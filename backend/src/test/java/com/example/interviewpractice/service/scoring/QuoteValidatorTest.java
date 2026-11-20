package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.entity.ScoreCriterion.Code;

class QuoteValidatorTest {

    private static final String TRANSCRIPT = "Lúc đó, nhóm bị trễ tiến độ hai tuần! Tôi đã chia lại việc.";

    private final QuoteValidator validator = new QuoteValidator();

    private static CriterionScore score(int score, String quote) {
        return new CriterionScore(Code.DEPTH, score, "r", quote, false);
    }

    private CriterionScore checkOne(int score, String quote) {
        return validator.check(List.of(score(score, quote)), TRANSCRIPT).criteria().get(0);
    }

    @Test
    void quoteNguyenVanGiuDiem() {
        CriterionScore c = checkOne(4, "nhóm bị trễ tiến độ hai tuần");
        assertThat(c.score()).isEqualTo(4);
        assertThat(c.quoteInvalid()).isFalse();
    }

    @Test
    void khacHoaThuongKhoangTrangVaDauCauVanHopLe() {
        assertThat(checkOne(5, "  LÚC   ĐÓ nhóm,  bị trễ -- tiến độ... ").quoteInvalid()).isFalse();
        assertThat(checkOne(3, "Tiến độ hai tuần. Tôi đã chia lại việc").score()).isEqualTo(3);
    }

    @Test
    void khacDangDungSanUnicodeVanHopLe() {
        // "ó" dạng tổ hợp (o + dấu sắc) so với dạng dựng sẵn trong transcript
        assertThat(checkOne(4, "nhóm bị trễ").quoteInvalid()).isFalse();
    }

    @Test
    void quoteBiaBiHaVeHaiVaGanCo() {
        CriterionScore c = checkOne(4, "chúng tôi đã tăng doanh thu gấp ba");
        assertThat(c.score()).isEqualTo(2);
        assertThat(c.quoteInvalid()).isTrue();
    }

    @Test
    void diemBaTroLenThieuQuoteBiHa() {
        assertThat(checkOne(3, null).score()).isEqualTo(2);
        assertThat(checkOne(5, "").quoteInvalid()).isTrue();
        assertThat(checkOne(3, " ... ").quoteInvalid()).isTrue();
    }

    @Test
    void diemMotHaiGiuNguyenKeCaQuoteSai() {
        CriterionScore low = checkOne(2, "bịa hoàn toàn");
        assertThat(low.score()).isEqualTo(2);
        assertThat(low.quoteInvalid()).isFalse();
        assertThat(checkOne(1, null).score()).isEqualTo(1);
    }

    @Test
    void demSoTieuChiBiHaVaNguongQuaNua() {
        List<CriterionScore> list = List.of(score(4, "nhóm bị trễ"), score(4, "bịa"), score(3, "bịa nữa"),
                score(2, "bịa"));

        QuoteValidator.Checked checked = validator.check(list, TRANSCRIPT);

        assertThat(checked.invalidCount()).isEqualTo(2);
        assertThat(checked.moreThanHalfInvalid()).isFalse(); // 2/4 đúng một nửa
        assertThat(validator.check(List.of(score(4, "bịa"), score(4, "bịa"), score(4, "nhóm")), TRANSCRIPT)
                .moreThanHalfInvalid()).isTrue();
    }

    @Test
    void transcriptRongThiMoiQuoteDeuSai() {
        assertThat(validator.check(List.of(score(4, "abc")), null).criteria().get(0).quoteInvalid()).isTrue();
    }
}
