# Nghiên cứu: chọn STT / TTS / LLM cho chấm điểm và phỏng vấn hội thoại

Ngày tra: 2026-11-15 · Loại: research · Trạng thái: done

## 1. Câu hỏi cần quyết định
1. Có nên đổi đầu vào (STT) sang Whisper (OpenAI API hoặc tự chạy PhoWhisper) thay cho Gemini không?
2. Đầu ra giọng nói (TTS) nên dùng gì: FPT.AI như kế hoạch, Gemini TTS hay dịch vụ khác?
3. Với tính năng phỏng vấn nhiều lượt (Cách A) rồi thời gian thực (Cách B), chọn công nghệ nào để không phải làm lại?

## 2. Tiêu chí (lấy từ ràng buộc dự án)
| Tiêu chí | Vì sao quan trọng ở dự án này |
|---|---|
| Giữ nguyên văn, kể cả từ đệm ("ờ", "à", "kiểu là") | `DeliveryCalculator` đếm từ đệm theo `filler-vi-v1`; STT tự lọc từ đệm thì điểm Delivery sai |
| Độ chính xác tiếng Việt | Trích dẫn (quote) phải khớp transcript; STT sai thì `QuoteValidator` hạ điểm oan |
| Độ trễ | Cổng #159: STT + LLM ≤ 12 giây |
| Chi phí, độ phức tạp vận hành | Đồ án 2 người, deploy Render, không có GPU |
| Tuổi thọ API | Không chọn thứ sắp bị khai tử |

## 3. Phát hiện quan trọng (ảnh hưởng ngay tới code hiện tại)
- **`gemini-2.5-flash` bị khai tử từ 2026-12-01**: request sẽ tự chuyển sang `gemini-3.5-flash-lite` và tính giá theo model đó. Đây đang là model mặc định cho cả STT lẫn LLM (`application.yml:27-28`). Chỉ còn khoảng 2 tuần. Nguồn: trang giá Gemini API.
- Google đã có **model chuyên chép lời `gemini-3.5-transcribe`**, vẫn gọi qua `generateContent` (như `GeminiSttClient.java:66`). Model này có:
  - chế độ `VERBATIM` (mặc định) **giữ từ đệm, lặp từ, ngập ngừng**, và chế độ `SMART` để lọc chúng đi;
  - `languageCodes: ["vi-VN"]`, hỗ trợ tiếng Việt;
  - `wordTimestamp: true` trả thời điểm bắt đầu và kết thúc của từng từ;
  - nhận `audio/webm`. Rủi ro "Gemini không nhận webm" trong `docs/knowledge/tech-debt.md` vì thế **đã được giải quyết theo tài liệu**, nhưng vẫn cần thử thật.
  - Giá khoảng $0.005/phút audio (gói trả phí), có gói miễn phí.
- **OpenAI khai tử `whisper-1` và `gpt-4o-transcribe` vào 2027-02-26** (đã thông báo 2026-08-26). Thay bằng `gpt-transcribe` hoặc `gpt-live-transcribe`.
- **Gói miễn phí của Gemini dùng dữ liệu để cải thiện sản phẩm**, gói trả phí thì không. Audio là giọng nói của người dùng, nên bản deploy cho người dùng thật cần cân nhắc bật gói trả phí, hoặc ghi rõ trong điều khoản.

## 4. So sánh STT (đầu vào)
| Phương án | Ưu | Nhược | Chi phí chuyển đổi | Hợp khi nào |
|---|---|---|---|---|
| **Gemini `gemini-3.5-transcribe`, chế độ VERBATIM** (khuyến nghị) | Giữ từ đệm theo thiết kế; có timestamp từng từ; nhận webm; cùng API key và cùng `generateContent`; có bản `-live` cho Cách B | Chưa đo WER tiếng Việt trên dữ liệu thật; bật timestamp có thể giảm độ chính xác; tài liệu không nói rõ đã GA hay còn preview | Thấp: đổi tên model, thêm `generationConfig.audioTranscriptionConfig`, bỏ prompt chép lời, parse `words[]` | Mặc định cho dự án |
| Gemini Flash + prompt "chép nguyên văn" (hiện tại) | Đã code xong và có test | Model đang dùng sắp khai tử; LLM tổng quát có thể "sửa câu" hoặc bịa lời, không có timestamp | 0 | Chỉ để dự phòng |
| OpenAI `whisper-1` / `gpt-4o-transcribe` | Phổ biến, nhiều tài liệu | **Khai tử 2027-02-26**; Whisper có xu hướng **lọc từ đệm**; thêm một nhà cung cấp và một API key; một benchmark độc lập cho kết quả tiếng Việt kém (WER 64% với gpt-4o-transcribe, chưa rõ cách đo) | Trung bình: adapter mới, billing mới | Không khuyến nghị |
| Tự chạy PhoWhisper (VinAI, có bản large 1.55B tham số) | Mạnh với tiếng Việt (WER 4.67% trên VIVOS, 8.14% trên CMV-Vi); chạy offline, không gửi giọng nói ra ngoài | Cần GPU hoặc nhiều RAM, gói rẻ của Render không đáp ứng; phải tự vận hành một dịch vụ Python; vẫn có thể lọc từ đệm như Whisper gốc (chưa xác minh) | Cao | Khi có server GPU hoặc yêu cầu bắt buộc dữ liệu không rời máy |
| FPT.AI / Viettel AI / VNPT SmartVoice (trong nước) | Tối ưu giọng vùng miền Việt Nam; hỗ trợ trong nước | Không công bố WER mới; giá STT phải liên hệ (FPT có báo giá bên thứ ba: 2.000 phút / 1,4 triệu đồng, chưa xác minh); chưa rõ có giữ từ đệm không | Trung bình | Phương án B nếu Gemini chép lời tiếng Việt kém trên dữ liệu đo |

**Kết luận STT:** không chuyển sang Whisper. Chuyển sang `gemini-3.5-transcribe` (VERBATIM, `vi-VN`, `wordTimestamp`).

Lợi ích phụ: có timestamp từng từ thì tính được **thời gian nói thật** (từ đầu tiên tới từ cuối cùng). Như vậy WPM không còn phụ thuộc `durationSeconds` do client khai báo, vốn là điểm yếu đã ghi trong `tech-debt.md`.

## 5. So sánh TTS (đầu ra giọng nói)
| Phương án | Ưu | Nhược | Hợp khi nào |
|---|---|---|---|
| **FPT.AI TTS** (theo kế hoạch #121) | Giọng Việt bản địa; miễn phí 100.000 ký tự/tháng (bản v5); gói 500.000 đồng / 1,5 triệu ký tự | Gói miễn phí chậm, có hàng đợi và giới hạn số request/ngày; thêm một nhà cung cấp; danh sách giọng chưa xác minh | Đọc phản hồi ở bản hiện tại; đã nằm trong tài liệu thiết kế và bảo vệ |
| **Gemini TTS** (`gemini-3.8-flash-tts`, `-flash-lite-tts`) | Cùng API key; `vi-VN` có trạng thái GA trên Cloud TTS; điều khiển được giọng điệu bằng prompt; có gói miễn phí; khoảng $0.0015–0.00225 cho mỗi 10 giây audio (giá tăng gấp đôi từ 2027-01-01) | Chất lượng giọng Việt chưa nghe thử; giá tính theo token | Phỏng vấn nhiều lượt: cần nhiều câu ngắn và giọng "người phỏng vấn" |
| Web Speech API của trình duyệt | Miễn phí, không cần backend | Chất lượng giọng Việt tùy trình duyệt và hệ điều hành, không đồng nhất | Bản demo nhanh |

**Kết luận TTS:** giữ adapter TTS theo Adapter Pattern (đã có trong kiến trúc). Thử cùng 5 câu mẫu trên FPT.AI và Gemini TTS rồi chọn bằng tai nghe.
- Mặc định giữ **FPT.AI**, để khỏi phải sửa tài liệu thiết kế.
- Chuyển sang Gemini TTS nếu gói miễn phí của FPT quá chậm cho hội thoại nhiều lượt.

## 6. Đề xuất cho phỏng vấn nhiều lượt
**Cách A, mỗi lượt:**
```
ghi âm → POST answer → STT gemini-3.5-transcribe → LLM (Flash hiện hành) sinh câu hỏi tiếp/kết thúc
→ TTS → client phát câu hỏi → … → kết thúc: chấm rubric trên toàn bộ transcript
```
- LLM sinh câu hỏi tiếp trả JSON ngắn: `{nextQuestion, rationale, shouldEnd}`. Đặt giới hạn số lượt (ví dụ 3–5 câu đào sâu) để kiểm soát chi phí.
- Chấm điểm có thể dùng lại `ScoringPipeline`, `QuoteValidator`, `ScoreCalculator`. Cần quyết định chấm trên toàn bộ cuộc trò chuyện hay chấm từng lượt.
- Chống prompt injection quan trọng hơn ở đây, vì câu trả lời của người dùng đi thẳng vào prompt sinh câu hỏi tiếp.
- Ước tính thô cho một buổi 10 phút (khoảng 5 phút người dùng nói): STT khoảng $0.025, cộng LLM và TTS vài cent. Chưa đo.

**Cách B (sau):** dùng Gemini Live API (`gemini-3.8-live` hoặc `gemini-3.1-flash-live-preview`) qua WebSocket với ephemeral token.
- Phiên chỉ có audio bị giới hạn khoảng 15 phút.
- Giá khoảng $0.005/phút audio vào và $0.018/phút audio ra.
- Chất lượng giọng Việt của native audio **chưa xác minh**.
- Có `gemini-3.5-transcribe-live` để lấy transcript liên tục.
- Chọn Gemini ở Cách A thì Cách B dùng lại được cùng nhà cung cấp và cùng API key.

## 7. Khuyến nghị và điều kiện đổi
1. **Ngay (trước 2026-12-01):** đổi model mặc định của STT sang `gemini-3.5-transcribe` và của LLM sang Flash hiện hành (`gemini-3.8-flash`, cần kiểm lại tên trước khi đổi). Chạy smoke test với audio webm thật.
2. **Không dùng Whisper.** Chỉ cân nhắc lại khi một trong các điều sau xảy ra:
   - (a) WER tiếng Việt của Gemini trên bộ #159 vượt khoảng 15%;
   - (b) bắt buộc dữ liệu giọng nói không rời hạ tầng của mình, khi đó dùng PhoWhisper tự host;
   - (c) quota Gemini không đủ.
3. **TTS:** giữ FPT.AI làm mặc định, thử Gemini TTS song song khi làm Cách A.
4. **Cách A** làm sau khi luồng một câu đã chạy được với API thật. **Cách B** làm sau #159.

## 8. Chưa xác minh
- `gemini-3.5-transcribe` đã GA hay còn preview; WER tiếng Việt thực tế; độ trễ thực tế.
- Tên chính xác của model Flash text hiện hành để thay `gemini-2.5-flash`. Trang giá nêu `gemini-3.8-flash`.
- Danh sách giọng FPT.AI v5, giá STT FPT (báo giá bên thứ ba), giá Viettel và VNPT (không công bố).
- Whisper hoặc PhoWhisper có giữ từ đệm tiếng Việt không. Nguồn chỉ nói về "um/uh" tiếng Anh.
- Chất lượng tiếng Việt của Gemini Live native audio.

## 9. Nguồn (tra 2026-11-15)
- Gemini transcription: https://aistudio.google.com/docs/transcribe?generate-content=true
- Gemini audio understanding (MIME types, 20MB/request, 32 token/giây): https://aistudio.google.com/docs/audio?hl=en
- Gemini API pricing (transcribe, TTS, Live, khai tử 2.5-flash): https://aistudio.google.com/docs/pricing
- Gemini TTS, vi-VN GA: https://docs.cloud.google.com/text-to-speech/docs/gemini-tts
- Live API limits: https://firebase.google.com/docs/ai-logic/live-api/limits-and-specs · Ephemeral tokens: https://ai.google.dev/gemini-api/docs/ephemeral-tokens?hl=vi
- OpenAI deprecations: https://developers.openai.com/api/docs/deprecations
- Whisper lọc từ đệm: https://arxiv.org/html/2506.04076v1 · https://simbavoice.ai/resources/how-stt-handles-disfluencies-and-filler-words
- PhoWhisper: https://arxiv.org/html/2406.02555v1
- Benchmark đa ngôn ngữ (gpt-4o-transcribe tiếng Việt): https://voiceping.net/en/blog/research-voiceping-asr-model-v01-benchmark/
- FPT.AI STT docs: https://docs.fpt.ai/docs/vi/speech/api/speech-to-text · TTS pricing: https://docs.fpt.ai/docs/en/speech/documentation/tts-pricing/ · Báo giá STT (bên thứ ba): https://quasa.io/vi/media/fptai-hay-google-speech-to-text-tieng-viet-can-do-bang-wer
- Viettel AI STT: https://viettelai.vn/en/speech-to-text · VNPT SmartVoice: https://smartvoice.vnpt.vn/en · So sánh API STT Việt (2021): https://www.jte.edu.vn/index.php/jte/article/download/46/38/1041
