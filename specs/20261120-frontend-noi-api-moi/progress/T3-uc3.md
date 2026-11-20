# T3 - Biên bản rà soát UC3 (QuestionsPage, #161)
Rà bằng đọc code; chưa kiểm thủ công trên trình duyệt (không có công cụ).

| Điểm kiểm | Kết quả | file:dòng | Đã sửa? |
|---|---|---|---|
| Loading (tải đầu "Đang tải...", đổi filter làm mờ lưới cũ) | Đạt | QuestionsPage.jsx:200,251 | Không |
| Lỗi tải list (alert role=alert, không dữ liệu cũ) | Đạt (không có nút "Thử lại", đề xuất) | :220-224 | Không |
| Rỗng (thông điệp + Xoá bộ lọc + random trong ngành) | Đạt | :226-247 | Không |
| Trang vượt tổng (URL page=99) hiện trạng thái rỗng có "Xoá bộ lọc" dù không lọc | Lệch nhỏ, đề xuất (cần đưa về trang cuối) | :226 | Không |
| Phân trang giữ filter khi đổi trang | Đạt (copy searchParams) | :59-65 | Không |
| Đổi filter về trang 0; đổi ngành bỏ vị trí | Đạt | :50-57 | Không |
| Filter đồng bộ URL, back/forward | Lệch: ô từ khoá không theo URL khi back/forward | :27-34 | Đã sửa (đồng bộ keyword khi render) |
| Keyword tối đa 200 ký tự (openapi) | Lệch: không giới hạn, gõ >200 gây 400 | :117 | Đã sửa (maxLength=200) |
| Random: 404 -> thông báo; lỗi khác -> message | Đạt | :72-78, useStartPractice.js:22-27 | Không |
| Random gửi đúng tham số (industry, position, level) | Đạt; questionType/keyword không gửi do API không hỗ trợ | api/questions.js:17-19 | Không |
| Vị trí "Chung" (có trong select; subtitle giải thích; backend tự gộp) | Đạt | taxonomy.js:9,23; QuestionsPage.jsx:277-283 | Không |
| Câu hỏi HIDDEN không lọt UI | Đạt: server lọc ACTIVE (openapi:152), UI không có đường khác | api/questions.js | Không |
| Bàn phím/aria (nav Phân trang, aria-current, aria-pressed, label, role=search) | Đạt | Pagination.jsx:19,38; QuestionsPage.jsx:299 | Không |
| Mobile 390px (breakpoint 1080/720 về 1-2 cột, flex-wrap) | Đạt theo CSS, chưa soi bằng mắt | QuestionsPage.module.css:322-345 | Không |
| Ô "Sắp xếp" chỉ có 1 lựa chọn giả | Ghi nhận (có chú thích API chưa hỗ trợ) | :208-213 | Không |

Đề xuất (không làm, ngoài phạm vi Q2): nút "Thử lại" khi lỗi tải; tự về trang cuối khi page vượt tổng; ẩn/bỏ ô Sắp xếp.
