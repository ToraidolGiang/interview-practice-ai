# Báo cáo tiến độ theo giai đoạn và chức năng

Dựng ngày 22/11/2026 từ lịch sử git, PR GitHub, các bản bàn giao 17/11 và 19/11, `Ke_Hoach_Coding.md`. Chia theo **giai đoạn công việc và chức năng** thay vì theo tuần, vì khối lượng mỗi tuần chênh nhau nhiều (có tuần không có commit, có ngày 20 commit).

Mỗi báo cáo giai đoạn có cùng khung: mục tiêu, chức năng đã làm (ticket, người, PR, ngày), kết quả và số liệu, quyết định, khó khăn, trạng thái và việc còn lại. Lý thuyết và khái niệm của từng giai đoạn nằm ở [`docs/hoc-bu/`](../hoc-bu/README.md).

Chú thích trạng thái: **Xong** = đã merge vào `main`; **Chờ review** = PR đang mở; **Chưa làm**; **Một phần** = làm được một phần, ghi rõ phần còn lại. Trạng thái Jira có thể chưa cập nhật theo.

## 1. Danh sách báo cáo
| Giai đoạn | Báo cáo | Lý thuyết |
|---|---|---|
| A. Phân tích, thiết kế, CSDL, CI | [BC_A](BC_A_Thiet_Ke_Va_Nen_Mong.md) | [01](../hoc-bu/01_Giai_Doan_A_Thiet_Ke_Va_Nen_Mong.md) |
| B. Dữ liệu câu hỏi | [BC_B](BC_B_Du_Lieu_Cau_Hoi.md) | [02](../hoc-bu/02_Giai_Doan_B_Du_Lieu_Cau_Hoi.md) |
| C. Xác thực và API nghiệp vụ | [BC_C](BC_C_Xac_Thuc_Va_API.md) | [03](../hoc-bu/03_Giai_Doan_C_Xac_Thuc_Va_API.md) |
| D. Pipeline AI | [BC_D](BC_D_Pipeline_AI.md) | [04](../hoc-bu/04_Giai_Doan_D_Pipeline_AI.md) |
| E. Frontend | [BC_E](BC_E_Frontend.md) | [05](../hoc-bu/05_Giai_Doan_E_Frontend.md) |
| F. Đo độ chính xác, đối chiếu theo ý, kiểm lỗi, RAG | [BC_F](BC_F_Do_Chinh_Xac_Va_Mo_Rong.md) | [06](../hoc-bu/06_Giai_Doan_F_Do_Chinh_Xac_Va_Mo_Rong.md) |

## 2. Ma trận chức năng (toàn dự án)
| Chức năng | GĐ | Ticket | Người | PR / thời điểm | Trạng thái |
|---|---|---|---|---|---|
| Thiết kế, SRS, báo cáo thiết kế, ERD, API v0.2.0 | A | (tài liệu) | Giang | 13-21/10 | Xong |
| Kế hoạch coding và phân vai | A | - | Tuấn Anh | PR #1, 22/10 | Xong |
| CSDL Flyway V1, entity, repository | A | #111 | Giang | PR #8, merge 28/10 | Xong |
| CI GitHub Actions | A | #113 | Giang | PR #10, merge 28/10 | Xong |
| Thu thập và chuẩn hóa câu hỏi, seed V2 | B | #114 | Tuấn Anh | PR #7, 26/10 | Xong (seed chưa duyệt) |
| Đăng ký, đăng nhập, JWT, phân quyền | C | #112 | Giang | PR #9, #13, #14, merge 28/10 | Xong |
| API tra cứu và quản trị câu hỏi | C | #116 | Giang | PR #15, #16, merge 17/11 | Xong |
| API lịch sử luyện tập | C | #118 | Tuấn Anh | PR #18, merge 20/11 | Xong |
| Quên và đặt lại mật khẩu | C | #157 | Tuấn Anh | PR #21, merge 20/11 | Xong |
| Thống kê và xuất CSV cho admin | C | #163 | Giang | merge 20/11 (PR #20) | Xong (xlsx chưa hỗ trợ) |
| Tạo phiên, upload audio S3 | D | #160 | Giang | PR #20, merge 20/11 | Xong |
| STT Gemini (VERBATIM) | D | #119 | Giang | PR #20 | Xong |
| Chấm điểm LLM theo rubric | D | #120 | Giang | PR #20 | Xong |
| Chống prompt injection, kiểm trích dẫn | D | #154 | Giang | PR #20 | Xong |
| Chấm bất đồng bộ (202 + polling) | D | #156 | Giang | PR #20 | Xong |
| Độ bền: phiên kẹt, giới hạn user, hạn mức ngày, file mồ côi | D | #156 (F2-F5) | Giang | PR #20, 19-20/11 | Xong |
| Sửa transcript và chấm lại (rescore) | D | #155 | Giang | PR #20 | Xong |
| TTS đọc phản hồi | D | #121 | Giang | - | Chưa làm |
| Dockerfile | D | #131 | Giang | nhánh `feature/DLPVXVTHA-131-dockerfile` | Chưa merge |
| Deploy Render, CD | D | #132, #133 | Giang | - | Chưa làm |
| Khung FE, đăng nhập/đăng ký | E | #115 | Tuấn Anh | 22/10 | Xong |
| Phòng luyện tập (ghi âm, upload) | E | #117 | Tuấn Anh | PR #5, 22/10 | Xong |
| Màn kết quả và khối Delivery | E | #122, #125 | Tuấn Anh | PR #2, #6, 22/10 | Xong |
| `DeliveryCalculator` (WPM, từ đệm) | E/D | #123 | Tuấn Anh | PR #3, 22/10 | Xong |
| Giao diện chọn câu hỏi | E | #161 | Tuấn Anh | PR #4, #17 | Xong |
| Giao diện lịch sử | E | #118 | Tuấn Anh | 22/10 | Xong |
| Giao diện admin: câu hỏi, thống kê, mã lỗi 429 | E | #162 | Tuấn Anh | PR #22, 20/11 | Xong |
| Giao diện admin vỏ riêng, form dạng hộp thoại | E | #162 | Tuấn Anh | PR #23 | Chờ review |
| i18n Vi/En | E | #149 | Tuấn Anh | - | Chưa làm (theo bàn giao 17/11) |
| Bộ dữ liệu chuẩn, công cụ đo QWK, rubric v1.1 | F | #159, #152 | Tuấn Anh | PR #19, merge 20/11 | Một phần (người chấm 2, đo chưa có) |
| Sửa quote nhiều đoạn (prompt-v2) | F | #156 | Giang | PR #24, 22/11 | Chờ review |
| Đối chiếu theo ý của đáp án (V4) | F | #156 | Giang | PR #24 | Chờ review |
| Kiểm lỗi kiến thức song song (V5) | F | #156 | Giang | PR #24 | Chờ review |
| Hướng RAG, đo bằng người chấm | F | - | cả hai | `Huong_Mo_Rong.md` | Đề xuất |

## 3. Khối lượng theo người (từ lịch sử git trên `main`, đến 22/11)
| Người | Commit (không tính merge) | Phần nổi bật |
|---|---|---|
| Giang | 51 | Thiết kế, CSDL, auth, API câu hỏi, pipeline AI, độ bền |
| Tuấn Anh | 39 | Frontend, dữ liệu câu hỏi, DeliveryCalculator, lịch sử, quên mật khẩu, bộ chuẩn |

Số commit chỉ là chỉ báo thô, không phản ánh độ khó hay thời gian làm.

## 4. Mốc thời gian (để tra cứu, không dùng để chia khối lượng)
| Mốc | Sự kiện |
|---|---|
| 10/09 | Khởi tạo repo |
| 13/10 | Thiết kế CSDL, API v0.2.0, báo cáo thiết kế |
| 22/10 | Kế hoạch coding; frontend, DeliveryCalculator và script dữ liệu (PR #1-#6) |
| 26/10 | Seed câu hỏi (PR #7) |
| 27-28/10 | Auth, CI, API câu hỏi (PR #8-#16) |
| 04/11 | Nền pipeline AI |
| 07/11 | Rubric v1.1, bộ chuẩn |
| 15/11 | Nhãn người chấm 1; chọn model Gemini |
| 17/11 | Smoke test Gemini; quên mật khẩu; mở PR #20 |
| 19-20/11 | Độ bền, rescore, thống kê admin; merge PR #18-#22 |
| 22/11 | Chạy thử thật, sửa quote, đối chiếu theo ý, kiểm lỗi (PR #24) |

Không có commit trong repo từ 28/09 đến 11/10 và từ 29/10 đến 31/10; nhóm làm gì ngoài repo trong khoảng đó thì **chưa xác minh**.

## 5. Rủi ro và việc tồn đọng chung (22/11)
1. **Chưa có số "AI so với người"**: mới có người chấm 1, cần người chấm 2 để tính trần đồng thuận.
2. **Seed câu hỏi chưa duyệt** (`V2` sinh bằng `--allow-pending`); đáp án tham chiếu do AI soạn.
3. **Model LLM chưa chốt**: mặc định `gemini-3.8-flash` bị 503 hoặc treo; dev dùng `gemini-3.1-flash-lite`; `gemini-2.5-flash` ngừng 01/12.
4. **AC-30** (≤ 12s, 14 mẫu 10-131s) chưa đo đủ; mới có một mẫu 61s đạt 8,9s.
5. **Deploy** (#131-#133) và **TTS** (#121) chưa xong.
6. Jira: chuyển #119 #120 #154 #156 #160 sang Done, đóng Sprint 2, đặt ngày Sprint 4.
