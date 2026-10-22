import { request } from './client'

export function createPracticeSession(questionId) {
  return request('/practice-sessions', { method: 'POST', body: { questionId } })
}

export function getPracticeSession(id) {
  return request(`/practice-sessions/${encodeURIComponent(id)}`)
}

export function uploadAnswer(id, audioBlob, durationSeconds) {
  const form = new FormData()
  const extension = audioBlob.type.includes('mp4') ? 'm4a' : audioBlob.type.includes('ogg') ? 'ogg' : 'webm'
  form.append('audio', audioBlob, `answer.${extension}`)
  form.append('durationSeconds', String(Math.round(durationSeconds)))
  return request(`/practice-sessions/${encodeURIComponent(id)}/answer`, { method: 'POST', body: form })
}

export function evaluateSession(id) {
  return request(`/practice-sessions/${encodeURIComponent(id)}/evaluate`, { method: 'POST' })
}

export function getScoreResult(id) {
  return request(`/practice-sessions/${encodeURIComponent(id)}/result`)
}

export function getFeedbackAudio(id) {
  return request(`/practice-sessions/${encodeURIComponent(id)}/feedback/audio`)
}
