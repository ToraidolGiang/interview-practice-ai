package com.example.interviewpractice.service.ai;

import java.util.UUID;

/** Cổng phiên âm giọng nói thành văn bản; tách khỏi nhà cung cấp để test bằng mock. */
public interface SttClient {

    /**
     * Phiên âm nguyên văn audio của một phiên luyện tập.
     *
     * @param sessionId phiên được ghi nhận vào nhật ký sử dụng API
     * @throws SttException khi gọi lỗi sau khi đã thử lại
     */
    String transcribe(UUID sessionId, byte[] audio, String mimeType);
}
