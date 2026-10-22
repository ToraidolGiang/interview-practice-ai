package com.example.interviewpractice.service.scoring;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

/**
 * Tính Delivery (tốc độ nói + từ đệm) bằng code, không dùng LLM.
 * Quy tắc theo docs/business/Rubric_Cham_Diem.md mục 5; thông số là giá trị khởi đầu,
 * sẽ chỉnh khi hiệu chỉnh ở #159 (đổi danh sách từ đệm thì tăng FILLER_LIST_VERSION).
 */
@Component
public class DeliveryCalculator {

    public static final String FILLER_LIST_VERSION = "filler-vi-v1";

    /** Dưới ngưỡng này không đủ dữ liệu Delivery: trả về rỗng và trọng số chia lại cho tiêu chí khác. */
    public static final int MIN_WORDS_FOR_DELIVERY = 30;

    // Cụm từ đệm nhiều từ, xét trước từ đơn để "à ừm" chỉ tính 1 lần
    private static final List<String[]> FILLER_PHRASES = List.of(
            new String[] {"nói", "chung", "là"},
            new String[] {"à", "ừm"},
            new String[] {"kiểu", "như"},
            new String[] {"kiểu", "là"});

    // Không đếm "thì", "là", "mà" vì là từ thông dụng trong tiếng Việt
    private static final Set<String> FILLER_WORDS = Set.of("ừm", "ờ", "ơ", "hmm");

    // Dấu câu ở đầu/cuối token (STT thường trả "ừm," hoặc "...ờ")
    private static final Pattern EDGE_PUNCTUATION = Pattern.compile("^[\\p{P}\\p{S}]+|[\\p{P}\\p{S}]+$");
    private static final Pattern WHITESPACE = Pattern.compile("\\s+");

    /**
     * @param transcript      transcript nguyên văn (verbatim) từ STT
     * @param durationSeconds thời lượng ghi âm (giây)
     * @return rỗng khi transcript dưới 30 từ hoặc không có thời lượng hợp lệ
     */
    public Optional<DeliveryMetrics> calculate(String transcript, Double durationSeconds) {
        if (durationSeconds == null || !(durationSeconds > 0)) {
            return Optional.empty();
        }
        List<String> words = tokenize(transcript);
        if (words.size() < MIN_WORDS_FOR_DELIVERY) {
            return Optional.empty();
        }

        int wordCount = words.size();
        int wpm = (int) Math.round(wordCount / (durationSeconds / 60.0));
        int fillerCount = countFillers(words);
        BigDecimal fillerRate = BigDecimal.valueOf(fillerCount * 100.0 / wordCount)
                .setScale(2, RoundingMode.HALF_UP);

        int wpmScore = wpmScore(wpm);
        int fillerScore = fillerScore(fillerRate);
        BigDecimal deliveryScore = BigDecimal.valueOf(0.5 * wpmScore + 0.5 * fillerScore)
                .setScale(2, RoundingMode.HALF_UP);

        return Optional.of(new DeliveryMetrics(
                wordCount, wpm, fillerCount, fillerRate, deliveryScore, FILLER_LIST_VERSION));
    }

    /** Tách từ theo khoảng trắng, bỏ dấu câu ở hai đầu, chuẩn hoá Unicode NFC và chữ thường. */
    static List<String> tokenize(String transcript) {
        List<String> words = new ArrayList<>();
        if (transcript == null || transcript.isBlank()) {
            return words;
        }
        String normalized = Normalizer.normalize(transcript, Normalizer.Form.NFC).toLowerCase(Locale.ROOT);
        for (String raw : WHITESPACE.split(normalized.strip())) {
            String word = EDGE_PUNCTUATION.matcher(raw).replaceAll("");
            if (!word.isEmpty()) {
                words.add(word);
            }
        }
        return words;
    }

    /**
     * Đếm từ đệm: cụm trong FILLER_PHRASES (mỗi cụm tính 1), từ trong FILLER_WORDS,
     * và lặp từ liền kề ("tôi tôi" tính 1 cho lần lặp). Từ đệm lặp ("ừm ừm") chỉ tính theo từ đệm, không tính thêm lần lặp.
     */
    static int countFillers(List<String> words) {
        int count = 0;
        int i = 0;
        while (i < words.size()) {
            int phraseLength = matchPhrase(words, i);
            if (phraseLength > 0) {
                count++;
                i += phraseLength;
                continue;
            }
            String word = words.get(i);
            if (FILLER_WORDS.contains(word)) {
                count++;
            } else if (i > 0 && word.equals(words.get(i - 1))) {
                count++;
            }
            i++;
        }
        return count;
    }

    private static int matchPhrase(List<String> words, int start) {
        for (String[] phrase : FILLER_PHRASES) {
            if (start + phrase.length > words.size()) {
                continue;
            }
            boolean matches = true;
            for (int k = 0; k < phrase.length; k++) {
                if (!phrase[k].equals(words.get(start + k))) {
                    matches = false;
                    break;
                }
            }
            if (matches) {
                return phrase.length;
            }
        }
        return 0;
    }

    static int wpmScore(int wpm) {
        if (wpm >= 100 && wpm <= 170) {
            return 5;
        }
        if ((wpm >= 80 && wpm <= 99) || (wpm >= 171 && wpm <= 190)) {
            return 4;
        }
        if ((wpm >= 60 && wpm <= 79) || (wpm >= 191 && wpm <= 210)) {
            return 3;
        }
        if ((wpm >= 40 && wpm <= 59) || (wpm >= 211 && wpm <= 240)) {
            return 2;
        }
        return 1;
    }

    static int fillerScore(BigDecimal fillerRate) {
        double rate = fillerRate.doubleValue();
        if (rate <= 2) {
            return 5;
        }
        if (rate <= 4) {
            return 4;
        }
        if (rate <= 6) {
            return 3;
        }
        if (rate <= 9) {
            return 2;
        }
        return 1;
    }
}
