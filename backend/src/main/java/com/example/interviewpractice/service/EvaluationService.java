package com.example.interviewpractice.service;

import java.time.Clock;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
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

    public EvaluationService(PracticeSessionRepository sessions, SessionAccess access, ScoringPipeline pipeline,
            @Qualifier("scoringExecutor") TaskExecutor executor, Clock clock) {
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
     *                      409 SESSION_ALREADY_SCORED; 503 khi hàng đợi chấm đầy (trạng thái đã hoàn tác UPLOADED)
     */
    public PracticeSessionResponse submit(UUID sessionId, AuthUser user) {
        access.requireOwned(sessionId, user);
        if (sessions.markProcessing(sessionId, clock.instant()) == 0) {
            throw conflictFor(sessionId);
        }
        // Chụp phản hồi ngay sau khi chiếm quyền chấm, trước khi worker kịp đổi trạng thái
        PracticeSessionResponse response = PracticeSessionResponse.from(access.requireOwned(sessionId, user));
        try {
            executor.execute(() -> pipeline.run(sessionId));
        } catch (TaskRejectedException e) {
            // Hàng đợi đầy: trả phiên về UPLOADED để người dùng gọi lại được, không để treo PROCESSING
            sessions.revertToUploaded(sessionId);
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
