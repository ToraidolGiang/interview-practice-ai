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

// Header dùng chung cho request() và downloadBlob(): Accept + Bearer (nếu có token)
function buildHeaders({ auth = true, accept = 'application/json', contentType } = {}) {
  const headers = { Accept: accept }
  if (contentType) headers['Content-Type'] = contentType
  const token = auth ? getAccessToken() : null
  if (token) headers.Authorization = `Bearer ${token}`
  return { headers, token }
}

export async function request(path, { method = 'GET', body, auth = true } = {}) {
  // FormData (upload file) để trình duyệt tự đặt Content-Type kèm boundary
  const isForm = body instanceof FormData
  const { headers, token } = buildHeaders({
    auth,
    contentType: body !== undefined && !isForm ? 'application/json' : undefined,
  })

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

// Tải file (vd CSV) có kèm JWT: thẻ <a href> trần không gửi được Authorization.
// Lỗi (JSON) -> ApiError như request(); thành công -> kích hoạt tải về, trả tên file đã dùng.
export async function downloadBlob(path, { params, filename = 'download' } = {}) {
  const query = params ? new URLSearchParams(params).toString() : ''
  const url = BASE_URL + path + (query ? `?${query}` : '')
  const { headers, token } = buildHeaders({ accept: '*/*' })

  let response
  try {
    response = await fetch(url, { headers })
  } catch {
    throw new ApiError(0, { code: 'NETWORK_ERROR', message: 'Không kết nối được máy chủ' })
  }

  if (!response.ok) {
    const text = await response.text()
    const data = text ? safeParse(text) : null
    if (response.status === 401 && token) window.dispatchEvent(new Event(UNAUTHORIZED_EVENT))
    throw new ApiError(response.status, data)
  }

  const blob = await response.blob()
  const name = sanitizeFilename(filenameFromDisposition(response.headers.get('Content-Disposition'))) || filename
  const objectUrl = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = objectUrl
  link.download = name
  document.body.appendChild(link)
  link.click()
  link.remove()
  // Hoãn thu hồi: một số trình duyệt bắt đầu tải bất đồng bộ sau click()
  setTimeout(() => URL.revokeObjectURL(objectUrl), 4000)
  return name
}

// Tên file từ header là dữ liệu ngoài: bỏ phân tách đường dẫn, ký tự điều khiển, '..', cắt độ dài
function sanitizeFilename(raw) {
  if (!raw) return null
  const cleaned = raw
    // eslint-disable-next-line no-control-regex
    .replace(/[\u0000-\u001f\u007f/\\]/g, '')
    .replace(/\.{2,}/g, '.')
    .trim()
    .slice(0, 150)
  return cleaned && cleaned !== '.' ? cleaned : null
}

function filenameFromDisposition(header) {
  if (!header) return null
  const star = /filename\*\s*=\s*(?:UTF-8'')?([^;]+)/i.exec(header)
  if (star) {
    try {
      return decodeURIComponent(star[1].trim().replace(/^"|"$/g, ''))
    } catch {
      // rơi xuống dạng filename thường
    }
  }
  const plain = /filename\s*=\s*"?([^";]+)"?/i.exec(header)
  return plain ? plain[1].trim() : null
}

function safeParse(text) {
  try {
    return JSON.parse(text)
  } catch {
    return null
  }
}
