package com.example.interviewpractice.service;

import java.time.Clock;
import java.time.ZoneId;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.task.TaskExecutor;
import org.springframework.core.task.TaskRejectedException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.example.interviewpractice.dto.PracticeSessionResponse;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.security.AuthUser;

/**
 * Nhận yêu cầu chấm (UC4): giành quyền chấm bằng một UPDATE có điều kiện rồi đưa việc vào executor nền.
 * Cố ý không có @Transactional để mỗi bước đổi trạng thái là một transaction ngắn, độc lập với việc submit.
 */
@Service
public class EvaluationService {

    private static final Logger log = LoggerFactory.getLogger(EvaluationService.class);

    private final PracticeSessionRepository sessions;
    private final SessionAccess access;
    private final ScoringPipeline pipeline;
    private final TaskExecutor executor;
    private final Clock clock;
    private final int maxProcessingPerUser;
    private final int maxEvaluationsPerDay;
    private final ZoneId dayZone;

    public EvaluationService(PracticeSessionRepository sessions, SessionAccess access, ScoringPipeline pipeline,
            @Qualifier("scoringExecutor") TaskExecutor executor, Clock clock,
            @Value("${app.scoring.max-processing-per-user}") int maxProcessingPerUser,
            @Value("${app.scoring.max-evaluations-per-day}") int maxEvaluationsPerDay,
            @Value("${app.scoring.day-zone}") String dayZone) {
        this.maxProcessingPerUser = maxProcessingPerUser;
        this.maxEvaluationsPerDay = maxEvaluationsPerDay;
        this.dayZone = ZoneId.of(dayZone);
        this.sessions = sessions;
        this.access = access;
        this.pipeline = pipeline;
        this.executor = executor;
        this.clock = clock;
    }

    /**
     * Đưa phiên vào hàng đợi chấm và trả phiên ở trạng thái PROCESSING.
     *
     * @throws ApiException 403/404 theo quyền sở hữu; 409 SESSION_PROCESSING (đang chấm hoặc chưa có audio),
     *                      409 SESSION_ALREADY_SCORED; 429 TOO_MANY_PROCESSING khi user đang có quá nhiều phiên chấm; 503 khi hàng đợi chấm đầy (trạng thái đã hoàn tác UPLOADED)
     */
    public PracticeSessionResponse submit(UUID sessionId, AuthUser user) {
        access.requireOwned(sessionId, user);
        enforceLimits(user);
        if (sessions.markProcessing(sessionId, clock.instant()) == 0) {
            throw conflictFor(sessionId);
        }
        UUID attemptId = recordAttempt(sessionId, user);
        return enqueue(sessionId, user, () -> pipeline.run(sessionId), () -> {
            sessions.revertToUploaded(sessionId);
            sessions.deleteAttempt(attemptId);
        });
    }

    /**
     * Chấm lại với transcript người dùng đã sửa (UC5 6a), không gọi lại STT. Kiểm tra quyền sở hữu rồi độ dài
     * transcript trước khi đụng tới trạng thái phiên.
     *
     * @throws ApiException 400 ANSWER_TOO_SHORT khi transcript dưới 15 từ; 403/404 theo quyền sở hữu;
     *                      409 SESSION_PROCESSING (đang chấm), 409 SESSION_NOT_READY (chưa từng được chấm);
     *                      429 như {@link #submit}; 503 khi hàng đợi đầy (phiên hoàn tác về SCORED, kết quả cũ còn nguyên)
     */
    public PracticeSessionResponse rescore(UUID sessionId, AuthUser user, String transcript) {
        access.requireOwned(sessionId, user);
        String text = transcript == null ? "" : transcript.strip();
        if (ScoringPipeline.wordCount(text) < ScoringPipeline.MIN_WORDS) {
            throw new ApiException(HttpStatus.BAD_REQUEST, ScoringPipeline.ANSWER_TOO_SHORT,
                    "Transcript phải có ít nhất " + ScoringPipeline.MIN_WORDS + " từ");
        }
        enforceLimits(user);
        if (sessions.markRescoring(sessionId, clock.instant()) == 0) {
            PracticeSession.Status status = sessions.findById(sessionId).map(PracticeSession::getStatus).orElse(null);
            if (status == PracticeSession.Status.PROCESSING) {
                throw new ApiException(HttpStatus.CONFLICT, "SESSION_PROCESSING", "Phiên đang được xử lý");
            }
            throw new ApiException(HttpStatus.CONFLICT, "SESSION_NOT_READY", "Phiên chưa từng được chấm điểm");
        }
        UUID attemptId = recordAttempt(sessionId, user);
        return enqueue(sessionId, user, () -> pipeline.rescore(sessionId, text), () -> {
            sessions.revertToScored(sessionId, clock.instant());
            sessions.deleteAttempt(attemptId);
        });
    }

    private void enforceLimits(AuthUser user) {
        // Giới hạn mềm (F4): kiểm tra rồi mới giành quyền nên có thể vượt 1-2 phiên khi request đồng thời,
        // đủ để một user không lấp đầy hàng đợi chung; không cần khóa vì mục tiêu là chặn lạm dụng, không phải đếm chính xác
        if (sessions.countProcessingByUser(user.id()) >= maxProcessingPerUser) {
            throw new ApiException(HttpStatus.TOO_MANY_REQUESTS, "TOO_MANY_PROCESSING",
                    "Bạn đang có quá nhiều phiên đang chấm, vui lòng đợi một phiên xong rồi thử lại");
        }
        // Hạn mức theo ngày (F4): bảo vệ chi phí Gemini; đếm số lượt chấm thật (evaluate, retry, rescore) theo ngày
        // lịch của múi giờ cấu hình, mỗi lượt một đơn vị dù bên trong có thử lại nhiều lần gọi HTTP
        if (sessions.countAttemptsSince(user.id(), clock.instant().atZone(dayZone).toLocalDate()
                .atStartOfDay(dayZone).toInstant()) >= maxEvaluationsPerDay) {
            throw new ApiException(HttpStatus.TOO_MANY_REQUESTS, "DAILY_LIMIT_EXCEEDED",
                    "Bạn đã dùng hết " + maxEvaluationsPerDay + " lượt chấm hôm nay, vui lòng quay lại vào ngày mai");
        }
    }

    /** Ghi một lượt chấm vào hạn mức ngày; gọi ngay sau khi giành được quyền chấm. */
    private UUID recordAttempt(UUID sessionId, AuthUser user) {
        UUID attemptId = UUID.randomUUID();
        sessions.recordAttempt(attemptId, user.id(), sessionId, clock.instant());
        return attemptId;
    }

    /** Đưa việc vào executor sau khi đã giành quyền chấm; hàng đợi đầy thì chạy {@code revert} rồi trả 503. */
    private PracticeSessionResponse enqueue(UUID sessionId, AuthUser user, Runnable job, Runnable revert) {
        // Chụp phản hồi ngay sau khi chiếm quyền chấm, trước khi worker kịp đổi trạng thái
        PracticeSessionResponse response = PracticeSessionResponse.from(access.requireOwned(sessionId, user));
        try {
            executor.execute(job);
        } catch (TaskRejectedException e) {
            // Hàng đợi đầy: hoàn tác để người dùng gọi lại được, không để treo PROCESSING
            revert.run();
            log.warn("Hàng đợi chấm đầy, đã hoàn tác sessionId={}", sessionId);
            throw new ApiException(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE",
                    "Hệ thống chấm điểm đang bận, vui lòng thử lại sau");
        }
        return response;
    }

    private ApiException conflictFor(UUID sessionId) {
        PracticeSession.Status status = sessions.findById(sessionId).map(PracticeSession::getStatus).orElse(null);
        if (status == PracticeSession.Status.SCORED) {
            return new ApiException(HttpStatus.CONFLICT, "SESSION_ALREADY_SCORED", "Phiên đã được chấm điểm");
        }
        if (status == PracticeSession.Status.CREATED) {
            return new ApiException(HttpStatus.CONFLICT, "SESSION_PROCESSING",
                    "Phiên chưa có audio câu trả lời để chấm");
        }
        return new ApiException(HttpStatus.CONFLICT, "SESSION_PROCESSING", "Phiên đang được xử lý");
    }
}
