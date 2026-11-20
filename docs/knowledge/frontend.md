# Frontend (React + Vite)

Thư mục `frontend/`. Cập nhật theo task `specs/20261120-frontend-noi-api-moi`. Chưa có framework test frontend; kiểm bằng `npm run lint` (oxlint), `npm run build` và chạy tay với Prism (`npm run dev:mock`: Prism 4010 + Vite 5173).

## Cấu trúc & quy ước
- `src/api/*.js`: mỗi nhóm API một file (`history.js`, `auth.js`, `practice.js`, `questions.js`, `adminQuestions.js`, `adminAnalytics.js`); trang không gọi `fetch` trực tiếp. Mọi lệnh gọi đi qua `src/api/client.js`.
- `client.js`: `request()` (JSON) và `downloadBlob(path, {params, filename})` (tải file, gửi Bearer qua `buildHeaders` dùng chung). URL = `/api` + path (cùng origin, token không ra ngoài). Chỉ phát `UNAUTHORIZED_EVENT` (đăng xuất) khi status **401**; 403 không đăng xuất. Tên file lấy từ Content-Disposition, lọc qua `sanitizeFilename`; `revokeObjectURL` trễ 4s.
- Thông báo lỗi tập trung ở `src/constants/scoring.js`: `FAILED_MESSAGES` (mã `errorCode` của phiên FAILED, có `FAILED_MESSAGE_FALLBACK` cho mã lạ), `HTTP_ERROR_MESSAGES` và `apiErrorMessage(err, fallback)`. Thứ tự: mã lỗi -> 429 không mã -> 403 -> `fallback ?? err.message`. Trang mới phải gọi `apiErrorMessage`, không in `err.message`/mã thô (trừ nhánh 400 hiển thị thông điệp backend). Có mã lỗi backend mới thì thêm câu vào đây. Một số câu còn là giả định chờ PO: `specs/20261120-frontend-noi-api-moi/assumptions.md`.
- Phân quyền UI: `AuthContext.isAdmin` (`role === 'ADMIN'`), `RequireAdmin` trong `auth/RequireAuth.jsx` bọc route `/admin/*` (`App.jsx`), menu admin trong `layouts/AppLayout.jsx` chỉ hiện khi `isAdmin`. Đây chỉ là UX; chặn thật ở backend (403).
- Component dùng chung: `components/AdminTabs` (tab Câu hỏi / Thống kê), `components/ConfirmDialog` (alertdialog, focus Huỷ, Escape, Tab xoay vòng, khóa khi `busy`). CSS Modules, dùng class chung (card/btn/alert), không thêm thư viện.
- Mock Prism: `mock/build-mock-spec.mjs` + `mock/examples.js` sinh `mock/.generated/openapi.yaml` (git-ignore) có dữ liệu mẫu cho `AdminQuestionPage`, `AnalyticsOverview`... Thêm schema admin mới thì thêm ví dụ vào `examples.js`.
- Mẫu chống race khi đổi filter: cờ `cancelled` trong effect + so `result.key` với `key` (`AdminQuestionsPage.jsx`, `AdminAnalyticsPage.jsx`); tìm kiếm debounce 400ms, đổi filter thì về trang 0.
- Form admin `noValidate`: không validate phía client, dựa vào 400 `fieldErrors` của backend hiển thị dưới từng ô. Prism không thực thi `minLength`, nên mock trả 201 cho body rỗng; muốn thấy lỗi phải giả lập (ghi đè `window.fetch`).

Luồng admin: [flows/admin.md](flows/admin.md). Nợ và đề xuất cho backend: [tech-debt.md](tech-debt.md).

Cập nhật lần cuối: 2026-11-20
