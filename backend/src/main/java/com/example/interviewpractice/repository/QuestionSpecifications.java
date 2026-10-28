package com.example.interviewpractice.repository;

import java.util.Locale;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import com.example.interviewpractice.entity.Question;

/** Các điều kiện lọc câu hỏi; điều kiện nào không dùng thì không đưa vào truy vấn. */
public final class QuestionSpecifications {

    /** Vị trí dùng chung của mọi vị trí trong một ngành (taxonomy-v1.0). */
    public static final String COMMON_POSITION = "Chung";
    public static final int MAX_KEYWORD_LENGTH = 200;

    /** Mới nhất trước, thêm id để thứ tự ổn định giữa các trang. */
    public static final Sort NEWEST_FIRST = Sort.by(Sort.Order.desc("createdAt"), Sort.Order.asc("id"));

    private static final char ESCAPE = '\\';

    private QuestionSpecifications() {
    }

    /** Ghép thêm điều kiện nếu có; Specification.and không nhận null nên điều kiện tùy chọn đi qua đây. */
    public static Specification<Question> andIf(Specification<Question> base, Specification<Question> optional) {
        return optional == null ? base : base.and(optional);
    }

    public static Specification<Question> any() {
        return (root, query, cb) -> cb.conjunction();
    }

    public static Specification<Question> hasStatus(Question.Status status) {
        return (root, query, cb) -> cb.equal(root.get("status"), status);
    }

    public static Specification<Question> hasIndustry(String industry) {
        return (root, query, cb) -> cb.equal(root.get("industry"), industry);
    }

    /**
     * Có ngành thì lấy cả câu vị trí Chung của ngành đó (position IN (:position, 'Chung'));
     * không có ngành thì khớp đúng vị trí.
     */
    public static Specification<Question> hasPosition(String position, boolean includeCommon) {
        return (root, query, cb) -> includeCommon
                ? root.get("position").in(position, COMMON_POSITION)
                : cb.equal(root.get("position"), position);
    }

    public static Specification<Question> hasLevel(Question.Level level) {
        return (root, query, cb) -> cb.equal(root.get("level"), level);
    }

    public static Specification<Question> hasType(Question.Type type) {
        return (root, query, cb) -> cb.equal(root.get("questionType"), type);
    }

    /** Không phân biệt hoa thường; '%', '_' và '\' trong từ khóa là ký tự thường. */
    public static Specification<Question> contentContains(String keyword) {
        String pattern = "%" + escapeLike(keyword.toLowerCase(Locale.ROOT)) + "%";
        return (root, query, cb) -> cb.like(cb.lower(root.get("content")), pattern, ESCAPE);
    }

    static String escapeLike(String raw) {
        StringBuilder sb = new StringBuilder(raw.length() + 4);
        for (char c : raw.toCharArray()) {
            if (c == ESCAPE || c == '%' || c == '_') {
                sb.append(ESCAPE);
            }
            sb.append(c);
        }
        return sb.toString();
    }
}
