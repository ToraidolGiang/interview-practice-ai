# Báo cáo giai đoạn C: Xác thực, phân quyền và API nghiệp vụ

- **Thời gian:** 27/10 - 20/11/2026. **Người làm:** Giang (auth, câu hỏi, thống kê admin); Tuấn Anh (lịch sử, quên mật khẩu).
- **Lý thuyết:** [03_Giai_Doan_C](../hoc-bu/03_Giai_Doan_C_Xac_Thuc_Va_API.md). **Trạng thái:** Xong.

## 1. Mục tiêu
Biến hợp đồng OpenAPI thành API chạy thật, có bảo mật: đăng ký/đăng nhập, phân quyền, tra cứu và quản trị câu hỏi, lịch sử, quên mật khẩu, thống kê.

## 2. Chức năng
| Chức năng | Ticket | Người | PR / mốc | Trạng thái |
|---|---|---|---|---|
| Đăng ký, đăng nhập, JWT HS256 24h, phân quyền `/admin/**` | #112 | Giang | PR #9, #13, #14; merge 28/10 | Xong |
| Hardening auth: email `Locale.ROOT`, 409 trùng đồng thời, mật khẩu theo byte, khóa 15 phút sau 5 lần sai, chống dò email, bộ lọc nạp lại user mỗi request | #112 | Giang | 27-28/10 | Xong |
| `ErrorResponse` thống nhất, `GlobalExceptionHandler`, `DbConstraints` | #112, #116 | Giang | 27-28/10 | Xong |
| Tra cứu câu hỏi: lọc, vị trí `Chung`, ngẫu nhiên, chi tiết | #116 | Giang | PR #16, merge 17/11 | Xong |
| Quản trị câu hỏi: thêm, sửa, xóa mềm/cứng, ghi audit log cùng transaction | #116 | Giang | PR #16, merge 17/11 | Xong |
| Hợp đồng API câu hỏi (làm rõ 400/409, quy tắc `Chung`, `referenceAnswer`) | #116 | Giang | PR #15, merge 17/11 | Xong |
| API lịch sử `GET /history`, `/history/{id}` | #118 | Tuấn Anh | PR #18, commit 03/11, merge 20/11 | Xong |
| Quên và đặt lại mật khẩu (token SHA-256, chờ gửi lại, `MailService`) | #157 | Tuấn Anh | PR #21, commit 17/11, merge 20/11 | Xong |
| Thống kê admin: overview, theo user, xuất CSV (xlsx trả 400) | #163 | Giang | commit 19/11, merge 20/11 | Xong (xlsx chưa hỗ trợ) |

## 3. Kết quả và số liệu
- 21 đường dẫn trong `openapi.yaml` (auth 4, câu hỏi 3, phiên luyện tập 7, lịch sử 2, admin câu hỏi 2, admin thống kê 3); riêng `/practice-sessions/{id}/feedback/audio` (TTS) chưa cài.
- Có test tích hợp trên Postgres thật cho auth, câu hỏi, lịch sử, thống kê (371 test backend đạt đến 22/11).

## 4. Quyết định chính
1. Bộ lọc JWT **không tin role trong token**, nạp lại user từ DB mỗi request.
2. Kiểm mật khẩu theo **byte UTF-8** (BCrypt chỉ dùng 72 byte đầu).
3. Chỉ đổi sang 409 khi vi phạm đúng chỉ mục `uq_users_email`.
4. Token đặt lại mật khẩu chỉ lưu SHA-256; phản hồi quên mật khẩu luôn giống nhau.
5. Xóa câu hỏi mặc định là xóa mềm (`HIDDEN`).

## 5. Khó khăn và xử lý
- Đăng nhập song song có thể vượt giới hạn 5 lần: khóa dòng bằng `PESSIMISTIC_WRITE`.
- 404 bị che thành 401: cho phép `/error` công khai.
- PR #15 cần Tuấn Anh xác nhận hợp đồng nên #16 phải chờ đến 17/11.
- `GET /history` ban đầu có thể tràn offset: giới hạn `page` tối đa 1.000.000, trả 400.

## 6. Còn lại
Chưa rate limit đăng nhập theo IP; chưa thu hồi JWT chủ động ngoài việc khóa user; xlsx cho xuất thống kê; bật lại câu `HIDDEN` và audit log theo user chưa có API.
