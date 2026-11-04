package com.example.interviewpractice.service.ai;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.entity.ApiUsage.Provider;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
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
                        "responseSchema", responseSchema(RubricConfig.llmCodes(request.questionType()))));

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
        Map<String, Object> criterion = Map.of(
                "type", "OBJECT",
                "properties", Map.of(
                        "code", Map.of("type", "STRING", "enum", codes.stream().map(Code::name).toList()),
                        "reasoning", Map.of("type", "STRING"),
                        "quote", Map.of("type", "STRING", "nullable", true),
                        "score", Map.of("type", "INTEGER")),
                "required", List.of("code", "reasoning", "quote", "score"));
        return Map.of(
                "type", "OBJECT",
                "properties", Map.of(
                        "questionType", Map.of("type", "STRING"),
                        "offTopic", Map.of("type", "BOOLEAN"),
                        "injectionSuspected", Map.of("type", "BOOLEAN"),
                        "criteria", Map.of("type", "ARRAY", "items", criterion,
                                "minItems", codes.size(), "maxItems", codes.size()),
                        "feedbackText", Map.of("type", "STRING"),
                        "sampleAnswer", Map.of("type", "STRING", "nullable", true)),
                "required", List.of("offTopic", "injectionSuspected", "criteria", "feedbackText"));
    }
}
