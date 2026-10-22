import { request } from './client'

// Lịch sử các phiên đã chấm (SCORED) của chính người dùng, mới nhất trước (UC7)
export function listHistory({ page = 0, size = 20 } = {}) {
  return request(`/history?page=${page}&size=${size}`)
}
