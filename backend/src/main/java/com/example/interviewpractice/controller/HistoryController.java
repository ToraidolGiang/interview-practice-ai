package com.example.interviewpractice.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.interviewpractice.dto.HistoryDetailDto;
import com.example.interviewpractice.dto.HistoryFilter;
import com.example.interviewpractice.dto.HistoryPageDto;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.HistoryService;

/** Lịch sử luyện tập của chính người dùng (UC7, #118). */
@RestController
@RequestMapping("/history")
public class HistoryController {

    private final HistoryService historyService;

    public HistoryController(HistoryService historyService) {
        this.historyService = historyService;
    }

    @GetMapping
    public HistoryPageDto list(@AuthenticationPrincipal AuthUser user,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(required = false) String industry,
            @RequestParam(required = false) BigDecimal minScore,
            @RequestParam(required = false) BigDecimal maxScore,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return historyService.list(user.id(), new HistoryFilter(from, to, industry, minScore, maxScore), page, size);
    }

    @GetMapping("/{id}")
    public HistoryDetailDto detail(@AuthenticationPrincipal AuthUser user, @PathVariable UUID id) {
        return historyService.detail(user.id(), id);
    }
}
