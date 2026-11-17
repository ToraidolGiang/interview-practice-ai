// Kiểm tra phía client theo RegisterRequest/LoginRequest trong openapi.yaml; backend vẫn kiểm tra lại.
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
export const PASSWORD_MIN_LENGTH = 8

export function isValidEmail(value) {
  return EMAIL_PATTERN.test(value.trim())
}

export function validateLogin({ email, password }) {
  const errors = {}
  if (!email.trim()) errors.email = 'Vui lòng nhập email'
  else if (!isValidEmail(email)) errors.email = 'Email không hợp lệ'
  if (!password) errors.password = 'Vui lòng nhập mật khẩu'
  return errors
}

export function validateRegister({ fullName, email, password, confirmPassword, agreed }) {
  const errors = {}
  if (!fullName.trim()) errors.fullName = 'Vui lòng nhập họ và tên'
  if (!email.trim()) errors.email = 'Vui lòng nhập email'
  else if (!isValidEmail(email)) errors.email = 'Email không hợp lệ'
  if (!password) errors.password = 'Vui lòng nhập mật khẩu'
  else if (password.length < PASSWORD_MIN_LENGTH) errors.password = `Mật khẩu tối thiểu ${PASSWORD_MIN_LENGTH} ký tự`
  if (!confirmPassword) errors.confirmPassword = 'Vui lòng nhập lại mật khẩu'
  else if (confirmPassword !== password) errors.confirmPassword = 'Mật khẩu xác nhận không khớp'
  if (!agreed) errors.agreed = 'Bạn cần đồng ý với điều khoản để tiếp tục'
  return errors
}

// Các yêu cầu hiển thị dưới ô mật khẩu mới (màn Đặt mật khẩu mới)
export function passwordChecks(password) {
  return [
    { label: `Tối thiểu ${PASSWORD_MIN_LENGTH} ký tự`, ok: password.length >= PASSWORD_MIN_LENGTH },
    { label: 'Có chữ hoa và chữ số', ok: /[A-Z]/.test(password) && /\d/.test(password) },
    { label: 'Có ký tự đặc biệt (!@#$...)', ok: /[^A-Za-z0-9]/.test(password) },
  ]
}

export function passwordStrength(password) {
  if (!password) return { level: 0, label: 'Chưa nhập' }
  const passed = passwordChecks(password).filter((c) => c.ok).length
  const level = Math.min(4, passed + (password.length >= 12 ? 1 : 0))
  return { level, label: ['Yếu', 'Yếu', 'Trung bình', 'Khá', 'Mạnh'][level] }
}

// Gom fieldErrors trong ErrorResponse thành { field: message }
export function toFieldErrors(apiError) {
  return Object.fromEntries((apiError.fieldErrors || []).map((e) => [e.field, e.message]))
}
