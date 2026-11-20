package com.example.interviewpractice.repository;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class QuestionSpecificationsTest {

    @Test
    void escapeLikeTreatsWildcardsAndBackslashAsPlainText() {
        assertEquals("100\\% đạt", QuestionSpecifications.escapeLike("100% đạt"));
        assertEquals("a\\_b", QuestionSpecifications.escapeLike("a_b"));
        assertEquals("c:\\\\temp", QuestionSpecifications.escapeLike("c:\\temp"));
    }

    @Test
    void escapeLikeLeavesVietnameseTextUntouched() {
        assertEquals("giới thiệu bản thân", QuestionSpecifications.escapeLike("giới thiệu bản thân"));
    }
}
