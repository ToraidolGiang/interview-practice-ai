package com.example.interviewpractice.config;

import java.util.Random;
import java.util.random.RandomGenerator;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/** Cung cấp nguồn ngẫu nhiên dùng chung (an toàn đa luồng) để test chọn câu hỏi ngẫu nhiên điều khiển được kết quả. */
@Configuration
public class RandomConfig {

    @Bean
    public RandomGenerator randomGenerator() {
        return new Random();
    }
}
