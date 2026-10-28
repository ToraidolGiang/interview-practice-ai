package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;

import com.example.interviewpractice.dto.RegisterRequest;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.UserRepository;

/** Cần Postgres như BackendApplicationTests: kiểm tra đăng ký trùng email khác chữ hoa/thường trên CSDL thật. */
@SpringBootTest
class AuthRegisterIntegrationTest {

    private static final String PASSWORD = "Matkhau123";

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository users;

    private final String email = "register-" + UUID.randomUUID() + "@example.com";

    @AfterEach
    void cleanUp() {
        users.findByEmail(email).ifPresent(users::delete);
    }

    @Test
    void registeringSameEmailInDifferentCaseReturnsConflict() {
        authService.register(new RegisterRequest("Người Dùng Thử", email, PASSWORD, PASSWORD));

        ApiException e = assertThrows(ApiException.class, () -> authService.register(
                new RegisterRequest("Người Dùng Khác", email.toUpperCase(), PASSWORD, PASSWORD)));

        assertEquals(HttpStatus.CONFLICT, e.getStatus());
        assertEquals("EMAIL_EXISTS", e.getCode());
    }
}
