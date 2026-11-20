# Nợ kỹ thuật & việc chưa làm

Nguồn: `specs/AI-PIPELINE/review.md`, `design.md`, `test-report.md`.

## Nợ từ review (MINOR, không chặn merge)
| Mã | Vấn đề | Đề xuất |
|---|---|---|
| F3 | ~~`markFailed`/`revertToUploaded` lỗi (DB chập chờn) -> phiên kẹt PROCESSING, mọi evaluate/upload 409 `SESSION_PROCESSING` tới lần restart sau (`ScoringPipeline.fail`, `EvaluationService.java:61`)~~ **Đã xử lý 2026-11-19** | `SessionRecoveryRunner.sweepTimedOut` quét mỗi 60s, đánh FAILED `PROCESSING_TIMEOUT` phiên quá 300s |
| F4 | ~~Không rate limit /evaluate, không giới hạn phiên theo user; 1 user lấp đầy queue (core 2/max 4/queue 20) -> user khác 503, tốn quota Gemini~~ **Đã xử lý 2026-11-19** | `EvaluationService` trả 429 `TOO_MANY_PROCESSING` khi user có >=3 phiên PROCESSING và 429 `DAILY_LIMIT_EXCEEDED` khi đã bắt đầu >=20 lượt chấm trong ngày (bảng `evaluation_attempts`) (cấu hình `app.scoring.max-evaluations-per-day`). Chấm lại (rescore/retry) cùng một phiên vẫn tính từng lượt; lượt bị hoàn tác do 503 không tính |
| F5 | ~~Upload lại hoặc 409 sau `put` để lại file S3 mồ côi chứa giọng nói~~ **Đã xử lý 2026-11-19** (phần code) | `AudioStorage.delete` best-effort: xóa khóa cũ khi nộp lại, xóa khóa mới khi thua race. Còn thiếu: S3 lifecycle trên AWS để dọn file sót khi `delete` lỗi |
| F2 | ~~`PracticeSessionRepository` import `dto/ScoringInput` (phụ thuộc ngược)~~ **Đã xử lý 2026-11-19** | Thay bằng interface projection `repository/ScoringInputView` |

## Chưa xác minh / rủi ro
- **Smoke test thật 2026-11-17 (STT):** `gemini-3.5-transcribe` nhận `audio/webm` (opus), giữ từ đệm "Um", "Uh" ở VERBATIM. Phản hồi để transcript ở `parts[].audioTranscription.text`, không phải `parts[].text`; client đã sửa (trước đó mọi phiên sẽ ra `STT_ERROR`). Mới thử mẫu tiếng Anh tổng hợp, **chưa thử giọng tiếng Việt thật từ trình duyệt**.
- **Smoke test thật 2026-11-17 (LLM):** `gemini-3.8-flash` trả 503 "high demand" (cả request tối giản không schema) và timeout, `gemini-2.5-flash` thì 200. `responseSchema` của chấm điểm **vẫn chưa kiểm được**. Cần chạy lại; nếu 3.8 tiếp tục quá tải, cân nhắc model dự phòng và timeout/retry (backend hiện timeout 15s, thử lại 1 lần). `gemini-2.5-flash` khai tử từ 2026-12-01 nên chỉ dùng tạm.
- Mặc định đã đổi (2026-11-15) vì `gemini-2.5-flash` khai tử từ 2026-12-01: STT `gemini-3.5-transcribe` (VERBATIM, `vi-VN`), LLM `gemini-3.8-flash`. Dự phòng: đặt `GEMINI_STT_MODEL` là model đa năng thì client quay về prompt phiên âm nguyên văn.
- Chưa dùng `wordTimestamp` của `gemini-3.5-transcribe` để tính thời gian nói thật cho WPM (hiện vẫn dùng `durationSeconds` client khai).
- AC-30 (<=12s, 14 mẫu 10-131s) chưa đo; quy trình ở `specs/AI-PIPELINE/test-report.md` dòng 59.
- `durationSeconds` do client khai (WPM có thể bị làm giả); chỉ đúng 1 instance (ADR-001).
- Q10 (chờ xác nhận): `weight` trả về là trọng số gốc hay đã chia lại khi Delivery null (hiện lưu gốc).

## Frontend & đề xuất cho backend/openapi (task 20261120-frontend-noi-api-moi)
Đề xuất cho Giang (frontend không tự sửa backend/openapi):
- `/history` không có `playbackUrl` trong schema (`audioUrl` là khóa S3, không phát được); `HistoryPage` dùng `session.playbackUrl` nên nút nghe lại có thể luôn khóa (`openapi.yaml:603` mô tả có, schema không khai).
- Chưa có API liệt kê user / `GET /admin/analytics/users` hoặc cột userId (không làm chi tiết user, Q4); chưa có API bật lại câu HIDDEN; chưa có audit log thao tác admin.
- Không rõ đơn vị tiền của `estimatedCost` (UI chỉ ghi "ước tính").
- Ghi vào openapi: `newPassword` giới hạn 72 byte UTF-8 (`ResetPasswordRequest.java:17`); `RescoreRequest.transcript` tối đa 10000 ký tự; rescore 503 hoàn tác về SCORED.

Nợ frontend:
- `HistoryPage` gọi `/questions/{id}` cho từng dòng (N+1) vì `PracticeSession` không có nội dung câu hỏi; lọc keyword chỉ trong trang hiện tại.
- `QuestionsPage`: ô "Sắp xếp" chỉ có 1 lựa chọn giả; thiếu nút "Thử lại" khi lỗi tải; `page` vượt tổng hiện trạng thái rỗng thay vì về trang cuối.
- Chưa có test tự động cho `downloadBlob`, `RequireAdmin`, `ConfirmDialog`; chưa kiểm tay: tải CSV thật, sửa/xoá câu hỏi, giao diện 1280px, `INTERNAL_ERROR`/mã lạ trên trình duyệt.
- Các câu thông báo lỗi mới còn là giả định chờ PO (`specs/20261120-frontend-noi-api-moi/assumptions.md`).

Cập nhật lần cuối: 2026-11-20
