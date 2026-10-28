package com.example.interviewpractice.validation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

/**
 * Giới hạn độ dài theo byte UTF-8 thay vì số ký tự. Dùng cho mật khẩu vì BCrypt chỉ nhận tối đa
 * 72 byte, mà chữ tiếng Việt có dấu chiếm 2-3 byte nên @Size(max = 72) vẫn để lọt chuỗi quá dài.
 * Áp dụng cho mọi DTO nhận mật khẩu mới (đăng ký, đặt lại mật khẩu).
 */
@Documented
@Constraint(validatedBy = MaxUtf8BytesValidator.class)
@Target({ ElementType.FIELD, ElementType.PARAMETER, ElementType.RECORD_COMPONENT })
@Retention(RetentionPolicy.RUNTIME)
public @interface MaxUtf8Bytes {

    int value();

    String message() default "Tối đa {value} byte (chữ có dấu chiếm 2-3 byte mỗi ký tự)";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
