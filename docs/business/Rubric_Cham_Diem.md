# Rubric chấm điểm câu trả lời phỏng vấn

- Phiên bản rubric: `rubric-v1.1` (draft, chờ hiệu chỉnh bằng bộ dữ liệu chuẩn, xem mục 9; thay đổi so với v1.0 ở mục 10)
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

Quy tắc chung:
- Chấm từng tiêu chí độc lập: một câu có thể cấu trúc tốt nhưng sai chuyên môn.
- Độ dài và từ đệm không ảnh hưởng điểm nội dung.
- Chỉ tính điều thí sinh thực sự nói ra, không suy diễn thay thí sinh.
- Khi `off_topic` = true thì `STRUCTURE` và `DEPTH` đều bằng 1; nội dung ngoài câu hỏi không tính cho khung hay yếu tố nào.
- "Ví dụ" là một tình huống hoặc đối tượng cụ thể. Chỉ nêu tên loại việc hoặc tên công cụ thì không tính. So sánh cụ thể được tính như ví dụ. Ví dụ hoặc so sánh tính kể cả khi sai, nhưng không tính nếu chính nó là điều câu hỏi yêu cầu trả lời.
- "Lướt" là chỉ nhắc tên, không nói vì sao liên quan; ví dụ có đối tượng hoặc số liệu cụ thể thì không phải là lướt.
- "Sáo rỗng" là câu đúng với mọi ứng viên hoặc mọi vị trí.

**RELEVANCE** (chỉ xét có trả lời đúng điều được hỏi hay không; đúng sai chuyên môn tính ở `CORRECTNESS`)
- 1: Không có ý nào trả lời trực tiếp câu hỏi, kể cả khi cùng lĩnh vực (ví dụ hỏi về index mà nói về chuẩn hóa). Bắt buộc đặt `off_topic` = true.
- 2: Chạm đến câu hỏi nhưng né tránh, từ chối, nói không biết, hoặc chỉ có một câu khẳng định không có nội dung.
- 3: Trả lời một phần: thiếu một vế của câu hỏi, hoặc phần lớn câu trả lời là lan man.
- 4: Trả lời đủ các vế, có đoạn lan man ngắn hoặc một vế còn sơ sài.
- 5: Trả lời trúng và đầy đủ các vế câu hỏi yêu cầu, không lạc đề.

`off_topic` = true khi và chỉ khi `RELEVANCE` = 1.

Cách đo: "lan man ngắn" là dưới một nửa số câu của câu trả lời, "phần lớn" là từ một nửa trở lên. "Sơ sài" là chỉ nhắc tới vế đó mà không nói nội dung gì; một mệnh đề có nội dung là đủ. Vế chỉ suy ra được mà không nói ra thì tính là thiếu. Lan man là câu không góp vào điều được hỏi; mô tả vấn đề hoặc nguyên nhân dẫn thẳng tới biện pháp thì không tính là lan man.

**STRUCTURE**
- `BEHAVIORAL`, khung STAR:
  - 1: Không xác định được bối cảnh hay hành động.
  - 2: Có 1 thành phần S/T/A/R.
  - 3: Có 2-3 thành phần S/T/A/R, hoặc đủ 4 nhưng từ hai phần trở lên còn mơ hồ.
  - 4: Đủ 4 thành phần nhưng đúng một phần còn mơ hồ hoặc vai trò cá nhân chưa rõ.
  - 5: Đủ Situation, Task, Action, Result, rõ vai trò cá nhân, trình tự hợp lý.
  - Task không cần nói thành câu riêng: suy ra rõ ràng từ Situation thì vẫn tính là có.
- `SITUATIONAL`, khung phân tích → quyết định → lý do:
  - 1: Không nêu hướng xử lý.
  - 2: Có hướng xử lý nhưng mơ hồ, không có bước nào cụ thể.
  - 3: Nêu hướng xử lý nhưng thiếu lý do hoặc thứ tự bước.
  - 4: Có thứ tự và lý do, chưa cân nhắc rủi ro hoặc phương án khác.
  - 5: Nêu cách tiếp cận có thứ tự, giải thích lý do, cân nhắc rủi ro hoặc phương án khác.
  - Vấn đề nêu ngay trước biện pháp tính là lý do. Làm thử có điều kiện dừng tính là cân nhắc rủi ro. Câu trả lời chỉ có một bước tính là thiếu thứ tự.
- `TECHNICAL`, khung khái niệm → giải thích → ví dụ:
  - 1: Rời rạc, không có mạch giải thích.
  - 2: Có định nghĩa nhưng không có giải thích.
  - 3: Có định nghĩa và giải thích, thiếu ví dụ hoặc so sánh.
  - 4: Đủ khái niệm, cơ chế, ví dụ hoặc so sánh, nhưng phần ví dụ chỉ nêu lướt.
  - 5: Mạch rõ: khái niệm, cơ chế, ví dụ, so sánh hoặc trường hợp áp dụng.
  - Câu không hỏi định nghĩa thì "khái niệm" là luận điểm trả lời trực tiếp. Định nghĩa phải là của đối tượng được hỏi. "Giải thích" dùng cùng phép thử với yếu tố giải thích của `DEPTH`.
- `INTRO`, chọn khung theo câu hỏi:
  - Câu "giới thiệu bản thân": hiện tại → quá khứ → định hướng.
  - Câu khác (động lực, điểm mạnh yếu, định hướng, hiểu về vị trí): ý chính → bằng chứng → liên hệ vị trí hoặc định hướng nghề.
  - Câu "hiểu về vị trí": ý chính là mô tả công việc, bằng chứng là trải nghiệm của thí sinh, liên hệ là vì sao thí sinh phù hợp.
  - Câu định hướng: bằng chứng là việc đã làm hoặc đã học; kế hoạch tương lai chỉ tính là liên hệ.
  - Kế hoạch cải thiện bản thân tính là liên hệ định hướng nghề. Ý chính sáo rỗng không tính là một phần.
  - 1: Không có phần nào của khung, hoặc liệt kê rời rạc không liên kết.
  - 2: Có 1 trong 3 phần.
  - 3: Có 2 trong 3 phần của khung.
  - 4: Đủ 3 phần nhưng phần cuối chỉ nối lướt qua.
  - 5: Đủ 3 phần, mạch lạc, phần cuối nối được với vị trí ứng tuyển hoặc định hướng nghề.

**DEPTH**: đếm số yếu tố có mặt theo loại câu hỏi, `điểm = số yếu tố + 1`. Yếu tố chỉ được tính khi nói cụ thể; câu sáo rỗng không tính. Một câu có thể tính cho nhiều yếu tố nếu chứa đủ thông tin cho từng yếu tố, nhưng một con số chỉ tính cho một yếu tố.

| `questionType` | Yếu tố 1 | Yếu tố 2 | Yếu tố 3 | Yếu tố 4 |
|---|---|---|---|---|
| `BEHAVIORAL` | Chi tiết cụ thể của sự việc | Số liệu hoặc kết quả đo được | Việc chính thí sinh đã làm | Bài học hoặc thay đổi sau đó |
| `SITUATIONAL` | Biện pháp cụ thể, không chỉ nguyên tắc | Lý do của biện pháp | Ví dụ, công cụ hoặc con số minh họa cho biện pháp | Cách đo kết quả hoặc xử lý khi biện pháp không hiệu quả |
| `TECHNICAL` | Giải thích cơ chế hoặc vì sao | Ví dụ hoặc so sánh cụ thể | Giới hạn, đánh đổi hoặc khi nào không dùng | Kinh nghiệm thực tế, số liệu hoặc cách kiểm chứng |
| `INTRO` | Thông tin cụ thể về vai trò, công nghệ hoặc thời gian của chính thí sinh | Thành tích có số liệu | Đóng góp cá nhân | Lý do hoặc kế hoạch cụ thể, gắn với câu hỏi |

Cách tính một số yếu tố:
- "Thay đổi sau đó" phải khác với việc xử lý chính.
- "Giải thích cơ chế hoặc vì sao" tính khi có quan hệ nhân quả nói ra rõ ràng, kể cả khi sai; chỉ định nghĩa lại, hoặc mệnh đề nhân quả nằm trong định nghĩa mà không thêm ý mới, thì không tính.
- "Giới hạn, đánh đổi" chỉ tính khi nêu rõ mặt hại, chi phí hoặc tình huống không nên dùng; làm rõ khái niệm hay nêu điều kiện áp dụng thì không tính.
- "Cách kiểm chứng" chỉ tính phần ngoài điều câu hỏi đã yêu cầu trả lời. Quy tắc này chỉ áp dụng cho yếu tố kiểm chứng.
- Với câu hỏi dạng liệt kê, việc xác nhận lại với người hỏi tính là "cách đo kết quả".

**CORRECTNESS** (chỉ `TECHNICAL`): tính tỉ lệ ý trong `referenceAnswer` được nêu đúng, mỗi gạch đầu dòng là một ý. Nêu đủ các vế của gạch đầu dòng tính 1 ý, nêu đúng một phần tính 0,5 ý. Các ví dụ liệt kê trong gạch đầu dòng chỉ cần nêu một.
- 1: Dưới 20%, kể cả nói không biết; hoặc sai ở khái niệm trung tâm của câu hỏi.
- 2: 20% đến dưới 50%.
- 3: 50% đến dưới 70%.
- 4: 70% đến dưới 90%.
- 5: Từ 90% trở lên, không có phát biểu sai.

Mỗi phát biểu sai nhưng không thuộc khái niệm trung tâm trừ 1 mức, tối thiểu là 1. Ý đúng ngoài `referenceAnswer` không cộng điểm và không trừ điểm. Nếu câu hỏi không có `referenceAnswer` thì tính theo các ý mà câu hỏi yêu cầu.

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
- **`off_topic` = true** (tương đương `RELEVANCE` = 1, mục 3.1): `totalScore` tối đa 30.
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

## 10. Lịch sử thay đổi

**rubric-v1.1** (không đổi tiêu chí, trọng số, công thức):
- `RELEVANCE`: mô tả đủ 5 mức, tách câu né tránh khỏi câu lạc đề, không xét đúng sai chuyên môn.
- `off_topic`: định nghĩa bằng `RELEVANCE` = 1, gồm cả câu cùng lĩnh vực nhưng không trả lời câu hỏi.
- `DEPTH`: đếm 4 yếu tố theo từng loại câu hỏi, thay cho một mô tả chung.
- `STRUCTURE`: `INTRO` chọn khung theo câu hỏi; `BEHAVIORAL` chấp nhận Task suy ra được.
- `CORRECTNESS`: tính theo tỉ lệ ý đúng, có quy tắc cho ý đúng một phần, phát biểu sai và câu nói không biết.
- `STRUCTURE`: mô tả đủ mức 2 và 4; định nghĩa "ví dụ"; câu lạc đề có `STRUCTURE` và `DEPTH` bằng 1.

Còn lại: nhiều gạch đầu dòng trong `referenceAnswer` chưa phân biệt vế bắt buộc và ví dụ, nên `CORRECTNESS` vẫn có thể lệch 1 mức. Cần đánh dấu lại khi rà ngân hàng câu hỏi.

Điểm chấm theo v1.0 không so sánh trực tiếp với v1.1. Chỉ đổi `RUBRIC_VERSION` trong code cùng lúc với prompt chấm điểm, để phiên bản lưu trong `ScoreResult` đúng với prompt thực tế đã dùng.
