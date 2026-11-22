# Giai đoạn A: Phân tích, thiết kế, cơ sở dữ liệu, CI

Thời gian: 10/09 - 28/10/2026. Người làm chính: Giang. Mốc chính: `Initial commit` 10/09, thiết kế CSDL và API v0.2.0 ngày 13/10, báo cáo thiết kế 13-15/10, entity/repository và CI 27/10 (PR #8, #10, merge 28/10).

## 1. Hiểu nhanh trong 1 phút
- **Một câu:** trước khi viết code, nhóm chốt *làm gì* (SRS, use case), *làm thế nào* (kiến trúc, CSDL, hợp đồng API) và *kiểm tra tự động ra sao* (CI), để hai người code song song mà không giẫm chân nhau.
- **Hình ảnh đời thường:** như vẽ bản vẽ và thống nhất ổ cắm điện trước khi hai thợ cùng xây hai phòng.
- **Ba ý chính:**
  1. Kiến trúc: monolith 3 tầng, dịch vụ ngoài đi qua adapter, chấm điểm bất đồng bộ (ADR-001).
  2. CSDL: 8 bảng, quản lý bằng Flyway, Hibernate chỉ *kiểm* schema chứ không tự sửa.
  3. Hợp đồng API (`docs/api/openapi.yaml`) là nguồn sự thật chung; frontend code theo mock, backend code theo hợp đồng.

## 2. Từ điển nhanh
| Từ | Nghĩa bằng lời thường |
|---|---|
| Monolith | Cả backend là một chương trình duy nhất, không tách thành nhiều dịch vụ nhỏ |
| 3 tầng (3-layer) | Controller (nhận HTTP) → Service (nghiệp vụ) → Repository (nói chuyện với DB) |
| Adapter / Port | Interface mô tả "việc cần làm" (port) và lớp cụ thể gọi Gemini/S3 (adapter); đổi nhà cung cấp chỉ sửa adapter |
| Migration | Một file SQL đánh số phiên bản (`V1__init.sql`) mô tả thay đổi schema, chạy theo thứ tự đúng một lần |
| Flyway | Công cụ chạy migration và ghi lại bản nào đã chạy trong bảng `flyway_schema_history` |
| ERD | Sơ đồ bảng và quan hệ giữa chúng |
| FK, `ON DELETE CASCADE/RESTRICT` | Khóa ngoại; CASCADE là xóa cha thì xóa luôn con, RESTRICT là cấm xóa cha khi còn con |
| OpenAPI | Tệp mô tả toàn bộ endpoint, dữ liệu vào/ra, mã lỗi |
| Contract-first | Viết hợp đồng API trước rồi mới code hai phía |
| 202 + polling | Server trả 202 "đã nhận, đang xử lý", client hỏi lại định kỳ cho đến khi xong |
| CI | Hệ thống tự build và chạy test mỗi lần có code mới đẩy lên |
| ADR | Bản ghi một quyết định kiến trúc: bối cảnh, quyết định, phương án đã cân nhắc, hệ quả |

## 3. Thân bài theo bước

### Bước 1. Phân tích yêu cầu (SRS, use case, user story)
- **Vì sao cần:** không có yêu cầu rõ thì mỗi người hiểu một kiểu, và vấn đáp sẽ hỏi "hệ thống này giải quyết gì".
- **Ý chính:** SRS v1.0, đặc tả 9 use case (UC1-UC9), user story. Có các yêu cầu phi chức năng đáng nhớ: chấm xong trong ≤ 12 giây (NF1, AC-30), tiếng Việt là ngôn ngữ chính.
- **Tài liệu:** `docs/business/` (SRS, Đặc tả use case, User Story, Rubric chấm điểm), `docs/reports/Bao_Cao_Thiet_Ke_He_Thong.docx`.

### Bước 2. Kiến trúc: monolith 3 tầng + adapter + bất đồng bộ
- **Vì sao monolith:** quy mô 2 người, 2 tháng, ít người dùng. Microservices thêm chi phí vận hành (nhiều dịch vụ, mạng, theo dõi) mà không có lợi ích tương ứng. Ranh giới vẫn rõ nhờ 3 tầng và adapter nên tách dịch vụ sau này không khó.
- **Vì sao bất đồng bộ:** STT từng mất tới 83 giây trong một lần đo thực tế và Render có cold start, nên không giữ một request HTTP chờ kết quả. API trả 202, client hỏi lại mỗi 2 giây.
- **Ví dụ số nhỏ:** nếu STT 5s + LLM 5s = 10s mà request đồng bộ, trình duyệt phải chờ 10s trên một kết nối; bất đồng bộ cho phản hồi dưới 1s rồi poll.
- **Quyết định ghi lại:** `docs/knowledge/decisions/ADR-001-cham-diem-bat-dong-bo.md`: `ThreadPoolTaskExecutor` trong tiến trình, trạng thái trong DB là nguồn sự thật, Gemini gọi bằng `RestClient`, server tính điểm. **Hệ quả phải nhớ:** mất job khi restart (bù bằng đánh `FAILED SERVER_RESTART`), không scale ngang, chỉ chạy đúng 1 instance.

### Bước 3. Thiết kế CSDL và Flyway (13/10)
- **Vì sao cần:** DB là thứ khó đổi nhất sau khi có dữ liệu thật.
- **8 bảng trong `V1__init.sql`:** `users`, `questions`, `practice_sessions`, `score_results`, `score_criteria`, `api_usages`, `audit_logs`, `password_reset_tokens`.
- **Quan hệ chính:** một user có nhiều phiên; một phiên có tối đa một kết quả (`UNIQUE` theo `session_id`); một kết quả có nhiều tiêu chí (`UNIQUE (result_id, code)`). Dữ liệu thuộc về phiên (`score_results`, `score_criteria`, `api_usages`) dùng `ON DELETE CASCADE`; bảng quản trị như `audit_logs` dùng `RESTRICT` để không mất dấu vết.
- **Ràng buộc đáng nhớ:** `CHECK` giới hạn giá trị (điểm 1-5, trạng thái, loại câu hỏi), chỉ mục duy nhất `uq_questions_position_content` (cùng vị trí không có hai câu trùng nội dung, so bằng `md5(content)`).
- **Flyway + `ddl-auto: validate`:** Hibernate không tự tạo/sửa bảng, chỉ so entity với DB và báo lỗi nếu lệch. Nhờ vậy mọi thay đổi schema đi qua migration có phiên bản, **không bao giờ sửa file migration đã chạy**; cần đổi thì thêm `V3`, `V4`, `V5`.
- **Các migration tính đến 22/11:** V1 schema, V2 seed câu hỏi, V3 `evaluation_attempts` (hạn mức theo ngày), V4 `score_points`, V5 `score_errors`.

### Bước 4. Hợp đồng API (OpenAPI v0.2.0)
- **Vì sao cần:** frontend và backend làm song song. Frontend dùng Prism sinh server giả từ `openapi.yaml` (`npm run dev:mock`), nên không phải chờ backend.
- **Quy tắc nhóm:** muốn đổi API thì Giang sửa hợp đồng trong PR riêng, cả hai đồng ý, rồi mới sửa code (Kế hoạch coding, mục 4).
- **Quyết định đáng nhớ trong v0.2.0:** chấm điểm bất đồng bộ (202 + polling), đặt lại mật khẩu, phân trang.

### Bước 5. Entity, repository, CI
- **Entity/repository (#111, 27/10):** 8 entity JPA khớp `V1__init.sql`, repository kèm các hàm tìm kiếm dùng cho auth và phiên.
- **CI (#113, 27/10):** GitHub Actions. Job backend dựng PostgreSQL 16, JDK 21 (Temurin), build và chạy test; job frontend chạy lint và build. Biến môi trường trong CI là giá trị giả (`GEMINI_API_KEY: ci`...) vì test không gọi dịch vụ thật.
- **Vì sao cần:** mỗi PR phải xanh mới merge, tránh "máy tôi chạy được".

### Bước 6. Kế hoạch coding và phân vai (22/10)
`docs/Ke_Hoach_Coding.md`: chia theo Jira (65 ticket), phân vai Giang (backend core, pipeline AI, deploy) và Tuấn Anh (frontend, dữ liệu, chất lượng AI, một số chức năng trọn gói), ranh giới thư mục sở hữu, quy tắc nhánh/commit/PR, Definition of Done.

## 4. Luồng nên nói được: một request đi qua các tầng
`HTTP request → JwtAuthenticationFilter (xác thực) → Controller (kiểm dữ liệu vào) → Service (nghiệp vụ, kiểm sở hữu) → Repository → PostgreSQL`, lỗi bất kỳ được `GlobalExceptionHandler` đổi thành `ErrorResponse{code, message, ...}` thống nhất theo OpenAPI.

## 5. Khung giảng lại (Nói / Vì sao / Nếu bị hỏi)
**Nói (45 giây):** "Mình làm nền móng: chốt yêu cầu, kiến trúc monolith 3 tầng có adapter, 8 bảng quản lý bằng Flyway, và hợp đồng OpenAPI để frontend và backend làm song song. CI chạy test mỗi lần đẩy code."

| Câu hỏi có thể bị hỏi | Gợi ý trả lời |
|---|---|
| Vì sao không microservices? | Quy mô nhỏ, microservices tăng chi phí vận hành; vẫn giữ ranh giới bằng 3 tầng và adapter |
| Vì sao Flyway mà không để Hibernate tự tạo bảng? | Schema có phiên bản, tái lập được, có lịch sử; `ddl-auto: validate` chỉ kiểm lệch |
| Restart giữa lúc đang chấm thì sao? | Job nền mất; lúc khởi động phiên `PROCESSING` bị đánh `FAILED SERVER_RESTART`, người dùng chấm lại |
| Vì sao bất đồng bộ trong tiến trình thay vì hàng đợi (SQS/Rabbit)? | Ít hạ tầng cho quy mô đồ án; nếu scale ngang thì chỉ thay `EvaluationService.submit` bằng hàng đợi |
| Hạn chế nên nói thẳng | Chỉ 1 instance; mất job khi restart; chưa có tải thực tế |

## 6. Câu hỏi ôn
1. Nếu bỏ `UNIQUE (session_id)` ở `score_results` thì chấm lại một phiên gây ra hậu quả gì?
2. Vì sao `audit_logs` không dùng `ON DELETE CASCADE` theo user admin?
3. Một đồng đội sửa `V1__init.sql` thêm một cột sau khi bạn đã chạy backend. Chuyện gì xảy ra và nên làm gì?
4. Chạy 2 instance backend cùng lúc với thiết kế hiện tại sẽ hỏng ở đâu?
5. Frontend đang code với Prism nhưng backend trả khác hợp đồng. Lỗi nằm ở đâu và ai sửa?

## 7. Đáp án
1. Một phiên có thể có nhiều kết quả; API đọc kết quả không biết lấy cái nào. Constraint còn là chỗ để phát hiện lỗi chấm trùng.
2. Nhật ký quản trị phải còn dù tài khoản admin bị xóa; `RESTRICT` chặn xóa admin còn dấu vết thay vì âm thầm mất lịch sử.
3. Flyway so checksum file đã chạy với bản hiện tại và báo lỗi (hoặc Hibernate `validate` báo lệch). Không sửa file cũ; thêm migration mới `V<n+1>`.
4. Mỗi instance có executor và hàng đợi riêng trong bộ nhớ; job của instance A không được instance B biết; sweep `PROCESSING` quá hạn và giới hạn theo user không phối hợp được. Theo ADR-001 chỉ chạy đúng 1 instance.
5. Hợp đồng là nguồn sự thật: code backend sai hợp đồng thì backend sửa; nếu hợp đồng sai thì Giang sửa hợp đồng trong PR riêng, hai bên đồng ý, rồi cả hai cập nhật.
