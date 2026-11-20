package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.ai.LlmClient;
import com.example.interviewpractice.service.ai.LlmException;
import com.example.interviewpractice.service.ai.LlmRawResult;
import com.example.interviewpractice.service.ai.LlmRequest;
import com.example.interviewpractice.service.ai.SttClient;
import com.example.interviewpractice.service.ai.SttException;
import com.example.interviewpractice.service.storage.AudioStorageException;

/** Chạy trọn luồng STT -> LLM -> lưu với executor đồng bộ; STT/LLM/S3 đều là mock, không gọi dịch vụ thật. */
class EvaluationPipelineIntegrationTest extends AbstractSessionApiTest {

    private static final String VALID = """
            {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","sampleAnswer":"mau","criteria":[
             {"code":"RELEVANCE","reasoning":"r","quote":"nhóm","score":4},
             {"code":"STRUCTURE","reasoning":"r","quote":"nhóm","score":3},
             {"code":"DEPTH","reasoning":"r","quote":"nhóm","score":3}]}""";
    private static final String BAD_SCORE = VALID.replace("\"score\":4", "\"score\":9");

    @MockitoBean
    private SttClient stt;

    @MockitoBean
    private LlmClient llm;

    // Executor chạy việc ngay trên luồng gọi để test xác định, không cần chờ
    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    @Autowired
    private EvaluationService evaluation;

    private AuthUser user;
    private PracticeSession session;

    @BeforeEach
    void uploadedSession() {
        doAnswer(inv -> {
            ((Runnable) inv.getArgument(0)).run();
            return null;
        }).when(executor).execute(any());
        user = new AuthUser(owner.getId(), owner.getEmail(), owner.getRole());
        session = newSession(owner, PracticeSession.Status.UPLOADED);
        jdbc.update("update practice_sessions set audio_key = ?, duration_sec = 60 where id = ?",
                "audio/u/s/a.webm", session.getId());
        when(storage.get("audio/u/s/a.webm")).thenReturn(new byte[] {1, 2, 3});
    }

    private static String words(int n) {
        return "nhóm ".repeat(n).trim();
    }

    private Map<String, Object> row() {
        return jdbc.queryForMap("select status, error_code, total_score, completed_at from practice_sessions "
                + "where id = ?", session.getId());
    }

    private int resultCount() {
        return jdbc.queryForObject("select count(*) from score_results where session_id = ?", Integer.class,
                session.getId());
    }

    @Test
    void successScoresSessionWithTotalScoreAndCompletedAt() {
        when(stt.transcribe(eq(session.getId()), any(), eq("audio/webm"))).thenReturn(words(20));
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID));

        evaluation.submit(session.getId(), user);

        Map<String, Object> row = row();
        assertThat(row.get("status")).isEqualTo("SCORED");
        assertThat(row.get("total_score")).isNotNull();
        assertThat(row.get("completed_at")).isNotNull();
        assertThat(row.get("error_code")).isNull();
        assertThat(resultCount()).isEqualTo(1);
        verify(llm, times(1)).score(any());
    }

    @Test
    void sttFailureMarksFailedSttError() {
        when(stt.transcribe(any(), any(), anyString())).thenThrow(new SttException("loi"));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("FAILED");
        assertThat(row().get("error_code")).isEqualTo("STT_ERROR");
        verify(llm, never()).score(any());
    }

    @Test
    void audioReadFailureMarksFailedSttError() {
        when(storage.get(anyString())).thenThrow(new AudioStorageException("s3 loi", new RuntimeException()));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("error_code")).isEqualTo("STT_ERROR");
    }

    @Test
    void llmErrorTwiceMarksFailedLlmError() {
        when(stt.transcribe(any(), any(), anyString())).thenReturn(words(20));
        when(llm.score(any())).thenThrow(new LlmException(LlmException.LLM_ERROR, "timeout"));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("FAILED");
        assertThat(row().get("error_code")).isEqualTo("LLM_ERROR");
        verify(llm, times(2)).score(any(LlmRequest.class));
    }

    @Test
    void invalidResultTwiceMarksFailedInvalidResult() {
        when(stt.transcribe(any(), any(), anyString())).thenReturn(words(20));
        when(llm.score(any())).thenReturn(new LlmRawResult(BAD_SCORE));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("error_code")).isEqualTo("INVALID_RESULT");
        verify(llm, times(2)).score(any());
    }

    @Test
    void llmFailsOnceThenSucceedsStillScores() {
        when(stt.transcribe(any(), any(), anyString())).thenReturn(words(20));
        when(llm.score(any())).thenReturn(new LlmRawResult(BAD_SCORE)).thenReturn(new LlmRawResult(VALID));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("SCORED");
    }

    @Test
    void fourteenWordsFailsAnswerTooShortWithoutCallingLlm() {
        when(stt.transcribe(any(), any(), anyString())).thenReturn(words(14));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("FAILED");
        assertThat(row().get("error_code")).isEqualTo("ANSWER_TOO_SHORT");
        verify(llm, never()).score(any());
    }

    @Test
    void fifteenWordsIsScored() {
        when(stt.transcribe(any(), any(), anyString())).thenReturn(words(15));
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("SCORED");
        verify(llm, times(1)).score(any());
    }

    // AC-20: offTopic=true từ LLM phải làm tổng điểm lưu trong DB bị chặn <= 30 (end-to-end, không chỉ prompt)
    @Test
    void offTopicResultCapsStoredTotalScoreAt30() {
        when(stt.transcribe(any(), any(), anyString())).thenReturn(words(20));
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID.replace("\"offTopic\":false", "\"offTopic\":true")));

        evaluation.submit(session.getId(), user);

        Map<String, Object> row = row();
        assertThat(row.get("status")).isEqualTo("SCORED");
        assertThat(((Number) row.get("total_score")).doubleValue()).isLessThanOrEqualTo(30.0);
    }

    @Test
    void unexpectedErrorStillEndsFailedAndSessionCanBeEvaluatedAgain() {
        when(stt.transcribe(any(), any(), anyString())).thenThrow(new IllegalStateException("bat ngo"))
                .thenReturn(words(20));
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID));

        evaluation.submit(session.getId(), user);
        assertThat(row().get("status")).isEqualTo("FAILED");
        assertThat(row().get("error_code")).isEqualTo("INTERNAL_ERROR");

        evaluation.submit(session.getId(), user);
        assertThat(row().get("status")).isEqualTo("SCORED");
        assertThat(row().get("error_code")).isNull();
    }

    @Test
    void sessionFailedByRestartMidScoringIsNotOverwrittenAndLeavesNoResult() {
        UUID id = session.getId();
        when(stt.transcribe(any(), any(), anyString())).thenAnswer(inv -> {
            // Giả lập khởi động lại làm phiên bị đánh FAILED trong lúc worker đang chạy
            jdbc.update("update practice_sessions set status = 'FAILED', error_code = 'SERVER_RESTART' "
                    + "where id = ?", id);
            return words(20);
        });
        when(llm.score(any())).thenReturn(new LlmRawResult(VALID));

        evaluation.submit(id, user);

        assertThat(row().get("status")).isEqualTo("FAILED");
        assertThat(row().get("error_code")).isEqualTo("SERVER_RESTART");
        assertThat(resultCount()).isZero();
    }
}
