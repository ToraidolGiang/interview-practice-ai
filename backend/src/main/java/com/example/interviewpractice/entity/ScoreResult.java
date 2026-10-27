package com.example.interviewpractice.entity;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Kết quả chấm điểm mới nhất của một phiên (tối đa 1 dòng mỗi phiên); khớp bảng score_results trong V1__init.sql. */
@Entity
@Table(name = "score_results")
@Getter
@Setter
@NoArgsConstructor
public class ScoreResult {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "session_id", nullable = false, updatable = false)
    private PracticeSession session;

    @Column(nullable = false, columnDefinition = "text")
    private String transcript;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Question.Type questionType;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal totalScore;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal contentScore;

    @Column(nullable = false)
    private boolean offTopic;

    @Column(nullable = false)
    private boolean injectionSuspected;

    // Nhóm chỉ số Delivery do DeliveryCalculator tính, null khi transcript quá ngắn
    private Integer wpm;

    private Integer fillerCount;

    @Column(precision = 5, scale = 2)
    private BigDecimal fillerRate;

    @Column(precision = 3, scale = 2)
    private BigDecimal deliveryScore;

    @Column(nullable = false, columnDefinition = "text")
    private String feedbackText;

    @Column(columnDefinition = "text")
    private String sampleAnswer;

    private String ttsAudioKey;

    @Column(nullable = false, length = 20)
    private String rubricVersion;

    @Column(nullable = false, length = 20)
    private String promptVersion;

    @Column(nullable = false, length = 50)
    private String modelVersion;

    @Column(length = 20)
    private String fillerListVersion;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @OneToMany(mappedBy = "result", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ScoreCriterion> criteria = new ArrayList<>();

    public void addCriterion(ScoreCriterion criterion) {
        criterion.setResult(this);
        criteria.add(criterion);
    }
}
