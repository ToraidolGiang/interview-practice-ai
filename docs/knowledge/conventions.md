# Quy ước

## Mẫu chuẩn để bắt chước
- Controller + test tích hợp: `QuestionController` / `QuestionApiIntegrationTest`; đồng thời: `AuthLoginConcurrencyTest`.
- Cấu hình: record `@ConfigurationProperties` như `config/JwtProperties.java`, `AiProperties`.
- Chuyển trạng thái: `repository/PracticeSessionRepository.java` (`markUploaded`, `markProcessing`, `markScored`, `markFailed`).

## Quy tắc bắt buộc (luồng phiên/chấm điểm)
1. **Chuyển trạng thái có điều kiện**: dùng `UPDATE ... WHERE id=:id AND status IN (...)` trả `int`; 0 dòng = thua cuộc đua -> trả 409. Không đọc-rồi-ghi. `@Modifying(clearAutomatically = true, flushAutomatically = true)` vì có OSIV. Worker chốt bằng `WHERE status='PROCESSING'` để idempotent.
2. **I/O ngoài transaction**: S3, STT, LLM gọi ngoài `@Transactional`; transaction chỉ ngắn quanh UPDATE/insert. Worker truyền `sessionId`/DTO (vd `dto/ScoringInput`), không truyền entity lazy.
3. **Không log transcript, API key, khóa S3 đầy đủ**: log chỉ sessionId/userId/mã lỗi/tên lớp lỗi. Key Gemini đi qua header, không nằm trong URL. DTO chứa transcript ẩn `toString` (`ScoredAnswer`).
4. Khóa S3 do server sinh (`audio/{userId}/{sessionId}/{uuid}.{ext}`), không dùng tên file client; không public ACL.
5. Mốc thời gian lấy từ `Clock` bean, không `Instant.now()` trực tiếp.
6. Mọi lệnh gọi ngoài qua interface (`SttClient`, `LlmClient`, `AudioStorage`, `DeliveryMetricsProvider`) để mock.
7. Jackson 3: `tools.jackson.databind.json.JsonMapper`; annotation vẫn ở `com.fasterxml.jackson.annotation`.
8. Mã lỗi mới -> thêm vào `docs/api/openapi.yaml` (mô tả `ErrorResponse.code`) và `Data_Dictionary.md` nếu là `error_code`.

## Test
- Integration theo mẫu `QuestionApiIntegrationTest`; `@MockitoBean` cho `SttClient`, `LlmClient`, `AudioStorage`.
- Executor test: override bằng executor đồng bộ; 1 test dùng executor thật + polling có timeout.
- Cấu hình test: `backend/src/test/resources/config/application.yml` (giá trị giả cho `ai.*`, `aws.*`).
- Unit test lớp thuần (`ScoreCalculator`...) ở biên: điểm 0/6/3.5, 14/15 từ, đúng 50% quote sai.

## Không làm theo
- Không tạo S3 key từ tên file client.
- Không dựa vào `totalScore` do LLM trả.
- Không dùng bảng `audit_logs` cho cờ injection (dành cho thao tác quản trị).
- Repository import `dto/ScoringInput` qua JPQL constructor (review F2): chấp nhận hiện tại, đừng nhân rộng.

Cập nhật lần cuối: 2026-11-04
