package com.example.interviewpractice.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import com.example.interviewpractice.config.JwtProperties;
import com.example.interviewpractice.entity.User;

class JwtServiceTest {

    private static final String SECRET = "test-secret-test-secret-test-secret-123456";
    private static final Instant NOW = Instant.parse("2026-10-27T03:00:00Z");

    private static JwtService serviceAt(Instant instant, String secret) {
        return new JwtService(new JwtProperties(secret, 24), Clock.fixed(instant, ZoneOffset.UTC));
    }

    private static User user() {
        User user = new User();
        user.setId(UUID.randomUUID());
        user.setEmail("cand@example.com");
        user.setRole(User.Role.ADMIN);
        return user;
    }

    @Test
    void tokenRoundTripKeepsIdentity() {
        User user = user();
        JwtService service = serviceAt(NOW, SECRET);

        AuthUser parsed = service.parse(service.generate(user)).orElseThrow();

        assertEquals(user.getId(), parsed.id());
        assertEquals("cand@example.com", parsed.email());
        assertEquals(User.Role.ADMIN, parsed.role());
    }

    @Test
    void tokenIsValidJustBeforeExpiryAndRejectedAfter() {
        String token = serviceAt(NOW, SECRET).generate(user());

        assertTrue(serviceAt(NOW.plus(Duration.ofHours(24)).minusSeconds(1), SECRET).parse(token).isPresent());
        assertTrue(serviceAt(NOW.plus(Duration.ofHours(24)), SECRET).parse(token).isEmpty());
    }

    @Test
    void tokenSignedWithAnotherSecretIsRejected() {
        String token = serviceAt(NOW, "another-secret-another-secret-123456789").generate(user());

        assertTrue(serviceAt(NOW, SECRET).parse(token).isEmpty());
    }

    @Test
    void malformedTokenIsRejected() {
        JwtService service = serviceAt(NOW, SECRET);

        assertTrue(service.parse("khong-phai-jwt").isEmpty());
        assertTrue(service.parse("").isEmpty());
    }

    @Test
    void shortSecretFailsFast() {
        assertThrows(IllegalStateException.class, () -> serviceAt(NOW, "too-short"));
    }
}
