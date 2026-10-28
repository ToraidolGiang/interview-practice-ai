package com.example.interviewpractice.service;

import java.util.UUID;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import com.example.interviewpractice.dto.AdminQuestionDto;
import com.example.interviewpractice.dto.PageResponse;
import com.example.interviewpractice.dto.QuestionUpsertRequest;
import com.example.interviewpractice.entity.AuditLog;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.exception.DbConstraints;
import com.example.interviewpractice.repository.AuditLogRepository;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.QuestionSpecifications;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.AuthUser;

/** Quản trị câu hỏi (UC8): thêm, sửa, xóa; mọi thao tác ghi AuditLog trong cùng transaction (NF2). */
@Service
public class AdminQuestionService {

    static final String ENTITY_TYPE = "QUESTION";
    private static final String DUPLICATE_INDEX = "uq_questions_position_content";
    private static final String SESSION_QUESTION_FK = "fk_practice_sessions_question_id";

    private final QuestionRepository questions;
    private final UserRepository users;
    private final AuditLogRepository auditLogs;
    private final PracticeSessionRepository sessions;
    private final TransactionTemplate tx;

    public AdminQuestionService(QuestionRepository questions, UserRepository users, AuditLogRepository auditLogs,
            PracticeSessionRepository sessions, TransactionTemplate tx) {
        this.questions = questions;
        this.users = users;
        this.auditLogs = auditLogs;
        this.sessions = sessions;
        this.tx = tx;
    }

    @Transactional(readOnly = true)
    public PageResponse<AdminQuestionDto> search(Question.Status status, String keyword, int page, int size) {
        Specification<Question> spec = QuestionSpecifications.any();
        spec = QuestionSpecifications.andIf(spec, status != null ? QuestionSpecifications.hasStatus(status) : null);
        spec = QuestionSpecifications.andIf(spec, QuestionService.keywordSpec(keyword));
        return PageResponse.from(
                questions.findAll(spec, PageRequest.of(page, size, QuestionSpecifications.NEWEST_FIRST)),
                AdminQuestionDto::from);
    }

    @Transactional
    public AdminQuestionDto create(QuestionUpsertRequest request, AuthUser admin) {
        Question question = new Question();
        apply(question, request);
        question.setCreatedBy(users.getReferenceById(admin.id()));
        save(question);
        audit(admin, "CREATE", question.getId());
        return AdminQuestionDto.from(question);
    }

    @Transactional
    public AdminQuestionDto update(UUID id, QuestionUpsertRequest request, AuthUser admin) {
        Question question = questions.findById(id).orElseThrow(AdminQuestionService::notFound);
        apply(question, request);
        save(question);
        audit(admin, "UPDATE", question.getId());
        return AdminQuestionDto.from(question);
    }

    /**
     * Câu hỏi đã có trong phiên luyện tập thì ẩn (HIDDEN), chưa có thì xóa cứng. Nếu một phiên mới được tạo
     * giữa lúc kiểm tra và lúc xóa, khóa ngoại chặn xóa cứng; khi đó làm lại trong transaction mới theo hướng ẩn.
     */
    public void delete(UUID id, AuthUser admin) {
        try {
            tx.executeWithoutResult(status -> removeOrHide(id, admin, false));
        } catch (DataIntegrityViolationException e) {
            if (!DbConstraints.violates(e, SESSION_QUESTION_FK)) {
                throw e;
            }
            tx.executeWithoutResult(status -> removeOrHide(id, admin, true));
        }
    }

    private void removeOrHide(UUID id, AuthUser admin, boolean forceHide) {
        Question question = questions.findById(id).orElseThrow(AdminQuestionService::notFound);
        if (forceHide || sessions.existsByQuestionId(id)) {
            question.setStatus(Question.Status.HIDDEN);
            questions.saveAndFlush(question);
        } else {
            questions.delete(question);
            // flush để vi phạm khóa ngoại lộ ra tại đây thay vì lúc commit
            questions.flush();
        }
        audit(admin, "DELETE", id);
    }

    /** Kiểm tra taxonomy và chuẩn hóa: bỏ khoảng trắng đầu cuối, chuỗi rỗng ở trường tùy chọn thành null. */
    private static void apply(Question question, QuestionUpsertRequest request) {
        String industry = request.industry().trim();
        String position = request.position().trim();
        var fieldErrors = Taxonomy.validate(industry, position);
        if (!fieldErrors.isEmpty()) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Dữ liệu không hợp lệ", fieldErrors);
        }
        question.setContent(request.content().trim());
        question.setIndustry(industry);
        question.setPosition(position);
        question.setLevel(request.level());
        question.setQuestionType(request.questionType());
        question.setAnswerHint(blankToNull(request.answerHint()));
        question.setReferenceAnswer(blankToNull(request.referenceAnswer()));
    }

    private void save(Question question) {
        try {
            // saveAndFlush để vi phạm chỉ mục trùng nội dung lộ ra tại đây, kể cả khi hai admin gửi cùng lúc
            questions.saveAndFlush(question);
        } catch (DataIntegrityViolationException e) {
            if (!DbConstraints.violates(e, DUPLICATE_INDEX)) {
                throw e;
            }
            throw new ApiException(HttpStatus.CONFLICT, "DUPLICATE_QUESTION",
                    "Câu hỏi này đã có trong vị trí " + question.getPosition());
        }
    }

    private void audit(AuthUser admin, String action, UUID questionId) {
        AuditLog log = new AuditLog();
        log.setAdmin(users.getReferenceById(admin.id()));
        log.setAction(action);
        log.setEntityType(ENTITY_TYPE);
        log.setEntityId(questionId);
        auditLogs.save(log);
    }

    private static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private static ApiException notFound() {
        return new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND", "Không tìm thấy câu hỏi");
    }
}
