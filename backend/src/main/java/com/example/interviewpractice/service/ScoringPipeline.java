package com.example.interviewpractice.service;

import java.time.Clock;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.example.interviewpractice.config.KnowledgeCheckProperties;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.ScoringInputView;
import com.example.interviewpractice.service.ai.KnowledgeErrorDetector;
import com.example.interviewpractice.service.ai.LlmException;
import com.example.interviewpractice.service.ai.LlmRequest;
import com.example.interviewpractice.service.ai.LlmResult;
import com.example.interviewpractice.service.ai.LlmScorer;
import com.example.interviewpractice.service.ai.PromptBuilder;
import com.example.interviewpractice.service.ai.SttClient;
import com.example.interviewpractice.service.ai.SttException;
import com.example.interviewpractice.service.scoring.DeliveryMetrics;
import com.example.interviewpractice.service.scoring.DeliveryMetricsProvider;
import com.example.interviewpractice.service.scoring.KnowledgeError;
import com.example.interviewpractice.service.scoring.ScoreCalculator;
import com.example.interviewpractice.service.scoring.ScoreOutcome;
import com.example.interviewpractice.service.storage.AudioStorage;
import com.example.interviewpractice.service.storage.AudioStorageException;

/**
 * Luồng chấm nền của một phiên: audio -> STT -> kiểm độ dài -> LLM -> Delivery -> tính điểm -> lưu.
 * Không có @Transactional: STT/LLM/S3 chạy ngoài transaction, chỉ các bước ghi CSDL mới có transaction ngắn riêng.
 * Mọi lỗi (kể cả lỗi bất ngờ) đều chốt phiên FAILED để phiên không treo ở PROCESSING.
 */
@Component
public class ScoringPipeline {

    /** Mã lỗi cho lỗi ngoài danh sách nghiệp vụ (lỗi lập trình, CSDL...). */
    static final String INTERNAL_ERROR = "INTERNAL_ERROR";
    static final String STT_ERROR = "STT_ERROR";
    static final String ANSWER_TOO_SHORT = "ANSWER_TOO_SHORT";
    /** Số từ tối thiểu của transcript (tính theo khoảng trắng, Rubric mục 3). */
    static final int MIN_WORDS = 15;
    /** Chờ thêm sau timeout HTTP của lượt kiểm lỗi để lỗi timeout tự nhiên được báo trước khi ta bỏ chờ. */
    private static final long CHECK_GRACE_MS = 1000;

    private static final Logger log = LoggerFactory.getLogger(ScoringPipeline.class);

    private final PracticeSessionRepository sessions;
    private final AudioStorage storage;
    private final SttClient stt;
    private final PromptBuilder promptBuilder;
    private final LlmScorer llmScorer;
    private final DeliveryMetricsProvider delivery;
    private final ScoreCalculator calculator;
    private final ScoreResultWriter writer;
    private final Clock clock;
    private final KnowledgeErrorDetector errorDetector;
    private final KnowledgeCheckProperties knowledgeCheck;
    private final ExecutorService checkExecutor;

    public ScoringPipeline(PracticeSessionRepository sessions, AudioStorage storage, SttClient stt,
            PromptBuilder promptBuilder, LlmScorer llmScorer, DeliveryMetricsProvider delivery,
            ScoreCalculator calculator, ScoreResultWriter writer, Clock clock, KnowledgeErrorDetector errorDetector,
            KnowledgeCheckProperties knowledgeCheck, @Qualifier("knowledgeCheckExecutor") ExecutorService checkExecutor) {
        this.sessions = sessions;
        this.storage = storage;
        this.stt = stt;
        this.promptBuilder = promptBuilder;
        this.llmScorer = llmScorer;
        this.delivery = delivery;
        this.calculator = calculator;
        this.writer = writer;
        this.clock = clock;
        this.errorDetector = errorDetector;
        this.knowledgeCheck = knowledgeCheck;
        this.checkExecutor = checkExecutor;
    }

    /** Chạy trên luồng của executor; không ném ra ngoài để luồng pool không chết và phiên luôn có kết cục. */
    public void run(UUID sessionId) {
        try {
            score(sessionId);
        } catch (Throwable e) {
            // Throwable để cả Error (ví dụ OutOfMemoryError khi đọc audio lớn) cũng không làm phiên treo PROCESSING
            fail(sessionId, errorCodeOf(e), e);
        }
    }

    private void score(UUID sessionId) {
        ScoringInputView input = sessions.findScoringInput(sessionId)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy phiên để chấm"));
        byte[] audio = storage.get(input.getAudioKey());
        String transcript = stt.transcribe(sessionId, audio, mimeTypeOf(input.getAudioKey()));
        scoreTranscript(sessionId, input, transcript);
    }

    /**
     * Chạy nền việc chấm lại (UC5 6a) với transcript người dùng đã sửa: bỏ qua STT, tính lại Delivery rồi gọi LLM
     * một lần. Cùng cam kết như {@link #run}: không ném ra ngoài, mọi lỗi chốt phiên FAILED.
     */
    public void rescore(UUID sessionId, String transcript) {
        try {
            ScoringInputView input = sessions.findScoringInput(sessionId)
                    .orElseThrow(() -> new IllegalStateException("Không tìm thấy phiên để chấm lại"));
            scoreTranscript(sessionId, input, transcript);
        } catch (Throwable e) {
            fail(sessionId, errorCodeOf(e), e);
        }
    }

    private void scoreTranscript(UUID sessionId, ScoringInputView input, String transcript) {
        if (wordCount(transcript) < MIN_WORDS) {
            fail(sessionId, ANSWER_TOO_SHORT, null);
            return;
        }

        LlmRequest request = promptBuilder.build(sessionId, input.getQuestionType(), input.getQuestionContent(),
                input.getReferenceAnswer(), transcript);
        // Lượt kiểm lỗi kiến thức chạy song song với lượt chấm chính nên không cộng thêm thời gian chờ
        CompletableFuture<List<KnowledgeError>> check = startKnowledgeCheck(sessionId, input, request, transcript);
        LlmResult llm = llmScorer.score(request, transcript);
        List<KnowledgeError> errors = llmScorer.keepSupported(awaitKnowledgeCheck(sessionId, check), transcript);
        llm = llmScorer.penalize(llm, errors);
        if (llm.injectionSuspected()) {
            // Audit log (Q7): chỉ sessionId, không log transcript hay trích dẫn; vẫn chấm theo nội dung (AC-32)
            log.warn("injection_suspected sessionId={}", sessionId);
        }
        Double durationSec = input.getDurationSec() == null ? null : input.getDurationSec().doubleValue();
        Optional<DeliveryMetrics> metrics = delivery.calculate(transcript, durationSec);
        ScoreOutcome outcome = calculator.calculate(input.getQuestionType(), llm.criteria(), metrics, llm.offTopic());

        writer.save(new ScoredAnswer(sessionId, transcript, input.getQuestionType(), llm.criteria(), metrics, outcome,
                llm.offTopic(), llm.injectionSuspected(), llm.feedbackText(), llm.sampleAnswer(), llm.points(), errors));
        log.info("Chấm xong sessionId={}", sessionId);
    }

    // Chỉ chạy khi có ý đối chiếu (câu TECHNICAL có đáp án tham chiếu) và tính năng đang bật
    private CompletableFuture<List<KnowledgeError>> startKnowledgeCheck(UUID sessionId, ScoringInputView input,
            LlmRequest request, String transcript) {
        if (!knowledgeCheck.enabled() || request.referencePoints().isEmpty()) {
            return null;
        }
        return CompletableFuture.supplyAsync(() -> errorDetector.detect(sessionId, input.getQuestionContent(),
                request.referencePoints(), transcript), checkExecutor);
    }

    // Lượt kiểm lỗi chỉ bổ sung: lỗi, quá hạn hay bị ngắt đều bỏ qua (không lỗi nào bị trừ), không làm hỏng phiên chấm
    private List<KnowledgeError> awaitKnowledgeCheck(UUID sessionId, CompletableFuture<List<KnowledgeError>> check) {
        if (check == null) {
            return List.of();
        }
        try {
            return check.get(knowledgeCheck.timeout().toMillis() + CHECK_GRACE_MS, TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            check.cancel(true);
            log.warn("Bỏ qua kiểm lỗi kiến thức vì bị ngắt sessionId={}", sessionId);
        } catch (TimeoutException e) {
            check.cancel(true);
            log.warn("Bỏ qua kiểm lỗi kiến thức vì quá hạn sessionId={}", sessionId);
        } catch (ExecutionException e) {
            // Chỉ log loại lỗi, không log message (có thể chứa nội dung phản hồi)
            log.warn("Bỏ qua kiểm lỗi kiến thức vì lỗi sessionId={} loi={}", sessionId,
                    e.getCause() == null ? "?" : e.getCause().getClass().getSimpleName());
        }
        return List.of();
    }

    /** Đếm từ theo khoảng trắng; null hoặc rỗng là 0 từ. */
    static int wordCount(String transcript) {
        if (transcript == null || transcript.isBlank()) {
            return 0;
        }
        return transcript.trim().split("\\s+").length;
    }

    // Khóa lưu do server sinh, có đuôi theo MIME đã whitelist (audio/{userId}/{sessionId}/{uuid}.{ext})
    static String mimeTypeOf(String audioKey) {
        String ext = audioKey.substring(audioKey.lastIndexOf('.') + 1).toLowerCase(Locale.ROOT);
        return switch (ext) {
            case "webm" -> "audio/webm";
            case "ogg" -> "audio/ogg";
            case "mp3" -> "audio/mpeg";
            case "wav" -> "audio/wav";
            case "m4a", "mp4" -> "audio/mp4";
            default -> "application/octet-stream";
        };
    }

    private static String errorCodeOf(Throwable e) {
        if (e instanceof SttException || e instanceof AudioStorageException) {
            return STT_ERROR;
        }
        if (e instanceof LlmException llm) {
            return llm.getErrorCode();
        }
        // Tiêu chí/điểm từ kết quả LLM không tính được
        if (e instanceof IllegalArgumentException) {
            return LlmException.INVALID_RESULT;
        }
        return INTERNAL_ERROR;
    }

    private void fail(UUID sessionId, String errorCode, Throwable cause) {
        // Chỉ log mã lỗi và loại lỗi, không log message/stack (có thể chứa transcript hoặc khóa API)
        if (cause == null) {
            log.warn("Chấm thất bại sessionId={} errorCode={}", sessionId, errorCode);
        } else {
            log.error("Chấm thất bại sessionId={} errorCode={} loi={}", sessionId, errorCode,
                    cause.getClass().getSimpleName());
        }
        try {
            if (sessions.markFailed(sessionId, errorCode, clock.instant()) == 0) {
                log.warn("Phiên không còn PROCESSING nên giữ nguyên trạng thái sessionId={}", sessionId);
            }
        } catch (RuntimeException e) {
            log.error("Không ghi được trạng thái FAILED sessionId={} loi={}", sessionId, e.getClass().getSimpleName());
        }
    }
}
