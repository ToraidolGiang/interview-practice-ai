package com.example.interviewpractice.security;

import java.util.UUID;

import com.example.interviewpractice.entity.User;

/** Người dùng đã xác thực, lấy từ JWT (không truy vấn CSDL mỗi request). */
public record AuthUser(UUID id, String email, User.Role role) {
}
