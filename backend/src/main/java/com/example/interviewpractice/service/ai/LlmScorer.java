package com.example.interviewpractice.service.ai;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.example.interviewpractice.entity.ScoreCriterion.Code;
import com.example.interviewpractice.entity.ScorePoint.Verdict;
import com.example.interviewpractice.service.scoring.CorrectnessCalculator;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.KnowledgeError;
import com.example.interviewpractice.service.scoring.PointScore;
import com.example.interviewpractice.service.scoring.QuoteValidator;

/**
 * Gọi LLM rồi kiểm schema và trích dẫn; lỗi gọi, timeout, kết quả sai schema hoặc hơn một nửa tiêu chí có trích dẫn
 * không hợp lệ đều được thử lại đúng 1 lần (tối đa 2 lần gọi LLM mỗi lần chấm, AC-21/27/36). Đúng một nửa thì không
 * thử lại. Hết lượt thì ném {@link LlmException} với LLM_ERROR hoặc INVALID_RESULT theo lỗi của lần cuối.
 * Tiêu chí có trích dẫn sai (nhưng chưa quá nửa) bị hạ về 2 và gắn quoteInvalid.
 * Khi có đối chiếu theo ý: ý được khen (COVERED/PARTIAL) mà trích dẫn không có trong transcript bị hạ một bậc và
 * gắn quoteInvalid; điểm CORRECTNESS do server tính từ các ý, điểm LLM tự cho tiêu chí này bị bỏ.
 */
@Component
public class LlmScorer {

    private final LlmClient client;
    private final LlmResultValidator validator;
    private final QuoteValidator quoteValidator;
    private final CorrectnessCalculator correctness;

    public LlmScorer(LlmClient client, LlmResultValidator validator, QuoteValidator quoteValidator,
            CorrectnessCalculator correctness) {
        this.client = client;
        this.validator = validator;
        this.quoteValidator = quoteValidator;
        this.correctness = correctness;
    }

    /** @param transcript transcript dùng để chấm, làm gốc đối chiếu trích dẫn */
    public LlmResult score(LlmRequest request, String transcript) {
        try {
            return OneRetry.call(() -> scoreOnce(request, transcript));
        } catch (LlmException e) {
            throw e;
        } catch (RuntimeException e) {
            throw new LlmException(LlmException.LLM_ERROR, "Chấm điểm bằng LLM thất bại", e);
        }
    }

    private LlmResult scoreOnce(LlmRequest request, String transcript) {
        LlmResult parsed = validator.validate(client.score(request), request.questionType(),
                request.referencePoints());
        List<PointScore> points = checkPoints(parsed.points(), transcript);
        List<CriterionScore> criteria = applyCorrectness(parsed.criteria(), points, 0);
        QuoteValidator.Checked checked = quoteValidator.check(criteria, transcript);
        if (checked.moreThanHalfInvalid()) {
            throw new LlmException(LlmException.INVALID_RESULT, "Quá nửa trích dẫn không có trong transcript");
        }
        return new LlmResult(parsed.offTopic(), parsed.injectionSuspected(), checked.criteria(),
                parsed.feedbackText(), parsed.sampleAnswer(), points);
    }

    /**
     * Giữ lại các lỗi kiến thức có trích dẫn nằm trong transcript (lỗi có trích dẫn bịa bị bỏ, không trừ điểm oan),
     * đánh số lại từ 1.
     */
    public List<KnowledgeError> keepSupported(List<KnowledgeError> errors, String transcript) {
        List<KnowledgeError> kept = new ArrayList<>();
        for (KnowledgeError e : errors) {
            if (quoteValidator.isSupported(e.quote(), transcript)) {
                kept.add(new KnowledgeError(kept.size() + 1, e.quote(), e.explanation()));
            }
        }
        return List.copyOf(kept);
    }

    /**
     * Tính lại điểm CORRECTNESS có trừ lỗi kiến thức. Không có ý đối chiếu hoặc không có lỗi thì giữ nguyên kết quả
     * (không có ý thì CORRECTNESS là điểm LLM tự cho, không có cơ sở để trừ).
     */
    public LlmResult penalize(LlmResult result, List<KnowledgeError> errors) {
        if (errors.isEmpty() || result.points().isEmpty()) {
            return result;
        }
        List<CriterionScore> criteria = applyCorrectness(result.criteria(), result.points(), errors.size());
        return new LlmResult(result.offTopic(), result.injectionSuspected(), criteria, result.feedbackText(),
                result.sampleAnswer(), result.points());
    }

    // Khen một ý mà không chỉ ra được đoạn có thật trong transcript thì hạ một bậc: COVERED -> PARTIAL -> MISSING
    private List<PointScore> checkPoints(List<PointScore> points, String transcript) {
        List<PointScore> result = new ArrayList<>(points.size());
        for (PointScore p : points) {
            boolean praised = p.verdict() == Verdict.COVERED || p.verdict() == Verdict.PARTIAL;
            if (praised && !quoteValidator.isSupported(p.quote(), transcript)) {
                Verdict lowered = p.verdict() == Verdict.COVERED ? Verdict.PARTIAL : Verdict.MISSING;
                result.add(new PointScore(p.position(), p.pointText(), lowered, p.quote(), p.note(), true));
            } else {
                result.add(p);
            }
        }
        return List.copyOf(result);
    }

    // Điểm CORRECTNESS lấy từ các ý; trích dẫn của tiêu chí là trích dẫn hợp lệ đầu tiên của ý được khen
    private List<CriterionScore> applyCorrectness(List<CriterionScore> criteria, List<PointScore> points,
            int errorCount) {
        if (points.isEmpty()) {
            return criteria;
        }
        int score = correctness.score(points, errorCount);
        String quote = points.stream()
                .filter(p -> !p.quoteInvalid() && (p.verdict() == Verdict.COVERED || p.verdict() == Verdict.PARTIAL))
                .map(PointScore::quote)
                .findFirst()
                .orElse(null);
        return criteria.stream()
                .map(c -> c.code() == Code.CORRECTNESS
                        ? new CriterionScore(c.code(), score, c.reasoning(), quote, false)
                        : c)
                .toList();
    }
}
