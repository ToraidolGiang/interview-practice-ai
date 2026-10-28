package com.example.interviewpractice.dto;

import com.example.interviewpractice.validation.MaxUtf8Bytes;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Yêu cầu đăng ký, khớp schema RegisterRequest trong openapi.yaml. */
public record RegisterRequest(
        @NotBlank(message = "Họ tên không được để trống")
        @Size(max = 100, message = "Họ tên tối đa 100 ký tự")
        String fullName,

        @NotBlank(message = "Email không được để trống")
        @Email(message = "Email không đúng định dạng")
        @Size(max = 255, message = "Email tối đa 255 ký tự")
        String email,

        // BCrypt giới hạn 72 byte (không phải 72 ký tự), nên đếm theo byte UTF-8
        @NotBlank(message = "Mật khẩu không được để trống")
        @Size(min = 8, message = "Mật khẩu tối thiểu 8 ký tự")
        @MaxUtf8Bytes(value = 72, message = "Mật khẩu quá dài (tối đa 72 byte, chữ có dấu chiếm 2-3 byte mỗi ký tự)")
        String password,

        @NotBlank(message = "Vui lòng nhập lại mật khẩu")
        String confirmPassword) {
}
