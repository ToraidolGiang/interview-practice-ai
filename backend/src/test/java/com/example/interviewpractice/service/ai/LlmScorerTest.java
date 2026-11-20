package com.example.interviewpractice.service.ai;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.UUID;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.service.scoring.CriterionScore;
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
    private final LlmScorer scorer = new LlmScorer(client, new LlmResultValidator(new JsonMapper()), new QuoteValidator());
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
}
