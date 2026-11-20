package com.example.interviewpractice.service.storage;

/** Lỗi khi đọc/ghi audio ở kho lưu trữ ngoài. */
public class AudioStorageException extends RuntimeException {

    public AudioStorageException(String message, Throwable cause) {
        super(message, cause);
    }
}
