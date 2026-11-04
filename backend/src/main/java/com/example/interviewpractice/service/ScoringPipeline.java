package com.example.interviewpractice.service;

import java.time.Clock;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.example.interviewpractice.dto.ScoringInput;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.service.ai.LlmException;
import com.example.interviewpractice.service.ai.LlmRequest;
import com.example.interviewpractice.service.ai.LlmResult;
import com.example.interviewpractice.service.ai.LlmScorer;
import com.example.interviewpractice.service.ai.PromptBuilder;
import com.example.interviewpractice.service.ai.SttClient;
import com.example.interviewpractice.service.ai.SttException;
import com.example.interviewpractice.service.scoring.DeliveryMetrics;
import com.example.interviewpractice.service.scoring.DeliveryMetricsProvider;
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

    public ScoringPipeline(PracticeSessionRepository sessions, AudioStorage storage, SttClient stt,
            PromptBuilder promptBuilder, LlmScorer llmScorer, DeliveryMetricsProvider delivery,
            ScoreCalculator calculator, ScoreResultWriter writer, Clock clock) {
        this.sessions = sessions;
        this.storage = storage;
        this.stt = stt;
        this.promptBuilder = promptBuilder;
        this.llmScorer = llmScorer;
        this.delivery = delivery;
        this.calculator = calculator;
        this.writer = writer;
        this.clock = clock;
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
        ScoringInput input = sessions.findScoringInput(sessionId)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy phiên để chấm"));
        byte[] audio = storage.get(input.audioKey());
        String transcript = stt.transcribe(sessionId, audio, mimeTypeOf(input.audioKey()));

        if (wordCount(transcript) < MIN_WORDS) {
            fail(sessionId, ANSWER_TOO_SHORT, null);
            return;
        }

        LlmRequest request = promptBuilder.build(sessionId, input.questionType(), input.questionContent(),
                input.referenceAnswer(), transcript);
        LlmResult llm = llmScorer.score(request, transcript);
        if (llm.injectionSuspected()) {
            // Audit log (Q7): chỉ sessionId, không log transcript hay trích dẫn; vẫn chấm theo nội dung (AC-32)
            log.warn("injection_suspected sessionId={}", sessionId);
        }
        Double durationSec = input.durationSec() == null ? null : input.durationSec().doubleValue();
        Optional<DeliveryMetrics> metrics = delivery.calculate(transcript, durationSec);
        ScoreOutcome outcome = calculator.calculate(input.questionType(), llm.criteria(), metrics, llm.offTopic());

        writer.save(new ScoredAnswer(sessionId, transcript, input.questionType(), llm.criteria(), metrics, outcome,
                llm.offTopic(), llm.injectionSuspected(), llm.feedbackText(), llm.sampleAnswer()));
        log.info("Chấm xong sessionId={}", sessionId);
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
