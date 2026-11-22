package com.example.interviewpractice.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.interviewpractice.dto.ForgotPasswordRequest;
import com.example.interviewpractice.dto.ResetPasswordRequest;
import com.example.interviewpractice.service.PasswordResetService;

import jakarta.validation.Valid;

/** Quên và đặt lại mật khẩu (#157); SecurityConfig đã mở công khai hai đường dẫn này. Trả 200 không có body. */
@RestController
@RequestMapping("/auth")
public class PasswordResetController {

    private final PasswordResetService passwordResetService;

    public PasswordResetController(PasswordResetService passwordResetService) {
        this.passwordResetService = passwordResetService;
    }

    @PostMapping("/forgot-password")
    public void forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        passwordResetService.requestReset(request);
    }

    @PostMapping("/reset-password")
    public void resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        passwordResetService.reset(request);
    }
}
