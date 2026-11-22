# Báo cáo kiểm thử: Frontend nối API mới — Vòng 1 (T9 nghiệm thu)
Kết luận: **PASS có điều kiện** — kiểm tĩnh/lint/build/hàm thuần PASS, không phát hiện CODE_BUG. Phần cần trình duyệt/backend thật CHƯA KIỂM THỦ CÔNG (xem "Chưa kiểm"). Không có framework test frontend (Q7), không thêm test.

Thống kê 25 AC: PASS (tĩnh + lint/build) 22 · FAIL 0 · KHÔNG LÀM (Q4) 1 (AC-23) · AC phụ thuộc thủ công vẫn ghi CHƯA KIỂM THỦ CÔNG ở cột kết quả (UI/hành vi chạy).

## Lệnh đã chạy
| Lệnh | Kết quả |
|---|---|
| `npm run lint` (oxlint) | 0 lỗi/0 cảnh báo (không có output lỗi) |
| `npm run build` | OK, 100 modules, built 498ms |
| `node mock/build-mock-spec.mjs` | OK, 10 schema có dữ liệu mẫu; `mock/.generated/openapi.yaml` có AdminQuestionPage (dòng 1540), AnalyticsOverview (totalUsers 1787/1814, aiApiCalls 1800/1819); `.generated` bị git-ignore |
| Script scratchpad `t.mjs` (nhập `constants/scoring.js`, trích `filenameFromDisposition` từ client.js) | 11/11 OK: 429 TOO_MANY_PROCESSING và DAILY_LIMIT_EXCEEDED ra hai câu khác nhau; 429 không code -> "thử lại sau"; 403 -> "không có quyền"; fallback; FAILED_MESSAGES.PROCESSING_TIMEOUT; fallback FAILED không lộ mã; Content-Disposition dạng `filename=` và `filename*=UTF-8''` đúng, null -> null |
| `downloadBlob` (fetch/DOM/Blob), RequireAdmin, trang | Bỏ qua (cần DOM/trình duyệt): chưa chạy |

## Ma trận AC
| AC | Kiểm bằng | Kết quả | Bằng chứng |
|---|---|---|---|
| AC-1 | Đọc mã + script | PASS (tĩnh); hiển thị CHƯA KIỂM THỦ CÔNG | scoring.js:105 (PROCESSING_TIMEOUT, tiếng Việt); ResultsPage.jsx:137-139 canRetry = code !== 'ANSWER_TOO_SHORT' nên TIMEOUT retry được; :158 render FAILED_MESSAGES[code] |
| AC-2 | Đọc mã + script | PASS (tĩnh) | scoring.js:106 INTERNAL_ERROR; :110 FAILED_MESSAGE_FALLBACK cho mã lạ; ResultsPage.jsx:158 không in mã thô |
| AC-3 | Đọc mã + script | PASS (tĩnh); thủ công Prism CHƯA | scoring.js:113-114, 121-123; PracticePage.jsx:108-112 submitErrorMessage -> apiErrorMessage, :76-78 chỉ navigate khi thành công; ResultsPage.jsx:146-149 |
| AC-4 | Đọc mã + script | PASS (tĩnh); thủ công CHƯA | scoring.js:115 (giờ Việt Nam, ngày mai) khác câu AC-3 (script xác nhận) |
| AC-5 | Đọc mã | PASS (tĩnh); thủ công CHƯA | ResultsPage.jsx:641-650 catch chỉ setError/setSaving(false), không reset `text` nên transcript giữ; dùng apiErrorMessage |
| AC-6 | Đọc mã + script | PASS (tĩnh) | scoring.js:117,124; client.js:56 và :79 chỉ phát UNAUTHORIZED khi status 401; 403 không đăng xuất |
| AC-7 | grep `err.message/error.message/failedCode/errorCode` trong pages | PASS | Văn bản 429/403/FAILED tập trung ở constants/scoring.js:99-125. Còn `err.message` ở: PracticePage.jsx:109 (nhánh 400, thông điệp backend ErrorResponse, có fallback VN), ForgotPassword:36, ResetPassword:44, Login:47, Register:46, QuestionsPage:77, HistoryPage:170 — ngoài phạm vi evaluate/rescore, nhánh tải/ form khác. Không có chuỗi mã lỗi thô ở evaluate/rescore |
| AC-8 | Đọc mã (biên bản T3) | PASS (tĩnh); luồng trên UI CHƯA KIỂM THỦ CÔNG | Biên bản UC3 ở progress/T3-uc3.md (14 điểm; 2 vá nhỏ QuestionsPage: keyword đồng bộ URL, maxLength 200). Đề xuất còn lại: nút "Thử lại", về trang cuối khi page vượt tổng, ô "Sắp xếp" giả |
| AC-9 | Rà tài liệu | PASS (không có mục thiếu mới được duyệt ở Q2 -> phương án A) | requirements.md Q2; T3 |
| AC-10 | Đọc mã | PASS (tĩnh); thủ công CHƯA | AuthContext.jsx:37 isAdmin = role==='ADMIN'; AppLayout.jsx:123 `{isAdmin && ...}`; App.jsx:47-49 route trong RequireAdmin |
| AC-11 | Đọc mã | PASS (tĩnh); thủ công CHƯA | RequireAuth.jsx:12-14 `!isAdmin -> Navigate /dashboard replace`; bao cả /admin/questions và /admin/analytics (App.jsx:47-49) |
| AC-12 | Đọc mã | PASS (tĩnh) | AdminQuestionsPage.jsx:17 PAGE_SIZE=10, :23 HIDDEN "Đã ẩn", :70 listAdminQuestions({status, keyword, page, size}), :229-230 nhãn |
| AC-13 | Đọc mã | PASS (tĩnh) | form POST qua adminQuestions.js (createAdminQuestion), :349 payload |
| AC-14 | Đọc mã | PASS (tĩnh) | :388-412 select ngành/vị trí; :358 map fieldErrors -> dưới từng FormField (:374-463) |
| AC-15 | Đọc mã | PASS (tĩnh) | :37 409 -> thông báo VN; form không bị reset khi lỗi |
| AC-16 | Đọc mã | PASS (tĩnh) | :356 404 -> onGone (làm mới); :38 thông báo "không còn tồn tại" |
| AC-17 | Đọc mã | PASS (tĩnh) | :286-315 DeleteDialog + ConfirmDialog; 404 -> onGone; sau xóa tải lại, nhãn "Đã ẩn" lấy từ status trả về |
| AC-18 | Đọc mã | PASS (tĩnh) | :329 isTechnical; :349 chỉ gửi referenceAnswer khi TECHNICAL; :476 ô "Đáp án tham chiếu" |
| AC-19 | Đọc mã | PASS (tĩnh); thủ công CHƯA | writeErrorMessage :40 -> apiErrorMessage (403 -> không có quyền); :181-182 lỗi list qua apiErrorMessage; client.js không đăng xuất khi 403 |
| AC-20 | Đọc CSS | PASS (CSS); mắt thường 390px CHƯA | AdminQuestionsPage.module.css:43 overflow-x:auto, @media 900/600 (:122,:128); AdminAnalyticsPage.module.css:94 @media 600 |
| AC-21 | Đọc mã | PASS (tĩnh); thủ công CHƯA | AdminAnalyticsPage.jsx:132-143 đủ totalUsers, activeUsers, totalSessions, scoredSessions, averageScore (null -> "Chưa có" :138), estimatedCost, aiApiCalls.stt/llm/tts; :30 kiểm from<=to; adminAnalytics.js:13 gọi overview?from&to |
| AC-22 | Đọc mã + script | PASS (tĩnh); tải CSV thật CHƯA | adminAnalytics.js:18-19 downloadBlob format=csv, không xlsx; client.js:~63-100 gửi Bearer qua buildHeaders, lỗi -> ApiError, tên file từ Content-Disposition (script OK); AdminAnalyticsPage.jsx:50 lỗi hiển thị |
| AC-23 | Không làm (Q4) | KHÔNG LÀM (Q4) | tasks.md T6; đề xuất Giang: GET /admin/analytics/users hoặc cột userId |
| AC-24 | Đối chiếu T4 | PASS có đề xuất (1 lệch FE đã sửa, các lệch còn lại là tài liệu/backend) | Bảng đối chiếu ở progress/T4-doi-chieu.md: history/forgot/reset/rescore khớp; HistoryPage audioUrl đã sửa dùng playbackUrl; 5 đề xuất cho Giang (playbackUrl chưa khai báo trong schema, 72 byte, maxLength 10000, trường luôn null, N+1 /questions/{id}). Mục "rescore 400/409/429/503: chưa xác minh (thuộc T3)" của T4 nay đã xử lý ở ResultsPage.jsx:641-650 (AC-5) |
| AC-25 | lint + build | PASS | lệnh ở trên, 0 lỗi |

## Hồi quy theo impact
Không có impact.md riêng trong task này; hồi quy chính (QuestionsPage, FAILED_MESSAGES cũ giữ nguyên, 401 đăng xuất) kiểm tĩnh: FAILED_MESSAGES chỉ thêm khoá; client.js 401 giữ nguyên (:56, :79). Hồi quy chạy thật: CHƯA KIỂM THỦ CÔNG.

## Lỗi phát hiện
Không có CODE_BUG. Ghi nhận (SPEC_GAP/đề xuất, không chặn):
- G1 [SPEC_GAP] openapi không khai báo playbackUrl cho /history -> nút nghe lại ở Lịch sử có thể luôn khoá (T4). Hỏi Giang.
- G2 [SPEC_GAP] Không có API liệt kê user/audit/bật lại HIDDEN (Q4, Q6) — đã chốt không làm.
- G3 (nhẹ, UC3) trang vượt tổng hiện trạng thái rỗng thay vì về trang cuối; QuestionsPage thiếu nút "Thử lại" (T3, ngoài phạm vi Q2).

## Chưa kiểm (chỉ kiểm được trên trình duyệt/backend thật)
- Giao diện 390px và 1280px: /admin/questions, /admin/analytics, QuestionsPage, menu admin (AC-10, 20; chưa soi bằng mắt).
- Đăng nhập ADMIN vs CANDIDATE, gõ URL /admin/* (AC-10, 11); role cũ trong localStorage.
- Prism: `Prefer: code=429` (TOO_MANY_PROCESSING, DAILY_LIMIT_EXCEEDED) ở evaluate/rescore, transcript còn nguyên sau lỗi (AC-3..5); `code=403` không đăng xuất (AC-6, 19); FAILED với PROCESSING_TIMEOUT/INTERNAL_ERROR/mã lạ (AC-1, 2).
- Tải CSV thật (Bearer, Content-Disposition, BOM) và 403/400 từ backend (AC-22); overview với dữ liệu thật (AC-21).
- CRUD admin end-to-end: 201/200/204, 409, 400 fieldErrors, 404, nhãn "Đã ẩn" sau xóa mềm (AC-12..17); bàn phím hộp thoại (ConfirmDialog.jsx:8,23-46 có Escape/Tab-trap/aria-modal theo mã, chưa chạy).
- Luồng UC3 đầy đủ trên UI (AC-8).
- `downloadBlob` và RequireAdmin: chưa chạy do phụ thuộc DOM/React Router.

## Ghi chú
- Đã sửa frontend/README.md:30: `src/assets/figma/` không tồn tại (ls src/assets -> chỉ `illustrations`); dòng mới nêu `src/assets/illustrations/`, icon/logo là component SVG (Icon.jsx, Logo.jsx).
- Scratchpad script không nằm trong repo. Không đổi nhánh/commit/push.

## Kiểm thủ công trên trình duyệt (2026-11-20, Prism mock + Vite, Chrome)
Môi trường: `npm run dev:mock` (Prism cổng 4010, Vite cổng 5173); phiên đăng nhập thử tạo bằng token giả trong sessionStorage (CANDIDATE và ADMIN). Một số phản hồi lỗi giả lập bằng cách ghi đè `window.fetch` trong tab, vì Prism không trả 400/409.

| AC | Kịch bản | Kết quả |
|---|---|---|
| AC-10, AC-11 | CANDIDATE gõ `/admin/questions` | PASS: chuyển về `/dashboard`, không có link admin trên trang |
| AC-10 | ADMIN vào `/admin/questions` | PASS: 5 dòng, nhãn "Đang hiển thị"/"Đã ẩn", tab "Câu hỏi" đang chọn |
| AC-21 | ADMIN vào `/admin/analytics` (mock) | PASS: số liệu tổng quan, "Chi phí AI … ước tính", thẻ STT/LLM/TTS, nút Xuất CSV |
| AC-14 | Gửi form thêm, giả lập 400 có `fieldErrors` | PASS: banner + lỗi dưới 3 trường, `aria-invalid`, form giữ nguyên. Lưu ý: form `noValidate`, không validate phía client; mock Prism nhận body rỗng và trả 201 vì openapi không có `minLength` |
| AC-15 | Giả lập 409 `DUPLICATE_QUESTION` | PASS: "Câu hỏi này đã tồn tại trong ngân hàng …", form mở |
| AC-18 | Đổi loại sang TECHNICAL | PASS: ô "Đáp án tham chiếu" ẩn với Hành vi, hiện với Kỹ thuật |
| AC-17 | Hộp thoại xóa | PASS: focus vào "Huỷ", Tab xoay vòng trong hộp, Escape đóng và trả focus về nút "Xoá" |
| Mobile | Iframe 390px (đổi cỡ cửa sổ không đổi viewport thật) trang `/admin/questions` | PASS: không cuộn ngang, bảng chuyển thành thẻ, bộ lọc xếp dọc |

### Lỗi tìm thấy khi kiểm thủ công (đã sửa)
- **AdminTabs hiện thanh cuộn dọc thừa** (mũi tên lên/xuống bên phải hàng tab) trên Chrome Windows. Nguyên nhân: `.tab { margin-bottom: -1px }` làm tab nhô 1px ra ngoài vùng nội dung của `<nav>` có `overflow-x: auto` (clientWidth 1265 so với 1280). Lint/build/đọc mã không bắt được. Sửa trong `frontend/src/components/AdminTabs.module.css`: vẽ đường kẻ bằng `box-shadow` inset, bỏ margin âm. Đã đo lại: clientWidth = 1280, không còn cuộn dọc, gạch chân tab giữ nguyên. Sửa này CHƯA qua vòng review của reviewer.

### Bổ sung sau khi nối lại Chrome (lỗi giả lập bằng cách ghi đè `window.fetch`)
| AC | Kịch bản | Kết quả |
|---|---|---|
| AC-1 | Phiên FAILED, errorCode `PROCESSING_TIMEOUT` | PASS: "Việc chấm điểm mất quá nhiều thời gian nên đã bị dừng. Bạn có thể gửi chấm lại." + nút "Gửi chấm lại", "Ghi âm lại" |
| AC-3 | Bấm "Gửi chấm lại", evaluate trả 429 `TOO_MANY_PROCESSING` | PASS: "Đang có quá nhiều phiên đang chấm. Hãy chờ phiên hiện tại hoàn tất rồi thử lại.", không điều hướng, nút được khôi phục |
| AC-4 | evaluate trả 429 `DAILY_LIMIT_EXCEEDED` | PASS: "Bạn đã hết lượt chấm điểm trong ngày (tính theo giờ Việt Nam). Hãy thử lại vào ngày mai." (không nêu số lượt) |
| AC-5 | Sửa transcript rồi "Lưu & chấm lại", rescore trả 429 `DAILY_LIMIT_EXCEEDED` | PASS: trình sửa còn mở, nội dung transcript đã sửa còn nguyên, thông báo đúng, nút không bị khóa |

### Còn chưa kiểm
- `INTERNAL_ERROR` và mã lạ ở phiên FAILED (AC-2) trên trình duyệt: mới kiểm hàm map bằng node.
- 403 ở rescore và 429 ở trang luyện tập (PracticePage); phiên FAILED tại PracticePage.
- CRUD admin thành công: mới thấy "Đã thêm câu hỏi."; lùi trang sau xóa, sửa và xóa chưa kiểm.
- Tải CSV thật (cần backend thật), giao diện 1280px các trang ngoài admin, bàn phím trang quản trị ngoài hộp thoại xóa.
