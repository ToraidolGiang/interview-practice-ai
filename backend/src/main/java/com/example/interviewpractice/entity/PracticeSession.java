package com.example.interviewpractice.entity;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Một lượt luyện tập: câu hỏi, audio và trạng thái xử lý; khớp bảng practice_sessions trong V1__init.sql. */
@Entity
@Table(name = "practice_sessions")
@Getter
@Setter
@NoArgsConstructor
public class PracticeSession {

    public enum Status { CREATED, UPLOADED, PROCESSING, SCORED, FAILED }

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, updatable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "question_id", nullable = false, updatable = false)
    private Question question;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status = Status.CREATED;

    private String audioKey;

    private Integer durationSec;

    @Column(precision = 5, scale = 2)
    private BigDecimal totalScore;

    @Column(columnDefinition = "text")
    private String feedback;

    @Column(length = 40)
    private String errorCode;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant startedAt;

    private Instant submittedAt;

    // Mốc bắt đầu chấm; job dọn phiên treo (#156) dựa vào cột này
    private Instant processingStartedAt;

    private Instant completedAt;
}
