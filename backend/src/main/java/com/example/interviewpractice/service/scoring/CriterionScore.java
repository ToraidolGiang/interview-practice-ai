package com.example.interviewpractice.service.scoring;

import com.example.interviewpractice.entity.ScoreCriterion.Code;

/**
 * Điểm một tiêu chí do LLM chấm (đã qua kiểm tra schema): điểm nguyên 1-5, lý do, trích dẫn từ transcript.
 * quoteInvalid do bước kiểm tra trích dẫn đặt sau; LLM không tự trả trường này.
 */
public record CriterionScore(Code code, int score, String reasoning, String quote, boolean quoteInvalid) {
}
