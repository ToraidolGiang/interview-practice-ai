package com.example.interviewpractice.service.storage;

import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.example.interviewpractice.config.AwsProperties;

import software.amazon.awssdk.core.exception.SdkException;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

/** Lưu audio trên S3 (bucket riêng tư, không đặt ACL công khai); khóa dạng audio/{userId}/{sessionId}/{uuid}.{ext}. */
@Component
public class S3AudioStorage implements AudioStorage {

    // Đuôi file do server chọn theo MIME đã được whitelist, không lấy từ tên file client
    private static final Map<String, String> EXTENSIONS = Map.of(
            "audio/webm", "webm",
            "audio/ogg", "ogg",
            "audio/mpeg", "mp3",
            "audio/wav", "wav",
            "audio/mp4", "m4a");

    private static final Logger log = LoggerFactory.getLogger(S3AudioStorage.class);

    private final S3Client s3;
    private final String bucket;

    public S3AudioStorage(S3Client s3, AwsProperties aws) {
        this.s3 = s3;
        this.bucket = aws.s3().bucket();
    }

    @Override
    public String put(UUID userId, UUID sessionId, byte[] data, String contentType) {
        String key = "audio/" + userId + "/" + sessionId + "/" + UUID.randomUUID() + "."
                + EXTENSIONS.getOrDefault(contentType, "bin");
        try {
            s3.putObject(PutObjectRequest.builder().bucket(bucket).key(key).contentType(contentType).build(),
                    RequestBody.fromBytes(data));
        } catch (SdkException e) {
            throw new AudioStorageException("Không lưu được audio lên S3", e);
        }
        return key;
    }

    @Override
    public byte[] get(String key) {
        try {
            return s3.getObjectAsBytes(GetObjectRequest.builder().bucket(bucket).key(key).build()).asByteArray();
        } catch (SdkException e) {
            throw new AudioStorageException("Không đọc được audio từ S3", e);
        }
    }

    @Override
    public void delete(String key) {
        try {
            s3.deleteObject(DeleteObjectRequest.builder().bucket(bucket).key(key).build());
        } catch (SdkException e) {
            log.warn("Không xóa được audio mồ côi key={}", key, e);
        }
    }
}
