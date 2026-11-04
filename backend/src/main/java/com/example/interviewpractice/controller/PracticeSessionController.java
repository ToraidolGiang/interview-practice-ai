package com.example.interviewpractice.controller;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.interviewpractice.dto.CreateSessionRequest;
import com.example.interviewpractice.dto.PracticeSessionResponse;
import com.example.interviewpractice.dto.ScoreResultResponse;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.EvaluationService;
import com.example.interviewpractice.service.PracticeSessionService;
import com.example.interviewpractice.service.ResultService;

import jakarta.validation.Valid;

/** Phiên luyện tập của người dùng: tạo, xem, nộp audio (UC3, UC4) và xem kết quả chấm (UC5). */
@RestController
@RequestMapping("/practice-sessions")
public class PracticeSessionController {

    private final PracticeSessionService service;
    private final ResultService resultService;
    private final EvaluationService evaluationService;

    public PracticeSessionController(PracticeSessionService service, ResultService resultService,
            EvaluationService evaluationService) {
        this.service = service;
        this.resultService = resultService;
        this.evaluationService = evaluationService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public PracticeSessionResponse create(@Valid @RequestBody CreateSessionRequest request,
            @AuthenticationPrincipal AuthUser user) {
        return service.create(request.questionId(), user);
    }

    @GetMapping("/{id}")
    public PracticeSessionResponse get(@PathVariable UUID id, @AuthenticationPrincipal AuthUser user) {
        return service.get(id, user);
    }

    @GetMapping("/{id}/result")
    public ScoreResultResponse result(@PathVariable UUID id, @AuthenticationPrincipal AuthUser user) {
        return resultService.get(id, user);
    }

    // durationSeconds không bắt buộc ở tầng Spring để thiếu tham số cũng ra VALIDATION_ERROR từ service
    @PostMapping(value = "/{id}/answer", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public PracticeSessionResponse uploadAnswer(@PathVariable UUID id,
            @RequestPart("audio") MultipartFile audio,
            @RequestParam(required = false) Integer durationSeconds,
            @AuthenticationPrincipal AuthUser user) {
        return service.uploadAnswer(id, user, audio, durationSeconds);
    }

    /** Bắt đầu chấm nền: trả 202 ngay với phiên PROCESSING, client polling GET /{id} để biết kết quả. */
    @PostMapping("/{id}/evaluate")
    @ResponseStatus(HttpStatus.ACCEPTED)
    public PracticeSessionResponse evaluate(@PathVariable UUID id, @AuthenticationPrincipal AuthUser user) {
        return evaluationService.submit(id, user);
    }
}
