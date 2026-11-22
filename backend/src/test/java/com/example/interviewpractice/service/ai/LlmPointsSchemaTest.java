package com.example.interviewpractice.service.ai;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.entity.ScorePoint.Verdict;
import com.example.interviewpractice.service.scoring.PointScore;
import com.example.interviewpractice.service.scoring.RubricConfig;

import tools.jackson.databind.json.JsonMapper;

/** Schema gửi Gemini và bước kiểm points của kết quả LLM (đối chiếu theo ý). */
class LlmPointsSchemaTest {

    private final LlmResultValidator validator = new LlmResultValidator(new JsonMapper());

    private static final List<String> REF = List.of("Ý một", "Ý hai");

    private static String json(String points) {
        return """
                {"offTopic":false,"injectionSuspected":false,"feedbackText":"ok","criteria":[
                 {"code":"RELEVANCE","reasoning":"r","quote":"q","score":4},
                 {"code":"STRUCTURE","reasoning":"r","quote":"q","score":4},
                 {"code":"DEPTH","reasoning":"r","quote":"q","score":4},
                 {"code":"CORRECTNESS","reasoning":"r","quote":"q","score":4}]%s}"""
                .formatted(points == null ? "" : ",\"points\":" + points);
    }

    private LlmResult validate(String points) {
        return validator.validate(new LlmRawResult(json(points)), Question.Type.TECHNICAL, REF);
    }

    @SuppressWarnings("unchecked")
    @Test
    void schemaCoMangPointsDungSoYKhiCoDapAnThamChieu() {
        Map<String, Object> schema = GeminiLlmClient.responseSchema(RubricConfig.llmCodes(Question.Type.TECHNICAL), 3);
        Map<String, Object> props = (Map<String, Object>) schema.get("properties");
        Map<String, Object> points = (Map<String, Object>) props.get("points");

        assertThat(points).containsEntry("minItems", 3).containsEntry("maxItems", 3);
        assertThat((List<String>) schema.get("required")).contains("points");
        Map<String, Object> item = (Map<String, Object>) points.get("items");
        Map<String, Object> verdict = (Map<String, Object>) ((Map<String, Object>) item.get("properties"))
                .get("verdict");
        assertThat((List<String>) verdict.get("enum"))
                .containsExactly(Verdict.COVERED.name(), Verdict.PARTIAL.name(), Verdict.MISSING.name(),
                        Verdict.INCORRECT.name());
    }

    @SuppressWarnings("unchecked")
    @Test
    void schemaKhongCoPointsKhiKhongCoYThamChieu() {
        Map<String, Object> schema = GeminiLlmClient.responseSchema(List.of(Code.RELEVANCE, Code.STRUCTURE), 0);
        assertThat((Map<String, Object>) schema.get("properties")).doesNotContainKey("points");
        assertThat((List<String>) schema.get("required")).doesNotContain("points");
    }

    @Test
    void doiChieuHopLeGiuDungThuTuVaBanChupNoiDungY() {
        LlmResult result = validate("""
                [{"index":2,"verdict":"MISSING","quote":null,"note":"thiếu"},
                 {"index":1,"verdict":"COVERED","quote":"ý một","note":"đủ"}]""");

        assertThat(result.points()).extracting(PointScore::position).containsExactly(1, 2);
        assertThat(result.points()).extracting(PointScore::pointText).containsExactly("Ý một", "Ý hai");
        assertThat(result.points()).extracting(PointScore::verdict).containsExactly(Verdict.COVERED,
                Verdict.MISSING);
        assertThat(result.points().get(1).quote()).isNull();
    }

    @Test
    void khongCoYThamChieuThiBoQuaPointsDoLlmTraThua() {
        LlmResult result = validator.validate(
                new LlmRawResult(json("[{\"index\":1,\"verdict\":\"COVERED\",\"quote\":\"x\",\"note\":\"n\"}]")),
                Question.Type.TECHNICAL, List.of());
        assertThat(result.points()).isEmpty();
    }

    @Test
    void saiSchemaPointsThiInvalidResult() {
        List<String> bad = List.of(
                "null",
                "[]",
                "[{\"index\":1,\"verdict\":\"COVERED\",\"quote\":\"q\",\"note\":\"n\"}]",
                "[{\"index\":1,\"verdict\":\"COVERED\",\"quote\":\"q\",\"note\":\"n\"},"
                        + "{\"index\":1,\"verdict\":\"MISSING\",\"quote\":null,\"note\":\"n\"}]",
                "[{\"index\":1,\"verdict\":\"COVERED\",\"quote\":\"q\",\"note\":\"n\"},"
                        + "{\"index\":3,\"verdict\":\"MISSING\",\"quote\":null,\"note\":\"n\"}]",
                "[{\"index\":1,\"verdict\":\"TUYET_VOI\",\"quote\":\"q\",\"note\":\"n\"},"
                        + "{\"index\":2,\"verdict\":\"MISSING\",\"quote\":null,\"note\":\"n\"}]",
                "[{\"index\":1.5,\"verdict\":\"COVERED\",\"quote\":\"q\",\"note\":\"n\"},"
                        + "{\"index\":2,\"verdict\":\"MISSING\",\"quote\":null,\"note\":\"n\"}]");
        for (String points : bad) {
            assertThatThrownBy(() -> validate(points)).as(points).isInstanceOfSatisfying(LlmException.class,
                    e -> assertThat(e.getErrorCode()).isEqualTo(LlmException.INVALID_RESULT));
        }
    }

    @Test
    void thieuHanMangPointsKhiCoYThamChieuThiInvalidResult() {
        assertThatThrownBy(() -> validate(null)).isInstanceOf(LlmException.class);
    }
}
