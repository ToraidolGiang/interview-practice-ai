package com.example.interviewpractice.dto;

import java.time.Instant;
import java.util.UUID;

import com.example.interviewpractice.entity.Question;

/** Câu hỏi trả cho ADMIN, khớp schema AdminQuestion trong openapi.yaml: Question kèm referenceAnswer. */
public record AdminQuestionDto(UUID id, String content, String industry, String position, Question.Level level,
        Question.Type questionType, String answerHint, String referenceAnswer, Question.Status status,
        UUID createdBy, Instant createdAt) {

    public static AdminQuestionDto from(Question q) {
        return new AdminQuestionDto(q.getId(), q.getContent(), q.getIndustry(), q.getPosition(), q.getLevel(),
                q.getQuestionType(), q.getAnswerHint(), q.getReferenceAnswer(), q.getStatus(),
                q.getCreatedBy().getId(), q.getCreatedAt());
    }
}
