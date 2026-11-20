import { request } from './client'

function toQuery(params) {
  const search = new URLSearchParams()
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== '') search.set(key, value)
  }
  const query = search.toString()
  return query ? `?${query}` : ''
}

// params: { status (ACTIVE|HIDDEN), keyword, page, size }
export function listAdminQuestions(params) {
  return request(`/admin/questions${toQuery(params)}`)
}

// body: { content, industry, position, level, questionType, answerHint?, referenceAnswer? }
export function createAdminQuestion(body) {
  return request('/admin/questions', { method: 'POST', body })
}

// PUT không có status: đổi trạng thái không thuộc phạm vi màn này
export function updateAdminQuestion(id, body) {
  return request(`/admin/questions/${encodeURIComponent(id)}`, { method: 'PUT', body })
}

// 204; backend tự quyết xoá mềm (đã có người luyện) hay xoá cứng
export function deleteAdminQuestion(id) {
  return request(`/admin/questions/${encodeURIComponent(id)}`, { method: 'DELETE' })
}
