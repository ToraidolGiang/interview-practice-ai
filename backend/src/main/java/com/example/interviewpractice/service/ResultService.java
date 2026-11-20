package com.example.interviewpractice.service;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.dto.ScoreResultResponse;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.ScoreResultRepository;
import com.example.interviewpractice.security.AuthUser;

/** Đọc kết quả chấm của phiên luyện tập (chỉ chủ phiên, chỉ khi đã SCORED). */
@Service
public class ResultService {

    private final SessionAccess access;
    private final ScoreResultRepository results;

    public ResultService(SessionAccess access, ScoreResultRepository results) {
        this.access = access;
        this.results = results;
    }

    @Transactional(readOnly = true)
    public ScoreResultResponse get(UUID sessionId, AuthUser user) {
        PracticeSession session = access.requireOwned(sessionId, user);
        if (session.getStatus() != PracticeSession.Status.SCORED) {
            throw new ApiException(HttpStatus.CONFLICT, "SESSION_NOT_READY", "Phiên chưa có kết quả chấm điểm");
        }
        return results.findBySessionId(sessionId)
                .map(ScoreResultResponse::from)
                .orElseThrow(() -> new ApiException(HttpStatus.CONFLICT, "SESSION_NOT_READY",
                        "Phiên chưa có kết quả chấm điểm"));
    }
}
