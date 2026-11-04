package com.example.interviewpractice.config;

import java.util.concurrent.ThreadPoolExecutor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

/**
 * Executor chạy việc chấm điểm nền. Queue có giới hạn và dùng AbortPolicy: khi đầy thì ném
 * TaskRejectedException để tầng gọi hoàn tác trạng thái và trả 503 thay vì nuốt việc.
 */
@Configuration
public class AsyncConfig {

    @Bean(name = "scoringExecutor")
    public ThreadPoolTaskExecutor scoringExecutor(
            @Value("${app.scoring.executor.core}") int core,
            @Value("${app.scoring.executor.max}") int max,
            @Value("${app.scoring.executor.queue}") int queue) {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(core);
        executor.setMaxPoolSize(max);
        executor.setQueueCapacity(queue);
        executor.setThreadNamePrefix("scoring-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
        executor.setWaitForTasksToCompleteOnShutdown(true);
        return executor;
    }
}
