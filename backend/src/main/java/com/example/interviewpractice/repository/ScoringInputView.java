package com.example.interviewpractice.repository;

import java.util.UUID;

import com.example.interviewpractice.entity.Question;

/** Dữ liệu tối thiểu của một phiên để chấm (interface projection); worker không cần entity lazy hay transaction. */
public interface ScoringInputView {

    UUID getSessionId();

    String getAudioKey();

    Integer getDurationSec();

    Question.Type getQuestionType();

    String getQuestionContent();

    String getReferenceAnswer();
}
