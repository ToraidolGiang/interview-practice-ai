package com.example.interviewpractice.dto;

import java.math.BigDecimal;

/** Số liệu tổng quan cho admin (UC9), khớp schema AnalyticsOverview; không chứa thông tin nhạy cảm của user (B2). */
public record AnalyticsOverview(long totalUsers, long activeUsers, long totalSessions, long scoredSessions,
        BigDecimal averageScore, AiApiCalls aiApiCalls, BigDecimal estimatedCost) {

    /** Số lượt gọi từng nhà cung cấp AI trong khoảng thời gian. */
    public record AiApiCalls(long stt, long llm, long tts) {
    }
}
