package com.example.interviewpractice.service.ai;

/** Lỗi phiên âm sau khi đã thử lại; tầng chấm điểm ánh xạ thành errorCode STT_ERROR. */
public class SttException extends RuntimeException {

    public SttException(String message, Throwable cause) {
        super(message, cause);
    }

    public SttException(String message) {
        super(message);
    }
}
