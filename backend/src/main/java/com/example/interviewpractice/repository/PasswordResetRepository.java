package com.example.interviewpractice.repository;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import com.example.interviewpractice.entity.PasswordResetToken;

import jakarta.persistence.LockModeType;

/**
 * Truy vấn cho quên mật khẩu (#157). Tách khỏi PasswordResetTokenRepository (dùng chung, do #111 quản lý) để thêm
 * khóa dòng và cập nhật hàng loạt mà không sửa repository dùng chung.
 */
public interface PasswordResetRepository extends Repository<PasswordResetToken, UUID> {

    PasswordResetToken save(PasswordResetToken token);

    /** Khóa dòng token để hai request dùng cùng một token cùng lúc chỉ có một request thành công. */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select t from PasswordResetToken t where t.tokenHash = :tokenHash")
    Optional<PasswordResetToken> findByTokenHashForUpdate(@Param("tokenHash") String tokenHash);

    /** Có token chưa dùng hết hạn sau mốc này không; dùng để biết vừa gửi email trong khoảng chờ hay chưa. */
    @Query("select count(t) > 0 from PasswordResetToken t "
            + "where t.user.id = :userId and t.usedAt is null and t.expiresAt > :expiresAfter")
    boolean existsUnusedExpiringAfter(@Param("userId") UUID userId, @Param("expiresAfter") Instant expiresAfter);

    /** Vô hiệu mọi token chưa dùng của người dùng (sau khi đặt lại mật khẩu thành công). */
    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("update PasswordResetToken t set t.usedAt = :now where t.user.id = :userId and t.usedAt is null")
    int markAllUnusedAsUsed(@Param("userId") UUID userId, @Param("now") Instant now);
}
