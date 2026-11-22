package com.example.interviewpractice.config;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Lượt kiểm lỗi kiến thức (ai.check.*): model riêng, mức suy nghĩ thấp để trả lời nhanh, timeout ngắn vì lượt này
 * chỉ bổ sung và không được làm chậm hay làm hỏng việc chấm. enabled=false thì bỏ qua hẳn lượt này.
 *
 * @param thinkingLevel mức suy nghĩ gửi cho Gemini (ví dụ minimal, low); rỗng thì không gửi
 */
@ConfigurationProperties(prefix = "ai.check")
public record KnowledgeCheckProperties(boolean enabled, String model, String thinkingLevel, Duration timeout) {
}
