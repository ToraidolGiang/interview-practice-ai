import { useCallback, useEffect, useRef, useState } from 'react'
import { getPracticeSession, getScoreResult } from '../api/practice'

export const POLL_INTERVAL_MS = 2000

/**
 * Polling GET /practice-sessions/{id} mỗi 2 giây khi đang PROCESSING (chấm bất đồng bộ, #156),
 * tới SCORED thì lấy GET /practice-sessions/{id}/result.
 * phase: loading | processing | scored | failed | not-submitted | error
 */
export function useSessionResult(sessionId) {
  const [state, setState] = useState({ phase: 'loading', session: null, result: null, error: null })
  const [pollStartedAt, setPollStartedAt] = useState(null)
  const timerRef = useRef(0)
  const runRef = useRef(0)

  const load = useCallback(async () => {
    const run = ++runRef.current
    clearTimeout(timerRef.current)
    const alive = () => run === runRef.current

    const poll = async () => {
      try {
        const session = await getPracticeSession(sessionId)
        if (!alive()) return
        if (session.status === 'PROCESSING') {
          setPollStartedAt((t) => t ?? Date.now())
          setState({ phase: 'processing', session, result: null, error: null })
          timerRef.current = setTimeout(poll, POLL_INTERVAL_MS)
          return
        }
        setPollStartedAt(null)
        if (session.status === 'SCORED') {
          const result = await getScoreResult(sessionId)
          if (alive()) setState({ phase: 'scored', session, result, error: null })
        } else if (session.status === 'FAILED') {
          setState({ phase: 'failed', session, result: null, error: null })
        } else {
          setState({ phase: 'not-submitted', session, result: null, error: null })
        }
      } catch (error) {
        if (alive()) setState((s) => ({ ...s, phase: 'error', error }))
      }
    }
    await poll()
  }, [sessionId])

  // Huỷ vòng polling đang chạy: các lần gọi API cũ trả về sau sẽ bị bỏ qua
  const cancel = useCallback(() => {
    runRef.current++
    clearTimeout(timerRef.current)
  }, [])

  useEffect(() => {
    load()
    return cancel
  }, [load, cancel])

  return { ...state, pollStartedAt, reload: load }
}
