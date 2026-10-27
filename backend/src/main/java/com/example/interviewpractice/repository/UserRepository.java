package com.example.interviewpractice.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.interviewpractice.entity.User;

public interface UserRepository extends JpaRepository<User, UUID> {

    // Email duy nhất không phân biệt hoa thường (chỉ mục uq_users_email)
    Optional<User> findByEmailIgnoreCase(String email);

    boolean existsByEmailIgnoreCase(String email);
}
