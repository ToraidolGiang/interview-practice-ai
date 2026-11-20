# Review: frontend nối API mới — Lăng kính: đúng đắn + kiến trúc + bảo mật + hiệu năng/UX
Kết luận: APPROVE (0 BLOCKER, 0 MAJOR, 3 MINOR, 1 NIT)

## Phát hiện
- F1 [MINOR] (tin cậy 80) frontend/src/api/client.js:~88 — `URL.revokeObjectURL` gọi đồng bộ ngay sau `link.click()`; một số trình duyệt (Safari/Firefox cũ) có thể huỷ tải khi URL bị thu hồi quá sớm. Đề xuất: `setTimeout(() => URL.revokeObjectURL(objectUrl), 0)` (hoặc ~1s).
- F2 [MINOR] (tin cậy 80) frontend/src/api/client.js `filenameFromDisposition` — tên file lấy từ Content-Disposition không lọc `/ \ ..` và ký tự điều khiển rồi gán `link.download`. Trình duyệt tự làm sạch đường dẫn nên rủi ro thấp (nguồn là backend tin cậy), nhưng nên phòng thủ: `name.replace(/[\\/\x00-\x1f]/g, '_')`, fallback `filename` nếu rỗng.
- F3 [MINOR] (tin cậy 80) frontend/src/components/ConfirmDialog.jsx:72-76 — khi `busy`, nút đang focus bị `disabled` nên focus rơi về body; Escape/Tab trap nằm ở `onKeyDown` của backdrop nên không còn bắt phím. Nếu xoá lỗi (setBusy(false)) hộp vẫn mở nhưng focus không ở trong hộp. Đề xuất: sau lỗi, `cancelRef.current?.focus()` (useEffect theo `error`), hoặc dùng `aria-disabled` thay `disabled`.
- F4 [NIT] (tin cậy 80) frontend/src/pages/AdminQuestionsPage.jsx:60-62 — gọi `setPage(0)` bên trong updater của `setKeyword` (side-effect trong hàm thuần; StrictMode gọi hai lần). Idempotent nên không lỗi; gọn hơn nếu so `next !== keyword` ngoài updater.

## Đối chiếu AC & kiểm tra chuyên đề
| Mục | Trạng thái |
|---|---|
| apiErrorMessage fallback (scoring.js:121-126) | OK: code -> 429 -> 403 -> fallback ?? err.message; trang Analytics truyền fallback nên không lộ message server |
| Debounce 400ms + reset page khi đổi keyword/status | OK (AdminQuestionsPage:57-66, 166-169) |
| Race khi đổi filter nhanh | OK: cờ `cancelled` trong effect + `result.key` so với `key` (:68-83); Analytics tương tự (:33-42) |
| Lùi trang sau xoá | OK: content rỗng và page>0 thì `setPage(page-1)` (:74), lùi đúng 1 trang, không vòng lặp |
| Loading/lỗi/rỗng | OK cả hai trang; lỗi 404/409/400 fieldErrors có câu riêng (:36-41) |
| So từ/đến | OK: `from > to` chuỗi yyyy-MM-dd so đúng; chặn gọi API, khoá nút Xuất, min/max trên input |
| Chống bấm đúp | OK: `busy`/`submitting` guard + disabled (DeleteDialog :290, form :338, export :73) |
| Khớp openapi /admin/questions, /admin/analytics | OK: params status/keyword/page/size, body QuestionUpsertRequest, export format=csv, from/to |
| Kiến trúc/quy ước | OK: CSS Modules, class chung (card/btn/alert), component dùng chung AdminTabs/ConfirmDialog, api/* tách file, không thêm thư viện |
| buildHeaders dùng chung request()/downloadBlob() | OK, không trùng lặp, hành vi request() giữ nguyên |
| RequireAdmin / menu | OK: route lồng trong RequireAuth, CANDIDATE bị `Navigate replace` về /dashboard; menu admin chỉ render khi `isAdmin`. Đây chỉ là UI; chặn thật ở backend (403 -> FORBIDDEN message). Mã nguồn bundle có route admin (không tránh được ở SPA, không phải bí mật) |
| downloadBlob bảo mật | OK: URL = '/api' + path cứng (cùng origin), Bearer không gửi ra ngoài; 401 phát UNAUTHORIZED_EVENT; lỗi JSON -> ApiError; chỉ còn F1/F2 |
| XSS | OK: `grep dangerouslySetInnerHTML` trong src không có kết quả; content, referenceAnswer, message lỗi đều render qua JSX (text) |
| a11y ConfirmDialog | Phần lớn OK: alertdialog, aria-modal, labelledby/describedby, focus Huỷ khi mở, Escape (chặn khi busy), Tab xoay vòng, trả focus; còn F3. Phần tử gốc (nút Xoá) bị unmount sau xoá thì trả focus không tác dụng (ghi nhận) |

## Điểm tốt (ngắn)
- Mẫu key-so-sánh thay vì setState loading trong effect; guard khoảng ngày chặn request thừa.
- Tách `writeErrorMessage`, option tạm cho câu ngoài taxonomy giữ dữ liệu cũ.

## Chưa xác minh
- Không đọc diff ResultsPage/PracticePage/HistoryPage/QuestionsPage/mock/examples.js nên chưa xác nhận retry/rescore giữ transcript (AC liên quan) ngoài việc có dùng `apiErrorMessage`.
- Không đọc CSS (390px, token index.css) và đoạn cuối QuestionForm (:450-522); chưa có ảnh UI nên UI "chưa kiểm bằng mắt".
- Khi sửa câu và đổi sang loại không phải TECHNICAL, `referenceAnswer` bị bỏ khỏi PUT (AdminQuestionsPage:349); chưa rõ backend giữ hay xoá giá trị cũ (cần đối chiếu implement backend).

## Ngoài phạm vi (ghi nhận, không chặn)
- Chưa có kiểm tra tự động cho `downloadBlob`/ConfirmDialog (tester chạy song song).

## Vòng xác nhận F1-F3
- F1: ĐÃ SỬA ĐÚNG — client.js:93 `setTimeout(() => URL.revokeObjectURL(objectUrl), 4000)`. Mỗi lần gọi có objectUrl riêng trong closure, mỗi cái đều được thu hồi sau 4s, nên không rò bộ nhớ và tải liên tiếp không ảnh hưởng nhau. Chữ ký `downloadBlob(path, { params, filename })` và `request()` không đổi.
- F2: ĐÃ SỬA ĐÚNG — client.js:98-107 `sanitizeFilename`, dùng ở :84. Bỏ ký tự điều khiển, `/`, `\`; `..` thu thành `.`; cắt 150 ký tự; rỗng hoặc chỉ `.` thì trả null và dùng `filename` dự phòng. Chữ tiếng Việt (có dấu) không bị đụng tới. `filenameFromDisposition` (:109-121) giữ nguyên, filename* vẫn được giải mã bằng decodeURIComponent trước khi lọc, nên `%2F` giải ra `/` cũng bị loại.
- F3: ĐÃ SỬA ĐÚNG — ConfirmDialog.jsx:
  - :28-32 khi busy, hộp nhận focus (có `tabIndex=-1` ở :67). Khi hết busy mà focus còn ở hộp thì chuyển về nút Huỷ, nên sau lỗi xoá hộp vẫn mở và focus về Huỷ.
  - :41-45 khi busy, Tab bị chặn và focus giữ ở hộp. :35-39 Escape bị bỏ qua khi busy nhưng vẫn `stopPropagation`.
  - Đóng thành công thì cleanup ở :24 trả focus về phần tử trước đó (nút Xoá).
  - Effect chỉ phụ thuộc `[busy]`, không có vòng lặp. Nếu busy không bao giờ hết thì focus nằm yên ở hộp (đúng ý định), không có vòng lặp.
  - `outline: none` (:68) chỉ áp dụng cho container, các nút trong hộp vẫn giữ chỉ báo focus.
- Phát hiện mới: không.
Kết luận vòng xác nhận: APPROVE
