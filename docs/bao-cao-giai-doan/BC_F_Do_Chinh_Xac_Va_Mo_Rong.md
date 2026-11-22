# Báo cáo giai đoạn F: Đo độ chính xác, đối chiếu theo ý, kiểm lỗi kiến thức, hướng RAG

- **Thời gian:** 06 - 22/11/2026. **Người làm:** Tuấn Anh (bộ chuẩn, công cụ đo, #159); Giang (quote đa mảnh, đối chiếu ý, kiểm lỗi, PR #24).
- **Lý thuyết:** [06_Giai_Doan_F](../hoc-bu/06_Giai_Doan_F_Do_Chinh_Xac_Va_Mo_Rong.md). **Trạng thái:** bộ chuẩn Một phần; PR #24 Chờ review.

## 1. Mục tiêu
Làm cho điểm của AI kiểm chứng được: đo so với người, cho người dùng thấy ý nào đúng/thiếu/sai, và định hướng chấm có căn cứ tri thức.

## 2. Chức năng
| Chức năng | Ticket | Người | PR / mốc | Trạng thái |
|---|---|---|---|---|
| Bộ chuẩn 144 câu trả lời, 24 câu hỏi, tách calibration/holdout | #159 | Tuấn Anh | PR #19, 06-07/11 | Xong |
| Công cụ đo QWK, Spearman, MAE; trang chấm mù offline | #159 | Tuấn Anh | 06/11 | Xong |
| Rubric v1.1 (làm rõ off_topic, DEPTH, STRUCTURE, CORRECTNESS) | #152 | Tuấn Anh | 07/11 | Xong |
| Nhãn người chấm 1 trên 100 câu | #159 | Tuấn Anh | 15/11 | Xong |
| **Người chấm 2, QWK giữa người, QWK AI so với người** | #159 | cả hai | - | **Chưa làm** |
| Quote nhiều đoạn nối bằng `...` (prompt-v2) | #156 | Giang | PR #24, 22/11 | Chờ review |
| Đối chiếu theo ý, điểm CORRECTNESS do server tính (V4) | #156 | Giang | PR #24 | Chờ review |
| Kiểm lỗi kiến thức song song (V5) | #156 | Giang | PR #24 | Chờ review |
| Đề xuất hướng RAG và đo bằng người chấm | - | Giang | `Huong_Mo_Rong.md` | Đề xuất |

## 3. Kết quả và số liệu
| Hạng mục | Số liệu |
|---|---|
| Bộ chuẩn | 144 câu, 16 câu hỏi calibration (96) + 8 holdout (48); người chấm chấm 100 câu |
| Hai phiên Claude chấm mù | QWK 0,93-0,98 (không phải độ chính xác: cùng họ mô hình) |
| Quote đa mảnh | cùng câu trả lời: tổng **75,0 → 97,5**; không còn `quote_invalid` |
| Thí nghiệm kiểm lỗi (cùng transcript) | Một lượt chấm đủ việc: **không** bắt được lỗi (0/4). Lượt riêng `gemini-3-flash-preview` `minimal`: bắt đúng 2/2, 1,4s, 423 token |
| Tự test E2E (backend thật, Gemini thật) | chấm lại 5,4s; CORRECTNESS 4 → 3 do 1 lỗi; tổng 76,3 → 66,3; token lượt kiểm lỗi 514 so với 1.908 của lượt chấm chính |
| Test | 371 test backend đạt sau khi gộp `main` |

## 4. Quyết định chính
1. CORRECTNESS do **server tính** từ các ý (coverage), bỏ điểm LLM tự cho.
2. Ý được khen mà trích dẫn không khớp transcript bị hạ một bậc.
3. Kiểm lỗi là **lượt riêng chạy song song**, không làm hỏng phiên khi lỗi; chỉ giữ lỗi có trích dẫn thật.
4. Hướng dài hạn: RAG (ingestion, vector store, retrieval, grounding), đo bằng người chấm mức từng ý.

## 5. Khó khăn và xử lý
- Điểm bị hạ oan do trích dẫn ghép nhiều đoạn: sửa prompt và validator.
- Đối chiếu theo ý bỏ sót lỗi nhập nhầm khái niệm (Giang phát hiện khi thử bằng giọng thật): thêm lượt kiểm lỗi riêng sau thí nghiệm chọn cách làm.
- Mô hình dòng 3.5-3.8 quá tải khi thử: dev dùng `3.1-flash-lite` cho lượt chấm, `3-flash-preview` cho lượt kiểm lỗi.

## 6. Còn lại và rủi ro
1. **Chưa đo "AI so với người"**; công thức quy đổi ý sang điểm 1-5 **chưa hiệu chỉnh**; quy tắc quote mới làm lệch bộ đo, **cần đo lại**.
2. Tỷ lệ bắt đúng và báo nhầm của kiểm lỗi **chưa đo** (mới một ca); đơn giá model preview **chưa xác minh**.
3. Đáp án tham chiếu do AI soạn, chưa duyệt hết.
4. Cần Tuấn Anh chốt: vector store (`pgvector` hay riêng), nguồn tri thức và giấy phép, ai gán nhãn mức từng ý, chấp nhận quy tắc quote mới.
