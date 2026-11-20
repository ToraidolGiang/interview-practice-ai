# Bàn giao tiến độ, 17/11/2026

Ghi để đọc lại sau khi Tuấn Anh review và làm tiếp. Nhánh đang làm: `feature/AI-PIPELINE-nen-tang-phien-luyen-tap`.

## 1. PR đang chờ review (chưa có review nào)

| PR | Nội dung | Ghi chú |
|---|---|---|
| #15 | Hợp đồng API câu hỏi (`openapi.yaml`) | Cần Vũ xác nhận trước. Đã nhắn Vũ, dự kiến phản hồi chiều 17/11 |
| #16 | API câu hỏi: danh sách, ngẫu nhiên, chi tiết, CRUD admin | Merge sau #15 |
| #18 | API lịch sử luyện tập `/history` | Chờ review |
| #19 | Bộ dữ liệu chuẩn, trang chấm mù, rubric v1.1 (#159) | Giang chấm trước, review sau. Không xem diff `data/gold/labels/` trước khi chấm |
| #20 | Pipeline AI phiên luyện tập (#156, #119, #120, #154, #160) | CI xanh. Test backend 310/310 trên JDK 21 |

Thứ tự đề xuất khi merge: #15, rồi #16, rồi #18, #19 và #20 (độc lập nhau).

## 2. Kết quả smoke test Gemini thật (17/11)

- **STT `gemini-3.5-transcribe`:** nhận `audio/webm` (opus), giữ từ đệm "Um", "Uh" ở chế độ VERBATIM. Transcript nằm ở `parts[].audioTranscription.text`. Client đã sửa theo dạng này (trước đó mọi phiên sẽ lỗi `STT_ERROR`).
- **LLM `gemini-3.8-flash`:** trả 503 "high demand", kể cả request tối giản không schema. `gemini-2.5-flash` cùng lúc vẫn 200. **`responseSchema` của chấm điểm chưa kiểm được.**
- Mới thử mẫu tiếng Anh tổng hợp, chưa thử giọng tiếng Việt thật từ trình duyệt.
- Hạn cứng: **01/12/2026**, `gemini-2.5-flash` ngừng hoạt động.

## 3. Việc cần làm tiếp, theo thứ tự ưu tiên

1. Chạy lại smoke test LLM khi `gemini-3.8-flash` ổn định. Nếu vẫn 503: tính model dự phòng, và xem lại timeout 15 giây, thử lại 1 lần của backend.
2. Ghi vài câu tiếng Việt từ trình duyệt, chạy lại smoke test STT (script mẫu đã dùng: gọi `generateContent` với `inline_data` webm, `audioTranscriptionConfig` VERBATIM `vi-VN`).
3. Đo AC-30 (từ upload đến SCORED ≤ 12 giây, 14 mẫu 10–131 giây). Quy trình ở `specs/AI-PIPELINE/test-report.md` dòng 59.
4. Xử lý nợ kỹ thuật trong `docs/knowledge/tech-debt.md`:
   - F3: phiên kẹt `PROCESSING` khi DB chập chờn, cần thu hồi phiên quá hạn.
   - F4: chưa rate limit `/evaluate`, một user có thể lấp đầy queue và tốn quota Gemini.
   - F5: file S3 mồ côi chứa giọng nói khi upload lại hoặc gặp lỗi 409.
   - F2: `PracticeSessionRepository` phụ thuộc ngược vào `dto/ScoringInput`.
5. Quyết định Q10: `weight` trả về là trọng số gốc hay đã chia lại khi Delivery null (hiện lưu gốc).
6. Việc chưa có code: **#155** (endpoint `rescore`, mới có trong `openapi.yaml`), **#121** (TTS), **#163** (thống kê usage, audit log).
7. Cân nhắc dùng `wordTimestamp` của `gemini-3.5-transcribe` để tính WPM thật, thay vì `durationSeconds` do client khai.

## 4. Jira (`DLPVXVTHA`, board 2)

Sprint 3 (id 4, chưa có ngày, **không sửa ngày nữa theo quyết định của Giang**):

| Ticket | Trạng thái | Người |
|---|---|---|
| #119 STT, #120 LLM, #154 chống injection, #156 bất đồng bộ, #160 API phiên và upload | In Review (chờ PR #20 merge rồi chuyển Done) | Giang |
| #152 rubric | To Do (bản v1.1 ở PR #19) | Giang |
| #155 sửa transcript và chấm lại | To Do | Giang |
| #163 thống kê usage, audit log | To Do | Giang |
| #121 TTS | To Do | Giang |
| #161 UI chọn câu hỏi (UC3), #162 UI quản trị câu hỏi (UC8) | To Do | Vũ |
| #126, #142, #149 | To Do | Vũ |
| #115, #117, #118, #122 | Done | Vũ |

Sprint 2 (id 3) vẫn ở trạng thái active, quá hạn từ 22/09, còn #113 In Review. **Chưa đóng sprint** (cần làm trên board). Chứa #153, #157, #158, #159 đã Done. #113 là CI (build/test), #133 là CD (tự động deploy), đã ghi rõ trong mô tả hai ticket.

Việc Jira còn lại: đóng Sprint 2, đặt ngày Sprint 4.

Kết nối Atlassian MCP đang dùng endpoint v1 sắp bị gỡ (01/03/2027). Cần tạo lại connector với `https://mcp.atlassian.com/v2/mcp`.

## 5. Môi trường máy này

- JDK 21 đã cài tại `C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot`. Biến `JAVA_HOME` hệ thống vẫn trống.
- Chạy test backend: bật Docker Desktop, `docker start interview-pg-test` (Postgres 16, cổng 5433), rồi đặt:
  - `JAVA_HOME` trỏ vào JDK 21
  - `DATABASE_URL=jdbc:postgresql://localhost:5433/interview?user=postgres&password=postgres`
  - `JWT_SECRET` là một chuỗi bất kỳ đủ dài
  - `JAVA_TOOL_OPTIONS=-Duser.timezone=Asia/Ho_Chi_Minh` (JDK Windows báo múi giờ `Asia/Saigon`, Postgres 16 từ chối)
- Lệnh `claude` trong Git Bash bị hỏng đường dẫn. Dùng PowerShell.

## 6. Thay đổi chưa commit trên máy

- `docs/Ke_Hoach_Coding.md`: đã tick mục 5 (Jira) một phần.
- `docs/Ban_Giao_Tien_Do_20261117.md`: file này.
- `AGENTS.md` (chưa theo dõi): bản sao quy ước Git cho Codex, chưa quyết định có đưa vào repo không.

## 7. Quy ước nhớ

Commit và mô tả PR không nhắc AI/Claude, không thêm `Co-Authored-By` (theo `CLAUDE.md`). Message commit bắt đầu bằng mã ticket, ví dụ `DLPVXVTHA-156 ...`.
