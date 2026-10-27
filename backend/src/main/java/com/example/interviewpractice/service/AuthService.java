package com.example.interviewpractice.service;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Locale;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.config.JwtProperties;
import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.dto.LoginRequest;
import com.example.interviewpractice.dto.LoginResponse;
import com.example.interviewpractice.dto.RegisterRequest;
import com.example.interviewpractice.dto.RegisterResponse;
import com.example.interviewpractice.dto.UserDto;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.JwtService;

/** Đăng ký và đăng nhập (UC1, UC2), gồm khóa tạm tài khoản sau nhiều lần đăng nhập sai. */
@Service
public class AuthService {

    public static final int MAX_FAILED_LOGINS = 5;
    public static final Duration LOCK_DURATION = Duration.ofMinutes(15);

    private final UserRepository users;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final JwtProperties jwtProperties;
    private final Clock clock;

    public AuthService(UserRepository users, PasswordEncoder passwordEncoder, JwtService jwtService,
            JwtProperties jwtProperties, Clock clock) {
        this.users = users;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.jwtProperties = jwtProperties;
        this.clock = clock;
    }

    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        if (!request.password().equals(request.confirmPassword())) {
            // Gắn lỗi vào đúng trường để frontend hiển thị dưới ô confirmPassword
            throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ",
                    List.of(new ErrorResponse.FieldError("confirmPassword", "Mật khẩu nhập lại không khớp")));
        }
        String email = normalize(request.email());
        if (users.existsByEmail(email)) {
            throw new ApiException(HttpStatus.CONFLICT, "EMAIL_EXISTS", "Email đã được đăng ký");
        }
        User user = new User();
        user.setFullName(request.fullName().trim());
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        try {
            // saveAndFlush để vi phạm chỉ mục uq_users_email lộ ra tại đây (hai request đăng ký cùng lúc)
            User saved = users.saveAndFlush(user);
            return new RegisterResponse(saved.getId(), saved.getEmail());
        } catch (DataIntegrityViolationException e) {
            throw new ApiException(HttpStatus.CONFLICT, "EMAIL_EXISTS", "Email đã được đăng ký");
        }
    }

    // Lần đăng nhập sai phải được lưu dù trả lỗi, nên không rollback khi ném ApiException
    @Transactional(noRollbackFor = ApiException.class)
    public LoginResponse login(LoginRequest request) {
        Instant now = clock.instant();
        User user = users.findByEmailForUpdate(normalize(request.email())).orElseThrow(AuthService::badCredentials);

        if (user.getLockedUntil() != null && user.getLockedUntil().isAfter(now)) {
            throw new ApiException(HttpStatus.TOO_MANY_REQUESTS, "ACCOUNT_LOCKED",
                    "Tài khoản tạm khóa do đăng nhập sai quá " + MAX_FAILED_LOGINS + " lần, vui lòng thử lại sau "
                            + LOCK_DURATION.toMinutes() + " phút");
        }
        // Tài khoản bị quản trị khóa (hoặc tài khoản hệ thống) không đăng nhập được
        if (user.getStatus() != User.Status.ACTIVE
                || !passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            registerFailure(user, now);
            throw badCredentials();
        }

        user.setFailedLoginCount(0);
        user.setLockedUntil(null);
        return new LoginResponse(jwtService.generate(user), jwtProperties.expirationHours(), UserDto.from(user));
    }

    private void registerFailure(User user, Instant now) {
        int failures = user.getFailedLoginCount() + 1;
        if (failures >= MAX_FAILED_LOGINS) {
            user.setLockedUntil(now.plus(LOCK_DURATION));
            failures = 0;
        }
        user.setFailedLoginCount(failures);
    }

    private static String normalize(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }

    private static ApiException badCredentials() {
        return new ApiException(HttpStatus.UNAUTHORIZED, "UNAUTHORIZED", "Sai email hoặc mật khẩu");
    }
}
