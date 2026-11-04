package com.example.interviewpractice.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/** Giới hạn audio câu trả lời đọc từ khóa app.audio.* trong application.yml. */
@ConfigurationProperties(prefix = "app.audio")
public record AudioProperties(long maxBytes, int minSeconds, int maxSeconds) {
}
