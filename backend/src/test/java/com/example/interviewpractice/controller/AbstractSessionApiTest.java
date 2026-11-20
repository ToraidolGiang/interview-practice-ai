package com.example.interviewpractice.controller;

import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.JwtService;
import com.example.interviewpractice.service.storage.AudioStorage;

import tools.jackson.databind.json.JsonMapper;

/** Nền chung cho test API phiên luyện tập: Postgres thật, S3 được mock, dữ liệu tự dọn sau mỗi test. */
@SpringBootTest
@AutoConfigureMockMvc
public abstract class AbstractSessionApiTest {

    @Autowired
    protected MockMvc mvc;

    @Autowired
    protected JdbcTemplate jdbc;

    @Autowired
    protected JsonMapper json;

    @Autowired
    protected UserRepository users;

    @Autowired
    protected QuestionRepository questions;

    @Autowired
    protected PracticeSessionRepository sessions;

    @Autowired
    private JwtService jwtService;

    @MockitoBean
    protected AudioStorage storage;

    protected User owner;
    protected User other;
    protected String ownerToken;
    protected String otherToken;
    protected Question activeQuestion;

    @BeforeEach
    void createFixtures() {
        owner = newUser();
        other = newUser();
        ownerToken = "Bearer " + jwtService.generate(owner);
        otherToken = "Bearer " + jwtService.generate(other);
        activeQuestion = newQuestion(Question.Status.ACTIVE);
    }

    @AfterEach
    void cleanUp() {
        // Thứ tự theo khóa ngoại: phiên, câu hỏi, người dùng
        jdbc.update("delete from practice_sessions where user_id in (?, ?)", owner.getId(), other.getId());
        jdbc.update("delete from questions where created_by = ?", owner.getId());
        jdbc.update("delete from users where id in (?, ?)", owner.getId(), other.getId());
    }

    protected User newUser() {
        User user = new User();
        user.setFullName("Người dùng kiểm thử");
        user.setEmail("session-" + UUID.randomUUID() + "@example.com");
        user.setPasswordHash("!khong-dang-nhap-bang-mat-khau");
        user.setRole(User.Role.CANDIDATE);
        return users.save(user);
    }

    protected Question newQuestion(Question.Status status) {
        Question q = new Question();
        q.setContent("Câu hỏi phiên " + UUID.randomUUID());
        q.setIndustry("Marketing");
        q.setPosition("Chuyên viên SEO");
        q.setLevel(Question.Level.MEDIUM);
        q.setQuestionType(Question.Type.BEHAVIORAL);
        q.setStatus(status);
        q.setCreatedBy(owner);
        return questions.save(q);
    }

    protected PracticeSession newSession(User user, PracticeSession.Status status) {
        PracticeSession s = new PracticeSession();
        s.setUser(user);
        s.setQuestion(activeQuestion);
        s.setStatus(status);
        return sessions.save(s);
    }

    protected String statusOf(UUID sessionId) {
        return jdbc.queryForObject("select status from practice_sessions where id = ?", String.class, sessionId);
    }
}
