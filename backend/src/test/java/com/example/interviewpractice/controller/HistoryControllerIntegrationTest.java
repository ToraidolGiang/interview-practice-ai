package com.example.interviewpractice.controller;

import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion;
import com.example.interviewpractice.entity.ScoreResult;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.ScoreResultRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.JwtService;

/** Cần Postgres như BackendApplicationTests: kiểm tra GET /history và /history/{id} (#118) qua cả tầng bảo mật. */
@SpringBootTest
@AutoConfigureMockMvc
class HistoryControllerIntegrationTest {

    @Autowired
    private MockMvc mvc;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserRepository users;

    @Autowired
    private QuestionRepository questions;

    @Autowired
    private PracticeSessionRepository sessions;

    @Autowired
    private ScoreResultRepository scoreResults;

    private User owner;
    private User other;
    private Question itQuestion;
    private Question marketingQuestion;
    private PracticeSession oldIt;
    private PracticeSession newMarketing;
    private PracticeSession processing;
    private PracticeSession otherUsers;

    @BeforeEach
    void setUp() {
        owner = user("owner");
        other = user("other");
        itQuestion = question(owner, "IT");
        marketingQuestion = question(owner, "Marketing-" + UUID.randomUUID());

        // 2026-10-10 23:30 giờ VN = 16:30 UTC cùng ngày; 2026-10-20 08:00 giờ VN = 01:00 UTC
        oldIt = session(owner, itQuestion, PracticeSession.Status.SCORED, "45.00", "2026-10-10T16:30:00Z");
        newMarketing = session(owner, marketingQuestion, PracticeSession.Status.SCORED, "82.50",
                "2026-10-20T01:00:00Z");
        processing = session(owner, itQuestion, PracticeSession.Status.PROCESSING, null, null);
        otherUsers = session(other, itQuestion, PracticeSession.Status.SCORED, "90.00", "2026-10-21T01:00:00Z");
        scoreResult(newMarketing);
    }

    // Bỏ qua phần tử null để dọn được cả khi setUp hỏng giữa chừng
    @AfterEach
    void cleanUp() {
        if (newMarketing != null) scoreResults.findBySessionId(newMarketing.getId()).ifPresent(scoreResults::delete);
        sessions.deleteAll(nonNull(oldIt, newMarketing, processing, otherUsers));
        questions.deleteAll(nonNull(itQuestion, marketingQuestion));
        users.deleteAll(nonNull(owner, other));
    }

    @SafeVarargs
    private static <T> List<T> nonNull(T... items) {
        return java.util.Arrays.stream(items).filter(java.util.Objects::nonNull).toList();
    }

    @Test
    void requiresLogin() throws Exception {
        mvc.perform(get("/history")).andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("UNAUTHORIZED"));
    }

    @Test
    void listsOnlyOwnScoredSessionsNewestFirst() throws Exception {
        mvc.perform(as(owner, get("/history")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[*].id").value(contains(newMarketing.getId().toString(),
                        oldIt.getId().toString())))
                .andExpect(jsonPath("$.content[0].userId").value(owner.getId().toString()))
                .andExpect(jsonPath("$.content[0].questionId").value(marketingQuestion.getId().toString()))
                .andExpect(jsonPath("$.content[0].status").value("SCORED"))
                .andExpect(jsonPath("$.content[0].totalScore").value(82.5))
                .andExpect(jsonPath("$.content[0].duration").value(95))
                .andExpect(jsonPath("$.content[0].audioUrl").value(nullValue()))
                .andExpect(jsonPath("$.page").value(0))
                .andExpect(jsonPath("$.size").value(20))
                .andExpect(jsonPath("$.totalElements").value(2))
                .andExpect(jsonPath("$.totalPages").value(1));
    }

    @Test
    void filtersByVietnamDateIndustryAndScore() throws Exception {
        // 23:30 ngày 10/10 giờ VN vẫn thuộc ngày 10/10 dù đã là 16:30 UTC
        mvc.perform(as(owner, get("/history").param("from", "2026-10-10").param("to", "2026-10-10")))
                .andExpect(jsonPath("$.content[*].id").value(contains(oldIt.getId().toString())));
        mvc.perform(as(owner, get("/history").param("industry", marketingQuestion.getIndustry())))
                .andExpect(jsonPath("$.content[*].id").value(contains(newMarketing.getId().toString())));
        mvc.perform(as(owner, get("/history").param("minScore", "50").param("maxScore", "100")))
                .andExpect(jsonPath("$.content[*].id").value(contains(newMarketing.getId().toString())));
    }

    @Test
    void paginates() throws Exception {
        mvc.perform(as(owner, get("/history").param("page", "1").param("size", "1")))
                .andExpect(jsonPath("$.content[*].id").value(contains(oldIt.getId().toString())))
                .andExpect(jsonPath("$.totalElements").value(2))
                .andExpect(jsonPath("$.totalPages").value(2));
    }

    @Test
    void rejectsInvalidFilters() throws Exception {
        mvc.perform(as(owner, get("/history").param("size", "101").param("minScore", "80").param("maxScore", "20")))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[*].field").value(contains("size", "minScore")));
    }

    @Test
    void detailIncludesScoreResult() throws Exception {
        mvc.perform(as(owner, get("/history/{id}", newMarketing.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(newMarketing.getId().toString()))
                .andExpect(jsonPath("$.status").value("SCORED"))
                .andExpect(jsonPath("$.scoreResult.sessionId").value(newMarketing.getId().toString()))
                .andExpect(jsonPath("$.scoreResult.questionType").value("BEHAVIORAL"))
                .andExpect(jsonPath("$.scoreResult.criteria[*].code").value(contains("RELEVANCE", "STRUCTURE")))
                .andExpect(jsonPath("$.scoreResult.criteria[1].quote").value("tôi chia lại việc"))
                .andExpect(jsonPath("$.scoreResult.delivery.wpm").value(128))
                .andExpect(jsonPath("$.scoreResult.delivery.fillerListVersion").value("filler-vi-v1"))
                .andExpect(jsonPath("$.scoreResult.ttsAudioUrl").value(nullValue()));
    }

    @Test
    void detailWithoutScoreResultHasNullScoreResult() throws Exception {
        mvc.perform(as(owner, get("/history/{id}", processing.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("PROCESSING"))
                .andExpect(jsonPath("$.scoreResult").value(nullValue()));
    }

    @Test
    void detailOfAnotherUsersSessionIsForbidden() throws Exception {
        mvc.perform(as(owner, get("/history/{id}", otherUsers.getId())))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.code").value("FORBIDDEN"));
    }

    @Test
    void detailOfMissingSessionIsNotFound() throws Exception {
        mvc.perform(as(owner, get("/history/{id}", UUID.randomUUID())))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }

    private MockHttpServletRequestBuilder as(User user, MockHttpServletRequestBuilder request) {
        return request.header("Authorization", "Bearer " + jwtService.generate(user));
    }

    private User user(String name) {
        User u = new User();
        u.setFullName("Người dùng " + name);
        u.setEmail("history-" + name + "-" + UUID.randomUUID() + "@example.com");
        u.setPasswordHash("$2a$04$khongdungdedangnhapkhongdungdedangnhapkhongdungde12");
        return users.save(u);
    }

    private Question question(User creator, String industry) {
        Question q = new Question();
        // Bảng questions có ràng buộc duy nhất (position, content)
        q.setContent("Câu hỏi thử cho lịch sử " + UUID.randomUUID());
        q.setIndustry(industry);
        q.setPosition("Chung");
        q.setLevel(Question.Level.EASY);
        q.setQuestionType(Question.Type.BEHAVIORAL);
        q.setCreatedBy(creator);
        return questions.save(q);
    }

    private PracticeSession session(User user, Question question, PracticeSession.Status status, String score,
            String completedAt) {
        PracticeSession s = new PracticeSession();
        s.setUser(user);
        s.setQuestion(question);
        s.setStatus(status);
        s.setDurationSec(95);
        s.setTotalScore(score == null ? null : new BigDecimal(score));
        s.setCompletedAt(completedAt == null ? null : Instant.parse(completedAt));
        return sessions.save(s);
    }

    private void scoreResult(PracticeSession session) {
        ScoreResult r = new ScoreResult();
        r.setSession(session);
        r.setTranscript("Trong dự án trước tôi chia lại việc cho cả nhóm.");
        r.setQuestionType(Question.Type.BEHAVIORAL);
        r.setTotalScore(new BigDecimal("82.50"));
        r.setContentScore(new BigDecimal("80.00"));
        r.setWpm(128);
        r.setFillerCount(3);
        r.setFillerRate(new BigDecimal("2.10"));
        r.setDeliveryScore(new BigDecimal("4.00"));
        r.setFillerListVersion("filler-vi-v1");
        r.setFeedbackText("Nên bổ sung kết quả đo được.");
        r.setRubricVersion("rubric-v1.0");
        r.setPromptVersion("prompt-v1");
        r.setModelVersion("gemini-flash");
        // Lưu STRUCTURE trước để kiểm tra API vẫn trả theo thứ tự rubric
        r.addCriterion(criterion(ScoreCriterion.Code.STRUCTURE, 4, 30, "tôi chia lại việc"));
        r.addCriterion(criterion(ScoreCriterion.Code.RELEVANCE, 5, 20, null));
        scoreResults.save(r);
    }

    private static ScoreCriterion criterion(ScoreCriterion.Code code, int score, int weight, String quote) {
        ScoreCriterion c = new ScoreCriterion();
        c.setCode(code);
        c.setScore((short) score);
        c.setWeight((short) weight);
        c.setReasoning("Lý do chấm " + code);
        c.setQuote(quote);
        return c;
    }
}
