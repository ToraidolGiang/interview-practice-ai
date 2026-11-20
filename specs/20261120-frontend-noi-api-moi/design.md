# Thiết kế: Frontend nối API mới (mã lỗi, #161, #162, analytics)

## Tóm tắt giải pháp
Chỉ sửa `frontend/**`. Thêm nền tảng dùng chung (hàm tải blob có JWT, `isAdmin` + `RequireAdmin`, hằng thông điệp 429/403 + hàm `apiErrorMessage`, route/menu admin) rồi 3 nhóm việc song song được: áp mã lỗi vào PracticePage/ResultsPage; rà QuestionsPage; trang `/admin/questions` (CRUD + hộp thoại xóa) và `/admin/analytics` (overview + CSV). Không đổi ApiError/hook, không thêm thư viện, không thêm test (D5/Q7).

## Phương án đã cân nhắc
### D7 — vị trí menu admin
| Phương án | Ưu | Nhược | Chọn? |
|---|---|---|---|
| A. Thêm 2 mục vào NAV_ITEMS (AppLayout.jsx:9-15) | Dễ thấy | Nav ngang đã 4 mục, tràn ở <=600px (I10); lẫn menu ứng viên | Loại |
| B. 1 mục nav "Quản trị" (-> /admin/questions) chỉ ADMIN thấy | Nổi bật | Vẫn thêm 1 mục vào nav hẹp; 2 trang admin cần điều hướng qua lại | Loại |
| C. Nhóm "Quản trị" trong AccountMenu (AppLayout.jsx:109-128), 2 link chỉ ADMIN thấy, đặt trước divider; thêm thanh tab con trong trang admin (2 NavLink) | Không tràn nav; không lặp lối vào; AccountMenu đã có Escape/click-ngoài/role=menu | Ẩn hơn một bậc (1 click) | **Chọn** |
**Lý do chọn C:** nav chính là của ứng viên (Figma), admin là thiểu số; tránh tràn nav; hạ tầng menu đã có truy cập bàn phím. Hai trang admin liên thông qua thanh tab con dùng chung (nằm trong WP3, WP4 dùng lại).

### Các quyết định khác
| Chủ đề | Quyết định | Phương án loại và lý do |
|---|---|---|
| Role lỗi thời/thiếu | `isAdmin = user?.role === 'ADMIN'`; thiếu role = không ADMIN. Không có endpoint hồ sơ trả role trong openapi (chỉ LoginResponse openapi:1090) nên không gọi lại. 403 hiển thị AC-19 | Gọi lại hồ sơ: không có endpoint, loại |
| Câu hỏi cũ ngoài taxonomy khi Sửa | Select thêm option tạm "<giá trị> (ngoài danh mục)" giữ nguyên giá trị hiện có | Ép chọn lại: mất dữ liệu âm thầm |
| Xóa hết trang | Sau DELETE tải lại; nếu `content` rỗng và page>0 thì `setPage(page-1)` (một lần) | Luôn về trang 0: mất ngữ cảnh |
| Tải CSV | `downloadBlob(path, params)` trong client.js; tách `buildHeaders` dùng chung với `request` | Link `<a href>`: thiếu Authorization; đọc `.text()`: hỏng BOM |
| 429/403 | Hằng `HTTP_ERROR_MESSAGES` + `apiErrorMessage(err, fallback)` ở constants/scoring.js (D1: không sửa ApiError) | Sửa trong client.js: đổi hành vi toàn app |
| Mock Prism admin | Thêm `AdminQuestion`, `AdminQuestionPage`, `AnalyticsOverview` vào `SCHEMA_EXAMPLES` (mock/examples.js:91) — WP riêng cuối vì cần kiểm `build-mock-spec.mjs` với allOf; CSV kiểm trên backend thật (I12) | Bỏ mock: mất khả năng kiểm thủ công UI admin |
| estimatedCost (D6) | Hiển thị số + nhãn "ước tính", không ký hiệu tiền | Gắn $: chưa biết đơn vị (hỏi Giang) |

## Ảnh hưởng
Xem impact.md (G1-G8, I1-I20). Bổ sung xác minh khi thiết kế: PracticePage `canReuseUpload` (PracticePage.jsx:92) cho UPLOADED nên nộp lại sau 429 chỉ gọi lại upload với blob hiện có/evaluate, phiên không điều hướng (submit catch :77-79 chỉ set lỗi) -> AC-3 đạt khi map 429 ở `submitErrorMessage` (:108-112).

## Thay đổi chi tiết theo thành phần
- **constants/scoring.js**: thêm key `PROCESSING_TIMEOUT`, `INTERNAL_ERROR` vào `FAILED_MESSAGES` (chỉ thêm); fallback mã lạ -> thông điệp chung không lộ mã; `HTTP_ERROR_MESSAGES {TOO_MANY_PROCESSING, DAILY_LIMIT_EXCEEDED, FORBIDDEN, TOO_MANY_REQUESTS}`; `apiErrorMessage(err, fallback)` theo `err.code` rồi `err.status` (429 không code -> "thử lại sau", 403 -> "không có quyền").
- **api/client.js**: `buildHeaders(auth, accept)` dùng chung; `downloadBlob(path, {params, filename})` fetch + Bearer + 401 event giống `request`, lỗi parse JSON -> ApiError, thành công `blob` -> `createObjectURL` -> `<a download>` -> `revoke`; tên file từ Content-Disposition, fallback do caller truyền.
- **auth/AuthContext.jsx**: thêm `isAdmin` vào value (AuthContext.jsx:33-36). **auth/RequireAuth.jsx**: `RequireAdmin` (không admin -> `<Navigate to="/dashboard" replace />`).
- **App.jsx**: route `/admin/questions`, `/admin/analytics` bọc `RequireAdmin` trong `RequireAuth > AppLayout`. **layouts/AppLayout.jsx**: nhóm "Quản trị" trong AccountMenu khi `isAdmin`.
- **api/adminQuestions.js**: list(params status/keyword/page/size), create, update, remove. **api/adminAnalytics.js**: getOverview(from,to), exportCsv(from,to) dùng downloadBlob (format=csv cố định, không xlsx).
- **pages/AdminQuestionsPage(+css)**: bảng (thẻ ở <=600px), lọc status/keyword, `Pagination`, size 10 (D4), nhãn "Đã ẩn" cho HIDDEN, cột referenceAnswer rút gọn; **AdminQuestionForm** (modal/panel): select taxonomy, referenceAnswer chỉ khi TECHNICAL (D3), fieldErrors theo trường, 409 DUPLICATE_QUESTION, 404 -> làm mới; **ConfirmDialog** (role="alertdialog", focus vào nút Hủy, Escape đóng, trap Tab, cảnh báo "câu đã có người luyện sẽ chỉ bị ẩn").
- **pages/AdminAnalyticsPage(+css)**: from/to `type=date`, validate from<=to, loading/lỗi/rỗng, thẻ số, averageScore null -> "Chưa có", nút "Xuất CSV" (disabled khi đang tải), ghi chú chỉ hỗ trợ CSV.
- **Trang ResultsPage/PracticePage**: thay `err.message` bằng `apiErrorMessage`; rescore giữ nguyên state transcript ở nhánh lỗi.

## Hợp đồng
Không đổi. Dùng: `GET/POST /admin/questions`, `PUT/DELETE /admin/questions/{id}`, `GET /admin/analytics/overview`, `GET /admin/analytics/export?format=csv`. Đề xuất cho Giang (ghi trong test-report/README, không sửa openapi): thêm `GET /admin/analytics/users` hoặc userId (Q4); `status` trong QuestionUpsertRequest hoặc endpoint khôi phục (Q6); đơn vị `estimatedCost` (Q8); endpoint đọc audit log.

## Dữ liệu & migration
Không. Cấu trúc `talentstar.auth` không đổi.

## Bảo mật · Hiệu năng · Đồng thời
- Chặn UI chỉ là tiện ích; backend 403 là chuẩn. Email chỉ hiện ở màn admin. Không log token; CSV gửi Bearer. React tự escape nội dung câu hỏi (không `dangerouslySetInnerHTML`).
- Hiệu năng: phân trang server (size 10); keyword debounce ~400 ms. Đồng thời: hủy/bỏ qua phản hồi cũ khi đổi bộ lọc (cờ `ignore` trong effect, như pattern QuestionsPage); khóa nút Lưu/Xóa khi đang gửi (chống double submit).

## Tương thích ngược, rollout & rollback
Chỉ thêm; revert commit là hoàn nguyên. Phiên FAILED với mã lạ đổi thông điệp (chủ ý AC-2).

## Chiến lược test (AC -> kiểm)
Không thêm test tự động (D5). Nghiệm thu: `npm run lint` + `npm run build` mỗi WP (AC-25) + kịch bản thủ công.
| AC | Loại | Vị trí/cách | Ghi chú |
|---|---|---|---|
| AC-1..2 | Thủ công Prism | ResultsPage, session FAILED có errorCode | sửa example |
| AC-3..5 | Thủ công Prism | `Prefer: code=429` evaluate/rescore | kiểm transcript còn |
| AC-6, 19 | Thủ công | `Prefer: code=403` | không đăng xuất |
| AC-7 | Review mã | grep chuỗi trong pages | |
| AC-8..9 | Thủ công | biên bản UC3 trong test-report | |
| AC-10..11 | Thủ công | đăng nhập ADMIN/CANDIDATE, gõ URL | session thiếu role |
| AC-12..18, 20 | Thủ công Prism/backend | trang admin | 390px và 1280px |
| AC-21..22 | Thủ công | overview Prism; CSV trên backend thật | |
| AC-23 | Không làm (Q4) | | |
| AC-24 | Đối chiếu | bảng trong test-report | |
| AC-25 | lint, build | frontend/ | |

## Rủi ro còn lại
R1 retry 429 mất transcript (kiểm tay); R2 CSV (backend thật); R3 role stale (403 xử lý); R4 ngoài taxonomy (option tạm); R5 menu hẹp (đã chọn C); R6 mock thiếu ví dụ CSV; build-mock-spec với allOf chưa kiểm.

## Giả định cần xác nhận
| Giá trị | Chỗ nằm | Ai xác nhận / ai sửa |
|---|---|---|
| Câu thông báo 429/403/timeout/internal (tiếng Việt do tôi đề xuất) | constants/scoring.js | Vũ/PO; chỉ lập trình viên sửa (chưa có UI) |
| Không nêu số hạn mức (3 phiên/20 lượt) | scoring.js | Giang (cấu hình `app.scoring.*`) |
| Admin = `user.role === 'ADMIN'`, thiếu role = không admin | AuthContext.jsx | Giang xác nhận LoginResponse luôn trả role |
| Size trang admin 10; debounce 400 ms | AdminQuestionsPage | PO; hằng trong file, chưa có UI |
| Mục admin trong AccountMenu (D7=C) | AppLayout.jsx | PO |
| estimatedCost không ký hiệu tiền (D6) | AdminAnalyticsPage | Giang (Q8) |
| from/to bỏ trống thì không gửi query; mặc định backend chưa xác minh (openapi:773-806) | adminAnalytics.js | Giang |
| Hộp thoại xóa nêu chung "đã có người luyện sẽ chỉ bị ẩn" | ConfirmDialog | PO |

## Tự phản biện
1. Menu trong AccountMenu có thể bị admin bỏ sót -> thêm link phụ "Quản trị" trên Dashboard nếu PO phản đối (không làm trước).
2. Dựa Q5 suy kiểu xóa từ danh sách tải lại: nếu lọc status mặc định ẩn HIDDEN thì không thấy câu bị ẩn -> mặc định lọc "Tất cả".
3. Content-Disposition có thể không đọc được -> luôn có tên fallback.

## Đối chuẩn web (dữ liệu ngoài, không tin cậy)
Chưa xác minh (không tra; dùng chuẩn WAI-ARIA alertdialog đã biết, cần xác minh khi review).

## Kiểm tra rủi ro
- Chạm hợp đồng công khai: không · Schema/migration: không · Tiền/bảo mật/phân quyền: có (gating UI admin, tải CSV có token; backend vẫn là chốt) · Lõi dùng chung: có (client.js, AuthContext, scoring.js — chỉ thêm)
- Khuyến nghị `risk: normal` — chỉ thêm ở frontend, không đổi hợp đồng; review kỹ client.js và RequireAdmin.

## Câu hỏi mở
Không có BLOCKING. Q8 (đơn vị estimatedCost), đề xuất Giang ở mục Hợp đồng.
