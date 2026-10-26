import { request } from './client'

function toQuery(params) {
  const search = new URLSearchParams()
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== '') search.set(key, value)
  }
  return search.toString()
}

// Lịch sử các phiên đã chấm (SCORED) của chính người dùng, mới nhất trước (UC7)
// filters: { from, to (yyyy-mm-dd), industry, minScore, maxScore, page, size }
export function listHistory({ page = 0, size = 20, ...filters } = {}) {
  return request(`/history?${toQuery({ ...filters, page, size })}`)
}

// Phiên kèm scoreResult đầy đủ (tiêu chí, Delivery)
export function getHistoryDetail(id) {
  return request(`/history/${encodeURIComponent(id)}`)
}
