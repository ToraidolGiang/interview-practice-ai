# Review: AI-PIPELINE (nền tảng phiên luyện tập + chấm điểm bất đồng bộ) — Lăng kính: đúng đắn, kiến trúc, bảo mật, hiệu năng/dữ liệu/đồng thời
Kết luận: APPROVE (không có BLOCKER/MAJOR; 5 MINOR nên xử lý hoặc ghi nợ kỹ thuật)

Phạm vi đọc: toàn bộ code production mới/sửa (controller, service, service/ai, service/scoring, storage, config, repository, GlobalExceptionHandler, application.yml, pom, .env.example, test config) + đối chiếu requirements/design/RB/OA. Không chạy mvn. Chỉ đọc lướt test để xác nhận có phủ AC (không đánh giá kết quả chạy).

## Phát hiện
- F1 [MINOR] (tin cậy 80) backend/src/main/java/com/example/interviewpractice/repository/PracticeSessionRepository.java (`markProcessing`, `markUploaded`) — Không xóa `completed_at` khi phiên FAILED quay lại UPLOADED/PROCESSING. Kịch bản: phiên FAILED (markFailed đặt `completed_at`) -> user gọi lại /evaluate (AC-28) -> GET trả `status=PROCESSING` nhưng `completedAt` vẫn là mốc lần lỗi trước; client nào dùng `completedAt != null` để biết "đã xong" sẽ dừng polling sớm (OA:1098 `completedAt` chỉ có nghĩa khi kết thúc). Đề xuất: thêm `completed_at = NULL` vào `markProcessing` và `markUploaded` (và test 1 dòng).
- F2 [MINOR] (tin cậy 85) repository/PracticeSessionRepository.java:17,81 — Repository import `service.ScoringInput` (JPQL constructor expression) nên tầng repository phụ thuộc ngược lên service; các repository khác không có kiểu này. Đề xuất: đặt `ScoringInput` ở `dto`/`repository.projection`, hoặc dùng interface projection; không chặn merge.
- F3 [MINOR] (tin cậy 80) service/ScoringPipeline.java:fail + EvaluationService.java:61 — Phiên PROCESSING chỉ được giải phóng bởi chính worker hoặc `SessionRecoveryRunner` lúc khởi động. Nếu `markFailed`/`revertToUploaded` ném lỗi (CSDL chập chờn, đã được catch và chỉ log) thì phiên kẹt PROCESSING, mọi /evaluate và upload đều 409 `SESSION_PROCESSING` cho tới lần restart tiếp theo. Đề xuất (rẻ): cho `markProcessing`/`markUploaded` chấp nhận PROCESSING có `processing_started_at < now - ngưỡng` (vd 5 phút, > worst-case ~2x15s STT + 2x15s LLM + S3); index `idx_sessions_processing` đã sẵn. Hoặc ghi nợ kỹ thuật vì R1 đã nêu.
- F4 [MINOR] (tin cậy 80) config/AsyncConfig.java + application.yml (core 2/max 4/queue 20) — Không có giới hạn theo user và không rate limit (engineering-standards mục 2). Kịch bản: một user đăng nhập tạo 24 phiên, upload file bất kỳ (thời lượng tự khai), gọi /evaluate cả loạt (hoặc lặp lại trên phiên FAILED, AC-28) -> hàng đợi đầy, user khác nhận 503 `SERVICE_UNAVAILABLE` và tốn quota Gemini. Đề xuất: giới hạn số phiên PROCESSING/user (đếm bằng 1 truy vấn trước `markProcessing`) hoặc rate limit; ghi vào backlog nếu không làm trong task này.
- F5 [MINOR] (tin cậy 80) service/PracticeSessionService.java:106-117 + storage/S3AudioStorage.java:38 — Mỗi lần upload sinh khóa S3 mới và không bao giờ xóa khóa cũ: upload lại (Q4) hoặc `markUploaded` trả 0 (409 sau khi đã `put`) để lại đối tượng mồ côi chứa giọng nói người dùng. Đề xuất: best-effort `delete` khóa cũ sau khi `markUploaded` thành công và xóa khóa mới khi trả 409; hoặc S3 lifecycle rule; ghi nợ nếu không làm.

## Đối chiếu AC & impact
| Mục | Trạng thái |
|---|---|
| AC-1,2,3,8 (tạo/lấy phiên, 404, 401) | Đạt: `PracticeSessionService.create/get`, Security không đổi (`anyRequest().authenticated()`) |
| AC-4,5,6 (upload, biên 10/180, MIME, 10MB, 404) | Đạt: kiểm sở hữu -> duration -> file -> trạng thái trước khi gọi S3; `markUploaded` điều kiện; 400 không đổi trạng thái. Thời lượng do client khai (R2, đã ghi nhận) |
| AC-7,23 (403/404/409 SESSION_NOT_READY) | Đạt: mọi endpoint theo `{id}` qua `SessionAccess.requireOwned` (không có đường vòng) |
| AC-9,10,11 (STT 15s, đúng 1 retry, nguyên văn) | Đạt: `OneRetry` + `GeminiSttClient.PROMPT`; khóa API ở header, không trong URL |
| AC-12 (14/15 từ) | Đạt: `ScoringPipeline.wordCount` + test 14/15 từ trong `EvaluationPipelineIntegrationTest` |
| AC-13,14,15,16 (Delivery) | Đạt qua `DeliveryCalculator` đã nằm trong nhánh hiện tại (D1 đã đóng); adapter mỏng |
| AC-17,18,19,20 (trọng số, công thức, offTopic) | Đạt: `ScoreCalculator` kiểm tay ví dụ OA:1161 = 15+15+20+7.5 = 57.5; delivery null -> contentScore; cap 30; HALF_UP 1 chữ số |
| AC-21,27,33,35,36 (LLM 1 lần, retry đúng 1, schema) | Đạt: `LlmResultValidator` (số nguyên 1-5, đủ/đúng bộ mã), `LlmScorer` retry gộp; đúng 50% không retry (`invalidCount*2 > size`) |
| AC-22 (phiên bản + dữ liệu lưu) | Đạt: rubric/prompt/model/fillerList version, transcript, quote, reasoning |
| AC-24,25,28 (202, 409, không 2 job) | Đạt: `markProcessing` là UPDATE có điều kiện; không transaction bọc executor; từ chối hàng đợi -> hoàn tác + 503 |
| AC-26,29 (polling, SERVER_RESTART) | Đạt (xem F1, F3): worker `catch Throwable` luôn chốt FAILED; recovery theo `processing_started_at < bootTime` |
| AC-30 (12s) | Chưa đo (benchmark thủ công theo Q6) |
| AC-31,32,34,37 (injection, trích dẫn) | Đạt: thẻ `<transcript>` + vô hiệu hóa thẻ đóng chèn trong transcript; log WARN chỉ sessionId; quote chuẩn hóa NFC/lower/bỏ dấu câu, quote rỗng không hợp lệ; prompt chỉ có dữ liệu câu hỏi + transcript của phiên |
| impact.md / design "Cần làm" | Đã xử lý: GlobalExceptionHandler multipart (400 VALIDATION_ERROR, có `MultipartErrorHandlingTest`), không migration, `deleteBySessionId` + flush trước insert |

## Bảo mật (tóm tắt kiểm)
- Sở hữu phiên: 404/403 đúng, tập trung một chỗ. Upload: MIME whitelist + đuôi file + 10MB + khóa S3 do server sinh (không dùng tên client, không path traversal), không public ACL.
- Rò rỉ: API key Gemini qua header; log chỉ sessionId/mã lỗi/tên lớp lỗi; `ScoredAnswer`/`Checked` ẩn `toString`; lỗi trả client qua ErrorResponse. SSRF: `baseUrl` chỉ từ env/config, model chèn qua URI template. Test config chỉ giá trị giả; `.env` đã gitignore.
- Prompt injection: dữ liệu vs chỉ thị tách bạch, tổng điểm LLM bị bỏ, điểm ngoài 1-5 = sai schema, quote bị kiểm.

## Điểm tốt (ngắn)
- Chuyển trạng thái bằng UPDATE có điều kiện nhất quán, `clearAutomatically` đúng chỗ với OSIV; STT/LLM/S3 ngoài transaction; writer rollback khi `markScored`=0 nên không có kết quả mồ côi.
- Phần tính điểm thuần, tách rõ, có test biên.

## Chưa xác minh
- Gemini có nhận `audio/webm` và `audio/mp4` (định dạng MediaRecorder phổ biến của trình duyệt) qua `inline_data` hay không: tài liệu Gemini liệt kê wav/mp3/aiff/aac/ogg/flac; chỉ xác minh được bằng gọi thật (AC-30/staging). Nếu không nhận, upload webm sẽ ra `STT_ERROR` ở runtime dù mọi test mock xanh.
- Kết quả chạy test (tester đang chạy song song).

## Ngoài phạm vi (ghi nhận, không chặn)
- `INTERNAL_ERROR` (ScoringPipeline) và 503/`SESSION_ALREADY_SCORED` chưa nằm trong danh sách mã lỗi của OA:1106; cần bổ sung OA (Q5, Q11). `AudioStorageException` khi đọc S3 đang bị gắn `STT_ERROR`; với `INTERNAL_ERROR` log chỉ có tên lớp lỗi (không stack) nên khó chẩn đoán, chấp nhận được vì ưu tiên không lộ transcript.
- Chỉ đúng với 1 instance (R1); `durationSeconds` do client khai làm WPM có thể bị làm giả (R2).
