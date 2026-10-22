import { useEffect, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router'
import iconBulbSm from '../assets/figma/icon-bulb-sm.svg'
import iconChat from '../assets/figma/icon-chat.svg'
import iconFlag from '../assets/figma/icon-flag.svg'
import iconQuote from '../assets/figma/icon-quote.svg'
import iconSpeaker from '../assets/figma/icon-speaker.svg'
import iconTranscript from '../assets/figma/icon-transcript.svg'
import iconTrendUp from '../assets/figma/icon-trend-up.svg'
import { evaluateSession, getFeedbackAudio } from '../api/practice'
import { getQuestion } from '../api/questions'
import AudioPlayer from '../components/AudioPlayer'
import DeliveryPanel from '../components/DeliveryPanel'
import { formatClock } from '../constants/practice'
import { CRITERIA, FAILED_MESSAGES, scoreBand } from '../constants/scoring'
import { industryLabel, levelOf, questionTypeLabel } from '../constants/taxonomy'
import { useSessionResult } from '../hooks/useSessionResult'
import { splitFillers } from '../utils/fillers'
import styles from './ResultsPage.module.css'

export default function ResultsPage() {
  const { sessionId } = useParams()
  return <ResultsView key={sessionId} sessionId={sessionId} />
}

function ResultsView({ sessionId }) {
  const { phase, session, result, error, pollStartedAt, reload } = useSessionResult(sessionId)
  const [question, setQuestion] = useState(null)

  const questionId = session?.questionId
  useEffect(() => {
    if (!questionId) return
    let cancelled = false
    getQuestion(questionId)
      .then((q) => !cancelled && setQuestion(q))
      .catch(() => {})
    return () => {
      cancelled = true
    }
  }, [questionId])

  return (
    <div className={styles.page}>
      <nav className={styles.breadcrumb} aria-label="Breadcrumb">
        <img src={iconFlag} alt="" width="9.33333" height="10.6667" />
        <Link to="/questions">Luyện tập</Link>
        <span aria-hidden>›</span>
        <span className={styles.breadcrumbCurrent}>Kết quả phân tích</span>
      </nav>

      {phase === 'loading' && <p className={styles.muted}>Đang tải kết quả...</p>}
      {phase === 'error' && (
        <p role="alert" className={styles.alert}>
          {error.status === 404 || error.status === 403
            ? 'Không tìm thấy phiên luyện tập này.'
            : `Không tải được kết quả: ${error.message}`}{' '}
          <button type="button" className={styles.linkButton} onClick={reload}>
            Thử lại
          </button>
        </p>
      )}
      {phase === 'processing' && <ProcessingCard startedAt={pollStartedAt} />}
      {phase === 'failed' && <FailedCard session={session} onRetried={reload} />}
      {phase === 'not-submitted' && (
        <section className={styles.card}>
          <h2 className={styles.cardTitle}>Phiên này chưa được gửi chấm điểm</h2>
          <p className={styles.muted}>Hãy ghi âm và nộp câu trả lời trong phòng luyện tập.</p>
          <Link className={styles.primaryLink} to={`/practice/${sessionId}`}>
            Đến phòng luyện tập
          </Link>
        </section>
      )}
      {phase === 'scored' && <ScoredView session={session} result={result} question={question} />}
    </div>
  )
}

function ProcessingCard({ startedAt }) {
  const [now, setNow] = useState(() => Date.now())
  useEffect(() => {
    const id = setInterval(() => setNow(Date.now()), 1000)
    return () => clearInterval(id)
  }, [])
  const waited = startedAt ? Math.max(0, Math.round((now - startedAt) / 1000)) : 0

  return (
    <section className={`${styles.card} ${styles.processing}`} aria-live="polite">
      <span className={styles.spinner} aria-hidden />
      <h2 className={styles.cardTitle}>AI đang chấm câu trả lời của bạn</h2>
      <p className={styles.muted}>
        Nhận diện giọng nói → tính tốc độ nói, từ đệm → chấm từng tiêu chí theo rubric. Thường mất dưới 12
        giây.
      </p>
      <p className={styles.waited}>Đã chờ {waited} giây</p>
      {waited > 30 && (
        <p className={styles.notice}>
          Lâu hơn dự kiến. Bạn có thể rời trang, kết quả vẫn được lưu trong Lịch sử luyện tập.
        </p>
      )}
    </section>
  )
}

function FailedCard({ session, onRetried }) {
  const navigate = useNavigate()
  const [retrying, setRetrying] = useState(false)
  const [error, setError] = useState(null)
  const code = session.errorCode
  const canRetry = code !== 'ANSWER_TOO_SHORT'

  async function retry() {
    setRetrying(true)
    setError(null)
    try {
      await evaluateSession(session.id)
      await onRetried()
    } catch (err) {
      setError(err.message)
    } finally {
      setRetrying(false)
    }
  }

  return (
    <section className={`${styles.card} ${styles.failed}`}>
      <h2 className={styles.cardTitle}>Chấm điểm không thành công</h2>
      <p>{FAILED_MESSAGES[code] ?? `Đã xảy ra lỗi khi chấm điểm${code ? ` (${code})` : ''}.`}</p>
      {error && (
        <p role="alert" className={styles.alert}>
          {error}
        </p>
      )}
      <div className={styles.actions}>
        {canRetry && (
          <button type="button" className={styles.primaryButton} onClick={retry} disabled={retrying}>
            {retrying ? 'Đang gửi...' : 'Gửi chấm lại'}
          </button>
        )}
        <button type="button" className={styles.secondaryButton} onClick={() => navigate(`/practice/${session.id}`)}>
          Ghi âm lại
        </button>
      </div>
    </section>
  )
}

function ScoredView({ session, result, question }) {
  const total = Math.round(result.totalScore ?? 0)
  const band = scoreBand(total)
  const delivery = result.delivery
  const level = question ? levelOf(question.level) : null

  return (
    <>
      <section className={styles.hero}>
        <ScoreRing value={total} />
        <div className={styles.heroText}>
          <p className={styles.heroBadges}>
            <span className={`${styles.bandBadge} ${styles[`band_${band.tone}`]}`}>{band.label}</span>
            <span>{questionTypeLabel(result.questionType ?? question?.questionType)}</span>
          </p>
          <h1 className={styles.heroTitle}>{question?.content ?? 'Câu hỏi luyện tập'}</h1>
          {question && (
            <p className={styles.heroSub}>
              {industryLabel(question.industry)} • {question.position}
            </p>
          )}
        </div>
        <div className={styles.heroStats}>
          <Stat label="Nội dung" value={result.contentScore != null ? Math.round(result.contentScore) : '--'} unit="/100" />
          <Stat label="Tốc độ" value={delivery?.wpm ?? '--'} unit="wpm" />
          <Stat label="Từ đệm" value={delivery?.fillerCount ?? '--'} unit="lần" />
        </div>
      </section>

      <Warnings result={result} />

      <div className={styles.layout}>
        <div className={styles.mainCol}>
          <FeedbackCard sessionId={session.id} result={result} />
          <CriteriaCard criteria={result.criteria ?? []} />
          <TranscriptCard transcript={result.transcript} />
          {result.sampleAnswer && <SampleAnswerCard text={result.sampleAnswer} />}
        </div>

        <aside className={styles.sideCol}>
          <DeliveryPanel delivery={delivery} />
          <section className={styles.card}>
            <h3 className={styles.sideTitle}>Thông số phiên luyện tập</h3>
            <dl className={styles.facts}>
              {level && (
                <>
                  <dt>Độ khó</dt>
                  <dd>
                    <span className={`${styles.levelBadge} ${styles[`level_${level.value}`]}`}>{level.label === 'TB' ? 'Trung bình' : level.label}</span>
                  </dd>
                </>
              )}
              <dt>Thời lượng trả lời</dt>
              <dd>{session.duration ? formatClock(session.duration) : '--'}</dd>
              <dt>Thời điểm chấm</dt>
              <dd>{formatDateTime(session.completedAt ?? session.submittedAt)}</dd>
              <dt>Phiên bản rubric</dt>
              <dd>{result.rubricVersion ?? '--'}</dd>
              {delivery?.fillerListVersion && (
                <>
                  <dt>Danh sách từ đệm</dt>
                  <dd>{delivery.fillerListVersion}</dd>
                </>
              )}
            </dl>
            <div className={styles.sideActions}>
              <Link className={styles.primaryLink} to="/questions">
                Luyện câu khác
              </Link>
              <Link className={styles.secondaryLink} to="/history">
                Xem lịch sử
              </Link>
            </div>
          </section>
        </aside>
      </div>
    </>
  )
}

function ScoreRing({ value }) {
  const r = 42
  const c = 2 * Math.PI * r
  return (
    <div className={styles.ring} role="img" aria-label={`Điểm tổng ${value} trên 100`}>
      <svg viewBox="0 0 100 100" width="104" height="104" aria-hidden>
        <circle cx="50" cy="50" r={r} className={styles.ringTrack} />
        <circle
          cx="50"
          cy="50"
          r={r}
          className={styles.ringValue}
          strokeDasharray={c}
          strokeDashoffset={c * (1 - Math.min(100, Math.max(0, value)) / 100)}
        />
      </svg>
      <span className={styles.ringText}>
        <strong>{value}</strong>
        <small>/ 100</small>
      </span>
    </div>
  )
}

function Stat({ label, value, unit }) {
  return (
    <div className={styles.stat}>
      <span className={styles.statLabel}>{label}</span>
      <span className={styles.statValue}>
        {value}
        <small> {unit}</small>
      </span>
    </div>
  )
}

function Warnings({ result }) {
  const items = []
  if (result.offTopic)
    items.push('Câu trả lời được đánh giá là lạc đề so với câu hỏi, điểm tổng bị giới hạn tối đa 30.')
  if (result.injectionSuspected)
    items.push('Phát hiện nội dung có dấu hiệu yêu cầu thao túng điểm trong câu trả lời. Kết quả đã được chấm bình thường theo nội dung.')
  if (!result.delivery)
    items.push('Không đủ dữ liệu để chấm Delivery (dưới 30 từ). Trọng số Delivery đã chia lại cho các tiêu chí nội dung.')
  if (!items.length) return null
  return (
    <div className={styles.warnings} role="status">
      {items.map((text) => (
        <p key={text}>⚠ {text}</p>
      ))}
    </div>
  )
}

function FeedbackCard({ sessionId, result }) {
  const [audio, setAudio] = useState({ status: 'idle', url: result.ttsAudioUrl ?? null, error: null })

  async function loadAudio() {
    setAudio({ status: 'loading', url: null, error: null })
    try {
      const res = await getFeedbackAudio(sessionId)
      setAudio({ status: 'ready', url: res.ttsAudioUrl, error: null })
    } catch (err) {
      setAudio({
        status: 'error',
        url: null,
        error: err.status === 502 ? 'Dịch vụ đọc phản hồi tạm thời gián đoạn, bạn vẫn đọc được phản hồi bên dưới.' : err.message,
      })
    }
  }

  return (
    <section className={styles.card}>
      <div className={styles.cardHeader}>
        <div>
          <h2 className={styles.cardTitle}>Phản hồi của AI</h2>
          <p className={styles.muted}>Nhận xét tổng hợp về câu trả lời của bạn</p>
        </div>
        {!audio.url && (
          <button type="button" className={styles.listenButton} onClick={loadAudio} disabled={audio.status === 'loading'}>
            <img src={iconSpeaker} alt="" width="18" height="17.5" />
            {audio.status === 'loading' ? 'Đang tạo giọng đọc...' : 'Nghe phản hồi'}
          </button>
        )}
      </div>
      {audio.url && <AudioPlayer src={audio.url} />}
      {audio.error && <p className={styles.notice}>{audio.error}</p>}
      {result.feedbackText && (
        <blockquote className={styles.quoteBox}>
          <img src={iconQuote} alt="" width="14.1667" height="12" />
          <p>{result.feedbackText}</p>
        </blockquote>
      )}
    </section>
  )
}

function CriteriaCard({ criteria }) {
  const best = criteria.reduce((max, c) => (max && max.score >= c.score ? max : c), null)
  return (
    <section className={styles.card}>
      <div className={styles.cardHeader}>
        <div>
          <h2 className={styles.cardTitle}>Đánh giá theo rubric</h2>
          <p className={styles.muted}>Mỗi tiêu chí chấm thang 1-5 kèm trích dẫn từ câu trả lời của bạn</p>
        </div>
      </div>
      <div className={styles.criteria}>
        {criteria.map((c) => {
          const meta = CRITERIA[c.code] ?? { key: c.code.charAt(0), label: c.code, desc: '' }
          const percent = ((c.score - 1) / 4) * 100
          return (
            <article key={c.code} className={styles.criterion}>
              <div className={styles.criterionTop}>
                <span className={styles.criterionKey}>{meta.key}</span>
                <div className={styles.criterionName}>
                  <p>
                    {meta.label}
                    {best?.code === c.code && criteria.length > 1 && <span className={styles.bestTag}>Cao nhất</span>}
                  </p>
                  <small>
                    {meta.desc} • trọng số {c.weight}%
                  </small>
                </div>
                <span className={styles.criterionScore}>
                  {c.score}
                  <small>/5</small>
                </span>
              </div>
              <div className={styles.bar}>
                <div
                  className={`${styles.barFill} ${c.score >= 4 ? styles.barGood : c.score <= 2 ? styles.barWeak : ''}`}
                  style={{ width: `${Math.max(4, percent)}%` }}
                />
              </div>
              {c.reasoning && (
                <p className={styles.reasoning}>
                  <strong>Nhận xét AI:</strong> {c.reasoning}
                </p>
              )}
              {c.quote && (
                <p className={`${styles.evidence} ${c.quoteInvalid ? styles.evidenceInvalid : ''}`}>
                  “{c.quote}”
                  {c.quoteInvalid && (
                    <span> Trích dẫn không khớp với transcript nên điểm tiêu chí này đã bị hạ.</span>
                  )}
                </p>
              )}
            </article>
          )
        })}
      </div>
    </section>
  )
}

function TranscriptCard({ transcript }) {
  const segments = splitFillers(transcript)
  return (
    <section className={styles.card}>
      <div className={styles.cardHeader}>
        <h2 className={`${styles.cardTitle} ${styles.withIcon}`}>
          <img src={iconTranscript} alt="" width="18.3333" height="14.6667" />
          Văn bản nhận diện giọng nói
        </h2>
        <span className={styles.legend}>
          <mark>ừm</mark> Từ đệm
        </span>
      </div>
      {transcript ? (
        <p className={styles.transcript}>
          {segments.map((s, i) => (s.filler ? <mark key={i}>{s.text}</mark> : <span key={i}>{s.text}</span>))}
        </p>
      ) : (
        <p className={styles.muted}>Không có transcript.</p>
      )}
    </section>
  )
}

function SampleAnswerCard({ text }) {
  return (
    <section className={styles.card}>
      <h2 className={`${styles.cardTitle} ${styles.withIcon}`}>
        <img src={iconTrendUp} alt="" width="20" height="12" />
        Gợi ý nâng cấp câu trả lời
      </h2>
      <div className={styles.suggestion}>
        <h3>
          <img src={iconBulbSm} alt="" width="11.25" height="15" />
          Câu trả lời mẫu tham khảo
        </h3>
        <p>{text}</p>
      </div>
      <div className={styles.suggestion}>
        <h3>
          <img src={iconChat} alt="" width="15" height="15" />
          Luyện lại để cải thiện
        </h3>
        <p>
          Ghi âm lại câu hỏi này hoặc chọn câu cùng chủ đề trong ngân hàng câu hỏi.{' '}
          <Link to="/questions">Chọn câu hỏi</Link>
        </p>
      </div>
    </section>
  )
}

function formatDateTime(value) {
  if (!value) return '--'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return '--'
  return date.toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' })
}
