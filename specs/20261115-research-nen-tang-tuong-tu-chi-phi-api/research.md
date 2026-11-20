# Nghiên cứu: nền tảng tương tự dựng kiến trúc giọng nói thế nào, dùng nhiều API ngoài có lãng phí không

Ngày tra: 2026-11-15 · Loại: research · Trạng thái: done
Liên quan: `specs/20261115-research-stt-tts-hoi-thoai/research.md` (chọn model STT/TTS)

## 1. Câu hỏi cần quyết định
- Các nền tảng luyện phỏng vấn hoặc luyện nói bằng AI, trong và ngoài nước, dựng STT/LLM/TTS theo kiểu nào?
- Dự án đang gọi 4 dịch vụ ngoài: Gemini STT, Gemini LLM, FPT TTS và S3. Như vậy có lãng phí tiền hoặc độ phức tạp không? Nên gộp bớt hay tự host?

Tiêu chí đánh giá:
- chi phí cho mỗi lượt chấm;
- số nhà cung cấp, API key và billing phải quản lý;
- yêu cầu của phần chấm: phải có transcript nguyên văn để kiểm trích dẫn và đếm từ đệm;
- khả năng chạy trên Render, không có GPU;
- quyền riêng tư của giọng nói.

## 2. Các nền tảng tương tự làm gì
| Nền tảng | Cách làm (theo nguồn công khai) | Ghi chú |
|---|---|---|
| Google Interview Warmup | 5 câu hỏi theo ngành. Trả lời bằng giọng nói được chép lời theo thời gian thực, rồi NLP rút ra "từ chuyên ngành", "từ dùng nhiều" và "ý đã nói" | **Không chấm điểm** và **không lưu audio**; người dùng tự tải transcript |
| Yoodli | Huấn luyện nói: phân tích tốc độ, từ đệm, âm lượng, cách dùng từ; có bản tích hợp Zoom chạy thời gian thực | Giống khối Delivery của dự án. Chưa thấy công bố họ dùng nhà cung cấp STT nào |
| Sản phẩm có tiếng Việt (Ava by Wizco, Interviews.chat, Acedit, Supawork…) | Trả lời bằng giọng nói hoặc gõ chữ | Chỉ có bài tổng hợp hoặc PR, không công bố kiến trúc. Chưa xác minh |
| Dự án mã nguồn mở (VoxPrep, mock-mind, voice-ai-interview…) | Hầu hết là chuỗi **STT → LLM → TTS**: Whisper hoặc Deepgram cho STT, GPT hoặc Gemini cho LLM, Edge-TTS hoặc gTTS cho TTS. Một số dùng nền tảng voice agent trọn gói (Vapi) | Thường dùng 3–4 dịch vụ ngoài giống dự án này |
| Bài thiết kế hệ thống "AI mock interview 1M users" | Khuyên **hybrid**: thuê STT/TTS, tự kiểm soát LLM; **chấm bất đồng bộ sau buổi phỏng vấn** bằng model mạnh hơn theo rubric, có trích bằng chứng, nhiệt độ 0; lưu transcript mặc định, **audio chỉ lưu khi người dùng đồng ý và giữ ngắn hạn**; chỉ tự host khi lưu lượng lớn | Trùng với ADR-001 (chấm bất đồng bộ) và `QuoteValidator` của dự án |

Kết luận của mục này: kiến trúc hiện tại gồm chuỗi STT → LLM, chấm nền, trích dẫn có kiểm và TTS tách riêng, **đúng với cách làm phổ biến**. Speech-to-speech (Realtime/Live API) chỉ phổ biến ở phần *hội thoại*, còn phần *chấm* vẫn cần transcript.

## 3. Ba kiểu kiến trúc trong ngành
| Phương án | Ưu | Nhược | Chi phí chuyển đổi | Hợp khi nào |
|---|---|---|---|---|
| **Chuỗi STT → LLM → TTS bằng API (hiện tại)** | Có transcript cho từng lượt để chấm; thay từng khâu độc lập (Adapter Pattern); rẻ nhất trên mỗi phút ở quy mô nhỏ; không cần GPU | Nhiều nhà cung cấp, API key và billing; độ trễ cộng dồn qua 3 bước | 0 | Đồ án, MVP, chấm theo rubric (**dự án này**) |
| Speech-to-speech (Gemini Live, OpenAI Realtime) | Trễ thấp, hội thoại tự nhiên, ngắt lời được | Đắt hơn khoảng 10 lần mỗi phút (ví dụ của Murf: khoảng $0,13/phút so với khoảng $0,012/phút); transcript chỉ là sản phẩm phụ, vẫn phải gọi LLM riêng để chấm | Cao (WebSocket, luồng mới) | Phần hội thoại thời gian thực (Cách B), không thay phần chấm |
| Tự host (Whisper/PhoWhisper, LLM mở, TTS mở) | Rẻ nhất khi lưu lượng rất lớn; dữ liệu không rời hạ tầng | Cần GPU, autoscale, vận hành; Render không đáp ứng; chất lượng chấm của LLM mở tiếng Việt chưa rõ | Rất cao | Hàng chục nghìn phút mỗi ngày, hoặc bắt buộc dữ liệu nội bộ |

## 4. Chi phí ước tính cho một lượt chấm (giá Gemini tra 2026-11-15; ước tính, chưa đo)
Giả định một câu trả lời dài 2 phút (tối đa 180 giây theo `application.yml:48`), prompt chấm khoảng 3.500 token vào và khoảng 800 token ra.

| Khâu | Phép tính | USD |
|---|---|---|
| STT `gemini-3.5-transcribe` | 2 phút × khoảng $0,005 | ≈ 0,010 |
| LLM `gemini-3.8-flash` | 3.500 × $0,75/1M + 800 × $3,75/1M | ≈ 0,0056 |
| TTS đọc phản hồi (khoảng 500 ký tự, FPT) | miễn phí 100.000 ký tự/tháng; gói 500.000đ / 1,5M ký tự ≈ 167đ/lượt | 0–0,007 |
| S3 lưu audio khoảng 2MB | khoảng $0,023/GB-tháng | ≈ 0,00005 |
| **Tổng** | | **≈ $0,016–0,023 (khoảng 400–600đ)** |

- 1.000 lượt chấm mỗi tháng tốn khoảng $16–23. Nếu chấm lại do LLM trả kết quả sai schema hoặc trích dẫn sai (`LlmScorer`, tối đa 2 lần), chi phí LLM nhân tối đa 2.
- Từ 2027-01-01, giá `gemini-3.8-flash` và Flash TTS tăng gấp đôi theo trang giá. Tổng sẽ vào khoảng $0,022–0,03.
- Khi phát triển có thể dùng gói miễn phí, nhưng gói này **dùng dữ liệu để cải thiện sản phẩm**. Không nên đưa giọng nói của người dùng thật qua gói miễn phí.

## 5. Có lãng phí không?
**Số nhà cung cấp không phải nguồn lãng phí.** Tiền nằm ở số phút audio và số token, không nằm ở việc có 2 hay 4 API. Lãng phí thật nằm ở những chỗ sau:

| Chỗ có thể lãng phí | Hiện trạng | Đề xuất |
|---|---|---|
| Gọi TTS cho mọi kết quả, kể cả khi người dùng chỉ đọc | #121 chưa làm | Chỉ sinh TTS **khi người dùng bấm nghe**, rồi cache theo phiên |
| Lưu audio vô thời hạn | S3 chưa có lifecycle; có thêm file mồ côi khi upload lại (F5 trong tech-debt) | S3 lifecycle xóa sau khoảng 30 ngày; chấm lại (#155) chỉ cần transcript, không cần audio |
| Chấm lại không giới hạn | Không có rate limit theo người dùng (F4) | Giới hạn số lượt chấm mỗi ngày cho mỗi người dùng |
| Gộp STT với chấm thành 1 lần gọi Gemini (audio vào, điểm ra) | Đang gọi 2 lần | **Không gộp**: mất transcript nguyên văn, nên `QuoteValidator` và `DeliveryCalculator` không chạy được, cũng không còn chấm lại bằng transcript. Tiết kiệm khoảng $0,005 nhưng mất cơ chế chống bịa |
| FPT TTS là nhà cung cấp thứ 3 | Đã nằm trong thiết kế | Nếu muốn giảm số API key, có thể thay bằng Gemini TTS (cùng key, `vi-VN` GA) hoặc TTS của trình duyệt (miễn phí, chất lượng không đồng đều). Quyết định sau khi nghe thử |
| Tự host Whisper hoặc LLM để "khỏi tốn API" | — | Không đáng ở quy mô đồ án: một máy GPU chạy liên tục đắt hơn rất nhiều so với vài chục USD API mỗi tháng (giá GPU chưa tra), lại thêm việc vận hành |

## 6. Khuyến nghị
**Giữ kiến trúc chuỗi STT → LLM → TTS bằng API như hiện tại.** Thêm 3 biện pháp chống lãng phí rẻ:
1. Chỉ sinh TTS khi người dùng bấm nghe.
2. Bật S3 lifecycle và xóa file mồ côi.
3. Giới hạn số lượt chấm theo người dùng.

Cân nhắc gộp FPT TTS vào Gemini TTS để còn 2 nhà cung cấp (Google và AWS) nếu giọng Gemini đạt.

**Khuyến nghị đổi khi:**
- lưu lượng vượt khoảng vài chục nghìn phút mỗi tháng và chi phí STT chiếm phần lớn: cân nhắc tự host PhoWhisper;
- bắt buộc giọng nói không rời hạ tầng: tự host STT;
- làm hội thoại thời gian thực: thêm Live API cho phần hội thoại, phần chấm vẫn giữ nguyên.

## 7. Chưa xác minh
- Kiến trúc nội bộ của Yoodli, Final Round AI và các sản phẩm tiếng Việt (không công bố).
- Số token thực của prompt chấm; độ dài trung bình câu trả lời thật; tỷ lệ phải gọi lại LLM.
- Giá GPU để so với tự host; tỷ giá USD/VND dùng làm tròn khoảng 25.000–26.000.
- Ví dụ so sánh chi phí speech-to-speech và cascade lấy từ blog của nhà cung cấp (Murf).

## 8. Nguồn (tra 2026-11-15)
- Thiết kế hệ thống AI mock interview: https://www.interviewsvector.com/blog/ai-mock-interview-platform-system-design
- Cascade so với speech-to-speech: https://murf.ai/blog/speech-to-speech-vs-stt-llm-tts · https://deepgram.com/learn/speech-to-speech-vs-cascade-voice-agent-architecture · https://inworld.ai/resources/cascaded-vs-speech-to-speech-voice-architecture
- Google Interview Warmup: https://9to5google.com/2022/05/17/google-interview-warmup/ · https://voicebot.ai/2022/05/26/google-launches-free-interview-warmup-voice-ai-tool-for-job-seekers/
- Yoodli: https://yoodli.ai/blog/ai-speech-coaching-explained · https://yoodli.ai/blog/how-to-stop-using-filler-words
- Mã nguồn mở: https://github.com/shivanshanand/VoxPrep · https://github.com/pjha26/mock-mind · https://github.com/rajatverma777/voice-ai-interview · https://github.com/Vednatladde/AI-powered-Mock-Interview
- Tổng hợp công cụ tiếng Việt: https://fptshop.com.vn/tin-tuc/danh-gia/cong-cu-ai-giup-luyen-tra-loi-phong-van-187569 · https://ybox.vn/ky-nang/toptip-top-5-website-phong-van-ao-giup-ban-chuan-bi-san-sang-va-ghi-diem-khi-phong-van-68cbd811fe6ca949df99db5b
- Giá Gemini: https://aistudio.google.com/docs/pricing · Giá FPT TTS: https://docs.fpt.ai/docs/en/speech/documentation/tts-pricing/
