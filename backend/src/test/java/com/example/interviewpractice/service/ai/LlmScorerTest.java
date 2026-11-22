package com.example.interviewpractice.service.ai;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScorePoint.Verdict;
import com.example.interviewpractice.service.scoring.CorrectnessCalculator;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.KnowledgeError;
import com.example.interviewpractice.service.scoring.PointScore;
import com.example.interviewpractice.service.scoring.QuoteValidator;

import tools.jackson.databind.json.JsonMapper;

class LlmScorerTest {

    private static final String VALID = """
            {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
             {"code":"RELEVANCE","reasoning":"r","quote":"q","score":4},
             {"code":"STRUCTURE","reasoning":"r","quote":"q","score":3},
             {"code":"DEPTH","reasoning":"r","quote":"q","score":3}]}""";
    private static final String BAD_SCORE = VALID.replace("\"score\":4", "\"score\":9");

    private static final String TRANSCRIPT = "tôi đã q và nhóm bị trễ tiến độ hai tuần";

    private final LlmClient client = mock(LlmClient.class);
    private final LlmScorer scorer = new LlmScorer(client, new LlmResultValidator(new JsonMapper()), new QuoteValidator(),
            new CorrectnessCalculator());
    private final LlmRequest request = new LlmRequest(UUID.randomUUID(), Question.Type.BEHAVIORAL, "s", "u");

    @Test
    void thanhCongLanDauChiGoiMotLan() {
        when(client.score(request)).thenReturn(new LlmRawResult(VALID));

        LlmResult result = scorer.score(request, TRANSCRIPT);

        assertThat(result.criteria()).hasSize(3);
        verify(client, times(1)).score(request);
    }

    @Test
    void loiGoiRoiThanhCongThiGoiDungHaiLan() {
        when(client.score(request)).thenThrow(new LlmException(LlmException.LLM_ERROR, "timeout"))
                .thenReturn(new LlmRawResult(VALID));

        assertThat(scorer.score(request, TRANSCRIPT).criteria()).hasSize(3);
        verify(client, times(2)).score(request);
    }

    @Test
    void saiSchemaRoiThanhCongThiGoiDungHaiLan() {
        when(client.score(request)).thenReturn(new LlmRawResult(BAD_SCORE)).thenReturn(new LlmRawResult(VALID));

        assertThat(scorer.score(request, TRANSCRIPT).criteria()).hasSize(3);
        verify(client, times(2)).score(request);
    }

    @Test
    void saiSchemaHaiLanThiInvalidResultVaKhongGoiLanBa() {
        when(client.score(request)).thenReturn(new LlmRawResult(BAD_SCORE));

        assertThatThrownBy(() -> scorer.score(request, TRANSCRIPT)).isInstanceOfSatisfying(LlmException.class,
                e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.INVALID_RESULT));
        verify(client, times(2)).score(request);
    }

    @Test
    void loiGoiHaiLanThiLlmErrorVaKhongGoiLanBa() {
        when(client.score(request)).thenThrow(new LlmException(LlmException.LLM_ERROR, "lỗi"));

        assertThatThrownBy(() -> scorer.score(request, TRANSCRIPT)).isInstanceOfSatisfying(LlmException.class,
                e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.LLM_ERROR));
        verify(client, times(2)).score(request);
    }

    @Test
    void loiRuntimeBatNgoBiBocThanhLlmError() {
        when(client.score(request)).thenThrow(new IllegalStateException("bất ngờ"));

        assertThatThrownBy(() -> scorer.score(request, TRANSCRIPT)).isInstanceOfSatisfying(LlmException.class,
                e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.LLM_ERROR));
        verify(client, times(2)).score(request);
    }

    // Ba tiêu chí điểm 4/3/3 với quote theo thứ tự; "q" có trong TRANSCRIPT, "bịa" thì không
    private static String withQuotes(String q1, String q2, String q3) {
        return """
                {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
                 {"code":"RELEVANCE","reasoning":"r","quote":"%s","score":4},
                 {"code":"STRUCTURE","reasoning":"r","quote":"%s","score":3},
                 {"code":"DEPTH","reasoning":"r","quote":"%s","score":3}]}""".formatted(q1, q2, q3);
    }

    @Test
    void motTrenBaQuoteSaiKhongRetryVaTieuChiBiHaVeHai() {
        when(client.score(request)).thenReturn(new LlmRawResult(withQuotes("q", "q", "bịa đặt")));

        LlmResult result = scorer.score(request, TRANSCRIPT);

        verify(client, times(1)).score(request);
        CriterionScore depth = result.criteria().get(2);
        assertThat(depth.score()).isEqualTo(2);
        assertThat(depth.quoteInvalid()).isTrue();
        assertThat(result.criteria().get(0).score()).isEqualTo(4);
        assertThat(result.criteria().get(0).quoteInvalid()).isFalse();
    }

    @Test
    void quaNuaQuoteSaiRetryDungMotLanRoiThanhCong() {
        when(client.score(request)).thenReturn(new LlmRawResult(withQuotes("q", "bịa 1", "bịa 2")))
                .thenReturn(new LlmRawResult(VALID));

        LlmResult result = scorer.score(request, TRANSCRIPT);

        verify(client, times(2)).score(request);
        assertThat(result.criteria()).noneMatch(CriterionScore::quoteInvalid);
    }

    @Test
    void quaNuaQuoteSaiHaiLanThiInvalidResultVaKhongGoiLanBa() {
        when(client.score(request)).thenReturn(new LlmRawResult(withQuotes("q", "bịa 1", "bịa 2")));

        assertThatThrownBy(() -> scorer.score(request, TRANSCRIPT)).isInstanceOfSatisfying(LlmException.class,
                e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.INVALID_RESULT));
        verify(client, times(2)).score(request);
    }

    @Test
    void dungMotNuaQuoteSaiBonTieuChiKhongRetry() {
        LlmRequest technical = new LlmRequest(UUID.randomUUID(), Question.Type.TECHNICAL, "s", "u");
        String json = """
                {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
                 {"code":"RELEVANCE","reasoning":"r","quote":"q","score":4},
                 {"code":"STRUCTURE","reasoning":"r","quote":"q","score":4},
                 {"code":"DEPTH","reasoning":"r","quote":"bịa","score":4},
                 {"code":"CORRECTNESS","reasoning":"r","quote":"bịa","score":5}]}""";
        when(client.score(technical)).thenReturn(new LlmRawResult(json));

        LlmResult result = scorer.score(technical, TRANSCRIPT);

        verify(client, times(1)).score(technical);
        assertThat(result.criteria()).filteredOn(CriterionScore::quoteInvalid).hasSize(2)
                .allMatch(c -> c.score() == 2);
    }

    // ---- Đối chiếu theo ý của đáp án tham chiếu ----

    private static final String TECH_TRANSCRIPT = "độ sâu tối đa giới hạn số tầng và số mẫu tối thiểu để chia nút";
    private static final List<String> REF = List.of("Độ sâu tối đa của cây", "Số mẫu tối thiểu để chia nút",
            "Số đặc trưng tối đa khi chia");

    private LlmRequest technicalWithPoints() {
        return new LlmRequest(UUID.randomUUID(), Question.Type.TECHNICAL, "s", "u", REF);
    }

    private static String technicalJson(String correctnessScore, String points) {
        return """
                {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
                 {"code":"RELEVANCE","reasoning":"r","quote":"độ sâu tối đa","score":4},
                 {"code":"STRUCTURE","reasoning":"r","quote":"độ sâu tối đa","score":4},
                 {"code":"DEPTH","reasoning":"r","quote":"độ sâu tối đa","score":4},
                 {"code":"CORRECTNESS","reasoning":"r","quote":"bịa","score":%s}],
                 "points":[%s]}""".formatted(correctnessScore, points);
    }

    @Test
    void diemCorrectnessDoServerTinhTuCacYKhongLayDiemLlm() {
        LlmRequest technical = technicalWithPoints();
        // LLM tự cho 5 nhưng chỉ nêu được 2/3 ý: server tính lại = 1 + round(4·2/3) = 4
        String json = technicalJson("5", """
                {"index":1,"verdict":"COVERED","quote":"độ sâu tối đa","note":"n"},
                {"index":2,"verdict":"COVERED","quote":"số mẫu tối thiểu để chia nút","note":"n"},
                {"index":3,"verdict":"MISSING","quote":null,"note":"không nêu"}""");
        when(client.score(technical)).thenReturn(new LlmRawResult(json));

        LlmResult result = scorer.score(technical, TECH_TRANSCRIPT);

        CriterionScore correctness = result.criteria().stream()
                .filter(c -> c.code().name().equals("CORRECTNESS")).findFirst().orElseThrow();
        assertThat(correctness.score()).isEqualTo(4);
        assertThat(correctness.quoteInvalid()).isFalse();
        assertThat(result.points()).extracting(PointScore::verdict)
                .containsExactly(Verdict.COVERED, Verdict.COVERED, Verdict.MISSING);
        assertThat(result.points()).extracting(PointScore::pointText).containsExactlyElementsOf(REF);
        verify(client, times(1)).score(technical);
    }

    @Test
    void yDuocKhenMaTrichDanBiaBiHaMotBac() {
        LlmRequest technical = technicalWithPoints();
        String json = technicalJson("5", """
                {"index":1,"verdict":"COVERED","quote":"độ sâu tối đa","note":"n"},
                {"index":2,"verdict":"COVERED","quote":"câu bịa hoàn toàn khác","note":"n"},
                {"index":3,"verdict":"PARTIAL","quote":"cũng bịa nốt","note":"n"}""");
        when(client.score(technical)).thenReturn(new LlmRawResult(json));

        LlmResult result = scorer.score(technical, TECH_TRANSCRIPT);

        assertThat(result.points()).extracting(PointScore::verdict)
                .containsExactly(Verdict.COVERED, Verdict.PARTIAL, Verdict.MISSING);
        assertThat(result.points()).extracting(PointScore::quoteInvalid).containsExactly(false, true, true);
    }

    @Test
    void thieuYTrongPointsThiThuLaiRoiBaoInvalidResult() {
        LlmRequest technical = technicalWithPoints();
        // chỉ có 1 phần tử trong khi đáp án tham chiếu có 3 ý
        String json = technicalJson("4",
                "{\"index\":1,\"verdict\":\"COVERED\",\"quote\":\"độ sâu tối đa\",\"note\":\"n\"}");
        when(client.score(technical)).thenReturn(new LlmRawResult(json));

        assertThatThrownBy(() -> scorer.score(technical, TECH_TRANSCRIPT)).isInstanceOfSatisfying(LlmException.class,
                e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.INVALID_RESULT));
        verify(client, times(2)).score(technical);
    }

    @Test
    void keepSupportedChiGiuLoiCoTrichDanThatVaDanhSoLai() {
        List<KnowledgeError> kept = scorer.keepSupported(List.of(
                new KnowledgeError(1, "câu bịa", "e1"),
                new KnowledgeError(2, "độ sâu tối đa", "e2"),
                new KnowledgeError(3, "", "e3")), TECH_TRANSCRIPT);

        assertThat(kept).extracting(KnowledgeError::position, KnowledgeError::explanation)
                .containsExactly(org.assertj.core.groups.Tuple.tuple(1, "e2"));
    }

    @Test
    void penalizeTruDiemCorrectnessTheoSoLoiVaGiuNguyenKhiKhongCoLoi() {
        LlmRequest technical = technicalWithPoints();
        String json = technicalJson("5", """
                {"index":1,"verdict":"COVERED","quote":"độ sâu tối đa","note":"n"},
                {"index":2,"verdict":"COVERED","quote":"số mẫu tối thiểu để chia nút","note":"n"},
                {"index":3,"verdict":"COVERED","quote":"độ sâu tối đa","note":"n"}""");
        when(client.score(technical)).thenReturn(new LlmRawResult(json));
        LlmResult base = scorer.score(technical, TECH_TRANSCRIPT);

        assertThat(scorer.penalize(base, List.of())).isSameAs(base);
        // 3 ý đủ trừ 2·0,5 -> 2/3 -> 1 + round(2,67) = 4
        LlmResult penalized = scorer.penalize(base,
                List.of(new KnowledgeError(1, "x", "e"), new KnowledgeError(2, "y", "e")));
        assertThat(penalized.criteria()).filteredOn(c -> c.code().name().equals("CORRECTNESS"))
                .extracting(CriterionScore::score).containsExactly(4);
        assertThat(penalized.points()).isEqualTo(base.points());
    }

    @Test
    void penalizeKhongTruKhiKhongCoYDoiChieu() {
        LlmRequest technical = new LlmRequest(UUID.randomUUID(), Question.Type.TECHNICAL, "s", "u");
        String json = """
                {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
                 {"code":"RELEVANCE","reasoning":"r","quote":"q","score":4},
                 {"code":"STRUCTURE","reasoning":"r","quote":"q","score":4},
                 {"code":"DEPTH","reasoning":"r","quote":"q","score":4},
                 {"code":"CORRECTNESS","reasoning":"r","quote":"q","score":5}]}""";
        when(client.score(technical)).thenReturn(new LlmRawResult(json));
        LlmResult base = scorer.score(technical, TRANSCRIPT);

        assertThat(scorer.penalize(base, List.of(new KnowledgeError(1, "q", "e")))).isSameAs(base);
    }

    @Test
    void khongCoYThamChieuThiGiuDiemLlmVaKhongCoPoints() {
        LlmRequest technical = new LlmRequest(UUID.randomUUID(), Question.Type.TECHNICAL, "s", "u");
        String json = """
                {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
                 {"code":"RELEVANCE","reasoning":"r","quote":"q","score":4},
                 {"code":"STRUCTURE","reasoning":"r","quote":"q","score":4},
                 {"code":"DEPTH","reasoning":"r","quote":"q","score":4},
                 {"code":"CORRECTNESS","reasoning":"r","quote":"q","score":5}]}""";
        when(client.score(technical)).thenReturn(new LlmRawResult(json));

        LlmResult result = scorer.score(technical, TRANSCRIPT);

        assertThat(result.points()).isEmpty();
        assertThat(result.criteria()).extracting(CriterionScore::score).containsExactly(4, 4, 4, 5);
    }
}
