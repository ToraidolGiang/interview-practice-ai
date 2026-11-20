package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.security.AuthUser;

/** F4: một user có đủ số phiên PROCESSING thì /evaluate trả 429, user khác không bị ảnh hưởng. */
class EvaluationUserLimitTest extends AbstractSessionApiTest {

    @Autowired
    private EvaluationService evaluation;

    @Test
    void userAtLimitGetsTooManyRequestsAndSessionStaysUploaded() {
        for (int i = 0; i < 3; i++) {
            newSession(owner, PracticeSession.Status.PROCESSING);
        }
        PracticeSession waiting = newSession(owner, PracticeSession.Status.UPLOADED);

        assertThatThrownBy(() -> evaluation.submit(waiting.getId(),
                new AuthUser(owner.getId(), owner.getEmail(), owner.getRole())))
                .isInstanceOfSatisfying(ApiException.class, e -> {
                    assertThat(e.getStatus()).isEqualTo(HttpStatus.TOO_MANY_REQUESTS);
                    assertThat(e.getCode()).isEqualTo("TOO_MANY_PROCESSING");
                });
        assertThat(statusOf(waiting.getId())).isEqualTo("UPLOADED");
    }
}
