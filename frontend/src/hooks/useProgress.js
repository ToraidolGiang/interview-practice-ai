import { useEffect, useMemo, useState } from 'react'
import { getHistoryDetail, listHistory } from '../api/history'
import { getQuestion } from '../api/questions'
import { CRITERIA, WEIGHTS } from '../constants/scoring'

// Số phiên gần nhất dùng để tính xu hướng (chỉ cần totalScore) và số phiên lấy chi tiết (tiêu chí, Delivery)
const TREND_SIZE = 60
const DETAIL_SIZE = 10

// Cache nội dung câu hỏi: API lịch sử chỉ trả questionId
const questionCache = new Map()
export function loadQuestion(id) {
  if (!questionCache.has(id)) questionCache.set(id, getQuestion(id).catch(() => null))
  return questionCache.get(id)
}

export function average(values) {
  const list = values.map(Number).filter((v) => Number.isFinite(v))
  return list.length ? list.reduce((a, b) => a + b, 0) / list.length : null
}

// Tuần ISO-8601: { year, week }
export function isoWeek(date) {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
  const day = d.getUTCDay() || 7
  d.setUTCDate(d.getUTCDate() + 4 - day)
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1))
  return { year: d.getUTCFullYear(), week: Math.ceil(((d - yearStart) / 864e5 + 1) / 7) }
}

const sessionDate = (s) => new Date(s.completedAt ?? s.submittedAt ?? s.startedAt)

/**
 * Thống kê tiến độ từ lịch sử phiên đã chấm của người dùng (dùng ở Tổng quan, Lịch sử, Hồ sơ).
 * Contract API chưa có endpoint thống kê cho ứng viên nên tính ở client.
 */
export function useProgress() {
  const [state, setState] = useState({ status: 'loading', total: 0, sessions: [], details: [] })

  useEffect(() => {
    let cancelled = false
    listHistory({ page: 0, size: TREND_SIZE })
      .then(async (page) => {
        const sessions = page.content ?? []
        const details = await Promise.all(
          sessions.slice(0, DETAIL_SIZE).map((s) => getHistoryDetail(s.id).catch(() => ({ ...s }))),
        )
        const questions = await Promise.all(sessions.slice(0, DETAIL_SIZE).map((s) => loadQuestion(s.questionId)))
        if (!cancelled)
          setState({
            status: 'ready',
            total: page.totalElements ?? sessions.length,
            sessions,
            details: details.map((d, i) => ({ ...d, question: questions[i] })),
          })
      })
      .catch(() => !cancelled && setState((s) => ({ ...s, status: 'error' })))
    return () => {
      cancelled = true
    }
  }, [])

  return useMemo(() => {
    const { sessions, details } = state
    const half = Math.ceil(details.length / 2)
    const newer = details.slice(0, half)
    const older = details.slice(half)

    // Điểm trung bình theo tiêu chí (thang 1-5)
    const buckets = {}
    for (const d of details) {
      for (const c of d.scoreResult?.criteria ?? []) (buckets[c.code] ??= []).push(c.score)
      const delivery = d.scoreResult?.delivery
      if (delivery) (buckets.DELIVERY ??= []).push(Number(delivery.deliveryScore))
    }
    const order = Object.keys(CRITERIA)
    const criteriaAvg = Object.entries(buckets)
      .map(([code, scores]) => ({ code, avg: average(scores), count: scores.length }))
      .sort((a, b) => order.indexOf(a.code) - order.indexOf(b.code))

    // Loại câu hỏi luyện nhiều nhất: dùng để hiển thị trọng số tiêu chí
    const typeCount = {}
    for (const d of details) {
      const t = d.scoreResult?.questionType ?? d.question?.questionType
      if (t) typeCount[t] = (typeCount[t] ?? 0) + 1
    }
    const mainType = Object.entries(typeCount).sort((a, b) => b[1] - a[1])[0]?.[0] ?? 'BEHAVIORAL'
    const weights = WEIGHTS[mainType]

    // Tiêu chí nội dung yếu nhất (không tính Delivery)
    const weakest = criteriaAvg
      .filter((c) => c.code !== 'DELIVERY')
      .sort((a, b) => a.avg - b.avg || (weights[b.code] ?? 0) - (weights[a.code] ?? 0))[0]

    // Điểm trung bình theo tuần, 6 tuần gần nhất có luyện tập
    const weekMap = new Map()
    for (const s of sessions) {
      if (s.totalScore == null) continue
      const { year, week } = isoWeek(sessionDate(s))
      const key = year * 100 + week
      if (!weekMap.has(key)) weekMap.set(key, { key, week, scores: [] })
      weekMap.get(key).scores.push(s.totalScore)
    }
    const nowWeek = isoWeek(new Date())
    const weekly = [...weekMap.values()]
      .sort((a, b) => a.key - b.key)
      .slice(-6)
      .map((w) => ({
        week: w.week,
        avg: average(w.scores),
        current: w.key === nowWeek.year * 100 + nowWeek.week,
      }))

    // Chuỗi ngày luyện liên tiếp tính đến hôm nay (hoặc hôm qua)
    const days = new Set(sessions.map((s) => sessionDate(s).toDateString()))
    let streak = 0
    const cursor = new Date()
    if (!days.has(cursor.toDateString())) cursor.setDate(cursor.getDate() - 1)
    while (days.has(cursor.toDateString())) {
      streak++
      cursor.setDate(cursor.getDate() - 1)
    }

    // Phiên trong tuần hiện tại theo thứ (T2..CN) và trong tháng hiện tại
    const now = new Date()
    const monday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - ((now.getDay() + 6) % 7))
    const weekDays = Array.from({ length: 7 }, (_, i) => {
      const day = new Date(monday.getFullYear(), monday.getMonth(), monday.getDate() + i)
      return { label: i === 6 ? 'CN' : `T${i + 2}`, done: days.has(day.toDateString()), future: day > now }
    })
    const thisWeek = sessions.filter((s) => sessionDate(s) >= monday).length
    const thisMonth = sessions.filter((s) => {
      const d = sessionDate(s)
      return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear()
    }).length

    const score = (list) => average(list.map((d) => d.totalScore))
    const filler = (list) => average(list.map((d) => d.scoreResult?.delivery?.fillerRate))

    return {
      ...state,
      avgScore: score(details),
      scoreDelta: older.length ? score(newer) - score(older) : null,
      avgWpm: average(details.map((d) => d.scoreResult?.delivery?.wpm)),
      avgFiller: filler(details),
      olderFiller: older.length ? filler(older) : null,
      criteriaAvg,
      weights,
      weakest,
      weekly,
      streak,
      weekDays,
      thisWeek,
      thisMonth,
    }
  }, [state])
}
