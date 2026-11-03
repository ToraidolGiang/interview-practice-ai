package com.example.interviewpractice.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.Repository;

import com.example.interviewpractice.entity.PracticeSession;

/**
 * Truy vấn chỉ đọc cho lịch sử luyện tập (#118). Tách khỏi PracticeSessionRepository (dùng chung, do #111 quản lý)
 * để thêm lọc động theo Specification mà không sửa repository dùng chung.
 */
public interface HistoryRepository extends Repository<PracticeSession, UUID>, JpaSpecificationExecutor<PracticeSession> {

    Optional<PracticeSession> findById(UUID id);
}
