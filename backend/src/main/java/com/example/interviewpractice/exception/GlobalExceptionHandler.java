package com.example.interviewpractice.exception;

import java.time.Instant;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import com.example.interviewpractice.dto.ErrorResponse;

/**
 * Đưa mọi lỗi về ErrorResponse chuẩn của API. Kế thừa ResponseEntityExceptionHandler để lỗi chuẩn của
 * Spring (404, 405, 415...) giữ đúng mã trạng thái nhưng body vẫn là ErrorResponse; lỗi không lường trước
 * rơi vào handleUnexpected và trả 500 với thông báo chung, không lộ chi tiết nội bộ.
 */
@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<ErrorResponse> handleApi(ApiException e) {
        return ResponseEntity.status(e.getStatus())
                .body(new ErrorResponse(e.getCode(), e.getMessage(), Instant.now(), e.getFieldErrors()));
    }

    // Không có handler riêng thì catch-all bên dưới sẽ biến lỗi phân quyền trong controller thành 500
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(AccessDeniedException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ErrorResponse.of("FORBIDDEN", "Không có quyền thực hiện thao tác này"));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception e) {
        log.error("Lỗi không lường trước", e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ErrorResponse.of("INTERNAL_ERROR", "Hệ thống gặp lỗi, vui lòng thử lại sau"));
    }

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException e,
            HttpHeaders headers, HttpStatusCode status, WebRequest request) {
        List<ErrorResponse.FieldError> fieldErrors = e.getBindingResult().getFieldErrors().stream()
                .map(f -> new ErrorResponse.FieldError(f.getField(), f.getDefaultMessage()))
                .toList();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new ErrorResponse("VALIDATION_ERROR", "Dữ liệu không hợp lệ", Instant.now(), fieldErrors));
    }

    @Override
    protected ResponseEntity<Object> handleHttpMessageNotReadable(HttpMessageNotReadableException e,
            HttpHeaders headers, HttpStatusCode status, WebRequest request) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ErrorResponse.of("VALIDATION_ERROR", "Nội dung yêu cầu không đúng định dạng JSON"));
    }

    // Mọi lỗi chuẩn còn lại của Spring (404, 405, 415...) đi qua đây, giữ nguyên header như Allow của 405
    @Override
    protected ResponseEntity<Object> handleExceptionInternal(Exception e, Object body, HttpHeaders headers,
            HttpStatusCode status, WebRequest request) {
        HttpStatus httpStatus = HttpStatus.resolve(status.value());
        String code = httpStatus != null ? httpStatus.name() : "HTTP_" + status.value();
        return new ResponseEntity<>(ErrorResponse.of(code, messageFor(status)), headers, status);
    }

    private static String messageFor(HttpStatusCode status) {
        return switch (status.value()) {
            case 404 -> "Không tìm thấy tài nguyên";
            case 405 -> "Phương thức HTTP không được hỗ trợ";
            case 415 -> "Kiểu nội dung không được hỗ trợ";
            default -> "Yêu cầu không hợp lệ";
        };
    }
}
