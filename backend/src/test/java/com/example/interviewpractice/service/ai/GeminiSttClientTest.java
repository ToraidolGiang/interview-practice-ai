package com.example.interviewpractice.service.ai;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.client.ExpectedCount.once;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.jsonPath;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withServerError;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.SocketTimeoutException;
import java.time.Duration;
import java.util.Base64;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.entity.ApiUsage.Provider;

import tools.jackson.databind.json.JsonMapper;

class GeminiSttClientTest {

    private static final String URL = "http://gemini.test/v1beta/models/stt-model:generateContent";
    private static final String OK_BODY = """
            {"candidates":[{"content":{"parts":[{"text":" Ừm, tôi ờ muốn nói về Java. "}]}}],
             "usageMetadata":{"totalTokenCount":321}}""";

    private final UUID sessionId = UUID.randomUUID();
    private final ApiUsageRecorder recorder = mock(ApiUsageRecorder.class);
    private MockRestServiceServer server;
    private GeminiSttClient client;

    @BeforeEach
    void setUp() {
        RestClient.Builder builder = RestClient.builder().baseUrl("http://gemini.test");
        server = MockRestServiceServer.bindTo(builder).build();
        AiProperties ai = new AiProperties(
                new AiProperties.Gemini("secret-key", "http://gemini.test", "stt-model", "llm-model"),
                new AiProperties.Fpt("x"), new AiProperties.Stt(Duration.ofSeconds(15)),
                new AiProperties.Llm(Duration.ofSeconds(15), 0.2));
        client = new GeminiSttClient(builder.build(), new JsonMapper(), ai, recorder);
    }

    @Test
    void successKeepsFillerWordsAndSendsVerbatimPromptAndAudio() {
        byte[] audio = {1, 2, 3};
        server.expect(once(), requestTo(URL))
                .andExpect(method(HttpMethod.POST))
                .andExpect(header("x-goog-api-key", "secret-key"))
                .andExpect(jsonPath("$.contents[0].parts[0].text").value(GeminiSttClient.PROMPT))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("NGUYÊN VĂN")))
                .andExpect(jsonPath("$.contents[0].parts[1].inline_data.mime_type").value("audio/webm"))
                .andExpect(jsonPath("$.contents[0].parts[1].inline_data.data")
                        .value(Base64.getEncoder().encodeToString(audio)))
                .andRespond(withSuccess(OK_BODY, MediaType.APPLICATION_JSON));

        String transcript = client.transcribe(sessionId, audio, "audio/webm");

        assertEquals("Ừm, tôi ờ muốn nói về Java.", transcript);
        server.verify();
        verify(recorder).record(eq(sessionId), eq(Provider.STT), anyLong(), eq(BigDecimal.valueOf(321)));
    }

    @Test
    void firstTimeoutThenSuccessMakesExactlyTwoRequests() {
        server.expect(requestTo(URL)).andRespond(request -> {
            throw new SocketTimeoutException("read timed out");
        });
        server.expect(requestTo(URL)).andRespond(withSuccess(OK_BODY, MediaType.APPLICATION_JSON));

        String transcript = client.transcribe(sessionId, new byte[] {1}, "audio/webm");

        assertEquals("Ừm, tôi ờ muốn nói về Java.", transcript);
        server.verify();
        // Mỗi lần gọi (kể cả lần lỗi) đều được ghi nhật ký
        verify(recorder, times(2)).record(eq(sessionId), eq(Provider.STT), anyLong(), any());
    }

    @Test
    void twoFailuresThrowSttExceptionAfterExactlyTwoRequestsAndRecordBoth() {
        server.expect(requestTo(URL)).andRespond(withServerError());
        server.expect(requestTo(URL)).andRespond(request -> {
            throw new IOException("connection reset");
        });

        assertThrows(SttException.class, () -> client.transcribe(sessionId, new byte[] {1}, "audio/webm"));

        server.verify();
        verify(recorder, times(2)).record(eq(sessionId), eq(Provider.STT), anyLong(), eq(null));
    }

    @Test
    void responseWithoutTextIsRetriedThenFails() {
        server.expect(requestTo(URL)).andRespond(withSuccess("{\"candidates\":[]}", MediaType.APPLICATION_JSON));
        server.expect(requestTo(URL)).andRespond(withSuccess("không phải json", MediaType.APPLICATION_JSON));

        assertThrows(SttException.class, () -> client.transcribe(sessionId, new byte[] {1}, "audio/webm"));

        server.verify();
    }
}
