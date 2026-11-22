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

/** Kết quả đối chiếu một ý của đáp án tham chiếu; khớp bảng score_points trong V4__score_points.sql. */
@Entity
@Table(name = "score_points")
@Getter
@Setter
@NoArgsConstructor
public class ScorePoint {

    /** Mức đáp ứng của câu trả lời với một ý: nêu đủ, nêu thiếu/lệch, không nêu, nêu sai. */
    public enum Verdict { COVERED, PARTIAL, MISSING, INCORRECT }

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
    private String pointText;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Verdict verdict;

    @Column(columnDefinition = "text")
    private String quote;

    // true khi trích dẫn không nằm trong transcript nên verdict đã bị hạ
    @Column(nullable = false)
    private boolean quoteInvalid;

    @Column(columnDefinition = "text")
    private String note;
}
