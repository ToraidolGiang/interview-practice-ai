-- Đối chiếu theo ý (Giai đoạn 1 của Huong_Mo_Rong.md): mỗi ý của đáp án tham chiếu một dòng kết quả.
-- point_text lưu bản chụp tại thời điểm chấm để kết quả không đổi khi reference_answer bị sửa sau này.
CREATE TABLE score_points (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    result_id uuid NOT NULL,
    position smallint NOT NULL,
    point_text text NOT NULL,
    verdict varchar(10) NOT NULL,
    quote text,
    quote_invalid boolean NOT NULL DEFAULT false,
    note text,
    CONSTRAINT fk_score_points_result_id FOREIGN KEY (result_id) REFERENCES score_results(id) ON DELETE CASCADE,
    CONSTRAINT ck_score_points_verdict CHECK (verdict IN ('COVERED','PARTIAL','MISSING','INCORRECT')),
    CONSTRAINT ck_score_points_position CHECK (position >= 1)
);
CREATE UNIQUE INDEX uq_score_points_result_position ON score_points (result_id, position);
