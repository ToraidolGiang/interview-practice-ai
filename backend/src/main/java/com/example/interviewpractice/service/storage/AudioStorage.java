package com.example.interviewpractice.service.storage;

import java.util.UUID;

/** Cổng lưu trữ audio câu trả lời; tách khỏi S3 để test bằng mock. */
public interface AudioStorage {

    /** Lưu audio và trả khóa đối tượng do server sinh (không dùng tên file của client). */
    String put(UUID userId, UUID sessionId, byte[] data, String contentType);

    byte[] get(String key);
}
