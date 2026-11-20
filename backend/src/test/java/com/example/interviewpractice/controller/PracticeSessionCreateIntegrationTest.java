package com.example.interviewpractice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.ResultActions;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;

class PracticeSessionCreateIntegrationTest extends AbstractSessionApiTest {

    private ResultActions create(Object questionId, String token) throws Exception {
        var request = post("/practice-sessions").contentType(MediaType.APPLICATION_JSON)
                .content(json.writeValueAsString(Map.of("questionId", questionId)).getBytes(StandardCharsets.UTF_8));
        return mvc.perform(token == null ? request : request.header("Authorization", token));
    }

    @Test
    void createsSessionInCreatedStatusForActiveQuestion() throws Exception {
        create(activeQuestion.getId(), ownerToken)
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("CREATED"))
                .andExpect(jsonPath("$.userId").value(owner.getId().toString()))
                .andExpect(jsonPath("$.questionId").value(activeQuestion.getId().toString()))
                .andExpect(jsonPath("$.audioUrl").doesNotExist());
        assertEquals(1, sessions.findByUserIdOrderByStartedAtDesc(owner.getId(), Pageable.unpaged())
                .getTotalElements());
    }

    @Test
    void unknownQuestionGets404() throws Exception {
        create(UUID.randomUUID(), ownerToken).andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }

    @Test
    void hiddenQuestionGets404() throws Exception {
        Question hidden = newQuestion(Question.Status.HIDDEN);
        create(hidden.getId(), ownerToken).andExpect(status().isNotFound());
    }

    @Test
    void missingQuestionIdGets400() throws Exception {
        mvc.perform(post("/practice-sessions").header("Authorization", ownerToken)
                        .contentType(MediaType.APPLICATION_JSON).content("{}"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    void requestsWithoutTokenGet401() throws Exception {
        create(activeQuestion.getId(), null).andExpect(status().isUnauthorized());
        mvc.perform(get("/practice-sessions/" + UUID.randomUUID())).andExpect(status().isUnauthorized());
        mvc.perform(post("/practice-sessions/" + UUID.randomUUID() + "/answer")).andExpect(status().isUnauthorized());
    }

    @Test
    void getReturnsOwnSessionWithValidStatus() throws Exception {
        for (PracticeSession.Status s : PracticeSession.Status.values()) {
            PracticeSession session = newSession(owner, s);
            mvc.perform(get("/practice-sessions/" + session.getId()).header("Authorization", ownerToken))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.id").value(session.getId().toString()))
                    .andExpect(jsonPath("$.status").value(s.name()));
        }
    }
}
