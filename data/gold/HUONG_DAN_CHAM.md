# Hướng dẫn cho người chấm

Bạn chấm 100 câu trả lời phỏng vấn theo rubric, ước tính khoảng 1,5-2 giờ, có thể chia nhiều buổi. Điểm của bạn là mốc để đo xem AI chấm có đúng không, nên hãy chấm theo đánh giá của chính bạn.

## Trước khi chấm

Đọc mục 3 của `docs/business/Rubric_Cham_Diem.md` (`rubric-v1.1`).

**Không mở các file trong `data/gold/labels/` và `data/gold/source/`, cũng không xem tab Files changed của PR.** Các nơi đó có nhãn nháp, xem rồi thì điểm của bạn không còn độc lập.

## Cách chấm

1. Mở `data/gold/rater.html` bằng Chrome hoặc Edge, nhập tên không dấu, ví dụ `vu`. Luôn dùng đúng máy, trình duyệt và tên đó, tiến độ lưu trong trình duyệt.
2. Đọc lời thí sinh, chấm từng tiêu chí bằng nút hoặc phím 1-5. Phím mũi tên trái, phải để chuyển câu.
3. Sau mỗi buổi, bấm **Tải phiếu CSV** để sao lưu. Nếu mất tiến độ, dùng **Nạp lại phiếu**.
4. Khi xong, gửi file CSV cuối cùng cho người tổng hợp.

## Nguyên tắc

- **Chấm độc lập.** Không trao đổi điểm hay bàn về câu cụ thể với người chấm khác cho tới khi tất cả đã nộp.
- **Bám mô tả mức điểm**, không chấm theo cảm giác chung. Mỗi tiêu chí chấm riêng: một câu có thể cấu trúc tốt nhưng sai chuyên môn.
- **Độ dài không phải là tiêu chí.** Câu ngắn vẫn có thể đạt điểm cao, câu dài vẫn có thể đạt điểm thấp.
- **Bỏ qua từ đệm và cách nói** như "ừm", "ờ". Phần đó được tính riêng bằng code.
- **DEPTH** đếm số yếu tố nói cụ thể, trang chấm hiện đúng 4 yếu tố của từng loại câu hỏi. Điểm bằng số yếu tố cộng 1.
- **CORRECTNESS** tính tỉ lệ ý đúng so với đáp án tham chiếu, mỗi gạch đầu dòng là một ý.
- **Thí sinh tự chọn vị trí:** câu hỏi không nêu vị trí thì không trừ điểm vì thí sinh tự nói về một vị trí.
- **Lạc đề (off_topic)** đánh dấu khi và chỉ khi RELEVANCE = 1, tức là không có ý nào trả lời trực tiếp câu hỏi, kể cả khi cùng lĩnh vực. Câu né tránh hoặc nói không biết là RELEVANCE 2, không phải lạc đề.
- Phân vân giữa hai mức thì chọn mức bạn tin hơn, không cần giải thích.
