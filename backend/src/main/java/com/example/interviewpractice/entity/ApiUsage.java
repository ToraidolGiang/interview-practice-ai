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

/** Nhật ký một lần gọi dịch vụ AI để thống kê độ trễ và chi phí; khớp bảng api_usages trong V1__init.sql. */
@Entity
@Table(name = "api_usages")
@Getter
@Setter
@NoArgsConstructor
public class ApiUsage {

    public enum Provider { STT, LLM, TTS }

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "session_id", nullable = false, updatable = false)
    private PracticeSession session;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Provider provider;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant calledAt;

    @Column(nullable = false)
    private int latencyMs;

    // Đơn vị tính phí tùy nhà cung cấp (giây audio, token, ký tự)
    @Column(precision = 12, scale = 4)
    private BigDecimal usageUnit;

    @Column(precision = 12, scale = 6)
    private BigDecimal estimatedCost;
}
