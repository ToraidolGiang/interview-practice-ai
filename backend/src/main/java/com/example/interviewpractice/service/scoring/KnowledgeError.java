package com.example.interviewpractice.service.scoring;

/**
 * Một phát biểu sai về chuyên môn do lượt kiểm lỗi kiến thức phát hiện: quote là đoạn thí sinh nói (đã kiểm có trong
 * transcript), explanation là điều đúng. position bắt đầu từ 1. Chứa lời thí sinh nên toString bị ẩn khỏi log.
 */
public record KnowledgeError(int position, String quote, String explanation) {

    @Override
    public String toString() {
        return "KnowledgeError[position=" + position + "]";
    }
}
