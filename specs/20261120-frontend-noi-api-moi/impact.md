# Phân tích ảnh hưởng: Frontend nối API mới (mã lỗi, #161, #162, analytics)
Phạm vi: chỉ frontend/** (+ docs/specs). Đã chốt: Q3 làm /admin/analytics (overview + CSV); Q4 không làm chi tiết user; Q5 nút Xóa + hộp thoại; D1-D5 giữ nguyên.
Lưu ý: vượt trần tool-use (~20/15) do cần đọc nhiều file nhỏ; phần chưa đọc ghi ở "Chưa xác minh".

## Điểm thay đổi gốc
| # | Thành phần | File/Symbol | Lý do phải đổi |
|---|---|---|---|
| G1 | Map mã lỗi | frontend/src/constants/scoring.js:99-105 `FAILED_MESSAGES` (+ hằng mới cho 429/403) | Thêm PROCESSING_TIMEOUT, INTERNAL_ERROR, TOO_MANY_PROCESSING, DAILY_LIMIT_EXCEEDED, FORBIDDEN (AC-1..7) |
| G2 | Nơi gọi evaluate/rescore | PracticePage.jsx:75,108-112,165; ResultsPage.jsx:136-154,637-646 | Dùng map mới thay `err.message` thô |
| G3 | Router | App.jsx:33-46 | Thêm `/admin/questions`, `/admin/analytics` |
| G4 | Auth | AuthContext.jsx:33-36 (thêm `isAdmin`), RequireAuth.jsx (thêm `RequireAdmin`) | Chặn UI theo `user.role` |
| G5 | Menu | AppLayout.jsx:9-15 NAV_ITEMS (+ AccountMenu 109-128) | Mục admin chỉ ADMIN thấy |
| G6 | API client | api/client.js:16-52 | Tải CSV cần fetch blob kèm JWT; `request` luôn `response.text()` + JSON nên KHÔNG dùng được cho binary |
| G7 | File mới | api/admin.js, pages/AdminQuestionsPage(+css), pages/AdminAnalyticsPage(+css), hộp thoại xác nhận | Màn admin |
| G8 | Mock | frontend/mock/examples.js:91 `SCHEMA_EXAMPLES` | Thêm ví dụ AdminQuestion/AdminQuestionPage/AnalyticsOverview |

## Ảnh hưởng lan truyền
| # | Thành phần bị ảnh hưởng | Loại | Bằng chứng | Rủi ro | Cần làm |
|---|---|---|---|---|---|
| I1 | FailedCard: thêm key vào `FAILED_MESSAGES` chỉ đổi text của mã trước đây rơi vào fallback `Đã xảy ra lỗi (code)`; mã cũ (ANSWER_TOO_SHORT, STT_ERROR, LLM_ERROR, INVALID_RESULT, SERVER_RESTART) giữ nguyên | code | ResultsPage.jsx:136,154; scoring.js:99-105 | Thấp | Chỉ THÊM key, không đổi/xóa key cũ. `canRetry = code !== 'ANSWER_TOO_SHORT'` giữ nguyên nên PROCESSING_TIMEOUT/INTERNAL_ERROR tự có nút "Chấm lại" (khớp AC-1) |
| I2 | Hằng 429/403 là hằng MỚI tách riêng (vd `HTTP_ERROR_MESSAGES`), không trộn vào FAILED_MESSAGES: TOO_MANY_PROCESSING/DAILY_LIMIT_EXCEEDED là mã HTTP, không bao giờ là `errorCode` của phiên (openapi:1215) | code | explore.md "Đối chiếu openapi" | Thấp | Hàm `apiErrorMessage(err)` tập trung; D1: không sửa ApiError |
| I3 | ResultsPage retry (evaluateSession) nay map 429; hiện `setError(err.message)` | code | ResultsPage.jsx:141-150 | Vừa | Giữ nguyên nhánh hiện có (SESSION_PROCESSING…), chèn map 429/403 TRƯỚC fallback `err.message`; phiên vẫn FAILED, không điều hướng (AC-3) |
| I4 | PracticePage submit: lỗi 429 ở evaluate sau khi upload đã xong. Nếu không điều hướng, phiên ở trạng thái UPLOADED; người dùng bấm nộp lại sẽ gọi lại uploadAnswer? | code/flow | PracticePage.jsx:66,75,108-112 | Vừa | ⚠️ [CẦN XÁC NHẬN] đọc PracticePage:60-112 để chắc retry chỉ gọi evaluate lại (không upload lại, không mất audio/blob); `submitErrorMessage` giữ nhánh 400/SESSION_PROCESSING hiện có |
| I5 | Rescore 429: không mất transcript đã sửa | code | ResultsPage.jsx:637-646 | Vừa | Chỉ `setError`, KHÔNG reset text/đóng editor trên nhánh lỗi 429; kiểm tay AC-5 (RescoreEditor ở chung file 695 dòng) |
| I6 | 403 thông điệp chung: nếu xử lý trong client.js (D1 cấm) sẽ đổi hành vi mọi trang; giữ ở map + hàm tiện ích. LoginPage dùng 423 ACCOUNT_LOCKED, không 403 | code | LoginPage.jsx:44; client.js:48 | Thấp | 401 giữ nguyên (chỉ đăng xuất khi có token); 403 không đăng xuất (AC-6) |
| I7 | `useSessionResult` phase failed/processing: hook không đổi; chỉ đọc `errorCode` | code | hooks/useSessionResult.js:7-62 | Thấp | Không sửa hook; khi quá thời gian PROCESSING_TIMEOUT backend đặt FAILED nên polling dừng đúng |
| I8 | Router: thêm route dưới `RequireAuth > AppLayout` không đổi route cũ. Deep link: CANDIDATE vào `/admin/*` bị `Navigate /dashboard`; chưa đăng nhập → RequireAuth chuyển `/login` kèm `state.from` | flow | App.jsx:33-46; RequireAuth.jsx:7 | Thấp | Đặt `RequireAdmin` lồng trong RequireAuth (RequireAuth chạy trước) ; ADMIN đăng nhập xong có quay về deep link không còn phụ thuộc: kiểm LoginPage có dùng `state.from` hay luôn `/dashboard` (chưa đọc) |
| I9 | `isAdmin = user?.role === 'ADMIN'` lấy từ session lưu storage; role đổi phía server không cập nhật tới khi đăng nhập lại/token hết hạn (≤24h) | auth | AuthContext.jsx:23-27; authStorage.js:30-38 | Vừa | Chỉ tiện ích; 403 ở API admin phải hiện AC-19. Session cũ trong storage (đăng nhập trước đây) có thể thiếu `user.role` nếu backend trước đó không trả → admin không thấy menu; nên kiểm LoginResponse (openapi:950,1090) khớp thực tế |
| I10 | AppLayout: NAV_ITEMS là mảng tĩnh; thêm mục có điều kiện (lọc theo isAdmin) không làm đổi mục cũ. Nav ngang 4 mục + 1-2 mục admin có thể tràn ở màn hẹp | UI | AppLayout.jsx:9-42; AppLayout.module.css (chưa đọc) | Vừa | Cân nhắc đặt mục admin trong AccountMenu (109-128) hoặc 1 mục "Quản trị" thay vì 2; kiểm ≤600px (AC-20). NavLink `/admin/questions` không xung đột `also` của `/practice` |
| I11 | Tải CSV: `request()` đọc `response.text()` và parse JSON → không dùng được. Cần hàm mới `download(path, params)` (fetch + Authorization + `response.blob()` + `URL.createObjectURL` + `<a download>` tạm + `revokeObjectURL`); lấy tên file từ `Content-Disposition` hoặc đặt `bao-cao-<from>-<to>.csv`. Lỗi 400/403 trả JSON → parse thành ApiError | api | client.js:36-37; openapi:842-885 | Vừa | Tái dùng cùng logic token/401 (nên tách `buildHeaders` dùng chung để không lệch với request). Không dùng `<a href>` trần (thiếu header). Dev proxy Vite `/api` đã có; Content-Disposition có thể không đọc được nếu CORS không expose (cùng origin qua proxy thì được) |
| I12 | Prism mock: `/admin/analytics/export` trả text/csv binary; Prism khó sinh ví dụ binary → nút Xuất CSV không kiểm được trên mock | test/mock | openapi:869-879; mock/examples.js | Thấp | Chấp nhận kiểm CSV trên backend thật; hoặc ghi chú trong test-report |
| I13 | Mock examples: SCHEMA_EXAMPLES có Question, QuestionPage… nhưng KHÔNG có AdminQuestion, AdminQuestionPage, AnalyticsOverview → Prism sinh "string"/số âm (đúng cảnh báo đầu examples.js:1-3). `build-mock-spec.mjs` chèn theo tên schema; thêm khóa mới không ảnh hưởng schema cũ. `Question` ví dụ không có `referenceAnswer`/`status HIDDEN` | mock | examples.js:1-3,91-93 | Thấp | Thêm 3 ví dụ (AdminQuestion có referenceAnswer + 1 câu HIDDEN; AdminQuestionPage; AnalyticsOverview có averageScore null/số). Cần xác nhận build-mock-spec xử lý `allOf` của AdminQuestion (ví dụ gắn ở mức schema allOf có thể bị bỏ) → ⚠️ [CẦN XÁC NHẬN] |
| I14 | Taxonomy dùng chung: form admin cần `INDUSTRIES`/`LEVELS`/`QUESTION_TYPES`/`questionTypeLabel`; chỉ ĐỌC các hằng này, không sửa → QuestionsPage không bị ảnh hưởng. Sai lệch: backend `QuestionUpsertRequest.industry/position` là `string` tự do (openapi:1155-1158), UI ép theo taxonomy-v1.0 → câu hỏi cũ trong DB có industry/position ngoài taxonomy sẽ không có option khi Sửa (select rỗng/mất giá trị) | data/UI | taxonomy.js:5-55; openapi:1149-1170 | Vừa | Form Sửa: nếu giá trị hiện có không nằm trong taxonomy, thêm tùy chọn tạm giữ nguyên giá trị (tránh âm thầm ghi đè) |
| I15 | QuestionsPage (người luyện) dùng `/questions` ẩn HIDDEN, không có referenceAnswer. Admin thêm/sửa/xóa không invalid cache nào (không có cache client) nhưng người luyện đang mở thấy dữ liệu cũ tới khi tải lại | flow | QuestionsPage.jsx; hook tự viết không react-query | Thấp | Không cần làm |
| I16 | Dữ liệu `status` HIDDEN và xóa mềm/cứng: UI không giả định; sau DELETE 204 tải lại danh sách; nếu trang hiện tại rỗng sau xóa cứng phần tử cuối trang → lùi về page-1 | UI | openapi:743-765 | Vừa | Xử lý page>0 mà rỗng |
| I17 | PUT/DELETE: 404 → làm mới; PUT không có field `status` nên ADMIN không thể bỏ ẩn câu HIDDEN (UI không được hứa tính năng "khôi phục") | API | openapi:699-772 (QuestionUpsertRequest không có status) | Thấp | Ẩn nút/ghi chú; đã ghi ngoài phạm vi trong requirements |
| I18 | Lint oxlint + build vite: file/hook mới phải qua `.oxlintrc.json`; quy tắc react-refresh (AuthContext đã dùng `eslint-disable-next-line react-refresh/only-export-components`) — thêm `RequireAdmin` cùng file RequireAuth.jsx (đã export 2 component) ổn; thêm hook/hằng export từ file component có thể bị cảnh báo | lint/build | AuthContext.jsx:41; package.json scripts | Thấp | Chạy `npm run lint` + `npm run build` sau mỗi WP (AC-25) |
| I19 | Dạng dữ liệu: `averageScore` null → "Chưa có"; `estimatedCost` float không nêu đơn vị tiền (openapi:1415-1418) | UI/data | openapi:1389-1418 | Thấp | Hiển thị số + "ước tính" không gắn đơn vị; hỏi Giang đơn vị (Q8, không chặn) |
| I20 | from/to: query `format: date` (YYYY-MM-DD); `<input type="date">` trả đúng định dạng; backend trả 400 nếu from > to; từ/đến để trống thì bỏ khỏi query (mặc định backend chưa đọc) | API | openapi:773-806, 858-867 | Thấp | Validate from<=to phía UI; ⚠️ [CẦN XÁC NHẬN] mặc định backend khi bỏ trống (đọc openapi:773-806) |

## Đối chiếu schema ↔ UI cần hiển thị
| Schema | Trường UI cần | Lệch/ghi chú |
|---|---|---|
| AdminQuestion (allOf Question + referenceAnswer, openapi:1138-1147) | content, industry, position, level, questionType, answerHint, status (ACTIVE/HIDDEN), referenceAnswer, createdAt | Question có `createdBy`, `createdAt`; UI không cần createdBy. referenceAnswer nullable, chỉ có nghĩa với TECHNICAL (D3). `Question` có thể có khoá cũ `starHint`? mô tả nói đã thay bằng answerHint → UI dùng answerHint |
| QuestionUpsertRequest | content, industry, position, level, questionType BẮT BUỘC; answerHint, referenceAnswer tùy chọn | Không có ràng buộc độ dài trong openapi → lỗi độ dài chỉ biết qua 400.fieldErrors; hiển thị đúng theo `fieldErrors[].field` (cần xem tên trường fieldErrors trong ErrorResponse) |
| AdminQuestionPage (1308-…) | content[], page, size, totalElements, totalPages | Cùng dạng QuestionPage → có thể dùng lại component Pagination hiện có (page 0-based? kiểm khi nối: QuestionsPage dùng PAGE_SIZE 6, page param) |
| AnalyticsOverview (1389-1418) | totalUsers, activeUsers, totalSessions, scoredSessions, averageScore(null), aiApiCalls{stt,llm,tts}, estimatedCost | Khớp AC-21. Không có tỉ lệ/thống kê theo ngày → UI chỉ thẻ số. Không có userId nào → xác nhận Q4=không làm |
| Export | text/csv binary | Không có tên file trong spec; xlsx trả 400 → không hiển thị lựa chọn xlsx |

## Luồng nghiệp vụ liên quan
- Luyện tập: ghi âm → upload → evaluate → polling → SCORED/FAILED → ResultsPage retry/rescore. Mã lỗi mới nằm ở nút nộp (PracticePage:75), nút Chấm lại (ResultsPage:142), rescore (ResultsPage:637).
- Auth: login → saveSession(role) → RequireAuth → AppLayout; 401 → UNAUTHORIZED_EVENT → logout.
- UC8 quản trị câu hỏi, UC9 thống kê: luồng mới; docs/knowledge/flows chưa kiểm (xem Chưa xác minh).

## Tương thích ngược & dữ liệu cũ
- Không đổi hợp đồng API, schema DB, backend. Session đã lưu trong storage vẫn đọc được (không đổi cấu trúc `talentstar.auth`).
- Phiên FAILED cũ với mã lạ nay hiện thông điệp chung thay cho `(code)` — chủ ý (AC-2). Giữ mã trong `title`/chi tiết nhỏ nếu cần hỗ trợ kỹ thuật.
- Câu hỏi cũ ngoài taxonomy: xem I14.

## Vùng thiếu test (cần bổ sung trước/sau khi sửa)
- Không có vitest/jest/playwright (D5). Chỉ `npm run lint` + `npm run build` + kịch bản thủ công. Vùng rủi ro cao nhất không có test: ResultsPage retry/rescore (I3, I5), RequireAdmin deep link (I8), tải CSV (I11), form admin 400/409/404 (AC-14..16).
- Kịch bản thủ công trên Prism: dùng header `Prefer: code=429` cho evaluate/rescore; 403 cho admin; CSV trên backend thật.

## Rủi ro tổng hợp
| Mã | Mô tả | Mức |
|---|---|---|
| R1 | Rescore/retry 429 làm mất transcript hoặc điều hướng sai (I3-I5) | Vừa |
| R2 | CSV tải sai cách (link trần/thiếu token/đọc text hỏng BOM) (I11) | Vừa |
| R3 | Role stale/thiếu trong session cũ → menu admin không hiện hoặc hiện nhầm (I9) | Vừa |
| R4 | Sửa câu hỏi ngoài taxonomy làm mất giá trị (I14) | Vừa |
| R5 | Menu tràn ở màn hẹp (I10) | Vừa |
| R6 | Mock không có ví dụ admin/CSV (I12-I13) | Thấp |
Không có rủi ro Cao.

## Câu hỏi mở
- Q8 (không chặn): đơn vị tiền của `estimatedCost` (openapi:1415-1418 không nêu) — hỏi Giang; mặc định D6: hiển thị số kèm nhãn "ước tính", không gắn ký hiệu tiền.
- Mặc định mới D6 (trên); D7: mục admin đặt trong AccountMenu hoặc 1 mục nav "Quản trị" (tùy architect, tránh tràn nav).
- Không có câu hỏi chặn mới.

## Chưa xác minh
- Chưa đọc: PracticePage.jsx:60-112 (đường retry sau 429 ở evaluate, I4), LoginPage (dùng `state.from`?), AppLayout.module.css, build-mock-spec.mjs (xử lý allOf), openapi:773-806 (mặc định from/to), cấu trúc `fieldErrors` ở ErrorResponse, docs/knowledge/flows.

## Tri thức cần cập nhật
- frontend/README.md:30 nhắc `src/assets/figma/` không tồn tại (từ explore.md).
