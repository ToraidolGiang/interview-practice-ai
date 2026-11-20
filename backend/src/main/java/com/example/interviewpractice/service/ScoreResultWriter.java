package com.example.interviewpractice.service;

import java.time.Clock;
import java.time.Instant;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.entity.ScoreCriterion;
import com.example.interviewpractice.entity.ScoreResult;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.ScoreResultRepository;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.DeliveryMetrics;
import com.example.interviewpractice.service.scoring.RubricConfig;

/**
 * Lưu kết quả chấm và chốt phiên SCORED trong một transaction. Chấm lại thì xóa kết quả cũ rồi ghi mới
 * (score_results có UNIQUE theo session_id). Không gọi dịch vụ ngoài trong transaction này.
 */
@Component
public class ScoreResultWriter {

    private final ScoreResultRepository results;
    private final PracticeSessionRepository sessions;
    private final AiProperties ai;
    private final Clock clock;

    public ScoreResultWriter(ScoreResultRepository results, PracticeSessionRepository sessions, AiProperties ai,
            Clock clock) {
        this.results = results;
        this.sessions = sessions;
        this.ai = ai;
        this.clock = clock;
    }

    /**
     * @throws IllegalStateException khi phiên không còn PROCESSING (ví dụ đã bị đánh FAILED lúc khởi động lại);
     *                               transaction được hoàn tác nên không để lại kết quả mồ côi
     */
    @Transactional
    public void save(ScoredAnswer answer) {
        results.deleteBySessionId(answer.sessionId());
        // Hibernate chạy INSERT trước DELETE khi flush, nên phải đẩy DELETE xuống CSDL trước để không vi phạm UNIQUE
        results.flush();

        ScoreResult result = new ScoreResult();
        result.setSession(sessions.getReferenceById(answer.sessionId()));
        result.setTranscript(answer.transcript());
        result.setQuestionType(answer.questionType());
        result.setTotalScore(answer.outcome().totalScore());
        result.setContentScore(answer.outcome().contentScore());
        result.setOffTopic(answer.offTopic());
        result.setInjectionSuspected(answer.injectionSuspected());
        answer.delivery().ifPresent(d -> applyDelivery(result, d));
        result.setFeedbackText(answer.feedbackText());
        result.setSampleAnswer(answer.sampleAnswer());
        result.setRubricVersion(RubricConfig.RUBRIC_VERSION);
        result.setPromptVersion(RubricConfig.PROMPT_VERSION);
        result.setModelVersion(ai.gemini().llmModel());

        for (CriterionScore c : answer.criteria()) {
            ScoreCriterion criterion = new ScoreCriterion();
            criterion.setCode(c.code());
            criterion.setScore((short) c.score());
            // Lưu trọng số gốc theo rubric; khi thiếu Delivery, trọng số chia lại tính được từ delivery_score IS NULL
            criterion.setWeight(RubricConfig.llmWeights(answer.questionType()).get(c.code()).shortValue());
            criterion.setReasoning(c.reasoning());
            criterion.setQuote(c.quote());
            criterion.setQuoteInvalid(c.quoteInvalid());
            result.addCriterion(criterion);
        }
        results.saveAndFlush(result);

        Instant now = clock.instant();
        if (sessions.markScored(answer.sessionId(), answer.outcome().totalScore(), now) == 0) {
            throw new IllegalStateException("Phiên " + answer.sessionId() + " không còn ở trạng thái PROCESSING");
        }
    }

    private static void applyDelivery(ScoreResult result, DeliveryMetrics d) {
        result.setWpm(d.wpm());
        result.setFillerCount(d.fillerCount());
        result.setFillerRate(d.fillerRate());
        result.setDeliveryScore(d.deliveryScore());
        result.setFillerListVersion(d.fillerListVersion());
    }
}
