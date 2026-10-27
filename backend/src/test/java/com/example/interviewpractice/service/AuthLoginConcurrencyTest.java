package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;

import com.example.interviewpractice.dto.LoginRequest;
import com.example.interviewpractice.dto.RegisterRequest;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.UserRepository;

/** Cần Postgres như BackendApplicationTests: kiểm tra khóa dòng khi nhiều request sai mật khẩu đến cùng lúc. */
@SpringBootTest
class AuthLoginConcurrencyTest {

    private static final String PASSWORD = "Matkhau123";
    private static final int PARALLEL_ATTEMPTS = 10;

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository users;

    private final String email = "concurrent-" + UUID.randomUUID() + "@example.com";

    @AfterEach
    void cleanUp() {
        users.findByEmail(email).ifPresent(users::delete);
    }

    @Test
    void parallelWrongPasswordsStillLockAccountAfterFiveFailures() throws Exception {
        authService.register(new RegisterRequest("Người Dùng Thử", email, PASSWORD, PASSWORD));

        List<HttpStatus> results = attemptWrongLoginsInParallel();

        assertEquals(AuthService.MAX_FAILED_LOGINS, count(results, HttpStatus.UNAUTHORIZED));
        assertEquals(PARALLEL_ATTEMPTS - AuthService.MAX_FAILED_LOGINS, count(results, HttpStatus.TOO_MANY_REQUESTS));
        User user = users.findByEmail(email).orElseThrow();
        assertNotNull(user.getLockedUntil());
    }

    private List<HttpStatus> attemptWrongLoginsInParallel() throws Exception {
        ExecutorService pool = Executors.newFixedThreadPool(PARALLEL_ATTEMPTS);
        CountDownLatch start = new CountDownLatch(1);
        List<Future<HttpStatus>> futures = new ArrayList<>();
        try {
            for (int i = 0; i < PARALLEL_ATTEMPTS; i++) {
                futures.add(pool.submit(() -> {
                    start.await();
                    try {
                        authService.login(new LoginRequest(email, "sai-mat-khau"));
                        return HttpStatus.OK;
                    } catch (ApiException e) {
                        return e.getStatus();
                    }
                }));
            }
            start.countDown();
            List<HttpStatus> results = new ArrayList<>();
            for (Future<HttpStatus> future : futures) {
                results.add(future.get());
            }
            return results;
        } finally {
            pool.shutdownNow();
        }
    }

    private static long count(List<HttpStatus> results, HttpStatus status) {
        return results.stream().filter(status::equals).count();
    }
}
