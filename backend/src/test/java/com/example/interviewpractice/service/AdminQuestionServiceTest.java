package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import org.hibernate.exception.ConstraintViolationException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import com.example.interviewpractice.dto.AdminQuestionDto;
import com.example.interviewpractice.dto.QuestionUpsertRequest;
import com.example.interviewpractice.entity.AuditLog;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.AuditLogRepository;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.AuthUser;

class AdminQuestionServiceTest {

    private final QuestionRepository questions = mock(QuestionRepository.class);
    private final UserRepository users = mock(UserRepository.class);
    private final AuditLogRepository auditLogs = mock(AuditLogRepository.class);
    private final PracticeSessionRepository sessions = mock(PracticeSessionRepository.class);
    private final AuthUser admin = new AuthUser(UUID.randomUUID(), "admin@example.com", User.Role.ADMIN);
    private AdminQuestionService service;
    private User adminEntity;

    @BeforeEach
    void setUp() {
        // Giao dịch thật do Spring quản lý; ở đây chỉ cần TransactionTemplate chạy callback
        TransactionTemplate tx = new TransactionTemplate(mock(PlatformTransactionManager.class));
        service = new AdminQuestionService(questions, users, auditLogs, sessions, tx);
        adminEntity = new User();
        adminEntity.setId(admin.id());
        when(users.getReferenceById(admin.id())).thenReturn(adminEntity);
        when(questions.saveAndFlush(any(Question.class))).thenAnswer(invocation -> {
            Question q = invocation.getArgument(0);
            if (q.getId() == null) {
                q.setId(UUID.randomUUID());
            }
            q.setCreatedAt(Instant.parse("2026-10-28T00:00:00Z"));
            return q;
        });
    }

    private static QuestionUpsertRequest request(String industry, String position) {
        return new QuestionUpsertRequest("  Hãy kể về một dự án bạn tự hào  ", industry, position,
                Question.Level.MEDIUM, Question.Type.BEHAVIORAL, "   ", "");
    }

    private static Question existing(UUID id) {
        User creator = new User();
        creator.setId(UUID.randomUUID());
        Question q = new Question();
        q.setId(id);
        q.setCreatedBy(creator);
        q.setStatus(Question.Status.ACTIVE);
        return q;
    }

    private static DataIntegrityViolationException violation(String constraint) {
        return new DataIntegrityViolationException("lỗi toàn vẹn",
                new ConstraintViolationException("lỗi toàn vẹn", new SQLException(), constraint));
    }

    private AuditLog savedAudit() {
        ArgumentCaptor<AuditLog> captor = ArgumentCaptor.forClass(AuditLog.class);
        verify(auditLogs).save(captor.capture());
        return captor.getValue();
    }

    @Test
    void createTrimsInputNormalizesBlankOptionalFieldsAndWritesAudit() {
        AdminQuestionDto dto = service.create(request(" IT ", " Backend Developer "), admin);

        ArgumentCaptor<Question> saved = ArgumentCaptor.forClass(Question.class);
        verify(questions).saveAndFlush(saved.capture());
        Question q = saved.getValue();
        assertEquals("Hãy kể về một dự án bạn tự hào", q.getContent());
        assertEquals("IT", q.getIndustry());
        assertEquals("Backend Developer", q.getPosition());
        assertNull(q.getAnswerHint());
        assertNull(q.getReferenceAnswer());
        assertSame(adminEntity, q.getCreatedBy());
        assertEquals(admin.id(), dto.createdBy());
        AuditLog audit = savedAudit();
        assertEquals("CREATE", audit.getAction());
        assertEquals("QUESTION", audit.getEntityType());
        assertEquals(q.getId(), audit.getEntityId());
        assertSame(adminEntity, audit.getAdmin());
    }

    @Test
    void createRejectsUnknownIndustryOnTheIndustryField() {
        ApiException e = assertThrows(ApiException.class, () -> service.create(request("Y tế", "Chung"), admin));

        assertEquals(HttpStatus.BAD_REQUEST, e.getStatus());
        assertEquals("VALIDATION_ERROR", e.getCode());
        assertEquals("industry", e.getFieldErrors().get(0).field());
        verify(questions, never()).saveAndFlush(any());
        verify(auditLogs, never()).save(any());
    }

    @Test
    void createRejectsPositionOfAnotherIndustryOnThePositionField() {
        ApiException e = assertThrows(ApiException.class,
                () -> service.create(request("Marketing", "Backend Developer"), admin));

        assertEquals("position", e.getFieldErrors().get(0).field());
    }

    @Test
    void taxonomyIsMatchedVerbatimIncludingCase() {
        assertThrows(ApiException.class, () -> service.create(request("it", "Chung"), admin));
    }

    @Test
    void createMapsDuplicateIndexTo409AndWritesNoAudit() {
        when(questions.saveAndFlush(any(Question.class))).thenThrow(violation("uq_questions_position_content"));

        ApiException e = assertThrows(ApiException.class, () -> service.create(request("IT", "Chung"), admin));

        assertEquals(HttpStatus.CONFLICT, e.getStatus());
        assertEquals("DUPLICATE_QUESTION", e.getCode());
        verify(auditLogs, never()).save(any());
    }

    @Test
    void createRethrowsIntegrityErrorsFromOtherConstraints() {
        DataIntegrityViolationException other = violation("ck_questions_level");
        when(questions.saveAndFlush(any(Question.class))).thenThrow(other);

        DataIntegrityViolationException thrown = assertThrows(DataIntegrityViolationException.class,
                () -> service.create(request("IT", "Chung"), admin));

        assertSame(other, thrown);
    }

    @Test
    void updateKeepsCreatorAndWritesAudit() {
        UUID id = UUID.randomUUID();
        Question q = existing(id);
        UUID creatorId = q.getCreatedBy().getId();
        when(questions.findById(id)).thenReturn(Optional.of(q));

        AdminQuestionDto dto = service.update(id, request("IT", "Chung"), admin);

        assertEquals(creatorId, dto.createdBy());
        assertEquals("Chung", q.getPosition());
        assertEquals("UPDATE", savedAudit().getAction());
    }

    @Test
    void updateUnknownQuestionIs404() {
        UUID id = UUID.randomUUID();
        when(questions.findById(id)).thenReturn(Optional.empty());

        ApiException e = assertThrows(ApiException.class, () -> service.update(id, request("IT", "Chung"), admin));

        assertEquals(HttpStatus.NOT_FOUND, e.getStatus());
    }

    @Test
    void updateMapsDuplicateIndexTo409() {
        UUID id = UUID.randomUUID();
        when(questions.findById(id)).thenReturn(Optional.of(existing(id)));
        when(questions.saveAndFlush(any(Question.class))).thenThrow(violation("uq_questions_position_content"));

        ApiException e = assertThrows(ApiException.class, () -> service.update(id, request("IT", "Chung"), admin));

        assertEquals("DUPLICATE_QUESTION", e.getCode());
    }

    @Test
    void deleteHidesQuestionAlreadyUsedInASession() {
        UUID id = UUID.randomUUID();
        Question q = existing(id);
        when(questions.findById(id)).thenReturn(Optional.of(q));
        when(sessions.existsByQuestionId(id)).thenReturn(true);

        service.delete(id, admin);

        assertEquals(Question.Status.HIDDEN, q.getStatus());
        verify(questions, never()).delete(any(Question.class));
        AuditLog audit = savedAudit();
        assertEquals("DELETE", audit.getAction());
        assertEquals(id, audit.getEntityId());
    }

    @Test
    void deleteRemovesUnusedQuestionForGood() {
        UUID id = UUID.randomUUID();
        Question q = existing(id);
        when(questions.findById(id)).thenReturn(Optional.of(q));
        when(sessions.existsByQuestionId(id)).thenReturn(false);

        service.delete(id, admin);

        verify(questions).delete(q);
        verify(questions).flush();
        assertEquals(Question.Status.ACTIVE, q.getStatus());
        assertEquals("DELETE", savedAudit().getAction());
    }

    @Test
    void deleteFallsBackToHidingWhenASessionAppearsBeforeTheHardDelete() {
        UUID id = UUID.randomUUID();
        Question q = existing(id);
        when(questions.findById(id)).thenReturn(Optional.of(q));
        when(sessions.existsByQuestionId(id)).thenReturn(false);
        org.mockito.Mockito.doThrow(violation("fk_practice_sessions_question_id")).when(questions).flush();

        service.delete(id, admin);

        assertEquals(Question.Status.HIDDEN, q.getStatus());
        // Lần thử đầu bị hủy nên chỉ lần ẩn câu hỏi ghi audit
        verify(auditLogs, times(1)).save(any(AuditLog.class));
    }

    @Test
    void deleteRethrowsOtherIntegrityErrors() {
        UUID id = UUID.randomUUID();
        when(questions.findById(id)).thenReturn(Optional.of(existing(id)));
        DataIntegrityViolationException other = violation("fk_something_else");
        org.mockito.Mockito.doThrow(other).when(questions).flush();

        DataIntegrityViolationException thrown = assertThrows(DataIntegrityViolationException.class,
                () -> service.delete(id, admin));

        assertSame(other, thrown);
        verify(auditLogs, never()).save(any());
    }

    @Test
    void deleteUnknownQuestionIs404() {
        UUID id = UUID.randomUUID();
        when(questions.findById(id)).thenReturn(Optional.empty());

        ApiException e = assertThrows(ApiException.class, () -> service.delete(id, admin));

        assertEquals(HttpStatus.NOT_FOUND, e.getStatus());
        verify(auditLogs, never()).save(any());
    }
}
