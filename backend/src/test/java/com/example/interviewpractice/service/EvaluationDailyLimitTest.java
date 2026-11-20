package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.security.AuthUser;

/** F4: hết hạn mức chấm trong ngày thì /evaluate trả 429 DAILY_LIMIT_EXCEEDED; lượt của hôm trước không tính. */
class EvaluationDailyLimitTest extends AbstractSessionApiTest {

    private static final int LIMIT = 20;

    @Autowired
    private EvaluationService evaluation;

    @Test
    void userOverDailyLimitGetsTooManyRequestsAndSessionStaysUploaded() {
        for (int i = 0; i < LIMIT; i++) {
            markEvaluated(newSession(owner, PracticeSession.Status.FAILED), Instant.now());
        }
        PracticeSession waiting = newSession(owner, PracticeSession.Status.UPLOADED);

        assertThatThrownBy(() -> evaluation.submit(waiting.getId(), asOwner()))
                .isInstanceOfSatisfying(ApiException.class, e -> {
                    assertThat(e.getStatus()).isEqualTo(HttpStatus.TOO_MANY_REQUESTS);
                    assertThat(e.getCode()).isEqualTo("DAILY_LIMIT_EXCEEDED");
                });
        assertThat(statusOf(waiting.getId())).isEqualTo("UPLOADED");
    }

    @Test
    void evaluationsFromEarlierDaysDoNotCount() {
        for (int i = 0; i < LIMIT; i++) {
            markEvaluated(newSession(owner, PracticeSession.Status.FAILED),
                    Instant.now().minus(Duration.ofDays(2)).truncatedTo(ChronoUnit.SECONDS));
        }
        PracticeSession waiting = newSession(owner, PracticeSession.Status.UPLOADED);
        jdbc.update("update practice_sessions set audio_key = 'k', duration_sec = 30 where id = ?", waiting.getId());

        // Không bị chặn bởi hạn mức; worker nền chạy sau đó không ảnh hưởng kiểm tra này
        assertThat(evaluation.submit(waiting.getId(), asOwner()).status()).isEqualTo(PracticeSession.Status.PROCESSING);
    }

    @Test
    void manyAttemptsOnOneSessionCountIndividually() {
        PracticeSession one = newSession(owner, PracticeSession.Status.FAILED);
        for (int i = 0; i < LIMIT; i++) {
            markEvaluated(one, Instant.now());
        }
        PracticeSession waiting = newSession(owner, PracticeSession.Status.UPLOADED);

        assertThatThrownBy(() -> evaluation.submit(waiting.getId(), asOwner()))
                .isInstanceOfSatisfying(ApiException.class, e -> assertThat(e.getCode()).isEqualTo("DAILY_LIMIT_EXCEEDED"));
    }

    private AuthUser asOwner() {
        return new AuthUser(owner.getId(), owner.getEmail(), owner.getRole());
    }

    private void markEvaluated(PracticeSession s, Instant at) {
        jdbc.update("insert into evaluation_attempts (id, user_id, session_id, started_at) values (?, ?, ?, ?)",
                java.util.UUID.randomUUID(), owner.getId(), s.getId(), java.sql.Timestamp.from(at));
    }
}
