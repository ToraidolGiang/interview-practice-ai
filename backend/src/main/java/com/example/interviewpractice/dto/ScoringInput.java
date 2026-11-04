package com.example.interviewpractice.dto;

import java.util.UUID;

import com.example.interviewpractice.entity.Question;

/** Dữ liệu tối thiểu của một phiên để chấm; là giá trị thuần nên worker không cần entity lazy hay transaction. */
public record ScoringInput(UUID sessionId, String audioKey, Integer durationSec, Question.Type questionType,
        String questionContent, String referenceAnswer) {
}
