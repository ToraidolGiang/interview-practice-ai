package com.example.interviewpractice.service.scoring;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import org.springframework.stereotype.Component;

/**
 * Quy kết quả đối chiếu theo ý về điểm CORRECTNESS nguyên 1-5 (lớp thuần, không I/O), để công thức tổng điểm
 * của Rubric mục 4 giữ nguyên. coverage = (COVERED + 0.5·PARTIAL − 0.5·INCORRECT) / số ý, chặn dưới 0;
 * điểm = 1 + làm tròn(4·coverage). Nêu sai một ý bị trừ nặng hơn bỏ sót.
 * Mỗi phát biểu sai về chuyên môn do lượt kiểm lỗi kiến thức tìm thấy trừ thêm 0,5 vào tử số (như một ý INCORRECT).
 */
@Component
public class CorrectnessCalculator {

    private static final BigDecimal HALF = new BigDecimal("0.5");
    private static final BigDecimal FOUR = BigDecimal.valueOf(4);

    /** @throws IllegalArgumentException khi không có ý nào (không có gì để tính) */
    public int score(List<PointScore> points) {
        return score(points, 0);
    }

    /**
     * @param errorCount số phát biểu sai đã được xác nhận (trích dẫn có trong transcript), không âm
     * @throws IllegalArgumentException khi không có ý nào hoặc errorCount âm
     */
    public int score(List<PointScore> points, int errorCount) {
        if (errorCount < 0) {
            throw new IllegalArgumentException("Số lỗi kiến thức không được âm");
        }
        if (points.isEmpty()) {
            throw new IllegalArgumentException("Không có ý nào để tính điểm CORRECTNESS");
        }
        BigDecimal sum = BigDecimal.ZERO;
        for (PointScore p : points) {
            sum = switch (p.verdict()) {
                case COVERED -> sum.add(BigDecimal.ONE);
                case PARTIAL -> sum.add(HALF);
                case INCORRECT -> sum.subtract(HALF);
                case MISSING -> sum;
            };
        }
        sum = sum.subtract(HALF.multiply(BigDecimal.valueOf(errorCount)));
        BigDecimal coverage = sum.divide(BigDecimal.valueOf(points.size()), 10, RoundingMode.HALF_UP)
                .max(BigDecimal.ZERO);
        return 1 + coverage.multiply(FOUR).setScale(0, RoundingMode.HALF_UP).intValue();
    }
}
