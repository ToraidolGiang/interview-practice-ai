package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.example.interviewpractice.config.JwtProperties;
import com.example.interviewpractice.dto.LoginRequest;
import com.example.interviewpractice.dto.LoginResponse;
import com.example.interviewpractice.dto.RegisterRequest;
import com.example.interviewpractice.dto.RegisterResponse;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.JwtService;

class AuthServiceTest {

    private static final Instant NOW = Instant.parse("2026-10-27T03:00:00Z");
    private static final String PASSWORD = "Matkhau123";

    private final PasswordEncoder encoder = spy(new BCryptPasswordEncoder(4));
    private final JwtProperties properties = new JwtProperties("test-secret-test-secret-test-secret-123456", 24);
    private final UserRepository users = mock(UserRepository.class);
    private Clock clock;
    private AuthService service;
    private User user;

    @BeforeEach
    void setUp() {
        useClock(NOW);
        user = new User();
        user.setId(UUID.randomUUID());
        user.setFullName("Nguyễn Văn A");
        user.setEmail("cand@example.com");
        user.setPasswordHash(encoder.encode(PASSWORD));
        when(users.findByEmailForUpdate("cand@example.com")).thenReturn(Optional.of(user));
    }

    private void useClock(Instant instant) {
        clock = Clock.fixed(instant, ZoneOffset.UTC);
        service = new AuthService(users, encoder, new JwtService(properties, clock), properties, clock);
    }

    private ApiException failLogin(String password) {
        return assertThrows(ApiException.class, () -> service.login(new LoginRequest("cand@example.com", password)));
    }

    @Test
    void registerStoresHashedPasswordAndNormalizedEmail() {
        when(users.existsByEmail("new@example.com")).thenReturn(false);
        when(users.saveAndFlush(any(User.class))).thenAnswer(inv -> {
            User saved = inv.getArgument(0);
            saved.setId(UUID.randomUUID());
            return saved;
        });

        RegisterResponse response = service.register(
                new RegisterRequest(" Trần B ", " New@Example.com ", PASSWORD, PASSWORD));

        assertEquals("new@example.com", response.email());
        verify(users).saveAndFlush(argThat(u ->
                u.getFullName().equals("Trần B")
                        && !u.getPasswordHash().equals(PASSWORD)
                        && encoder.matches(PASSWORD, u.getPasswordHash())
                        && u.getRole() == User.Role.CANDIDATE));
    }

    @Test
    void registerRejectsDuplicateEmail() {
        when(users.existsByEmail("cand@example.com")).thenReturn(true);

        ApiException e = assertThrows(ApiException.class, () -> service.register(
                new RegisterRequest("A", "cand@example.com", PASSWORD, PASSWORD)));

        assertEquals(HttpStatus.CONFLICT, e.getStatus());
        assertEquals("EMAIL_EXISTS", e.getCode());
        verify(users, never()).saveAndFlush(any());
    }

    @Test
    void registerRejectsMismatchedConfirmPassword() {
        ApiException e = assertThrows(ApiException.class, () -> service.register(
                new RegisterRequest("A", "new@example.com", PASSWORD, "khac-mat-khau")));

        assertEquals(HttpStatus.BAD_REQUEST, e.getStatus());
        assertEquals("confirmPassword", e.getFieldErrors().get(0).field());
        verify(users, never()).saveAndFlush(any());
    }

    @Test
    void loginReturnsTokenAndResetsFailureCounter() {
        user.setFailedLoginCount(3);

        LoginResponse response = service.login(new LoginRequest("Cand@Example.com", PASSWORD));

        assertEquals(24, response.expiresInHours());
        assertEquals("cand@example.com", response.user().email());
        assertEquals(3, response.accessToken().split("\\.").length);
        assertEquals(0, user.getFailedLoginCount());
    }

    @Test
    void loginWithUnknownEmailGivesSameErrorAsWrongPassword() {
        when(users.findByEmailForUpdate("nobody@example.com")).thenReturn(Optional.empty());

        ApiException unknown = assertThrows(ApiException.class,
                () -> service.login(new LoginRequest("nobody@example.com", PASSWORD)));
        ApiException wrong = failLogin("sai-mat-khau");

        assertEquals(HttpStatus.UNAUTHORIZED, unknown.getStatus());
        assertEquals(unknown.getMessage(), wrong.getMessage());
    }

    @Test
    void fifthWrongPasswordLocksAccountAndNextAttemptIsRejectedEvenWithCorrectPassword() {
        for (int i = 0; i < AuthService.MAX_FAILED_LOGINS; i++) {
            assertEquals(HttpStatus.UNAUTHORIZED, failLogin("sai-mat-khau").getStatus());
        }

        assertEquals(NOW.plus(AuthService.LOCK_DURATION), user.getLockedUntil());
        ApiException locked = failLogin(PASSWORD);
        assertEquals(HttpStatus.TOO_MANY_REQUESTS, locked.getStatus());
        assertEquals("ACCOUNT_LOCKED", locked.getCode());
    }

    @Test
    void accountUnlocksAfterLockDuration() {
        for (int i = 0; i < AuthService.MAX_FAILED_LOGINS; i++) {
            failLogin("sai-mat-khau");
        }

        useClock(NOW.plus(AuthService.LOCK_DURATION).plus(Duration.ofSeconds(1)));
        LoginResponse response = service.login(new LoginRequest("cand@example.com", PASSWORD));

        assertNotNull(response.accessToken());
        assertNull(user.getLockedUntil());
        assertEquals(0, user.getFailedLoginCount());
    }

    @Test
    void adminLockedAccountCannotLogInEvenWithCorrectPassword() {
        user.setStatus(User.Status.LOCKED);

        assertEquals(HttpStatus.UNAUTHORIZED, failLogin(PASSWORD).getStatus());
    }

    @Test
    void registerReturnsConflictWhenUniqueIndexRejectsConcurrentDuplicate() {
        when(users.existsByEmail("new@example.com")).thenReturn(false);
        when(users.saveAndFlush(any(User.class))).thenThrow(new DataIntegrityViolationException("uq_users_email"));

        ApiException e = assertThrows(ApiException.class, () -> service.register(
                new RegisterRequest("A", "new@example.com", PASSWORD, PASSWORD)));

        assertEquals(HttpStatus.CONFLICT, e.getStatus());
        assertEquals("EMAIL_EXISTS", e.getCode());
    }

    @Test
    void emailNormalizationIgnoresDefaultLocale() {
        Locale original = Locale.getDefault();
        try {
            // Locale Thổ Nhĩ Kỳ biến "I" thành "ı" nếu toLowerCase không chỉ định Locale
            Locale.setDefault(Locale.forLanguageTag("tr-TR"));
            when(users.existsByEmail("info@example.com")).thenReturn(true);

            ApiException e = assertThrows(ApiException.class, () -> service.register(
                    new RegisterRequest("A", "INFO@Example.com", PASSWORD, PASSWORD)));

            assertEquals("EMAIL_EXISTS", e.getCode());
        } finally {
            Locale.setDefault(original);
        }
    }

    @Test
    void lockedMessageShowsRemainingMinutes() {
        for (int i = 0; i < AuthService.MAX_FAILED_LOGINS; i++) {
            failLogin("sai-mat-khau");
        }

        useClock(NOW.plus(Duration.ofMinutes(10)));
        ApiException locked = failLogin(PASSWORD);

        assertEquals("ACCOUNT_LOCKED", locked.getCode());
        assertTrue(locked.getMessage().contains("sau 5 phút"), locked.getMessage());
    }

    @Test
    void unknownEmailStillRunsPasswordHashSoTimingDoesNotRevealEmail() {
        when(users.findByEmailForUpdate("nobody@example.com")).thenReturn(Optional.empty());

        assertThrows(ApiException.class, () -> service.login(new LoginRequest("nobody@example.com", PASSWORD)));

        verify(encoder).matches(eq(PASSWORD), anyString());
    }

    @Test
    void loginWithPasswordOver72BytesIsBadCredentialsNotServerError() {
        // 14 ký tự có dấu x 5 = 70 ký tự nhưng hơn 72 byte
        String tooLong = "mậtkhẩuđặcbiệt".repeat(5);

        ApiException e = failLogin(tooLong);

        assertEquals(HttpStatus.UNAUTHORIZED, e.getStatus());
    }

    @Test
    void bcryptRefusesToEncodeMoreThan72BytesSoRegistrationMustRejectThem() {
        assertThrows(IllegalArgumentException.class, () -> new BCryptPasswordEncoder(4).encode("a".repeat(73)));
    }
}
