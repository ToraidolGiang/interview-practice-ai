# Giả định

## Câu thông báo
mã | câu | chỗ sửa
PROCESSING_TIMEOUT | Việc chấm điểm mất quá nhiều thời gian nên đã bị dừng. Bạn có thể gửi chấm lại. | frontend/src/constants/scoring.js (FAILED_MESSAGES) · cần PO xác nhận
INTERNAL_ERROR | Hệ thống gặp sự cố khi chấm điểm. Bạn có thể gửi chấm lại sau ít phút. | frontend/src/constants/scoring.js (FAILED_MESSAGES) · cần PO xác nhận
(mã lạ) | Phiên chấm điểm không thành công. Bạn có thể thử gửi chấm lại. | frontend/src/constants/scoring.js (FAILED_MESSAGE_FALLBACK) · cần PO xác nhận
TOO_MANY_PROCESSING | Đang có quá nhiều phiên đang chấm. Hãy chờ phiên hiện tại hoàn tất rồi thử lại. | frontend/src/constants/scoring.js (HTTP_ERROR_MESSAGES) · theo AC-3
DAILY_LIMIT_EXCEEDED | Bạn đã hết lượt chấm điểm trong ngày (tính theo giờ Việt Nam). Hãy thử lại vào ngày mai. | frontend/src/constants/scoring.js (HTTP_ERROR_MESSAGES) · không nêu con số (G2)
FORBIDDEN (403) | Bạn không có quyền thực hiện thao tác này. | frontend/src/constants/scoring.js (HTTP_ERROR_MESSAGES) · theo AC-6
TOO_MANY_REQUESTS (429 không code) | Bạn thao tác quá nhanh hoặc hệ thống đang bận. Vui lòng thử lại sau ít phút. | frontend/src/constants/scoring.js (HTTP_ERROR_MESSAGES) · cần PO xác nhận
Menu admin | "Quản trị câu hỏi", "Thống kê quản trị" | frontend/src/layouts/AppLayout.jsx · cần PO xác nhận
