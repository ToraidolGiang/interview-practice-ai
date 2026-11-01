import { useEffect, useState } from 'react'
import { listQuestions } from '../api/questions'

/** Câu hỏi gợi ý: cùng ngành/vị trí với lần luyện gần nhất, bỏ các câu đã luyện gần đây. */
export function useSuggestions({ industry, position, exclude = [], count = 3 }) {
  const [state, setState] = useState(null)
  const excludeKey = exclude.join(',')

  useEffect(() => {
    let cancelled = false
    const skip = new Set(excludeKey.split(',').filter(Boolean))
    const pick = (page) => (page.content ?? []).filter((q) => !skip.has(q.id))
    listQuestions({ industry, position, page: 0, size: count + skip.size })
      .then(async (page) => {
        let items = pick(page)
        if (items.length < count && (industry || position)) {
          // Không đủ câu theo vị trí: lấy thêm trong toàn ngân hàng
          const more = pick(await listQuestions({ page: 0, size: count + skip.size }))
          items = [...items, ...more.filter((q) => !items.some((i) => i.id === q.id))]
        }
        if (!cancelled) setState(items.slice(0, count))
      })
      .catch(() => !cancelled && setState([]))
    return () => {
      cancelled = true
    }
  }, [industry, position, excludeKey, count])

  return state
}
