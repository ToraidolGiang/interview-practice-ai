package com.example.interviewpractice.controller;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.interviewpractice.dto.AnalyticsOverview;
import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.dto.UserActivity;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.service.AnalyticsService;

/** Thống kê hoạt động cho admin (UC9); SecurityConfig chỉ cho ADMIN vào /admin/**. */
@RestController
@RequestMapping("/admin/analytics")
public class AdminAnalyticsController {

    private final AnalyticsService analytics;

    public AdminAnalyticsController(AnalyticsService analytics) {
        this.analytics = analytics;
    }

    @GetMapping("/overview")
    public AnalyticsOverview overview(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return analytics.overview(from, to);
    }

    @GetMapping("/users/{userId}")
    public UserActivity user(@PathVariable UUID userId) {
        return analytics.userActivity(userId);
    }

    /** Chỉ hỗ trợ csv; xlsx cần thư viện bảng tính chưa có trong dự án nên trả 400. */
    @GetMapping("/export")
    public ResponseEntity<byte[]> export(@RequestParam(defaultValue = "csv") String format,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        if (!"csv".equalsIgnoreCase(format)) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ",
                    List.of(new ErrorResponse.FieldError("format", "Hiện chỉ hỗ trợ csv")));
        }
        byte[] body = analytics.exportCsv(from, to).getBytes(StandardCharsets.UTF_8);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        ContentDisposition.attachment().filename("bao-cao-hoat-dong.csv").build().toString())
                .contentType(new MediaType("text", "csv", StandardCharsets.UTF_8)).body(body);
    }
}
