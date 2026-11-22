# Giai đoạn F: Đo độ chính xác, đối chiếu theo ý, kiểm lỗi kiến thức, hướng RAG

Thời gian: 06 - 22/11/2026. Tuấn Anh làm bộ dữ liệu chuẩn và công cụ đo (#159, PR #19, merge 20/11). Giang làm đối chiếu theo ý và kiểm lỗi kiến thức (PR #24, 22/11).

## 1. Hiểu nhanh trong 1 phút
- **Một câu:** làm cho điểm của AI **có thể kiểm chứng**: đo nó so với người chấm bằng số liệu, cho người dùng thấy **ý nào đúng, ý nào thiếu, câu nào sai**, và hướng tới chấm có căn cứ tri thức (RAG).
- **Hình ảnh đời thường:** giám khảo AI giờ phải nộp *biên bản chấm*: "thí sinh nêu đủ 4/5 ý, thiếu ý này, nói sai câu này, trích dẫn đây", và có một kỳ thi thử để kiểm tra chính giám khảo.
- **Ba ý chính:**
  1. **Đo:** bộ 144 câu trả lời chuẩn + QWK/Spearman/MAE; mức đồng thuận giữa *người với người* là trần thực tế.
  2. **Giải thích được:** điểm CORRECTNESS tính từ từng ý của đáp án tham chiếu, kèm trích dẫn.
  3. **Bắt lỗi sai:** một lượt kiểm lỗi riêng, chạy song song, vì "nhắc đến ý đó" khác "nói đúng".

## 2. Từ điển nhanh
| Từ | Nghĩa |
|---|---|
| Gold set (bộ chuẩn) | Tập câu trả lời có điểm tham chiếu do người chấm, để đo bộ chấm tự động |
| QWK | Quadratic Weighted Kappa: độ đồng thuận giữa hai người chấm; lệch 2 mức bị phạt nặng hơn lệch 1 mức (bình phương). 1 là trùng hoàn toàn, 0 là ngang đoán mò |
| Spearman | Tương quan thứ hạng: hai bên có xếp hạng giống nhau không |
| MAE | Sai số tuyệt đối trung bình |
| Calibration / Holdout | Tập dùng để chỉnh prompt / tập giữ lại **chỉ đo một lần** sau khi ngừng chỉnh |
| Mốc độ dài | Bộ chấm giả chỉ dựa vào độ dài; AI phải **vượt** mốc này mới có ý nghĩa |
| Verdict | Mức đáp ứng một ý: `COVERED` (nêu đủ), `PARTIAL` (thiếu/lệch), `MISSING` (không nêu), `INCORRECT` (nêu sai) |
| Coverage | Độ bao phủ ý của đáp án = (COVERED + 0,5·PARTIAL − 0,5·INCORRECT) / số ý, chặn dưới 0 |
| Grounding | Kết luận phải dựa trên bằng chứng (trích dẫn / nguồn), không tự suy |
| RAG | Retrieval-Augmented Generation: truy xuất tài liệu liên quan rồi bắt LLM chỉ kết luận dựa trên đó |
| Thinking level | Mức "suy nghĩ" của model Gemini; `minimal` cho trả lời nhanh, ít token |

## 3. Thân bài theo bước

### Bước 1. Bộ dữ liệu chuẩn (#159, `data/gold/`)
- **Vì sao cần:** chưa có bất kỳ số đo nào cho độ chính xác điểm AI. Giáo viên sẽ hỏi "độ chính xác bao nhiêu, đo thế nào".
- **Thiết kế:** 144 câu trả lời trên 24 câu hỏi trong seed (mỗi loại 6 câu hỏi); mỗi câu hỏi 6 câu trả lời (5 mức chất lượng + 1 câu đối chứng ngắn mà tốt hoặc dài mà yếu). Tách **theo câu hỏi**: 16 câu hỏi calibration (96 trả lời) và 8 câu hỏi holdout (48 trả lời). Người chấm chấm 100 câu: đủ 48 câu holdout + 52 calibration. Có ca khó: lạc đề, dài mà rỗng, ngắn mà tốt, trình bày tốt nhưng sai chuyên môn.
- **Công cụ:** `scripts/gold/` (`build_gold.py`, `import_ratings.py`, `metrics.py`, `rater_template.html` chạy offline và xuất CSV). Chấm mù: người chấm không xem nhãn nháp.
- **Trạng thái 22/11:** người chấm 1 đã chấm 100 câu (`labels/nguoi_cham_1.jsonl`); **chưa có người chấm 2**, nên **chưa tính được QWK giữa người với người**, và chưa có số "AI so với người".
- **Giới hạn phải nói thẳng:** câu trả lời **do Claude viết**, không phải ứng viên thật; chỉ có văn bản (không đo STT, Delivery, độ trễ); độ dài vẫn tương quan với điểm (Spearman khoảng 0,7 trên nhãn nháp); CORRECTNESS ít mẫu (24 calibration, 12 holdout); ngân hàng chỉ ngành IT. Hai phiên Claude chấm mù khớp nhau QWK 0,93-0,98, nhưng **đó không đo độ chính xác** (cùng họ mô hình, câu trả lời viết theo mức định sẵn).
- **Rubric v1.1** (07/11): làm rõ `off_topic`, `DEPTH` (điểm = số yếu tố + 1), `STRUCTURE`, `CORRECTNESS`. Thử mù cho thấy vẫn còn phán đoán, thường lệch 1 điểm, nên thước đo đúng là đồng thuận giữa người.

### Bước 2. Quote nhiều đoạn (22/11, prompt-v2)
- **Triệu chứng thật:** cùng một câu trả lời đúng, RELEVANCE và STRUCTURE bị 2 điểm dù lập luận của LLM khen, tổng 75 thay vì 97,5.
- **Nguyên nhân:** LLM ghép nhiều đoạn bằng `...` và rút gọn; `QuoteValidator` đòi chuỗi con liên tục nên coi là bịa và hạ về 2.
- **Cách sửa:** (a) prompt dặn chép một đoạn liền mạch; (b) validator tách theo `...`/`…`, bỏ mảnh dưới 3 từ, hợp lệ khi **quá nửa** số mảnh là chuỗi con của transcript. Một mảnh vẫn phải khớp trọn.
- **Kết quả đo:** cùng transcript, tổng điểm 75,0 → 97,5; các tiêu chí không còn `quote_invalid`.
- **Lưu ý:** đây là thay đổi quy tắc rubric (mục 6, quy tắc 2) làm lệch bộ đo, **cần đo lại**.

### Bước 3. Đối chiếu theo ý (PR #24, V4 `score_points`)
- **Vấn đề:** CORRECTNESS 5/5 chỉ có một trích dẫn; người dùng không thấy mình trúng ý nào của đáp án tham chiếu.
- **Cách làm:** `ReferencePoints` tách `reference_answer` thành các ý (mỗi dòng một ý, bỏ gạch đầu dòng, tối đa 10). Schema LLM thêm mảng `points` đúng số ý; mỗi phần tử có `index`, `verdict`, `quote`, `note`.
- **Kiểm trích dẫn:** ý `COVERED`/`PARTIAL` mà trích dẫn không có trong transcript thì **hạ một bậc** (`COVERED→PARTIAL→MISSING`) và gắn `quoteInvalid`.
- **Server tính điểm CORRECTNESS 1-5** (`CorrectnessCalculator`): `điểm = 1 + làm tròn(4·coverage)`. LLM vẫn trả CORRECTNESS nhưng điểm đó **bị bỏ**.
- **Ví dụ số nhỏ:** 5 ý, 3 `COVERED` + 1 `PARTIAL` + 1 `MISSING` → tử số 3,5 → coverage 0,7 → 1 + round(2,8) = **4**. Nếu thêm 1 lỗi kiến thức: 3,0/5 = 0,6 → 1 + round(2,4) = 3.
- **Giới hạn:** công thức quy đổi là **lựa chọn thiết kế, chưa hiệu chỉnh bằng dữ liệu người chấm**.

### Bước 4. Kiểm lỗi kiến thức (PR #24, V5 `score_errors`)
- **Phát hiện bằng thử thật:** người nói nhập nhầm `min_samples_split` với `min_samples_leaf` ("số mẫu tối thiểu để chia nút là số mẫu ít nhất phải nằm ở mỗi nút lá") nhưng ý vẫn `COVERED`. Lý do: đối chiếu theo ý chỉ kiểm "có nhắc đến không", không kiểm "có đúng không".
- **Thí nghiệm chọn cách làm (cùng transcript):**

| Cách | Bắt được lỗi? | Thời gian | Token |
|---|---|---|---|
| Một lượt chấm đủ việc, `gemini-3.1-flash-lite`, đã siết prompt | **Không** (0/2) | khoảng 4-5s | khoảng 2.000 |
| Một lượt chấm đủ việc, `gemini-3-flash-preview`, đã siết prompt | **Không** (0/2) | khoảng 11-13s | khoảng 3.800 (gồm suy nghĩ) |
| Một lượt chấm đủ việc + yêu cầu liệt kê lỗi, `gemini-3-flash-preview` | Có (2/2), nhưng chậm | 13-18s | chưa ghi |
| **Lượt riêng chỉ tìm lỗi**, `gemini-3-flash-preview`, `thinkingLevel: minimal` | **Có (2/2, 1 lỗi đúng, không báo nhầm)** | **khoảng 1,4s** | **khoảng 423** |
| Lượt riêng, `gemini-3.1-flash-lite` | Có nhưng **báo nhầm** thêm 1 lỗi | khoảng 1,6s | khoảng 510 |

- **Quyết định:** lượt kiểm lỗi riêng, model `gemini-3-flash-preview` mức suy nghĩ `minimal`, chạy **song song** với lượt chấm chính (luồng ảo `knowledgeCheckExecutor`), nên thêm khoảng 0 thời gian chờ. Chỉ câu `TECHNICAL` có đáp án tham chiếu.
- **Quy tắc:** lỗi có trích dẫn không nằm trong transcript bị bỏ (không trừ oan); mỗi lỗi hợp lệ trừ 0,5 trong tử số coverage; tối đa 5 lỗi; prompt dặn bỏ qua chỗ có vẻ do STT nghe nhầm. **Lượt này lỗi, quá hạn (8 giây) hay tắt thì bỏ qua, không làm hỏng phiên.**
- **Tự test E2E 22/11 (backend thật, Gemini thật):** chấm lại phiên cây quyết định mất **5,4s**; bắt đúng lỗi nhập nhầm, CORRECTNESS 4 → 3, tổng 76,3 → 66,3. `api_usages`: lượt kiểm lỗi 514 token (2,1s), lượt chấm chính 1.908 token (4,1s), tức token tăng khoảng 27%.
- **Giới hạn:** vẫn dựa vào kiến thức của LLM; mới thử trên một ca; chưa đo tỷ lệ bắt đúng/báo nhầm; đơn giá model preview chưa xác minh.

### Bước 5. Hướng RAG (xem `docs/Huong_Mo_Rong.md`)
- **Vì sao:** `reference_answer` do AI soạn và chưa ai duyệt hết; kiểm lỗi dựa vào kiến thức LLM. Muốn điểm **có căn cứ**, cần nguồn tri thức độc lập, có trích dẫn.
- **Các thành phần:** ingestion (nạp tài liệu, cắt đoạn, metadata, giấy phép), kho vector (đề xuất `pgvector` trong PostgreSQL, **chưa xác minh** trên môi trường deploy), retrieval theo (câu hỏi + từng ý), grounding (không có căn cứ thì `UNVERIFIED`), port `KnowledgeRetriever`, phiên bản `knowledgeVersion`. `KnowledgeErrorDetector` đã là port nên chỉ cần thay adapter.
- **Thứ tự đề xuất:** hợp đồng đối chiếu theo ý (đã làm) → RAG → đo bằng người chấm (mở rộng `rater.html` sang mức từng ý) → tô màu trên transcript.
- **Quyết định cần chốt với Tuấn Anh:** vector store, nguồn tri thức và giấy phép, ai gán nhãn mức từng ý.

## 4. Luồng chấm sau PR #24 (câu TECHNICAL có đáp án tham chiếu)
```
transcript ─┬─▶ LLM chính (lite): 4 tiêu chí + mảng points ─▶ kiểm schema ─▶ hạ bậc ý có quote sai
            │                                                  ─▶ server tính CORRECTNESS từ points
            └─▶ KnowledgeErrorDetector (preview, song song): danh sách phát biểu sai
                       ─▶ giữ lỗi có quote thật ─▶ trừ 0,5 ý mỗi lỗi vào CORRECTNESS
        ─▶ QuoteValidator (tiêu chí) ─▶ Delivery ─▶ ScoreCalculator ─▶ lưu score_criteria + score_points + score_errors
```

## 5. Khung giảng lại
**Nói (1 phút):** "Điểm AI phải kiểm chứng được. Phần đo: bộ 144 câu trả lời chuẩn, chấm mù, so bằng QWK với mức đồng thuận giữa người làm trần. Phần giải thích: CORRECTNESS tính từ từng ý của đáp án kèm trích dẫn. Phần bắt lỗi: một lượt riêng tìm phát biểu sai, chạy song song nên không chậm thêm. Hướng tiếp theo là RAG để có nguồn tri thức độc lập."

| Câu hỏi có thể bị hỏi | Gợi ý trả lời |
|---|---|
| Độ chính xác bao nhiêu? | **Chưa có số "AI so với người"**: mới có người chấm 1; cần người chấm 2 để tính trần. Chỉ có số đo độ trễ và các ca thử |
| Vì sao QWK mà không accuracy? | Điểm có thứ bậc: lệch 1 mức nhẹ hơn lệch 3 mức; QWK phạt theo bình phương |
| Vì sao có holdout? | Để đo một lần sau khi ngừng chỉnh prompt; chỉnh sau khi xem holdout thì không còn giá trị |
| Bộ chuẩn do AI viết, tin được không? | Chỉ dùng để thử pipeline; số "AI so với người" bắt buộc dùng nhãn của người, và phải công bố giới hạn này |
| Vì sao lượt kiểm lỗi riêng? | Gộp chung thì model nhỏ bỏ sót lỗi, model lớn chậm 13-18s; tách riêng, tắt suy nghĩ thì 1,4s và bắt đúng |
| Kiểm lỗi sai thì sao? | Lỗi phải có quote thật mới tính; lượt kiểm lỗi lỗi/quá hạn thì bỏ qua; vẫn cần đo tỷ lệ báo nhầm |
| RAG khác gì dán tài liệu vào prompt? | RAG có ingestion, truy xuất theo từng ý, grounding và đo được; dán tài liệu thì không mở rộng và không kiểm soát được nguồn |
| Hạn chế nên nói thẳng | Chưa đo độ chính xác; công thức quy đổi chưa hiệu chỉnh; kiểm lỗi chưa đo báo nhầm; đáp án tham chiếu chưa duyệt hết |

## 6. Câu hỏi ôn
1. Hai người chấm khớp nhau QWK 0,45. Có nên chỉnh prompt cho AI trước không? Vì sao?
2. Bộ chấm giả chỉ xếp theo độ dài đạt QWK 0,65 với người. AI đạt 0,68. Kết luận gì?
3. 4 ý `COVERED` và 1 lỗi kiến thức thì điểm CORRECTNESS là mấy? (4 ý, không phải 5)
4. Vì sao lượt kiểm lỗi phải chạy song song và không được làm hỏng phiên chấm khi lỗi?
5. LLM kiểm lỗi báo "cây quyết định là mô hình tham số" là sai, nhưng cách gọi phổ biến là "phi tham số". Hệ thống bảo vệ người dùng ở chỗ nào, và còn lỗ hổng gì?
6. Tại sao điểm 75 → 97,5 sau khi đổi quy tắc quote lại cần đo lại bộ chuẩn?

## 7. Đáp án
1. Không. Đồng thuận giữa người là **trần**: rubric còn mơ hồ nên phải làm rõ mức điểm và tăng phiên bản rubric, chấm lại, rồi mới chỉnh AI.
2. Chưa thể kết luận AI tốt: gần như không hơn mốc độ dài. Cần so với mốc độ dài, không chỉ so với 0,6.
3. 4 ý đủ = 4, trừ 0,5 = 3,5, chia 4 = 0,875 → 1 + round(3,5) = 1 + 4 = **5** (làm tròn HALF_UP). Với 2 lỗi: 3/4 = 0,75 → 1 + 3 = 4.
4. Song song để không cộng thêm thời gian chờ (NF1 ≤ 12s). Không làm hỏng phiên vì đây chỉ là kiểm tra bổ sung, người dùng vẫn cần điểm.
5. Lỗi chỉ tính khi trích dẫn có thật trong transcript và có tối đa 5 lỗi; nhưng **vẫn không kiểm được tính đúng sai của chính nhận định** (cùng kiến thức LLM). Lỗ hổng: báo nhầm khi LLM nhầm; cần RAG và đo tỷ lệ báo nhầm.
6. Quy tắc quote thay đổi làm điểm của nhiều câu thay đổi; mọi số đo trước đó (QWK, MAE) dựa trên quy tắc cũ nên không còn so sánh được.
