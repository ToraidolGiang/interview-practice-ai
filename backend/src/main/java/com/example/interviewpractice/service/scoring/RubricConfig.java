package com.example.interviewpractice.service.scoring;

import java.util.Collections;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;

/**
 * Bộ tiêu chí và trọng số theo loại câu hỏi (docs/business/Rubric_Cham_Diem.md mục 4).
 * Trọng số của tiêu chí do LLM chấm; Delivery tính riêng bằng code với trọng số {@link #DELIVERY_WEIGHT}.
 * Tổng trọng số LLM + Delivery của mỗi loại luôn bằng 100.
 */
public final class RubricConfig {

    public static final String RUBRIC_VERSION = "rubric-v1.0";
    public static final String PROMPT_VERSION = "prompt-v1";

    /** Trọng số Delivery; khi thiếu dữ liệu Delivery thì phần này chia lại theo tỷ lệ cho tiêu chí còn lại. */
    public static final int DELIVERY_WEIGHT = 10;

    // Thứ tự khóa trong từng map (theo thứ tự enum Code) cũng là thứ tự hiển thị tiêu chí
    private static final Map<Question.Type, Map<Code, Integer>> LLM_WEIGHTS = new EnumMap<>(Question.Type.class);

    static {
        LLM_WEIGHTS.put(Question.Type.BEHAVIORAL, weights(20, 30, 40, 0));
        LLM_WEIGHTS.put(Question.Type.SITUATIONAL, weights(25, 25, 40, 0));
        LLM_WEIGHTS.put(Question.Type.TECHNICAL, weights(15, 15, 25, 35));
        LLM_WEIGHTS.put(Question.Type.INTRO, weights(25, 30, 35, 0));
    }

    private RubricConfig() {
    }

    // correctness bằng 0 nghĩa là loại câu hỏi này không có tiêu chí CORRECTNESS
    private static Map<Code, Integer> weights(int relevance, int structure, int depth, int correctness) {
        Map<Code, Integer> map = new EnumMap<>(Code.class);
        map.put(Code.RELEVANCE, relevance);
        map.put(Code.STRUCTURE, structure);
        map.put(Code.DEPTH, depth);
        if (correctness > 0) {
            map.put(Code.CORRECTNESS, correctness);
        }
        return Collections.unmodifiableMap(map);
    }

    /** Trọng số gốc (chưa chia lại) của các tiêu chí LLM chấm, theo thứ tự hiển thị. */
    public static Map<Code, Integer> llmWeights(Question.Type type) {
        return LLM_WEIGHTS.get(type);
    }

    /** Mã các tiêu chí LLM phải chấm cho loại câu hỏi này. */
    public static List<Code> llmCodes(Question.Type type) {
        return List.copyOf(LLM_WEIGHTS.get(type).keySet());
    }
}
