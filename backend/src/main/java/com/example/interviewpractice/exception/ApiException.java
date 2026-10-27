package com.example.interviewpractice.exception;

import org.springframework.http.HttpStatus;

/** Lỗi nghiệp vụ có mã HTTP và mã lỗi (code) theo openapi.yaml, ví dụ EMAIL_EXISTS, ACCOUNT_LOCKED. */
public class ApiException extends RuntimeException {

    private final HttpStatus status;
    private final String code;

    public ApiException(HttpStatus status, String code, String message) {
        super(message);
        this.status = status;
        this.code = code;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public String getCode() {
        return code;
    }
}
