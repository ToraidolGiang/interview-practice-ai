package com.example.interviewpractice.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/** Cấu hình JWT đọc từ khóa jwt.* trong application.yml. */
@ConfigurationProperties(prefix = "jwt")
public record JwtProperties(String secret, int expirationHours) {
}
