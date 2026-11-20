package com.example.interviewpractice.repository;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Instant;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.User;

@SpringBootTest
class PracticeSessionRepositoryResetTest {

    @Autowired
    private JdbcTemplate jdbc;
    @Autowired
    private UserRepository users;
    @Autowired
    private QuestionRepository questions;
    @Autowired
    private PracticeSessionRepository sessions;

    private User user;
    private PracticeSession session;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setFullName("Người dùng kiểm thử");
        user.setEmail("reset-" + UUID.randomUUID() + "@example.com");
        user.setPasswordHash("!khong-dang-nhap-bang-mat-khau");
        user.setRole(User.Role.CANDIDATE);
        user = users.save(user);

        Question q = new Question();
        q.setContent("Câu hỏi reset " + UUID.randomUUID());
        q.setIndustry("Marketing");
        q.setPosition("Chuyên viên SEO");
        q.setLevel(Question.Level.MEDIUM);
        q.setQuestionType(Question.Type.TECHNICAL);
        q.setStatus(Question.Status.ACTIVE);
        q.setCreatedBy(user);
        q = questions.save(q);

        session = new PracticeSession();
        session.setUser(user);
        session.setQuestion(q);
        session.setStatus(PracticeSession.Status.FAILED);
        session = sessions.save(session);
        jdbc.update("update practice_sessions set completed_at = ?, error_code = 'STT_FAILED' where id = ?",
                java.sql.Timestamp.from(Instant.now()), session.getId());
    }

    @AfterEach
    void cleanUp() {
        jdbc.update("delete from practice_sessions where user_id = ?", user.getId());
        jdbc.update("delete from questions where created_by = ?", user.getId());
        jdbc.update("delete from users where id = ?", user.getId());
    }

    private boolean completedAtIsNull() {
        return Boolean.TRUE.equals(jdbc.queryForObject(
                "select completed_at is null from practice_sessions where id = ?", Boolean.class, session.getId()));
    }

    @Test
    void markProcessingClearsCompletedAtOfFailedSession() {
        assertThat(completedAtIsNull()).isFalse();
        assertThat(sessions.markProcessing(session.getId(), Instant.now())).isEqualTo(1);
        assertThat(completedAtIsNull()).isTrue();
    }

    @Test
    void markUploadedClearsCompletedAtOfFailedSession() {
        assertThat(completedAtIsNull()).isFalse();
        assertThat(sessions.markUploaded(session.getId(), "audio/k.webm", 30, Instant.now())).isEqualTo(1);
        assertThat(completedAtIsNull()).isTrue();
    }
}
