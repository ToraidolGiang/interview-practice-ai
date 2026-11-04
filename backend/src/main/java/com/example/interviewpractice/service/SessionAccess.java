package com.example.interviewpractice.service;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.security.AuthUser;

/** Kiểm quyền sở hữu phiên luyện tập (chống IDOR); mọi endpoint theo {id} đều đi qua đây. */
@Component
public class SessionAccess {

    private final PracticeSessionRepository sessions;

    public SessionAccess(PracticeSessionRepository sessions) {
        this.sessions = sessions;
    }

    /** Không tồn tại thì 404, của người khác thì 403 (theo openapi.yaml). */
    public PracticeSession requireOwned(UUID sessionId, AuthUser user) {
        PracticeSession session = sessions.findById(sessionId).orElseThrow(() ->
                new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND", "Không tìm thấy phiên luyện tập"));
        // getId() trên proxy lazy không nạp User
        if (!session.getUser().getId().equals(user.id())) {
            throw new ApiException(HttpStatus.FORBIDDEN, "FORBIDDEN", "Bạn không phải chủ sở hữu phiên luyện tập này");
        }
        return session;
    }
}
