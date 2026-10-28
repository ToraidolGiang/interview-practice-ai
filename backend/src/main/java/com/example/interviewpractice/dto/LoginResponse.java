package com.example.interviewpractice.dto;

/** Kết quả đăng nhập, khớp schema LoginResponse trong openapi.yaml. */
public record LoginResponse(String accessToken, int expiresInHours, UserDto user) {
}
