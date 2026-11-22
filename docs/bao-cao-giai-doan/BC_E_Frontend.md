# Báo cáo giai đoạn E: Frontend

- **Thời gian:** 22/10 - 20/11/2026 (PR #23 đang mở). **Người làm:** Tuấn Anh.
- **Lý thuyết:** [05_Giai_Doan_E](../hoc-bu/05_Giai_Doan_E_Frontend.md). **Trạng thái:** Xong phần chính; admin vỏ riêng chờ review; i18n chưa làm.

## 1. Mục tiêu
Ứng dụng web cho ứng viên (đăng nhập, chọn câu hỏi, ghi âm, xem kết quả, lịch sử) và cho quản trị viên, làm song song với backend nhờ mock.

## 2. Chức năng
| Chức năng | Ticket | PR / mốc | Trạng thái |
|---|---|---|---|
| Khung React/Vite, router, `client.js` gắn JWT, báo lỗi mạng 502-504, `dev:mock` | #115 | 22/10 | Xong |
| Đăng nhập, đăng ký theo Figma | #115 | 22/10 | Xong |
| Giao diện chọn câu hỏi (UC3) | #161 | PR #4, 22/10 | Xong |
| Phòng luyện tập: ghi âm `MediaRecorder`, nghe lại, ghi lại, upload; bỏ khung STAR cố định | #117 | PR #5, 22/10 | Xong |
| Màn kết quả theo rubric, khối Delivery | #122, #125 | PR #2, #6, 22/10 | Xong |
| Polling kết quả mỗi 2 giây, sửa transcript và chấm lại | #122 | 22/10, nối API 20/11 | Xong |
| Làm lại giao diện ứng viên theo Figma InterviewAI-MockupV1 | - | PR #17, merge 03/11 | Xong |
| Giao diện lịch sử và tiến độ | #118 | 22/10 | Xong (API cần nhánh có PR #18) |
| Quản trị câu hỏi, thống kê admin, xuất CSV, mã lỗi 429 | #162 | PR #22, 20/11 | Xong |
| Giao diện admin vỏ riêng, form câu hỏi dạng hộp thoại | #162 | PR #23 | Chờ review |
| Khối "Đối chiếu với đáp án tham chiếu", "Chỗ cần sửa" | - | PR #24, 22/11 (Giang thêm) | Chờ review |
| i18n Vi/En | #149 | - | Chưa làm (theo bàn giao 17/11) |
| Unit test frontend | #126 | - | Chưa có |

## 3. Kết quả
- Có route công khai, route đăng nhập và khu `/admin/*` bọc `RequireAdmin`.
- Kiểm bằng lint (oxlint), build và chạy tay với Prism; **chưa có test tự động frontend**.

## 4. Quyết định chính
1. Frontend code theo mock sinh từ `openapi.yaml`; không chờ backend.
2. Chỉ **401** mới đăng xuất; 403 thì không.
3. Thông báo lỗi tập trung ở `constants/scoring.js`.
4. Phân quyền UI chỉ là UX; chặn thật ở backend.

## 5. Khó khăn và xử lý
- Mock trả "string" và số âm: bổ sung dữ liệu mẫu.
- Thanh cuộn dọc thừa ở `AdminTabs` chỉ lộ trên Chrome Windows (`margin-bottom: -1px` trong `overflow-x: auto`): ghi vào `lessons-learned.md`.
- Prism không thực thi `minLength`: nhánh 400 phải giả lập.

## 6. Còn lại
Test tự động frontend (#126); i18n (#149); kiểm tay sửa/xóa thật, tải CSV thật, giao diện 1280px (còn ghi trong `test-report` của task `20261120-frontend-noi-api-moi`).
