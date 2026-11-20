package com.example.interviewpractice.service.ai;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.concurrent.atomic.AtomicInteger;

import org.junit.jupiter.api.Test;

class OneRetryTest {

    @Test
    void successOnFirstCallRunsOnce() {
        AtomicInteger calls = new AtomicInteger();

        String result = OneRetry.call(() -> {
            calls.incrementAndGet();
            return "ok";
        });

        assertEquals("ok", result);
        assertEquals(1, calls.get());
    }

    @Test
    void failureThenSuccessRunsTwice() {
        AtomicInteger calls = new AtomicInteger();

        String result = OneRetry.call(() -> {
            if (calls.incrementAndGet() == 1) {
                throw new IllegalStateException("lần 1");
            }
            return "ok";
        });

        assertEquals("ok", result);
        assertEquals(2, calls.get());
    }

    @Test
    void twoFailuresRethrowSecondErrorAfterExactlyTwoCalls() {
        AtomicInteger calls = new AtomicInteger();

        IllegalStateException e = assertThrows(IllegalStateException.class, () -> OneRetry.call(() -> {
            throw new IllegalStateException("lần " + calls.incrementAndGet());
        }));

        assertEquals("lần 2", e.getMessage());
        assertEquals(2, calls.get());
    }
}
