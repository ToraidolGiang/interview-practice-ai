package com.example.interviewpractice.service.ai;

/**
 * Lỗi chấm bằng LLM sau khi đã thử lại. errorCode là mã lưu vào phiên:
 * LLM_ERROR (gọi lỗi/timeout) hoặc INVALID_RESULT (kết quả sai schema).
 */
public class LlmException extends RuntimeException {

    public static final String LLM_ERROR = "LLM_ERROR";
    public static final String INVALID_RESULT = "INVALID_RESULT";

    private final String errorCode;

    public LlmException(String errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    public LlmException(String errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }
}
