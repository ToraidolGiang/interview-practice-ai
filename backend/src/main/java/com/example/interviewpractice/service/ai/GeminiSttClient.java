package com.example.interviewpractice.service.ai;

import java.math.BigDecimal;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.entity.ApiUsage.Provider;

import tools.jackson.core.JacksonException;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/**
 * Phiên âm bằng Gemini generateContent (audio nhúng base64). Timeout theo cấu hình, thử lại đúng 1 lần,
 * mỗi lần gọi đều ghi api_usages. Không log API key hay nội dung transcript.
 */
@Component
public class GeminiSttClient implements SttClient {

    static final String PROMPT = "Hãy phiên âm NGUYÊN VĂN đoạn ghi âm tiếng Việt này. Giữ nguyên các từ đệm như "
            + "ừm, ờ, à; không sửa lỗi, không rút gọn, không dịch, không thêm lời giải thích. "
            + "Chỉ trả về đúng nội dung được nói.";

    private final RestClient restClient;
    private final JsonMapper jsonMapper;
    private final AiProperties ai;
    private final ApiUsageRecorder usageRecorder;

    public GeminiSttClient(@Qualifier("geminiSttRestClient") RestClient restClient, JsonMapper jsonMapper,
            AiProperties ai, ApiUsageRecorder usageRecorder) {
        this.restClient = restClient;
        this.jsonMapper = jsonMapper;
        this.ai = ai;
        this.usageRecorder = usageRecorder;
    }

    @Override
    public String transcribe(UUID sessionId, byte[] audio, String mimeType) {
        Map<String, Object> body = Map.of("contents", List.of(Map.of("parts", List.of(
                Map.of("text", PROMPT),
                Map.of("inline_data", Map.of("mime_type", mimeType,
                        "data", Base64.getEncoder().encodeToString(audio)))))));
        try {
            return OneRetry.call(() -> attempt(sessionId, body));
        } catch (SttException e) {
            throw e;
        } catch (RuntimeException e) {
            throw new SttException("Phiên âm thất bại", e);
        }
    }

    private String attempt(UUID sessionId, Map<String, Object> body) {
        long start = System.nanoTime();
        BigDecimal usageUnit = null;
        try {
            // Khóa API gửi qua header, không nằm trong URL để không lọt vào log
            String raw = restClient.post()
                    .uri("/v1beta/models/{model}:generateContent", ai.gemini().sttModel())
                    .header("x-goog-api-key", ai.gemini().apiKey())
                    .body(body)
                    .retrieve()
                    .body(String.class);
            JsonNode root = jsonMapper.readTree(raw);
            JsonNode tokens = root.path("usageMetadata").path("totalTokenCount");
            usageUnit = tokens.isNumber() ? BigDecimal.valueOf(tokens.asLong()) : null;
            JsonNode text = root.path("candidates").path(0).path("content").path("parts").path(0).path("text");
            if (!text.isString()) {
                throw new SttException("Phản hồi Gemini không có văn bản phiên âm");
            }
            return text.asString().strip();
        } catch (RestClientException e) {
            throw new SttException("Gọi Gemini STT lỗi", e);
        } catch (JacksonException e) {
            throw new SttException("Phản hồi Gemini STT không phải JSON hợp lệ", e);
        } finally {
            usageRecorder.record(sessionId, Provider.STT, (System.nanoTime() - start) / 1_000_000, usageUnit);
        }
    }
}
