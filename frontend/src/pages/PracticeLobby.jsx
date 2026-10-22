import { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router'
import iconMicWhite from '../assets/figma/icon-mic-white.svg'
import iconSearch from '../assets/figma/icon-search.svg'
import { listHistory } from '../api/history'
import { createPracticeSession } from '../api/practice'
import { getQuestion, listQuestions, randomQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import { MAX_RECORDING_SECONDS, MIN_RECORDING_SECONDS } from '../constants/practice'
import { RUBRIC_VERSION, scoreBand } from '../constants/scoring'
import { industryLabel, levelOf, questionTypeLabel } from '../constants/taxonomy'
import styles from './PracticeLobby.module.css'

const STEPS = [
  { title: 'Chọn câu hỏi', desc: 'Từ ngân hàng câu hỏi theo ngành, vị trí, độ khó' },
  {
    title: 'Ghi âm câu trả lời',
    desc: `${MIN_RECORDING_SECONDS} giây - ${MAX_RECORDING_SECONDS / 60} phút, nghe lại và ghi lại tuỳ ý`,
  },
  { title: 'AI chấm theo rubric', desc: `Điểm từng tiêu chí (${RUBRIC_VERSION}), phản hồi bằng giọng nói` },
]

// Phòng luyện tập khi mở từ menu, chưa gắn với phiên nào
export default function PracticeLobby() {
  const navigate = useNavigate()
  const [suggestions, setSuggestions] = useState(null)
  const [recent, setRecent] = useState(null)
  const [starting, setStarting] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    let cancelled = false
    listQuestions({ page: 0, size: 3 })
      .then((p) => !cancelled && setSuggestions((p.content ?? []).slice(0, 3)))
      .catch(() => !cancelled && setSuggestions([]))
    listHistory({ page: 0, size: 3 })
      .then(async (p) => {
        const sessions = (p.content ?? []).slice(0, 3)
        // Lịch sử chỉ có questionId nên lấy thêm nội dung câu hỏi để hiển thị
        const questions = await Promise.all(sessions.map((s) => getQuestion(s.questionId).catch(() => null)))
        if (!cancelled) setRecent(sessions.map((s, i) => ({ session: s, question: questions[i] })))
      })
      .catch(() => !cancelled && setRecent([]))
    return () => {
      cancelled = true
    }
  }, [])

  async function start(key, getQuestionId) {
    setError(null)
    setStarting(key)
    try {
      const questionId = await getQuestionId()
      const session = await createPracticeSession(questionId)
      navigate(`/practice/${session.id}`)
    } catch (err) {
      setError(err.status === 404 ? 'Hiện chưa có câu hỏi phù hợp, hãy chọn trong Ngân hàng câu hỏi.' : err.message)
      setStarting(null)
    }
  }

  return (
    <div className={styles.page}>
      <Breadcrumb current="Phòng luyện tập" />
      <div className={styles.column}>
        <section className={styles.card}>
          <p className={styles.eyebrow}>
            <span className={styles.dot} aria-hidden />
            Phòng luyện tập phỏng vấn
          </p>
          <h1 className={styles.title}>Sẵn sàng cho buổi phỏng vấn thử?</h1>
          <p className={styles.lead}>
            Chọn một câu hỏi, trả lời bằng giọng nói như phỏng vấn thật, AI sẽ chấm từng tiêu chí và gợi ý cách cải
            thiện.
          </p>

          <ol className={styles.steps}>
            {STEPS.map((step, i) => (
              <li key={step.title} className={styles.step}>
                <span className={styles.stepKey}>{i + 1}</span>
                <div>
                  <p className={styles.stepTitle}>{step.title}</p>
                  <p className={styles.stepDesc}>{step.desc}</p>
                </div>
              </li>
            ))}
          </ol>

          {error && (
            <p role="alert" className={styles.alert}>
              {error}
            </p>
          )}

          <div className={styles.actions}>
            <button
              type="button"
              className={styles.recordButton}
              onClick={() => start('random', async () => (await randomQuestion({})).id)}
              disabled={starting !== null}
            >
              <img src={iconMicWhite} alt="" width="9.33333" height="12.6667" />
              {starting === 'random' ? 'Đang chuẩn bị...' : 'Luyện câu ngẫu nhiên'}
            </button>
            <Link to="/questions" className={styles.secondaryButton}>
              <img src={iconSearch} alt="" width="16.5" height="16.5" />
              Chọn từ Ngân hàng câu hỏi
            </Link>
          </div>
        </section>

        <section className={styles.card}>
          <div className={styles.cardHeader}>
            <h2 className={styles.cardTitle}>Gợi ý câu hỏi để bắt đầu</h2>
            <Link to="/questions" className={styles.moreLink}>
              Xem tất cả
            </Link>
          </div>
          {suggestions === null && <p className={styles.muted}>Đang tải câu hỏi...</p>}
          {suggestions?.length === 0 && <p className={styles.muted}>Chưa tải được câu hỏi gợi ý.</p>}
          <div className={styles.list}>
            {suggestions?.map((q) => {
              const level = levelOf(q.level)
              return (
                <article key={q.id} className={styles.row}>
                  <div className={styles.rowBody}>
                    <p className={styles.rowMeta}>
                      <span className={styles.rowIndustry}>{industryLabel(q.industry)}</span>
                      {level && <span className={styles[`tone${level.value}`]}>{level.badge}</span>}
                      <span>{questionTypeLabel(q.questionType).split(' (')[0]}</span>
                    </p>
                    <p className={styles.rowTitle}>{q.content}</p>
                  </div>
                  <button
                    type="button"
                    className={styles.practiceButton}
                    onClick={() => start(q.id, async () => q.id)}
                    disabled={starting !== null}
                  >
                    <img src={iconMicWhite} alt="" width="9.33333" height="12.6667" />
                    {starting === q.id ? 'Đang tạo...' : 'Luyện tập ngay'}
                  </button>
                </article>
              )
            })}
          </div>
        </section>

        <section className={styles.card}>
          <div className={styles.cardHeader}>
            <h2 className={styles.cardTitle}>Kết quả gần đây</h2>
            <Link to="/history" className={styles.moreLink}>
              Xem lịch sử
            </Link>
          </div>
          {recent === null && <p className={styles.muted}>Đang tải...</p>}
          {recent?.length === 0 && (
            <p className={styles.muted}>Bạn chưa có phiên nào được chấm. Hãy bắt đầu câu hỏi đầu tiên ở trên.</p>
          )}
          <div className={styles.list}>
            {recent?.map(({ session, question }) => {
              const score = Math.round(session.totalScore ?? 0)
              const band = scoreBand(score)
              return (
                <Link key={session.id} to={`/results/${session.id}`} className={`${styles.row} ${styles.rowLink}`}>
                  <span className={`${styles.score} ${styles[`band_${band.tone}`]}`}>
                    {score}
                    <small>/100</small>
                  </span>
                  <div className={styles.rowBody}>
                    <p className={styles.rowTitle}>{question?.content ?? 'Câu hỏi luyện tập'}</p>
                    <p className={styles.rowMeta}>
                      <span>{band.label}</span>
                      <span>{formatDate(session.completedAt)}</span>
                    </p>
                  </div>
                  <span className={styles.moreLink}>Xem kết quả</span>
                </Link>
              )
            })}
          </div>
        </section>
      </div>
    </div>
  )
}

function formatDate(value) {
  if (!value) return ''
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? '' : date.toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' })
}
