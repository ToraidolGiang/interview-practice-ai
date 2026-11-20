package com.example.interviewpractice.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.test.web.servlet.MvcResult;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.security.JwtService;

/** UC9 / #163: thống kê cho admin. Dữ liệu đặt ở ngày 2001-05-05 để khoảng from=to cho số liệu chính xác. */
class AdminAnalyticsIntegrationTest extends AbstractSessionApiTest {

    private static final String DAY = "2001-05-05";

    @Autowired
    private JwtService jwt;

    private User admin;
    private String adminToken;
    private PracticeSession scored;

    @BeforeEach
    void data() {
        admin = newUser();
        admin.setRole(User.Role.ADMIN);
        admin = users.save(admin);
        adminToken = "Bearer " + jwt.generate(admin);

        scored = newSession(owner, PracticeSession.Status.SCORED);
        PracticeSession failed = newSession(owner, PracticeSession.Status.FAILED);
        for (PracticeSession s : new PracticeSession[] {scored, failed}) {
            jdbc.update("update practice_sessions set started_at = timestamptz '" + DAY + " 10:00:00+07' where id = ?",
                    s.getId());
        }
        jdbc.update("update practice_sessions set total_score = 80 where id = ?", scored.getId());
        usage(scored.getId(), "STT", "0.010000");
        usage(scored.getId(), "LLM", "0.002000");
        usage(scored.getId(), "LLM", "0.002000");
    }

    @AfterEach
    void removeAdmin() {
        jdbc.update("delete from users where id = ?", admin.getId());
    }

    private void usage(UUID sessionId, String provider, String cost) {
        jdbc.update("insert into api_usages (session_id, provider, called_at, latency_ms, estimated_cost) values "
                + "(?, ?, timestamptz '" + DAY + " 10:05:00+07', 100, " + cost + ")", sessionId, provider);
    }

    @Test
    void overviewCountsOnlyTheRequestedRange() throws Exception {
        mvc.perform(get("/admin/analytics/overview").param("from", DAY).param("to", DAY)
                .header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.activeUsers").value(1))
                .andExpect(jsonPath("$.totalSessions").value(2))
                .andExpect(jsonPath("$.scoredSessions").value(1))
                .andExpect(jsonPath("$.averageScore").value(80.0))
                .andExpect(jsonPath("$.aiApiCalls.stt").value(1))
                .andExpect(jsonPath("$.aiApiCalls.llm").value(2))
                .andExpect(jsonPath("$.aiApiCalls.tts").value(0))
                .andExpect(jsonPath("$.estimatedCost").value(0.014))
                .andExpect(jsonPath("$.totalUsers").isNumber());
    }

    @Test
    void emptyRangeGivesZeroesAndNullAverage() throws Exception {
        mvc.perform(get("/admin/analytics/overview").param("from", "2001-05-06").param("to", "2001-05-07")
                .header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalSessions").value(0))
                .andExpect(jsonPath("$.averageScore").value(org.hamcrest.Matchers.nullValue()))
                .andExpect(jsonPath("$.estimatedCost").value(0));
    }

    @Test
    void fromAfterToGets400() throws Exception {
        mvc.perform(get("/admin/analytics/overview").param("from", "2001-05-07").param("to", "2001-05-06")
                .header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    void candidateGets403AndAnonymousGets401() throws Exception {
        mvc.perform(get("/admin/analytics/overview").header(HttpHeaders.AUTHORIZATION, ownerToken))
                .andExpect(status().isForbidden());
        mvc.perform(get("/admin/analytics/overview")).andExpect(status().isUnauthorized());
        mvc.perform(get("/admin/analytics/export").header(HttpHeaders.AUTHORIZATION, ownerToken))
                .andExpect(status().isForbidden());
    }

    @Test
    void userActivityShowsTotalsAverageAndRecentSessionsWithoutSecrets() throws Exception {
        MvcResult result = mvc.perform(get("/admin/analytics/users/" + owner.getId())
                .header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(owner.getId().toString()))
                .andExpect(jsonPath("$.email").value(owner.getEmail()))
                .andExpect(jsonPath("$.totalSessions").value(2))
                .andExpect(jsonPath("$.averageScore").value(80.0))
                .andExpect(jsonPath("$.lastPracticeAt").isNotEmpty())
                .andExpect(jsonPath("$.recentSessions.length()").value(2))
                .andReturn();
        assertThat(result.getResponse().getContentAsString()).doesNotContain("passwordHash");
    }

    @Test
    void unknownUserGets404() throws Exception {
        mvc.perform(get("/admin/analytics/users/" + UUID.randomUUID()).header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isNotFound());
    }

    @Test
    void csvExportHasHeaderRowsAndNeutralisesFormulas() throws Exception {
        jdbc.update("update users set full_name = '=HYPERLINK(\"x\")' where id = ?", owner.getId());

        MvcResult result = mvc.perform(get("/admin/analytics/export").param("from", DAY).param("to", DAY)
                .header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith("text/csv"))
                .andReturn();
        String csv = result.getResponse().getContentAsString(java.nio.charset.StandardCharsets.UTF_8);

        assertThat(csv).startsWith("﻿Họ tên,Email");
        assertThat(csv).contains("\"'=HYPERLINK(\"\"x\"\")\",\"" + owner.getEmail() + "\",2,1,80.00,");
        assertThat(result.getResponse().getHeader(HttpHeaders.CONTENT_DISPOSITION)).contains("bao-cao-hoat-dong.csv");
    }

    @Test
    void xlsxFormatIsRejectedWith400() throws Exception {
        mvc.perform(get("/admin/analytics/export").param("format", "xlsx")
                .header(HttpHeaders.AUTHORIZATION, adminToken))
                .andExpect(status().isBadRequest());
    }
}
