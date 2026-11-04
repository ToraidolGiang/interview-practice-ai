package com.example.interviewpractice.service.ai;

/** Văn bản JSON thô do LLM trả về, chưa kiểm schema. Chứa nội dung chấm nên không đưa vào log. */
public record LlmRawResult(String json) {

    @Override
    public String toString() {
        return "LlmRawResult[json=<ẩn>]";
    }
}
