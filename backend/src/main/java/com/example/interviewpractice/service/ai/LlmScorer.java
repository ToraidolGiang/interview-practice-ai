package com.example.interviewpractice.service.ai;

import org.springframework.stereotype.Component;

import com.example.interviewpractice.service.scoring.QuoteValidator;

/**
 * Gọi LLM rồi kiểm schema và trích dẫn; lỗi gọi, timeout, kết quả sai schema hoặc hơn một nửa tiêu chí có trích dẫn
 * không hợp lệ đều được thử lại đúng 1 lần (tối đa 2 lần gọi LLM mỗi lần chấm, AC-21/27/36). Đúng một nửa thì không
 * thử lại. Hết lượt thì ném {@link LlmException} với LLM_ERROR hoặc INVALID_RESULT theo lỗi của lần cuối.
 * Tiêu chí có trích dẫn sai (nhưng chưa quá nửa) bị hạ về 2 và gắn quoteInvalid.
 */
@Component
public class LlmScorer {

    private final LlmClient client;
    private final LlmResultValidator validator;
    private final QuoteValidator quoteValidator;

    public LlmScorer(LlmClient client, LlmResultValidator validator, QuoteValidator quoteValidator) {
        this.client = client;
        this.validator = validator;
        this.quoteValidator = quoteValidator;
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
        LlmResult parsed = validator.validate(client.score(request), request.questionType());
        QuoteValidator.Checked checked = quoteValidator.check(parsed.criteria(), transcript);
        if (checked.moreThanHalfInvalid()) {
            throw new LlmException(LlmException.INVALID_RESULT, "Quá nửa trích dẫn không có trong transcript");
        }
        return new LlmResult(parsed.offTopic(), parsed.injectionSuspected(), checked.criteria(),
                parsed.feedbackText(), parsed.sampleAnswer());
    }
}
