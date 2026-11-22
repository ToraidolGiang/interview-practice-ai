package com.example.interviewpractice.service.ai;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.entity.ApiUsage.Provider;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.entity.ScorePoint.Verdict;
import com.example.interviewpractice.service.scoring.RubricConfig;

import tools.jackson.core.JacksonException;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/**
 * Chấm điểm bằng Gemini generateContent: ép đầu ra JSON theo responseSchema, nhiệt độ thấp lấy từ cấu hình.
 * Mỗi lệnh gọi chỉ gửi một request (việc thử lại thuộc {@link LlmScorer}) và ghi một dòng api_usages.
 * Không log API key, prompt hay nội dung phản hồi.
 */
@Component
public class GeminiLlmClient implements LlmClient {

    private final RestClient restClient;
    private final JsonMapper jsonMapper;
    private final AiProperties ai;
    private final ApiUsageRecorder usageRecorder;

    public GeminiLlmClient(@Qualifier("geminiLlmRestClient") RestClient restClient, JsonMapper jsonMapper,
            AiProperties ai, ApiUsageRecorder usageRecorder) {
        this.restClient = restClient;
        this.jsonMapper = jsonMapper;
        this.ai = ai;
        this.usageRecorder = usageRecorder;
    }

    @Override
    public LlmRawResult score(LlmRequest request) {
        Map<String, Object> body = Map.of(
                "systemInstruction", Map.of("parts", List.of(Map.of("text", request.systemPrompt()))),
                "contents", List.of(Map.of("role", "user", "parts", List.of(Map.of("text", request.userPrompt())))),
                "generationConfig", Map.of(
                        "temperature", ai.llm().temperature(),
                        "responseMimeType", "application/json",
                        "responseSchema", responseSchema(RubricConfig.llmCodes(request.questionType()),
                                request.referencePoints().size())));

        long start = System.nanoTime();
        BigDecimal usageUnit = null;
        try {
            // Khóa API gửi qua header, không nằm trong URL để không lọt vào log
            String raw = restClient.post()
                    .uri("/v1beta/models/{model}:generateContent", ai.gemini().llmModel())
                    .header("x-goog-api-key", ai.gemini().apiKey())
                    .body(body)
                    .retrieve()
                    .body(String.class);
            JsonNode root = jsonMapper.readTree(raw);
            JsonNode tokens = root.path("usageMetadata").path("totalTokenCount");
            usageUnit = tokens.isNumber() ? BigDecimal.valueOf(tokens.asLong()) : null;
            JsonNode text = root.path("candidates").path(0).path("content").path("parts").path(0).path("text");
            if (!text.isString()) {
                throw new LlmException(LlmException.LLM_ERROR, "Phản hồi Gemini không có nội dung chấm điểm");
            }
            return new LlmRawResult(text.asString());
        } catch (RestClientException e) {
            throw new LlmException(LlmException.LLM_ERROR, "Gọi Gemini LLM lỗi", e);
        } catch (JacksonException e) {
            throw new LlmException(LlmException.LLM_ERROR, "Phản hồi Gemini LLM không phải JSON hợp lệ", e);
        } finally {
            usageRecorder.record(request.sessionId(), Provider.LLM, (System.nanoTime() - start) / 1_000_000,
                    usageUnit);
        }
    }

    // Schema đầu ra theo Rubric_Cham_Diem.md mục 6; code bị ràng buộc theo bộ tiêu chí của loại câu hỏi
    static Map<String, Object> responseSchema(List<Code> codes) {
        return responseSchema(codes, 0);
    }

    // pointCount > 0: thêm mảng points đối chiếu theo ý của đáp án tham chiếu, đúng pointCount phần tử
    static Map<String, Object> responseSchema(List<Code> codes, int pointCount) {
        Map<String, Object> criterion = Map.of(
                "type", "OBJECT",
                "properties", Map.of(
                        "code", Map.of("type", "STRING", "enum", codes.stream().map(Code::name).toList()),
                        "reasoning", Map.of("type", "STRING"),
                        "quote", Map.of("type", "STRING", "nullable", true),
                        "score", Map.of("type", "INTEGER")),
                "required", List.of("code", "reasoning", "quote", "score"));
        Map<String, Object> properties = new LinkedHashMap<>();
        properties.put("questionType", Map.of("type", "STRING"));
        properties.put("offTopic", Map.of("type", "BOOLEAN"));
        properties.put("injectionSuspected", Map.of("type", "BOOLEAN"));
        properties.put("criteria", Map.of("type", "ARRAY", "items", criterion,
                "minItems", codes.size(), "maxItems", codes.size()));
        properties.put("feedbackText", Map.of("type", "STRING"));
        properties.put("sampleAnswer", Map.of("type", "STRING", "nullable", true));
        List<String> required = new ArrayList<>(List.of("offTopic", "injectionSuspected", "criteria", "feedbackText"));
        if (pointCount > 0) {
            Map<String, Object> point = Map.of(
                    "type", "OBJECT",
                    "properties", Map.of(
                            "index", Map.of("type", "INTEGER"),
                            "verdict", Map.of("type", "STRING",
                                    "enum", Arrays.stream(Verdict.values()).map(Verdict::name).toList()),
                            "quote", Map.of("type", "STRING", "nullable", true),
                            "note", Map.of("type", "STRING")),
                    "required", List.of("index", "verdict", "quote", "note"));
            properties.put("points", Map.of("type", "ARRAY", "items", point,
                    "minItems", pointCount, "maxItems", pointCount));
            required.add("points");
        }
        return Map.of("type", "OBJECT", "properties", properties, "required", required);
    }
}
