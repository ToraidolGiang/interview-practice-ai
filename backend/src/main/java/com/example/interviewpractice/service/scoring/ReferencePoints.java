package com.example.interviewpractice.service.scoring;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Tách đáp án tham chiếu (reference_answer) thành các ý để đối chiếu. Mỗi dòng không rỗng là một ý; tiền tố gạch
 * đầu dòng ("-", "*", "•", "1.", "1)") được bỏ. Tối đa {@value #MAX_POINTS} ý, phần dư bị bỏ để schema LLM gọn.
 */
public final class ReferencePoints {

    public static final int MAX_POINTS = 10;

    private static final Pattern BULLET = Pattern.compile("^\\s*(?:[-*•–]|\\d{1,2}[.)])\\s*");

    private ReferencePoints() {
    }

    /** @return danh sách ý theo thứ tự, rỗng khi đáp án null hoặc trắng */
    public static List<String> parse(String referenceAnswer) {
        if (referenceAnswer == null || referenceAnswer.isBlank()) {
            return List.of();
        }
        List<String> points = new ArrayList<>();
        for (String line : referenceAnswer.split("\\R")) {
            String point = BULLET.matcher(line).replaceFirst("").strip();
            if (!point.isEmpty()) {
                points.add(point);
                if (points.size() == MAX_POINTS) {
                    break;
                }
            }
        }
        return List.copyOf(points);
    }
}
