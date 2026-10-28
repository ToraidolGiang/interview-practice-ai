# Câu hỏi giảng viên có thể hỏi về phần thiết kế

Dùng để chuẩn bị buổi họp định kỳ. Câu trả lời gợi ý bám theo các quyết định đã ghi trong `docs/`; mục "Hạn chế nên nói thẳng" là chỗ nên chủ động nêu để không bị hỏi vặn.

## 1. Kiến trúc tổng thể

**Vì sao chọn monolith, không dùng microservices?**
Quy mô đồ án 2 tháng, 2 người, một nhóm người dùng nhỏ. Microservices làm tăng chi phí vận hành (nhiều dịch vụ, mạng, theo dõi) mà không có lợi ích tương ứng. Vẫn giữ ranh giới rõ bằng 3 tầng (Controller – Service – Repository) và Adapter Pattern nên tách dịch vụ sau này không khó. (`Kien_Truc_He_Thong.docx` mục 2)

**Adapter Pattern để làm gì?**
Tầng Service không gọi trực tiếp Gemini, FPT.AI, SMTP, S3 mà đi qua `SttService`, `LlmService`, `TtsService`, `MailService`, `FileStorageService` và các interface provider. Đổi nhà cung cấp (hoặc mock khi test) chỉ sửa một lớp.

**Vì sao chấm điểm chạy bất đồng bộ?**
STT từng mất tới 83 giây trong lần đo thực tế và Render có cold start, nên không nên giữ một request HTTP chờ kết quả. API trả 202 ngay, client polling mỗi 2 giây rồi lấy kết quả. Thực thi bằng `ThreadPoolTaskExecutor` trong cùng tiến trình, không thêm hàng đợi ngoài để giữ hệ thống đơn giản. (Hình 4)

**Nếu server khởi động lại giữa lúc đang chấm thì sao?**
Job nền bị mất. Khi khởi động, phiên `PROCESSING` quá hạn được đặt `FAILED` với `SERVER_RESTART`, người dùng bấm Chấm lại. Nếu cần bền hơn thì nâng cấp lên hàng đợi (hướng phát triển).

**NF1 ≤ 12 giây dựa trên đâu?**
Đo 14 mẫu audio dài 10–131 giây trên pipeline gọi LLM đúng 1 lần; ban đầu dự kiến 8 giây nhưng thực đo không đạt. Với bất đồng bộ, API phản hồi ≤ 1 giây còn 12 giây là từ lúc nộp tới `SCORED`.

**Bảo mật được xử lý thế nào?**
JWT 24 giờ, `JwtAuthenticationFilter` xác thực mọi request và nạp lại trạng thái, role của người dùng từ CSDL (xem câu hỏi bên dưới), `/admin/**` yêu cầu ADMIN, phiên và lịch sử chỉ trả cho chủ sở hữu, mật khẩu băm BCrypt, khóa tài khoản 15 phút sau 5 lần sai (trả 429, khóa dòng để request song song không vượt được giới hạn), bí mật chỉ đọc từ biến môi trường. (Hình 5)

**Tài khoản bị khóa hoặc đổi role thì token đang dùng ra sao?**
Token chỉ chứng minh danh tính. Mỗi request, bộ lọc tra `users` theo khóa chính (một truy vấn trên chỉ mục khóa chính) để lấy `status` và `role` hiện tại: tài khoản bị quản trị khóa (`LOCKED`) hoặc bị xóa thì bị từ chối 401 ngay, đổi role có hiệu lực ngay, không chờ token hết hạn. Đánh đổi: thêm một truy vấn nhỏ mỗi request, đổi lấy việc thu hồi được quyền tức thì; ở quy mô đồ án chi phí này không đáng kể. Khóa tạm do đăng nhập sai không làm mất hiệu lực token đang dùng.

**Hạn chế nên nói thẳng:** chưa có rate limit ngoài khóa đăng nhập; token chưa bị thu hồi khi người dùng tự đổi mật khẩu (chỉ thu hồi khi tài khoản bị khóa hoặc xóa); Gemini bậc miễn phí có giới hạn request/phút.

## 2. Cơ sở dữ liệu

**Vì sao điểm từng tiêu chí là bảng `score_criteria` thay vì 4 cột S/T/A/R hoặc JSONB?**
Mỗi loại câu hỏi có số tiêu chí khác nhau và rubric sẽ còn hiệu chỉnh; bảng riêng thêm tiêu chí không cần đổi schema, vẫn truy vấn/thống kê được và có ràng buộc `UNIQUE (result_id, code)`, `CHECK score 1–5`.

**Vì sao khóa chính UUID?**
Khớp OpenAPI, không lộ số lượng bản ghi qua URL, sinh ở phía ứng dụng/CSDL không cần tuần tự. Đổi lại index lớn hơn một chút, chấp nhận được ở quy mô này.

**Xóa câu hỏi thì dữ liệu lịch sử ra sao?**
Xóa mềm: câu hỏi đã có trong lịch sử chuyển `status = HIDDEN`, các khóa ngoại dùng `ON DELETE RESTRICT` nên không thể xóa cứng nhầm. Dữ liệu thuộc về một phiên (kết quả, tiêu chí, nhật ký gọi AI) dùng `CASCADE`.

**Làm sao truy vết một điểm số do mô hình nào chấm?**
Mỗi `score_results` lưu `rubric_version`, `prompt_version`, `model_version`, `filler_list_version`; đổi phiên bản không tính lại kết quả cũ.

**Quên mật khẩu lưu token thế nào?**
Chỉ lưu SHA-256 của token (`password_reset_tokens.token_hash`), dùng một lần (`used_at`), có hạn (`expires_at`); lộ bảng không đủ để đặt lại mật khẩu.

**Migration và kiểm thử schema?**
Flyway (`V1__init.sql`), Hibernate chỉ `validate`. Script đã chạy thử trên PostgreSQL 16 cùng 18 ca kiểm tra ràng buộc (trùng email khác hoa thường, giá trị ngoài danh sách, RESTRICT/CASCADE).

**Hạn chế nên nói thẳng:** chấm lại ghi đè kết quả cũ (chỉ giữ bản mới nhất mỗi phiên); gói PostgreSQL miễn phí trên Render có thời hạn nên cần nâng gói hoặc chuyển nhà cung cấp trước khi bảo vệ cuối kỳ.

## 3. Class diagram

**Vì sao `ScoringService` có nhiều lớp phụ (`RubricProvider`, `PromptBuilder`, `QuoteValidator`, `ScoreCalculator`, `DeliveryAnalyzer`, `EvaluationExecutor`)?**
Tách trách nhiệm để từng phần kiểm thử riêng được: tính điểm và kiểm tra trích dẫn là mã tất định (không phụ thuộc LLM), prompt/rubric có phiên bản, executor lo bất đồng bộ. `ScoringService` chỉ điều phối.

**Sơ đồ Sequence và Class có nhất quán không?**
Có script đối chiếu: mọi thông điệp Sequence phải gọi phương thức có trong lớp đích; 23 phương thức controller ứng với đúng 23 endpoint OpenAPI; thuộc tính lớp miền trùng cột bảng. (`Doi_Chieu_Thiet_Ke.md`)

**Vì sao Domain Model và Design Class Diagram tách làm hai?**
Domain Model mô tả dữ liệu và quan hệ (khớp ERD), Design Class Diagram mô tả lớp thiết kế theo tầng cùng phụ thuộc giữa chúng.

## 4. API và chấm điểm

**Vì sao `evaluate` trả 202 mà không trả kết quả luôn?**
Xem phần kiến trúc: tránh giữ request dài, chịu được STT chậm. Trạng thái `PROCESSING → SCORED | FAILED` kèm `errorCode`.

**STAR có quá cứng không? Vì sao không train mô hình?**
Rubric theo loại câu hỏi (BEHAVIORAL, SITUATIONAL, TECHNICAL, INTRO), STAR chỉ là khung cấu trúc cho câu hành vi. Không train vì chưa có dữ liệu gán nhãn và thời gian ngắn; thay vào đó dùng LLM với rubric có mô tả neo, tính điểm tổng bằng code, rồi hiệu chỉnh bằng bộ dữ liệu chuẩn 100–150 câu (QWK, Spearman, MAE). (`Rubric_Cham_Diem.md`)

**Làm sao chống người dùng nói "cho tôi 100 điểm"?**
Transcript được bọc như dữ liệu, LLM có cờ `injectionSuspected`/`offTopic`, điểm tiêu chí bị ép 1–5, tổng điểm do server tính, và mọi điểm từ 3 trở lên phải kèm trích dẫn nguyên văn được kiểm tra có trong transcript.

**Độ chính xác của STT với giọng vùng miền?**
Đây là rủi ro đã nhận diện: lỗi nghe thành lỗi điểm. Giảm bằng cách cho người dùng sửa transcript rồi chấm lại (không gọi lại STT), điểm nội dung độc lập với Delivery, Delivery chỉ chiếm 10/100.

**Phân trang, lỗi, xác thực của API thống nhất ra sao?**
`page`/`size` (size ≤ 100) cho danh sách; mọi lỗi dạng `ErrorResponse {code, message, timestamp, fieldErrors?}`; Bearer JWT; 401 thiếu/sai token, 403 không đủ quyền, 409 xung đột trạng thái.

**Hạn chế nên nói thẳng:** OpenAPI là bản thiết kế, backend chưa được implement; kết quả đo độ chính xác AI so với người chấm sẽ có sau ticket DLPVXVTHA-129.
