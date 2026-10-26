# Scripts thu thập dataset

## `collect_github_questions.py`

Thu thập câu hỏi phỏng vấn (tiếng Anh) từ các repo GitHub có license mở. Kết quả dùng làm đầu vào cho bước dịch/chuẩn hoá sang tiếng Việt trước khi seed vào bảng `questions`.

```bash
python scripts/dataset/collect_github_questions.py                    # chạy tất cả nguồn
python scripts/dataset/collect_github_questions.py --only sysadmin-skills --refresh
```

Yêu cầu Python 3.9+, không cần cài thêm thư viện. Đặt `GITHUB_TOKEN` nếu bị GitHub API giới hạn (60 request/giờ khi không đăng nhập; mỗi lần chạy dùng khoảng 10 request).

- File gốc cache tại `data/raw/github/<repo>/<commit>/...` (đã gitignore), tải theo commit SHA cố định nên kết quả tái lập được.
- Đầu ra: `data/interim/github_questions.jsonl`.
- Repo có license không thuộc `ALLOWED_LICENSES` sẽ bị bỏ qua.

### Nguồn hiện có

| key | Repo | License | Vị trí | Ghi chú |
|---|---|---|---|---|
| `tech-interview-handbook` | yangshun/tech-interview-handbook | MIT | Software Engineer | Câu hỏi hành vi, không có đáp án; nhiều câu nhắc tên công ty (xem `topic`) |
| `h5bp-frontend` | h5bp/Front-end-Developer-Interview-Questions | MIT | Frontend Developer | Không có đáp án; bỏ phần bài tập viết code |
| `react-interview-questions` | sudheerj/reactjs-interview-questions | MIT | Frontend Developer | Có đáp án |
| `data-science-interviews` | alexeygrigorev/data-science-interviews | CC-BY-4.0 | Data Scientist | Có đáp án và độ khó (👶/⭐️/🚀); chỉ lấy `theory.md` |
| `sysadmin-skills` | trimstray/test-your-sysadmin-skills | MIT | System Administrator / DevOps | Có đáp án; độ khó theo cấp Junior/Regular/Senior/Guru |

Đã loại vì không có license: `sudheerj/javascript-interview-questions`, `chiphuyen/ml-interviews-book`, `bregman-arie/devops-exercises`, các repo `learning-zone/*`.

### Định dạng mỗi dòng JSONL

| Trường | Ý nghĩa |
|---|---|
| `id` | Hash ổn định từ nguồn + nội dung |
| `content_en` | Câu hỏi gốc |
| `answer_en` | Đáp án gốc (cắt tối đa 2000 ký tự) hoặc `null`; dùng làm nguyên liệu cho `reference_answer` |
| `question_type_guess` | Phỏng đoán theo luật đơn giản: `BEHAVIORAL`/`SITUATIONAL`/`TECHNICAL`/`INTRO`, **cần gán lại** |
| `level_guess` | `EASY`/`MEDIUM`/`HARD` nếu nguồn có, ngược lại `null` |
| `industry`, `position`, `topic` | Ngành, vị trí, chủ đề/mục trong file gốc |
| `source` | `repo`, `path`, `commit`, `url`, `license`; cần giữ để ghi nguồn theo license |

## `normalize_questions.py`

Dùng Gemini (REST `generateContent`, structured output) để chuyển `github_questions.jsonl` thành bản nháp câu hỏi tiếng Việt:

- loại câu không hợp trả lời bằng lời nói (`drop_reason`: `CODING_TASK`, `COMMAND_SPECIFIC`, `COMPANY_SPECIFIC`, `NOT_INTERVIEW`, `OUTDATED`, `LOW_QUALITY`)
- viết lại câu hỏi tiếng Việt tự nhiên, khái quát hoá tên công ty
- gán `question_type`, `level` theo `docs/business/Rubric_Cham_Diem.md`
- soạn `answer_hint` (mọi loại) và `reference_answer` (chỉ `TECHNICAL`, 3-6 ý chính)

```bash
python scripts/dataset/normalize_questions.py --dry-run --limit 5   # xem prompt, không gọi API
python scripts/dataset/normalize_questions.py --limit 20            # chạy thử
python scripts/dataset/normalize_questions.py                       # chạy hết (~80 lô)
```

- Cần `GEMINI_API_KEY` (biến môi trường hoặc `.env`). Model mặc định `gemini-3.7-flash`, đổi bằng `--model` hoặc `GEMINI_MODEL`.
- Ghi nối tiếp vào `data/interim/questions_vi.jsonl` và bỏ qua id đã xử lý, nên chạy lại được khi bị ngắt hoặc hết quota.
- Kết quả từng câu được kiểm tra (enum, trường bắt buộc, câu hỏi không chứa ký hiệu markdown/code vì được đọc bằng TTS, `reference_answer` của TECHNICAL gồm 3-6 dòng bắt đầu bằng `- `); câu lỗi được gọi lại riêng 1 lần, vẫn lỗi thì ghi vào `questions_vi.errors.jsonl`.
- Mọi câu có `review_status: "PENDING"`, **phải có người duyệt** trước khi seed vào bảng `questions`. `industry`/`position` theo `docs/business/Danh_Muc_Nganh_Vi_Tri.md`; câu không phải `TECHNICAL` gán vị trí `Chung`.
- Khi Gemini hết quota, có thể chuẩn hoá thủ công theo đúng quy tắc trong `SYSTEM_PROMPT`; bản ghi vẫn qua `validate()`/`to_output_record()` và ghi rõ người làm trong `generated_by.model`. Hiện tại cả 1151 câu được chuẩn hoá thủ công (`claude-opus-5-5 (thủ công)`), câu trùng ý giữa các nguồn đã loại với `drop_reason: LOW_QUALITY`.

## `review_questions.py`

Duyệt câu hỏi bằng bảng tính thay vì sửa JSONL:

```bash
python scripts/dataset/review_questions.py export   # ghi data/interim/review.csv (gitignore)
# mở bằng Excel/Google Sheets, điền review_status = APPROVED / REJECTED, có thể sửa nội dung
python scripts/dataset/review_questions.py import   # kiểm tra rồi ghi ngược vào questions_vi.jsonl
```

Import kiểm tra lại toàn bộ luật (enum, vị trí theo `Danh_Muc_Nganh_Vi_Tri.md`, định dạng câu hỏi và đáp án); có dòng sai thì báo và không ghi gì. Câu bị sửa nội dung được đánh dấu `generated_by.edited_by_reviewer`.

## `build_seed_sql.py`

Sinh `backend/src/main/resources/db/migration/V2__seed_questions.sql` từ `questions_vi.jsonl` (lấy câu `keep=true` đã `APPROVED`, bỏ trùng `(position, content)`):

```bash
python scripts/dataset/build_seed_sql.py                  # bản chính thức: chỉ câu đã duyệt
python scripts/dataset/build_seed_sql.py --allow-pending  # gồm cả câu chưa duyệt, để chạy thử local
```

V2 hiện tại được sinh bằng `--allow-pending` (chưa ai duyệt); trước khi deploy phải duyệt xong rồi sinh lại không có cờ này.
