package com.example.interviewpractice.service.scoring;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;

import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.ScoreCriterion.Code;

class RubricConfigTest {

    @Test
    void behavioralCoBaTieuChiVoiTrongSoTheoBang() {
        assertThat(RubricConfig.llmWeights(Question.Type.BEHAVIORAL))
                .containsExactly(Map.entry(Code.RELEVANCE, 20), Map.entry(Code.STRUCTURE, 30),
                        Map.entry(Code.DEPTH, 40));
    }

    @Test
    void situationalCoBaTieuChiVoiTrongSoTheoBang() {
        assertThat(RubricConfig.llmWeights(Question.Type.SITUATIONAL))
                .containsExactly(Map.entry(Code.RELEVANCE, 25), Map.entry(Code.STRUCTURE, 25),
                        Map.entry(Code.DEPTH, 40));
    }

    @Test
    void technicalCoThemCorrectness() {
        assertThat(RubricConfig.llmWeights(Question.Type.TECHNICAL))
                .containsExactly(Map.entry(Code.RELEVANCE, 15), Map.entry(Code.STRUCTURE, 15),
                        Map.entry(Code.DEPTH, 25), Map.entry(Code.CORRECTNESS, 35));
    }

    @Test
    void introCoBaTieuChiVoiTrongSoTheoBang() {
        assertThat(RubricConfig.llmWeights(Question.Type.INTRO))
                .containsExactly(Map.entry(Code.RELEVANCE, 25), Map.entry(Code.STRUCTURE, 30),
                        Map.entry(Code.DEPTH, 35));
    }

    @ParameterizedTest
    @EnumSource(Question.Type.class)
    void tongTrongSoCongDeliveryBang100(Question.Type type) {
        int sum = RubricConfig.llmWeights(type).values().stream().mapToInt(Integer::intValue).sum();
        assertThat(sum + RubricConfig.DELIVERY_WEIGHT).isEqualTo(100);
    }

    @ParameterizedTest
    @EnumSource(Question.Type.class)
    void chiTechnicalCoCorrectness(Question.Type type) {
        List<Code> codes = RubricConfig.llmCodes(type);
        assertThat(codes.contains(Code.CORRECTNESS)).isEqualTo(type == Question.Type.TECHNICAL);
    }

    @Test
    void phienBanRubric() {
        assertThat(RubricConfig.RUBRIC_VERSION).isEqualTo("rubric-v1.0");
    }
}
