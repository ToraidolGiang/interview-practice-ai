import { useCallback, useState } from 'react'
import { useNavigate } from 'react-router'
import { createPracticeSession } from '../api/practice'

/**
 * Tạo phiên luyện tập cho một câu hỏi rồi chuyển vào phòng luyện tập.
 * start(questionId | () => Promise<questionId>, key?) — key dùng để biết nút nào đang chờ.
 */
export function useStartPractice() {
  const navigate = useNavigate()
  const [startingId, setStartingId] = useState(null)
  const [error, setError] = useState(null)

  const start = useCallback(
    async (questionOrLoader, key) => {
      setError(null)
      setStartingId(key ?? (typeof questionOrLoader === 'function' ? 'loader' : questionOrLoader))
      try {
        const questionId = typeof questionOrLoader === 'function' ? await questionOrLoader() : questionOrLoader
        const session = await createPracticeSession(questionId)
        navigate(`/practice/${session.id}`, { state: { questionId } })
      } catch (err) {
        setStartingId(null)
        // Lỗi lấy câu ngẫu nhiên để nơi gọi tự xử lý thông báo
        if (typeof questionOrLoader === 'function') throw err
        setError(err.status === 404 ? 'Câu hỏi không còn khả dụng, vui lòng chọn câu khác.' : err.message)
      }
    },
    [navigate],
  )

  return { start, startingId, error }
}
