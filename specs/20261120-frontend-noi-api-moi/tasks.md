# Tasks: Frontend nối API mới
Thứ tự ưu tiên người dùng: mã lỗi -> #161 -> #162 -> rà khớp + analytics. Chạy trong `frontend/`. Test chung mọi WP: `npm run lint` và `npm run build` (không thêm test, D5). Wave 1 phải xong trước các wave sau.

## Wave 1 — nền tảng (một WP, đụng toàn bộ file dùng chung)
- [x] T1 (WP-A): Nền tảng dùng chung
  - Files: src/constants/scoring.js, src/api/client.js, src/auth/AuthContext.jsx, src/auth/RequireAuth.jsx, src/layouts/AppLayout.jsx (nhóm "Quản trị" trong AccountMenu, link /admin/questions, /admin/analytics khi isAdmin)
  - Đọc trước: src/api/client.js:16-52; src/constants/scoring.js:95-110; src/auth/AuthContext.jsx:15-45; src/auth/RequireAuth.jsx; src/layouts/AppLayout.jsx:75-132
  - Phụ thuộc: —
  - AC: AC-6, AC-7, AC-10, AC-11 (một phần), AC-25
  - UI: có (menu)
  - Ngân sách: ≤ 30 tool-use
  - Test phạm vi: `npm run lint`; `npm run build`; thủ công: ADMIN thấy nhóm Quản trị, CANDIDATE không
  - DoD: `FAILED_MESSAGES` chỉ THÊM PROCESSING_TIMEOUT/INTERNAL_ERROR + fallback chung; `HTTP_ERROR_MESSAGES` + `apiErrorMessage(err, fallback)`; `buildHeaders` + `downloadBlob` (Bearer, 401 event, lỗi JSON -> ApiError, tên file fallback); `isAdmin`, `RequireAdmin` (về /dashboard); menu admin trong AccountMenu có Escape/bàn phím sẵn; lint/build sạch; không đổi ApiError và `request()` ngoài việc dùng `buildHeaders`

## Wave 2 — song song (không chung file)
- [x] T2 (WP1): Áp mã lỗi vào PracticePage + ResultsPage
  - Files: src/pages/PracticePage.jsx, src/pages/ResultsPage.jsx
  - Đọc trước: src/pages/PracticePage.jsx:70-112; src/pages/ResultsPage.jsx:130-160; src/pages/ResultsPage.jsx:625-660; src/constants/scoring.js (phần T1 thêm)
  - Phụ thuộc: T1
  - AC: AC-1..AC-7
  - UI: có (thông báo lỗi `role="alert"` đã dùng)
  - Ngân sách: ≤ 25 tool-use
  - Test phạm vi: lint; build; thủ công Prism `Prefer: code=429` ở evaluate/rescore; FAILED với PROCESSING_TIMEOUT/INTERNAL_ERROR/mã lạ; 403
  - DoD: `submitErrorMessage` và retry/rescore dùng `apiErrorMessage` sau nhánh SESSION_PROCESSING/400 hiện có; 429 không điều hướng, transcript rescore còn nguyên; FailedCard giữ nút Chấm lại cho timeout/internal; không rải chuỗi mới trong page
- [x] T3 (WP2): Rà soát QuestionsPage (#161)
  - Files: src/pages/QuestionsPage.jsx (chỉ sửa nếu tìm ra lỗ hổng nhỏ), specs/20261120-frontend-noi-api-moi/test-report.md (biên bản UC3)
  - Đọc trước: src/pages/QuestionsPage.jsx:25-75; 193-244; 275-315; src/api/questions.js; docs/api/openapi.yaml (`/questions`, `/questions/random`)
  - Phụ thuộc: T1
  - AC: AC-8, AC-9
  - UI: có
  - Ngân sách: ≤ 20 tool-use
  - Test phạm vi: lint; build; thủ công list/filter/random/404 random/rỗng/lỗi/phân trang
  - DoD: biên bản UC3 <-> màn hình; chỉ vá trạng thái loading/lỗi/rỗng/404 random nếu thiếu; mục mới ngoài đó -> hỏi, không làm (Q2); không hồi quy
- [x] T4 (WP4a): Rà khớp history/forgot/reset/rescore với openapi
  - Files: src/api/history.js, src/api/auth.js (chỉ sửa nếu lệch), src/pages/HistoryPage.jsx, ForgotPasswordPage.jsx, ResetPasswordPage.jsx (chỉ sửa nếu lệch)  - Đọc trước: src/api/history.js; src/api/auth.js; docs/api/openapi.yaml (`/history`, `/auth/forgot-password`, `/auth/reset-password`, `rescore`); src/api/practice.js
  - Phụ thuộc: T1
  - AC: AC-24
  - UI: không
  - Ngân sách: ≤ 20 tool-use
  - Test phạm vi: lint; build; thủ công forgot/reset/history trên Prism
  - DoD: mỗi lời gọi đối chiếu tham số/trường/mã lỗi; lệch frontend sửa, lệch backend ghi đề xuất cho Giang; ghi kết quả vào `specs/.../progress/T4.md` (T9 hợp nhất vào test-report)

## Wave 3 — admin (T5 trước nhờ api/route chung; T6 song song T5 vì khác file)
- [x] T5 (WP3): Quản trị câu hỏi `/admin/questions`
  - Files: src/api/adminQuestions.js, src/pages/AdminQuestionsPage.jsx + .module.css, src/components/ConfirmDialog.jsx + .module.css, src/components/AdminTabs.jsx + .module.css (thanh tab con Câu hỏi | Thống kê, dùng bởi T6), src/App.jsx (thêm route `/admin/questions`)
  - Đọc trước: docs/api/openapi.yaml:624-772 và 1138-1170, 1308-1330 (ErrorResponse fieldErrors); src/pages/QuestionsPage.jsx:25-75 (pattern fetch/filter); src/components/Pagination.jsx; src/constants/taxonomy.js:5-55; src/components/Breadcrumb.jsx
  - Phụ thuộc: T1
  - AC: AC-10..AC-20
  - UI: có (chuẩn engineering-standards mục 8: loading/lỗi/rỗng, bàn phím, xác nhận phá hủy; kiểm 390px và 1280px)
  - Ngân sách: ≤ 30 tool-use (nếu vượt: tách form thành WP riêng, báo orchestrator)
  - Test phạm vi: lint; build; thủ công trên Prism (cần T8 để có ví dụ) hoặc backend thật
  - DoD: danh sách size 10 (D4) lọc status mặc định "Tất cả" + keyword (debounce); nhãn "Đã ẩn"; form thêm/sửa (select taxonomy + option tạm ngoài danh mục; referenceAnswer chỉ khi TECHNICAL; fieldErrors dưới trường; 409/404/403 qua `apiErrorMessage`); ConfirmDialog alertdialog (focus, Escape, trap Tab); sau xóa tải lại, rỗng và page>0 thì lùi 1 trang; khóa nút khi đang gửi; bảng cuộn ngang/thẻ <=600px; không hứa "khôi phục"
- [x] T6 (WP4b): Trang `/admin/analytics`
  - Files: src/api/adminAnalytics.js, src/pages/AdminAnalyticsPage.jsx + .module.css (KHÔNG sửa App.jsx; route thêm ở T7)
  - Đọc trước: docs/api/openapi.yaml:773-806, 842-885, 1389-1418; src/api/client.js (downloadBlob từ T1); src/components/Breadcrumb.jsx
  - Phụ thuộc: T1 (dùng AdminTabs của T5 -> import sau ở T7 nếu cần; T6 tự dùng Breadcrumb)
  - AC: AC-21, AC-22 (AC-23 không làm theo Q4)
  - UI: có (mục 8; 390px/1280px)
  - Ngân sách: ≤ 25 tool-use
  - Test phạm vi: lint; build; thủ công overview trên Prism; CSV trên backend thật
  - DoD: from/to date, validate from<=to; loading/lỗi/rỗng; averageScore null -> "Chưa có"; estimatedCost số + "ước tính" (D6); aiApiCalls stt/llm/tts; "Xuất CSV" qua downloadBlob, khóa khi đang tải, lỗi 400/403 hiển thị; không xlsx; không có màn chi tiết user

## Wave 4 — gom file chung + mock + nghiệm thu
- [x] T7: Nối route analytics + thanh tab
  - Files: src/App.jsx, src/pages/AdminAnalyticsPage.jsx (thêm `AdminTabs`)
  - Đọc trước: src/App.jsx:33-46; src/components/AdminTabs.jsx; src/pages/AdminAnalyticsPage.jsx (đầu file)
  - Phụ thuộc: T5, T6
  - AC: AC-10, AC-11, AC-21
  - UI: có
  - Ngân sách: ≤ 10 tool-use
  - Test phạm vi: lint; build; thủ công CANDIDATE gõ `/admin/analytics` -> /dashboard
  - DoD: route `/admin/analytics` bọc RequireAdmin; AdminTabs hiển thị đúng tab hiện hành ở 2 trang
- [x] T8: Mock Prism cho endpoint admin
  - Files: frontend/mock/examples.js, (đọc) frontend/mock/build-mock-spec.mjs
  - Đọc trước: mock/examples.js:1-10, 85-100; mock/build-mock-spec.mjs (phần chèn example/allOf); docs/api/openapi.yaml:1138-1147, 1308-1330, 1389-1418
  - Phụ thuộc: T5 (để biết trường UI dùng) — có thể chạy cùng wave 4 vì khác file với T7
  - AC: hỗ trợ nghiệm thu AC-12, AC-21
  - UI: không
  - Ngân sách: ≤ 15 tool-use
  - Test phạm vi: `npm run mock` khởi động được; GET admin trả ví dụ có HIDDEN + referenceAnswer; averageScore null; lint; build
  - DoD: thêm AdminQuestion, AdminQuestionPage, AnalyticsOverview; xác nhận allOf xử lý đúng (nếu không, gắn ví dụ ở response); export CSV ghi chú không kiểm trên mock
- [ ] T9: Nghiệm thu cuối + test-report phần frontend
  - Files: specs/20261120-frontend-noi-api-moi/test-report.md, frontend/README.md (sửa dòng 30 nhắc assets/figma không tồn tại, nếu doc-keeper chưa làm)
  - Đọc trước: tasks.md; progress/T4.md; test-report.md (T3)
  - Phụ thuộc: T7, T8
  - AC: AC-8, AC-24, AC-25
  - UI: có (chụp 390px/1280px vào specs/.../ui/ một lần nếu có công cụ trình duyệt, nếu không ghi "UI chưa soi bằng mắt")
  - Ngân sách: ≤ 15 tool-use
  - Test phạm vi: `npm run lint` và `npm run build` toàn bộ
  - DoD: lint/build 0 lỗi; bảng AC -> kết quả thủ công; bảng đối chiếu openapi; danh sách đề xuất cho Giang (Q4, Q6, Q8, audit log)

## Ghi chú song song
- Wave 2 và 3 có thể chạy worktree riêng; T2/T3/T4 không chung file nhau; T5/T6 không chung file. Mọi file chung (client.js, AuthContext, RequireAuth, scoring.js, AppLayout) chỉ ở T1; App.jsx chỉ ở T5 (route questions) rồi T7 (route analytics) — khác wave nên không xung đột.
