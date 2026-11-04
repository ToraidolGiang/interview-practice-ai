package com.example.interviewpractice.service.storage;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import com.example.interviewpractice.config.AwsProperties;

import software.amazon.awssdk.core.ResponseBytes;
import software.amazon.awssdk.core.exception.SdkClientException;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

class S3AudioStorageTest {

    private final S3Client s3 = mock(S3Client.class);
    private final S3AudioStorage storage = new S3AudioStorage(s3,
            new AwsProperties("ak", "sk", "ap-southeast-1", new AwsProperties.S3("bucket-x")));

    @Test
    void putUsesServerGeneratedKeyWithoutClientFileName() {
        UUID userId = UUID.randomUUID();
        UUID sessionId = UUID.randomUUID();

        String key = storage.put(userId, sessionId, new byte[] {1, 2}, "audio/mpeg");

        ArgumentCaptor<PutObjectRequest> captor = ArgumentCaptor.forClass(PutObjectRequest.class);
        verify(s3).putObject(captor.capture(), any(RequestBody.class));
        assertEquals("bucket-x", captor.getValue().bucket());
        assertEquals(key, captor.getValue().key());
        assertEquals("audio/mpeg", captor.getValue().contentType());
        assertTrue(key.matches("audio/" + userId + "/" + sessionId + "/[0-9a-f-]{36}\\.mp3"), key);
    }

    @Test
    void putWrapsSdkFailure() {
        when(s3.putObject(any(PutObjectRequest.class), any(RequestBody.class)))
                .thenThrow(SdkClientException.create("lỗi mạng"));
        assertThrows(AudioStorageException.class,
                () -> storage.put(UUID.randomUUID(), UUID.randomUUID(), new byte[] {1}, "audio/webm"));
    }

    @Test
    void getReturnsBytes() {
        when(s3.getObjectAsBytes(any(GetObjectRequest.class)))
                .thenReturn(ResponseBytes.fromByteArray(GetObjectResponse.builder().build(), new byte[] {9, 8}));
        assertArrayEquals(new byte[] {9, 8}, storage.get("k"));
    }
}
