package com.example.interviewpractice.config;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import java.util.concurrent.ThreadPoolExecutor;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import software.amazon.awssdk.services.s3.S3Client;

/** Kiểm tra cấu hình nền tảng: bind property, executor chấm điểm có queue giới hạn, S3Client dựng được. */
@SpringBootTest
class ConfigPropertiesTest {

    @Autowired
    private AiProperties ai;

    @Autowired
    private AudioProperties audio;

    @Autowired
    private AwsProperties aws;

    @Autowired
    private ApplicationContext context;

    @Test
    void bindsAiPropertiesFromTestConfig() {
        assertThat(ai.gemini().apiKey()).isNotBlank();
        assertThat(ai.gemini().baseUrl()).isEqualTo("http://localhost:0");
        assertThat(ai.gemini().sttModel()).isNotBlank();
        assertThat(ai.gemini().llmModel()).isNotBlank();
        assertThat(ai.stt().timeout()).isEqualTo(Duration.ofSeconds(15));
        assertThat(ai.llm().timeout()).isEqualTo(Duration.ofSeconds(15));
        assertThat(ai.llm().temperature()).isEqualTo(0.2);
    }

    @Test
    void bindsAudioLimits() {
        assertThat(audio.maxBytes()).isEqualTo(10_485_760L);
        assertThat(audio.minSeconds()).isEqualTo(10);
        assertThat(audio.maxSeconds()).isEqualTo(180);
    }

    @Test
    void bindsAwsPropertiesFromTestConfig() {
        assertThat(aws.accessKeyId()).isNotBlank();
        assertThat(aws.region()).isEqualTo("ap-southeast-1");
        assertThat(aws.s3().bucket()).isEqualTo("test-audio-bucket");
    }

    @Test
    void scoringExecutorHasBoundedQueueAndAbortPolicy() {
        ThreadPoolTaskExecutor executor = context.getBean("scoringExecutor", ThreadPoolTaskExecutor.class);
        ThreadPoolExecutor pool = executor.getThreadPoolExecutor();

        assertThat(executor.getThreadNamePrefix()).isEqualTo("scoring-");
        assertThat(pool.getQueue().remainingCapacity()).isEqualTo(20);
        assertThat(pool.getRejectedExecutionHandler()).isInstanceOf(ThreadPoolExecutor.AbortPolicy.class);
    }

    @Test
    void s3ClientIsCreatedWithoutNetworkCall() {
        assertThat(context.getBean(S3Client.class)).isNotNull();
    }
}
