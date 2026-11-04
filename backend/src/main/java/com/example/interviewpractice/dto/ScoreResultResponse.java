package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.entity.ScoreResult;

/** Kết quả chấm trả cho client, khớp schema ScoreResult trong openapi.yaml (ttsAudioUrl chưa hỗ trợ nên bỏ). */
public record ScoreResultResponse(UUID id, UUID sessionId, String transcript, Question.Type questionType,
        BigDecimal totalScore, BigDecimal contentScore, List<CriterionDto> criteria, DeliveryDto delivery,
        boolean offTopic, boolean injectionSuspected, String rubricVersion, String promptVersion,
        String modelVersion, String feedbackText, String sampleAnswer) {

    /** Điểm một tiêu chí; weight là trọng số gốc theo rubric. */
    public record CriterionDto(Code code, int score, int weight, String reasoning, String quote,
            boolean quoteInvalid) {
    }

    /** Chỉ số Delivery; fillerListVersion là phiên bản danh sách từ đệm đã dùng. */
    public record DeliveryDto(int wpm, int fillerCount, BigDecimal fillerRate, BigDecimal deliveryScore,
            String fillerListVersion) {
    }

    public static ScoreResultResponse from(ScoreResult r) {
        List<CriterionDto> criteria = r.getCriteria().stream()
                .sorted(Comparator.comparing(ScoreCriterion::getCode)) // theo thứ tự rubric, không theo thứ tự CSDL
                .map(c -> new CriterionDto(c.getCode(), c.getScore(), c.getWeight(), c.getReasoning(), c.getQuote(),
                        c.isQuoteInvalid()))
                .toList();
        // Cột delivery_score null nghĩa là thiếu dữ liệu Delivery (transcript dưới 30 từ hoặc không có thời lượng)
        DeliveryDto delivery = r.getDeliveryScore() == null ? null
                : new DeliveryDto(r.getWpm(), r.getFillerCount(), r.getFillerRate(), r.getDeliveryScore(),
                        r.getFillerListVersion());
        // getId() trên proxy lazy không nạp lại phiên
        return new ScoreResultResponse(r.getId(), r.getSession().getId(), r.getTranscript(), r.getQuestionType(),
                r.getTotalScore(), r.getContentScore(), criteria, delivery, r.isOffTopic(),
                r.isInjectionSuspected(), r.getRubricVersion(), r.getPromptVersion(), r.getModelVersion(),
                r.getFeedbackText(), r.getSampleAnswer());
    }
}
