package com.example.interviewpractice.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.example.interviewpractice.dto.LoginRequest;
import com.example.interviewpractice.dto.LoginResponse;
import com.example.interviewpractice.dto.RegisterRequest;
import com.example.interviewpractice.dto.RegisterResponse;
import com.example.interviewpractice.service.AuthService;

import jakarta.validation.Valid;

/** Đăng ký và đăng nhập (UC1, UC2). Quên và đặt lại mật khẩu thuộc #157. */
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public RegisterResponse register(@Valid @RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }
}
