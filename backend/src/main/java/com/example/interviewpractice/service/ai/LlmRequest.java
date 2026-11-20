package com.example.interviewpractice.service.ai;

import java.util.UUID;

import com.example.interviewpractice.entity.Question;

/** Yêu cầu chấm gửi LLM: prompt đã dựng sẵn; questionType quyết định bộ tiêu chí trong schema đầu ra. */
public record LlmRequest(UUID sessionId, Question.Type questionType, String systemPrompt, String userPrompt) {

    // Prompt chứa transcript của thí sinh nên không đưa vào toString/log
    @Override
    public String toString() {
        return "LlmRequest[sessionId=" + sessionId + ", questionType=" + questionType + "]";
    }
}
