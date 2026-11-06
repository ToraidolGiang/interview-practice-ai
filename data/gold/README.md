# Bộ dữ liệu chuẩn (DLPVXVTHA-159)

Dùng để đo độ chính xác của bộ chấm theo `docs/business/Rubric_Cham_Diem.md` mục 9.

> **Trạng thái: nháp.** Câu trả lời và nhãn trong `labels/claude_draft.jsonl` do Claude viết, chưa có người chấm. Chưa được dùng kết quả so với nhãn này làm số liệu "AI so với người" trong báo cáo.

## Thành phần

| File | Nội dung |
|---|---|
| `gold_v1.jsonl` | 144 câu trả lời kèm câu hỏi, đáp án tham chiếu và tập, không có nhãn |
| `labels/claude_draft.jsonl` | Nhãn nháp của Claude, kèm mức dự kiến và lý do |
| `rater_sheet.csv` | Phiếu chấm mù cho người, đã xáo thứ tự, không có nhãn nháp |
| `source/*.jsonl` | Bản gốc để sửa. `contrast.jsonl` là các câu đối chứng ngắn mà tốt, dài mà yếu |

Sửa `source/` rồi chạy lại `python scripts/gold/build_gold.py`, không sửa tay các file sinh ra.

## Thiết kế

- 24 câu hỏi có trong seed V2, mỗi loại 6 câu; 6 câu trả lời mỗi câu hỏi (5 mức chất lượng và 1 câu đối chứng).
- Tách tập theo câu hỏi: 16 câu hỏi calibration (96 câu trả lời), 8 câu hỏi holdout (48 câu trả lời).
- Có các ca khó: lạc đề, dài mà rỗng, ngắn mà tốt, trình bày tốt nhưng sai chuyên môn.
- Câu trả lời viết theo văn nói, từ đệm có ở cả câu tốt lẫn câu yếu.

## Quy trình

1. **Chấm:** 2-3 người chấm độc lập trên bản sao của `rater_sheet.csv`, theo đúng rubric, không trao đổi và không xem `labels/`. Cột `off_topic` đánh `x` nếu lạc đề. Lưu dạng "CSV UTF-8".
2. **Nhập điểm:** `python scripts/gold/import_ratings.py phieu.csv --rater nguoi_cham_1`
3. **Đo đồng thuận giữa người chấm:** `python scripts/gold/metrics.py --ref data/gold/labels/nguoi_cham_1.jsonl --pred data/gold/labels/nguoi_cham_2.jsonl`
4. **Chạy pipeline** trên `transcript` của từng câu, lưu kết quả cùng định dạng file nhãn: `{"id": "GOLD-001", "scores": {"RELEVANCE": 4, "STRUCTURE": 3, "DEPTH": 3}, "off_topic": false}`
5. **Đo bộ chấm:** `python scripts/gold/metrics.py --ref <nhãn người> --pred lan1.jsonl --pred lan2.jsonl`. Truyền nhiều `--pred` để đo độ lặp lại, rubric yêu cầu 5 lần.
6. **Chốt:** chỉ dùng `--split holdout` một lần sau khi đã ngừng chỉnh prompt. Nếu chỉnh tiếp sau khi xem holdout thì holdout không còn giá trị.

Chạy test: `python -m unittest discover -s scripts/gold`

## Giới hạn

- **Không thay được người chấm.** Claude vừa viết câu trả lời vừa gán nhãn theo mức đã định sẵn, nên nhãn nháp không độc lập với câu trả lời. Rubric mục 9 yêu cầu 2-3 người chấm.
- **Không phải dữ liệu thật.** Câu trả lời do Claude viết có thể đều và mạch lạc hơn người thật. Nên bổ sung câu trả lời thật khi có.
- **Chỉ có văn bản.** Không có audio nên chưa đo được STT, Delivery, độ trễ 12 giây và giọng vùng miền. Các phần này cần ghi âm thật.
- **Độ dài vẫn tương quan với điểm** (Spearman khoảng 0.7 trên nhãn nháp). Bộ chấm giả chỉ xếp hạng theo độ dài đạt QWK 0.63-0.75 ở RELEVANCE, STRUCTURE, DEPTH trên calibration, tức là đã chạm mục tiêu 0.6. Vì vậy phải so QWK với cột "Mốc độ dài" của `metrics.py`, không chỉ so với 0.6.
- **CORRECTNESS có ít mẫu** (24 calibration, 12 holdout), kết quả dao động nhiều.
- **Nhãn nháp có trần:** 23 câu đạt tối đa ở mọi tiêu chí, người chấm có thể chấm thấp hơn.
- **Ngân hàng câu hỏi chỉ có ngành IT**, chưa đại diện các ngành khác trong taxonomy.
