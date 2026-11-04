package com.example.interviewpractice.service.scoring;

import java.util.Optional;

import org.springframework.stereotype.Component;

/** Bọc {@link DeliveryCalculator} sau interface để tầng chấm điểm không phụ thuộc trực tiếp lớp cài đặt. */
@Component
public class DeliveryCalculatorAdapter implements DeliveryMetricsProvider {

    private final DeliveryCalculator calculator;

    public DeliveryCalculatorAdapter(DeliveryCalculator calculator) {
        this.calculator = calculator;
    }

    @Override
    public Optional<DeliveryMetrics> calculate(String transcript, Double durationSeconds) {
        return calculator.calculate(transcript, durationSeconds);
    }
}
