# Danh mục ngành nghề và vị trí ứng tuyển

- Phiên bản: `taxonomy-v1.0`
- Áp dụng cho cột `questions.industry` và `questions.position` (bộ lọc UC3, lịch sử UC7, form thêm/sửa câu hỏi UC8, dữ liệu seed).
- Giá trị lưu trong CSDL **đúng nguyên văn** cột "Giá trị" bên dưới (phân biệt hoa/thường, có dấu). Frontend lấy danh sách từ đây, không cho nhập tự do.
- `level` (EASY/MEDIUM/HARD) là cột riêng. Không dùng Fresher/Junior/Senior làm vị trí.

## 1. Ngành nghề (`industry`)

| Giá trị | Ghi chú | Giai đoạn |
|---|---|---|
| `IT` | Công nghệ thông tin | MVP |
| `Marketing` | | MVP |
| `Kinh doanh / Bán hàng` | | MVP |
| `Kế toán / Tài chính` | | MVP |
| `Nhân sự` | | MVP |
| `Chăm sóc khách hàng` | | MVP |

## 2. Vị trí (`position`) theo ngành

Vị trí ngành IT giữ tên tiếng Anh vì thị trường tuyển dụng IT Việt Nam dùng tên này.

| Ngành | Vị trí |
|---|---|
| `IT` | `Chung`, `Backend Developer`, `Frontend Developer`, `Fullstack Developer`, `Mobile Developer`, `Tester / QA`, `DevOps / Quản trị hệ thống`, `Data Analyst`, `Data Scientist / AI`, `Business Analyst` |
| `Marketing` | `Chung`, `Digital Marketing`, `Content Marketing`, `Chuyên viên SEO` |
| `Kinh doanh / Bán hàng` | `Chung`, `Nhân viên kinh doanh`, `Nhân viên bán hàng` |
| `Kế toán / Tài chính` | `Chung`, `Kế toán viên`, `Chuyên viên phân tích tài chính` |
| `Nhân sự` | `Chung`, `Chuyên viên tuyển dụng`, `Chuyên viên C&B` |
| `Chăm sóc khách hàng` | `Chung`, `Nhân viên CSKH` |

### Vị trí `Chung`

Dùng cho câu hỏi hành vi, tình huống, giới thiệu bản thân áp dụng cho mọi vị trí trong ngành (ví dụ "Kể về lần bạn xử lý xung đột trong nhóm"), để không phải nhân bản cùng một câu cho từng vị trí.

**Ảnh hưởng tới backend:** khi người dùng lọc theo một vị trí cụ thể, `GET /questions` và `GET /questions/random` trả cả câu của vị trí đó **và** câu `Chung` cùng ngành:

```sql
WHERE status = 'ACTIVE' AND industry = :industry AND position IN (:position, 'Chung')
```

## 3. Ánh xạ nguồn dữ liệu GitHub

| Nguồn (`source.key`) | `position` gốc | `industry` | `position` |
|---|---|---|---|
| `tech-interview-handbook` | Software Engineer | `IT` | `Chung` |
| `h5bp-frontend` | Frontend Developer | `IT` | `Frontend Developer` |
| `react-interview-questions` | Frontend Developer | `IT` | `Frontend Developer` |
| `data-science-interviews` | Data Scientist | `IT` | `Data Scientist / AI` |
| `sysadmin-skills` | System Administrator / DevOps | `IT` | `DevOps / Quản trị hệ thống` |

Riêng câu hỏi không phải `TECHNICAL` (hành vi, tình huống, giới thiệu) từ mọi nguồn IT đều chuyển sang `Chung`.

## 4. Thay đổi danh mục

Thêm/đổi giá trị thì tăng phiên bản, cập nhật `scripts/dataset/normalize_questions.py` (`INDUSTRY_VI`, `POSITION_VI`) và viết migration đổi dữ liệu cũ nếu đổi tên.
