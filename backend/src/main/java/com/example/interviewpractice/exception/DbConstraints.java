package com.example.interviewpractice.exception;

import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;

/** Nhận biết lỗi toàn vẹn dữ liệu do đúng một ràng buộc/chỉ mục có tên cụ thể. */
public final class DbConstraints {

    private DbConstraints() {
    }

    /**
     * Đúng khi lỗi vi phạm ràng buộc {@code constraintName}: khớp tên ràng buộc Hibernate đọc từ Postgres,
     * hoặc tên xuất hiện trong thông báo gốc (Postgres ghi "constraint \"tên\""). Hai cách độc lập nên một
     * bên thiếu hay khác dạng tên không làm lỡ trường hợp đúng.
     */
    public static boolean violates(DataIntegrityViolationException e, String constraintName) {
        for (Throwable cause = e; cause != null; cause = cause.getCause()) {
            if (cause instanceof ConstraintViolationException violation
                    && constraintName.equalsIgnoreCase(violation.getConstraintName())) {
                return true;
            }
        }
        Throwable root = e.getMostSpecificCause();
        return root.getMessage() != null && root.getMessage().contains("\"" + constraintName + "\"");
    }
}
