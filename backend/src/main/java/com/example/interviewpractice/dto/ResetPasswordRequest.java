package com.example.interviewpractice.dto;

import com.example.interviewpractice.validation.MaxUtf8Bytes;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Đặt lại mật khẩu bằng token trong email, khớp schema ResetPasswordRequest trong openapi.yaml. */
public record ResetPasswordRequest(
        @NotBlank(message = "Thiếu token đặt lại mật khẩu")
        @Size(max = 200, message = "Token không hợp lệ")
        String token,

        // Cùng quy tắc với mật khẩu khi đăng ký (RegisterRequest)
        @NotBlank(message = "Mật khẩu không được để trống")
        @Size(min = 8, message = "Mật khẩu tối thiểu 8 ký tự")
        @MaxUtf8Bytes(value = 72, message = "Mật khẩu quá dài (tối đa 72 byte, chữ có dấu chiếm 2-3 byte mỗi ký tự)")
        String newPassword,

        @NotBlank(message = "Vui lòng nhập lại mật khẩu")
        String confirmPassword) {
}
