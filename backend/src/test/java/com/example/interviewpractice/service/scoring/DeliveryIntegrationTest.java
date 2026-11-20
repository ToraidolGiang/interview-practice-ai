package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;

/** Kiểm tích hợp Delivery vào chấm điểm qua cổng DeliveryMetricsProvider (logic tính nằm ở DeliveryCalculatorTest). */
class DeliveryIntegrationTest {

    private static final List<CriterionScore> CRITERIA = List.of(
            new CriterionScore(Code.RELEVANCE, 4, "r", "q", false),
            new CriterionScore(Code.STRUCTURE, 3, "r", "q", false),
            new CriterionScore(Code.DEPTH, 3, "r", "q", false));

    private final ScoreCalculator calculator = new ScoreCalculator();

    // Mỗi lần lặp là 5 từ
    private static String words(int repeats) {
        return "tôi đã phân tích nguyên nhân ".repeat(repeats).strip();
    }

    @Test
    void stubCoMetricsThiTongDiemGomDeliveryVaGiuPhienBanDanhSachTuDem() {
        DeliveryMetrics metrics = new DeliveryMetrics(120, 128, 6, new BigDecimal("4.10"), new BigDecimal("4.0"),
                DeliveryCalculator.FILLER_LIST_VERSION);
        DeliveryMetricsProvider provider = new StubDeliveryMetricsProvider(Optional.of(metrics));

        Optional<DeliveryMetrics> got = provider.calculate("bất kỳ", 60.0);

        assertThat(got).get().extracting(DeliveryMetrics::fillerListVersion).isEqualTo("filler-vi-v1");
        assertThat(calculator.calculate(Question.Type.BEHAVIORAL, CRITERIA, got, false).totalScore())
                .isEqualByComparingTo("57.5");
    }

    @Test
    void stubRongThiChiaLaiTrongSoVaKhongCoPhienBanDanhSachTuDem() {
        DeliveryMetricsProvider provider = new StubDeliveryMetricsProvider(Optional.empty());

        Optional<DeliveryMetrics> got = provider.calculate("bất kỳ", null);

        assertThat(got).isEmpty();
        assertThat(calculator.calculate(Question.Type.BEHAVIORAL, CRITERIA, got, false).totalScore())
                .isEqualByComparingTo("55.6");
    }

    @Test
    void adapterThatTraFillerViV1KhiDuDuLieuVaRongKhiTranscriptNganHoacThieuThoiLuong() {
        DeliveryMetricsProvider provider = new DeliveryCalculatorAdapter(new DeliveryCalculator());

        assertThat(provider.calculate(words(8), 30.0)).get()
                .extracting(DeliveryMetrics::fillerListVersion).isEqualTo("filler-vi-v1");
        assertThat(provider.calculate(words(2), 30.0)).isEmpty();
        assertThat(provider.calculate(words(8), null)).isEmpty();
    }
}
