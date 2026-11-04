package com.example.interviewpractice.service.scoring;

import java.util.Optional;

/** Cổng lấy chỉ số Delivery; test thay bằng bản giả, bản thật bọc {@link DeliveryCalculator}. */
public interface DeliveryMetricsProvider {

    /** Rỗng khi transcript dưới 30 từ hoặc thiếu thời lượng (trọng số Delivery khi đó chia lại). */
    Optional<DeliveryMetrics> calculate(String transcript, Double durationSeconds);
}
