package com.example.interviewpractice.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.interviewpractice.entity.ScoreResult;

public interface ScoreResultRepository extends JpaRepository<ScoreResult, UUID> {

    Optional<ScoreResult> findBySessionId(UUID sessionId);
}
