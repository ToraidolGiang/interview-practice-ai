package com.example.interviewpractice.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.controller.AbstractSessionApiTest;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.security.AuthUser;

/** Nhiều /evaluate đồng thời trên cùng một phiên chỉ được sinh đúng một job (AC-25). */
class EvaluateConcurrencyTest extends AbstractSessionApiTest {

    private static final int PARALLEL = 10;

    @Autowired
    private EvaluationService evaluation;

    @MockitoBean(name = "scoringExecutor")
    private TaskExecutor executor;

    @Test
    void parallelEvaluateStartsExactlyOneJob() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.UPLOADED);
        AuthUser user = new AuthUser(owner.getId(), owner.getEmail(), owner.getRole());

        ExecutorService pool = Executors.newFixedThreadPool(PARALLEL);
        CountDownLatch start = new CountDownLatch(1);
        List<Future<HttpStatus>> futures = new ArrayList<>();
        try {
            for (int i = 0; i < PARALLEL; i++) {
                futures.add(pool.submit(() -> {
                    start.await();
                    try {
                        evaluation.submit(session.getId(), user);
                        return HttpStatus.ACCEPTED;
                    } catch (ApiException e) {
                        return e.getStatus();
                    }
                }));
            }
            start.countDown();
            List<HttpStatus> results = new ArrayList<>();
            for (Future<HttpStatus> f : futures) {
                results.add(f.get());
            }
            assertThat(results.stream().filter(HttpStatus.ACCEPTED::equals).count()).isEqualTo(1);
            assertThat(results.stream().filter(HttpStatus.CONFLICT::equals).count()).isEqualTo(PARALLEL - 1);
        } finally {
            pool.shutdownNow();
        }
        verify(executor, times(1)).execute(any());
        assertThat(statusOf(session.getId())).isEqualTo("PROCESSING");
    }
}
