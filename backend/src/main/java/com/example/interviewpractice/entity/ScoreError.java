package com.example.interviewpractice.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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

/** Một phát biểu sai về chuyên môn trong câu trả lời; khớp bảng score_errors trong V5__score_errors.sql. */
@Entity
@Table(name = "score_errors")
@Getter
@Setter
@NoArgsConstructor
public class ScoreError {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "result_id", nullable = false, updatable = false)
    private ScoreResult result;

    // smallint trong CSDL nên dùng Short
    @Column(nullable = false)
    private Short position;

    @Column(nullable = false, columnDefinition = "text")
    private String quote;

    @Column(nullable = false, columnDefinition = "text")
    private String explanation;
}
