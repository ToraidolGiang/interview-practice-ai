package com.example.interviewpractice.service;

import java.time.Clock;
import java.time.Instant;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
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

    public SessionRecoveryRunner(PracticeSessionRepository sessions, Clock clock) {
        this.sessions = sessions;
        this.clock = clock;
        this.bootTime = clock.instant();
    }

    @EventListener(ApplicationReadyEvent.class)
    public void recover() {
        int failed = sessions.failStaleProcessing(bootTime, clock.instant());
        if (failed > 0) {
            log.warn("Đã đánh FAILED SERVER_RESTART cho {} phiên đang chấm dở", failed);
        }
    }
}
