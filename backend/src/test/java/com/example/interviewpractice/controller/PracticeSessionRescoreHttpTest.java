package com.example.interviewpractice.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.service.ScoreResultWriter;
import com.example.interviewpractice.service.ScoredAnswer;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.ScoreOutcome;

/** Tầng HTTP của POST /practice-sessions/{id}/rescore: ánh xạ, xác thực đầu vào và mã trạng thái. */
class PracticeSessionRescoreHttpTest extends AbstractSessionApiTest {

    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    @Autowired
    private ScoreResultWriter writer;

    private org.springframework.test.web.servlet.ResultActions rescore(UUID id, String body, String token)
            throws Exception {
        return mvc.perform(post("/practice-sessions/" + id + "/rescore").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(body));
    }

    private static String body(int words) {
        return "{\"transcript\":\"" + "nhóm ".repeat(words).trim() + "\"}";
    }

    @Test
    void scoredSessionWithEnoughWordsGets202Processing() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.PROCESSING);
        writer.save(new ScoredAnswer(session.getId(), "nhóm tôi bị trễ tiến độ hai tuần", Question.Type.BEHAVIORAL,
                List.of(new CriterionScore(Code.DEPTH, 3, "Có ví dụ.", "trễ tiến độ", false),
                        new CriterionScore(Code.RELEVANCE, 4, "Đúng trọng tâm.", "trễ tiến độ", false),
                        new CriterionScore(Code.STRUCTURE, 2, "Thiếu kết quả.", "trễ tiến độ", false)),
                Optional.empty(), new ScoreOutcome(new BigDecimal("57.5"), new BigDecimal("55.6")), false, false,
                "Nên bổ sung.", "Mẫu."));

        rescore(session.getId(), body(20), ownerToken).andExpect(status().isAccepted())
                .andExpect(jsonPath("$.status").value("PROCESSING"));

        verify(executor).execute(any());
    }

    @Test
    void blankTranscriptGets400ValidationError() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.SCORED);

        rescore(session.getId(), "{\"transcript\":\"   \"}", ownerToken).andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
        verify(executor, never()).execute(any());
    }

    @Test
    void shortTranscriptGets400AnswerTooShort() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.SCORED);

        rescore(session.getId(), body(5), ownerToken).andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("ANSWER_TOO_SHORT"));
    }

    @Test
    void otherUsersSessionGets403AndNoTokenGets401() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.SCORED);

        rescore(session.getId(), body(20), otherToken).andExpect(status().isForbidden());
        mvc.perform(post("/practice-sessions/" + session.getId() + "/rescore")
                .contentType(MediaType.APPLICATION_JSON).content(body(20))).andExpect(status().isUnauthorized());
    }
}
