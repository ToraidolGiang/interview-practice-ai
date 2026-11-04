package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.DeliveryCalculator;
import com.example.interviewpractice.service.scoring.DeliveryMetrics;
import com.example.interviewpractice.service.scoring.ScoreOutcome;

@SpringBootTest
class ScoreResultWriterTest {

    @Autowired
    private ScoreResultWriter writer;
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
        user.setEmail("writer-" + UUID.randomUUID() + "@example.com");
        user.setPasswordHash("!khong-dang-nhap-bang-mat-khau");
        user.setRole(User.Role.CANDIDATE);
        user = users.save(user);

        Question q = new Question();
        q.setContent("Câu hỏi writer " + UUID.randomUUID());
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
        session.setStatus(PracticeSession.Status.PROCESSING);
        session = sessions.save(session);
    }

    @AfterEach
    void cleanUp() {
        jdbc.update("delete from practice_sessions where user_id = ?", user.getId());
        jdbc.update("delete from questions where created_by = ?", user.getId());
        jdbc.update("delete from users where id = ?", user.getId());
    }

    private ScoredAnswer answer(int score, String total, boolean withDelivery) {
        Optional<DeliveryMetrics> delivery = withDelivery
                ? Optional.of(new DeliveryMetrics(60, 120, 1, new BigDecimal("1.67"), new BigDecimal("4.50"),
                        DeliveryCalculator.FILLER_LIST_VERSION))
                : Optional.empty();
        return new ScoredAnswer(session.getId(), "transcript " + total, Question.Type.TECHNICAL,
                List.of(new CriterionScore(Code.RELEVANCE, score, "r", "q", false),
                        new CriterionScore(Code.STRUCTURE, score, "r", "q", false),
                        new CriterionScore(Code.DEPTH, score, "r", "q", false),
                        new CriterionScore(Code.CORRECTNESS, score, "r", "q", false)),
                delivery, new ScoreOutcome(new BigDecimal(total), new BigDecimal(total)), false, false,
                "nhận xét", null);
    }

    private int count(String table, String column, UUID id) {
        return jdbc.queryForObject("select count(*) from " + table + " where " + column + " = ?", Integer.class, id);
    }

    @Test
    void saveStoresResultCriteriaWithOriginalWeightsAndMarksSessionScored() {
        writer.save(answer(4, "75.0", true));

        assertThat(jdbc.queryForObject("select status from practice_sessions where id = ?", String.class,
                session.getId())).isEqualTo("SCORED");
        assertThat(jdbc.queryForObject("select total_score from practice_sessions where id = ?", BigDecimal.class,
                session.getId())).isEqualByComparingTo("75.0");
        assertThat(jdbc.queryForObject("select completed_at is not null from practice_sessions where id = ?",
                Boolean.class, session.getId())).isTrue();
        assertThat(jdbc.queryForObject("select filler_list_version from score_results where session_id = ?",
                String.class, session.getId())).isEqualTo("filler-vi-v1");
        assertThat(jdbc.queryForObject("select rubric_version from score_results where session_id = ?",
                String.class, session.getId())).isEqualTo("rubric-v1.0");
        List<Integer> weights = jdbc.queryForList("""
                select c.weight from score_criteria c join score_results r on r.id = c.result_id
                where r.session_id = ? order by c.weight""", Integer.class, session.getId());
        assertThat(weights).containsExactly(15, 15, 25, 35);
    }

    @Test
    void saveWithoutDeliveryLeavesDeliveryColumnsNull() {
        writer.save(answer(3, "50.0", false));

        assertThat(jdbc.queryForObject("select delivery_score is null and filler_list_version is null "
                + "from score_results where session_id = ?", Boolean.class, session.getId())).isTrue();
    }

    @Test
    void rescoreOverwritesOldResultWithoutViolatingUniqueSessionConstraint() {
        writer.save(answer(2, "25.0", true));
        // Chấm lại: phiên về PROCESSING rồi ghi đè
        jdbc.update("update practice_sessions set status = 'PROCESSING' where id = ?", session.getId());

        writer.save(answer(5, "100.0", false));

        assertThat(count("score_results", "session_id", session.getId())).isEqualTo(1);
        assertThat(jdbc.queryForObject("select transcript from score_results where session_id = ?", String.class,
                session.getId())).isEqualTo("transcript 100.0");
        assertThat(jdbc.queryForObject("""
                select count(*) from score_criteria c join score_results r on r.id = c.result_id
                where r.session_id = ?""", Integer.class, session.getId())).isEqualTo(4);
        assertThat(jdbc.queryForObject("select total_score from practice_sessions where id = ?", BigDecimal.class,
                session.getId())).isEqualByComparingTo("100.0");
    }

    @Test
    void saveRollsBackWhenSessionIsNoLongerProcessing() {
        jdbc.update("update practice_sessions set status = 'FAILED', error_code = 'SERVER_RESTART' where id = ?",
                session.getId());

        assertThatThrownBy(() -> writer.save(answer(4, "75.0", true))).isInstanceOf(IllegalStateException.class);

        assertThat(count("score_results", "session_id", session.getId())).isZero();
        assertThat(jdbc.queryForObject("select status from practice_sessions where id = ?", String.class,
                session.getId())).isEqualTo("FAILED");
    }
}
