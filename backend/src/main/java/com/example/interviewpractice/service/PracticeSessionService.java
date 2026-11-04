package com.example.interviewpractice.service;

import java.io.IOException;
import java.time.Clock;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.interviewpractice.config.AudioProperties;
import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.dto.PracticeSessionResponse;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.AuthUser;
import com.example.interviewpractice.service.storage.AudioStorage;
import com.example.interviewpractice.service.storage.AudioStorageException;

/** Tạo, xem và nộp audio cho phiên luyện tập (UC3, UC4). */
@Service
public class PracticeSessionService {

    private static final Logger log = LoggerFactory.getLogger(PracticeSessionService.class);

    // MIME được nhận (đã bỏ tham số như ;codecs=opus) quy về MIME chuẩn dùng để lưu
    private static final Map<String, String> CANONICAL_MIME = Map.of(
            "audio/webm", "audio/webm",
            "audio/ogg", "audio/ogg",
            "audio/mpeg", "audio/mpeg",
            "audio/mp3", "audio/mpeg",
            "audio/wav", "audio/wav",
            "audio/x-wav", "audio/wav",
            "audio/wave", "audio/wav",
            "audio/mp4", "audio/mp4",
            "audio/x-m4a", "audio/mp4",
            "audio/m4a", "audio/mp4");
    private static final Set<String> EXTENSIONS = Set.of("webm", "ogg", "mp3", "wav", "m4a", "mp4");

    private final PracticeSessionRepository sessions;
    private final QuestionRepository questions;
    private final UserRepository users;
    private final SessionAccess access;
    private final AudioStorage storage;
    private final AudioProperties audio;
    private final Clock clock;

    public PracticeSessionService(PracticeSessionRepository sessions, QuestionRepository questions,
            UserRepository users, SessionAccess access, AudioStorage storage, AudioProperties audio, Clock clock) {
        this.sessions = sessions;
        this.questions = questions;
        this.users = users;
        this.access = access;
        this.storage = storage;
        this.audio = audio;
        this.clock = clock;
    }

    @Transactional
    public PracticeSessionResponse create(UUID questionId, AuthUser user) {
        Question question = questions.findById(questionId)
                .filter(q -> q.getStatus() == Question.Status.ACTIVE)
                .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND",
                        "Câu hỏi không tồn tại hoặc không còn hoạt động"));
        PracticeSession session = new PracticeSession();
        session.setUser(users.getReferenceById(user.id()));
        session.setQuestion(question);
        return PracticeSessionResponse.from(sessions.save(session));
    }

    @Transactional(readOnly = true)
    public PracticeSessionResponse get(UUID sessionId, AuthUser user) {
        return PracticeSessionResponse.from(access.requireOwned(sessionId, user));
    }

    /**
     * Nộp audio: kiểm tra đầu vào trước, gọi S3 ngoài transaction, rồi mới đổi trạng thái bằng một UPDATE có điều kiện.
     * Cố ý không có @Transactional để không giữ kết nối CSDL trong lúc tải lên S3.
     */
    public PracticeSessionResponse uploadAnswer(UUID sessionId, AuthUser user, MultipartFile file,
            Integer durationSeconds) {
        PracticeSession session = access.requireOwned(sessionId, user);
        validateDuration(durationSeconds);
        String contentType = validateFile(file);
        rejectIfNotUploadable(session.getStatus());

        byte[] data;
        try {
            data = file.getBytes();
        } catch (IOException e) {
            throw validation("audio", "Không đọc được file audio");
        }
        String key;
        try {
            key = storage.put(user.id(), sessionId, data, contentType);
        } catch (AudioStorageException e) {
            log.error("Lưu audio thất bại sessionId={}", sessionId, e);
            throw new ApiException(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE",
                    "Không lưu được audio, vui lòng thử lại sau");
        }

        if (sessions.markUploaded(sessionId, key, durationSeconds, clock.instant()) == 0) {
            // Trạng thái đổi sang PROCESSING/SCORED giữa lúc kiểm tra và lúc cập nhật
            rejectIfNotUploadable(sessions.findById(sessionId).map(PracticeSession::getStatus).orElse(null));
            throw new ApiException(HttpStatus.CONFLICT, "SESSION_PROCESSING", "Phiên đang được xử lý");
        }
        return PracticeSessionResponse.from(access.requireOwned(sessionId, user));
    }

    private static void rejectIfNotUploadable(PracticeSession.Status status) {
        if (status == PracticeSession.Status.PROCESSING) {
            throw new ApiException(HttpStatus.CONFLICT, "SESSION_PROCESSING",
                    "Phiên đang được xử lý, không thể nộp lại audio");
        }
        if (status == PracticeSession.Status.SCORED) {
            throw new ApiException(HttpStatus.CONFLICT, "SESSION_ALREADY_SCORED",
                    "Phiên đã được chấm điểm, không thể nộp lại audio");
        }
    }

    private void validateDuration(Integer durationSeconds) {
        if (durationSeconds == null || durationSeconds < audio.minSeconds() || durationSeconds > audio.maxSeconds()) {
            throw validation("durationSeconds", "Thời lượng ghi âm phải từ " + audio.minSeconds() + " đến "
                    + audio.maxSeconds() + " giây");
        }
    }

    /** Trả MIME chuẩn của file hợp lệ; sai kích thước/định dạng thì 400 VALIDATION_ERROR. */
    private String validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw validation("audio", "File audio là bắt buộc và không được rỗng");
        }
        if (file.getSize() > audio.maxBytes()) {
            throw validation("audio",
                    "File audio vượt quá dung lượng tối đa " + audio.maxBytes() / (1024 * 1024) + "MB");
        }
        String mime = file.getContentType() == null ? ""
                : file.getContentType().split(";", 2)[0].trim().toLowerCase(Locale.ROOT);
        String canonical = CANONICAL_MIME.get(mime);
        String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        String extension = name.contains(".") ? name.substring(name.lastIndexOf('.') + 1) : "";
        if (canonical == null || !EXTENSIONS.contains(extension)) {
            throw validation("audio", "Định dạng audio không được hỗ trợ (webm, ogg, mp3, wav, m4a)");
        }
        return canonical;
    }

    private static ApiException validation(String field, String message) {
        return new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ",
                List.of(new ErrorResponse.FieldError(field, message)));
    }
}
