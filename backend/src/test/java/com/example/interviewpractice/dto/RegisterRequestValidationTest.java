package com.example.interviewpractice.dto;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Set;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Test;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.ValidatorFactory;

class RegisterRequestValidationTest {

    private static final ValidatorFactory FACTORY = Validation.buildDefaultValidatorFactory();

    @AfterAll
    static void close() {
        FACTORY.close();
    }

    private static Set<ConstraintViolation<RegisterRequest>> validate(String password) {
        return FACTORY.getValidator().validate(
                new RegisterRequest("Nguyễn Văn A", "cand@example.com", password, password));
    }

    @Test
    void passwordOf56AccentedCharsButOver72BytesIsRejectedOnPasswordField() {
        // Ca Tuấn Anh tái hiện: 56 ký tự, 92 byte; trước đây lọt validation rồi BCrypt ném lỗi gây 500
        String password = "mậtkhẩuđặcbiệt".repeat(4);
        assertEquals(56, password.length());

        Set<ConstraintViolation<RegisterRequest>> violations = validate(password);

        assertEquals(1, violations.size());
        ConstraintViolation<RegisterRequest> violation = violations.iterator().next();
        assertEquals("password", violation.getPropertyPath().toString());
        assertTrue(violation.getMessage().contains("72 byte"), violation.getMessage());
    }

    @Test
    void passwordOfExactly72BytesIsAccepted() {
        assertTrue(validate("a".repeat(72)).isEmpty());
        // "ậ" chiếm 3 byte: 24 ký tự = 72 byte
        assertTrue(validate("ậ".repeat(24)).isEmpty());
    }

    @Test
    void passwordOf73BytesIsRejected() {
        assertEquals(1, validate("a".repeat(73)).size());
        assertEquals(1, validate("ậ".repeat(24) + "a").size());
    }

    @Test
    void passwordShorterThan8CharsIsStillRejected() {
        assertEquals(1, validate("abc123").size());
    }
}
