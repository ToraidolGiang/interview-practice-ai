package com.example.interviewpractice.dto;

import com.example.interviewpractice.entity.Question;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * Thêm/sửa câu hỏi, khớp schema QuestionUpsertRequest trong openapi.yaml. Việc industry/position thuộc
 * taxonomy-v1.0 được kiểm tra ở AdminQuestionService vì cần cả hai trường cùng lúc.
 */
public record QuestionUpsertRequest(
        @NotBlank(message = "Nội dung câu hỏi không được để trống")
        @Size(max = 2000, message = "Nội dung câu hỏi tối đa 2000 ký tự") String content,
        @NotBlank(message = "Ngành không được để trống")
        @Size(max = 100, message = "Ngành tối đa 100 ký tự") String industry,
        @NotBlank(message = "Vị trí không được để trống")
        @Size(max = 100, message = "Vị trí tối đa 100 ký tự") String position,
        @NotNull(message = "Mức độ không được để trống") Question.Level level,
        @NotNull(message = "Loại câu hỏi không được để trống") Question.Type questionType,
        @Size(max = 4000, message = "Gợi ý tối đa 4000 ký tự") String answerHint,
        @Size(max = 8000, message = "Đáp án tham chiếu tối đa 8000 ký tự") String referenceAnswer) {
}
