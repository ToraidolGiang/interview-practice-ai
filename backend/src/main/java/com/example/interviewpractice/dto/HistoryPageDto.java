package com.example.interviewpractice.dto;

import java.util.List;

import org.springframework.data.domain.Page;

/** Một trang lịch sử luyện tập, khớp schema HistoryPage trong openapi.yaml. */
public record HistoryPageDto(List<PracticeSessionDto> content, int page, int size, long totalElements,
        int totalPages) {

    public static HistoryPageDto from(Page<PracticeSessionDto> page) {
        return new HistoryPageDto(page.getContent(), page.getNumber(), page.getSize(), page.getTotalElements(),
                page.getTotalPages());
    }
}
