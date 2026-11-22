# Báo cáo giai đoạn B: Dữ liệu câu hỏi

- **Thời gian:** 22 - 26/10/2026. **Người làm chính:** Tuấn Anh (PR #7, `feature/dataset-questions`).
- **Lý thuyết:** [02_Giai_Doan_B](../hoc-bu/02_Giai_Doan_B_Du_Lieu_Cau_Hoi.md). **Trạng thái:** Xong, **nhưng seed chưa được duyệt**.

## 1. Mục tiêu
Có ngân hàng câu hỏi tiếng Việt có cấu trúc (ngành, vị trí, loại, mức, gợi ý, đáp án tham chiếu cho câu kỹ thuật) nạp vào DB bằng migration.

## 2. Chức năng và sản phẩm
| Hạng mục | Nội dung | Mốc | Trạng thái |
|---|---|---|---|
| Thu thập (`collect_github_questions.py`) | 7 nguồn license mở (MIT, CC-BY-4.0), tải theo commit SHA cố định; loại nguồn copyleft và không license | 22/10 | Xong |
| Taxonomy `taxonomy-v1.0` | 6 ngành, vị trí theo ngành, `Chung` cho câu không gắn nghề | 22/10 | Xong (dữ liệu chỉ có IT) |
| Chuẩn hóa (`normalize_questions.py`) | Loại câu không hợp, viết lại tiếng Việt, gán loại/mức, soạn gợi ý và đáp án; prompt v2 sau vòng thử 80 câu | 22-26/10 | Xong |
| Duyệt (`review_questions.py`) | Xuất/nhập CSV, kiểm lại toàn bộ luật | 26/10 | **Công cụ xong, chưa ai duyệt** |
| Seed (`build_seed_sql.py`) | Sinh `V2__seed_questions.sql` | 26/10 | Xong, sinh bằng `--allow-pending` |

## 3. Kết quả và số liệu
- 1.783 câu thô thu thập và chuẩn hóa; **815 câu `ACTIVE` trong DB** sau khi loại câu không hợp và trùng.
- Phân bố theo vị trí: Backend Developer 228, Frontend Developer 235, Data Scientist / AI 148, DevOps / Quản trị hệ thống 147, `Chung` 57 (25 hành vi, 26 giới thiệu, 6 tình huống). Phần lớn là câu kỹ thuật.
- Chỉ ngành **IT**.

## 4. Quyết định chính
1. Chỉ dùng nguồn license mở; ghi `source` (repo, commit, license) cho từng câu để ghi công.
2. Kiểm tự động từng bước và **bắt buộc có người duyệt** trước seed bản chính thức.
3. Câu hỏi không chứa ký hiệu markdown/code vì sẽ được đọc bằng TTS.
4. Vị trí `Chung` cho câu hành vi, tình huống, giới thiệu.

## 5. Khó khăn và xử lý
- Gemini hết quota khi chuẩn hóa: chuẩn hóa thủ công theo đúng quy tắc của prompt, ghi rõ trong `generated_by.model`; câu trùng ý giữa các nguồn loại bằng `LOW_QUALITY`.
- Ít câu hành vi và tình huống so với câu kỹ thuật.

## 6. Còn lại
1. **Duyệt toàn bộ câu hỏi và đáp án tham chiếu** rồi sinh lại V2 không có cờ `--allow-pending` trước khi deploy. Đáp án do AI soạn là rủi ro cho điểm CORRECTNESS.
2. Bổ sung câu hành vi/tình huống và các ngành khác trong taxonomy.
