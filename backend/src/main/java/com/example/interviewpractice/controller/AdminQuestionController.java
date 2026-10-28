package com.example.interviewpractice.controller;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.example.interviewpractice.dto.AdminQuestionDto;
import com.example.interviewpractice.dto.PageResponse;
import com.example.interviewpractice.dto.QuestionUpsertRequest;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.repository.QuestionSpecifications;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.AdminQuestionService;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

/** Quản trị câu hỏi (UC8); SecurityConfig chỉ cho ADMIN vào /admin/**. */
@RestController
@RequestMapping("/admin/questions")
public class AdminQuestionController {

    private final AdminQuestionService adminQuestionService;

    public AdminQuestionController(AdminQuestionService adminQuestionService) {
        this.adminQuestionService = adminQuestionService;
    }

    @GetMapping
    public PageResponse<AdminQuestionDto> list(
            @RequestParam(required = false) Question.Status status,
            @RequestParam(required = false)
            @Size(max = QuestionSpecifications.MAX_KEYWORD_LENGTH, message = "Từ khóa tối đa 200 ký tự") String keyword,
            @RequestParam(defaultValue = "0") @Min(value = 0, message = "page phải từ 0 trở lên") int page,
            @RequestParam(defaultValue = "20")
            @Min(value = 1, message = "size phải từ 1 đến 100")
            @Max(value = 100, message = "size phải từ 1 đến 100") int size) {
        return adminQuestionService.search(status, keyword, page, size);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AdminQuestionDto create(@Valid @RequestBody QuestionUpsertRequest request,
            @AuthenticationPrincipal AuthUser admin) {
        return adminQuestionService.create(request, admin);
    }

    @PutMapping("/{id}")
    public AdminQuestionDto update(@PathVariable UUID id, @Valid @RequestBody QuestionUpsertRequest request,
            @AuthenticationPrincipal AuthUser admin) {
        return adminQuestionService.update(id, request, admin);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable UUID id, @AuthenticationPrincipal AuthUser admin) {
        adminQuestionService.delete(id, admin);
    }
}
