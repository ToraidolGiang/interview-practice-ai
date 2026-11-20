package com.example.interviewpractice.config;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;

/** Cấu hình dịch vụ AI đọc từ khóa ai.* trong application.yml (Gemini cho STT/LLM, timeout từng bước chấm). */
@ConfigurationProperties(prefix = "ai")
public record AiProperties(Gemini gemini, Fpt fpt, Stt stt, Llm llm) {

    /** Gemini: khóa API, địa chỉ gốc và tên model dùng cho phiên âm và chấm điểm. */
    public record Gemini(String apiKey, String baseUrl, String sttModel, String llmModel) {
    }

    /** FPT.AI: chỉ giữ khóa API đã bắt buộc sẵn trong cấu hình. */
    public record Fpt(String apiKey) {
    }

    /** Thời gian chờ tối đa cho một lần gọi STT. */
    public record Stt(Duration timeout) {
    }

    /** Thời gian chờ tối đa và nhiệt độ sinh cho một lần gọi LLM chấm điểm. */
    public record Llm(Duration timeout, double temperature) {
    }
}
