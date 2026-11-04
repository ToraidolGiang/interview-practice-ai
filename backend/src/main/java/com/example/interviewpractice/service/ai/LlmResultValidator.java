package com.example.interviewpractice.service.ai;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.RubricConfig;

import tools.jackson.core.JacksonException;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/**
 * Kiểm schema đầu ra LLM (Rubric_Cham_Diem.md mục 6, quy tắc 1): JSON hợp lệ, criteria đủ và đúng bộ mã của
 * questionType, điểm là số nguyên 1-5 (không ép về khoảng này). Mọi tổng điểm LLM tự trả đều bị bỏ qua.
 * Kiểm trích dẫn là bước khác. Sai schema thì ném {@link LlmException} với INVALID_RESULT.
 */
@Component
public class LlmResultValidator {

    private final JsonMapper jsonMapper;

    public LlmResultValidator(JsonMapper jsonMapper) {
        this.jsonMapper = jsonMapper;
    }

    public LlmResult validate(LlmRawResult raw, Question.Type type) {
        JsonNode root;
        try {
            root = jsonMapper.readTree(raw.json());
        } catch (JacksonException e) {
            throw invalid("Kết quả LLM không phải JSON hợp lệ");
        }
        if (root == null || !root.isObject()) {
            throw invalid("Kết quả LLM không phải đối tượng JSON");
        }

        boolean offTopic = requireBoolean(root, "offTopic");
        boolean injectionSuspected = requireBoolean(root, "injectionSuspected");
        String feedbackText = requireText(root, "feedbackText");
        JsonNode sample = root.path("sampleAnswer");
        String sampleAnswer = sample.isString() ? sample.asString() : null;

        List<CriterionScore> criteria = parseCriteria(root.path("criteria"), type);
        return new LlmResult(offTopic, injectionSuspected, criteria, feedbackText, sampleAnswer);
    }

    private List<CriterionScore> parseCriteria(JsonNode node, Question.Type type) {
        if (!node.isArray()) {
            throw invalid("criteria phải là mảng");
        }
        Set<Code> expected = EnumSet.copyOf(RubricConfig.llmCodes(type));
        Set<Code> seen = EnumSet.noneOf(Code.class);
        List<CriterionScore> result = new ArrayList<>();
        for (JsonNode item : node) {
            if (!item.isObject()) {
                throw invalid("Phần tử criteria không phải đối tượng");
            }
            Code code = parseCode(item.path("code"));
            if (!expected.contains(code)) {
                throw invalid("Tiêu chí " + code + " không thuộc loại câu hỏi " + type);
            }
            if (!seen.add(code)) {
                throw invalid("Trùng tiêu chí " + code);
            }
            JsonNode score = item.path("score");
            // Chỉ nhận số nguyên 1-5; 3.5, "3", 0, 6 đều là sai schema
            if (!score.isIntegralNumber() || !score.canConvertToInt() || score.intValue() < 1
                    || score.intValue() > 5) {
                throw invalid("Điểm tiêu chí " + code + " phải là số nguyên 1-5");
            }
            String reasoning = requireText(item, "reasoning");
            JsonNode quote = item.path("quote");
            result.add(new CriterionScore(code, score.intValue(), reasoning,
                    quote.isString() ? quote.asString() : null, false));
        }
        if (!seen.equals(expected)) {
            throw invalid("Thiếu tiêu chí so với loại câu hỏi " + type);
        }
        return result;
    }

    private static Code parseCode(JsonNode node) {
        if (!node.isString()) {
            throw invalid("Thiếu mã tiêu chí");
        }
        try {
            return Code.valueOf(node.asString());
        } catch (IllegalArgumentException e) {
            throw invalid("Mã tiêu chí không hợp lệ");
        }
    }

    private static boolean requireBoolean(JsonNode parent, String field) {
        JsonNode node = parent.path(field);
        if (!node.isBoolean()) {
            throw invalid(field + " phải là boolean");
        }
        return node.booleanValue();
    }

    private static String requireText(JsonNode parent, String field) {
        JsonNode node = parent.path(field);
        if (!node.isString()) {
            throw invalid(field + " phải là chuỗi");
        }
        return node.asString();
    }

    // Thông báo chỉ nêu trường sai, không chép nội dung LLM trả (có thể chứa transcript)
    private static LlmException invalid(String message) {
        return new LlmException(LlmException.INVALID_RESULT, message);
    }
}
