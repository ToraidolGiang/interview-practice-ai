# Bàn giao tiến độ, 19/11/2026

Tiếp nối `Ban_Giao_Tien_Do_20261117.md`. Nhánh: `feature/AI-PIPELINE-nen-tang-phien-luyen-tap` (PR #20).

## 1. Đã làm hôm nay
- Sửa góp ý MINOR của review #20: bỏ `@Transactional` ở `ApiUsageRecorder.record` (`0b4f0e6`).
- F3: job quét `SessionRecoveryRunner.sweepTimedOut` (60s/lần), phiên PROCESSING quá 300s thành FAILED `PROCESSING_TIMEOUT` (`ff53ccc`).
- F4: tối đa 3 phiên PROCESSING mỗi user, vượt thì 429 `TOO_MANY_PROCESSING` (`ff53ccc`). Hạn mức theo ngày xem mục dưới.
- Cập nhật `openapi.yaml`, `Data_Dictionary.md`, `tech-debt.md`. Test backend 312/312 (JDK 21).
- Tài liệu học (git-ignore, chỉ trên máy): `.claude/learning/AI-PIPELINE-do-ben-vung-F3-F4.md`.

## 2. Trạng thái PR (19/11)
| PR | Trạng thái |
|---|---|
| #15, #16 | Đã merge |
| #18 | Mở, CI xanh. Chờ chốt hướng hiển thị câu hỏi bị ẩn và DTO dùng chung với #20 |
| #19 | Mở. Chờ Giang chấm 100 câu rồi mới review |
| #20 | Mở, CI xanh, chưa ai approve |
| #21 | Mở, CI xanh, chưa review |

## 3. Việc của Giang, theo thứ tự
- [ ] Chấm 100 câu cho #19 (`rater.html`), gửi CSV cho Tuấn Anh. Chưa mở `data/gold/labels/`.
- [ ] Smoke test LLM `gemini-3.8-flash` kiểm `responseSchema`; nếu vẫn 503 thì chốt model dự phòng + xem timeout 15s/retry 1 lần. **Hạn 01/12/2026.**
- [ ] Smoke test STT bằng giọng tiếng Việt thật từ trình duyệt.
- [ ] Đo AC-30 (≤ 12s, 14 mẫu 10–131s), quy trình ở `specs/AI-PIPELINE/test-report.md` dòng 59.
- [ ] Chốt #18: tóm tắt câu hỏi trong mục lịch sử hay cho `/questions/{id}` trả câu HIDDEN; chốt dùng chung DTO với #20; chốt Q10 (`weight`).
- [ ] F5: xóa best-effort file S3 mồ côi, thêm S3 lifecycle.
- [ ] Hạn mức `/evaluate` theo ngày (phần còn lại của F4).
- [ ] F2: interface projection thay `ScoringInput` trong repository.
- [ ] Code chưa có: #155 rescore, #121 TTS, #163 usage/audit log, #131 Dockerfile, #132 deploy Render, #133 CD.
- [ ] Cân nhắc `wordTimestamp` để tính WPM thật; thêm metric (độ sâu queue, p95, số PROCESSING_TIMEOUT).
- [ ] Jira: chuyển #119 #120 #154 #156 #160 sang Done sau khi #20 merge; đóng Sprint 2; đặt ngày Sprint 4; tạo lại connector Atlassian v2.
- [ ] Quyết định có commit `AGENTS.md` không.

## 4. Báo Tuấn Anh
- Review và approve #20 (có thêm F3/F4 sau lần review trước), rồi #21 và #18.
- Thứ tự merge: #20 và #21, sau đó #18; #19 sau khi chấm xong và đối chiếu điểm.
- Cấu hình môi trường deploy: `GEMINI_API_KEY`, biến S3, `JWT_SECRET`, Postgres; chạy đúng 1 instance (ADR-001).

## 5. Báo Vũ (frontend)
- Hiển thị mã lỗi mới `PROCESSING_TIMEOUT` và thông báo 429 `TOO_MANY_PROCESSING`.
- #161 UI chọn câu hỏi, #162 UI quản trị câu hỏi.

## 6. Môi trường
Như bàn giao 17/11. Docker Desktop không tự chạy: mở app rồi `docker start interview-pg-test`.

## 7. Cập nhật buổi chiều 19/11 (chưa push)
Trên nhánh `feature/AI-PIPELINE-nen-tang-phien-luyen-tap`, test backend 337/337:
- F4 hạn mức ngày: đã làm. 20 lượt chấm/user/ngày (429 `DAILY_LIMIT_EXCEEDED`), cấu hình `app.scoring.max-evaluations-per-day`, `day-zone`. Đếm từ bảng `evaluation_attempts` (V3): mỗi lượt evaluate/retry/rescore là một đơn vị, chấm lại cùng phiên vẫn tính; lượt bị hoàn tác do hàng đợi đầy (503) không tính.
- F5: `AudioStorage.delete` best-effort, xóa file cũ khi nộp lại và file mới khi thua race. Còn thiếu S3 lifecycle trên AWS.
- F2: `ScoringInput` thành interface projection `ScoringInputView`.
- #155: `POST /practice-sessions/{id}/rescore` (không gọi lại STT, ghi đè kết quả cũ). Lỗi chấm lại thì FAILED, kết quả cũ còn để thử lại.
- #163: `/admin/analytics/overview`, `/users/{userId}`, `/export` (chỉ csv; xlsx trả 400, cần Apache POI nếu muốn hỗ trợ).
- #131: nhánh `feature/DLPVXVTHA-131-dockerfile` (từ `main`), Dockerfile đa tầng, đã build và chạy thử với Postgres local.

Còn lại: #121 TTS (cần `FPT_AI_API_KEY` thật để kiểm), #132 deploy Render, #133 CD, và các việc của Giang ở mục 3 (chấm 100 câu, smoke test, đo AC-30, Jira, chốt #18).
Môi trường Windows: nếu Postgres báo `invalid value for parameter "TimeZone": "Asia/Saigon"` thì chạy test với `JAVA_TOOL_OPTIONS=-Duser.timezone=Asia/Ho_Chi_Minh`.

