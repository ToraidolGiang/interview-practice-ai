package com.example.interviewpractice.dto;

import java.time.Instant;
import java.util.UUID;

import com.example.interviewpractice.entity.Question;

/** Câu hỏi trả cho người luyện tập, khớp schema Question trong openapi.yaml. Không có referenceAnswer. */
public record QuestionDto(UUID id, String content, String industry, String position, Question.Level level,
        Question.Type questionType, String answerHint, Question.Status status, UUID createdBy, Instant createdAt) {

    public static QuestionDto from(Question q) {
        // getId() trên proxy lazy không nạp User, nên không phát sinh thêm truy vấn cho mỗi câu hỏi
        return new QuestionDto(q.getId(), q.getContent(), q.getIndustry(), q.getPosition(), q.getLevel(),
                q.getQuestionType(), q.getAnswerHint(), q.getStatus(), q.getCreatedBy().getId(), q.getCreatedAt());
    }
}
