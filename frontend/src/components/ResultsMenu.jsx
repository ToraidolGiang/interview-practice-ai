import { useEffect, useRef, useState } from 'react'
import { Link, useLocation } from 'react-router'
import iconBell from '../assets/figma/icon-bell.svg'
import { listHistory } from '../api/history'
import { getQuestion } from '../api/questions'
import { formatPoints, scoreBand } from '../constants/scoring'
import styles from './ResultsMenu.module.css'

const SEEN_KEY = 'talentstar.resultsSeenAt'

function readSeenAt() {
  try {
    return Number(localStorage.getItem(SEEN_KEY)) || 0
  } catch {
    return 0
  }
}

// Chuông trên header: danh sách kết quả mới chấm, chấm đỏ khi có kết quả chưa xem
export default function ResultsMenu() {
  const location = useLocation()
  const [open, setOpen] = useState(false)
  const [items, setItems] = useState(null)
  const [seenAt, setSeenAt] = useState(readSeenAt)
  const rootRef = useRef(null)

  // Tải lại khi đổi trang để kết quả vừa chấm xong hiện ngay
  useEffect(() => {
    let cancelled = false
    listHistory({ page: 0, size: 5 })
      .then(async (page) => {
        const sessions = (page.content ?? []).slice(0, 5)
        const questions = await Promise.all(sessions.map((s) => getQuestion(s.questionId).catch(() => null)))
        if (!cancelled) setItems(sessions.map((s, i) => ({ session: s, question: questions[i] })))
      })
      .catch(() => !cancelled && setItems([]))
    return () => {
      cancelled = true
    }
  }, [location.pathname])

  useEffect(() => {
    if (!open) return
    const close = (e) => {
      if (e.type === 'keydown' ? e.key === 'Escape' : !rootRef.current?.contains(e.target)) setOpen(false)
    }
    document.addEventListener('mousedown', close)
    document.addEventListener('keydown', close)
    return () => {
      document.removeEventListener('mousedown', close)
      document.removeEventListener('keydown', close)
    }
  }, [open])

  const unread = (items ?? []).filter((it) => new Date(it.session.completedAt).getTime() > seenAt).length

  function toggle() {
    const next = !open
    setOpen(next)
    if (next && items?.length) {
      const latest = Math.max(...items.map((it) => new Date(it.session.completedAt).getTime() || 0))
      setSeenAt(latest)
      try {
        localStorage.setItem(SEEN_KEY, String(latest))
      } catch {
        // bỏ qua
      }
    }
  }

  return (
    <div className={styles.root} ref={rootRef}>
      <button
        type="button"
        className={`${styles.bell} ${open ? styles.bellOpen : ''}`}
        onClick={toggle}
        aria-label={unread ? `Kết quả chấm điểm, ${unread} kết quả mới` : 'Kết quả chấm điểm'}
        aria-expanded={open}
        title="Kết quả chấm điểm"
      >
        <img src={iconBell} alt="" width="13.333" height="16.667" />
        {unread > 0 && <span className={styles.badge}>{unread}</span>}
      </button>

      {open && (
        <div className={styles.panel} role="dialog" aria-label="Kết quả chấm điểm gần đây">
          <div className={styles.panelHead}>
            <p>Kết quả chấm điểm gần đây</p>
          </div>
          {items === null && <p className={styles.empty}>Đang tải...</p>}
          {items?.length === 0 && <p className={styles.empty}>Chưa có kết quả nào. Luyện một câu để nhận điểm đầu tiên.</p>}
          <ul className={styles.list}>
            {items?.map(({ session, question }) => {
              const band = scoreBand(session.totalScore ?? 0)
              return (
                <li key={session.id}>
                  <Link to={`/results/${session.id}`} className={styles.item} onClick={() => setOpen(false)}>
                    <span className={`${styles.score} ${styles[`band_${band.tone}`]}`}>
                      {formatPoints(Math.round(session.totalScore ?? 0))}
                    </span>
                    <span className={styles.itemText}>
                      <span className={styles.itemTitle}>{question?.content ?? 'Câu hỏi luyện tập'}</span>
                      <span className={styles.itemMeta}>
                        {band.label} • {formatDate(session.completedAt)}
                      </span>
                    </span>
                  </Link>
                </li>
              )
            })}
          </ul>
          <Link to="/history" className={styles.all} onClick={() => setOpen(false)}>
            Xem tất cả trong Lịch sử & Tiến độ
          </Link>
        </div>
      )}
    </div>
  )
}

function formatDate(value) {
  const d = new Date(value)
  return Number.isNaN(d.getTime()) ? '' : d.toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' })
}
