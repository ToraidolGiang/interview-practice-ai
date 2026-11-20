package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import com.example.interviewpractice.entity.PracticeSession;

/**
 * Chi tiết một mục lịch sử, khớp schema HistoryDetail (allOf PracticeSession + scoreResult) trong openapi.yaml:
 * các trường của phiên nằm phẳng cùng cấp với scoreResult.
 */
public record HistoryDetailDto(UUID id, UUID userId, UUID questionId, PracticeSession.Status status, String audioUrl,
        Integer duration, BigDecimal totalScore, String feedback, Instant startedAt, Instant submittedAt,
        Instant completedAt, String errorCode, ScoreResultDto scoreResult) {

    public static HistoryDetailDto of(PracticeSessionDto s, ScoreResultDto scoreResult) {
        return new HistoryDetailDto(s.id(), s.userId(), s.questionId(), s.status(), s.audioUrl(), s.duration(),
                s.totalScore(), s.feedback(), s.startedAt(), s.submittedAt(), s.completedAt(), s.errorCode(),
                scoreResult);
    }
}
