package com.example.interviewpractice.exception;

import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;

/** Nhận biết lỗi toàn vẹn dữ liệu do đúng một ràng buộc/chỉ mục có tên cụ thể. */
public final class DbConstraints {

    private DbConstraints() {
    }

    /**
     * Đúng khi lỗi vi phạm ràng buộc {@code constraintName}. Ưu tiên tên ràng buộc Hibernate đọc từ Postgres,
     * nếu driver không cung cấp thì đối chiếu tên trong thông báo gốc (Postgres ghi "constraint \"tên\"").
     */
    public static boolean violates(DataIntegrityViolationException e, String constraintName) {
        for (Throwable cause = e; cause != null; cause = cause.getCause()) {
            if (cause instanceof ConstraintViolationException violation
                    && violation.getConstraintName() != null) {
                return constraintName.equalsIgnoreCase(violation.getConstraintName());
            }
        }
        Throwable root = e.getMostSpecificCause();
        return root.getMessage() != null && root.getMessage().contains("\"" + constraintName + "\"");
    }
}
