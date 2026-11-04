package com.example.interviewpractice.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.interviewpractice.entity.ScoreResult;

public interface ScoreResultRepository extends JpaRepository<ScoreResult, UUID> {

    Optional<ScoreResult> findBySessionId(UUID sessionId);

    /** Xóa kết quả cũ của phiên (criteria xóa theo); người gọi phải flush trước khi insert kết quả mới. */
    void deleteBySessionId(UUID sessionId);
}
