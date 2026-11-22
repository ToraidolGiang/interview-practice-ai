package com.example.interviewpractice.config;

import java.net.http.HttpClient;
import java.time.Duration;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.JdkClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

/** RestClient gọi Gemini; connect/read timeout lấy từ cấu hình (STT: AC-9, LLM: ai.llm.timeout). */
@Configuration
@EnableConfigurationProperties(KnowledgeCheckProperties.class)
public class GeminiHttpConfig {

    @Bean(name = "geminiSttRestClient")
    public RestClient geminiSttRestClient(AiProperties ai) {
        return build(ai.gemini().baseUrl(), ai.stt().timeout());
    }

    @Bean(name = "geminiLlmRestClient")
    public RestClient geminiLlmRestClient(AiProperties ai) {
        return build(ai.gemini().baseUrl(), ai.llm().timeout());
    }

    @Bean(name = "geminiCheckRestClient")
    public RestClient geminiCheckRestClient(AiProperties ai, KnowledgeCheckProperties check) {
        return build(ai.gemini().baseUrl(), check.timeout());
    }

    private static RestClient build(String baseUrl, Duration timeout) {
        HttpClient httpClient = HttpClient.newBuilder().connectTimeout(timeout).build();
        JdkClientHttpRequestFactory factory = new JdkClientHttpRequestFactory(httpClient);
        factory.setReadTimeout(timeout);
        return RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(factory)
                .build();
    }
}
