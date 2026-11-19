package com.example.interviewpractice.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.dto.AnalyticsOverview;
import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.dto.PracticeSessionResponse;
import com.example.interviewpractice.dto.UserActivity;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.PracticeSessionRepository;

/**
 * Thống kê hoạt động và chi phí AI cho admin (UC9, #163). Khoảng [from, to] là ngày lịch (tính cả hai đầu) theo múi
 * giờ app.scoring.day-zone; bỏ trống thì không giới hạn phía đó. Chỉ trả số liệu tổng hợp và tên/email, không đụng tới
 * mật khẩu hay dữ liệu nhạy cảm khác (B2).
 */
@Service
public class AnalyticsService {

    private static final Instant MIN = Instant.parse("1970-01-01T00:00:00Z");
    private static final Instant MAX = Instant.parse("9999-01-01T00:00:00Z");
    private static final int RECENT_SESSIONS = 10;

    private final NamedParameterJdbcTemplate jdbc;
    private final PracticeSessionRepository sessions;
    private final ZoneId zone;

    public AnalyticsService(NamedParameterJdbcTemplate jdbc, PracticeSessionRepository sessions,
            @Value("${app.scoring.day-zone}") String dayZone) {
        this.jdbc = jdbc;
        this.sessions = sessions;
        this.zone = ZoneId.of(dayZone);
    }

    @Transactional(readOnly = true)
    public AnalyticsOverview overview(LocalDate from, LocalDate to) {
        MapSqlParameterSource range = range(from, to);
        long totalUsers = jdbc.queryForObject("SELECT COUNT(*) FROM users", Map.of(), Long.class);
        Map<String, Object> s = jdbc.queryForMap("SELECT COUNT(*) AS total, COUNT(DISTINCT user_id) AS active, "
                + "COUNT(*) FILTER (WHERE status = 'SCORED') AS scored, "
                + "AVG(total_score) FILTER (WHERE status = 'SCORED') AS avg_score "
                + "FROM practice_sessions WHERE started_at >= :from AND started_at < :to", range);

        long stt = 0;
        long llm = 0;
        long tts = 0;
        BigDecimal cost = BigDecimal.ZERO;
        for (Map<String, Object> row : jdbc.queryForList("SELECT provider, COUNT(*) AS calls, "
                + "COALESCE(SUM(estimated_cost), 0) AS cost FROM api_usages "
                + "WHERE called_at >= :from AND called_at < :to GROUP BY provider", range)) {
            long calls = ((Number) row.get("calls")).longValue();
            switch ((String) row.get("provider")) {
                case "STT" -> stt = calls;
                case "LLM" -> llm = calls;
                case "TTS" -> tts = calls;
                default -> { }
            }
            cost = cost.add((BigDecimal) row.get("cost"));
        }
        return new AnalyticsOverview(totalUsers, ((Number) s.get("active")).longValue(),
                ((Number) s.get("total")).longValue(), ((Number) s.get("scored")).longValue(),
                round((BigDecimal) s.get("avg_score")), new AnalyticsOverview.AiApiCalls(stt, llm, tts), cost);
    }

    @Transactional(readOnly = true)
    public UserActivity userActivity(UUID userId) {
        List<Map<String, Object>> users = jdbc.queryForList("SELECT full_name, email FROM users WHERE id = :id",
                Map.of("id", userId));
        if (users.isEmpty()) {
            throw new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND", "Không tìm thấy người dùng");
        }
        Map<String, Object> s = jdbc.queryForMap("SELECT COUNT(*) AS total, "
                + "AVG(total_score) FILTER (WHERE status = 'SCORED') AS avg_score, MAX(started_at) AS last_at "
                + "FROM practice_sessions WHERE user_id = :id", Map.of("id", userId));
        List<PracticeSessionResponse> recent = sessions
                .findByUserIdOrderByStartedAtDesc(userId, PageRequest.of(0, RECENT_SESSIONS)).getContent().stream()
                .map(PracticeSessionResponse::from).toList();
        return new UserActivity(userId, (String) users.get(0).get("full_name"), (String) users.get(0).get("email"),
                ((Number) s.get("total")).longValue(), round((BigDecimal) s.get("avg_score")),
                toInstant(s.get("last_at")), recent);
    }

    /** CSV báo cáo theo người dùng trong khoảng ngày; có BOM để Excel đọc đúng tiếng Việt, ô được chống formula injection. */
    @Transactional(readOnly = true)
    public String exportCsv(LocalDate from, LocalDate to) {
        StringBuilder csv = new StringBuilder("﻿");
        csv.append("Họ tên,Email,Số phiên,Số phiên đã chấm,Điểm trung bình,Lần luyện tập gần nhất\r\n");
        jdbc.query("SELECT u.full_name, u.email, COUNT(s.id) AS total, "
                + "COUNT(s.id) FILTER (WHERE s.status = 'SCORED') AS scored, "
                + "AVG(s.total_score) FILTER (WHERE s.status = 'SCORED') AS avg_score, MAX(s.started_at) AS last_at "
                + "FROM users u LEFT JOIN practice_sessions s ON s.user_id = u.id "
                + "AND s.started_at >= :from AND s.started_at < :to GROUP BY u.id ORDER BY u.email", range(from, to),
                rs -> {
                    BigDecimal avg = round(rs.getBigDecimal("avg_score"));
                    Timestamp last = rs.getTimestamp("last_at");
                    csv.append(cell(rs.getString("full_name"))).append(',').append(cell(rs.getString("email")))
                            .append(',').append(rs.getLong("total")).append(',').append(rs.getLong("scored"))
                            .append(',').append(avg == null ? "" : avg.toPlainString()).append(',')
                            .append(last == null ? "" : last.toInstant()).append("\r\n");
                });
        return csv.toString();
    }

    private MapSqlParameterSource range(LocalDate from, LocalDate to) {
        if (from != null && to != null && from.isAfter(to)) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ",
                    List.of(new ErrorResponse.FieldError("from", "from không được sau to")));
        }
        Instant start = from == null ? MIN : from.atStartOfDay(zone).toInstant();
        Instant end = to == null ? MAX : to.plusDays(1).atStartOfDay(zone).toInstant();
        return new MapSqlParameterSource().addValue("from", Timestamp.from(start)).addValue("to", Timestamp.from(end));
    }

    private static BigDecimal round(BigDecimal value) {
        return value == null ? null : value.setScale(2, RoundingMode.HALF_UP);
    }

    private static Instant toInstant(Object timestamp) {
        return timestamp == null ? null : ((Timestamp) timestamp).toInstant();
    }

    /** Escape theo RFC 4180; ô bắt đầu bằng = + - @ bị Excel coi là công thức nên thêm dấu nháy đơn phía trước. */
    static String cell(String value) {
        String text = value == null ? "" : value;
        if (!text.isEmpty() && "=+-@\t\r".indexOf(text.charAt(0)) >= 0) {
            text = "'" + text;
        }
        return "\"" + text.replace("\"", "\"\"") + "\"";
    }
}
