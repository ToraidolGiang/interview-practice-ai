package com.example.interviewpractice.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.example.interviewpractice.dto.PageResponse;
import com.example.interviewpractice.dto.QuestionDto;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.exception.GlobalExceptionHandler;
import com.example.interviewpractice.service.QuestionService;

class QuestionControllerTest {

    private final QuestionService service = mock(QuestionService.class);
    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.standaloneSetup(new QuestionController(service))
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    private static QuestionDto dto() {
        return new QuestionDto(UUID.randomUUID(), "Giới thiệu bản thân", "IT", "Chung", Question.Level.EASY,
                Question.Type.INTRO, "Nêu kinh nghiệm chính", Question.Status.ACTIVE, UUID.randomUUID(),
                Instant.parse("2026-10-28T00:00:00Z"));
    }

    @Test
    void listUsesDefaultsAndReturnsOpenApiPageShape() throws Exception {
        when(service.search(null, null, null, null, null, 0, 20))
                .thenReturn(new PageResponse<>(List.of(dto()), 0, 20, 1, 1));

        mvc.perform(get("/questions"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].content").value("Giới thiệu bản thân"))
                .andExpect(jsonPath("$.page").value(0))
                .andExpect(jsonPath("$.size").value(20))
                .andExpect(jsonPath("$.totalElements").value(1))
                .andExpect(jsonPath("$.totalPages").value(1))
                .andExpect(jsonPath("$.content[0].referenceAnswer").doesNotExist());
    }

    @Test
    void listPassesFiltersAndTreatsBlankValuesAsAbsent() throws Exception {
        when(service.search(any(), any(), any(), any(), any(), eq(2), eq(50)))
                .thenReturn(new PageResponse<>(List.of(), 2, 50, 0, 0));

        mvc.perform(get("/questions")
                        .param("industry", "IT")
                        .param("position", "   ")
                        .param("level", "HARD")
                        .param("questionType", "TECHNICAL")
                        .param("keyword", "spring")
                        .param("page", "2")
                        .param("size", "50"))
                .andExpect(status().isOk());

        verify(service).search(eq("IT"), isNull(), eq(Question.Level.HARD), eq(Question.Type.TECHNICAL),
                eq("spring"), eq(2), eq(50));
    }

    @Test
    void unknownLevelIs400OnTheLevelField() throws Exception {
        mvc.perform(get("/questions").param("level", "FOO"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[0].field").value("level"));
        verifyNoInteractions(service);
    }

    @Test
    void levelIsCaseSensitive() throws Exception {
        mvc.perform(get("/questions").param("level", "easy"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("level"));
    }

    @Test
    void sizeAboveLimitIs400OnTheSizeField() throws Exception {
        mvc.perform(get("/questions").param("size", "101"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[0].field").value("size"));
        verifyNoInteractions(service);
    }

    @Test
    void sizeZeroAndNegativePageAreRejected() throws Exception {
        mvc.perform(get("/questions").param("size", "0"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("size"));
        mvc.perform(get("/questions").param("page", "-1"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("page"));
    }

    @Test
    void nonNumericPageIs400() throws Exception {
        mvc.perform(get("/questions").param("page", "abc"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("page"));
    }

    @Test
    void keywordLongerThan200CharactersIs400() throws Exception {
        mvc.perform(get("/questions").param("keyword", "a".repeat(201)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("keyword"));
        verifyNoInteractions(service);
    }

    @Test
    void randomRejectsUnknownLevel() throws Exception {
        mvc.perform(get("/questions/random").param("level", "FOO"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("level"));
    }

    @Test
    void randomReturnsOneQuestion() throws Exception {
        when(service.random("IT", "Backend Developer", null)).thenReturn(dto());

        mvc.perform(get("/questions/random").param("industry", "IT").param("position", "Backend Developer"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.industry").value("IT"));
    }

    @Test
    void detailWithMalformedUuidIs400() throws Exception {
        mvc.perform(get("/questions/khong-phai-uuid"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[0].field").value("id"));
    }
}
