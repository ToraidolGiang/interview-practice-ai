package com.example.interviewpractice.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.example.interviewpractice.entity.Question;

/** Truy vấn lọc theo nhiều điều kiện tùy chọn đi qua QuestionSpecifications (tránh tham số null với Postgres). */
public interface QuestionRepository extends JpaRepository<Question, UUID>, JpaSpecificationExecutor<Question> {
}
