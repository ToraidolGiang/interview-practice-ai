# ADR-001: Chấm điểm bất đồng bộ trong tiến trình với Gemini qua RestClient
Trạng thái: Accepted
Ngày: 2026-11-04

## Bối cảnh
STT + LLM mất vài giây; OA yêu cầu 202 + polling; NF1 12s; chưa có hạ tầng hàng đợi.

## Quyết định
`ThreadPoolTaskExecutor` có queue giới hạn trong tiến trình; trạng thái DB là nguồn sự thật, chuyển bằng `UPDATE` có điều kiện; Gemini gọi qua `RestClient` (Jackson 3, REST `generateContent`); AWS SDK v2 S3 quản lý bằng BOM (2.57.8, property `awssdk.version`); server tính điểm, LLM chỉ chấm tiêu chí.

## Các phương án đã cân nhắc
- SQS/Rabbit: bền, scale, nhưng thêm hạ tầng ngoài phạm vi.
- `@Scheduled` poll bảng: sống sót restart nhưng trễ, vi phạm NF1.
- SDK Google GenAI: tiện nhưng thêm dependency, khó đặt timeout đúng AC-9.

## Hệ quả
- Tích cực: đơn giản, ít hạ tầng; đủ cho quy mô đồ án.
- Tiêu cực: mất job khi restart (bù bằng `SERVER_RESTART`); không scale ngang; chưa có rate limit theo user (xem tech-debt.md).
- Việc phải làm: nếu scale ngang, chỉ thay `EvaluationService.submit` bằng hàng đợi ngoài.

Cập nhật lần cuối: 2026-11-04
