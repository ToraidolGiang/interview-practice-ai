import { request } from './client'

export function createPracticeSession(questionId) {
  return request('/practice-sessions', { method: 'POST', body: { questionId } })
}

export function getPracticeSession(id) {
  return request(`/practice-sessions/${encodeURIComponent(id)}`)
}
