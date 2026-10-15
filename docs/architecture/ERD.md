# ERD - Cơ sở dữ liệu (PostgreSQL)

Phiên bản: draft 0.2, theo `docs/business/Rubric_Cham_Diem.md` (rubric-v1.0) và chấm bất đồng bộ.
Sơ đồ dạng hình: `docs/diagrams/ERDDiagram.drawio.xml` (ảnh: `docs/diagrams/export/erd.png`). Chi tiết cột, ràng buộc, index: `Data_Dictionary.md`. DDL: `backend/src/main/resources/db/migration/V1__init.sql`.

```mermaid
erDiagram
    users ||..o{ practice_sessions : "user_id"
    questions ||..o{ practice_sessions : "question_id"
    practice_sessions ||..o| score_results : "session_id"
    score_results ||..o{ score_criteria : "result_id"
    practice_sessions ||..o{ api_usages : "session_id"
    users ||..o{ audit_logs : "admin_id"
    users ||..o{ questions : "created_by"
    users ||..o{ password_reset_tokens : "user_id"
    users {
        uuid id PK
        varchar full_name
        varchar email UK
        varchar password_hash
        varchar role
        varchar status
        integer failed_login_count
        timestamptz locked_until
        timestamptz created_at
    }
    questions {
        uuid id PK
        text content
        varchar industry
        varchar position
        varchar level
        varchar question_type
        text answer_hint
        text reference_answer
        varchar status
        uuid created_by FK
        timestamptz created_at
    }
    practice_sessions {
        uuid id PK
        uuid user_id FK
        uuid question_id FK
        varchar status
        varchar audio_key
        integer duration_sec
        numeric total_score
        text feedback
        varchar error_code
        timestamptz started_at
        timestamptz submitted_at
        timestamptz processing_started_at
        timestamptz completed_at
    }
    score_results {
        uuid id PK
        uuid session_id FK UK
        text transcript
        varchar question_type
        numeric total_score
        numeric content_score
        boolean off_topic
        boolean injection_suspected
        integer wpm
        integer filler_count
        numeric filler_rate
        numeric delivery_score
        text feedback_text
        text sample_answer
        varchar tts_audio_key
        varchar rubric_version
        varchar prompt_version
        varchar model_version
        varchar filler_list_version
        timestamptz created_at
    }
    score_criteria {
        uuid id PK
        uuid result_id FK
        varchar code
        smallint score
        smallint weight
        text reasoning
        text quote
        boolean quote_invalid
    }
    api_usages {
        uuid id PK
        uuid session_id FK
        varchar provider
        timestamptz called_at
        integer latency_ms
        numeric usage_unit
        numeric estimated_cost
    }
    audit_logs {
        uuid id PK
        uuid admin_id FK
        varchar action
        varchar entity_type
        uuid entity_id
        timestamptz created_at
    }
    password_reset_tokens {
        uuid id PK
        uuid user_id FK
        varchar token_hash UK
        timestamptz expires_at
        timestamptz used_at
        timestamptz created_at
    }
```

Ký hiệu: đường nét đứt là quan hệ không xác định (mọi bảng có khóa chính riêng `id`, khóa ngoại chỉ là cột thường); đầu cha `||` là đúng một, đầu con `o{` là không hoặc nhiều, `o|` là không hoặc một.

## Quyết định thiết kế

1. Điểm từng tiêu chí là bảng riêng `score_criteria` thay cho 4 cột S/T/A/R: mỗi loại câu hỏi có số tiêu chí khác nhau, thêm tiêu chí không cần đổi schema.
2. Cấu hình rubric (tiêu chí, trọng số, thông số Delivery) nằm trong code/cấu hình có phiên bản, không nằm trong DB; mỗi kết quả lưu các cột `*_version` để truy vết.
3. `score_results.question_type` được chụp lại tại thời điểm chấm để sửa loại câu hỏi sau này không làm lệch kết quả cũ.
4. `questions.reference_answer` chỉ ADMIN đọc/ghi, API dành cho candidate không trả về.
5. Khóa chính `uuid` theo OpenAPI; đã thống nhất lại trong Class Diagram.
6. Chấm bất đồng bộ: `practice_sessions` có `processing_started_at`, `error_code` để phát hiện job quá hạn và báo lỗi.
7. Quên mật khẩu: `password_reset_tokens` lưu bản băm SHA-256, dùng một lần (`used_at`).
8. Khóa tài khoản: `users.failed_login_count` và `users.locked_until` (tự mở khóa sau 15 phút).
