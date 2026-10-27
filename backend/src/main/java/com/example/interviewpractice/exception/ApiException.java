package com.example.interviewpractice.exception;

import java.util.List;

import org.springframework.http.HttpStatus;

import com.example.interviewpractice.dto.ErrorResponse;

/** Lỗi nghiệp vụ có mã HTTP và mã lỗi (code) theo openapi.yaml, ví dụ EMAIL_EXISTS, ACCOUNT_LOCKED. */
public class ApiException extends RuntimeException {

    private final HttpStatus status;
    private final String code;
    private final List<ErrorResponse.FieldError> fieldErrors;

    public ApiException(HttpStatus status, String code, String message) {
        this(status, code, message, null);
    }

    /** Dùng cho VALIDATION_ERROR phát hiện ở tầng service, kèm lỗi theo từng trường. */
    public ApiException(HttpStatus status, String code, String message,
            List<ErrorResponse.FieldError> fieldErrors) {
        super(message);
        this.status = status;
        this.code = code;
        this.fieldErrors = fieldErrors;
    }

    public List<ErrorResponse.FieldError> getFieldErrors() {
        return fieldErrors;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public String getCode() {
        return code;
    }
}
