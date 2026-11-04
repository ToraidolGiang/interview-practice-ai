package com.example.interviewpractice.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.http.urlconnection.UrlConnectionHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

/**
 * Dựng S3Client từ credential tĩnh trong cấu hình. Việc dựng client không gọi mạng,
 * nên context vẫn nạp được với giá trị AWS giả khi chạy test.
 * Đồng thời đăng ký các nhóm cấu hình nền tảng (AI, audio, AWS).
 */
@Configuration
@EnableConfigurationProperties({AiProperties.class, AudioProperties.class, AwsProperties.class})
public class S3Config {

    @Bean
    public S3Client s3Client(AwsProperties aws) {
        return S3Client.builder()
                .region(Region.of(aws.region()))
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(aws.accessKeyId(), aws.secretAccessKey())))
                .httpClientBuilder(UrlConnectionHttpClient.builder())
                .build();
    }
}
