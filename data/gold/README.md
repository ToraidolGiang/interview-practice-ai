# Bộ dữ liệu chuẩn (DLPVXVTHA-159)

Dùng để đo độ chính xác của bộ chấm theo `docs/business/Rubric_Cham_Diem.md` mục 9.

> **Trạng thái: nháp.** Câu trả lời và nhãn trong `labels/claude_draft.jsonl` do Claude viết, chưa có người chấm. Chưa được dùng kết quả so với nhãn này làm số liệu "AI so với người" trong báo cáo.

## Thành phần

| File | Nội dung |
|---|---|
| `gold_v1.jsonl` | 144 câu trả lời kèm câu hỏi, đáp án tham chiếu, tập và `rating_set`, không có nhãn |
| `labels/claude_draft.jsonl` | Nhãn nháp của Claude, kèm mức dự kiến và lý do |
| `labels/claude_blind.jsonl` | Điểm AI: một phiên Claude khác chấm mù, chỉ thấy rubric và câu trả lời. Không phải điểm người |
| `rater.html` | Trang chấm mù chạy offline, tự lưu tiến độ, xuất CSV. Đây là cách chấm chính |
| `HUONG_DAN_CHAM.md` | Hướng dẫn cho người chấm |
| `rater_sheet.csv` | Phiếu chấm mù dạng bảng, dùng khi không chấm bằng `rater.html` |
| `source/*.jsonl` | Bản gốc để sửa. `contrast.jsonl` là các câu đối chứng ngắn mà tốt, dài mà yếu |

Sửa `source/` rồi chạy lại `python scripts/gold/build_gold.py`, không sửa tay các file sinh ra.

## Thiết kế

- 24 câu hỏi có trong seed V2, mỗi loại 6 câu; 6 câu trả lời mỗi câu hỏi (5 mức chất lượng và 1 câu đối chứng).
- Tách tập theo câu hỏi: 16 câu hỏi calibration (96 câu trả lời), 8 câu hỏi holdout (48 câu trả lời).
- Người chấm chấm 100 câu (`rating_set`): đủ 48 câu holdout và 52 câu calibration, mỗi loại 13 câu, trải đều các mức. Các số liệu so với người chỉ tính trên 100 câu này.
- Có các ca khó: lạc đề, dài mà rỗng, ngắn mà tốt, trình bày tốt nhưng sai chuyên môn.
- Câu trả lời viết theo văn nói, từ đệm có ở cả câu tốt lẫn câu yếu.

## Quy trình

1. **Chấm:** 2-3 người chấm độc lập theo `HUONG_DAN_CHAM.md`.
2. **Nhập điểm:** `python scripts/gold/import_ratings.py phieu.csv --rater nguoi_cham_1`
3. **Đo đồng thuận giữa người chấm:** `python scripts/gold/metrics.py --split all --ref data/gold/labels/nguoi_cham_1.jsonl --pred data/gold/labels/nguoi_cham_2.jsonl`. Nếu QWK giữa người dưới 0.6 thì rubric còn mơ hồ: làm rõ mô tả mức điểm, tăng `rubric-v`, chấm lại, chưa chỉnh AI.
4. **Chạy pipeline** trên `transcript` của từng câu, lưu kết quả cùng định dạng file nhãn: `{"id": "GOLD-001", "scores": {"RELEVANCE": 4, "STRUCTURE": 3, "DEPTH": 3}, "off_topic": false}`
5. **Đo bộ chấm:** `python scripts/gold/metrics.py --ref <nhãn người> --pred lan1.jsonl --pred lan2.jsonl`. Chạy riêng với **từng** người chấm rồi lấy trung bình, không gộp điểm người chấm thành một nhãn. Truyền nhiều `--pred` để đo độ lặp lại, rubric yêu cầu 5 lần.
6. **Đọc kết quả:** bộ chấm đạt khi QWK với người từ 0.6 trở lên, vượt "Mốc độ dài", và không thấp hơn nhiều so với QWK giữa người với người. Mức đồng thuận giữa người là trần thực tế của AI.
7. **Chốt:** chỉ dùng `--split holdout` một lần sau khi đã ngừng chỉnh prompt. Nếu chỉnh tiếp sau khi xem holdout thì holdout không còn giá trị.

Chạy test: `python -m unittest discover -s scripts/gold`

## Cách ghi trong báo cáo

Điền số thật sau khi đo, giữ nguyên các phần công bố:

> Bộ dữ liệu gồm 144 câu trả lời tổng hợp do Claude sinh theo 5 mức chất lượng, trên 24 câu hỏi thuộc 4 loại, không phải câu trả lời của ứng viên thật. Điểm tham chiếu do N người chấm độc lập trên 100 câu theo rubric, không xem nhãn nháp. Đồng thuận giữa người chấm đạt QWK = ... . Trên tập giữ lại 48 câu không dùng khi chỉnh prompt, bộ chấm đạt QWK trung bình = ... so với người chấm, Spearman = ..., MAE = ... . Bộ chấm giả chỉ dựa vào độ dài đạt QWK = ... . Do người chấm đồng thời là thành viên nhóm phát triển và dữ liệu chỉ có văn bản, kết quả chưa khái quát cho ứng viên thật và chưa bao gồm sai số STT.

Bỏ câu về thành viên nhóm nếu người chấm là người ngoài nhóm. Không dùng `labels/claude_draft.jsonl` hay `labels/claude_blind.jsonl` làm tham chiếu cho số liệu AI so với người trong báo cáo.

## Kết quả chấm mù bằng AI

Hai phiên Claude khớp nhau ở mức QWK 0.93-0.98 trên cả 144 câu, Spearman điểm tổng 0.955. Con số này chỉ cho thấy các mức chất lượng tách biệt rõ với chính Claude. Nó không đo độ chính xác, vì cùng một họ mô hình, và câu trả lời được viết theo mức định sẵn nên dễ chấm hơn câu thật.

Hai bộ nhãn `claude_*` được chấm theo `rubric-v1.0`, trước khi rubric đổi sang v1.1.

Khi thử áp dụng v1.1 bằng các phiên mù, rubric giải quyết được phần lớn câu từng khó, nhưng trên 15 câu chưa từng thử chỉ 3 câu được quyết định hoàn toàn bằng câu chữ, phần còn lại cần phán đoán, thường lệch 1 điểm. Vì vậy không thể coi rubric là hết mơ hồ; thước đo đúng là đồng thuận giữa người chấm ở bước 3.

## Giới hạn

- **Không thay được người chấm.** Claude vừa viết câu trả lời vừa gán nhãn theo mức đã định sẵn, nên nhãn nháp không độc lập với câu trả lời. Rubric mục 9 yêu cầu 2-3 người chấm.
- **Không phải dữ liệu thật.** Câu trả lời do Claude viết có thể đều và mạch lạc hơn người thật. Nên bổ sung câu trả lời thật khi có.
- **Chỉ có văn bản.** Không có audio nên chưa đo được STT, Delivery, độ trễ 12 giây và giọng vùng miền. Các phần này cần ghi âm thật.
- **Độ dài vẫn tương quan với điểm** (Spearman khoảng 0.7 trên nhãn nháp). Bộ chấm giả chỉ xếp hạng theo độ dài đạt QWK 0.63-0.75 ở RELEVANCE, STRUCTURE, DEPTH trên calibration, tức là đã chạm mục tiêu 0.6. Vì vậy phải so QWK với cột "Mốc độ dài" của `metrics.py`, không chỉ so với 0.6.
- **CORRECTNESS có ít mẫu** (24 calibration, 12 holdout), kết quả dao động nhiều.
- **Nhãn nháp có trần:** 23 câu đạt tối đa ở mọi tiêu chí, người chấm có thể chấm thấp hơn.
- **Ngân hàng câu hỏi chỉ có ngành IT**, chưa đại diện các ngành khác trong taxonomy.
