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
