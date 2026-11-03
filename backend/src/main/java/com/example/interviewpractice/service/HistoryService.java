package com.example.interviewpractice.service;

import java.math.BigDecimal;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.dto.HistoryDetailDto;
import com.example.interviewpractice.dto.HistoryFilter;
import com.example.interviewpractice.dto.HistoryPageDto;
import com.example.interviewpractice.dto.PracticeSessionDto;
import com.example.interviewpractice.dto.ScoreResultDto;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.HistoryRepository;
import com.example.interviewpractice.repository.ScoreResultRepository;

/**
 * Lịch sử luyện tập (UC7, #118). B1: người dùng chỉ xem được phiên của chính mình, kể cả ADMIN.
 * Danh sách chỉ gồm phiên đã chấm (SCORED), mới nhất trước theo thời điểm chấm xong.
 */
@Service
@Transactional(readOnly = true)
public class HistoryService {

    // Ngày trong bộ lọc from/to là ngày theo giờ Việt Nam, người dùng chọn trên lịch
    static final ZoneId ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    static final int MAX_PAGE_SIZE = 100;
    private static final BigDecimal MAX_SCORE = BigDecimal.valueOf(100);

    private final HistoryRepository history;
    private final ScoreResultRepository scoreResults;

    public HistoryService(HistoryRepository history, ScoreResultRepository scoreResults) {
        this.history = history;
        this.scoreResults = scoreResults;
    }

    public HistoryPageDto list(UUID userId, HistoryFilter filter, int page, int size) {
        validate(filter, page, size);
        Pageable pageable = PageRequest.of(page, size,
                Sort.by(Sort.Order.desc("completedAt"), Sort.Order.desc("id")));
        return HistoryPageDto.from(history.findAll(specification(userId, filter), pageable)
                .map(s -> PracticeSessionDto.from(s, null)));
    }

    public HistoryDetailDto detail(UUID userId, UUID sessionId) {
        PracticeSession session = history.findById(sessionId)
                .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND",
                        "Không tìm thấy phiên luyện tập"));
        if (!session.getUser().getId().equals(userId)) {
            throw new ApiException(HttpStatus.FORBIDDEN, "FORBIDDEN", "Bạn không có quyền xem phiên luyện tập này");
        }
        ScoreResultDto result = scoreResults.findBySessionId(sessionId)
                .map(r -> ScoreResultDto.from(r, null))
                .orElse(null);
        return HistoryDetailDto.of(PracticeSessionDto.from(session, null), result);
    }

    static Specification<PracticeSession> specification(UUID userId, HistoryFilter f) {
        return (root, query, cb) -> {
            var predicates = new ArrayList<jakarta.persistence.criteria.Predicate>();
            predicates.add(cb.equal(root.get("user").get("id"), userId));
            predicates.add(cb.equal(root.get("status"), PracticeSession.Status.SCORED));
            if (f.from() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("completedAt"),
                        f.from().atStartOfDay(ZONE).toInstant()));
            }
            if (f.to() != null) {
                // to là ngày cuối cùng được tính, nên lấy tới trước 0h ngày hôm sau
                predicates.add(cb.lessThan(root.get("completedAt"),
                        f.to().plusDays(1).atStartOfDay(ZONE).toInstant()));
            }
            if (f.industry() != null && !f.industry().isBlank()) {
                predicates.add(cb.equal(root.get("question").get("industry"), f.industry().strip()));
            }
            if (f.minScore() != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("totalScore"), f.minScore()));
            }
            if (f.maxScore() != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("totalScore"), f.maxScore()));
            }
            return cb.and(predicates.toArray(jakarta.persistence.criteria.Predicate[]::new));
        };
    }

    private static void validate(HistoryFilter f, int page, int size) {
        List<ErrorResponse.FieldError> errors = new ArrayList<>();
        if (page < 0) errors.add(new ErrorResponse.FieldError("page", "Số trang phải từ 0 trở lên"));
        if (size < 1 || size > MAX_PAGE_SIZE) {
            errors.add(new ErrorResponse.FieldError("size", "Số phần tử mỗi trang phải từ 1 đến " + MAX_PAGE_SIZE));
        }
        if (outOfRange(f.minScore())) errors.add(new ErrorResponse.FieldError("minScore", "Điểm phải từ 0 đến 100"));
        if (outOfRange(f.maxScore())) errors.add(new ErrorResponse.FieldError("maxScore", "Điểm phải từ 0 đến 100"));
        if (f.minScore() != null && f.maxScore() != null && f.minScore().compareTo(f.maxScore()) > 0) {
            errors.add(new ErrorResponse.FieldError("minScore", "Điểm tối thiểu không được lớn hơn điểm tối đa"));
        }
        if (f.from() != null && f.to() != null && f.from().isAfter(f.to())) {
            errors.add(new ErrorResponse.FieldError("from", "Ngày bắt đầu không được sau ngày kết thúc"));
        }
        if (!errors.isEmpty()) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ", errors);
        }
    }

    private static boolean outOfRange(BigDecimal score) {
        return score != null && (score.signum() < 0 || score.compareTo(MAX_SCORE) > 0);
    }
}
