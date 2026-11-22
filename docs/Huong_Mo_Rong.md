# Đề xuất hướng triển khai và mở rộng sau demo v1

- Ngày viết: 22/11/2026. Người viết: Giang (nháp để thảo luận với Tuấn Anh).
- Nguồn: kết quả chạy thật ngày 22/11, `docs/Ban_Giao_Tien_Do_20261119.md`, `docs/knowledge/tech-debt.md`, `docs/Ke_Hoach_Coding.md` (EP7).
- Điều chưa kiểm chứng được ghi rõ là "chưa xác minh".

## 1. Vì sao cần hướng này

Quan sát từ phiên chấm thật ngày 22/11 (câu TECHNICAL "Những tham số chính của mô hình cây quyết định là gì?"):

1. Pipeline chạy được: STT tiếng Việt giữ từ đệm, 8,9 giây từ nộp đến có kết quả (mẫu 61 giây), model `gemini-3.1-flash-lite`.
2. CORRECTNESS = 5/5 là hợp lý (người nói nêu đủ 5/5 ý của `reference_answer`), nhưng **hệ thống không chứng minh được điều đó**: chỉ có một trích dẫn tiêu biểu, và `reference_answer` chỉ đi vào prompt, không đi ra kết quả.
3. Điểm chuyên môn hiện phụ thuộc hai thứ không kiểm chứng được: kiến thức của LLM và đáp án tham chiếu do người/LLM soạn. Bộ dữ liệu chuẩn (#159) do Claude viết nên không xác định đúng/sai.

Kết luận: muốn điểm CORRECTNESS có căn cứ, cần chuyển từ "LLM tự đánh giá" sang "đối chiếu từng ý với nguồn tri thức, có trích dẫn cả hai phía". Đây là hướng RAG đã chốt ngày 21/11.

Phạm vi áp dụng: chỉ câu `TECHNICAL`. Câu hành vi, tình huống, giới thiệu không có đáp án đúng nên vẫn chấm theo cách trình bày (rubric hiện tại). Ngân hàng câu hỏi hiện chỉ có ngành IT (815 câu, đều `ACTIVE`).

## 2. Hợp đồng kết quả mới: "đối chiếu theo ý" (claim-level grounding)

Đây là bước nền cho mọi giai đoạn sau, và là thứ giao diện hiển thị.

Với mỗi ý (`point`) của đáp án tham chiếu, kết quả lưu:

| Trường | Ý nghĩa |
|---|---|
| `pointText` | Nội dung ý cần có |
| `verdict` | `COVERED` (nêu đủ), `PARTIAL` (nêu thiếu/lệch), `MISSING` (không nêu), `INCORRECT` (nêu sai) |
| `answerQuote` | Đoạn trong transcript làm bằng chứng (kiểm bằng `QuoteValidator`) |
| `sourceRef` | Nguồn tri thức làm căn cứ (giai đoạn 2 trở đi; giai đoạn 1 là chính `reference_answer`) |
| `note` | Một câu giải thích |

Điểm CORRECTNESS do **server tính** từ tỷ lệ ý `COVERED`/`PARTIAL`/`INCORRECT`, không để LLM tự cho số, cùng nguyên tắc "LLM chấm tiêu chí, server tính điểm" đang dùng.

Giao diện thêm khối "Đối chiếu đáp án": mỗi ý một dòng ✓ / ◐ / ✗ kèm trích dẫn. Giai đoạn 3 tô màu trực tiếp trên transcript.

## 3. Lộ trình theo giai đoạn

### Giai đoạn 1: Đối chiếu theo ý trên `reference_answer` (ĐÃ LÀM 22/11/2026, chưa commit)
- **Đã triển khai:** migration `V4__score_points.sql`, entity `ScorePoint`, `ReferencePoints` (tách đáp án thành ý), schema LLM có mảng `points`, `LlmResultValidator` kiểm `points`, `LlmScorer` hạ bậc ý có trích dẫn không khớp transcript, `CorrectnessCalculator` tính điểm CORRECTNESS, API `ScoreResult.points`, khối "Đối chiếu với đáp án tham chiếu" ở `ResultsPage.jsx`, `openapi.yaml`, `Data_Dictionary.md`.
- **Công thức:** `coverage = (COVERED + 0.5·PARTIAL − 0.5·INCORRECT) / số ý` (chặn dưới 0), điểm CORRECTNESS = `1 + làm tròn(4·coverage)`. Điểm LLM tự cho tiêu chí này bị bỏ.
- **Quy tắc trích dẫn:** ý COVERED/PARTIAL mà trích dẫn không có trong transcript bị hạ một bậc (COVERED→PARTIAL→MISSING) và gắn `quoteInvalid`.
- **Giới hạn đã biết:** chỉ câu TECHNICAL có `reference_answer`; tối đa 10 ý; chưa đo độ chính xác của `verdict` (cần giai đoạn 3); công thức quy đổi là lựa chọn thiết kế chưa được hiệu chỉnh bằng dữ liệu người chấm.
- Phần "Làm gì / Chạm vào" bên dưới giữ lại như bản thiết kế ban đầu.

**Bổ sung giai đoạn 1: lượt kiểm lỗi kiến thức (ĐÃ LÀM 22/11/2026, chưa commit).**
- **Vì sao:** đối chiếu ý chỉ kiểm "có nhắc đến ý đó không". Thử thật: người nói nhập nhầm `min_samples_split` với `min_samples_leaf` mà ý vẫn COVERED, vì model nhỏ không bắt được lỗi trong một lượt chấm nhiều việc.
- **Cách làm:** `KnowledgeErrorDetector` (port) + `GeminiKnowledgeErrorDetector` (adapter): một lượt Gemini riêng, chỉ trả danh sách phát biểu sai, model `gemini-3-flash-preview`, `thinkingLevel: minimal`. Chạy song song với lượt chấm chính (luồng ảo, `knowledgeCheckExecutor`), chỉ cho câu TECHNICAL có đáp án tham chiếu.
- **Quy tắc:** lỗi có trích dẫn không nằm trong transcript bị bỏ. Mỗi lỗi hợp lệ trừ 0,5 trong tử số coverage. Lượt này lỗi, quá hạn (8s) hay bị tắt thì bỏ qua, không làm hỏng phiên. Bảng `score_errors` (V5), `ScoreResult.errors`, khối "Chỗ cần sửa" ở giao diện.
- **Số đo trên một mẫu (chưa phải thống kê):** lượt riêng khoảng 1,4s, 423 token, bắt đúng lỗi 2/2 lần; so với lượt chấm chính khoảng 2.000 token. Model `3.1-flash-lite` trong lượt riêng cũng bắt được nhưng báo nhầm thêm một lỗi.
- **Cấu hình:** `ai.check.*` (`KNOWLEDGE_CHECK_ENABLED`, `GEMINI_CHECK_MODEL`).
- **Giới hạn:** vẫn dựa vào kiến thức của LLM, chưa có nguồn tri thức độc lập; chưa đo tỷ lệ bắt đúng và báo nhầm (cần giai đoạn 3).

- **Làm gì:** đổi schema LLM cho CORRECTNESS trả danh sách ý theo hợp đồng ở mục 2; tách `reference_answer` thành các ý (mỗi gạch đầu dòng một ý); server tính điểm CORRECTNESS.
- **Chạm vào:** `PromptBuilder`, `GeminiLlmClient.responseSchema`, `LlmResultValidator`, `ScoreCalculator`, bảng mới `score_points` (Flyway V4), `ScoreResultResponse`, `openapi.yaml` (tăng phiên bản API), `ResultsPage.jsx`.
- **Đầu ra kiểm được:** câu trả lời thiếu ý hiển thị đúng ý thiếu; câu nêu đủ hiển thị đủ.
- **Rủi ro:** `reference_answer` do người soạn nên có thể sai hoặc sót; giai đoạn này chỉ làm điểm *minh bạch*, chưa làm điểm *đúng hơn*. Cần ghi rõ như vậy khi báo cáo.
- **Ước lượng công:** chưa xác minh; cần Tuấn Anh bàn vì ảnh hưởng frontend.

### Giai đoạn 2: RAG làm căn cứ chuyên môn
Mục tiêu: `sourceRef` trỏ tới nguồn có thật, và chấm được cả câu không có `reference_answer` đầy đủ.

| Thành phần | Nội dung |
|---|---|
| Ingestion | Nạp tài liệu nguồn (giáo trình mở, tài liệu chính thức có giấy phép cho phép) theo ngành/vị trí; cắt đoạn, gắn metadata (ngành, chủ đề, nguồn, giấy phép, ngày tra) |
| Lưu trữ vector | Phương án 1: `pgvector` trên PostgreSQL hiện có (ít hạ tầng nhất; chưa xác minh khả năng cài trên môi trường demo). Phương án 2: dịch vụ vector riêng (thêm hạ tầng, lệch ADR-001 "một instance") |
| Retrieval | Truy xuất theo (câu hỏi + từng ý cần kiểm), có lọc theo ngành/chủ đề; cân nhắc kết hợp từ khóa và vector |
| Grounding | LLM chỉ được kết luận `COVERED/INCORRECT` dựa trên đoạn truy xuất được; không có căn cứ thì ghi `UNVERIFIED`, không tự suy |
| Port/Adapter | `KnowledgeRetriever` là port mới, đặt cạnh `LlmClient`, `SttClient`; giữ kiến trúc hiện có |
| Phiên bản hóa | Ghi `knowledgeVersion` cùng `rubricVersion`, `promptVersion`, `modelVersion` để kết quả truy vết được |

Điểm cần chốt: nguồn nào được dùng và giấy phép; nội dung nào của đáp án tham chiếu sinh từ nguồn thay vì từ LLM.

### Giai đoạn 3: Đo độ chính xác thật
Hiện chưa có số đo nào cho điểm AI (bộ chuẩn do AI viết, AC-30 chưa đo cho cả bộ mẫu).
- Người chấm thật gán nhãn `verdict` cho một tập câu trả lời (mở rộng `rater.html` của #159 sang mức từng ý, không chỉ điểm tổng).
- Đo: độ đồng thuận người-người trước (làm trần), rồi người-hệ thống (QWK cho điểm; precision/recall cho `verdict`).
- So sánh trước/sau RAG, và giữa các model (`3.1-flash-lite`, `3-flash-preview`) để chọn model có căn cứ.
- Đây là phần giáo viên dễ hỏi nhất: "độ chính xác bao nhiêu, đo thế nào".

### Giai đoạn 4: Tô màu trên transcript
Trích dẫn từng ý có vị trí ký tự trong transcript; giao diện tô xanh/vàng/đỏ. Phụ thuộc giai đoạn 1.

## 4. Hướng mở rộng khác (không phụ thuộc RAG)

| Hướng | Nội dung | Ghi chú |
|---|---|---|
| WPM thật | Dùng `wordTimestamp` của `gemini-3.5-transcribe` thay `durationSeconds` client khai | Phiên thật cho WPM 207, nghi cao bất thường; chưa xác minh `wordTimestamp` dùng được ở chế độ VERBATIM |
| Độ ổn định LLM | Cấu hình model dự phòng tự động khi model chính 503 hoặc quá hạn; ghi metric độ trễ p95 | Tháng 11 các model 3.5–3.8 từng 503 hoặc treo, `2.5-flash` ngừng 01/12 |
| TTS (#121) | Đọc phản hồi bằng FPT.AI | Cần `FPT_AI_API_KEY`; có khóa trong `.env`, chưa kiểm chạy |
| Quản trị tri thức | Giao diện admin nạp/duyệt nguồn RAG và `reference_answer` | Cần cho giai đoạn 2 |
| Mở rộng ngành | Thêm ngành ngoài IT (ngân hàng câu hỏi, nguồn RAG theo ngành) | Đi cùng taxonomy-v1.0 |
| EP7 cũ | #124 độ tự tin qua giọng, #134-135 tiếng Anh, #143 Realtime/Live API | Làm sau khi đo được độ chính xác |

## 5. Quyết định cần chốt với Tuấn Anh

1. Có làm giai đoạn 1 ngay sau demo (thay đổi API, DB, giao diện) hay gộp 1 và 2 thành một đợt?
2. Vector store: `pgvector` trong Postgres hay dịch vụ riêng? (cần thử cài trên môi trường deploy)
3. Nguồn tri thức: ai chọn, ai kiểm giấy phép; nguồn tiếng Việt hay tiếng Anh?
4. Rubric: chấp nhận quy tắc quote nhiều đoạn nối bằng `...` (prompt-v2, đã làm 22/11)? Câu hỏi Q10 về `weight` vẫn mở.
5. Tập gán nhãn mức từng ý: ai gán, bao nhiêu mẫu?

## 6. Rủi ro và giới hạn trung thực

- RAG làm điểm *có căn cứ*, không làm điểm *chắc chắn đúng*: nguồn sai hoặc truy xuất sai vẫn cho kết quả sai. Vì vậy giai đoạn 3 (đo) không được bỏ.
- Ngân hàng câu hỏi và `reference_answer` hiện sinh bằng LLM rồi duyệt; chưa có thước đo chất lượng.
- Mọi ước lượng công trong tài liệu này là chưa xác minh.
