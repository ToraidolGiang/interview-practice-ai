package com.example.interviewpractice.service.ai;

import java.util.List;
import java.util.UUID;

import com.example.interviewpractice.entity.Question;

/**
 * Yêu cầu chấm gửi LLM: prompt đã dựng sẵn; questionType quyết định bộ tiêu chí trong schema đầu ra.
 * referencePoints là các ý của đáp án tham chiếu cần đối chiếu (rỗng thì không có phần đối chiếu theo ý).
 */
public record LlmRequest(UUID sessionId, Question.Type questionType, String systemPrompt, String userPrompt,
        List<String> referencePoints) {

    public LlmRequest {
        referencePoints = referencePoints == null ? List.of() : List.copyOf(referencePoints);
    }

    public LlmRequest(UUID sessionId, Question.Type questionType, String systemPrompt, String userPrompt) {
        this(sessionId, questionType, systemPrompt, userPrompt, List.of());
    }

    // Prompt chứa transcript của thí sinh nên không đưa vào toString/log
    @Override
    public String toString() {
        return "LlmRequest[sessionId=" + sessionId + ", questionType=" + questionType + "]";
    }
}
