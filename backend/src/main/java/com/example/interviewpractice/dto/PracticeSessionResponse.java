package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import com.example.interviewpractice.entity.PracticeSession;

/**
 * Phiên luyện tập trả cho client, khớp schema PracticeSession trong openapi.yaml.
 * audioUrl là khóa đối tượng trên S3 (bucket riêng tư, chỉ server đọc), không phải đường dẫn công khai.
 */
public record PracticeSessionResponse(UUID id, UUID userId, UUID questionId, PracticeSession.Status status,
        String audioUrl, Integer duration, BigDecimal totalScore, String feedback, Instant startedAt,
        Instant submittedAt, Instant completedAt, String errorCode) {

    public static PracticeSessionResponse from(PracticeSession s) {
        // getId() trên proxy lazy không nạp User/Question nên không phát sinh thêm truy vấn
        return new PracticeSessionResponse(s.getId(), s.getUser().getId(), s.getQuestion().getId(), s.getStatus(),
                s.getAudioKey(), s.getDurationSec(), s.getTotalScore(), s.getFeedback(), s.getStartedAt(),
                s.getSubmittedAt(), s.getCompletedAt(), s.getErrorCode());
    }
}
