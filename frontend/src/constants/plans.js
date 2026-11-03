// Gói dịch vụ và mục tiêu luyện tập theo Figma (Bảng giá, Thanh toán, Tổng quan).
// Contract API chưa có thanh toán / hạn mức nên các giá trị này chỉ dùng để hiển thị.
export const FREE_MONTHLY_SESSIONS = 3
export const WEEKLY_GOAL = 10

export const PRO_PRICES = {
  monthly: { perMonth: 149000, total: 149000, months: 1 },
  yearly: { perMonth: 119000, total: 1428000, months: 12, discount: 20 },
}

export function formatVnd(value) {
  return `${value.toLocaleString('vi-VN')}đ`
}
