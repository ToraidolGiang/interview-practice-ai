package com.example.interviewpractice.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/** Bật PasswordResetProperties; tách riêng để không sửa SecurityConfig dùng chung. */
@Configuration
@EnableConfigurationProperties(PasswordResetProperties.class)
public class PasswordResetConfig {
}
