# Giai đoạn E: Frontend (React + Vite)

Thời gian: 22/10 - 20/11/2026. Người làm chính: Tuấn Anh (PR #2-#6 ngày 22/10, #17 mở 01/11 merge 03/11, #22 20/11, #23 đang mở). Giang bổ sung hợp đồng API và nối mã lỗi mới.

## 1. Hiểu nhanh trong 1 phút
- **Một câu:** ứng dụng web cho ứng viên (đăng nhập, chọn câu hỏi, ghi âm, xem kết quả, lịch sử) và cho quản trị viên (câu hỏi, thống kê), gọi backend qua REST có JWT.
- **Hình ảnh đời thường:** quầy lễ tân của hệ thống: nhận bài (ghi âm), phát phiếu hẹn rồi hỏi lại mỗi 2 giây, đến khi có kết quả thì trình bày đẹp và dễ hiểu.
- **Ba ý chính:**
  1. Frontend **code theo mock** sinh từ `openapi.yaml` (Prism), không chờ backend.
  2. Mọi lệnh gọi API đi qua `src/api/client.js`; lỗi đổi thành thông báo tiếng Việt ở một chỗ (`constants/scoring.js`).
  3. Phân quyền ở giao diện chỉ là **UX**; chặn thật nằm ở backend (403).

## 2. Từ điển nhanh
| Từ | Nghĩa |
|---|---|
| SPA | Ứng dụng một trang: chuyển màn bằng router chứ không tải lại trang |
| Vite | Công cụ dev/build frontend rất nhanh |
| Prism | Server giả sinh từ OpenAPI, trả dữ liệu mẫu |
| Proxy `/api` | Dev server chuyển `/api/...` sang backend (`localhost:8080`) nên không dính CORS |
| `MediaRecorder` | API trình duyệt ghi âm từ micro |
| Polling | Gọi lại định kỳ (2 giây) để hỏi trạng thái |
| Hook | Hàm React tái sử dụng logic có trạng thái (`useAudioRecorder`, `useSessionResult`) |
| CSS Modules | CSS gắn với từng component, không đụng nhau |
| `RequireAuth` / `RequireAdmin` | Component chặn route khi chưa đăng nhập / không phải ADMIN |
| oxlint | Công cụ lint nhanh dùng trong CI |

## 3. Thân bài theo bước

### Bước 1. Khung, đăng nhập và định tuyến (#115)
- **Router** (`App.jsx`): công khai `/`, `/login`, `/register`, `/forgot-password`, `/reset-password`; sau đăng nhập `/dashboard`, `/questions`, `/practice`, `/practice/:sessionId`, `/results/:sessionId`, `/history`, `/profile`, `/settings`, `/upgrade`; khu quản trị `/admin/*` bọc `RequireAdmin`.
- **Phiên đăng nhập** (`auth/authStorage.js`): "Ghi nhớ đăng nhập" lưu `localStorage`, không thì `sessionStorage` của tab.
- **`client.js`:** gắn Bearer, URL = `/api` + path (cùng origin nên token không ra ngoài). **Chỉ phát sự kiện đăng xuất khi 401**; 403 không đăng xuất vì nghĩa là "đã đăng nhập nhưng không đủ quyền".
- **Báo lỗi mạng rõ ràng:** gặp 502-504 (backend không với tới) hiện thông báo riêng.

### Bước 2. Dev với mock (`npm run dev:mock`)
`mock/build-mock-spec.mjs` + `mock/examples.js` dựng `mock/.generated/openapi.yaml` có dữ liệu mẫu (không phải "string" hay số âm), chạy Prism ở cổng 4010 và Vite cùng lúc. **Hạn chế đã gặp:** Prism không thực thi `minLength`, nên form gửi rỗng vẫn trả 201; muốn thử nhánh 400 phải giả lập phản hồi.

### Bước 3. Chọn câu hỏi (UC3) và phòng luyện tập (#117)
- **Ngân hàng câu hỏi** (`QuestionsPage`): lọc theo ngành, vị trí, mức, từ khóa, có phân trang.
- **Ghi âm** (`hooks/useAudioRecorder.js`): chọn MIME được trình duyệt hỗ trợ (`isTypeSupported`), xin quyền micro (`getUserMedia`), ghi bằng `MediaRecorder`, đếm `elapsed`, **tự dừng khi chạm `maxSeconds`** (180 giây), cho nghe lại, ghi lại, rồi upload. Tạo phiên bằng `POST /practice-sessions` rồi `POST /{id}/answer` (multipart gồm `audio` và `durationSeconds`) và `POST /{id}/evaluate`.
- **Đã bỏ khung STAR cố định** vì chỉ hợp câu hành vi; giao diện hiển thị theo loại câu hỏi (rubric theo loại).

### Bước 4. Polling và màn kết quả (#122, #125)
- **`useSessionResult`:** gọi `GET /practice-sessions/{id}` mỗi 2 giây khi `PROCESSING`; `SCORED` thì lấy `/result`; `FAILED` thì hiện lý do. Có cơ chế `runRef` để vòng polling cũ trả về muộn **bị bỏ qua** (tránh ghi đè trạng thái mới).
- **Màn kết quả (`ResultsPage.jsx`):** `HeroCard` (tổng điểm), `FeedbackCard` (điểm mạnh/cần cải thiện từ lập luận tiêu chí), `CriteriaCard` (điểm, lý do, trích dẫn; trích dẫn không khớp có cảnh báo), `DeliveryCard` (WPM, từ đệm), `TranscriptCard` + `TranscriptEditor` (sửa transcript và chấm lại, không ghi âm lại), câu trả lời mẫu. **Mới 22/11:** khối "Đối chiếu với đáp án tham chiếu" và "Chỗ cần sửa" (giai đoạn F).
- **Nút nào hiện khi nào:** "Gửi chấm lại" chỉ hiện khi phiên `FAILED` (và lỗi không phải `ANSWER_TOO_SHORT`); phiên đã `SCORED` muốn chấm lại thì bấm "Sửa transcript & chấm lại" ở thẻ Transcript.

### Bước 5. Lịch sử (#118) và Dashboard
`HistoryPage` gọi `GET /history` (lọc thời gian, ngành, điểm) để tìm lại kết quả; chi tiết gọi `GET /history/{id}`. **Lưu ý:** API này nằm trong PR #18 (merge 20/11); nhánh nào chưa gộp `main` sẽ không có `/history` (đã gặp ngày 22/11).

### Bước 6. Quản trị (UC8) và thống kê (#162, PR #22)
- `AdminQuestionsPage`: danh sách 10 dòng/trang, lọc trạng thái và từ khóa (debounce 400ms), thêm/sửa/xóa mềm có `ConfirmDialog`; `referenceAnswer` chỉ gửi khi loại là `TECHNICAL`.
- `AdminAnalyticsPage`: tổng quan và **xuất CSV** qua `downloadBlob`; chặn gọi khi `from > to`; `estimatedCost` kèm nhãn "ước tính".
- **Chống race khi đổi bộ lọc:** cờ `cancelled` trong `useEffect` và so `result.key` với `key`.
- **Form `noValidate`:** hiển thị `fieldErrors` 400 của backend dưới từng ô, không tự kiểm.

### Bước 7. Thông báo lỗi tập trung (`constants/scoring.js`)
`FAILED_MESSAGES` (mã `errorCode` của phiên) và `HTTP_ERROR_MESSAGES`; `apiErrorMessage(err, fallback)` trả thông báo tiếng Việt theo thứ tự: mã lỗi riêng → 429 chung → 403 → fallback. Có mã lỗi backend mới (ví dụ `PROCESSING_TIMEOUT`, `TOO_MANY_PROCESSING`, `DAILY_LIMIT_EXCEEDED`) thì thêm câu vào đây; trang không in `err.message` thô.

## 4. Luồng nên nói được: luyện một câu
`Chọn câu hỏi → /practice → xin quyền micro → ghi âm (≤180s) → nghe lại → nộp: POST /practice-sessions → POST /answer (multipart) → POST /evaluate (202) → chuyển /results/:id → useSessionResult poll 2s → PROCESSING … → SCORED → GET /result → vẽ điểm, tiêu chí, Delivery, transcript`.

## 5. Khung giảng lại
**Nói (45 giây):** "Frontend React/Vite, chuyển màn bằng router, gọi API qua một client chung gắn JWT. Ghi âm bằng MediaRecorder, nộp rồi poll mỗi 2 giây, có kết quả thì hiển thị theo rubric kèm trích dẫn và cho sửa transcript chấm lại. Mình dùng Prism để làm song song với backend."

| Câu hỏi có thể bị hỏi | Gợi ý trả lời |
|---|---|
| Vì sao poll mà không WebSocket? | Đơn giản, đủ cho khoảng chờ vài đến chục giây; hợp với kiến trúc chấm bất đồng bộ 202 |
| Phân quyền admin ở frontend có an toàn không? | Chỉ là UX; chặn thật ở backend bằng 403 |
| Vì sao 401 mới đăng xuất, 403 thì không? | 401 là chưa/hết đăng nhập; 403 là đã đăng nhập nhưng thiếu quyền |
| Làm sao tránh kết quả cũ ghi đè mới khi polling? | `runRef` tăng mỗi lần chạy; phản hồi cũ thấy `run` khác nên bỏ qua |
| Hạn chế nên nói thẳng | Chưa có test tự động frontend (chỉ lint, build, kiểm tay với Prism); i18n Vi/En (#149) còn To Do theo bàn giao 17/11 |

## 6. Câu hỏi ôn
1. Nếu bỏ `runRef` khỏi `useSessionResult`, tình huống nào gây hiển thị sai?
2. Người dùng bấm "Ghi lại" rồi nộp lại cùng phiên. Backend xử lý file cũ ra sao?
3. Vì sao dev dùng proxy `/api` thay vì gọi thẳng `localhost:8080`?
4. Một phiên `FAILED` do `ANSWER_TOO_SHORT`. Vì sao không hiện nút "Gửi chấm lại"?
5. Vì sao `AdminTabs` từng hiện thanh cuộn dọc chỉ trên Chrome Windows?

## 7. Đáp án
1. Người dùng đổi sang phiên khác hoặc rời trang trong lúc một lần poll cũ đang chờ; phản hồi cũ trả về muộn có thể ghi đè trạng thái của phiên mới.
2. Backend xóa file S3 cũ best-effort khi nộp lại (F5), file mới thay khóa trong DB.
3. Cùng origin nên không dính CORS và token không đi ra miền khác; giống môi trường chạy thật hơn.
4. Chấm lại với **cùng** transcript quá ngắn vẫn quá ngắn; phải **sửa transcript** (ghi âm lại hoặc sửa chữ) rồi mới chấm lại được.
5. `.tab { margin-bottom: -1px }` làm tab nhô 1px khỏi `<nav>` có `overflow-x: auto`; một trục là `auto` thì trục kia thành `auto`, nên có cuộn dọc. Ghi trong `docs/knowledge/lessons-learned.md`.
