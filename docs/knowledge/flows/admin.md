# Luồng: Quản trị (ADMIN)

## Mục đích & tác nhân
ADMIN quản lý ngân hàng câu hỏi và xem thống kê. CANDIDATE gõ `/admin/*` bị chuyển về `/dashboard` (`RequireAdmin`, `frontend/src/auth/RequireAuth.jsx:12`).

## Điểm vào
- `/admin/questions` -> `pages/AdminQuestionsPage.jsx`, API `api/adminQuestions.js` (`/admin/questions`: status, keyword, page, size; POST/PUT body `QuestionUpsertRequest`).
- `/admin/analytics` -> `pages/AdminAnalyticsPage.jsx`, API `api/adminAnalytics.js` (overview + xuất CSV qua `downloadBlob`, `format=csv`, from/to).

## Quy tắc & ràng buộc
- Danh sách 10 dòng/trang, lọc trạng thái (ACTIVE "Đang hiển thị" / HIDDEN "Đã ẩn") + từ khoá.
- Xoá là xoá mềm: `ConfirmDialog` cảnh báo; sau xoá tải lại, câu chuyển HIDDEN. Xoá hết dòng cuối trang thì lùi 1 trang.
- Chỉ gửi `referenceAnswer` khi loại câu hỏi là TECHNICAL (`AdminQuestionsPage.jsx:~349`). Đã đối chiếu backend: `AdminQuestionService.java:123` gán `referenceAnswer = blankToNull(request.referenceAnswer())`, tức PUT thay thế toàn bộ, nên khi đổi sang loại khác (frontend không gửi trường này) đáp án tham chiếu cũ bị xoá. Đây là hành vi mong muốn, không phải lỗi.
- Thống kê: chặn gọi/xuất khi `from > to`; `averageScore` null hiện "Chưa có"; `estimatedCost` kèm nhãn "ước tính" vì openapi không nêu đơn vị tiền.

## Lỗi & trường hợp biên
- 400 `fieldErrors` -> dưới từng ô; 409 `DUPLICATE_QUESTION` -> thông báo tiếng Việt, form giữ nguyên; 404 (câu đã mất) -> làm mới danh sách; 403 -> "không có quyền", không đăng xuất.
- Chưa có: bật lại câu HIDDEN, chi tiết theo user, audit log (backend chưa có API) — xem [tech-debt.md](../tech-debt.md).

## Test hiện có
Không có test tự động frontend. Kiểm tĩnh + thủ công Prism: `specs/20261120-frontend-noi-api-moi/test-report.md` (còn chưa kiểm: sửa/xoá thật, tải CSV thật, giao diện 1280px).

Cập nhật lần cuối: 2026-11-20
