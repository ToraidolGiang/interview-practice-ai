package com.example.interviewpractice.repository;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.dto.ScoringInput;

public interface PracticeSessionRepository extends JpaRepository<PracticeSession, UUID> {

    Page<PracticeSession> findByUserIdOrderByStartedAtDesc(UUID userId, Pageable pageable);

    /** Câu hỏi đã từng được dùng trong phiên luyện tập thì chỉ được ẩn, không xóa cứng. */
    boolean existsByQuestionId(UUID questionId);

    /**
     * Ghi nhận audio đã tải lên; chỉ khi phiên đang CREATED/UPLOADED/FAILED (một UPDATE có điều kiện nên không
     * ghi đè phiên đang chấm). Trả 0 nếu phiên không còn ở các trạng thái đó.
     */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'UPLOADED', audio_key = :audioKey, "
            + "duration_sec = :durationSec, submitted_at = :now, error_code = NULL, completed_at = NULL "
            + "WHERE id = :id AND status IN ('CREATED', 'UPLOADED', 'FAILED')", nativeQuery = true)
    int markUploaded(@Param("id") UUID id, @Param("audioKey") String audioKey,
            @Param("durationSec") int durationSec, @Param("now") Instant now);

    /** Chốt phiên đang chấm thành SCORED; trả 0 nếu phiên không còn PROCESSING (không ghi đè trạng thái khác). */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'SCORED', total_score = :totalScore, "
            + "completed_at = :now, error_code = NULL WHERE id = :id AND status = 'PROCESSING'", nativeQuery = true)
    int markScored(@Param("id") UUID id, @Param("totalScore") BigDecimal totalScore, @Param("now") Instant now);

    /** Chốt phiên đang chấm thành FAILED kèm mã lỗi; trả 0 nếu phiên không còn PROCESSING. */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'FAILED', error_code = :errorCode, completed_at = :now "
            + "WHERE id = :id AND status = 'PROCESSING'", nativeQuery = true)
    int markFailed(@Param("id") UUID id, @Param("errorCode") String errorCode, @Param("now") Instant now);

    /**
     * Giành quyền chấm: chỉ phiên UPLOADED/FAILED mới sang PROCESSING (một UPDATE có điều kiện nên hai request
     * đồng thời chỉ một cái thắng). Trả 0 nếu phiên ở trạng thái khác.
     */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'PROCESSING', processing_started_at = :now, "
            + "error_code = NULL, completed_at = NULL WHERE id = :id AND status IN ('UPLOADED', 'FAILED')", nativeQuery = true)
    int markProcessing(@Param("id") UUID id, @Param("now") Instant now);

    /** Hoàn tác về UPLOADED khi không đưa được việc chấm vào hàng đợi; trả 0 nếu phiên không còn PROCESSING. */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'UPLOADED', processing_started_at = NULL "
            + "WHERE id = :id AND status = 'PROCESSING'", nativeQuery = true)
    int revertToUploaded(@Param("id") UUID id);

    /**
     * Đánh FAILED (SERVER_RESTART) các phiên PROCESSING bắt đầu chấm trước thời điểm khởi động: việc chấm nằm
     * trong bộ nhớ nên đã mất theo tiến trình cũ. Phiên bắt đầu sau bootTime không bị đụng tới.
     */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'FAILED', error_code = 'SERVER_RESTART', "
            + "completed_at = :now WHERE status = 'PROCESSING' AND processing_started_at < :bootTime",
            nativeQuery = true)
    int failStaleProcessing(@Param("bootTime") Instant bootTime, @Param("now") Instant now);

    /**
     * Đánh FAILED (PROCESSING_TIMEOUT) các phiên PROCESSING quá hạn khi ứng dụng vẫn chạy (F3): lúc DB chập chờn
     * markFailed/revertToUploaded có thể lỗi và phiên kẹt mãi. Chỉ đụng phiên bắt đầu chấm trước cutoff.
     */
    @Transactional
    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "UPDATE practice_sessions SET status = 'FAILED', error_code = 'PROCESSING_TIMEOUT', "
            + "completed_at = :now WHERE status = 'PROCESSING' AND processing_started_at < :cutoff",
            nativeQuery = true)
    int failTimedOutProcessing(@Param("cutoff") Instant cutoff, @Param("now") Instant now);

    /** Số phiên đang chấm của một người dùng, để giới hạn tải theo user (F4). */
    @Query("SELECT COUNT(s) FROM PracticeSession s WHERE s.user.id = :userId AND s.status = "
            + "com.example.interviewpractice.entity.PracticeSession.Status.PROCESSING")
    long countProcessingByUser(@Param("userId") UUID userId);

    /** Dữ liệu worker cần để chấm; đọc bằng một truy vấn nên không giữ transaction/entity lazy khi gọi dịch vụ ngoài. */
    @Query("SELECT new com.example.interviewpractice.dto.ScoringInput(s.id, s.audioKey, s.durationSec, "
            + "q.questionType, q.content, q.referenceAnswer) FROM PracticeSession s JOIN s.question q "
            + "WHERE s.id = :id")
    Optional<ScoringInput> findScoringInput(@Param("id") UUID id);
}
