package com.example.interviewpractice.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.core.task.TaskExecutor;
import org.springframework.core.task.TaskRejectedException;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.entity.PracticeSession;

/** Hàng đợi chấm đầy: trả 503 và hoàn tác phiên về UPLOADED để gọi lại được. */
class PracticeSessionEvaluateQueueFullIntegrationTest extends AbstractSessionApiTest {

    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    @BeforeEach
    void queueIsFull() {
        doThrow(new TaskRejectedException("Hàng đợi đầy")).when(executor).execute(any());
    }

    @Test
    void rejectedExecutorRevertsToUploadedAndReturns503() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);

        mvc.perform(post("/practice-sessions/" + session.getId() + "/evaluate").header("Authorization", ownerToken))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.code").value("SERVICE_UNAVAILABLE"));

        assertThat(statusOf(session.getId())).isEqualTo("UPLOADED");
        assertThat(jdbc.queryForObject("select processing_started_at is null from practice_sessions where id = ?",
                Boolean.class, session.getId())).isTrue();
    }

    @Test
    void failedSessionRejectedByQueueGoesBackToUploadedNotProcessing() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.FAILED);

        mvc.perform(post("/practice-sessions/" + session.getId() + "/evaluate").header("Authorization", ownerToken))
                .andExpect(status().isServiceUnavailable());

        assertThat(statusOf(session.getId())).isEqualTo("UPLOADED");
    }
}
