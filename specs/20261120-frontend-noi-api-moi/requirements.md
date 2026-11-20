# Yêu cầu: Frontend nối các API mới (mã lỗi, chọn câu hỏi #161, quản trị câu hỏi #162, nối API đã merge)

## Bối cảnh & vấn đề
- Backend đã thêm mã lỗi mới và API admin (openapi.yaml:417, 511, 624-863, 1023, 1215; Ban_Giao_Tien_Do_20261119.md mục 5, 7). Frontend chưa hiển thị đúng: 429 ở evaluate/rescore hiện `err.message` thô (ResultsPage.jsx:141-150, 637-646; PracticePage.jsx:108-112), `FAILED_MESSAGES` thiếu `PROCESSING_TIMEOUT`, `INTERNAL_ERROR` (constants/scoring.js:99-105).
- Chưa có route/menu/api cho `/admin/*` (App.jsx:20-52; AuthContext không có isAdmin; explore.md "Phân quyền UI").
- Hiện trạng đã nối (explore.md): lịch sử, quên/đặt lại mật khẩu, rescore. Chưa nối: `/admin/analytics/*`.
- Đề bài coi history/forgot-reset/rescore là "cần nối", thực tế đã nối → việc (4) chỉ còn rà khớp hợp đồng + màn thống kê admin.

## Mục tiêu
Người luyện tập thấy thông báo tiếng Việt rõ ràng khi bị giới hạn/hết thời gian chấm; ADMIN quản trị được câu hỏi và xem thống kê trên giao diện; mọi lời gọi khớp `docs/api/openapi.yaml`.

## Phạm vi
- WP1 Mã lỗi: map `PROCESSING_TIMEOUT`, `INTERNAL_ERROR` (phiên FAILED) và `TOO_MANY_PROCESSING`, `DAILY_LIMIT_EXCEEDED` (HTTP 429) tập trung ở `constants/scoring.js`; áp dụng tại PracticePage (nộp/evaluate), ResultsPage (FailedCard retry, rescore). Thêm xử lý chung 403 và 429 ở mức thông điệp.
- WP2 #161: rà soát QuestionsPage so với UC3 (list/random/filter/phân trang đã có: QuestionsPage.jsx:25-75, 193-244, 275-315) → chỉ bổ sung phần thiếu đã xác nhận ở Q2; không làm lại phần có sẵn.
- WP3 #162: route `/admin/questions` chỉ hiển thị cho ADMIN: danh sách (lọc status, keyword, phân trang), thêm, sửa, xóa; hiển thị `referenceAnswer`, trạng thái HIDDEN; lỗi 400 gắn đúng trường (fieldErrors), 409 DUPLICATE_QUESTION, 403, 404.
- WP4: (a) đối chiếu từng lời gọi history/forgot/reset/rescore với openapi (tham số, schema, mã lỗi); (b) màn thống kê admin (overview, chi tiết user, xuất CSV) nếu Q3 chốt làm; (c) cập nhật mock Prism/examples cho endpoint admin nếu dev:mock cần.

## Ngoài phạm vi
- Sửa backend/openapi (cần đổi → Q4, Q6 gửi Giang). Hỗ trợ xlsx (backend trả 400). Thêm framework test (Q7). Ẩn/hiện câu hỏi bằng endpoint riêng (openapi không có; chỉ qua DELETE mềm hoặc PUT). Xem audit log trên UI (openapi không có endpoint đọc audit log; backend chỉ ghi). TTS (#121). Làm lại bộ lọc/phân trang QuestionsPage.
- Phân quyền UI chỉ là tiện ích; backend chặn thật bằng 403.

## User stories
- US-1: Là người luyện tập, tôi muốn thấy thông báo tiếng Việt rõ khi phiên chấm lỗi quá thời gian hoặc bị giới hạn lượt để biết nên chờ hay thử lại.
- US-2: Là người luyện tập, tôi muốn chọn câu hỏi theo ngành/vị trí/cấp độ/loại, hoặc ngẫu nhiên, để bắt đầu luyện (UC3).
- US-3: Là ADMIN, tôi muốn thêm/sửa/xóa và xem câu hỏi (kể cả HIDDEN) để duy trì ngân hàng câu hỏi (UC8).
- US-4: Là ADMIN, tôi muốn xem thống kê hoạt động và xuất báo cáo CSV để theo dõi sử dụng và chi phí AI (UC9).
- US-5: Là người dùng, tôi muốn các màn lịch sử, quên mật khẩu, chấm lại hoạt động đúng theo hợp đồng API hiện hành.

## Tiêu chí nghiệm thu
Kiểm bằng `npm run lint`, `npm run build` (trong frontend/) và kịch bản thủ công trên Prism mock hoặc backend thật (đổi mã trả bằng header `Prefer: code=429` của Prism hoặc sửa examples).
### WP1 (US-1)
- AC-1: Given phiên FAILED với errorCode `PROCESSING_TIMEOUT` When mở ResultsPage Then FailedCard hiện thông báo tiếng Việt riêng (nêu quá thời gian chấm) và nút "Chấm lại" khả dụng (canRetry=true).
- AC-2: Given phiên FAILED errorCode `INTERNAL_ERROR` hoặc mã lạ When mở ResultsPage Then hiện thông báo chung tiếng Việt, không lộ chuỗi mã thô như thông điệp chính.
- AC-3: Given `POST /practice-sessions/{id}/evaluate` trả 429 `TOO_MANY_PROCESSING` When nộp từ PracticePage hoặc bấm chấm lại ở ResultsPage Then hiện thông báo "đang có quá nhiều phiên đang chấm, hãy chờ phiên hiện tại hoàn tất rồi thử lại"; phiên giữ nguyên trạng thái, không điều hướng sang màn đang chấm.
- AC-4: Given 429 `DAILY_LIMIT_EXCEEDED` ở evaluate hoặc rescore When thao tác Then hiện thông báo hết hạn mức chấm trong ngày (nêu hạn mức ngày tính theo giờ Việt Nam, thử lại ngày mai), phân biệt rõ với AC-3.
- AC-5: Given 429 ở rescore (ResultsPage.jsx:637) When bấm "Chấm lại với transcript đã sửa" Then thông báo như AC-3/AC-4 theo code; nội dung transcript người dùng đã sửa KHÔNG bị mất.
- AC-6: Given phản hồi 403 ở bất kỳ API When xảy ra Then hiện thông báo "không có quyền thực hiện", không đăng xuất (chỉ 401 mới đăng xuất, client.js:48).
- AC-7: Given tất cả thông báo trên When xem mã nguồn Then văn bản nằm tập trung ở một hằng (constants/scoring.js hoặc tương đương), không rải chuỗi trong nhiều trang.
### WP2 (US-2) — chờ Q2 để chốt phần thiếu
- AC-8: Given danh sách đã có (list/filter/random/phân trang) When chạy kịch bản UC3 đủ luồng chính + 404 random + rỗng Then không hồi quy; ghi biên bản đối chiếu UC3 ↔ màn hình trong test-report.
- AC-9: Given mỗi mục thiếu đã được duyệt ở Q2 When nghiệm thu Then có AC riêng bổ sung vào file này trước khi code.
### WP3 (US-3)
- AC-10: Given người dùng role ADMIN When đăng nhập Then thấy mục menu "Quản trị câu hỏi" và vào được `/admin/questions`.
- AC-11: Given role CANDIDATE When gõ URL `/admin/questions` (hoặc `/admin/analytics`) Then bị chuyển về `/dashboard`, không thấy mục menu admin.
- AC-12: Given ADMIN vào danh sách When tải trang Then gọi `GET /admin/questions` và hiện cả câu HIDDEN (có nhãn trạng thái), lọc theo status và keyword, phân trang (page/size theo openapi).
- AC-13: Given ADMIN mở form thêm When nhập hợp lệ rồi lưu Then gọi `POST /admin/questions`, nhận 201, danh sách làm mới và hiện câu mới.
- AC-14: Given form thêm/sửa When industry/position chọn từ taxonomy (constants/taxonomy.js) Then chỉ cho chọn giá trị hợp lệ; Given 400 với fieldErrors Then lỗi hiện ngay dưới đúng trường.
- AC-15: Given nội dung trùng cùng vị trí When lưu Then 409 `DUPLICATE_QUESTION` hiện thông báo tiếng Việt, form giữ nguyên dữ liệu.
- AC-16: Given ADMIN bấm sửa When lưu Then gọi `PUT /admin/questions/{id}` (200) và danh sách cập nhật; 404 → thông báo "câu hỏi không còn tồn tại" và làm mới danh sách.
- AC-17: Given ADMIN bấm xóa When xác nhận qua hộp thoại Then gọi `DELETE` (204); UI không giả định mềm/cứng: sau khi xóa tải lại danh sách và nếu câu còn lại với status HIDDEN thì hiện nhãn "Đã ẩn" (theo Q5); thông báo kết quả đúng thực tế.
- AC-18: Given trường referenceAnswer When questionType=TECHNICAL Then form có ô nhập "Đáp án tham chiếu"; loại khác thì ẩn/để trống (theo mô tả openapi:1147).
- AC-19: Given backend trả 403 ở API admin (vd role đổi) When thao tác Then hiện thông báo không có quyền (AC-6) và không vỡ trang.
- AC-20: Given màn hình admin When thu hẹp (<= 600px) Then không vỡ bố cục (bảng cuộn ngang hoặc dạng thẻ).
### WP4 (US-4, US-5) — AC-21..23 chỉ áp dụng nếu Q3 = làm
- AC-21: Given ADMIN vào `/admin/analytics` When chọn khoảng from/to (định dạng date) Then gọi `GET /admin/analytics/overview?from&to` và hiện totalUsers, activeUsers, totalSessions, scoredSessions, averageScore (null → "Chưa có"), aiApiCalls (stt/llm/tts), estimatedCost.
- AC-22: Given bấm "Xuất CSV" When gọi `GET /admin/analytics/export?format=csv&from&to` kèm token Then trình duyệt tải file `.csv`; lỗi 403/400 hiện thông báo; không có lựa chọn xlsx (hoặc vô hiệu kèm chú thích).
- AC-23: Given có userId (Q4) When mở chi tiết Then gọi `GET /admin/analytics/users/{userId}`, hiện fullName, email, totalSessions, averageScore, lastPracticeAt, recentSessions; 404 → "Không tìm thấy người dùng".
- AC-24: Given history (listHistory/getHistoryDetail), forgot/reset, rescore When so với openapi Then tham số, tên trường, xử lý mã lỗi khớp; mọi lệch được sửa trong frontend hoặc ghi thành câu hỏi gửi Giang. Kết quả lập bảng đối chiếu trong test-report.
- AC-25: Given toàn bộ thay đổi When chạy `npm run lint` và `npm run build` Then 0 lỗi.

## Yêu cầu phi chức năng
- Bảo mật: không lưu/log dữ liệu nhạy cảm; email trong thống kê chỉ hiển thị cho ADMIN; tải CSV phải gửi Bearer token (không dùng link trần nếu API cần header). CSV có BOM/chống formula injection do backend lo.
- i18n: toàn bộ chuỗi mới tiếng Việt, thuật ngữ theo domain-glossary.
- Giao diện: dùng class/token sẵn có (index.css), cùng pattern page + .module.css; bám Figma InterviewAI-MockupV1 ở mức tinh thần (README frontend:3; thư mục assets/figma không tồn tại).
- Truy cập: lỗi dùng `role="alert"`, hộp thoại xóa điều khiển được bằng bàn phím.

## Giả định
(a) Đã xác nhận: thứ tự 4 việc; chỉ sửa frontend/** và docs/specs; phân quyền UI chỉ tiện ích (người dùng, 2026-11-20).
(b) Chưa xác nhận (người duyệt cần nhìn):
- Nội dung thông báo tiếng Việt do tôi đề xuất (sửa tại constants/scoring.js, chỉ lập trình viên sửa được).
- Hạn mức hiển thị trong thông báo: không nêu con số (backend mặc định 3 phiên/20 lượt, cấu hình `app.scoring.*` có thể đổi) để khỏi lệch.
- Nhận biết ADMIN bằng `user.role === 'ADMIN'` từ LoginResponse đã lưu (AuthContext.jsx:22-27).
- Menu admin nằm trong AppLayout dưới mục riêng chỉ ADMIN thấy.
- QuestionsPage cơ bản đã đủ UC3 (chưa xác minh phần render đầy đủ).

## Mặc định áp dụng
| Mã | Mặc định | Hệ quả | Gõ để sửa |
|---|---|---|---|
| D1 | Xử lý 429/403 bằng map mã → thông báo tại constants, không sửa ApiError | Mỗi nơi gọi tự gọi hàm map | `D1: xử lý chung trong client.js` |
| D2 | Xác nhận xóa bằng hộp thoại, không hoàn tác | Thêm 1 bước click | `D2: bỏ xác nhận` |
| D3 | Form admin hiện referenceAnswer chỉ khi TECHNICAL | Giảm nhập thừa | `D3: luôn hiện` |
| D4 | Kích thước trang admin = 10 | Khác QuestionsPage (6) | `D4: size 20` |
| D5 | Không thêm test, chỉ lint/build/thủ công | Không có hồi quy tự động | xem Q7 |

## Câu hỏi mở
### Q1
- **ID**: Q1
- **Vị trí**: README.md Tóm tắt; Ban_Giao_Tien_Do_20261119.md:41
- **Bối cảnh**: Việc (4) nói "nối API đã merge" nhưng history/forgot/reset/rescore đã nối; chỉ analytics thiếu.
- **Phương án**: A) Chỉ rà khớp openapi các phần đã nối + làm analytics; B) Làm lại/thiết kế lại các màn đã có.
- **Đề xuất**: A — **Lý do**: explore.md xác nhận đã có api + màn + route; làm lại tốn công không thêm giá trị.
- **Nếu chọn sai**: B cần mở rộng WP4; quay lại bằng cách thêm WP.
- **Mức chặn**: không
- **Thuật ngữ**: rà khớp = so tham số/schema/mã lỗi lời gọi với openapi.yaml.

### Q2
- **ID**: Q2
- **Vị trí**: frontend/src/pages/QuestionsPage.jsx; docs/diagrams (UC3)
- **Bối cảnh**: #161 coi là "To Do" nhưng QuestionsPage đã có list/random/filter/phân trang/bắt đầu luyện; tôi chưa đối chiếu được luồng UC3 chi tiết (chỉ có sơ đồ drawio, không có văn bản).
- **Phương án**: A) #161 chỉ là rà soát + vá lỗ hổng nhỏ tìm được (vd trạng thái lỗi, xem chi tiết `GET /questions/{id}`, 404 random), đóng ticket nếu đã đủ; B) Làm thêm tính năng mới (xem trước chi tiết, yêu thích...) — cần Vũ liệt kê.
- **Đề xuất**: A — **Lý do**: không có yêu cầu văn bản nào ngoài những gì đã làm.
- **Nếu chọn sai**: thiếu tính năng người duyệt mong đợi; bổ sung AC-9 rồi làm tiếp.
- **Mức chặn**: không
- **Thuật ngữ**: UC3 = use case chọn câu hỏi luyện tập.

### Q3
- **ID**: Q3
- **Vị trí**: openapi.yaml:773-863; AppLayout.jsx:110-126
- **Bối cảnh**: Màn thống kê admin (#163 backend xong) chưa có trong 4 việc nêu rõ; cần quyết có làm trong task này và đặt ở đâu.
- **Phương án**: A) Làm trong task này: trang `/admin/analytics` (overview + xuất CSV), cùng nhóm menu admin với quản trị câu hỏi; B) Tách task sau, task này chỉ WP1-3 + rà khớp; C) Chỉ nút xuất CSV.
- **Đề xuất**: A — **Lý do**: việc (4) của người dùng nêu rõ thiếu 3 endpoint analytics; chi phí nhỏ (1 trang, 1 api file).
- **Nếu chọn sai**: B thì AC-21..23 chuyển sang task sau; đảo ngược dễ.
- **Mức chặn**: BLOCKING
- **Thuật ngữ**: overview = tổng quan số liệu; xuất CSV = tải báo cáo mỗi dòng một người dùng.

### Q4
- **ID**: Q4
- **Vị trí**: openapi.yaml:807-841 (`/admin/analytics/users/{userId}`)
- **Bối cảnh**: Không có API liệt kê user và overview không trả danh sách user, nên UI không có cách lấy `userId` để mở chi tiết; export CSV cũng không chứa userId theo mô tả.
- **Phương án**: A) Không làm màn chi tiết user trong task này, ghi đề xuất cho Giang (thêm `GET /admin/analytics/users` hoặc cột userId trong overview); B) Ô nhập userId (UUID) thủ công; C) Liên kết từ `recentSessions`/nơi nào đó nếu tồn tại (chưa thấy).
- **Đề xuất**: A — **Lý do**: B là UX kém, không ai biết UUID; frontend không được sửa backend/openapi.
- **Nếu chọn sai**: chọn B mất công làm ô nhập rồi bỏ; quay lại bằng xóa ô nhập.
- **Mức chặn**: BLOCKING
- **Thuật ngữ**: userId = mã UUID của người dùng.

### Q5
- **ID**: Q5
- **Vị trí**: openapi.yaml:743-765 (DELETE)
- **Bối cảnh**: DELETE tự quyết mềm (HIDDEN, nếu đã dùng) hoặc cứng; response 204 không cho biết đã làm kiểu nào. Người dùng hỏi UI xóa mềm hay cứng.
- **Phương án**: A) Một nút "Xóa"; sau 204 tải lại danh sách, kiểu xóa suy ra từ việc câu còn xuất hiện với HIDDEN hay không; hộp thoại cảnh báo chung "câu đã có người luyện sẽ chỉ bị ẩn"; B) Nút "Xóa" + hỏi Giang cho trả thêm thông tin; C) Thêm nút "Ẩn" riêng (PUT không có trường status → không khả thi).
- **Đề xuất**: A — **Lý do**: khớp hợp đồng hiện tại, không cần đổi backend.
- **Nếu chọn sai**: mất nhãn "đã ẩn" chính xác ngay lập tức; sửa nhỏ.
- **Mức chặn**: BLOCKING
- **Thuật ngữ**: xóa mềm = đặt status HIDDEN, giữ dữ liệu; xóa cứng = xóa khỏi DB.

### Q6
- **ID**: Q6
- **Vị trí**: openapi.yaml:624-772
- **Bối cảnh**: Người dùng nhắc "ẩn/hiện" và "audit log nếu API có": openapi không có endpoint bật lại HIDDEN (PUT không có `status`) và không có endpoint đọc audit log.
- **Phương án**: A) Không làm ẩn/hiện thủ công và audit log trên UI; ghi đề xuất cho Giang (thêm `status` vào QuestionUpsertRequest hoặc endpoint audit); B) Chờ Giang bổ sung rồi mới làm WP3.
- **Đề xuất**: A — **Lý do**: không chặn CRUD cốt lõi; frontend không sửa openapi.
- **Nếu chọn sai**: thiếu tính năng "hiện lại"; bổ sung sau khi hợp đồng đổi.
- **Mức chặn**: không
- **Thuật ngữ**: AuditLog = nhật ký thao tác admin ghi ở backend.

### Q7
- **ID**: Q7
- **Vị trí**: frontend/package.json (không có framework test)
- **Bối cảnh**: Hiện chỉ có lint/build; thêm test cần cài vitest (phụ thuộc mới).
- **Phương án**: A) Không thêm test; B) Thêm vitest cho hàm thuần (map mã lỗi, nhận biết ADMIN); C) Thêm cả component test.
- **Đề xuất**: A — **Lý do**: ngoài yêu cầu, thêm phụ thuộc/CI; kiểm thủ công đủ cho task này.
- **Nếu chọn sai**: thiếu hồi quy tự động; thêm sau.
- **Mức chặn**: không
- **Thuật ngữ**: vitest = framework test cho dự án Vite.

## Tự phản biện
- R1: Gán `isAdmin` từ role lưu ở localStorage có thể cũ (đổi role sau khi đăng nhập). Xử lý: backend 403 là chuẩn; UI hiện AC-19.
- R2: Phân biệt mã 429 phụ thuộc `code` trong body; nếu backend trả thiếu code, rơi về thông báo chung 429. Xử lý: fallback nêu "thử lại sau".
- R3: Giả định QuestionsPage đã đủ dựa trên grep khảo sát, chưa đọc toàn bộ. Xử lý: WP2 bắt đầu bằng đối chiếu và chốt qua Q2 trước khi code.

## Chưa xác minh
- Văn bản đặc tả UC3/UC8 chi tiết (chỉ có drawio/API_Spec_Table); khớp Figma (không có assets/figma).
- Tên header Prism để ép mã 429; mock/examples cho endpoint admin.
- ForgotPassword/Reset/History đối chiếu từng trường chưa làm (thuộc AC-24).
