package com.example.interviewpractice.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.interviewpractice.entity.User;

import jakarta.persistence.LockModeType;

/**
 * Các hàm theo email nhận email đã chuẩn hóa chữ thường. Dùng lower(email) thay vì IgnoreCase
 * (sinh upper(email)) để khớp chỉ mục uq_users_email trên lower(email).
 */
public interface UserRepository extends JpaRepository<User, UUID> {

    @Query("select u from User u where lower(u.email) = :email")
    Optional<User> findByEmail(@Param("email") String email);

    @Query("select count(u) > 0 from User u where lower(u.email) = :email")
    boolean existsByEmail(@Param("email") String email);

    // SELECT ... FOR UPDATE: các lần đăng nhập cùng một tài khoản xếp hàng, nên bộ đếm sai không bị ghi đè
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select u from User u where lower(u.email) = :email")
    Optional<User> findByEmailForUpdate(@Param("email") String email);
}
