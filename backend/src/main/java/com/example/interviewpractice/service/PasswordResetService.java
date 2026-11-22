package com.example.interviewpractice.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Clock;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;
import java.util.List;
import java.util.Locale;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.util.UriComponentsBuilder;

import com.example.interviewpractice.config.PasswordResetProperties;
import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.dto.ForgotPasswordRequest;
import com.example.interviewpractice.dto.ResetPasswordRequest;
import com.example.interviewpractice.entity.PasswordResetToken;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.PasswordResetRepository;
import com.example.interviewpractice.repository.UserRepository;

/**
 * Quên và đặt lại mật khẩu (#157). Token ngẫu nhiên 256 bit chỉ nằm trong email; CSDL chỉ lưu SHA-256 của nó,
 * nên lộ bảng password_reset_tokens cũng không dùng được token.
 */
@Service
public class PasswordResetService {

    private static final int TOKEN_BYTES = 32;

    private final UserRepository users;
    private final PasswordResetRepository tokens;
    private final PasswordEncoder passwordEncoder;
    private final MailService mailService;
    private final PasswordResetProperties properties;
    private final Clock clock;
    private final SecureRandom random = new SecureRandom();

    public PasswordResetService(UserRepository users, PasswordResetRepository tokens, PasswordEncoder passwordEncoder,
            MailService mailService, PasswordResetProperties properties, Clock clock) {
        this.users = users;
        this.tokens = tokens;
        this.passwordEncoder = passwordEncoder;
        this.mailService = mailService;
        this.properties = properties;
        this.clock = clock;
    }

    /**
     * Luôn kết thúc bình thường (controller trả 200) dù email có tồn tại hay không, để không lộ danh sách tài khoản.
     * Tài khoản bị quản trị khóa không nhận email vì đặt lại mật khẩu xong vẫn không đăng nhập được.
     */
    @Transactional
    public void requestReset(ForgotPasswordRequest request) {
        User user = users.findByEmail(normalize(request.email()))
                .filter(u -> u.getStatus() == User.Status.ACTIVE)
                .orElse(null);
        if (user == null) {
            return;
        }
        Instant now = clock.instant();
        // Token gửi trong khoảng chờ vẫn còn hiệu lực lâu hơn (ttl - cooldown); khi đó không gửi thêm email
        Instant recentlySentMarker = now.plus(properties.tokenTtl()).minus(properties.resendCooldown());
        if (tokens.existsUnusedExpiringAfter(user.getId(), recentlySentMarker)) {
            return;
        }

        String rawToken = newToken();
        PasswordResetToken token = new PasswordResetToken();
        token.setUser(user);
        token.setTokenHash(sha256(rawToken));
        token.setExpiresAt(now.plus(properties.tokenTtl()));
        tokens.save(token);

        String to = user.getEmail();
        String fullName = user.getFullName();
        String link = resetLink(rawToken, to);
        // Chỉ gửi khi token đã nằm trong CSDL, tránh gửi link dùng không được nếu transaction rollback
        afterCommit(() -> mailService.sendPasswordReset(to, fullName, link));
    }

    /** Thành công thì đổi mật khẩu, mở khóa tạm do đăng nhập sai và vô hiệu mọi token còn lại của người dùng. */
    @Transactional
    public void reset(ResetPasswordRequest request) {
        if (!request.newPassword().equals(request.confirmPassword())) {
            // Kiểm tra trước khi đụng tới token để nhập sai không làm mất token
            throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ",
                    List.of(new ErrorResponse.FieldError("confirmPassword", "Mật khẩu nhập lại không khớp")));
        }
        Instant now = clock.instant();
        PasswordResetToken token = tokens.findByTokenHashForUpdate(sha256(request.token()))
                .filter(t -> t.getUsedAt() == null && t.getExpiresAt().isAfter(now))
                .orElseThrow(PasswordResetService::invalidToken);
        // Khóa dòng user như khi đăng nhập để không ghi đè lẫn nhau failed_login_count với một lần đăng nhập sai
        User user = users.findByEmailForUpdate(token.getUser().getEmail())
                .filter(u -> u.getStatus() == User.Status.ACTIVE)
                .orElseThrow(PasswordResetService::invalidToken);

        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        user.setFailedLoginCount(0);
        user.setLockedUntil(null);
        token.setUsedAt(now);
        // Gồm cả token vừa dùng (đã đánh dấu ở trên); query này flush thay đổi trước rồi mới cập nhật
        tokens.markAllUnusedAsUsed(user.getId(), now);
    }

    String resetLink(String rawToken, String email) {
        // Truyền qua biến template để được mã hóa chặt: '+' trong email thành %2B, nếu không URLSearchParams
        // ở frontend sẽ đọc thành dấu cách
        return UriComponentsBuilder.fromUriString(properties.frontendBaseUrl())
                .path("/reset-password")
                .queryParam("token", "{token}")
                .queryParam("email", "{email}")
                .encode()
                .buildAndExpand(rawToken, email)
                .toUriString();
    }

    private String newToken() {
        byte[] bytes = new byte[TOKEN_BYTES];
        random.nextBytes(bytes);
        // base64url không có ký tự cần mã hóa trong URL
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    static String sha256(String value) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("JVM thiếu SHA-256", e);
        }
    }

    private static void afterCommit(Runnable action) {
        if (!TransactionSynchronizationManager.isSynchronizationActive()) {
            action.run();
            return;
        }
        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCommit() {
                action.run();
            }
        });
    }

    private static String normalize(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }

    private static ApiException invalidToken() {
        return new ApiException(HttpStatus.BAD_REQUEST, "INVALID_TOKEN",
                "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn");
    }
}
