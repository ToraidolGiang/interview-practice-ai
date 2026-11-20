package com.example.interviewpractice.service.scoring;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.stereotype.Component;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;

/**
 * Tính điểm tổng và điểm nội dung (Rubric_Cham_Diem.md mục 4); lớp thuần, không I/O.
 * totalScore = Σ wᵢ·(sᵢ−1)/4; không có Delivery thì wᵢ' = wᵢ·100/90; lạc đề thì tối đa 30.
 * Tổng điểm LLM tự trả (nếu có) không bao giờ đi vào đây.
 */
@Component
public class ScoreCalculator {

    static final BigDecimal OFF_TOPIC_CAP = BigDecimal.valueOf(30);
    private static final BigDecimal HUNDRED = BigDecimal.valueOf(100);
    private static final BigDecimal FOUR = BigDecimal.valueOf(4);
    private static final MathContext PRECISION = new MathContext(20, RoundingMode.HALF_UP);

    /**
     * @param criteria điểm LLM, phải đủ và đúng bộ mã của questionType, mỗi điểm nguyên 1-5
     * @param delivery rỗng khi thiếu dữ liệu Delivery
     * @throws IllegalArgumentException khi bộ tiêu chí hoặc điểm sai (lỗi lập trình, validator đã chặn trước)
     */
    public ScoreOutcome calculate(Question.Type type, List<CriterionScore> criteria,
            Optional<DeliveryMetrics> delivery, boolean offTopic) {
        Map<Code, Integer> weights = RubricConfig.llmWeights(type);
        requireExactCriteria(weights.keySet(), criteria);

        BigDecimal llmPoints = BigDecimal.ZERO;
        BigDecimal llmWeightSum = BigDecimal.ZERO;
        for (CriterionScore c : criteria) {
            if (c.score() < 1 || c.score() > 5) {
                throw new IllegalArgumentException("Điểm tiêu chí ngoài 1-5: " + c.code());
            }
            BigDecimal w = BigDecimal.valueOf(weights.get(c.code()));
            llmPoints = llmPoints.add(points(w, BigDecimal.valueOf(c.score())));
            llmWeightSum = llmWeightSum.add(w);
        }

        // Quy về 0-100 trên riêng các tiêu chí LLM; cũng chính là tổng điểm khi chia lại trọng số (w·100/90)
        BigDecimal contentScore = llmPoints.multiply(HUNDRED).divide(llmWeightSum, PRECISION);
        BigDecimal total;
        if (delivery.isPresent()) {
            total = llmPoints.add(points(BigDecimal.valueOf(RubricConfig.DELIVERY_WEIGHT),
                    delivery.get().deliveryScore()));
        } else {
            total = contentScore;
        }
        if (offTopic && total.compareTo(OFF_TOPIC_CAP) > 0) {
            total = OFF_TOPIC_CAP;
        }
        return new ScoreOutcome(round(total), round(contentScore));
    }

    // w·(s−1)/4: điểm 1 ứng 0%, điểm 5 ứng 100% trọng số
    private static BigDecimal points(BigDecimal weight, BigDecimal score) {
        return weight.multiply(score.subtract(BigDecimal.ONE)).divide(FOUR, PRECISION);
    }

    private static BigDecimal round(BigDecimal value) {
        return value.setScale(1, RoundingMode.HALF_UP);
    }

    private static void requireExactCriteria(Set<Code> expected, List<CriterionScore> criteria) {
        Set<Code> actual = EnumSet.noneOf(Code.class);
        for (CriterionScore c : criteria) {
            if (!actual.add(c.code())) {
                throw new IllegalArgumentException("Trùng tiêu chí: " + c.code());
            }
        }
        if (!actual.equals(expected)) {
            throw new IllegalArgumentException("Bộ tiêu chí không khớp loại câu hỏi: " + actual);
        }
    }
}
