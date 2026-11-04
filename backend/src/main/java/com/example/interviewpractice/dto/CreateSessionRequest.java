package com.example.interviewpractice.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotNull;

/** Yêu cầu tạo phiên luyện tập, khớp schema CreateSessionRequest trong openapi.yaml. */
public record CreateSessionRequest(@NotNull(message = "questionId là bắt buộc") UUID questionId) {
}
