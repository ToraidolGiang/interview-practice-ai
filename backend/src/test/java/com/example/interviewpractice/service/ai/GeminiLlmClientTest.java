package com.example.interviewpractice.service.ai;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.client.ExpectedCount.once;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.jsonPath;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withServerError;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import java.math.BigDecimal;
import java.time.Duration;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.entity.ApiUsage.Provider;
import com.example.interviewpractice.entity.Question;

import tools.jackson.databind.json.JsonMapper;

class GeminiLlmClientTest {

    private static final String URL = "http://gemini.test/v1beta/models/llm-model:generateContent";
    private static final String JSON_OUT = "{\"offTopic\":false}";

    private final UUID sessionId = UUID.randomUUID();
    private final ApiUsageRecorder recorder = mock(ApiUsageRecorder.class);
    private MockRestServiceServer server;
    private GeminiLlmClient client;

    @BeforeEach
    void setUp() {
        RestClient.Builder builder = RestClient.builder().baseUrl("http://gemini.test");
        server = MockRestServiceServer.bindTo(builder).build();
        AiProperties ai = new AiProperties(
                new AiProperties.Gemini("secret-key", "http://gemini.test", "stt-model", "llm-model"),
                new AiProperties.Fpt("x"), new AiProperties.Stt(Duration.ofSeconds(15)),
                new AiProperties.Llm(Duration.ofSeconds(15), 0.2));
        client = new GeminiLlmClient(builder.build(), new JsonMapper(), ai, recorder);
    }

    private LlmRequest request(Question.Type type) {
        return new LlmRequest(sessionId, type, "system prompt", "user prompt");
    }

    private static String responseWith(String text) {
        return "{\"candidates\":[{\"content\":{\"parts\":[{\"text\":" + new JsonMapper().writeValueAsString(text)
                + "}]}}],\"usageMetadata\":{\"totalTokenCount\":99}}";
    }

    @Test
    void guiJsonMimeTypeNhietDoThapSchemaVaKhoaQuaHeader() {
        server.expect(once(), requestTo(URL))
                .andExpect(method(HttpMethod.POST))
                .andExpect(header("x-goog-api-key", "secret-key"))
                .andExpect(jsonPath("$.generationConfig.responseMimeType").value("application/json"))
                .andExpect(jsonPath("$.generationConfig.temperature").value(0.2))
                .andExpect(jsonPath("$.systemInstruction.parts[0].text").value("system prompt"))
                .andExpect(jsonPath("$.contents[0].parts[0].text").value("user prompt"))
                .andExpect(jsonPath("$.generationConfig.responseSchema.properties.criteria.minItems").value(3))
                .andExpect(jsonPath("$.generationConfig.responseSchema.properties.criteria.items.properties.code.enum")
                        .value(org.hamcrest.Matchers.contains("RELEVANCE", "STRUCTURE", "DEPTH")))
                .andRespond(withSuccess(responseWith(JSON_OUT), MediaType.APPLICATION_JSON));

        LlmRawResult raw = client.score(request(Question.Type.BEHAVIORAL));

        assertEquals(JSON_OUT, raw.json());
        server.verify();
        verify(recorder).record(eq(sessionId), eq(Provider.LLM), anyLong(), eq(BigDecimal.valueOf(99)));
    }

    @Test
    void schemaCuaTechnicalCoCorrectness() {
        server.expect(once(), requestTo(URL))
                .andExpect(jsonPath("$.generationConfig.responseSchema.properties.criteria.maxItems").value(4))
                .andExpect(jsonPath("$.generationConfig.responseSchema.properties.criteria.items.properties.code.enum")
                        .value(org.hamcrest.Matchers.hasItem("CORRECTNESS")))
                .andRespond(withSuccess(responseWith(JSON_OUT), MediaType.APPLICATION_JSON));

        client.score(request(Question.Type.TECHNICAL));

        server.verify();
    }

    @Test
    void loiMayChuNemLlmErrorVaVanGhiApiUsage() {
        server.expect(once(), requestTo(URL)).andRespond(withServerError());

        LlmException e = assertThrows(LlmException.class, () -> client.score(request(Question.Type.BEHAVIORAL)));

        assertEquals(LlmException.LLM_ERROR, e.getErrorCode());
        verify(recorder).record(eq(sessionId), eq(Provider.LLM), anyLong(), isNull());
    }

    @Test
    void phanHoiKhongCoNoiDungNemLlmError() {
        server.expect(once(), requestTo(URL))
                .andRespond(withSuccess("{\"candidates\":[]}", MediaType.APPLICATION_JSON));

        LlmException e = assertThrows(LlmException.class, () -> client.score(request(Question.Type.INTRO)));

        assertEquals(LlmException.LLM_ERROR, e.getErrorCode());
    }
}
