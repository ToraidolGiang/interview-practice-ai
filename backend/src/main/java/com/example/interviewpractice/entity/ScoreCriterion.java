package com.example.interviewpractice.entity;

import java.util.UUID;

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

/** Điểm một tiêu chí rubric trong kết quả chấm; khớp bảng score_criteria trong V1__init.sql. */
@Entity
@Table(name = "score_criteria")
@Getter
@Setter
@NoArgsConstructor
public class ScoreCriterion {

    public enum Code { RELEVANCE, STRUCTURE, DEPTH, CORRECTNESS }

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "result_id", nullable = false, updatable = false)
    private ScoreResult result;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Code code;

    // smallint trong CSDL nên dùng Short, nếu dùng int thì Hibernate validate báo lệch kiểu
    @Column(nullable = false)
    private Short score;

    @Column(nullable = false)
    private Short weight;

    @Column(nullable = false, columnDefinition = "text")
    private String reasoning;

    @Column(columnDefinition = "text")
    private String quote;

    // true khi trích dẫn không nằm trong transcript (kiểm tra ở #154)
    @Column(nullable = false)
    private boolean quoteInvalid;
}
