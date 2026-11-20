package com.example.interviewpractice.service.scoring;

import java.math.BigDecimal;

/** Điểm do server tính: tổng (0-100) và điểm nội dung (0-100, chỉ gồm tiêu chí LLM), đều làm tròn 1 chữ số. */
public record ScoreOutcome(BigDecimal totalScore, BigDecimal contentScore) {
}
