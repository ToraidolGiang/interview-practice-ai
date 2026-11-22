package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.ai.KnowledgeErrorDetector;
import com.example.interviewpractice.service.ai.LlmClient;
import com.example.interviewpractice.service.ai.LlmException;
import com.example.interviewpractice.service.ai.LlmRawResult;
import com.example.interviewpractice.service.ai.SttClient;
import com.example.interviewpractice.service.scoring.KnowledgeError;

/**
 * Luồng chấm câu TECHNICAL có đáp án tham chiếu: đối chiếu theo ý chạy cùng lượt chấm chính, lượt kiểm lỗi kiến thức
 * chạy song song và trừ điểm CORRECTNESS. STT/LLM/kiểm lỗi/S3 đều là mock.
 */
class KnowledgeCheckPipelineTest extends AbstractSessionApiTest {

    private static final String TRANSCRIPT = "Độ sâu tối đa giới hạn số tầng của cây. Số mẫu tối thiểu để chia nút "
            + "là số mẫu ít nhất phải nằm ở mỗi nút lá sau khi chia. Gini hoặc entropy đo độ hỗn tạp";

    private static final String LLM_JSON = """
            {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
             {"code":"RELEVANCE","reasoning":"r","quote":"độ sâu tối đa","score":4},
             {"code":"STRUCTURE","reasoning":"r","quote":"độ sâu tối đa","score":4},
             {"code":"DEPTH","reasoning":"r","quote":"độ sâu tối đa","score":4},
             {"code":"CORRECTNESS","reasoning":"r","quote":"độ sâu tối đa","score":5}],
             "points":[
              {"index":1,"verdict":"COVERED","quote":"Độ sâu tối đa giới hạn số tầng của cây","note":"đủ"},
              {"index":2,"verdict":"COVERED","quote":"Số mẫu tối thiểu để chia nút","note":"đủ"},
              {"index":3,"verdict":"COVERED","quote":"Gini hoặc entropy","note":"đủ"},
              {"index":4,"verdict":"COVERED","quote":"Gini hoặc entropy đo độ hỗn tạp","note":"đủ"}]}""";

    @MockitoBean
    private SttClient stt;

    @MockitoBean
    private LlmClient llm;

    @MockitoBean
    private KnowledgeErrorDetector detector;

    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    @Autowired
    private EvaluationService evaluation;

    private AuthUser user;
    private PracticeSession session;

    @BeforeEach
    void technicalSession() {
        doAnswer(inv -> {
            ((Runnable) inv.getArgument(0)).run();
            return null;
        }).when(executor).execute(any());
        user = new AuthUser(owner.getId(), owner.getEmail(), owner.getRole());
        jdbc.update("update questions set question_type = 'TECHNICAL', reference_answer = ? where id = ?",
                "- Độ sâu tối đa của cây\n- Số mẫu tối thiểu để chia nút và ở lá\n- Tiêu chí Gini hoặc entropy\n"
                        + "- Đo độ hỗn tạp của nút",
                activeQuestion.getId());
        session = newSession(owner, PracticeSession.Status.UPLOADED);
        jdbc.update("update practice_sessions set audio_key = ?, duration_sec = 60 where id = ?",
                "audio/u/s/a.webm", session.getId());
        when(storage.get("audio/u/s/a.webm")).thenReturn(new byte[] {1, 2, 3});
        when(stt.transcribe(eq(session.getId()), any(), eq("audio/webm"))).thenReturn(TRANSCRIPT);
        when(llm.score(any())).thenReturn(new LlmRawResult(LLM_JSON));
    }

    private Map<String, Object> row() {
        return jdbc.queryForMap("select status, error_code from practice_sessions where id = ?", session.getId());
    }

    private int correctnessScore() {
        return jdbc.queryForObject("""
                select c.score from score_criteria c join score_results r on r.id = c.result_id
                where r.session_id = ? and c.code = 'CORRECTNESS'""", Integer.class, session.getId());
    }

    private List<String> savedErrors() {
        return jdbc.queryForList("""
                select e.position || ':' || e.quote from score_errors e join score_results r on r.id = e.result_id
                where r.session_id = ? order by e.position""", String.class, session.getId());
    }

    @Test
    void khongCoLoiKienThucThiCorrectnessTinhTuCacYVaKhongLuuLoi() {
        when(detector.detect(any(), anyString(), anyList(), anyString())).thenReturn(List.of());

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("SCORED");
        assertThat(correctnessScore()).isEqualTo(5); // 4/4 ý đủ
        assertThat(savedErrors()).isEmpty();
    }

    @Test
    void loiKienThucCoTrichDanThatBiTruDiemVaDuocLuu() {
        when(detector.detect(any(), anyString(), anyList(), anyString())).thenReturn(List.of(
                new KnowledgeError(1, "Số mẫu tối thiểu để chia nút là số mẫu ít nhất phải nằm ở mỗi nút lá",
                        "min_samples_split khác min_samples_leaf"),
                new KnowledgeError(2, "Gini hoặc entropy đo độ hỗn tạp", "giải thích khác")));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("SCORED");
        // 4 ý đủ = 4, trừ 2·0,5 -> 3/4 = 0,75 -> 1 + round(3) = 4
        assertThat(correctnessScore()).isEqualTo(4);
        assertThat(savedErrors()).hasSize(2).first().asString().startsWith("1:Số mẫu tối thiểu");
    }

    @Test
    void nhieuLoiLamGiamDiemCorrectnessRoRet() {
        when(detector.detect(any(), anyString(), anyList(), anyString())).thenReturn(List.of(
                new KnowledgeError(1, "Độ sâu tối đa giới hạn số tầng của cây", "sai 1"),
                new KnowledgeError(2, "Số mẫu tối thiểu để chia nút", "sai 2"),
                new KnowledgeError(3, "Gini hoặc entropy", "sai 3"),
                new KnowledgeError(4, "đo độ hỗn tạp", "sai 4")));

        evaluation.submit(session.getId(), user);

        // 4 ý đủ trừ 4·0,5 = 2 -> 2/4 = 0,5 -> 3
        assertThat(correctnessScore()).isEqualTo(3);
        assertThat(savedErrors()).hasSize(4);
    }

    @Test
    void loiCoTrichDanBiaKhongBiTruDiemVaKhongDuocLuu() {
        when(detector.detect(any(), anyString(), anyList(), anyString())).thenReturn(List.of(
                new KnowledgeError(1, "câu này thí sinh không hề nói", "sai")));

        evaluation.submit(session.getId(), user);

        assertThat(correctnessScore()).isEqualTo(5);
        assertThat(savedErrors()).isEmpty();
    }

    @Test
    void luotKiemLoiThatBaiKhongLamHongPhienCham() {
        when(detector.detect(any(), anyString(), anyList(), anyString()))
                .thenThrow(new LlmException(LlmException.LLM_ERROR, "gemini 503"));

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("SCORED");
        assertThat(correctnessScore()).isEqualTo(5);
        assertThat(savedErrors()).isEmpty();
    }

    @Test
    void cauKhongCoDapAnThamChieuThiKhongGoiKiemLoi() {
        jdbc.update("update questions set reference_answer = null where id = ?", activeQuestion.getId());

        evaluation.submit(session.getId(), user);

        assertThat(row().get("status")).isEqualTo("SCORED");
        verify(detector, never()).detect(any(), anyString(), anyList(), anyString());
    }
}
