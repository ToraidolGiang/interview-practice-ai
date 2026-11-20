package com.example.interviewpractice.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/** Cấu hình AWS đọc từ khóa aws.* trong application.yml (credential tĩnh từ env, vùng và bucket S3). */
@ConfigurationProperties(prefix = "aws")
public record AwsProperties(String accessKeyId, String secretAccessKey, String region, S3 s3) {

    /** Bucket S3 chứa audio câu trả lời. */
    public record S3(String bucket) {
    }
}
