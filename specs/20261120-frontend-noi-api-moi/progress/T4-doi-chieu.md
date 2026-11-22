# T4 - Đối chiếu frontend với docs/api/openapi.yaml (AC-24)

| API | Điểm kiểm | Kết quả | frontend vs openapi | Đã sửa? |
|---|---|---|---|---|
| GET /history | tham số from,to,industry,minScore,maxScore,page,size | Khớp | api/history.js:12-14 vs openapi:557-584 | - |
| GET /history | size ≤100 (PAGE_SIZE=5), page từ 0 | Khớp | HistoryPage.jsx:13,48 vs :935-947 | - |
| GET /history | PageResponse content/page/size/totalElements/totalPages | Khớp | HistoryPage.jsx:57,91,207 vs :1324-1338 | - |
| GET /history | chỉ trả SCORED; totalScore nullable xử lý "--" | Khớp | HistoryPage.jsx:415-416,448 vs :587 | - |
| GET /history | không có trường question/industry trong PracticeSession; trang tự gọi loadQuestion theo questionId | Khớp (N+1 gọi /questions/{id}, lưu ý hiệu năng) | HistoryPage.jsx:58 vs :1171-1215 | - |
| GET /history | lọc keyword chỉ ở client trong trang hiện tại (openapi không có tham số keyword) | Khớp (hạn chế đã biết) | HistoryPage.jsx:95-96 | - |
| GET /history | audioUrl là khóa S3, KHÔNG phải URL tải được; trang dùng làm <audio src> | LỆCH | HistoryPage.jsx:453 (cũ) vs openapi:1181-1185 | Có: dùng session.playbackUrl (không có trong list thì nút nghe bị khóa, tooltip trung tính) |
| GET /history | backend gọi PracticeSessionDto.from(s,null): trường phụ thuộc tham số thứ 2 (chưa xác minh tên trường, giả định là playbackUrl/nội dung phụ) luôn null | Chưa xác minh | UI chỉ dùng id,questionId,totalScore,audioUrl,duration,completedAt/submittedAt/startedAt; đều có giá trị. Trang xử lý null cho totalScore và playbackUrl | - |
| GET /history/{id} | HistoryDetail = PracticeSession + scoreResult; dùng ở hooks/useProgress.js:46 (ngoài phạm vi T4) với fallback .catch | Khớp | api/history.js:17-19 vs openapi:594-625,1382-1388 | - |
| GET /history/{id} | playbackUrl: mô tả openapi:603 nói có, nhưng schema PracticeSession/HistoryDetail không khai báo; grep backend không thấy playbackUrl | LỆCH (do openapi/backend) | openapi:603 vs :1382 | Không (đề xuất) |
| GET /history/{id} | 403/404 qua apiErrorMessage/err.message | Khớp | client.js | - |
| POST /auth/forgot-password | body {email}, 200 không body, 400 | Khớp | api/auth.js:15-17, ForgotPasswordPage.jsx:31-36 vs openapi:100-123 | - |
| POST /auth/forgot-password | 429/503 không có trong openapi; trang hiển thị err.message cho mã khác 400 | Khớp (an toàn) | ForgotPasswordPage.jsx:36 | - |
| POST /auth/reset-password | body {token,newPassword,confirmPassword}; 200; 400 INVALID_TOKEN -> màn "hết hạn"; 400 VALIDATION_ERROR -> fieldErrors | Khớp | api/auth.js:22-28, ResetPasswordPage.jsx:39-44 vs openapi:124-146,1340 | - |
| POST /auth/reset-password | không có 410 trong openapi (token sai/hết hạn là 400) | Khớp | - | - |
| POST /auth/reset-password | giới hạn 72 byte UTF-8 (backend ResetPasswordRequest.java:17) không có trong openapi (chỉ minLength 8); frontend không kiểm trước, chỉ hiển thị fieldErrors backend trả | Khớp về hành vi; LỆCH tài liệu | ResetPasswordPage.jsx:31 vs openapi:1340-1352 | Không (đề xuất) |
| POST /practice-sessions/{id}/rescore | body {transcript}; 202 PracticeSession | Khớp | api/practice.js:32-33, ResultsPage.jsx:637 vs openapi:461-521,1354 | - |
| rescore | mã 400 ANSWER_TOO_SHORT/409/429/503, xử lý ở ResultsPage (T3 phụ trách) | Chưa xác minh (thuộc T3) | ResultsPage.jsx:637 | - |
| rescore | RescoreRequest openapi: tối thiểu 15 từ; backend @NotBlank max 10000 không ghi trong schema | LỆCH tài liệu | openapi:1354-1360 | Không (đề xuất) |

## Đề xuất cho Giang (không sửa backend/openapi)
1. Khai báo playbackUrl (nullable) trong PracticeSession/HistoryDetail, hoặc bổ sung vào list; hiện không có trường nào UI dùng để phát lại audio (audioUrl là khóa S3).
2. Thêm maxLength-theo-byte 72 vào ResetPasswordRequest.newPassword trong openapi (và RegisterRequest nếu cũng có).
3. Thêm maxLength 10000 vào RescoreRequest.transcript; liệt kê 503 SERVICE_UNAVAILABLE trong ErrorResponse mô tả (đã có), ghi rõ rescore 503 hoàn tác về SCORED.
4. Tham số thứ 2 của PracticeSessionDto.from/ScoreResultDto.from luôn null: ghi rõ trong openapi trường nào luôn null ở /history.
5. HistoryPage gọi /questions/{id} cho từng dòng (N+1); cân nhắc trả kèm tóm tắt câu hỏi.
