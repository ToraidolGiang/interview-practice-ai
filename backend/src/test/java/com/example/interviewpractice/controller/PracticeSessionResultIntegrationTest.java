package com.example.interviewpractice.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.service.ScoreResultWriter;
import com.example.interviewpractice.service.ScoredAnswer;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.DeliveryCalculator;
import com.example.interviewpractice.service.scoring.DeliveryMetrics;
import com.example.interviewpractice.service.scoring.ScoreOutcome;

class PracticeSessionResultIntegrationTest extends AbstractSessionApiTest {

    @Autowired
    private ScoreResultWriter writer;

    private ScoredAnswer scored(UUID sessionId, boolean withDelivery) {
        Optional<DeliveryMetrics> delivery = withDelivery
                ? Optional.of(new DeliveryMetrics(120, 128, 6, new BigDecimal("4.10"), new BigDecimal("4.00"),
                        DeliveryCalculator.FILLER_LIST_VERSION))
                : Optional.empty();
        return new ScoredAnswer(sessionId, "nhóm tôi bị trễ tiến độ hai tuần", Question.Type.BEHAVIORAL,
                List.of(new CriterionScore(Code.DEPTH, 3, "Có ví dụ.", "giảm được ba ngày", false),
                        new CriterionScore(Code.RELEVANCE, 4, "Đúng trọng tâm.", "trễ tiến độ", false),
                        new CriterionScore(Code.STRUCTURE, 2, "Thiếu kết quả.", "không có trong transcript", true)),
                delivery, new ScoreOutcome(new BigDecimal("57.5"), new BigDecimal("55.6")), false, true,
                "Nên bổ sung kết quả đo được.", "Câu trả lời mẫu.");
    }

    private PracticeSession processing() {
        return newSession(owner, PracticeSession.Status.PROCESSING);
    }

    @Test
    void sessionScoredGets200WithVersionsTranscriptAndPerCriterionDetails() throws Exception {
        PracticeSession session = processing();
        writer.save(scored(session.getId(), true));

        mvc.perform(get("/practice-sessions/" + session.getId() + "/result").header("Authorization", ownerToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.sessionId").value(session.getId().toString()))
                .andExpect(jsonPath("$.rubricVersion").value("rubric-v1.0"))
                .andExpect(jsonPath("$.promptVersion").value("prompt-v1"))
                .andExpect(jsonPath("$.modelVersion").isNotEmpty())
                .andExpect(jsonPath("$.delivery.fillerListVersion").value("filler-vi-v1"))
                .andExpect(jsonPath("$.delivery.wpm").value(128))
                .andExpect(jsonPath("$.transcript").value("nhóm tôi bị trễ tiến độ hai tuần"))
                .andExpect(jsonPath("$.questionType").value("BEHAVIORAL"))
                .andExpect(jsonPath("$.totalScore").value(57.5))
                .andExpect(jsonPath("$.contentScore").value(55.6))
                .andExpect(jsonPath("$.injectionSuspected").value(true))
                .andExpect(jsonPath("$.feedbackText").value("Nên bổ sung kết quả đo được."))
                // Thứ tự theo rubric, không theo thứ tự lưu
                .andExpect(jsonPath("$.criteria[0].code").value("RELEVANCE"))
                .andExpect(jsonPath("$.criteria[0].score").value(4))
                .andExpect(jsonPath("$.criteria[0].weight").value(20))
                .andExpect(jsonPath("$.criteria[0].quote").value("trễ tiến độ"))
                .andExpect(jsonPath("$.criteria[0].reasoning").value("Đúng trọng tâm."))
                .andExpect(jsonPath("$.criteria[1].code").value("STRUCTURE"))
                .andExpect(jsonPath("$.criteria[1].quoteInvalid").value(true))
                .andExpect(jsonPath("$.criteria[2].code").value("DEPTH"))
                .andExpect(jsonPath("$.criteria[2].weight").value(40));
    }

    @Test
    void scoredWithoutDeliveryReturnsNullDelivery() throws Exception {
        PracticeSession session = processing();
        writer.save(scored(session.getId(), false));

        mvc.perform(get("/practice-sessions/" + session.getId() + "/result").header("Authorization", ownerToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.delivery").value(org.hamcrest.Matchers.nullValue()));
    }

    @Test
    void sessionNotScoredGets409SessionNotReady() throws Exception {
        for (PracticeSession.Status s : List.of(PracticeSession.Status.CREATED, PracticeSession.Status.UPLOADED,
                PracticeSession.Status.PROCESSING, PracticeSession.Status.FAILED)) {
            PracticeSession session = newSession(owner, s);
            mvc.perform(get("/practice-sessions/" + session.getId() + "/result")
                            .header("Authorization", ownerToken))
                    .andExpect(status().isConflict())
                    .andExpect(jsonPath("$.code").value("SESSION_NOT_READY"));
        }
    }

    @Test
    void resultOfAnotherUserGets403() throws Exception {
        PracticeSession session = newSession(other, PracticeSession.Status.PROCESSING);
        writer.save(scored(session.getId(), true));

        mvc.perform(get("/practice-sessions/" + session.getId() + "/result").header("Authorization", ownerToken))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.code").value("FORBIDDEN"));
    }

    @Test
    void unknownSessionGets404() throws Exception {
        mvc.perform(get("/practice-sessions/" + UUID.randomUUID() + "/result").header("Authorization", ownerToken))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }

    @Test
    void withoutTokenGets401() throws Exception {
        mvc.perform(get("/practice-sessions/" + UUID.randomUUID() + "/result"))
                .andExpect(status().isUnauthorized());
    }
}
