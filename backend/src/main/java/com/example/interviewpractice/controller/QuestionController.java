package com.example.interviewpractice.controller;

import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.interviewpractice.dto.PageResponse;
import com.example.interviewpractice.dto.QuestionDto;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.repository.QuestionSpecifications;
import com.example.interviewpractice.service.QuestionService;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

/** Tra cứu câu hỏi cho người luyện tập (UC3), cần đăng nhập. */
@RestController
@RequestMapping("/questions")
public class QuestionController {

    private final QuestionService questionService;

    public QuestionController(QuestionService questionService) {
        this.questionService = questionService;
    }

    @GetMapping
    public PageResponse<QuestionDto> list(
            @RequestParam(required = false) String industry,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) Question.Level level,
            @RequestParam(required = false) Question.Type questionType,
            @RequestParam(required = false)
            @Size(max = QuestionSpecifications.MAX_KEYWORD_LENGTH, message = "Từ khóa tối đa 200 ký tự") String keyword,
            @RequestParam(defaultValue = "0")
            @Min(value = 0, message = "page phải từ 0 đến 1000000")
            @Max(value = QuestionSpecifications.MAX_PAGE, message = "page phải từ 0 đến 1000000") int page,
            @RequestParam(defaultValue = "20")
            @Min(value = 1, message = "size phải từ 1 đến 100")
            @Max(value = 100, message = "size phải từ 1 đến 100") int size) {
        return questionService.search(blankToNull(industry), blankToNull(position), level, questionType, keyword,
                page, size);
    }

    @GetMapping("/random")
    public QuestionDto random(
            @RequestParam(required = false) String industry,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) Question.Level level) {
        return questionService.random(blankToNull(industry), blankToNull(position), level);
    }

    @GetMapping("/{id}")
    public QuestionDto get(@PathVariable UUID id) {
        return questionService.get(id);
    }

    // Frontend bỏ tham số rỗng, nhưng ?industry= vẫn có thể đến; coi như không lọc thay vì tìm chuỗi rỗng
    private static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
