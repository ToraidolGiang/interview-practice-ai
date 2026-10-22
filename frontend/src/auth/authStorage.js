// Phiên đăng nhập giữ trong bộ nhớ + storage. "Ghi nhớ đăng nhập" lưu vào localStorage,
// ngược lại chỉ giữ trong sessionStorage của tab.
const KEY = 'talentstar.auth'

let current = null

function read(storage) {
  try {
    const raw = storage.getItem(KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

function isValid(session) {
  return !!session && session.expiresAt > Date.now()
}

export function loadSession() {
  const session = read(localStorage) || read(sessionStorage)
  if (!isValid(session)) {
    clearSession()
    return null
  }
  current = session
  return session
}

export function saveSession(session, remember) {
  clearSession()
  current = session
  try {
    ;(remember ? localStorage : sessionStorage).setItem(KEY, JSON.stringify(session))
  } catch {
    // Trình duyệt chặn storage: phiên vẫn dùng được trong bộ nhớ đến khi tải lại trang
  }
}

export function clearSession() {
  current = null
  try {
    localStorage.removeItem(KEY)
    sessionStorage.removeItem(KEY)
  } catch {
    // bỏ qua
  }
}

export function getAccessToken() {
  return isValid(current) ? current.accessToken : null
}
