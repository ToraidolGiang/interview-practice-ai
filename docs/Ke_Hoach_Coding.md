# Kế hoạch coding

- Cập nhật: 22/10/2026, dựa trên backlog Jira `DLPVXVTHA` (65 ticket, Sprint 1-4)
- Phạm vi: EP3 (Setup), EP4 (Coding), EP5 (Testing), EP6 (Deploy). EP7 (Mở rộng) chỉ làm khi còn thời gian.
- Tài liệu thiết kế tham chiếu: `docs/api/openapi.yaml` (v0.2.0), `docs/business/Rubric_Cham_Diem.md` (rubric-v1.0), `docs/architecture/Data_Dictionary.md`, `docs/business/Danh_Muc_Nganh_Vi_Tri.md`

## 1. Hiện trạng (22/10/2026)

- Backend mới có khung thư mục 3-layer và migration `V1__init.sql`; frontend là template Vite. Toàn bộ EP4 đang To Do.
- Sprint 2 (08/09-22/09) đã quá hạn nhưng chưa đóng; Sprint 3, 4 chưa có ngày.
- Đang làm: #111 (DB + migration, Giang), #114 (seed câu hỏi, Vũ; script ở `scripts/dataset/`).

## 2. Phân vai

| | **Trường Giang** | **Tuấn Anh Vũ** |
|---|---|---|
| Vai trò | Backend core + AI pipeline + Deploy | Frontend + Dữ liệu & chất lượng AI + một số chức năng trọn gói (backend + frontend) |
| Thư mục sở hữu | `backend/**` (trừ phần của Vũ bên dưới), `docs/api/openapi.yaml` | `frontend/**`, `scripts/dataset/**`, `data/**`, migration seed `V2__seed_*.sql`; code backend của #118, #123, #157 |
| Ticket | #111, #112, #113, #116, #119, #120, #121, #154, #155, #156, #129, #130, #131, #132, #133 | #114, #115, #117, #118, #122, #123, #125, #126, #127, #128, #149, #157, #159 |

Thay đổi so với Jira ban đầu (cần cập nhật assignee trên Jira):
- **#123 Delivery** (Giang → Vũ): hàm thuần tính bằng code, gắn với hiệu chỉnh dữ liệu ở #159.
- **#118 Lịch sử luyện tập** (Giang → Vũ): API chỉ đọc + giao diện, làm trọn gói.
- **#157 Quên mật khẩu** (Giang → Vũ): chức năng độc lập, làm trọn gói.
- **#159 Vòng đo 1** (chưa giao → Vũ): Vũ xây bộ dữ liệu chuẩn và tính chỉ số; Giang hỗ trợ chạy pipeline và chỉnh prompt.

Ranh giới khi làm code backend trong phần của Vũ: dùng entity/repository, `SecurityConfig` và cấu trúc package do Giang dựng ở #111, #112; không tự sửa các phần dùng chung đó, cần đổi thì nhắn Giang.

## 3. Lộ trình theo giai đoạn

Thứ tự trong mỗi cột là thứ tự nên làm. Giai đoạn sau chỉ bắt đầu khi các ticket chặn (ghi trong ngoặc) đã xong.

### Giai đoạn A: Nền móng (hoàn tất Sprint 2)

| Giang | Vũ |
|---|---|
| **#111** Chạy migration cùng app, viết entity + repository (chặn #112, #116, #118) | **#114** Chạy hết `normalize_questions.py`, duyệt câu hỏi, viết `V2__seed_questions.sql` |
| **#112** API đăng ký/đăng nhập, JWT 24h, RBAC | Khung frontend: router, layout, API client gắn JWT, mock server sinh từ `openapi.yaml` |
| **#113** GitHub Actions: build + test khi push/PR | **#115** Giao diện đăng nhập/đăng ký (dùng mock, nối API thật khi #112 xong) |

### Giai đoạn B: Luồng chính tối thiểu (Sprint 3)

Mục tiêu: chọn câu hỏi → ghi âm → upload → chấm điểm → xem kết quả, chạy được từ đầu đến cuối.

| Giang | Vũ |
|---|---|
| **#116** `GET /questions` (lọc, gồm vị trí `Chung`), `/questions/random`, admin CRUD | Giao diện chọn câu hỏi UC3 *(ticket mới)* |
| Tạo phiên luyện tập + upload audio lên S3 *(ticket mới)* | **#117** Ghi âm MediaRecorder, nghe lại, ghi lại, upload |
| **#119** Adapter STT, prompt yêu cầu phiên âm nguyên văn (giữ từ đệm) | **#123** `DeliveryCalculator` (WPM, từ đệm `filler-vi-v1`) + unit test |
| **#120** Prompt + logic chấm điểm LLM theo rubric-v1.0 | **#122** Màn hình kết quả: tổng điểm, điểm từng tiêu chí, trích dẫn, cảnh báo |
| **#156** Chấm bất đồng bộ: 202 + `PROCESSING`, `EvaluationExecutor` | Polling `GET /practice-sessions/{id}` mỗi 2 giây trong #122 |
| **#154** Chống prompt injection, kiểm tra trích dẫn | **#125** Khối Delivery trong màn hình kết quả |

**Mốc đo sớm (#159):** ngay khi #119 + #120 + #123 chạy được, đo trên tập chỉnh (khoảng 70% bộ dữ liệu). Vũ bắt đầu xây bộ 100-150 câu trả lời chuẩn **ngay từ bây giờ**, không chờ code. Cổng quyết định: nếu QWK vẫn thấp sau 2-3 vòng chỉnh hoặc độ trễ STT + LLM vượt 12 giây thì đổi pipeline ngay, trước khi làm tiếp giai đoạn C.

### Giai đoạn C: Hoàn thiện chức năng (Sprint 3 → 4)

| Giang | Vũ |
|---|---|
| **#155** Sửa transcript và chấm lại (`/rescore`, không gọi lại STT) | Giao diện sửa transcript trong màn hình kết quả (thuộc #122/#155) |
| **#121** Adapter TTS (FPT.AI) đọc phản hồi | **#118** Lịch sử: API + giao diện, lọc theo thời gian/ngành/điểm |
| Thống kê API usage, audit log cho admin *(ticket mới)* | **#157** Quên mật khẩu: API, `MailService` (SMTP), giao diện |
| | Giao diện quản trị câu hỏi UC8 *(ticket mới)* |
| | **#149** i18n Vi/En |

### Giai đoạn D: Kiểm thử và triển khai (Sprint 4)

| Giang | Vũ |
|---|---|
| **#131** Dockerfile → **#132** Deploy lên Render → **#133** Tự động deploy khi merge | **#126** Unit test: chấm điểm, ghi âm, xác thực |
| **#130** Sửa lỗi theo phản hồi người dùng | **#127**, **#128** Kịch bản test, thử với người dùng thật |
| **#129** Vòng đo 2 (chốt) trên môi trường đã deploy | Tập giữ lại (30%), script đánh giá, bảng kết quả cho báo cáo #142 |

### EP7 Mở rộng (khi còn thời gian)

#124 (độ tự tin qua giọng nói), #134 (câu hỏi tiếng Anh), #135 (pipeline tiếng Anh), #143 (Realtime/Live API).

## 4. Quy tắc làm việc chung

1. **Contract API là `docs/api/openapi.yaml`.** Frontend code theo mock, không chờ backend. Muốn đổi API: Giang sửa contract trong PR riêng, cả hai đồng ý, rồi mới sửa code.
2. **Nhánh:** mỗi ticket một nhánh `feature/DLPVXVTHA-<số>-mo-ta-ngan` (tài liệu: `docs/...`), tách từ `main` mới nhất. Không commit thẳng vào `main`.
3. **Commit:** bắt đầu bằng mã ticket để Jira tự liên kết, ví dụ `DLPVXVTHA-116 Them API loc cau hoi`.
4. **Pull request:** người còn lại review trước khi merge; CI phải xanh.
5. **Hoàn thành (Definition of Done):** đạt "Tiêu chí hoàn thành" ghi trong ticket (nhiều ticket yêu cầu unit test cụ thể), CI xanh, đã review, đã cập nhật tài liệu nếu đổi thiết kế.
6. **Bí mật:** API key chỉ để trong `.env` (đã gitignore), không ghi vào `.env.example` hay code.

## 5. Việc cần cập nhật trên Jira

- [ ] Đổi assignee: #118, #123, #157 sang Vũ; giao #159 cho Vũ.
- [ ] Tạo ticket mới: API tạo phiên luyện tập + upload audio S3 (Giang); giao diện chọn câu hỏi UC3 (Vũ); giao diện quản trị câu hỏi UC8 (Vũ); thống kê API usage + audit log cho admin (Giang).
- [ ] Đóng Sprint 2, đặt ngày cho Sprint 3, 4; xếp #152-#159 vào sprint.
- [ ] Ghi rõ ranh giới #113 (CI build/test) và #133 (CD tự động deploy).
