package com.example.interviewpractice.service.scoring;

import com.example.interviewpractice.entity.ScorePoint.Verdict;

/**
 * Kết quả đối chiếu một ý của đáp án tham chiếu (đã qua kiểm schema và kiểm trích dẫn).
 * position bắt đầu từ 1, theo thứ tự ý trong đáp án; quoteInvalid do bước kiểm trích dẫn đặt, LLM không tự trả.
 */
public record PointScore(int position, String pointText, Verdict verdict, String quote, String note,
        boolean quoteInvalid) {
}
