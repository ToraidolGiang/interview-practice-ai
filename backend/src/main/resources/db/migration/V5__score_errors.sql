-- Phát biểu sai về chuyên môn trong câu trả lời (lượt kiểm lỗi kiến thức, chỉ câu TECHNICAL có đáp án tham chiếu).
-- Chỉ lưu lỗi có trích dẫn nằm trong transcript; mỗi lỗi hợp lệ trừ vào điểm CORRECTNESS.
CREATE TABLE score_errors (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    result_id uuid NOT NULL,
    position smallint NOT NULL,
    quote text NOT NULL,
    explanation text NOT NULL,
    CONSTRAINT fk_score_errors_result_id FOREIGN KEY (result_id) REFERENCES score_results(id) ON DELETE CASCADE,
    CONSTRAINT ck_score_errors_position CHECK (position >= 1)
);
CREATE UNIQUE INDEX uq_score_errors_result_position ON score_errors (result_id, position);
