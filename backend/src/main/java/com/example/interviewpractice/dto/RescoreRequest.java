package com.example.interviewpractice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Yêu cầu chấm lại với transcript đã sửa, khớp schema RescoreRequest trong openapi.yaml. */
public record RescoreRequest(
        @NotBlank(message = "transcript là bắt buộc")
        @Size(max = 10000, message = "transcript tối đa 10000 ký tự") String transcript) {
}
