package com.example.interviewpractice.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.example.interviewpractice.entity.PracticeSession;

public interface PracticeSessionRepository extends JpaRepository<PracticeSession, UUID> {

    Page<PracticeSession> findByUserIdOrderByStartedAtDesc(UUID userId, Pageable pageable);
}
