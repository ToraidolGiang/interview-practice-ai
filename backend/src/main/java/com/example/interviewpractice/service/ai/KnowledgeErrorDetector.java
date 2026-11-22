package com.example.interviewpractice.service.ai;

import java.util.List;
import java.util.UUID;

import com.example.interviewpractice.service.scoring.KnowledgeError;

/**
 * Port của lượt kiểm lỗi kiến thức: tìm các phát biểu SAI về chuyên môn trong câu trả lời (khác với đối chiếu ý, vốn
 * chỉ kiểm câu trả lời có nhắc đến ý đó hay chưa). Adapter hiện tại dùng Gemini; về sau có thể thay bằng truy xuất
 * tri thức (RAG) mà không đổi bên gọi.
 */
public interface KnowledgeErrorDetector {

    /**
     * @param referencePoints các ý chuẩn của đáp án tham chiếu, dùng làm gợi ý kiến thức
     * @return các phát biểu sai kèm trích dẫn thí sinh nói và điều đúng; chưa kiểm trích dẫn có trong transcript
     * @throws LlmException khi gọi hoặc phân tích kết quả lỗi (bên gọi coi lượt này là bổ sung, không bắt buộc)
     */
    List<KnowledgeError> detect(UUID sessionId, String question, List<String> referencePoints, String transcript);
}
