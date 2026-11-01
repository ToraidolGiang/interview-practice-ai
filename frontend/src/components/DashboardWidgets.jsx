import { Link } from 'react-router'
import { levelOf } from '../constants/taxonomy'
import { useStartPractice } from '../hooks/useStartPractice'
import { formatRecentTime } from '../utils/format'
import Icon from './Icon'
import styles from './DashboardWidgets.module.css'

const shortIndustry = (q) =>
  [q.industry, q.position === 'Chung' ? 'Chung' : q.position?.split(' ')[0]].filter(Boolean).join(' · ').toUpperCase()

export function SuggestionGrid({ questions }) {
  const { start, startingId, error } = useStartPractice()
  if (!questions) return <p className="muted">Đang tải gợi ý...</p>
  if (!questions.length) return <p className="muted">Chưa có câu hỏi để gợi ý.</p>
  return (
    <>
      {error && <p className="field-error">{error}</p>}
      <div className={styles.suggestions}>
        {questions.map((q) => {
          const level = levelOf(q.level)
          return (
            <article key={q.id} className={styles.suggestion}>
              <div className={styles.tags}>
                <span className={styles.tagIndigo}>{shortIndustry(q)}</span>
                {level && <span className={styles[`tag_${level.value}`]}>{level.label.toUpperCase()}</span>}
              </div>
              <h3>{q.content}</h3>
              {q.answerHint && <p>{q.answerHint}</p>}
              <button type="button" className="link" onClick={() => start(q.id)} disabled={startingId !== null}>
                {startingId === q.id ? 'Đang tạo phiên...' : 'Luyện ngay'}
                <Icon name="arrowRight" size={13} strokeWidth={2.2} />
              </button>
            </article>
          )
        })}
      </div>
    </>
  )
}

export function RecentSessions({ items }) {
  if (!items) return <p className="muted">Đang tải...</p>
  if (!items.length) return <p className="muted">Chưa có phiên nào. Hãy chọn một câu hỏi để bắt đầu.</p>
  return (
    <ul className={styles.recent}>
      {items.map(({ session, question }) => (
        <li key={session.id}>
          <Link to={`/results/${session.id}`}>
            <span className={styles.recentText}>
              <strong>{question?.content ?? 'Câu hỏi luyện tập'}</strong>
              <small>{formatRecentTime(session.completedAt ?? session.submittedAt ?? session.startedAt)}</small>
            </span>
            {session.totalScore != null && (
              <span className={`pill ${session.totalScore >= 80 ? 'pill-green' : 'pill-amber'}`}>
                {session.totalScore.toFixed(1)}
              </span>
            )}
          </Link>
        </li>
      ))}
    </ul>
  )
}
