package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.jupiter.api.Test;

class ReferencePointsTest {

    @Test
    void tachTheoDongVaBoTienToGachDauDong() {
        String ref = "- Độ sâu tối đa của cây\n- Số mẫu tối thiểu để chia nút\n* Gini hoặc entropy\n• Số đặc trưng tối đa\n";
        assertThat(ReferencePoints.parse(ref)).containsExactly("Độ sâu tối đa của cây",
                "Số mẫu tối thiểu để chia nút", "Gini hoặc entropy", "Số đặc trưng tối đa");
    }

    @Test
    void boSoThuTuVaDongTrangVaChapNhanXuongDongKieuWindows() {
        assertThat(ReferencePoints.parse("1. Một ý\r\n\r\n2) Hai ý\r\n  3. Ba ý "))
                .containsExactly("Một ý", "Hai ý", "Ba ý");
    }

    @Test
    void khongCoGachDauDongThiMoiDongMotY() {
        assertThat(ReferencePoints.parse("Ý thứ nhất\nÝ thứ hai")).hasSize(2);
        assertThat(ReferencePoints.parse("Chỉ một ý duy nhất")).containsExactly("Chỉ một ý duy nhất");
    }

    @Test
    void nullHoacTrangThiRong() {
        assertThat(ReferencePoints.parse(null)).isEmpty();
        assertThat(ReferencePoints.parse("  \n \n")).isEmpty();
    }

    @Test
    void toiDaMuoiY() {
        String ref = String.join("\n", IntStream.rangeClosed(1, 14).mapToObj(i -> "- ý " + i).toList());
        List<String> points = ReferencePoints.parse(ref);
        assertThat(points).hasSize(ReferencePoints.MAX_POINTS);
        assertThat(points.get(9)).isEqualTo("ý 10");
    }
}
