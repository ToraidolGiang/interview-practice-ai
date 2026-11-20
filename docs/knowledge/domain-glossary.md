# Thuật ngữ

| Thuật ngữ | Nghĩa | Tên trong code |
|---|---|---|
| Phiên luyện tập | Một lượt trả lời 1 câu hỏi | `entity/PracticeSession`, bảng `practice_sessions` |
| Trạng thái phiên | CREATED, UPLOADED, PROCESSING, SCORED, FAILED | `PracticeSessionStatus` (OA) |
| STT | Chuyển giọng nói thành văn bản (Gemini) | `SttClient`, `GeminiSttClient` |
| Transcript | Văn bản phiên âm, giữ từ đệm | bọc `<transcript>` trong prompt |
| Rubric | Bộ tiêu chí và trọng số theo loại câu hỏi | `RubricConfig`, `RUBRIC_VERSION=rubric-v1.0` |
| Tiêu chí | Một mục chấm 1-5 (vd CORRECTNESS) | `score_criteria`, `CriterionScore` |
| Delivery | Điểm cách nói: WPM + từ đệm, trọng số 10 | `DeliveryCalculator`, `DeliveryMetricsProvider` |
| Từ đệm (filler) | ừm, ờ... | `fillerCount`, `fillerListVersion` |
| Trích dẫn (quote) | Đoạn nguyên văn transcript làm bằng chứng cho điểm | `QuoteValidator`, `quoteInvalid` |
| offTopic | Câu trả lời lạc đề, tổng điểm tối đa 30 | `ScoreCalculator` |
| Injection | Thí sinh chèn chỉ thị vào lời nói để thao túng điểm | `injection_suspected` |
| Chấm lại | Xóa kết quả cũ rồi ghi mới trong 1 tx | `ScoreResultWriter`, `deleteBySessionId` |
| SERVER_RESTART | Mã lỗi phiên PROCESSING bị bỏ dở khi khởi động lại | `SessionRecoveryRunner` |
| audioUrl | Trường API thực chất chứa khóa S3 (`audio_key`) | `PracticeSessionResponse` |

Cập nhật lần cuối: 2026-11-04
