package com.example.interviewpractice.config;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Cấu hình quên mật khẩu (#157), đọc từ khóa password-reset.* trong application.yml.
 *
 * @param frontendBaseUrl gốc của frontend, link trong email là {frontendBaseUrl}/reset-password?token=...&email=...
 * @param mailFrom        địa chỉ người gửi
 * @param tokenTtl        thời hạn token (contract: 30 phút)
 * @param resendCooldown  trong khoảng này sau lần gửi trước thì không gửi thêm, tránh bị dùng để spam hộp thư
 */
@ConfigurationProperties(prefix = "password-reset")
public record PasswordResetProperties(String frontendBaseUrl, String mailFrom, Duration tokenTtl,
        Duration resendCooldown) {
}
