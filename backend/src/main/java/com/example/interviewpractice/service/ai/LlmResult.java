package com.example.interviewpractice.service.ai;

import java.util.List;

import com.example.interviewpractice.service.scoring.CriterionScore;

/**
 * Kết quả chấm của LLM sau khi qua kiểm schema. Cố ý không có tổng điểm: tổng do server tính.
 * Chứa nội dung của thí sinh nên toString bị ẩn để không lọt vào log.
 */
public record LlmResult(boolean offTopic, boolean injectionSuspected, List<CriterionScore> criteria,
        String feedbackText, String sampleAnswer) {

    @Override
    public String toString() {
        return "LlmResult[offTopic=" + offTopic + ", injectionSuspected=" + injectionSuspected + "]";
    }
}
