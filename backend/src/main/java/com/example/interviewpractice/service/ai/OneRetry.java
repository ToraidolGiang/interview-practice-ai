package com.example.interviewpractice.service.ai;

import java.util.function.Supplier;

/** Chạy một thao tác và thử lại đúng 1 lần nếu lần đầu ném RuntimeException (tối đa 2 lần gọi). */
public final class OneRetry {

    private OneRetry() {
    }

    /** Trả kết quả của lần thành công đầu tiên; nếu cả hai lần lỗi thì ném lại lỗi của lần thứ hai. */
    public static <T> T call(Supplier<T> action) {
        try {
            return action.get();
        } catch (RuntimeException first) {
            return action.get();
        }
    }
}
