package com.example.interviewpractice.service.scoring;

import java.math.BigDecimal;

/**
 * Kết quả tính Delivery cho một câu trả lời, khớp schema DeliveryMetrics trong openapi.yaml
 * và các cột wpm, filler_count, filler_rate, delivery_score, filler_list_version của score_results.
 *
 * @param wordCount số từ trong transcript (dùng nội bộ, không trả cho client)
 */
public record DeliveryMetrics(
        int wordCount,
        int wpm,
        int fillerCount,
        BigDecimal fillerRate,
        BigDecimal deliveryScore,
        String fillerListVersion) {
}
