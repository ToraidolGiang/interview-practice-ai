# Nợ kỹ thuật & việc chưa làm

Nguồn: `specs/AI-PIPELINE/review.md`, `design.md`, `test-report.md`.

## Nợ từ review (MINOR, không chặn merge)
| Mã | Vấn đề | Đề xuất |
|---|---|---|
| F3 | `markFailed`/`revertToUploaded` lỗi (DB chập chờn) -> phiên kẹt PROCESSING, mọi evaluate/upload 409 `SESSION_PROCESSING` tới lần restart sau (`ScoringPipeline.fail`, `EvaluationService.java:61`) | Cho phép thu hồi PROCESSING quá hạn (theo `processing_started_at`) hoặc job dọn định kỳ |
| F4 | Không rate limit /evaluate, không giới hạn phiên theo user; 1 user lấp đầy queue (core 2/max 4/queue 20) -> user khác 503, tốn quota Gemini | Giới hạn phiên đang xử lý/ngày theo user |
| F5 | Upload lại hoặc 409 sau `put` để lại file S3 mồ côi chứa giọng nói (`PracticeSessionService.java:106-117`) | Xóa best-effort khóa cũ/mới, hoặc S3 lifecycle |
| F2 | `PracticeSessionRepository` import `dto/ScoringInput` (phụ thuộc ngược) | Dùng interface projection |

## Chưa xác minh / rủi ro
- Tài liệu Gemini (tra 2026-11-15) đã liệt kê `audio/webm`, `audio/m4a`; `gemini-3.5-transcribe` nhận webm. Vẫn **cần smoke test thật** với audio từ trình duyệt (xem `specs/20261115-research-stt-tts-hoi-thoai/research.md`).
- Schema Gemini (`responseSchema` / `generateContent`) chưa xác minh với API thật.
- Mặc định đã đổi (2026-11-15) vì `gemini-2.5-flash` khai tử từ 2026-12-01: STT `gemini-3.5-transcribe` (VERBATIM, `vi-VN`), LLM `gemini-3.8-flash`. Chưa gọi thử API thật; `responseSchema` của chấm điểm chưa kiểm trên model mới. Dự phòng: đặt `GEMINI_STT_MODEL` là model đa năng thì client quay về prompt phiên âm nguyên văn.
- Chưa dùng `wordTimestamp` của `gemini-3.5-transcribe` để tính thời gian nói thật cho WPM (hiện vẫn dùng `durationSeconds` client khai).
- AC-30 (<=12s, 14 mẫu 10-131s) chưa đo; quy trình ở `specs/AI-PIPELINE/test-report.md` dòng 59.
- `durationSeconds` do client khai (WPM có thể bị làm giả); chỉ đúng 1 instance (ADR-001).
- Q10 (chờ xác nhận): `weight` trả về là trọng số gốc hay đã chia lại khi Delivery null (hiện lưu gốc).

Cập nhật lần cuối: 2026-11-15
