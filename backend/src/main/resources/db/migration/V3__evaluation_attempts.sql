-- Mỗi lượt chấm thật (evaluate, retry, rescore) một dòng, để tính hạn mức chấm theo ngày (F4).
-- Tách khỏi api_usages vì bảng đó ghi theo từng lần gọi HTTP (có retry) và do worker nền ghi bất đồng bộ.
CREATE TABLE evaluation_attempts (
    id uuid PRIMARY KEY,
    user_id uuid NOT NULL,
    session_id uuid,
    started_at timestamptz NOT NULL,
    CONSTRAINT fk_evaluation_attempts_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_evaluation_attempts_session_id FOREIGN KEY (session_id) REFERENCES practice_sessions(id) ON DELETE SET NULL
);
CREATE INDEX idx_evaluation_attempts_user_started ON evaluation_attempts (user_id, started_at);
