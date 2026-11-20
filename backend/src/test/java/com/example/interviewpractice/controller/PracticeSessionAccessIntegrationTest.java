package com.example.interviewpractice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

import com.example.interviewpractice.entity.PracticeSession;

class PracticeSessionAccessIntegrationTest extends AbstractSessionApiTest {

    @Test
    void getSessionOfAnotherUserGets403() throws Exception {
        PracticeSession session = newSession(other, PracticeSession.Status.CREATED);
        mvc.perform(get("/practice-sessions/" + session.getId()).header("Authorization", ownerToken))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.code").value("FORBIDDEN"));
    }

    @Test
    void getUnknownSessionGets404() throws Exception {
        mvc.perform(get("/practice-sessions/" + UUID.randomUUID()).header("Authorization", ownerToken))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }

    @Test
    void uploadToSessionOfAnotherUserGets403AndKeepsStatus() throws Exception {
        PracticeSession session = newSession(other, PracticeSession.Status.CREATED);
        mvc.perform(multipart("/practice-sessions/" + session.getId() + "/answer")
                        .file(new MockMultipartFile("audio", "a.webm", "audio/webm", new byte[] {1, 2, 3}))
                        .param("durationSeconds", "30").header("Authorization", ownerToken))
                .andExpect(status().isForbidden());
        assertEquals("CREATED", statusOf(session.getId()));
    }
}
