package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.random.RandomGenerator;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;

import com.example.interviewpractice.dto.PageResponse;
import com.example.interviewpractice.dto.QuestionDto;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.QuestionRepository;

class QuestionServiceTest {

    private final QuestionRepository questions = mock(QuestionRepository.class);
    private final RandomGenerator random = mock(RandomGenerator.class);
    private QuestionService service;

    @BeforeEach
    void setUp() {
        service = new QuestionService(questions, random);
    }

    private static Question question(Question.Status status) {
        User creator = new User();
        creator.setId(UUID.randomUUID());
        Question q = new Question();
        q.setId(UUID.randomUUID());
        q.setContent("Hãy giới thiệu về bản thân");
        q.setIndustry("IT");
        q.setPosition("Chung");
        q.setLevel(Question.Level.EASY);
        q.setQuestionType(Question.Type.INTRO);
        q.setAnswerHint("Nêu kinh nghiệm chính");
        q.setReferenceAnswer("đáp án chỉ dành cho admin");
        q.setStatus(status);
        q.setCreatedBy(creator);
        q.setCreatedAt(Instant.parse("2026-10-28T00:00:00Z"));
        return q;
    }

    @SuppressWarnings("unchecked")
    @Test
    void searchReturnsPageInOpenApiShape() {
        Question q = question(Question.Status.ACTIVE);
        when(questions.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(q), PageRequest.of(1, 5), 11));

        PageResponse<QuestionDto> page = service.search("IT", "Backend Developer", Question.Level.EASY, null,
                "  giới thiệu ", 1, 5);

        assertEquals(1, page.content().size());
        assertEquals(1, page.page());
        assertEquals(5, page.size());
        assertEquals(11, page.totalElements());
        assertEquals(3, page.totalPages());
        assertEquals(q.getCreatedBy().getId(), page.content().get(0).createdBy());
    }

    @SuppressWarnings("unchecked")
    @Test
    void searchSortsNewestFirstWithStableTieBreak() {
        when(questions.findAll(any(Specification.class), any(Pageable.class))).thenReturn(Page.empty());

        service.search(null, null, null, null, null, 0, 20);

        ArgumentCaptor<Pageable> pageable = ArgumentCaptor.forClass(Pageable.class);
        verify(questions).findAll(any(Specification.class), pageable.capture());
        assertEquals("createdAt: DESC,id: ASC", pageable.getValue().getSort().toString());
    }

    @SuppressWarnings("unchecked")
    @Test
    void randomPicksTheOffsetChosenByTheRandomSource() {
        Question q = question(Question.Status.ACTIVE);
        when(questions.count(any(Specification.class))).thenReturn(7L);
        when(random.nextInt(7)).thenReturn(4);
        when(questions.findAll(any(Specification.class), eq(PageRequest.of(4, 1,
                com.example.interviewpractice.repository.QuestionSpecifications.NEWEST_FIRST))))
                .thenReturn(new PageImpl<>(List.of(q), PageRequest.of(4, 1), 7));

        QuestionDto dto = service.random("IT", null, null);

        assertEquals(q.getId(), dto.id());
    }

    @SuppressWarnings("unchecked")
    @Test
    void randomWithNoMatchIs404() {
        when(questions.count(any(Specification.class))).thenReturn(0L);

        ApiException e = assertThrows(ApiException.class, () -> service.random("IT", "Chung", null));

        assertEquals(HttpStatus.NOT_FOUND, e.getStatus());
        assertEquals("NOT_FOUND", e.getCode());
        verify(random, never()).nextInt(any(Integer.class));
    }

    @SuppressWarnings("unchecked")
    @Test
    void randomFallsBackToFirstRowWhenTheChosenOffsetDisappeared() {
        Question q = question(Question.Status.ACTIVE);
        when(questions.count(any(Specification.class))).thenReturn(3L);
        when(random.nextInt(3)).thenReturn(2);
        when(questions.findAll(any(Specification.class), eq(PageRequest.of(2, 1,
                com.example.interviewpractice.repository.QuestionSpecifications.NEWEST_FIRST))))
                .thenReturn(Page.empty());
        when(questions.findAll(any(Specification.class), eq(PageRequest.of(0, 1,
                com.example.interviewpractice.repository.QuestionSpecifications.NEWEST_FIRST))))
                .thenReturn(new PageImpl<>(List.of(q), PageRequest.of(0, 1), 2));

        assertEquals(q.getId(), service.random("IT", null, null).id());
    }

    @SuppressWarnings("unchecked")
    @Test
    void randomIs404WhenRowsDisappearBetweenCountAndFetch() {
        when(questions.count(any(Specification.class))).thenReturn(3L);
        when(random.nextInt(3)).thenReturn(2);
        when(questions.findAll(any(Specification.class), any(Pageable.class))).thenReturn(Page.empty());

        ApiException e = assertThrows(ApiException.class, () -> service.random("IT", null, null));

        assertEquals(HttpStatus.NOT_FOUND, e.getStatus());
    }

    @Test
    void getReturnsActiveQuestion() {
        Question q = question(Question.Status.ACTIVE);
        when(questions.findById(q.getId())).thenReturn(Optional.of(q));

        assertEquals(q.getId(), service.get(q.getId()).id());
    }

    @Test
    void getTreatsHiddenQuestionAsNotFound() {
        Question q = question(Question.Status.HIDDEN);
        when(questions.findById(q.getId())).thenReturn(Optional.of(q));

        ApiException e = assertThrows(ApiException.class, () -> service.get(q.getId()));

        assertEquals(HttpStatus.NOT_FOUND, e.getStatus());
    }

    @Test
    void getUnknownIdIsNotFound() {
        UUID id = UUID.randomUUID();
        when(questions.findById(id)).thenReturn(Optional.empty());

        ApiException e = assertThrows(ApiException.class, () -> service.get(id));

        assertEquals("NOT_FOUND", e.getCode());
    }
}
