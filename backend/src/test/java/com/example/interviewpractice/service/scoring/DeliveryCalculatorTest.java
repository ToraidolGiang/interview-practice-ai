package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.text.Normalizer;
import java.util.Collections;
import java.util.List;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

class DeliveryCalculatorTest {

    private final DeliveryCalculator calculator = new DeliveryCalculator();

    /** Câu trả lời n từ, không có từ đệm và không lặp từ liền kề. */
    private static String plainWords(int n) {
        String[] vocab = {"tôi", "đã", "phân", "tích", "nguyên", "nhân", "sự", "cố", "và", "khắc", "phục"};
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) {
            sb.append(vocab[i % vocab.length]).append(' ');
        }
        return sb.toString().strip();
    }

    @Nested
    class KhongDuDuLieu {

        @Test
        void duoi30TuThiTraVeRong() {
            assertThat(calculator.calculate(plainWords(29), 60.0)).isEmpty();
        }

        @Test
        void du30TuThiCoKetQua() {
            assertThat(calculator.calculate(plainWords(30), 60.0)).isPresent();
        }

        @Test
        void thieuHoacSaiThoiLuongThiTraVeRong() {
            assertThat(calculator.calculate(plainWords(100), null)).isEmpty();
            assertThat(calculator.calculate(plainWords(100), 0.0)).isEmpty();
            assertThat(calculator.calculate(plainWords(100), -5.0)).isEmpty();
            assertThat(calculator.calculate(plainWords(100), Double.NaN)).isEmpty();
        }

        @Test
        void transcriptRongThiTraVeRong() {
            assertThat(calculator.calculate(null, 60.0)).isEmpty();
            assertThat(calculator.calculate("   ", 60.0)).isEmpty();
        }
    }

    @Nested
    class TachTu {

        @Test
        void boDauCauVaChuanHoaChuThuong() {
            assertThat(DeliveryCalculator.tokenize("Ừm, tôi... đã LÀM xong!  "))
                    .containsExactly("ừm", "tôi", "đã", "làm", "xong");
        }

        @Test
        void tokenChiCoDauCauKhongTinhLaTu() {
            assertThat(DeliveryCalculator.tokenize("tôi - đã ... làm")).containsExactly("tôi", "đã", "làm");
        }

        @Test
        void chuanHoaUnicodeDangToHop() {
            // STT có thể trả chữ tiếng Việt dạng tổ hợp (NFD)
            String nfd = Normalizer.normalize("ừm kiểu như", Normalizer.Form.NFD);
            assertThat(DeliveryCalculator.countFillers(DeliveryCalculator.tokenize(nfd))).isEqualTo(2);
        }
    }

    @Nested
    class DemTuDem {

        private int count(String text) {
            return DeliveryCalculator.countFillers(DeliveryCalculator.tokenize(text));
        }

        @Test
        void tuDemDon() {
            assertThat(count("ừm tôi ờ nghĩ ơ là hmm được")).isEqualTo(4);
        }

        @Test
        void cumTuDemTinhMotLan() {
            assertThat(count("à ừm tôi kiểu như là nói chung là ổn kiểu là vậy")).isEqualTo(4);
        }

        @Test
        void khongDemThiLaMa() {
            assertThat(count("nếu vậy thì tôi là người mà ai cũng tin")).isZero();
        }

        @Test
        void lapTuLienKe() {
            assertThat(count("tôi tôi nghĩ là là đúng")).isEqualTo(2);
            assertThat(count("rất rất rất tốt")).isEqualTo(2);
        }

        @Test
        void tuDemLapKhongTinhThemLanLap() {
            assertThat(count("ừm ừm tôi")).isEqualTo(2);
        }

        @Test
        void lapTuSauCumTuDem() {
            assertThat(count("kiểu như như vậy")).isEqualTo(2);
        }

        @Test
        void lapTuQuaDauCauVanTinh() {
            assertThat(count("tôi, tôi nghĩ")).isEqualTo(1);
        }
    }

    @Nested
    class DiemTocDo {

        @ParameterizedTest
        @CsvSource({
            "100,5", "135,5", "170,5",
            "80,4", "99,4", "171,4", "190,4",
            "60,3", "79,3", "191,3", "210,3",
            "40,2", "59,2", "211,2", "240,2",
            "0,1", "39,1", "241,1", "400,1"
        })
        void theoDai(int wpm, int expected) {
            assertThat(DeliveryCalculator.wpmScore(wpm)).isEqualTo(expected);
        }
    }

    @Nested
    class DiemTuDem {

        @ParameterizedTest
        @CsvSource({
            "0,5", "2.00,5",
            "2.01,4", "4.00,4",
            "4.01,3", "6.00,3",
            "6.01,2", "9.00,2",
            "9.01,1", "25,1"
        })
        void theoNguong(String rate, int expected) {
            assertThat(DeliveryCalculator.fillerScore(new BigDecimal(rate))).isEqualTo(expected);
        }
    }

    @Nested
    class TinhTongHop {

        @Test
        void cauTraLoiChuanDat5Diem() {
            // 260 từ trong 2 phút = 130 WPM, không từ đệm
            DeliveryMetrics m = calculator.calculate(plainWords(260), 120.0).orElseThrow();

            assertThat(m.wordCount()).isEqualTo(260);
            assertThat(m.wpm()).isEqualTo(130);
            assertThat(m.fillerCount()).isZero();
            assertThat(m.fillerRate()).isEqualByComparingTo("0");
            assertThat(m.deliveryScore()).isEqualByComparingTo("5.00");
            assertThat(m.fillerListVersion()).isEqualTo("filler-vi-v1");
        }

        @Test
        void noiNhanhVaNhieuTuDem() {
            // 95 từ thường + 5 "ừm" = 100 từ trong 30 giây = 200 WPM (3 điểm); 5/100 = 5% (3 điểm)
            String transcript = plainWords(95) + " ừm ừm ừm ừm ừm";
            DeliveryMetrics m = calculator.calculate(transcript, 30.0).orElseThrow();

            assertThat(m.wpm()).isEqualTo(200);
            assertThat(m.fillerCount()).isEqualTo(5);
            assertThat(m.fillerRate()).isEqualByComparingTo("5.00");
            assertThat(m.deliveryScore()).isEqualByComparingTo("3.00");
        }

        @Test
        void diemLeKhiHaiThanhPhanKhacNhau() {
            // 100 từ trong 60 giây = 100 WPM (5 điểm); 3 từ đệm / 100 = 3% (4 điểm) => 4.5
            String transcript = plainWords(97) + " ờ ơ hmm";
            DeliveryMetrics m = calculator.calculate(transcript, 60.0).orElseThrow();

            assertThat(m.wpm()).isEqualTo(100);
            assertThat(m.fillerRate()).isEqualByComparingTo("3.00");
            assertThat(m.deliveryScore()).isEqualByComparingTo("4.50");
        }

        @Test
        void tyLeTuDemLamTronHaiChuSo() {
            // 1 từ đệm / 31 từ = 3.2258% => 3.23
            DeliveryMetrics m = calculator.calculate(plainWords(30) + " ừm", 15.0).orElseThrow();
            assertThat(m.fillerRate()).isEqualByComparingTo("3.23");
        }

        @Test
        void diemLuonTrongKhoang1Den5() {
            String noisy = String.join(" ", Collections.nCopies(60, "ừm"));
            DeliveryMetrics m = calculator.calculate(noisy, 5.0).orElseThrow();
            assertThat(m.deliveryScore()).isEqualByComparingTo("1.00");

            List<Double> durations = List.of(1.0, 10.0, 45.5, 180.0, 3600.0);
            for (double d : durations) {
                BigDecimal score = calculator.calculate(plainWords(120), d).orElseThrow().deliveryScore();
                assertThat(score).isBetween(BigDecimal.ONE, BigDecimal.valueOf(5));
            }
        }
    }
}
