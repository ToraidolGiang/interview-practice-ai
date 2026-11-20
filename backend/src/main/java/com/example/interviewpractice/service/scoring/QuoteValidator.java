package com.example.interviewpractice.service.scoring;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

/**
 * Kiểm trích dẫn LLM trả về có thật sự nằm trong transcript (Rubric_Cham_Diem.md mục 6, quy tắc 2).
 * Chuẩn hóa cả hai phía: Unicode NFC, chữ thường, dấu câu thành khoảng trắng, gộp khoảng trắng; rồi kiểm chuỗi con.
 * Tiêu chí điểm từ 3 trở lên mà trích dẫn không hợp lệ bị hạ về 2 và gắn quoteInvalid; điểm 1-2 giữ nguyên.
 */
@Component
public class QuoteValidator {

    /** Điểm tối thiểu bắt buộc phải có trích dẫn hợp lệ. */
    static final int MIN_SCORE_REQUIRING_QUOTE = 3;
    /** Điểm sau khi bị hạ vì trích dẫn không hợp lệ. */
    static final int DOWNGRADED_SCORE = 2;

    // Mọi ký tự không phải chữ/số (dấu câu, ký hiệu, khoảng trắng lạ) đều thành một khoảng trắng
    private static final Pattern NON_WORD = Pattern.compile("[^\\p{L}\\p{N}]+");

    /**
     * Kết quả kiểm: danh sách tiêu chí đã áp dụng hạ điểm và số tiêu chí bị hạ.
     * Chứa trích dẫn của thí sinh nên toString bị ẩn để không lọt vào log.
     */
    public record Checked(List<CriterionScore> criteria, int invalidCount) {

        /** Hơn một nửa số tiêu chí có trích dẫn không hợp lệ (đúng một nửa thì chưa tính). */
        public boolean moreThanHalfInvalid() {
            return invalidCount * 2 > criteria.size();
        }

        @Override
        public String toString() {
            return "Checked[invalidCount=" + invalidCount + "]";
        }
    }

    public Checked check(List<CriterionScore> criteria, String transcript) {
        String haystack = normalize(transcript);
        List<CriterionScore> result = new ArrayList<>(criteria.size());
        int invalid = 0;
        for (CriterionScore c : criteria) {
            if (c.score() >= MIN_SCORE_REQUIRING_QUOTE && !isValid(c.quote(), haystack)) {
                result.add(new CriterionScore(c.code(), DOWNGRADED_SCORE, c.reasoning(), c.quote(), true));
                invalid++;
            } else {
                result.add(c);
            }
        }
        return new Checked(List.copyOf(result), invalid);
    }

    // Trích dẫn rỗng sau chuẩn hóa không phải bằng chứng (chuỗi rỗng là chuỗi con của mọi chuỗi)
    private static boolean isValid(String quote, String normalizedTranscript) {
        String q = normalize(quote);
        return !q.isEmpty() && normalizedTranscript.contains(q);
    }

    static String normalize(String text) {
        if (text == null) {
            return "";
        }
        String nfc = Normalizer.normalize(text, Normalizer.Form.NFC).toLowerCase(Locale.ROOT);
        return NON_WORD.matcher(nfc).replaceAll(" ").trim();
    }
}
