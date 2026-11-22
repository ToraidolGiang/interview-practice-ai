package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Bộ lọc của GET /history (UC7); null nghĩa là không lọc theo tiêu chí đó. */
public record HistoryFilter(LocalDate from, LocalDate to, String industry, BigDecimal minScore,
        BigDecimal maxScore) {
}
