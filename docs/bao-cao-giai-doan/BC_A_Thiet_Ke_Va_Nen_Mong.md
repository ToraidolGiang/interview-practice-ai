# Báo cáo giai đoạn A: Phân tích, thiết kế, CSDL, CI

- **Thời gian:** 10/09 - 28/10/2026 (khối lượng tập trung 13-15/10 và 27-28/10). **Người làm chính:** Giang; Tuấn Anh viết kế hoạch coding.
- **Lý thuyết:** [01_Giai_Doan_A](../hoc-bu/01_Giai_Doan_A_Thiet_Ke_Va_Nen_Mong.md). **Trạng thái:** Xong.

## 1. Mục tiêu
Chốt yêu cầu, kiến trúc, CSDL và hợp đồng API để hai người code song song; có CI chạy test mỗi lần đẩy code.

## 2. Chức năng và sản phẩm
| Hạng mục | Nội dung | Người | Mốc / PR | Trạng thái |
|---|---|---|---|---|
| Tài liệu nghiệp vụ, SRS v1.0, đặc tả 9 use case, user story | `docs/business/` | Giang | 24/09, 13/10 | Xong |
| Báo cáo thiết kế hệ thống | Kiến trúc, 6 class diagram, sequence/activity mỗi use case, use case diagram, ERD | Giang (Tuấn Anh 1 commit 14/10) | 13-15/10 | Xong |
| Thiết kế CSDL | `V1__init.sql` (8 bảng), ERD, từ điển dữ liệu; `ddl-auto: validate` | Giang | 13/10 | Xong |
| Hợp đồng API v0.2.0 | Chấm bất đồng bộ (202 + polling), đặt lại mật khẩu, phân trang; Rubric chấm điểm | Giang | 13/10 | Xong |
| Tài liệu bảo vệ | Câu hỏi bảo vệ thiết kế, sổ tay ôn | Giang | 13/10, 21/10 | Xong |
| Kế hoạch coding, phân vai | Chia ticket Jira, ranh giới thư mục, quy tắc nhánh/commit/PR | Tuấn Anh | PR #1, 22/10 | Xong |
| Entity JPA, repository | 8 entity khớp V1 | Giang | #111, PR #8, merge 28/10 | Xong |
| CI | GitHub Actions: build, test với Postgres 16, lint và build frontend | Giang | #113, PR #10, merge 28/10 | Xong |

## 3. Kết quả và số liệu
- 8 bảng: `users`, `questions`, `practice_sessions`, `score_results`, `score_criteria`, `api_usages`, `audit_logs`, `password_reset_tokens`.
- 5 migration tính đến 22/11: V1 schema, V2 seed, V3 `evaluation_attempts`, V4 `score_points`, V5 `score_errors`.
- Tài liệu tri thức: ADR-001, `architecture.md`, `conventions.md`, `lessons-learned.md`, `tech-debt.md` trong `docs/knowledge/`.

## 4. Quyết định chính
1. **Monolith 3 tầng**, không microservices (quy mô 2 người, 2 tháng).
2. **Adapter/port** cho mọi dịch vụ ngoài (STT, LLM, TTS, mail, lưu trữ).
3. **Chấm bất đồng bộ** trong tiến trình (ADR-001): STT từng mất tới 83 giây trong một lần đo.
4. **Flyway** quản lý schema; không sửa migration đã chạy.
5. **Contract-first:** `openapi.yaml` là nguồn sự thật chung; đổi API qua PR riêng.

## 5. Khó khăn và xử lý
- Chạy backend trên Windows lỗi múi giờ `Asia/Saigon` với PostgreSQL 16: đặt `JAVA_TOOL_OPTIONS=-Duser.timezone=Asia/Ho_Chi_Minh`.
- Cấu hình test đặt sai chỗ nên giá trị giả không được nạp: đặt tại `src/test/resources/config/application.yml`.
- Build lỗi do sai JDK: dùng JDK 21.

## 6. Còn lại
Khoảng trống 28/09 - 11/10 không có commit; **chưa xác minh** công việc ngoài repo. Biên bản họp với giảng viên chưa có trong repo.
