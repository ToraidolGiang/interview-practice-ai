# Giai đoạn B: Dữ liệu câu hỏi (thu thập, chuẩn hóa, duyệt, seed)

Thời gian: 22 - 26/10/2026. Người làm chính: Tuấn Anh (PR #7, `feature/dataset-questions`). Giang chốt danh mục ngành/vị trí và đặc tả bảng `questions`.

## 1. Hiểu nhanh trong 1 phút
- **Một câu:** biến các kho câu hỏi phỏng vấn công khai (tiếng Anh) thành ngân hàng câu hỏi tiếng Việt có cấu trúc, có đáp án tham chiếu cho câu kỹ thuật, rồi nạp vào DB bằng migration `V2__seed_questions.sql`.
- **Hình ảnh đời thường:** thu mua sách từ nhiều nhà, dịch, loại sách trùng/không hợp, đóng dấu loại, rồi xếp lên kệ.
- **Ba ý chính:**
  1. Chỉ lấy nguồn có license mở; loại nguồn copyleft hoặc không license.
  2. Pipeline có kiểm tra tự động từng bước và **bước người duyệt**.
  3. Kết quả cuối: 815 câu `ACTIVE` trong DB, hiện chỉ ngành IT.

## 2. Từ điển nhanh
| Từ | Nghĩa |
|---|---|
| JSONL | Mỗi dòng một đối tượng JSON; dễ ghi nối tiếp, chạy lại khi bị ngắt |
| Taxonomy | Danh mục chuẩn ngành và vị trí (`taxonomy-v1.0`); giá trị lưu đúng nguyên văn, không nhập tự do |
| `question_type` | `BEHAVIORAL` (hành vi), `SITUATIONAL` (tình huống), `TECHNICAL` (kỹ thuật), `INTRO` (giới thiệu) |
| `reference_answer` | Các ý chính của đáp án đúng, chỉ có ở câu `TECHNICAL`; sau này dùng để đối chiếu theo ý |
| `answer_hint` | Gợi ý cách trả lời hiển thị cho người luyện, áp dụng mọi loại |
| `drop_reason` | Lý do loại câu: `CODING_TASK`, `COMMAND_SPECIFIC`, `COMPANY_SPECIFIC`, `NOT_INTERVIEW`, `OUTDATED`, `LOW_QUALITY` |
| `review_status` | `PENDING`, `APPROVED`, `REJECTED`; câu phải `APPROVED` mới được seed bản chính thức |
| Vị trí `Chung` | Vị trí cho câu không gắn với một nghề cụ thể (hành vi, tình huống, giới thiệu); API lọc theo vị trí vẫn trả cả câu `Chung` |

## 3. Thân bài theo bước

### Bước 1. Thu thập (`collect_github_questions.py`)
- **Vì sao cần:** tự viết hàng nghìn câu là không thực tế; dùng nguồn mở có kiểm soát giấy phép.
- **Cách làm:** tải từ 7 nguồn (MIT hoặc CC-BY-4.0) theo **commit SHA cố định**, nên chạy lại cho kết quả giống nhau (tái lập). Cache ở `data/raw/` (gitignore). Mỗi dòng lưu `source` (repo, đường dẫn, commit, URL, license) để ghi công nguồn.
- **Nguồn:** tech-interview-handbook, h5bp-frontend, react-interview-questions, data-science-interviews, sysadmin-skills, java-backend-qa, backend-node-go. Đã **loại** repo copyleft (GPL, CC-BY-SA) và repo không có license.
- **Ví dụ số nhỏ:** lần đầu có 1783 câu thô trong `github_questions.jsonl`.

### Bước 2. Chuẩn hóa sang tiếng Việt (`normalize_questions.py`)
- **Vì sao cần:** câu gốc tiếng Anh, lẫn bài tập viết code, câu theo công ty cụ thể, câu lỗi thời.
- **Ý chính:** với mỗi câu, hoặc loại (kèm `drop_reason`) hoặc viết lại tiếng Việt tự nhiên, khái quát tên công ty, gán `question_type`, `level`, soạn `answer_hint`; câu `TECHNICAL` có `reference_answer` 3-6 ý, mỗi ý một dòng bắt đầu bằng `- `.
- **Kiểm tra tự động:** enum hợp lệ, đủ trường bắt buộc, câu hỏi không chứa ký hiệu markdown/code (vì sẽ được đọc bằng TTS), định dạng đáp án; câu lỗi gọi lại 1 lần rồi ghi vào file lỗi riêng.
- **Chạy lại được:** ghi nối tiếp, bỏ qua id đã xử lý, nên bị ngắt hoặc hết quota thì chạy tiếp.
- **Điều phải nói thẳng:** khi Gemini hết quota, cả 1783 câu được chuẩn hóa **thủ công theo đúng quy tắc của prompt** (ghi trong `generated_by.model`); câu trùng ý giữa nguồn bị loại bằng `LOW_QUALITY`. Một vòng chạy thử 80 câu dẫn tới prompt v2.

### Bước 3. Người duyệt (`review_questions.py`)
- **Vì sao cần:** đây là cổng chất lượng; AI viết lại có thể sai ý.
- **Cách làm:** xuất `review.csv` (gitignore), người duyệt mở bằng Excel/Sheets, điền `APPROVED/REJECTED`, có thể sửa nội dung; lệnh `import` kiểm lại toàn bộ luật và **không ghi gì nếu có dòng sai**.
- **Thực tế hiện tại:** **chưa ai duyệt** (xem bước 4).

### Bước 4. Sinh migration seed (`build_seed_sql.py`)
- **Cách làm:** lấy câu `keep=true` đã duyệt, bỏ trùng `(position, content)`, sinh `V2__seed_questions.sql`.
- **Hiện trạng thật:** V2 hiện tại sinh bằng `--allow-pending`, tức gồm cả câu **chưa duyệt**. Đây là việc phải làm **trước khi deploy**: duyệt xong rồi sinh lại không có cờ này. Trong DB local: 815 câu, tất cả `ACTIVE`.
- **Phân bố hiện có:** ngành `IT`; vị trí Backend Developer 228, Frontend Developer 235, Data Scientist / AI 148, DevOps / Quản trị hệ thống 147, và `Chung` 57 (25 hành vi, 26 giới thiệu, 6 tình huống). Phần lớn là `TECHNICAL`. Phần câu hành vi và giới thiệu còn ít.

### Bước 5. Chốt taxonomy (`taxonomy-v1.0`)
`docs/business/Danh_Muc_Nganh_Vi_Tri.md` liệt kê 6 ngành (IT, Marketing, Kinh doanh / Bán hàng, Kế toán / Tài chính, Nhân sự, Chăm sóc khách hàng) làm đích dài hạn. Dữ liệu seed hiện **chỉ có IT**. `level` (EASY/MEDIUM/HARD) là cột riêng, **không** dùng Fresher/Junior/Senior làm vị trí.

## 4. Luồng nên nói được
`GitHub (7 nguồn, license mở) → collect (SHA cố định) → github_questions.jsonl → normalize (loại/dịch/gán nhãn) → questions_vi.jsonl (PENDING) → review CSV (người duyệt) → build_seed_sql → V2__seed_questions.sql → Flyway nạp vào bảng questions`.

## 5. Khung giảng lại
**Nói (45 giây):** "Mình dựng ngân hàng câu hỏi từ nguồn GitHub license mở. Pipeline: thu thập theo commit cố định, chuẩn hóa sang tiếng Việt và gán loại/mức, có đáp án tham chiếu cho câu kỹ thuật, rồi qua bước duyệt trước khi seed bằng Flyway."

| Câu hỏi có thể bị hỏi | Gợi ý trả lời |
|---|---|
| Vì sao chỉ lấy MIT/CC-BY? | Tuân thủ giấy phép; copyleft (GPL, CC-BY-SA) bắt dữ liệu phái sinh theo cùng giấy phép nên loại |
| Làm sao tái lập? | Tải theo commit SHA cố định, chuẩn hóa ghi nối tiếp có bỏ qua id đã xử lý |
| Chất lượng đáp án tham chiếu ra sao? | Do AI soạn từ đáp án gốc, **chưa ai duyệt hết**; đây là rủi ro chấm điểm chuyên môn (xem giai đoạn F) |
| Vì sao có vị trí `Chung`? | Câu hành vi/giới thiệu không thuộc nghề cụ thể; API lọc theo vị trí vẫn trả `Chung` |
| Hạn chế nên nói thẳng | Chỉ ngành IT; seed chưa duyệt; ít câu hành vi/tình huống |

## 6. Câu hỏi ôn
1. Vì sao câu hỏi dùng cho TTS không được chứa ký hiệu markdown hoặc code?
2. Bạn chạy `normalize_questions.py` hai lần với cùng nguồn. Kết quả có bị nhân đôi không? Vì sao?
3. Người dùng lọc vị trí "Backend Developer" nhưng không thấy câu "Kể về lần bạn xử lý xung đột". Có thể do đâu?
4. Nếu đổi nội dung một câu đã seed, sửa `V2__seed_questions.sql` có đúng không?
5. Vì sao câu bị sửa nội dung trong lúc duyệt được đánh dấu `edited_by_reviewer`?

## 7. Đáp án
1. TTS đọc to văn bản; ký hiệu `` ` `` hay `**` sẽ được đọc ra hoặc làm lệch ngữ điệu.
2. Không: script bỏ qua các id đã có trong `questions_vi.jsonl`; id là hash ổn định từ nguồn và nội dung.
3. Câu đó có vị trí `Chung`; nếu API/giao diện không gộp `Chung` khi lọc theo vị trí thì sẽ ẩn. Quy tắc đúng: lọc vị trí vẫn trả cả `Chung`.
4. Không: migration đã chạy không được sửa (Flyway kiểm checksum). Dùng `PUT /admin/questions/{id}` hoặc thêm migration mới.
5. Để biết nội dung không còn là bản AI sinh nguyên văn, phục vụ truy vết chất lượng và trách nhiệm duyệt.
