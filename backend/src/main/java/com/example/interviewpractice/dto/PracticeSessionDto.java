package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import com.example.interviewpractice.entity.PracticeSession;

/** Một phiên luyện tập trả về client, khớp schema PracticeSession trong openapi.yaml. */
public record PracticeSessionDto(UUID id, UUID userId, UUID questionId, PracticeSession.Status status,
        String audioUrl, Integer duration, BigDecimal totalScore, String feedback, Instant startedAt,
        Instant submittedAt, Instant completedAt, String errorCode) {

    /**
     * audioUrl là URL ký sẵn tới audio trên S3. Phần lưu audio lên S3 chưa có nên tạm truyền null;
     * theo contract, client vẫn hiển thị transcript và điểm khi audioUrl null.
     */
    public static PracticeSessionDto from(PracticeSession session, String audioUrl) {
        // getId() trên proxy LAZY của Hibernate không nạp thêm bản ghi user/question
        return new PracticeSessionDto(session.getId(), session.getUser().getId(), session.getQuestion().getId(),
                session.getStatus(), audioUrl, session.getDurationSec(), session.getTotalScore(),
                session.getFeedback(), session.getStartedAt(), session.getSubmittedAt(), session.getCompletedAt(),
                session.getErrorCode());
    }
}
