package com.example.interviewpractice.security;

import java.util.UUID;

import com.example.interviewpractice.entity.User;

/** Người dùng đã xác thực; JwtAuthenticationFilter nạp lại id, email và role từ CSDL ở mỗi request. */
public record AuthUser(UUID id, String email, User.Role role) {
}
