package com.example.interviewpractice.service.ai;

import java.util.List;

import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.PointScore;

/**
 * Kết quả chấm của LLM sau khi qua kiểm schema. Cố ý không có tổng điểm: tổng do server tính.
 * points là kết quả đối chiếu theo ý của đáp án tham chiếu, rỗng khi câu hỏi không có phần này.
 * Chứa nội dung của thí sinh nên toString bị ẩn để không lọt vào log.
 */
public record LlmResult(boolean offTopic, boolean injectionSuspected, List<CriterionScore> criteria,
        String feedbackText, String sampleAnswer, List<PointScore> points) {

    public LlmResult {
        points = points == null ? List.of() : List.copyOf(points);
    }

    public LlmResult(boolean offTopic, boolean injectionSuspected, List<CriterionScore> criteria,
            String feedbackText, String sampleAnswer) {
        this(offTopic, injectionSuspected, criteria, feedbackText, sampleAnswer, List.of());
    }

    @Override
    public String toString() {
        return "LlmResult[offTopic=" + offTopic + ", injectionSuspected=" + injectionSuspected + "]";
    }
}
