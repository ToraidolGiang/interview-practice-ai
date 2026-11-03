package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion;
import com.example.interviewpractice.entity.ScoreResult;

/** Kết quả chấm điểm trả về client, khớp schema ScoreResult trong openapi.yaml. */
public record ScoreResultDto(UUID id, UUID sessionId, String transcript, Question.Type questionType,
        BigDecimal totalScore, BigDecimal contentScore, List<CriterionScore> criteria, DeliveryMetrics delivery,
        boolean offTopic, boolean injectionSuspected, String rubricVersion, String promptVersion,
        String modelVersion, String feedbackText, String sampleAnswer, String ttsAudioUrl) {

    public record CriterionScore(ScoreCriterion.Code code, int score, int weight, String reasoning, String quote,
            boolean quoteInvalid) {

        static CriterionScore from(ScoreCriterion c) {
            return new CriterionScore(c.getCode(), c.getScore(), c.getWeight(), c.getReasoning(), c.getQuote(),
                    c.isQuoteInvalid());
        }
    }

    /** Null khi transcript quá ngắn hoặc thiếu thời lượng (DeliveryCalculator không tính). */
    public record DeliveryMetrics(Integer wpm, Integer fillerCount, BigDecimal fillerRate, BigDecimal deliveryScore,
            String fillerListVersion) {
    }

    /** ttsAudioUrl cần URL ký sẵn trên S3 (#121), chưa có nên tạm truyền null. */
    public static ScoreResultDto from(ScoreResult r, String ttsAudioUrl) {
        // Thứ tự tiêu chí cố định theo rubric (RELEVANCE, STRUCTURE, DEPTH, CORRECTNESS), không phụ thuộc thứ tự lưu
        List<CriterionScore> criteria = r.getCriteria().stream()
                .sorted(Comparator.comparing(ScoreCriterion::getCode))
                .map(CriterionScore::from)
                .toList();
        DeliveryMetrics delivery = r.getWpm() == null ? null
                : new DeliveryMetrics(r.getWpm(), r.getFillerCount(), r.getFillerRate(), r.getDeliveryScore(),
                        r.getFillerListVersion());
        return new ScoreResultDto(r.getId(), r.getSession().getId(), r.getTranscript(), r.getQuestionType(),
                r.getTotalScore(), r.getContentScore(), criteria, delivery, r.isOffTopic(), r.isInjectionSuspected(),
                r.getRubricVersion(), r.getPromptVersion(), r.getModelVersion(), r.getFeedbackText(),
                r.getSampleAnswer(), ttsAudioUrl);
    }
}
