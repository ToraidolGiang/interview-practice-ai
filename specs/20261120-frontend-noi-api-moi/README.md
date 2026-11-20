# Frontend nối các API mới (mã lỗi, chọn câu hỏi, quản trị câu hỏi, nối API đã merge)
status: done
type: feature
created: 2026-11-20
level: standard
risk: normal — chỉ frontend, không đổi hợp đồng API/schema/phân quyền backend; UI admin dựa trên RBAC sẵn có của backend

## Tóm tắt
Bốn việc theo thứ tự: (1) hiển thị mã lỗi PROCESSING_TIMEOUT, TOO_MANY_PROCESSING, DAILY_LIMIT_EXCEEDED; (2) #161 UI chọn câu hỏi; (3) #162 UI quản trị câu hỏi; (4) nối frontend với API đã merge (lịch sử #118, quên mật khẩu #157, rescore #155, admin analytics #163).
Bỏ khảo sát đối chuẩn web: UI bám thiết kế Figma InterviewAI-MockupV1 đã có trong dự án (xác minh ở bước khảo sát).

## Usage
| Bước | Agent | Model | Token | Tool-use | Thời gian |
|---|---|---|---|---|---|

Tri thức: chưa cập nhật
Số vòng: test-fix 0 · review-fix 0 · DESIGN_ISSUE 0

## Nhật ký quyết định
- 2026-11-20 — Gộp 4 việc thành một task nhiều WP theo thứ tự người dùng nêu — người dùng yêu cầu "làm theo thứ tự 4 việc"
- 2026-11-20 — Cổng 1 duyệt: Q3 làm trang /admin/analytics (overview + xuất CSV) cùng menu admin; Q4 không làm chi tiết user, ghi đề xuất cho Giang (GET /admin/analytics/users hoặc cột userId); Q5 nút Xóa + hộp thoại cảnh báo; giữ mặc định D1-D5, Q1, Q2, Q6, Q7 — người dùng duyệt
- 2026-11-20 — Bước 3 xong: impact.md không có rủi ro Cao, không câu hỏi chặn; thêm mặc định D6 (estimatedCost hiển thị số kèm nhãn 'ước tính', hỏi Giang đơn vị tiền) — ghi nhận, chờ duyệt ở Cổng 2
- 2026-11-20 — Cổng 2 duyệt: thiết kế 9 WP / 4 wave, giữ nguyên mặc định G1-G8, risk normal (review thêm lăng kính bảo mật cho client.js, RequireAdmin) — người dùng duyệt
- 2026-11-20 — Task xong: review APPROVE (F1-F3 đã sửa và xác nhận), kiểm thủ công trình duyệt phát hiện và sửa lỗi cuộn thừa AdminTabs (chưa qua reviewer); chờ người dùng chạy /devteam:ship
