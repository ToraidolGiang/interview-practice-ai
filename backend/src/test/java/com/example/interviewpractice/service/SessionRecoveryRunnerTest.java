package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;

class SessionRecoveryRunnerTest extends AbstractSessionApiTest {

    @Autowired
    private SessionRecoveryRunner runner;

    private PracticeSession processingSince(Instant startedAt) {
        PracticeSession s = newSession(owner, PracticeSession.Status.PROCESSING);
        jdbc.update("update practice_sessions set processing_started_at = ? where id = ?",
                Timestamp.from(startedAt), s.getId());
        return s;
    }

    private String errorOf(UUID id) {
        return jdbc.queryForObject("select error_code from practice_sessions where id = ?", String.class, id);
    }

    @Test
    void staleProcessingBecomesFailedServerRestart() {
        PracticeSession stale = processingSince(Instant.now().minus(1, ChronoUnit.HOURS));

        runner.recover();

        assertThat(statusOf(stale.getId())).isEqualTo("FAILED");
        assertThat(errorOf(stale.getId())).isEqualTo("SERVER_RESTART");
    }

    @Test
    void processingStartedAfterBootAndOtherStatusesAreUntouched() {
        PracticeSession fresh = processingSince(Instant.now().plus(1, ChronoUnit.MINUTES));
        PracticeSession uploaded = newSession(owner, PracticeSession.Status.UPLOADED);
        PracticeSession scored = newSession(owner, PracticeSession.Status.SCORED);
        PracticeSession failed = newSession(owner, PracticeSession.Status.FAILED);

        runner.recover();

        assertThat(statusOf(fresh.getId())).isEqualTo("PROCESSING");
        assertThat(statusOf(uploaded.getId())).isEqualTo("UPLOADED");
        assertThat(statusOf(scored.getId())).isEqualTo("SCORED");
        assertThat(statusOf(failed.getId())).isEqualTo("FAILED");
        assertThat(errorOf(failed.getId())).isNull();
    }
}
