package com.example.interviewpractice.dto;

import java.time.Instant;
import java.util.UUID;

import com.example.interviewpractice.entity.User;

/** Thông tin người dùng trả về client, khớp schema User trong openapi.yaml (không có password_hash). */
public record UserDto(UUID id, String fullName, String email, User.Role role, User.Status status,
        Instant createdAt) {

    public static UserDto from(User user) {
        return new UserDto(user.getId(), user.getFullName(), user.getEmail(), user.getRole(), user.getStatus(),
                user.getCreatedAt());
    }
}
