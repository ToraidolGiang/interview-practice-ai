package com.example.interviewpractice.config;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

/**
 * Executor chạy việc chấm điểm nền. Queue có giới hạn và dùng AbortPolicy: khi đầy thì ném
 * TaskRejectedException để tầng gọi hoàn tác trạng thái và trả 503 thay vì nuốt việc.
 */
@Configuration
@EnableScheduling
public class AsyncConfig {

    /**
     * Chạy lượt kiểm lỗi kiến thức song song với lượt chấm chính. Tách khỏi scoringExecutor để một worker chấm đang
     * chờ kết quả không phải xếp hàng sau chính các phiên khác (tránh nghẽn khi hàng đợi chấm đầy). Luồng ảo vì việc
     * chỉ là chờ HTTP.
     */
    @Bean(name = "knowledgeCheckExecutor", destroyMethod = "close")
    public ExecutorService knowledgeCheckExecutor() {
        return Executors.newVirtualThreadPerTaskExecutor();
    }

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
