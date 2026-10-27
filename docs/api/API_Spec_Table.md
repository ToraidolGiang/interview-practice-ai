# Bảng đặc tả API

Sinh tự động từ `docs/api/openapi.yaml` (phiên bản 0.2.0); không sửa tay file này, hãy sửa OpenAPI rồi sinh lại.

## Quy ước chung

- **Base path:** `/api` (domain chốt khi triển khai trên Render). Dữ liệu JSON, UTF-8; riêng nộp audio dùng `multipart/form-data`.
- **Xác thực:** header `Authorization: Bearer <JWT>` (hạn 24 giờ). Server nạp lại `status` và `role` từ CSDL mỗi request nên tài khoản bị khóa/xóa bị từ chối 401 ngay và đổi role có hiệu lực ngay. Endpoint `Công khai` không cần token; `/admin/**` yêu cầu role ADMIN.
- **Lỗi:** mọi lỗi trả `ErrorResponse {code, message, timestamp, fieldErrors?}`. 401 thiếu/sai token, 403 không đủ quyền hoặc không phải chủ sở hữu, 404 không tìm thấy, 409 xung đột trạng thái.
- **Phân trang:** query `page` (từ 0) và `size` (1-100, mặc định 20); phản hồi gồm `content`, `page`, `size`, `totalElements`, `totalPages`.
- **Chấm điểm bất đồng bộ:** `POST /practice-sessions/{id}/evaluate` trả **202** và chuyển phiên sang `PROCESSING`. Client polling `GET /practice-sessions/{id}` (đề xuất mỗi 2 giây) tới `SCORED` hoặc `FAILED` (kèm `errorCode`), rồi `GET /practice-sessions/{id}/result`. Chấm lại bằng `POST /practice-sessions/{id}/rescore` (transcript đã sửa, không gọi lại STT).

Trạng thái phiên: `CREATED` → `UPLOADED` → `PROCESSING` → `SCORED` | `FAILED` (từ `FAILED` có thể `evaluate` hoặc `rescore` lại).

## Danh sách endpoint

| # | Method | Endpoint | Chức năng | Quyền | UC | Request | Response thành công | Mã lỗi |
|---|---|---|---|---|---|---|---|---|
| 1 | POST | `/auth/register` | Đăng ký tài khoản (UC1) | Công khai | UC1 | body RegisterRequest | 201 RegisterResponse | 400, 409 |
| 2 | POST | `/auth/login` | Đăng nhập (UC2) | Công khai | UC2 | body LoginRequest | 200 LoginResponse | 401, 429 |
| 3 | POST | `/auth/forgot-password` | Yêu cầu đặt lại mật khẩu (gửi email) | Công khai | UC2 | body ForgotPasswordRequest | 200 | 400 |
| 4 | POST | `/auth/reset-password` | Đặt lại mật khẩu bằng token trong email | Công khai | UC2 | body ResetPasswordRequest | 200 | 400 |
| 5 | GET | `/questions` | Danh sách câu hỏi theo bộ lọc (UC3) | Đã đăng nhập | UC3 | query industry; query position; query level; query questionType; query keyword; query page; query size | 200 QuestionPage | 401 |
| 6 | GET | `/questions/random` | Lấy ngẫu nhiên một câu hỏi theo bộ lọc (UC3, Alt 5a) | Đã đăng nhập | UC3 | query industry; query position; query level | 200 Question | 401, 404 |
| 7 | GET | `/questions/{id}` | Chi tiết một câu hỏi | Đã đăng nhập | UC3 | path id | 200 Question | 401, 404 |
| 8 | POST | `/practice-sessions` | Tạo phiên luyện tập với câu hỏi đã chọn (UC3 → UC4) | Đã đăng nhập | UC3, UC4 | body CreateSessionRequest | 201 PracticeSession | 401, 404 |
| 9 | GET | `/practice-sessions/{id}` | Xem chi tiết một phiên luyện tập | Đã đăng nhập | UC4, UC5 | path id | 200 PracticeSession | 401, 403, 404 |
| 10 | POST | `/practice-sessions/{id}/answer` | Nộp file ghi âm câu trả lời (UC4) | Đã đăng nhập | UC4 | path id; body multipart/form-data | 200 PracticeSession | 400, 401, 404 |
| 11 | POST | `/practice-sessions/{id}/evaluate` | Bắt đầu chấm điểm câu trả lời bằng AI (UC5, bất đồng bộ) | Đã đăng nhập | UC5 | path id | 202 PracticeSession | 401, 404, 409 |
| 12 | GET | `/practice-sessions/{id}/result` | Lấy kết quả chấm điểm (sau khi session SCORED) | Đã đăng nhập | UC5 | path id | 200 ScoreResult | 401, 403, 404, 409 |
| 13 | POST | `/practice-sessions/{id}/rescore` | Chấm lại với transcript đã sửa (UC5, Alt 6a, bất đồng bộ) | Đã đăng nhập | UC5 | path id; body RescoreRequest | 202 PracticeSession | 400, 401, 403, 404, 409 |
| 14 | GET | `/practice-sessions/{id}/feedback/audio` | Lấy audio TTS đọc phản hồi AI (UC6) | Đã đăng nhập | UC6 | path id | 200 FeedbackAudioResponse | 401, 404, 502 |
| 15 | GET | `/history` | Danh sách lịch sử luyện tập của chính người dùng (UC7) | Đã đăng nhập | UC7 | query from; query to; query industry; query minScore; query maxScore; query page; query size | 200 HistoryPage | 401 |
| 16 | GET | `/history/{id}` | Chi tiết một mục lịch sử, kèm link phát lại audio | Đã đăng nhập | UC7 | path id | 200 HistoryDetail | 401, 403, 404 |
| 17 | GET | `/admin/questions` | Danh sách toàn bộ câu hỏi (bao gồm HIDDEN) — chỉ ADMIN | ADMIN | UC8 | query status; query keyword; query page; query size | 200 QuestionPage | 401, 403 |
| 18 | POST | `/admin/questions` | Thêm câu hỏi mới — chỉ ADMIN (UC8) | ADMIN | UC8 | body QuestionUpsertRequest | 201 Question | 401, 403, 409 |
| 19 | PUT | `/admin/questions/{id}` | Sửa câu hỏi — chỉ ADMIN | ADMIN | UC8 | path id; body QuestionUpsertRequest | 200 Question | 401, 403, 404 |
| 20 | DELETE | `/admin/questions/{id}` | Xoá câu hỏi — chỉ ADMIN | ADMIN | UC8 | path id | 204 | 401, 403, 404 |
| 21 | GET | `/admin/analytics/overview` | Dashboard tổng quan hoạt động người dùng — chỉ ADMIN (UC9) | ADMIN | UC9 | query from; query to | 200 AnalyticsOverview | 401, 403 |
| 22 | GET | `/admin/analytics/users/{userId}` | Chi tiết hoạt động của một người dùng — chỉ ADMIN | ADMIN | UC9 | path userId | 200 UserActivity | 401, 403, 404 |
| 23 | GET | `/admin/analytics/export` | Xuất báo cáo hoạt động dạng Excel/CSV — chỉ ADMIN | ADMIN | UC9 | query format; query from; query to | 200 binary | 401, 403 |

Tổng: 23 endpoint.
