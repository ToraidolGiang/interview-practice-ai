package com.example.interviewpractice.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.core.task.TaskExecutor;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.entity.PracticeSession;

class PracticeSessionEvaluateIntegrationTest extends AbstractSessionApiTest {

    // Thay executor thật: chỉ ghi nhận việc được đưa vào, không chạy worker
    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    private String evaluate(UUID id) {
        return "/practice-sessions/" + id + "/evaluate";
    }

    @Test
    void uploadedSessionGets202ProcessingAndOneJob() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);

        mvc.perform(post(evaluate(session.getId())).header("Authorization", ownerToken))
                .andExpect(status().isAccepted())
                .andExpect(jsonPath("$.status").value("PROCESSING"));

        assertThat(statusOf(session.getId())).isEqualTo("PROCESSING");
        assertThat(jdbc.queryForObject("select processing_started_at is not null from practice_sessions where id = ?",
                Boolean.class, session.getId())).isTrue();
        verify(executor, times(1)).execute(any());
    }

    // AC-24: 202 trong <= 1 giây (worker bị mock nên chỉ đo phần đồng bộ của endpoint)
    @Test
    void evaluateRespondsWithin1Second() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);

        long start = System.nanoTime();
        mvc.perform(post(evaluate(session.getId())).header("Authorization", ownerToken))
                .andExpect(status().isAccepted());
        long ms = (System.nanoTime() - start) / 1_000_000;

        assertThat(ms).isLessThan(1000);
    }

    @Test
    void failedSessionCanBeEvaluatedAgainAndErrorCodeIsCleared() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.FAILED);
        jdbc.update("update practice_sessions set error_code = 'STT_ERROR' where id = ?", session.getId());

        mvc.perform(post(evaluate(session.getId())).header("Authorization", ownerToken))
                .andExpect(status().isAccepted())
                .andExpect(jsonPath("$.status").value("PROCESSING"));

        assertThat(jdbc.queryForObject("select error_code from practice_sessions where id = ?", String.class,
                session.getId())).isNull();
    }

    @Test
    void createdSessionWithoutAudioGets409() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);

        mvc.perform(post(evaluate(session.getId())).header("Authorization", ownerToken))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("SESSION_PROCESSING"));
        assertThat(statusOf(session.getId())).isEqualTo("CREATED");
    }

    @Test
    void processingSessionGets409AndNoSecondJob() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.PROCESSING);

        mvc.perform(post(evaluate(session.getId())).header("Authorization", ownerToken))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("SESSION_PROCESSING"));
        verify(executor, never()).execute(any());
    }

    @Test
    void scoredSessionGets409AlreadyScored() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.SCORED);

        mvc.perform(post(evaluate(session.getId())).header("Authorization", ownerToken))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("SESSION_ALREADY_SCORED"));
    }

    @Test
    void otherUsersSessionGets403AndStaysUploaded() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);

        mvc.perform(post(evaluate(session.getId())).header("Authorization", otherToken))
                .andExpect(status().isForbidden());
        assertThat(statusOf(session.getId())).isEqualTo("UPLOADED");
    }

    @Test
    void unknownSessionGets404() throws Exception {
        mvc.perform(post(evaluate(UUID.randomUUID())).header("Authorization", ownerToken))
                .andExpect(status().isNotFound());
    }

    @Test
    void withoutTokenIsRejected() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);

        mvc.perform(post(evaluate(session.getId()))).andExpect(status().isUnauthorized());
    }
}
