package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

import java.time.Duration;
import java.time.Instant;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.ai.LlmClient;
import com.example.interviewpractice.service.ai.LlmRawResult;
import com.example.interviewpractice.service.ai.SttClient;

/** Dùng executor thật (scoringExecutor): /evaluate trả ngay PROCESSING, rồi polling tới SCORED (AC-24, AC-26). */
class EvaluationAsyncIntegrationTest extends AbstractSessionApiTest {

    private static final String VALID = """
            {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","sampleAnswer":"mau","criteria":[
             {"code":"RELEVANCE","reasoning":"r","quote":"nhóm","score":4},
             {"code":"STRUCTURE","reasoning":"r","quote":"nhóm","score":3},
             {"code":"DEPTH","reasoning":"r","quote":"nhóm","score":3}]}""";

    @MockitoBean
    private SttClient stt;

    @MockitoBean
    private LlmClient llm;

    @Autowired
    private EvaluationService evaluation;

    @Test
    void realExecutorEventuallyScoresSession() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);
        jdbc.update("update practice_sessions set audio_key = ?, duration_sec = 60 where id = ?",
                "audio/u/s/a.mp3", session.getId());
        when(storage.get(anyString())).thenReturn(new byte[] {1});
        when(stt.transcribe(any(), any(), anyString())).thenReturn("nhóm ".repeat(20).trim());
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID));

        var response = evaluation.submit(session.getId(), new AuthUser(owner.getId(), owner.getEmail(), owner.getRole()));
        assertThat(response.status()).isEqualTo(PracticeSession.Status.PROCESSING);

        Instant deadline = Instant.now().plus(Duration.ofSeconds(15));
        String status = statusOf(session.getId());
        while (!"SCORED".equals(status) && Instant.now().isBefore(deadline)) {
            Thread.sleep(50);
            status = statusOf(session.getId());
        }
        assertThat(status).isEqualTo("SCORED");
    }
}
