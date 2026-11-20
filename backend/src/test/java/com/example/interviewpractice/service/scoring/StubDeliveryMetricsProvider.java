package com.example.interviewpractice.service.scoring;

import java.util.Optional;

/** Bản giả của cổng Delivery cho test: trả đúng kết quả được cài sẵn, không tính gì. */
class StubDeliveryMetricsProvider implements DeliveryMetricsProvider {

    private final Optional<DeliveryMetrics> result;

    StubDeliveryMetricsProvider(Optional<DeliveryMetrics> result) {
        this.result = result;
    }

    @Override
    public Optional<DeliveryMetrics> calculate(String transcript, Double durationSeconds) {
        return result;
    }
}
