# Từ điển dữ liệu

- Hệ quản trị: PostgreSQL 13 trở lên (dùng `gen_random_uuid()`), quản lý schema bằng Flyway (`backend/src/main/resources/db/migration/V1__init.sql`).
- Tài liệu này và `V1__init.sql`, `ERD.md`, `ERDDiagram.drawio.xml` được sinh từ cùng một định nghĩa schema nên không lệch nhau.
- Quy ước: tên bảng và cột `snake_case`; khóa chính `uuid`; thời gian `timestamptz`; giá trị liệt kê lưu `varchar` kèm `CHECK` (không dùng kiểu enum của PostgreSQL để dễ migration).

## Quy tắc chung

- **Xóa mềm:** câu hỏi không bị xóa cứng khi đã có trong lịch sử; chuyển `questions.status = 'HIDDEN'`. Vì vậy mọi khóa ngoại tới `questions`, `users` dùng `ON DELETE RESTRICT`.
- **Xóa theo phiên:** `score_results`, `score_criteria`, `api_usages` thuộc về một phiên nên dùng `ON DELETE CASCADE`.
- **Một kết quả mới nhất mỗi phiên:** `score_results.session_id` là duy nhất. Chấm lại sau khi sửa transcript ghi đè kết quả cũ (bản cũ chỉ lưu trong `audit_logs` nếu cần).
- **Truy vết chấm điểm:** mỗi kết quả lưu `rubric_version`, `prompt_version`, `model_version`, `filler_list_version`; đổi phiên bản không tính lại kết quả cũ.
- **Lưu trữ audio:** chỉ lưu khóa S3 (`audio_key`, `tts_audio_key`), API trả URL ký sẵn có hạn. Audio ghi âm được dọn sau 6 tháng bằng S3 lifecycle, đồng thời đặt `audio_key = NULL`.
- **Chấm bất đồng bộ:** `practice_sessions.status = 'PROCESSING'` kèm `processing_started_at`; khi khởi động lại, phiên PROCESSING quá hạn được đặt `FAILED` với `error_code = 'SERVER_RESTART'` (dùng `idx_sessions_processing`).

## Quyết định đã chốt

- `users.locked_until`: tài khoản bị khóa sau 5 lần sai tự mở khóa sau 15 phút.
- `password_reset_tokens.expires_at`: token đặt lại mật khẩu có hạn 30 phút, dùng một lần.
- Nơi lưu trữ: PostgreSQL managed của Render (cùng nền tảng với backend), kết nối qua `DATABASE_URL`. Gói miễn phí có thời hạn nên cần nâng gói hoặc chuyển sang nhà cung cấp khác trước khi bảo vệ cuối kỳ.

## `users`

Tài khoản người dùng (CANDIDATE) và quản trị viên (ADMIN).

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `full_name` | varchar(100) | không |  |  | Họ tên hiển thị |
| `email` | varchar(255) | không |  | UNIQUE (lower(email)) | Email đăng nhập, không phân biệt hoa thường |
| `password_hash` | varchar(100) | không |  |  | Mật khẩu băm BCrypt |
| `role` | varchar(20) | không | `'CANDIDATE'` | CHECK role IN ('CANDIDATE','ADMIN') | Vai trò (RBAC) |
| `status` | varchar(20) | không | `'ACTIVE'` | CHECK status IN ('ACTIVE','LOCKED') | Trạng thái tài khoản |
| `failed_login_count` | integer | không | `0` | CHECK failed_login_count >= 0 | Số lần đăng nhập sai liên tiếp; đủ 5 thì khóa |
| `locked_until` | timestamptz | có |  |  | Thời điểm tự mở khóa (15 phút sau khi bị khóa) |
| `created_at` | timestamptz | không | `now()` |  | Thời điểm tạo |

Index và ràng buộc duy nhất:

- Duy nhất `uq_users_email`: `(lower(email))`

## `questions`

Ngân hàng câu hỏi phỏng vấn (xóa mềm bằng status = HIDDEN).

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `content` | text | không |  |  | Nội dung câu hỏi |
| `industry` | varchar(100) | không |  |  | Ngành nghề |
| `position` | varchar(100) | không |  |  | Vị trí ứng tuyển |
| `level` | varchar(10) | không |  | CHECK level IN ('EASY','MEDIUM','HARD') | Độ khó |
| `question_type` | varchar(20) | không |  | CHECK question_type IN ('BEHAVIORAL','SITUATIONAL','TECHNICAL','INTRO') | Loại câu hỏi, quyết định rubric chấm điểm |
| `answer_hint` | text | có |  |  | Gợi ý cách trả lời hiển thị cho người luyện tập (thay cho star_hint) |
| `reference_answer` | text | có |  |  | Các ý chính cần có (câu TECHNICAL); chỉ ADMIN xem, không trả về cho candidate |
| `status` | varchar(10) | không | `'ACTIVE'` | CHECK status IN ('ACTIVE','HIDDEN') | ACTIVE hiển thị; HIDDEN là xóa mềm |
| `created_by` | uuid | không |  | FK → users(id) ON DELETE RESTRICT | Admin tạo câu hỏi |
| `created_at` | timestamptz | không | `now()` |  | Thời điểm tạo |

Index và ràng buộc duy nhất:

- Duy nhất `uq_questions_position_content`: `(position, md5(content))`
- Index `idx_questions_filter`: `(status, industry, position, level)`

## `practice_sessions`

Một lượt luyện tập: câu hỏi, audio, trạng thái xử lý.

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `user_id` | uuid | không |  | FK → users(id) ON DELETE RESTRICT | Người luyện tập |
| `question_id` | uuid | không |  | FK → questions(id) ON DELETE RESTRICT | Câu hỏi được chọn |
| `status` | varchar(20) | không | `'CREATED'` | CHECK status IN ('CREATED','UPLOADED','PROCESSING','SCORED','FAILED') | Trạng thái phiên |
| `audio_key` | varchar(255) | có |  |  | Khóa đối tượng S3 của file ghi âm (API trả URL ký sẵn) |
| `duration_sec` | integer | có |  | CHECK duration_sec >= 0 | Thời lượng ghi âm (giây) |
| `total_score` | numeric(5,2) | có |  | CHECK total_score BETWEEN 0 AND 100 | Điểm tổng (sao chép từ score_results để lọc/sắp xếp lịch sử) |
| `feedback` | text | có |  |  | Nhận xét tóm tắt hiển thị ở danh sách lịch sử |
| `error_code` | varchar(40) | có |  |  | Mã lỗi khi FAILED (STT_ERROR, LLM_ERROR, INVALID_RESULT, SERVER_RESTART) |
| `started_at` | timestamptz | không | `now()` |  | Thời điểm tạo phiên |
| `submitted_at` | timestamptz | có |  |  | Thời điểm nộp audio |
| `processing_started_at` | timestamptz | có |  |  | Thời điểm worker bắt đầu chấm (phát hiện job quá hạn) |
| `completed_at` | timestamptz | có |  |  | Thời điểm SCORED hoặc FAILED |

Index và ràng buộc duy nhất:

- Index `idx_sessions_user_started`: `(user_id, started_at DESC)`
- Index `idx_sessions_question`: `(question_id)`
- Index `idx_sessions_processing`: `(processing_started_at WHERE status = 'PROCESSING')`

## `score_results`

Kết quả chấm điểm của một phiên (tối đa 1 kết quả mới nhất mỗi phiên).

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `session_id` | uuid | không |  | FK → practice_sessions(id) ON DELETE CASCADE; UNIQUE (session_id) | Phiên luyện tập |
| `transcript` | text | không |  |  | Bản chép lời dùng để chấm (có thể đã được người dùng sửa) |
| `question_type` | varchar(20) | không |  | CHECK question_type IN ('BEHAVIORAL','SITUATIONAL','TECHNICAL','INTRO') | Loại câu hỏi tại thời điểm chấm |
| `total_score` | numeric(5,2) | không |  | CHECK total_score BETWEEN 0 AND 100 | Điểm tổng 0-100, do server tính |
| `content_score` | numeric(5,2) | không |  | CHECK content_score BETWEEN 0 AND 100 | Điểm nội dung 0-100 (không gồm Delivery) |
| `off_topic` | boolean | không | `false` |  | Lạc đề; tổng điểm tối đa 30 |
| `injection_suspected` | boolean | không | `false` |  | Transcript có dấu hiệu thao túng điểm |
| `wpm` | integer | có |  | CHECK wpm >= 0 | Tốc độ nói (từ/phút); null nếu không đủ dữ liệu Delivery |
| `filler_count` | integer | có |  | CHECK filler_count >= 0 | Số từ đệm |
| `filler_rate` | numeric(5,2) | có |  |  | Số từ đệm trên 100 từ |
| `delivery_score` | numeric(3,2) | có |  | CHECK delivery_score BETWEEN 1 AND 5 | Điểm Delivery 1-5 |
| `feedback_text` | text | không |  |  | Nhận xét và gợi ý cải thiện |
| `sample_answer` | text | có |  |  | Câu trả lời mẫu |
| `tts_audio_key` | varchar(255) | có |  |  | Khóa S3 của audio TTS đọc phản hồi (API trả URL ký sẵn) |
| `rubric_version` | varchar(20) | không |  |  | Phiên bản rubric, ví dụ rubric-v1.0 |
| `prompt_version` | varchar(20) | không |  |  | Phiên bản prompt |
| `model_version` | varchar(50) | không |  |  | Mô hình LLM đã dùng |
| `filler_list_version` | varchar(20) | có |  |  | Phiên bản danh sách từ đệm |
| `created_at` | timestamptz | không | `now()` |  | Thời điểm chấm |

Index và ràng buộc duy nhất:

- Duy nhất `uq_score_results_session`: `(session_id)`

## `score_criteria`

Điểm từng tiêu chí của rubric trong một kết quả.

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `result_id` | uuid | không |  | FK → score_results(id) ON DELETE CASCADE | Kết quả chấm |
| `code` | varchar(20) | không |  | CHECK code IN ('RELEVANCE','STRUCTURE','DEPTH','CORRECTNESS') | Mã tiêu chí |
| `score` | smallint | không |  | CHECK score BETWEEN 1 AND 5 | Điểm tiêu chí 1-5 |
| `weight` | smallint | không |  | CHECK weight BETWEEN 0 AND 100 | Trọng số của tiêu chí trong điểm tổng |
| `reasoning` | text | không |  |  | Lý do chấm |
| `quote` | text | có |  |  | Trích dẫn nguyên văn từ transcript làm bằng chứng |
| `quote_invalid` | boolean | không | `false` |  | Trích dẫn không khớp transcript, điểm đã bị hạ |

Index và ràng buộc duy nhất:

- Duy nhất `uq_score_criteria_result_code`: `(result_id, code)`

## `api_usages`

Nhật ký gọi dịch vụ AI để thống kê độ trễ và chi phí.

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `session_id` | uuid | không |  | FK → practice_sessions(id) ON DELETE CASCADE | Phiên luyện tập |
| `provider` | varchar(10) | không |  | CHECK provider IN ('STT','LLM','TTS') | Loại dịch vụ |
| `called_at` | timestamptz | không | `now()` |  | Thời điểm gọi |
| `latency_ms` | integer | không |  | CHECK latency_ms >= 0 | Độ trễ (ms) |
| `usage_unit` | numeric(12,4) | có |  |  | Đơn vị sử dụng (giây audio, token, ký tự) |
| `estimated_cost` | numeric(12,6) | có |  |  | Chi phí ước tính |

Index và ràng buộc duy nhất:

- Index `idx_api_usages_called`: `(called_at, provider)`
- Index `idx_api_usages_session`: `(session_id)`

## `audit_logs`

Nhật ký thao tác quản trị (thêm/sửa/xóa câu hỏi).

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `admin_id` | uuid | không |  | FK → users(id) ON DELETE RESTRICT | Admin thực hiện |
| `action` | varchar(50) | không |  |  | CREATE, UPDATE, DELETE |
| `entity_type` | varchar(50) | không |  |  | Loại đối tượng, ví dụ QUESTION |
| `entity_id` | uuid | có |  |  | Id đối tượng bị tác động |
| `created_at` | timestamptz | không | `now()` |  | Thời điểm thực hiện |

Index và ràng buộc duy nhất:

- Index `idx_audit_created`: `(created_at DESC)`

## `password_reset_tokens`

Token đặt lại mật khẩu (dùng một lần, chỉ lưu bản băm).

| Cột | Kiểu | Null | Mặc định | Ràng buộc | Mô tả |
|---|---|---|---|---|---|
| `id` | uuid | không | `gen_random_uuid()` | PK | Khóa chính |
| `user_id` | uuid | không |  | FK → users(id) ON DELETE CASCADE | Người dùng yêu cầu đặt lại |
| `token_hash` | varchar(64) | không |  | UNIQUE (token_hash) | SHA-256 (hex) của token gửi qua email |
| `expires_at` | timestamptz | không |  |  | Thời điểm hết hạn (30 phút sau khi tạo) |
| `used_at` | timestamptz | có |  |  | Thời điểm đã dùng; null nếu chưa dùng |
| `created_at` | timestamptz | không | `now()` |  | Thời điểm tạo |

Index và ràng buộc duy nhất:

- Duy nhất `uq_reset_token_hash`: `(token_hash)`
- Index `idx_reset_user`: `(user_id)`
