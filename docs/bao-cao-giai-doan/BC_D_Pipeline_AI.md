# Báo cáo giai đoạn D: Pipeline AI

- **Thời gian:** 04 - 20/11/2026 (PR #20 mở 17/11, merge 20/11). **Người làm:** Giang.
- **Lý thuyết:** [04_Giai_Doan_D](../hoc-bu/04_Giai_Doan_D_Pipeline_AI.md). **Trạng thái:** phần cốt lõi Xong; TTS, Dockerfile, deploy **chưa**.

## 1. Mục tiêu
Người dùng nộp ghi âm, hệ thống lưu, chuyển thành chữ, chấm theo rubric, tính điểm và trả kết quả, chạy nền và không để phiên treo.

## 2. Chức năng
| Chức năng | Ticket | Mốc | Trạng thái |
|---|---|---|---|
| Cấu hình nền: AWS SDK S3, thuộc tính Gemini/audio/executor | #119 | 04/11 | Xong |
| Tạo phiên, upload audio S3 (khóa do server sinh, MIME + đuôi + dung lượng) | #160 | 04/11 | Xong |
| STT Gemini `gemini-3.5-transcribe` VERBATIM, timeout 15s, thử lại 1 lần | #119 | 04/11, sửa 17/11 | Xong |
| Chấm LLM theo rubric: `responseSchema`, kiểm schema, nhiệt độ 0,2 | #120 | 04/11 | Xong |
| Chống prompt injection; kiểm trích dẫn (`QuoteValidator`) | #154 | 04/11 | Xong |
| Chấm bất đồng bộ 202 + polling, executor queue giới hạn, 503 khi đầy | #156 | 04/11 | Xong |
| Delivery (WPM, từ đệm) tính bằng code; tổng điểm do server tính | #123 | 22/10 (Tuấn Anh), tích hợp 04/11 | Xong |
| F3: quét phiên kẹt `PROCESSING` > 300s thành `PROCESSING_TIMEOUT` | #156 | 19/11 | Xong |
| F4: tối đa 3 phiên đang chấm mỗi user; 20 lượt/ngày (bảng `evaluation_attempts` V3) | #156 | 19-20/11 | Xong |
| F5: xóa file S3 mồ côi khi nộp lại hoặc thua cuộc đua | #156 | 19/11 | Xong (còn S3 lifecycle) |
| F2: `ScoringInputView` thay phụ thuộc ngược | #156 | 19/11 | Xong |
| Sửa transcript và chấm lại (`/rescore`), không gọi lại STT | #155 | 19/11 | Xong |
| Ghi `api_usages` mỗi lần gọi AI (nguồn cho thống kê #163) | #156 | 04/11 | Xong |
| TTS đọc phản hồi (FPT.AI) | #121 | - | Chưa làm |
| Dockerfile | #131 | nhánh riêng | Chưa merge |
| Deploy Render, CD | #132, #133 | - | Chưa làm |

## 3. Kết quả và số liệu thật
- **STT (22/11, giọng tiếng Việt thật, 61 giây):** chính xác thuật ngữ (Gini, entropy, siêu tham số), giữ "Ờ", "Ừ".
- **Độ trễ (một mẫu 61 giây):** STT 4,6s + LLM 3,0s, nộp đến có kết quả **8,9s**, đạt NF1 ≤ 12s. Chấm lại không STT: 5,4s.
- **Điểm một phiên thật:** 4 tiêu chí 5/5, Delivery 4,0 → tổng 97,5 (WPM 207 nghi cao vì `durationSeconds` do client khai).
- **Model LLM (thử 22/11, cùng request có schema):** `gemini-3.1-flash-lite` 1,9s, `gemini-3-flash-preview` 13s, `gemini-3.8-flash` 503 hoặc treo, `gemini-3.5-3.7-flash` chậm hoặc 503; `gemini-2.5-flash` chạy nhưng ngừng ngày 01/12.

## 4. Quyết định chính
1. LLM chỉ chấm tiêu chí; **server tính điểm tổng**.
2. Chuyển trạng thái bằng `UPDATE ... WHERE status IN (...)`; I/O ngoài transaction.
3. Mọi lỗi chốt `FAILED` kèm mã lỗi; có job quét và giới hạn theo user.
4. Chỉ chạy đúng 1 instance (ADR-001).

## 5. Khó khăn và xử lý
- Transcript nằm ở `audioTranscription.text` chứ không phải `text`: sửa client sau smoke test 17/11.
- `gemini-3.8-flash` quá tải: đổi model dev sang `3.1-flash-lite`.
- Ghi `api_usages` bị bắt lỗi nhầm trong transaction: bỏ `@Transactional` ở `ApiUsageRecorder.record` (theo review PR #20).
- Hibernate INSERT trước DELETE khi chấm lại: `flush()` DELETE trước.

## 6. Còn lại
Chốt model trước 01/12; đo AC-30 đủ 14 mẫu; `wordTimestamp` để WPM thật; S3 lifecycle; TTS; Dockerfile (#131), deploy (#132), CD (#133); metric (độ sâu queue, p95, số `PROCESSING_TIMEOUT`).
