package com.example.interviewpractice.dto;

import java.util.UUID;

/** Kết quả đăng ký, khớp schema RegisterResponse trong openapi.yaml. */
public record RegisterResponse(UUID id, String email) {
}
