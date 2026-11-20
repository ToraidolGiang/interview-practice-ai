package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.util.UriComponentsBuilder;

import com.example.interviewpractice.config.PasswordResetProperties;
import com.example.interviewpractice.dto.ForgotPasswordRequest;
import com.example.interviewpractice.dto.ResetPasswordRequest;
import com.example.interviewpractice.entity.PasswordResetToken;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.PasswordResetRepository;
import com.example.interviewpractice.repository.UserRepository;

class PasswordResetServiceTest {

    private static final Instant NOW = Instant.parse("2026-11-17T03:00:00Z");
    private static final String EMAIL = "user@example.com";
    private static final String NEW_PASSWORD = "MatkhauMoi123";
    private static final PasswordResetProperties PROPERTIES = new PasswordResetProperties("http://app.test",
            "no-reply@app.test", Duration.ofMinutes(30), Duration.ofSeconds(60));

    private final UserRepository users = mock(UserRepository.class);
    private final PasswordResetRepository tokens = mock(PasswordResetRepository.class);
    private final MailService mail = mock(MailService.class);
    private final PasswordEncoder encoder = new BCryptPasswordEncoder(4);
    private PasswordResetService service;
    private User user;

    @BeforeEach
    void setUp() {
        service = new PasswordResetService(users, tokens, encoder, mail, PROPERTIES,
                Clock.fixed(NOW, ZoneOffset.UTC));
        user = new User();
        user.setId(UUID.randomUUID());
        user.setEmail(EMAIL);
        user.setFullName("Người Dùng");
        user.setPasswordHash(encoder.encode("MatkhauCu123"));
        when(users.findByEmail(EMAIL)).thenReturn(Optional.of(user));
        when(users.findByEmailForUpdate(EMAIL)).thenReturn(Optional.of(user));
        when(tokens.save(any())).thenAnswer(inv -> inv.getArgument(0));
    }

    @Test
    void requestStoresOnlyHashOfTheTokenSentByEmailWithThirtyMinuteExpiry() {
        service.requestReset(new ForgotPasswordRequest("  User@Example.com "));

        ArgumentCaptor<PasswordResetToken> saved = ArgumentCaptor.forClass(PasswordResetToken.class);
        verify(tokens).save(saved.capture());
        ArgumentCaptor<String> link = ArgumentCaptor.forClass(String.class);
        verify(mail).sendPasswordReset(eq(EMAIL), eq("Người Dùng"), link.capture());

        var params = UriComponentsBuilder.fromUriString(link.getValue()).build().getQueryParams();
        String rawToken = params.getFirst("token");
        assertTrue(link.getValue().startsWith("http://app.test/reset-password?"));
        assertTrue(rawToken.length() >= 43, "token 256 bit dạng base64url");
        assertEquals(PasswordResetService.sha256(rawToken), saved.getValue().getTokenHash());
        assertEquals(NOW.plus(Duration.ofMinutes(30)), saved.getValue().getExpiresAt());
        assertEquals(user, saved.getValue().getUser());
    }

    @Test
    void unknownEmailEndsNormallyWithoutCreatingTokenOrSendingMail() {
        when(users.findByEmail("nobody@example.com")).thenReturn(Optional.empty());

        service.requestReset(new ForgotPasswordRequest("nobody@example.com"));

        verify(tokens, never()).save(any());
        verifyNoInteractions(mail);
    }

    @Test
    void accountLockedByAdminGetsNoMail() {
        user.setStatus(User.Status.LOCKED);

        service.requestReset(new ForgotPasswordRequest(EMAIL));

        verify(tokens, never()).save(any());
        verifyNoInteractions(mail);
    }

    @Test
    void secondRequestWithinCooldownSendsNothing() {
        // Token còn hạn quá 29 phút nghĩa là vừa được tạo trong 60 giây qua
        when(tokens.existsUnusedExpiringAfter(user.getId(), NOW.plus(Duration.ofMinutes(29)))).thenReturn(true);

        service.requestReset(new ForgotPasswordRequest(EMAIL));

        verify(tokens, never()).save(any());
        verifyNoInteractions(mail);
    }

    @Test
    void resetChangesPasswordClearsTemporaryLockAndInvalidatesAllTokens() {
        user.setFailedLoginCount(3);
        user.setLockedUntil(NOW.plusSeconds(600));
        PasswordResetToken token = token("raw-token", NOW.plusSeconds(60), null);

        service.reset(new ResetPasswordRequest("raw-token", NEW_PASSWORD, NEW_PASSWORD));

        assertTrue(encoder.matches(NEW_PASSWORD, user.getPasswordHash()));
        assertEquals(0, user.getFailedLoginCount());
        assertNull(user.getLockedUntil());
        assertEquals(NOW, token.getUsedAt());
        verify(tokens).markAllUnusedAsUsed(user.getId(), NOW);
    }

    @Test
    void expiredTokenIsRejected() {
        token("raw-token", NOW, null);

        assertInvalidToken(() -> service.reset(new ResetPasswordRequest("raw-token", NEW_PASSWORD, NEW_PASSWORD)));
    }

    @Test
    void usedTokenIsRejected() {
        token("raw-token", NOW.plusSeconds(60), NOW.minusSeconds(5));

        assertInvalidToken(() -> service.reset(new ResetPasswordRequest("raw-token", NEW_PASSWORD, NEW_PASSWORD)));
    }

    @Test
    void unknownTokenIsRejected() {
        when(tokens.findByTokenHashForUpdate(anyString())).thenReturn(Optional.empty());

        assertInvalidToken(() -> service.reset(new ResetPasswordRequest("khong-co", NEW_PASSWORD, NEW_PASSWORD)));
    }

    @Test
    void tokenOfAccountLockedByAdminIsRejected() {
        token("raw-token", NOW.plusSeconds(60), null);
        user.setStatus(User.Status.LOCKED);

        assertInvalidToken(() -> service.reset(new ResetPasswordRequest("raw-token", NEW_PASSWORD, NEW_PASSWORD)));
    }

    @Test
    void mismatchedConfirmationFailsOnTheFieldWithoutConsumingTheToken() {
        ApiException e = assertThrows(ApiException.class,
                () -> service.reset(new ResetPasswordRequest("raw-token", NEW_PASSWORD, "KhacNhau123")));

        assertEquals("VALIDATION_ERROR", e.getCode());
        assertEquals("confirmPassword", e.getFieldErrors().get(0).field());
        verifyNoInteractions(tokens);
    }

    @Test
    void linkEncodesEmailForTheQueryString() {
        String link = service.resetLink("abc_-123", "a+b@example.com");

        assertEquals("http://app.test/reset-password?token=abc_-123&email=a%2Bb%40example.com", link);
    }

    private PasswordResetToken token(String raw, Instant expiresAt, Instant usedAt) {
        PasswordResetToken token = new PasswordResetToken();
        token.setUser(user);
        token.setTokenHash(PasswordResetService.sha256(raw));
        token.setExpiresAt(expiresAt);
        token.setUsedAt(usedAt);
        when(tokens.findByTokenHashForUpdate(PasswordResetService.sha256(raw))).thenReturn(Optional.of(token));
        return token;
    }

    private static void assertInvalidToken(org.junit.jupiter.api.function.Executable call) {
        ApiException e = assertThrows(ApiException.class, call);
        assertEquals(HttpStatus.BAD_REQUEST, e.getStatus());
        assertEquals("INVALID_TOKEN", e.getCode());
    }
}
