import { request } from './client'

function toQuery(params) {
  const search = new URLSearchParams()
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== '') search.set(key, value)
  }
  const query = search.toString()
  return query ? `?${query}` : ''
}

// filters: { industry, position, level, questionType, keyword, page, size }
export function listQuestions(filters) {
  return request(`/questions${toQuery(filters)}`)
}

export function randomQuestion({ industry, position, level }) {
  return request(`/questions/random${toQuery({ industry, position, level })}`)
}

export function getQuestion(id) {
  return request(`/questions/${encodeURIComponent(id)}`)
}
