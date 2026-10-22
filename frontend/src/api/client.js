// Gọi API theo contract docs/api/openapi.yaml (base path /api), tự gắn JWT nếu đã đăng nhập.
import { getAccessToken } from '../auth/authStorage'

const BASE_URL = '/api'
export const UNAUTHORIZED_EVENT = 'talentstar:unauthorized'

export class ApiError extends Error {
  constructor(status, body) {
    super(body?.message || `Lỗi máy chủ (${status})`)
    this.status = status
    this.code = body?.code
    this.fieldErrors = body?.fieldErrors || []
  }
}

export async function request(path, { method = 'GET', body, auth = true } = {}) {
  const headers = { Accept: 'application/json' }
  // FormData (upload file) để trình duyệt tự đặt Content-Type kèm boundary
  const isForm = body instanceof FormData
  if (body !== undefined && !isForm) headers['Content-Type'] = 'application/json'

  const token = auth ? getAccessToken() : null
  if (token) headers.Authorization = `Bearer ${token}`

  let response
  try {
    response = await fetch(BASE_URL + path, {
      method,
      headers,
      body: body === undefined || isForm ? body : JSON.stringify(body),
    })
  } catch {
    throw new ApiError(0, { code: 'NETWORK_ERROR', message: 'Không kết nối được máy chủ' })
  }

  const text = await response.text()
  const data = text ? safeParse(text) : null

  if (!response.ok) {
    // 502-504: Vite proxy không gọi được backend/mock (chưa chạy `npm run mock` hoặc backend tắt)
    if (response.status >= 502 && response.status <= 504 && !data) {
      throw new ApiError(response.status, {
        code: 'NETWORK_ERROR',
        message: 'Không kết nối được máy chủ API. Kiểm tra backend hoặc mock (npm run mock) đã chạy chưa.',
      })
    }
    // JWT hết hạn hoặc bị thu hồi: AuthProvider nghe sự kiện này để đăng xuất
    if (response.status === 401 && token) window.dispatchEvent(new Event(UNAUTHORIZED_EVENT))
    throw new ApiError(response.status, data)
  }
  return data
}

function safeParse(text) {
  try {
    return JSON.parse(text)
  } catch {
    return null
  }
}
