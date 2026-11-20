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

### 2026-11-20 — Thanh cuộn dọc thừa ở AdminTabs chỉ lộ trên Chrome Windows
- Chuyện gì xảy ra: hàng tab admin hiện mũi tên cuộn lên/xuống bên phải; lint, build và đọc mã đều không phát hiện, chỉ thấy khi kiểm tay trên trình duyệt.
- Nguyên nhân gốc: `.tab { margin-bottom: -1px }` làm tab nhô 1px khỏi vùng nội dung của `<nav>` có `overflow-x: auto`; một trục là `auto` thì trục kia cũng thành `auto` nên xuất hiện cuộn dọc.
- Quy tắc rút ra: Không dùng margin âm bên trong phần tử `overflow-x: auto`. Giao diện có cuộn/tràn phải soi bằng mắt trên trình duyệt thật (kể cả Windows), không dựa vào lint/build.
- Liên quan: specs/20261120-frontend-noi-api-moi/test-report.md, `frontend/src/components/AdminTabs.module.css`

### 2026-11-20 — Form `noValidate` + Prism không bắt lỗi rỗng
- Chuyện gì xảy ra: gửi form admin trống, mock Prism trả 201 vì openapi không khai `minLength`; không thử được nhánh 400 một cách tự nhiên.
- Quy tắc rút ra: Form `noValidate` phải dựa vào 400 `fieldErrors` của backend; thử nhánh lỗi bằng cách giả lập phản hồi (ghi đè `window.fetch` hoặc `Prefer: code=`), đừng kỳ vọng Prism kiểm ràng buộc.
- Liên quan: specs/20261120-frontend-noi-api-moi/test-report.md

Cập nhật lần cuối: 2026-11-20
