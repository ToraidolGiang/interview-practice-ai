package com.example.interviewpractice.dto;

import jakarta.validation.constraints.NotBlank;

/** Yêu cầu đăng nhập, khớp schema LoginRequest trong openapi.yaml. */
public record LoginRequest(
        @NotBlank(message = "Email không được để trống")
        String email,

        @NotBlank(message = "Mật khẩu không được để trống")
        String password) {
}
