# Bộ tài liệu học bù: Interview Practice AI

Mục đích: để Giang và Tuấn Anh cùng nắm **toàn bộ** những gì đã làm từ đầu đến 22/11/2026: giai đoạn nào, luồng chạy ra sao, lý thuyết nào đứng sau, khái niệm nào cần nói được. Dùng để viết phiếu báo cáo và giảng bài cho nhau.

Nguồn sự thật là mã nguồn và tài liệu trong repo; chỗ nào chưa kiểm chứng được thì ghi "Chưa xác minh". Số `file:dòng` có thể lệch vài dòng khi code đổi, hãy tìm theo tên hàm.

## Cách dùng
1. Đọc **Hiểu nhanh** của một giai đoạn, rồi **Từ điển**, rồi đọc **Thân bài** theo bước.
2. Tự giảng lại bằng khung "Nói / Vì sao / Nếu bị hỏi" ở mỗi giai đoạn, không nhìn tài liệu. Chỗ nào nói không ra là chỗ chưa hiểu.
3. Trả lời **Câu hỏi ôn** rồi mới đọc đáp án.
4. Buổi giảng cho nhau: mỗi người giảng 3 giai đoạn, đổi vai, 25 phút mỗi giai đoạn gồm 15 phút giảng và 10 phút hỏi. Gợi ý chia: Giang giảng phần mình làm nhiều nhất (A, C, D), Tuấn Anh giảng B, E, F. **Mỗi người nên được hỏi về phần của người kia**, vì vấn đáp thường hỏi chéo. Giai đoạn C và F có phần của cả hai người (lịch sử, quên mật khẩu do Tuấn Anh; bộ chuẩn do Tuấn Anh, đối chiếu và kiểm lỗi do Giang), nên cả hai cùng đọc.

## Lộ trình theo giai đoạn

| # | Giai đoạn | Thời gian | Người làm chính | File |
|---|---|---|---|---|
| A | Phân tích, thiết kế, CSDL, CI | 10/09 - 28/10 | Giang | [01_Giai_Doan_A_Thiet_Ke_Va_Nen_Mong.md](01_Giai_Doan_A_Thiet_Ke_Va_Nen_Mong.md) |
| B | Dữ liệu câu hỏi (thu thập, chuẩn hóa, seed) | 22 - 26/10 | Tuấn Anh | [02_Giai_Doan_B_Du_Lieu_Cau_Hoi.md](02_Giai_Doan_B_Du_Lieu_Cau_Hoi.md) |
| C | Xác thực và API nghiệp vụ | 27/10 - 20/11 | Giang (lịch sử, quên mật khẩu: Tuấn Anh) | [03_Giai_Doan_C_Xac_Thuc_Va_API.md](03_Giai_Doan_C_Xac_Thuc_Va_API.md) |
| D | Pipeline AI: upload, STT, chấm điểm, bất đồng bộ, độ bền | 04 - 20/11 | Giang | [04_Giai_Doan_D_Pipeline_AI.md](04_Giai_Doan_D_Pipeline_AI.md) |
| E | Frontend | 22/10 - 20/11 | Tuấn Anh | [05_Giai_Doan_E_Frontend.md](05_Giai_Doan_E_Frontend.md) |
| F | Đo độ chính xác, đối chiếu theo ý, kiểm lỗi kiến thức, hướng RAG | 06 - 22/11 | Tuấn Anh (bộ chuẩn), Giang (đối chiếu, kiểm lỗi) | [06_Giai_Doan_F_Do_Chinh_Xac_Va_Mo_Rong.md](06_Giai_Doan_F_Do_Chinh_Xac_Va_Mo_Rong.md) |

Thứ tự đọc: A → B → C → D → F → E. Giai đoạn E đọc sau D và F vì giao diện hiển thị kết quả của hai phần đó.

Tài liệu đi kèm:
- [00_Tu_Dien_Khai_Niem.md](00_Tu_Dien_Khai_Niem.md): từ điển toàn bộ khái niệm, tra nhanh.
- [Báo cáo theo giai đoạn và chức năng](../bao-cao-giai-doan/README.md): ma trận chức năng (ticket, người, PR, trạng thái), dựng từ lịch sử git và PR; mỗi giai đoạn một phiếu báo cáo.
- [Hướng mở rộng](../Huong_Mo_Rong.md): lộ trình RAG và các hướng tiếp theo.
- [Câu hỏi bảo vệ thiết kế](../Cau_Hoi_Bao_Ve_Thiet_Ke.md) và [Sổ tay ôn bảo vệ](../So_Tay_On_Bao_Ve_Thiet_Ke.pdf): chuẩn bị vấn đáp phần thiết kế.

## Bản đồ nhanh: hệ thống làm gì

```
Người dùng ──(ghi âm, web)──▶ Frontend React
                                  │  REST + JWT
                                  ▼
                           Backend Spring Boot (3 tầng)
   Controller ─▶ Service ─▶ Repository ─▶ PostgreSQL (Flyway V1..V5)
                  │
                  ├─▶ AudioStorage ──▶ AWS S3          (lưu file ghi âm)
                  └─▶ ScoringPipeline (chạy nền, bất đồng bộ)
                         ├─▶ SttClient ──▶ Gemini      (giọng nói → transcript)
                         ├─▶ LlmClient ──▶ Gemini      (chấm rubric + đối chiếu ý)
                         ├─▶ KnowledgeErrorDetector ──▶ Gemini (tìm phát biểu sai, song song)
                         ├─▶ DeliveryCalculator        (WPM, từ đệm: tính bằng code)
                         └─▶ ScoreCalculator           (server tính điểm tổng)
```

Ba nguyên tắc xuyên suốt, hay bị hỏi:
1. **LLM chấm từng tiêu chí, server tính điểm tổng.** LLM không được tự trả tổng điểm.
2. **Mọi điểm từ 3 trở lên phải có trích dẫn nguyên văn từ transcript**, hệ thống kiểm trích dẫn có thật.
3. **Mọi dịch vụ ngoài đi qua interface (port/adapter)** để thay nhà cung cấp và để test không gọi mạng.

## Việc tồn đọng khi viết tài liệu (22/11/2026)
- PR #24 (đối chiếu theo ý, kiểm lỗi, quote nhiều đoạn) đang chờ Tuấn Anh review.
- Chưa đo độ chính xác của bộ chấm so với người (cần nhãn của ít nhất 2 người chấm trên 100 câu, hiện mới có người chấm 1).
- Chưa đo AC-30 trên 14 mẫu; chưa có giọng người thật ngoài một vài lần thử.
- TTS (#121), deploy Render (#132), CD (#133) chưa làm; Dockerfile (#131) nằm ở nhánh riêng.
