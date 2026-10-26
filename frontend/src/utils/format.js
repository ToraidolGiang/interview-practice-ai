// Số đếm hiển thị theo Figma (dấu phẩy ngăn cách hàng nghìn: 20,412)
export function formatCount(value) {
  return Number(value ?? 0).toLocaleString('en-US')
}
