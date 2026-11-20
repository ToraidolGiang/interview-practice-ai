package com.example.interviewpractice.service.ai;

/** Cổng gọi LLM chấm điểm; test thay bằng mock. Việc thử lại do {@link LlmScorer} quyết định, không phải client. */
public interface LlmClient {

    /**
     * Gọi LLM đúng một lần.
     *
     * @throws LlmException (LLM_ERROR) khi gọi lỗi, timeout hoặc phản hồi không có nội dung
     */
    LlmRawResult score(LlmRequest request);
}
