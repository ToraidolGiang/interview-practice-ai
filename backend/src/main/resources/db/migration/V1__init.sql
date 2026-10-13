-- Flyway migration V1: lược đồ ban đầu (PostgreSQL 13+).
-- Sinh từ schema duy nhất của đồ án; khớp docs/architecture/ERD.md và Data_Dictionary.md.
-- Hibernate chỉ validate schema (spring.jpa.hibernate.ddl-auto=validate), không tự tạo bảng.

-- Tài khoản người dùng (CANDIDATE) và quản trị viên (ADMIN)
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name varchar(100) NOT NULL,
    email varchar(255) NOT NULL,
    password_hash varchar(100) NOT NULL,
    role varchar(20) NOT NULL DEFAULT 'CANDIDATE',
    status varchar(20) NOT NULL DEFAULT 'ACTIVE',
    failed_login_count integer NOT NULL DEFAULT 0,
    locked_until timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_users_role CHECK (role IN ('CANDIDATE','ADMIN')),
    CONSTRAINT ck_users_status CHECK (status IN ('ACTIVE','LOCKED')),
    CONSTRAINT ck_users_failed_login_count CHECK (failed_login_count >= 0)
);
CREATE UNIQUE INDEX uq_users_email ON users (lower(email));

-- Ngân hàng câu hỏi phỏng vấn (xóa mềm bằng status = HIDDEN)
CREATE TABLE questions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    content text NOT NULL,
    industry varchar(100) NOT NULL,
    position varchar(100) NOT NULL,
    level varchar(10) NOT NULL,
    question_type varchar(20) NOT NULL,
    answer_hint text,
    reference_answer text,
    status varchar(10) NOT NULL DEFAULT 'ACTIVE',
    created_by uuid NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_questions_level CHECK (level IN ('EASY','MEDIUM','HARD')),
    CONSTRAINT ck_questions_question_type CHECK (question_type IN ('BEHAVIORAL','SITUATIONAL','TECHNICAL','INTRO')),
    CONSTRAINT ck_questions_status CHECK (status IN ('ACTIVE','HIDDEN')),
    CONSTRAINT fk_questions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT
);
CREATE UNIQUE INDEX uq_questions_position_content ON questions (position, md5(content));
CREATE INDEX idx_questions_filter ON questions (status, industry, position, level);

-- Một lượt luyện tập: câu hỏi, audio, trạng thái xử lý
CREATE TABLE practice_sessions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    question_id uuid NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'CREATED',
    audio_key varchar(255),
    duration_sec integer,
    total_score numeric(5,2),
    feedback text,
    error_code varchar(40),
    started_at timestamptz NOT NULL DEFAULT now(),
    submitted_at timestamptz,
    processing_started_at timestamptz,
    completed_at timestamptz,
    CONSTRAINT fk_practice_sessions_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_practice_sessions_question_id FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE RESTRICT,
    CONSTRAINT ck_practice_sessions_status CHECK (status IN ('CREATED','UPLOADED','PROCESSING','SCORED','FAILED')),
    CONSTRAINT ck_practice_sessions_duration_sec CHECK (duration_sec >= 0),
    CONSTRAINT ck_practice_sessions_total_score CHECK (total_score BETWEEN 0 AND 100)
);
CREATE INDEX idx_sessions_user_started ON practice_sessions (user_id, started_at DESC);
CREATE INDEX idx_sessions_question ON practice_sessions (question_id);
CREATE INDEX idx_sessions_processing ON practice_sessions (processing_started_at) WHERE status = 'PROCESSING';

-- Kết quả chấm điểm của một phiên (tối đa 1 kết quả mới nhất mỗi phiên)
CREATE TABLE score_results (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id uuid NOT NULL,
    transcript text NOT NULL,
    question_type varchar(20) NOT NULL,
    total_score numeric(5,2) NOT NULL,
    content_score numeric(5,2) NOT NULL,
    off_topic boolean NOT NULL DEFAULT false,
    injection_suspected boolean NOT NULL DEFAULT false,
    wpm integer,
    filler_count integer,
    filler_rate numeric(5,2),
    delivery_score numeric(3,2),
    feedback_text text NOT NULL,
    sample_answer text,
    tts_audio_key varchar(255),
    rubric_version varchar(20) NOT NULL,
    prompt_version varchar(20) NOT NULL,
    model_version varchar(50) NOT NULL,
    filler_list_version varchar(20),
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_score_results_session_id FOREIGN KEY (session_id) REFERENCES practice_sessions(id) ON DELETE CASCADE,
    CONSTRAINT ck_score_results_question_type CHECK (question_type IN ('BEHAVIORAL','SITUATIONAL','TECHNICAL','INTRO')),
    CONSTRAINT ck_score_results_total_score CHECK (total_score BETWEEN 0 AND 100),
    CONSTRAINT ck_score_results_content_score CHECK (content_score BETWEEN 0 AND 100),
    CONSTRAINT ck_score_results_wpm CHECK (wpm >= 0),
    CONSTRAINT ck_score_results_filler_count CHECK (filler_count >= 0),
    CONSTRAINT ck_score_results_delivery_score CHECK (delivery_score BETWEEN 1 AND 5)
);
CREATE UNIQUE INDEX uq_score_results_session ON score_results (session_id);

-- Điểm từng tiêu chí của rubric trong một kết quả
CREATE TABLE score_criteria (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    result_id uuid NOT NULL,
    code varchar(20) NOT NULL,
    score smallint NOT NULL,
    weight smallint NOT NULL,
    reasoning text NOT NULL,
    quote text,
    quote_invalid boolean NOT NULL DEFAULT false,
    CONSTRAINT fk_score_criteria_result_id FOREIGN KEY (result_id) REFERENCES score_results(id) ON DELETE CASCADE,
    CONSTRAINT ck_score_criteria_code CHECK (code IN ('RELEVANCE','STRUCTURE','DEPTH','CORRECTNESS')),
    CONSTRAINT ck_score_criteria_score CHECK (score BETWEEN 1 AND 5),
    CONSTRAINT ck_score_criteria_weight CHECK (weight BETWEEN 0 AND 100)
);
CREATE UNIQUE INDEX uq_score_criteria_result_code ON score_criteria (result_id, code);

-- Nhật ký gọi dịch vụ AI để thống kê độ trễ và chi phí
CREATE TABLE api_usages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id uuid NOT NULL,
    provider varchar(10) NOT NULL,
    called_at timestamptz NOT NULL DEFAULT now(),
    latency_ms integer NOT NULL,
    usage_unit numeric(12,4),
    estimated_cost numeric(12,6),
    CONSTRAINT fk_api_usages_session_id FOREIGN KEY (session_id) REFERENCES practice_sessions(id) ON DELETE CASCADE,
    CONSTRAINT ck_api_usages_provider CHECK (provider IN ('STT','LLM','TTS')),
    CONSTRAINT ck_api_usages_latency_ms CHECK (latency_ms >= 0)
);
CREATE INDEX idx_api_usages_called ON api_usages (called_at, provider);
CREATE INDEX idx_api_usages_session ON api_usages (session_id);

-- Nhật ký thao tác quản trị (thêm/sửa/xóa câu hỏi)
CREATE TABLE audit_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id uuid NOT NULL,
    action varchar(50) NOT NULL,
    entity_type varchar(50) NOT NULL,
    entity_id uuid,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_audit_logs_admin_id FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE RESTRICT
);
CREATE INDEX idx_audit_created ON audit_logs (created_at DESC);

-- Token đặt lại mật khẩu (dùng một lần, chỉ lưu bản băm)
CREATE TABLE password_reset_tokens (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    token_hash varchar(64) NOT NULL,
    expires_at timestamptz NOT NULL,
    used_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT fk_password_reset_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX uq_reset_token_hash ON password_reset_tokens (token_hash);
CREATE INDEX idx_reset_user ON password_reset_tokens (user_id);
