package com.example.interviewpractice.service;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.interviewpractice.repository.PracticeSessionRepository;

/**
 * Khi ứng dụng khởi động xong, đánh FAILED (SERVER_RESTART) các phiên còn PROCESSING từ lần chạy trước: việc chấm
 * nằm trong bộ nhớ nên đã mất theo tiến trình cũ và phiên sẽ không bao giờ tự kết thúc.
 */
@Component
public class SessionRecoveryRunner {

    private static final Logger log = LoggerFactory.getLogger(SessionRecoveryRunner.class);

    private final PracticeSessionRepository sessions;
    private final Clock clock;
    // Mốc khởi động lấy khi bean được tạo, trước mọi request nên phiên chấm sau mốc này không bị đánh nhầm
    private final Instant bootTime;

    private final Duration processingTimeout;

    public SessionRecoveryRunner(PracticeSessionRepository sessions, Clock clock,
            @Value("${app.scoring.processing-timeout-seconds}") long processingTimeoutSeconds) {
        this.sessions = sessions;
        this.clock = clock;
        this.processingTimeout = Duration.ofSeconds(processingTimeoutSeconds);
        this.bootTime = clock.instant();
    }

    @EventListener(ApplicationReadyEvent.class)
    public void recover() {
        int failed = sessions.failStaleProcessing(bootTime, clock.instant());
        if (failed > 0) {
            log.warn("Đã đánh FAILED SERVER_RESTART cho {} phiên đang chấm dở", failed);
        }
    }

    /**
     * Quét định kỳ phiên PROCESSING quá hạn (F3). Khác recover(): chạy khi ứng dụng vẫn sống, cứu phiên kẹt do
     * ghi trạng thái lỗi thất bại. Hạn phải dài hơn thời gian chấm tối đa (timeout STT + LLM + thử lại).
     */
    @Scheduled(fixedDelayString = "${app.scoring.sweep-interval-ms}", initialDelayString = "${app.scoring.sweep-interval-ms}")
    public void sweepTimedOut() {
        Instant now = clock.instant();
        int failed = sessions.failTimedOutProcessing(now.minus(processingTimeout), now);
        if (failed > 0) {
            log.warn("Đã đánh FAILED PROCESSING_TIMEOUT cho {} phiên kẹt quá {}", failed, processingTimeout);
        }
    }
}
