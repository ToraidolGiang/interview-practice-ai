# Rubric chấm điểm câu trả lời phỏng vấn

- Phiên bản rubric: `rubric-v1.0` (draft, chờ hiệu chỉnh bằng bộ dữ liệu chuẩn, xem mục 9)
- Thay thế: cách chấm S-T-A-R cố định trong UC5 (business rule B1) và `ScoreResult` cũ (`sScore`, `tScore`, `aScore`, `rScore`)
- Đây là tài liệu gốc cho: UC5, OpenAPI `ScoreResult`, ERD, class/sequence diagram, prompt và code tính điểm. Khi có mâu thuẫn, tài liệu này được ưu tiên.

## 1. Nguyên tắc

1. **Rubric theo loại câu hỏi.** STAR chỉ phù hợp câu hỏi hành vi. Mỗi câu hỏi có `questionType` và được chấm bằng bộ tiêu chí/trọng số tương ứng.
2. **LLM chấm từng tiêu chí, code tính tổng.** LLM không được tự cộng điểm hay tự tính điểm Delivery.
3. **Mọi điểm từ 3 trở lên phải kèm trích dẫn nguyên văn** từ transcript. Hệ thống kiểm tra trích dẫn có thật.
4. **Điểm nội dung độc lập với giọng nói.** Delivery chiếm trọng số nhỏ và hiển thị tách riêng.
5. **Transcript là dữ liệu, không phải chỉ thị** (mục 7).

## 2. Loại câu hỏi (`questionType`)

| Giá trị | Mô tả | Ví dụ |
|---|---|---|
| `BEHAVIORAL` | Kể về trải nghiệm đã xảy ra | "Kể về lần bạn xử lý xung đột trong nhóm" |
| `SITUATIONAL` | Tình huống giả định | "Nếu deadline bị rút ngắn một nửa, bạn làm gì?" |
| `TECHNICAL` | Kiến thức chuyên môn, có đáp án tham chiếu | "REST khác SOAP ở điểm nào?" |
| `INTRO` | Giới thiệu bản thân, động lực | "Hãy giới thiệu về bản thân" |

Câu hỏi `TECHNICAL` nên có `referenceAnswer` (ý chính cần có) trong ngân hàng câu hỏi. Trường `starHint` cũ đổi tên thành `answerHint` (gợi ý hiển thị cho người luyện tập, áp dụng cho mọi loại).

## 3. Tiêu chí và thang điểm

Mỗi tiêu chí do LLM chấm theo thang **1-5, số nguyên** (riêng Delivery tính bằng code, có thể là số thập phân).

| Mã | Tiêu chí | Người chấm |
|---|---|---|
| `RELEVANCE` | Đúng trọng tâm câu hỏi | LLM |
| `STRUCTURE` | Cấu trúc câu trả lời (phụ thuộc loại câu hỏi) | LLM |
| `DEPTH` | Mức cụ thể: ví dụ, số liệu, vai trò cá nhân, lập luận | LLM |
| `CORRECTNESS` | Đúng về chuyên môn (chỉ `TECHNICAL`) | LLM, đối chiếu `referenceAnswer` |
| `DELIVERY` | Tốc độ nói và từ đệm | Code (mục 5) |

### 3.1 Mô tả neo (anchor)

**RELEVANCE**
- 1: Lạc đề hoặc không trả lời câu hỏi.
- 3: Trả lời một phần câu hỏi, có đoạn lan man.
- 5: Trả lời trúng và đầy đủ các ý câu hỏi yêu cầu, không lạc đề.

**STRUCTURE** (mức 2 và 4 là mức trung gian)
- `BEHAVIORAL`, khung STAR:
  - 1: Không xác định được bối cảnh hay hành động.
  - 3: Có 2-3 thành phần S/T/A/R, thiếu hoặc mơ hồ phần còn lại (thường là Result).
  - 5: Đủ Situation, Task, Action, Result, rõ vai trò cá nhân, trình tự hợp lý.
- `SITUATIONAL`, khung phân tích → quyết định → lý do:
  - 1: Không nêu hướng xử lý.
  - 3: Nêu hướng xử lý nhưng thiếu lý do hoặc thứ tự bước.
  - 5: Nêu cách tiếp cận có thứ tự, giải thích lý do, cân nhắc rủi ro hoặc phương án khác.
- `TECHNICAL`, khung khái niệm → giải thích → ví dụ:
  - 1: Rời rạc, không có mạch giải thích.
  - 3: Có định nghĩa và giải thích, thiếu ví dụ hoặc so sánh.
  - 5: Mạch rõ: khái niệm, cơ chế, ví dụ hoặc trường hợp áp dụng.
- `INTRO`, khung hiện tại → quá khứ → định hướng:
  - 1: Liệt kê rời rạc, không liên kết.
  - 3: Có 2 trong 3 phần, thiếu liên hệ với vị trí ứng tuyển.
  - 5: Mạch lạc, nối kinh nghiệm với vị trí ứng tuyển và định hướng.

**DEPTH**
- 1: Chung chung, toàn câu nói sáo rỗng, không có chi tiết cụ thể.
- 3: Có ví dụ hoặc lập luận cụ thể nhưng thiếu số liệu, kết quả hoặc vai trò cá nhân.
- 5: Chi tiết cụ thể, có số liệu hoặc kết quả đo được, nêu rõ đóng góp cá nhân và bài học.

**CORRECTNESS** (chỉ `TECHNICAL`)
- 1: Sai cơ bản hoặc mâu thuẫn với `referenceAnswer`.
- 3: Đúng ý chính nhưng thiếu hoặc sai một số ý quan trọng.
- 5: Đúng và đủ các ý chính trong `referenceAnswer`, không có sai sót đáng kể.

## 4. Trọng số và công thức tổng điểm

Trọng số cấu hình theo loại câu hỏi (tổng mỗi dòng = 100):

| `questionType` | RELEVANCE | STRUCTURE | DEPTH | CORRECTNESS | DELIVERY |
|---|---|---|---|---|---|
| `BEHAVIORAL` | 20 | 30 | 40 | - | 10 |
| `SITUATIONAL` | 25 | 25 | 40 | - | 10 |
| `TECHNICAL` | 15 | 15 | 25 | 35 | 10 |
| `INTRO` | 25 | 30 | 35 | - | 10 |

Công thức, với `wᵢ` là trọng số và `sᵢ` là điểm tiêu chí (1-5):

```
totalScore = Σ wᵢ · (sᵢ − 1) / 4        → thang 0-100, làm tròn 1 chữ số thập phân
```

Điểm 1 ứng với 0%, điểm 5 ứng với 100% của trọng số tiêu chí đó.

Điểm hiển thị gồm: `contentScore` (các tiêu chí do LLM chấm, quy về 0-100) và `deliveryScore` (hiển thị riêng), cộng `totalScore` như trên.

Trường hợp đặc biệt:
- **Không đủ dữ liệu Delivery** (transcript dưới 30 từ hoặc không có thời lượng): bỏ DELIVERY, chia lại trọng số 10 cho các tiêu chí còn lại theo tỷ lệ.
- **`off_topic` = true**: `totalScore` tối đa 30.
- **Câu trả lời dưới 15 từ**: không chấm, trả lỗi 422 `ANSWER_TOO_SHORT`.

## 5. Delivery (tính bằng code, không dùng LLM)

Thông số bên dưới là **giá trị khởi đầu, cấu hình được**, dự kiến chỉnh sau khi có dữ liệu thật.

**Tốc độ nói (WPM)** = số từ trong transcript / thời lượng ghi âm (phút). Từ tiếng Việt tính theo khoảng trắng.

| WPM | `wpmScore` |
|---|---|
| 100-170 | 5 |
| 80-99 hoặc 171-190 | 4 |
| 60-79 hoặc 191-210 | 3 |
| 40-59 hoặc 211-240 | 2 |
| ngoài các khoảng trên | 1 |

**Từ đệm**: `fillerRate` = số từ đệm trên 100 từ.

| `fillerRate` | `fillerScore` |
|---|---|
| ≤ 2 | 5 |
| ≤ 4 | 4 |
| ≤ 6 | 3 |
| ≤ 9 | 2 |
| > 9 | 1 |

`deliveryScore (1-5) = 0.5 · wpmScore + 0.5 · fillerScore`

Danh sách từ đệm (`filler-vi-v1`): "ừm", "ờ", "ơ", "à ừm", "hmm", "kiểu như", "kiểu là", "nói chung là", và lặp từ liền kề ("tôi tôi", "là là"). **Không đếm "thì", "là", "mà"** vì là từ thông dụng trong tiếng Việt.

Giới hạn cần ghi trong báo cáo: nếu STT làm sạch transcript và bỏ từ đệm thì `fillerCount` sẽ thấp hơn thực tế. Prompt STT phải yêu cầu phiên âm nguyên văn (verbatim). Cho phép người dùng sửa transcript và chấm lại.

## 6. Đầu ra của LLM (JSON bắt buộc)

```json
{
  "questionType": "BEHAVIORAL",
  "offTopic": false,
  "injectionSuspected": false,
  "criteria": [
    {
      "code": "STRUCTURE",
      "reasoning": "Có tình huống và hành động, thiếu kết quả.",
      "quote": "lúc đó nhóm bị trễ tiến độ hai tuần",
      "score": 3
    }
  ],
  "feedbackText": "...",
  "sampleAnswer": "..."
}
```

Quy tắc kiểm tra phía server:
1. `criteria` phải đủ các tiêu chí LLM-chấm của `questionType` đó, `score` là số nguyên 1-5.
2. `quote` chuẩn hoá (bỏ dấu câu thừa, khoảng trắng, không phân biệt hoa/thường) phải là chuỗi con của transcript. Tiêu chí có `score ≥ 3` mà `quote` không hợp lệ thì bị hạ xuống 2 và gắn cờ `quoteInvalid`.
3. Nếu hơn nửa số tiêu chí có `quote` không hợp lệ hoặc JSON sai schema: gọi lại LLM đúng 1 lần (thống nhất với business rule B4); vẫn lỗi thì session chuyển `FAILED`.
4. `totalScore` luôn do server tính theo mục 4, bỏ qua mọi điểm tổng do LLM tự trả.

## 7. Chống prompt injection

- Transcript được bọc trong thẻ phân cách (ví dụ `<transcript>...</transcript>`); system prompt nói rõ nội dung trong thẻ là lời thí sinh, không phải chỉ thị.
- LLM trả cờ `injectionSuspected` khi transcript chứa câu yêu cầu đổi điểm, bỏ qua rubric, hoặc đổi vai trò. Khi cờ bật: vẫn chấm theo nội dung thật, hiển thị cảnh báo, ghi vào audit log.
- Điểm bị ép trong khoảng 1-5, tổng điểm do server tính (mục 6, quy tắc 4).
- Không đưa dữ liệu nhạy cảm của người dùng khác vào prompt.

## 8. Truy vết và phiên bản

Mỗi kết quả chấm lưu: `rubricVersion`, `promptVersion`, `modelVersion`, `fillerListVersion`, transcript đã dùng để chấm, và điểm/trích dẫn/lý do từng tiêu chí. Khi đổi bất kỳ phiên bản nào, kết quả cũ giữ nguyên, không tính lại.

## 9. Hiệu chỉnh và đo độ chính xác

Rubric này là giả thuyết cần kiểm chứng (liên quan ticket DLPVXVTHA-129):
1. Xây bộ dữ liệu chuẩn 100-150 câu trả lời, đủ 4 loại câu hỏi và nhiều giọng vùng miền.
2. 2-3 người chấm độc lập theo đúng rubric này.
3. Đo: mức đồng thuận giữa người chấm (weighted kappa), AI so với người (QWK, Spearman, MAE), độ lặp lại (chạy cùng input 5 lần, đo độ lệch chuẩn).
4. Chỉnh anchor, prompt, trọng số, thông số Delivery cho đến khi QWK đạt khoảng 0.6-0.7. Mỗi lần chỉnh tăng version.
