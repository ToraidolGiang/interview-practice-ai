# Lessons learned

### 2026-11-04 — Backend không kết nối được PostgreSQL 16 trên máy Windows
- Chuyện gì xảy ra: JVM lấy múi giờ `Asia/Saigon`, PostgreSQL 16 không nhận tên này.
- Nguyên nhân gốc: tên múi giờ cũ của JVM khác tên IANA mà Postgres hỗ trợ (`Asia/Ho_Chi_Minh`).
- Quy tắc rút ra: Trên Windows đặt `JAVA_TOOL_OPTIONS=-Duser.timezone=Asia/Ho_Chi_Minh` (hoặc UTC) trước khi chạy backend/test.
- Liên quan: README.md mục Chạy local. ⚠️ [CẦN XÁC NHẬN] cơ chế chính xác do orchestrator báo, chưa tái hiện trong phiên này.

### 2026-11-04 — Cấu hình test không được nạp
- Chuyện gì xảy ra: yml của test đặt sai chỗ nên giá trị giả `ai.*`/`aws.*` không có hiệu lực.
- Quy tắc rút ra: Đặt yml test ở `backend/src/test/resources/config/application.yml`.
- Liên quan: specs/AI-PIPELINE

### 2026-11-04 — Build lỗi do sai JDK
- Quy tắc rút ra: Build/test bằng JDK 21 (kiểm `java -version` và `JAVA_HOME`).

### 2026-11-04 — MockMvc không kích hoạt giới hạn multipart
- Chuyện gì xảy ra: MockMvc không áp `spring.servlet.multipart.max-file-size`, test quá cỡ có thể xanh giả.
- Quy tắc rút ra: Kiểm dung lượng ở tầng service/validator (`file.getSize()`) hoặc test bằng server thật; không tin MockMvc cho lỗi multipart của container.
- Liên quan: `MultipartErrorHandlingTest`, `GlobalExceptionHandler`.

Cập nhật lần cuối: 2026-11-04
