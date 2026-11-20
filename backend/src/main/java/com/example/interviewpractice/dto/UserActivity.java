package com.example.interviewpractice.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

/** Hoạt động luyện tập của một người dùng cho admin (UC9), khớp schema UserActivity. */
public record UserActivity(UUID userId, String fullName, String email, long totalSessions, BigDecimal averageScore,
        Instant lastPracticeAt, List<PracticeSessionResponse> recentSessions) {
}
