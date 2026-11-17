// Tuỳ chọn cá nhân lưu trên trình duyệt (contract API chưa có endpoint hồ sơ/cài đặt).
// Khoá theo id người dùng để nhiều tài khoản trên cùng máy không lẫn nhau.
const PREFIX = 'interviewai.prefs.'

export function loadPrefs(userId) {
  try {
    return JSON.parse(localStorage.getItem(PREFIX + (userId ?? 'guest'))) ?? {}
  } catch {
    return {}
  }
}

export function savePrefs(userId, changes) {
  const next = { ...loadPrefs(userId), ...changes }
  try {
    localStorage.setItem(PREFIX + (userId ?? 'guest'), JSON.stringify(next))
  } catch {
    // Trình duyệt chặn storage: tuỳ chọn chỉ còn trong phiên này
  }
  return next
}
