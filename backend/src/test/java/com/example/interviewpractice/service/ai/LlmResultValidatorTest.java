package com.example.interviewpractice.service.ai;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;

import tools.jackson.databind.json.JsonMapper;

class LlmResultValidatorTest {

    private final LlmResultValidator validator = new LlmResultValidator(new JsonMapper());

    private static String criterion(String code, String score) {
        return "{\"code\":\"" + code + "\",\"reasoning\":\"lý do\",\"quote\":\"trích dẫn\",\"score\":" + score + "}";
    }

    private static String json(String criteria, String extra) {
        return "{\"offTopic\":false,\"injectionSuspected\":false,\"criteria\":[" + criteria
                + "],\"feedbackText\":\"nhận xét\"" + extra + "}";
    }

    private static String behavioral(String relevance, String structure, String depth) {
        return criterion("RELEVANCE", relevance) + "," + criterion("STRUCTURE", structure) + ","
                + criterion("DEPTH", depth);
    }

    private LlmResult validate(String json, Question.Type type) {
        return validator.validate(new LlmRawResult(json), type);
    }

    private void assertInvalid(String json, Question.Type type) {
        assertThatThrownBy(() -> validate(json, type)).isInstanceOfSatisfying(LlmException.class,
                e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.INVALID_RESULT));
    }

    @Test
    void jsonHopLeDuTieuChiThiNhanDuoc() {
        LlmResult r = validate(json(behavioral("4", "3", "3"), ",\"sampleAnswer\":\"mẫu\""),
                Question.Type.BEHAVIORAL);

        assertThat(r.criteria()).extracting("code").containsExactly(Code.RELEVANCE, Code.STRUCTURE, Code.DEPTH);
        assertThat(r.criteria()).extracting("score").containsExactly(4, 3, 3);
        assertThat(r.feedbackText()).isEqualTo("nhận xét");
        assertThat(r.sampleAnswer()).isEqualTo("mẫu");
        assertThat(r.offTopic()).isFalse();
    }

    @Test
    void technicalDuBonTieuChiThiNhanDuoc() {
        String four = behavioral("5", "4", "3") + "," + criterion("CORRECTNESS", "2");
        assertThat(validate(json(four, ""), Question.Type.TECHNICAL).criteria()).hasSize(4);
    }

    @ParameterizedTest
    @ValueSource(strings = {"0", "6", "3.5", "-1", "\"3\"", "null", "3.0"})
    void diemNgoaiKhoangHoacKhongNguyenLaSaiSchema(String badScore) {
        assertInvalid(json(behavioral("4", badScore, "3"), ""), Question.Type.BEHAVIORAL);
    }

    @Test
    void technicalThieuCorrectnessLaSaiSchema() {
        assertInvalid(json(behavioral("4", "3", "3"), ""), Question.Type.TECHNICAL);
    }

    @Test
    void behavioralCoThemCorrectnessLaSaiSchema() {
        String extra = behavioral("4", "3", "3") + "," + criterion("CORRECTNESS", "3");
        assertInvalid(json(extra, ""), Question.Type.BEHAVIORAL);
    }

    @Test
    void tieuChiTrungLaSaiSchema() {
        String dup = criterion("RELEVANCE", "4") + "," + criterion("RELEVANCE", "4") + ","
                + criterion("DEPTH", "3");
        assertInvalid(json(dup, ""), Question.Type.BEHAVIORAL);
    }

    @Test
    void maTieuChiLaLaSaiSchema() {
        String bad = criterion("RELEVANCE", "4") + "," + criterion("STRUCTURE", "3") + "," + criterion("FOO", "3");
        assertInvalid(json(bad, ""), Question.Type.BEHAVIORAL);
    }

    @Test
    void jsonHongHoacKhongPhaiDoiTuongLaSaiSchema() {
        assertInvalid("{khong phai json", Question.Type.INTRO);
        assertInvalid("[]", Question.Type.INTRO);
        assertInvalid("", Question.Type.INTRO);
    }

    @Test
    void thieuCoOffTopicHoacFeedbackLaSaiSchema() {
        assertInvalid("{\"injectionSuspected\":false,\"criteria\":[" + behavioral("4", "3", "3")
                + "],\"feedbackText\":\"x\"}", Question.Type.BEHAVIORAL);
        assertInvalid("{\"offTopic\":false,\"injectionSuspected\":false,\"criteria\":[" + behavioral("4", "3", "3")
                + "]}", Question.Type.BEHAVIORAL);
    }

    @Test
    void totalScoreCuaLlmBiBoQua() {
        LlmResult r = validate(json(behavioral("1", "1", "1"), ",\"totalScore\":100"), Question.Type.BEHAVIORAL);

        // LlmResult không có trường tổng điểm; điểm tiêu chí giữ nguyên
        assertThat(r.criteria()).extracting("score").containsExactly(1, 1, 1);
    }

    @Test
    void quoteNullDuocChoPhep() {
        String noQuote = "{\"code\":\"RELEVANCE\",\"reasoning\":\"r\",\"quote\":null,\"score\":2},"
                + criterion("STRUCTURE", "2") + "," + criterion("DEPTH", "2");
        LlmResult r = validate(json(noQuote, ""), Question.Type.BEHAVIORAL);
        assertThat(r.criteria().get(0).quote()).isNull();
    }

    @Test
    void thongBaoLoiKhongChuaNoiDungLlmTra() {
        String secret = "NOI-DUNG-NHAY-CAM";
        assertThatThrownBy(() -> validate("{\"offTopic\":\"" + secret + "\"}", Question.Type.INTRO))
                .hasMessageNotContaining(secret);
    }
}
