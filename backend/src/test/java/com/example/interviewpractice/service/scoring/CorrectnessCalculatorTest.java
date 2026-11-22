package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.ScorePoint.Verdict;

class CorrectnessCalculatorTest {

    private final CorrectnessCalculator calculator = new CorrectnessCalculator();

    private static List<PointScore> points(Verdict... verdicts) {
        List<PointScore> list = new ArrayList<>();
        for (int i = 0; i < verdicts.length; i++) {
            list.add(new PointScore(i + 1, "ý " + (i + 1), verdicts[i], "q", "n", false));
        }
        return list;
    }

    @Test
    void duMoiYLaNamDiem() {
        assertThat(calculator.score(points(Verdict.COVERED, Verdict.COVERED, Verdict.COVERED, Verdict.COVERED,
                Verdict.COVERED))).isEqualTo(5);
    }

    @Test
    void khongNeuYNaoLaMotDiem() {
        assertThat(calculator.score(points(Verdict.MISSING, Verdict.MISSING, Verdict.MISSING))).isEqualTo(1);
    }

    @Test
    void thieuMotTrongNamYLaBonDiem() {
        // 4/5 = 0.8 -> 1 + round(3.2) = 4
        assertThat(calculator.score(points(Verdict.COVERED, Verdict.COVERED, Verdict.COVERED, Verdict.COVERED,
                Verdict.MISSING))).isEqualTo(4);
    }

    @Test
    void nuaSoYLaBaDiem() {
        assertThat(calculator.score(points(Verdict.COVERED, Verdict.MISSING))).isEqualTo(3);
    }

    @Test
    void neuThieuTinhNuaY() {
        // (1 + 0.5 + 0.5) / 4 = 0.5 -> 3
        assertThat(calculator.score(points(Verdict.COVERED, Verdict.PARTIAL, Verdict.PARTIAL, Verdict.MISSING)))
                .isEqualTo(3);
    }

    @Test
    void neuSaiBiTruNangHonBoSot() {
        int missing = calculator.score(points(Verdict.COVERED, Verdict.COVERED, Verdict.MISSING, Verdict.MISSING));
        int incorrect = calculator.score(points(Verdict.COVERED, Verdict.COVERED, Verdict.INCORRECT,
                Verdict.INCORRECT));
        assertThat(missing).isEqualTo(3);
        assertThat(incorrect).isEqualTo(2);
    }

    @Test
    void khongXuongDuoiMotDiemKhiSaiNhieu() {
        assertThat(calculator.score(points(Verdict.INCORRECT, Verdict.INCORRECT))).isEqualTo(1);
    }

    @Test
    void moiLoiKienThucTruNuaY() {
        List<PointScore> full = points(Verdict.COVERED, Verdict.COVERED, Verdict.COVERED, Verdict.COVERED);
        assertThat(calculator.score(full, 0)).isEqualTo(5);
        assertThat(calculator.score(full, 1)).isEqualTo(5); // 3,5/4 = 0,875 -> 1 + round(3,5) = 5
        assertThat(calculator.score(full, 2)).isEqualTo(4); // 3/4 -> 4
        assertThat(calculator.score(full, 4)).isEqualTo(3); // 2/4 -> 3
    }

    @Test
    void nhieuLoiKhongXuongDuoiMotDiemVaLoiAmBiTuChoi() {
        List<PointScore> one = points(Verdict.COVERED);
        assertThat(calculator.score(one, 5)).isEqualTo(1);
        assertThatThrownBy(() -> calculator.score(one, -1)).isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void khongCoYNaoThiLoi() {
        assertThatThrownBy(() -> calculator.score(List.of())).isInstanceOf(IllegalArgumentException.class);
    }
}
