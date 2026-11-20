package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;

class ScoreCalculatorTest {

    private final ScoreCalculator calculator = new ScoreCalculator();

    private static CriterionScore c(Code code, int score) {
        return new CriterionScore(code, score, "lý do", "trích dẫn", false);
    }

    private static Optional<DeliveryMetrics> delivery(String score) {
        return Optional.of(new DeliveryMetrics(120, 128, 6, new BigDecimal("4.10"), new BigDecimal(score),
                DeliveryCalculator.FILLER_LIST_VERSION));
    }

    private static List<CriterionScore> behavioral(int relevance, int structure, int depth) {
        return List.of(c(Code.RELEVANCE, relevance), c(Code.STRUCTURE, structure), c(Code.DEPTH, depth));
    }

    @Test
    void viDuOpenApiChoDiem57Phay5VaContent55Phay6() {
        ScoreOutcome out = calculator.calculate(Question.Type.BEHAVIORAL, behavioral(4, 3, 3), delivery("4.0"),
                false);
        assertThat(out.totalScore()).isEqualByComparingTo("57.5");
        assertThat(out.contentScore()).isEqualByComparingTo("55.6");
    }

    @Test
    void thieuDeliveryThiChiaLaiTrongSoTheoMuoiPhanChin() {
        // 50 điểm trên 90 trọng số -> 50·100/90 = 55.6
        ScoreOutcome out = calculator.calculate(Question.Type.BEHAVIORAL, behavioral(4, 3, 3), Optional.empty(),
                false);
        assertThat(out.totalScore()).isEqualByComparingTo("55.6");
        assertThat(out.contentScore()).isEqualByComparingTo("55.6");
    }

    @Test
    void contentScoreChiGomTieuChiLlmNenKhongDoiKhiDeliveryDoi() {
        ScoreOutcome low = calculator.calculate(Question.Type.BEHAVIORAL, behavioral(4, 3, 3), delivery("1.0"),
                false);
        ScoreOutcome high = calculator.calculate(Question.Type.BEHAVIORAL, behavioral(4, 3, 3), delivery("5.0"),
                false);
        assertThat(low.contentScore()).isEqualByComparingTo(high.contentScore());
        assertThat(low.totalScore()).isLessThan(high.totalScore());
    }

    @Test
    void toiDaVaToiThieu() {
        assertThat(calculator.calculate(Question.Type.BEHAVIORAL, behavioral(5, 5, 5), delivery("5.0"), false)
                .totalScore()).isEqualByComparingTo("100.0");
        assertThat(calculator.calculate(Question.Type.BEHAVIORAL, behavioral(1, 1, 1), delivery("1.0"), false)
                .totalScore()).isEqualByComparingTo("0.0");
    }

    @Test
    void technicalDungTrongSoCorrectness() {
        List<CriterionScore> criteria = List.of(c(Code.RELEVANCE, 5), c(Code.STRUCTURE, 5), c(Code.DEPTH, 5),
                c(Code.CORRECTNESS, 1));
        // 15 + 15 + 25 + 0 = 55 trên 90 -> 61.1
        assertThat(calculator.calculate(Question.Type.TECHNICAL, criteria, Optional.empty(), false).totalScore())
                .isEqualByComparingTo("61.1");
    }

    @Test
    void offTopicChanTai30ChiKhiTrenNguong() {
        assertThat(calculator.calculate(Question.Type.BEHAVIORAL, behavioral(5, 5, 5), delivery("5.0"), true)
                .totalScore()).isEqualByComparingTo("30.0");
        // Điểm vốn dưới 30 thì giữ nguyên: chỉ còn phần Delivery 10·(5-1)/4 = 10
        assertThat(calculator.calculate(Question.Type.BEHAVIORAL, behavioral(1, 1, 1), delivery("5.0"), true)
                .totalScore()).isEqualByComparingTo("10.0");
    }

    @Test
    void offTopicKhongLamDoiContentScore() {
        ScoreOutcome out = calculator.calculate(Question.Type.BEHAVIORAL, behavioral(5, 5, 5), delivery("5.0"),
                true);
        assertThat(out.contentScore()).isEqualByComparingTo("100.0");
    }

    @Test
    void lamTronHalfUpMotChuSoKhiPhanThapPhanLa75() {
        // INTRO 1,1,3: 35·0.5 = 17.5; delivery 1.1 -> 10·0.1/4 = 0.25 => 17.75 -> HALF_UP 17.8
        ScoreOutcome out = calculator.calculate(Question.Type.INTRO,
                List.of(c(Code.RELEVANCE, 1), c(Code.STRUCTURE, 1), c(Code.DEPTH, 3)), delivery("1.1"), false);
        assertThat(out.totalScore()).isEqualByComparingTo("17.8");
        assertThat(out.totalScore().scale()).isEqualTo(1);
    }

    @Test
    void lamTronXuongKhiPhanThapPhanDuoiNamNam() {
        // SITUATIONAL 3,2,2 không Delivery: (12.5 + 6.25 + 10)·100/90 = 31.944... -> 31.9
        ScoreOutcome out = calculator.calculate(Question.Type.SITUATIONAL,
                List.of(c(Code.RELEVANCE, 3), c(Code.STRUCTURE, 2), c(Code.DEPTH, 2)), Optional.empty(), false);
        assertThat(out.totalScore()).isEqualByComparingTo("31.9");
    }

    @Test
    void thieuHoacThuaTieuChiThiNemLoi() {
        assertThatThrownBy(() -> calculator.calculate(Question.Type.TECHNICAL, behavioral(3, 3, 3),
                Optional.empty(), false)).isInstanceOf(IllegalArgumentException.class);
        List<CriterionScore> extra = List.of(c(Code.RELEVANCE, 3), c(Code.STRUCTURE, 3), c(Code.DEPTH, 3),
                c(Code.CORRECTNESS, 3));
        assertThatThrownBy(() -> calculator.calculate(Question.Type.BEHAVIORAL, extra, Optional.empty(), false))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void diemNgoaiKhoang1Den5ThiNemLoi() {
        assertThatThrownBy(() -> calculator.calculate(Question.Type.BEHAVIORAL, behavioral(6, 3, 3),
                Optional.empty(), false)).isInstanceOf(IllegalArgumentException.class);
    }
}
