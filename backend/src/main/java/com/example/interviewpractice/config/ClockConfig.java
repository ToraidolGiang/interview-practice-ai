package com.example.interviewpractice.config;

import java.time.Clock;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/** Cung cấp Clock để test điều khiển được thời gian (hết hạn token, thời gian khóa tài khoản). */
@Configuration
public class ClockConfig {

    @Bean
    public Clock clock() {
        return Clock.systemUTC();
    }
}
