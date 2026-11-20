package com.example.interviewpractice.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.DeliveryMetrics;
import com.example.interviewpractice.service.scoring.ScoreOutcome;

/**
 * Kết quả chấm hoàn chỉnh của một phiên, sẵn sàng để lưu: điểm đã do server tính, tiêu chí đã qua kiểm trích dẫn.
 * Chứa transcript của thí sinh nên toString bị ẩn để không lọt vào log.
 */
public record ScoredAnswer(UUID sessionId, String transcript, Question.Type questionType,
        List<CriterionScore> criteria, Optional<DeliveryMetrics> delivery, ScoreOutcome outcome, boolean offTopic,
        boolean injectionSuspected, String feedbackText, String sampleAnswer) {

    @Override
    public String toString() {
        return "ScoredAnswer[sessionId=" + sessionId + "]";
    }
}
