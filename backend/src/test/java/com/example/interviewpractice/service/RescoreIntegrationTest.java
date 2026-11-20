package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.core.task.TaskRejectedException;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.ai.LlmClient;
import com.example.interviewpractice.service.ai.LlmException;
import com.example.interviewpractice.service.ai.LlmRawResult;
import com.example.interviewpractice.service.ai.SttClient;

/** UC5 6a: chấm lại với transcript đã sửa, không gọi lại STT, ghi đè kết quả cũ. */
class RescoreIntegrationTest extends AbstractSessionApiTest {

    private static final String VALID = """
            {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","sampleAnswer":"mau","criteria":[
             {"code":"RELEVANCE","reasoning":"r","quote":"nhóm","score":4},
             {"code":"STRUCTURE","reasoning":"r","quote":"nhóm","score":3},
             {"code":"DEPTH","reasoning":"r","quote":"nhóm","score":3}]}""";

    @MockitoBean
    private SttClient stt;

    @MockitoBean
    private LlmClient llm;

    // Executor chạy việc ngay trên luồng gọi để test xác định
    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    @Autowired
    private EvaluationService evaluation;

    private AuthUser user;
    private PracticeSession session;

    @BeforeEach
    void scoredSession() {
        doAnswer(inv -> {
            ((Runnable) inv.getArgument(0)).run();
            return null;
        }).when(executor).execute(any());
        user = new AuthUser(owner.getId(), owner.getEmail(), owner.getRole());
        session = newSession(owner, PracticeSession.Status.UPLOADED);
        jdbc.update("update practice_sessions set audio_key = ?, duration_sec = 60 where id = ?",
                "audio/u/s/a.webm", session.getId());
        when(storage.get("audio/u/s/a.webm")).thenReturn(new byte[] {1, 2, 3});
        when(stt.transcribe(any(), any(), any())).thenReturn(words(20));
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID));
        evaluation.submit(session.getId(), user);
        assertThat(statusOf(session.getId())).isEqualTo("SCORED");
    }

    private static String words(int n) {
        return "nhóm ".repeat(n).trim();
    }

    private String transcript() {
        return jdbc.queryForObject("select transcript from score_results where session_id = ?", String.class,
                session.getId());
    }

    private int resultCount() {
        return jdbc.queryForObject("select count(*) from score_results where session_id = ?", Integer.class,
                session.getId());
    }

    private ApiException rescoreFails(String transcript) {
        return assertThrows(ApiException.class, () -> evaluation.rescore(session.getId(), user, transcript));
    }

    @Test
    void rescoreReplacesResultWithoutCallingSttAgain() {
        String edited = words(18) + " đã sửa";

        var response = evaluation.rescore(session.getId(), user, edited);

        assertThat(response.status()).isEqualTo(PracticeSession.Status.PROCESSING);
        assertThat(statusOf(session.getId())).isEqualTo("SCORED");
        assertThat(transcript()).isEqualTo(edited);
        assertThat(resultCount()).isEqualTo(1);
        verify(stt, times(1)).transcribe(any(), any(), any());
        verify(llm, times(2)).score(any());
    }

    @Test
    void transcriptUnder15WordsGets400AndKeepsSessionAndResult() {
        ApiException e = rescoreFails(words(14));

        assertThat(e.getStatus()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(e.getCode()).isEqualTo("ANSWER_TOO_SHORT");
        assertThat(statusOf(session.getId())).isEqualTo("SCORED");
        assertThat(transcript()).isEqualTo(words(20));
        verify(llm, times(1)).score(any());
    }

    @Test
    void neverScoredSessionGets409NotReady() {
        PracticeSession fresh = newSession(owner, PracticeSession.Status.UPLOADED);

        assertThatThrownBy(() -> evaluation.rescore(fresh.getId(), user, words(20)))
                .isInstanceOfSatisfying(ApiException.class, e -> {
                    assertThat(e.getStatus()).isEqualTo(HttpStatus.CONFLICT);
                    assertThat(e.getCode()).isEqualTo("SESSION_NOT_READY");
                });
        assertThat(statusOf(fresh.getId())).isEqualTo("UPLOADED");
    }

    @Test
    void processingSessionGets409Processing() {
        jdbc.update("update practice_sessions set status = 'PROCESSING' where id = ?", session.getId());

        ApiException e = rescoreFails(words(20));

        assertThat(e.getCode()).isEqualTo("SESSION_PROCESSING");
        assertThat(statusOf(session.getId())).isEqualTo("PROCESSING");
    }

    @Test
    void otherUsersSessionGets403() {
        AuthUser stranger = new AuthUser(other.getId(), other.getEmail(), other.getRole());

        assertThatThrownBy(() -> evaluation.rescore(session.getId(), stranger, words(20)))
                .isInstanceOfSatisfying(ApiException.class,
                        e -> assertThat(e.getStatus()).isEqualTo(HttpStatus.FORBIDDEN));
        verify(llm, times(1)).score(any());
    }

    @Test
    void llmFailureMarksFailedKeepsOldResultAndAllowsRescoreAgain() {
        when(llm.score(any())).thenThrow(new LlmException(LlmException.LLM_ERROR, "timeout"));

        evaluation.rescore(session.getId(), user, words(20) + " sửa");

        assertThat(statusOf(session.getId())).isEqualTo("FAILED");
        assertThat(resultCount()).isEqualTo(1);

        doReturn(new LlmRawResult(VALID)).when(llm).score(any());
        evaluation.rescore(session.getId(), user, words(21));
        assertThat(statusOf(session.getId())).isEqualTo("SCORED");
        assertThat(transcript()).isEqualTo(words(21));
    }

    @Test
    void fullQueueGets503AndRestoresScoredWithOldResult() {
        doThrow(new TaskRejectedException("đầy")).when(executor).execute(any());

        ApiException e = rescoreFails(words(20) + " sửa");

        assertThat(e.getStatus()).isEqualTo(HttpStatus.SERVICE_UNAVAILABLE);
        assertThat(statusOf(session.getId())).isEqualTo("SCORED");
        assertThat(jdbc.queryForObject("select total_score is not null from practice_sessions where id = ?",
                Boolean.class, session.getId())).isTrue();
        assertThat(transcript()).isEqualTo(words(20));
    }

    private int attemptCount() {
        return jdbc.queryForObject("select count(*) from evaluation_attempts where user_id = ?", Integer.class,
                owner.getId());
    }

    @Test
    void repeatedRescoresOnOneSessionHitDailyLimit() {
        // submit trong @BeforeEach đã tính 1 lượt; còn 19 lượt chấm lại trong hạn mức 20
        for (int i = 0; i < 19; i++) {
            evaluation.rescore(session.getId(), user, words(20) + " lan" + i);
        }
        assertThat(attemptCount()).isEqualTo(20);

        ApiException e = rescoreFails(words(20) + " them");

        assertThat(e.getStatus()).isEqualTo(HttpStatus.TOO_MANY_REQUESTS);
        assertThat(e.getCode()).isEqualTo("DAILY_LIMIT_EXCEEDED");
        verify(llm, times(20)).score(any());
    }

    @Test
    void rescoreRejectedByFullQueueDoesNotConsumeQuotaAndKeepsEarlierAttempts() {
        assertThat(attemptCount()).isEqualTo(1);
        doThrow(new TaskRejectedException("đầy")).when(executor).execute(any());

        assertThat(rescoreFails(words(20) + " sửa").getStatus()).isEqualTo(HttpStatus.SERVICE_UNAVAILABLE);

        assertThat(attemptCount()).isEqualTo(1);
    }
}
