import { useEffect, useRef, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router'
import iconBulbSm from '../assets/figma/icon-bulb-sm.svg'
import iconChat from '../assets/figma/icon-chat.svg'
import iconFeedbackDoc from '../assets/figma/icon-feedback-doc.svg'
import iconPdf from '../assets/figma/icon-pdf.svg'
import iconPlayWhite from '../assets/figma/icon-play-white.svg'
import iconQuote from '../assets/figma/icon-quote.svg'
import iconTranscript from '../assets/figma/icon-transcript.svg'
import iconTrendUp from '../assets/figma/icon-trend-up.svg'
import { evaluateSession, getFeedbackAudio } from '../api/practice'
import { getQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import DeliveryPanel from '../components/DeliveryPanel'
import RubricRadar from '../components/RubricRadar'
import { formatClock } from '../constants/practice'
import {
  anchor5,
  contribution,
  CRITERIA,
  criterionDesc,
  FAILED_MESSAGES,
  formatPoints,
  scoreBand,
  WEIGHTS,
} from '../constants/scoring'
import { industryLabel, levelOf, questionTypeLabel } from '../constants/taxonomy'
import { useSessionResult } from '../hooks/useSessionResult'
import { highlightTranscript } from '../utils/fillers'
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

  const questionType = result?.questionType ?? question?.questionType

  return (
    <div className={styles.page}>
      <Breadcrumb
        items={[{ label: 'Phòng luyện tập', to: '/practice' }]}
        current="Kết quả chấm điểm"
        tag={questionType ? questionTypeLabel(questionType).split(' (')[0] : null}
      >
        {phase === 'scored' && (
          <div className={styles.topActions}>
            <span className={styles.engineChip}>
              <span className={styles.engineDot} aria-hidden />
              Chấm theo {result.rubricVersion ?? 'rubric-v1.0'}
            </span>
            <button type="button" className={styles.pdfButton} onClick={() => window.print()}>
              <img src={iconPdf} alt="" width="13.3333" height="13.3333" />
              Xuất PDF Báo cáo
            </button>
          </div>
        )}
      </Breadcrumb>

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
      {phase === 'scored' && (
        <ScoredView session={session} result={result} question={question} questionType={questionType} />
      )}
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

/** Gộp tiêu chí do LLM chấm và Delivery (code tính) thành một danh sách hàng rubric. */
function rubricRows(result, questionType) {
  const weights = WEIGHTS[questionType] ?? {}
  const rows = (result.criteria ?? []).map((c) => ({
    code: c.code,
    score: c.score,
    weight: c.weight ?? weights[c.code] ?? 0,
    reasoning: c.reasoning,
    quote: c.quote,
    quoteInvalid: c.quoteInvalid,
  }))
  if (result.delivery) {
    rows.push({
      code: 'DELIVERY',
      score: Number(result.delivery.deliveryScore),
      // Server không trả trọng số Delivery; lấy theo rubric (10) hoặc phần còn lại để tổng = 100
      weight: weights.DELIVERY ?? Math.max(0, 100 - rows.reduce((sum, r) => sum + r.weight, 0)),
      reasoning: `Tốc độ ${result.delivery.wpm} từ/phút, ${result.delivery.fillerCount} từ đệm (${Number(result.delivery.fillerRate).toLocaleString('en-US', { maximumFractionDigits: 2 })} trên 100 từ).`,
    })
  }
  return rows
}

function ScoredView({ session, result, question, questionType }) {
  const total = Math.round(result.totalScore ?? 0)
  const band = scoreBand(total)
  const delivery = result.delivery
  const rows = rubricRows(result, questionType)

  return (
    <>
      <section className={styles.hero}>
        <ScoreRing value={total} />
        <div className={styles.heroText}>
          <p className={styles.heroBadges}>
            <span className={styles.bandBadge}>{band.label}</span>
            <span>
              Chấm theo rubric {questionTypeLabel(questionType).split(' (')[0].toLowerCase()} • {rows.length} tiêu chí
            </span>
          </p>
          <h1 className={styles.heroTitle}>{question?.content ?? 'Câu hỏi luyện tập'}</h1>
          {question && (
            <p className={styles.heroSub}>
              {industryLabel(question.industry)} • {question.position}
            </p>
          )}
        </div>
        <div className={styles.heroStats}>
          <Stat label="Nội dung" value={result.contentScore != null ? formatPoints(result.contentScore) : '--'} />
          <Stat label="Tốc độ" value={delivery?.wpm ?? '--'} unit="wpm" />
          <Stat label="Từ đệm" value={delivery?.fillerCount ?? '--'} unit="lần" />
        </div>
      </section>

      <Warnings result={result} />

      <div className={styles.layout}>
        <div className={styles.mainCol}>
          <FeedbackCard sessionId={session.id} result={result} />
          <RubricCard rows={rows} questionType={questionType} total={total} band={band} hasDelivery={!!delivery} />
          <TranscriptCard transcript={result.transcript} criteria={result.criteria ?? []} />
          <SuggestionsCard rows={rows} questionType={questionType} result={result} sessionId={session.id} />
        </div>

        <aside className={styles.sideCol}>
          <DeliveryPanel delivery={delivery} transcript={result.transcript} />
          <section className={styles.card}>
            <div>
              <h3 className={styles.sideHeading}>Hồ sơ năng lực theo rubric</h3>
              <p className={styles.muted}>Điểm từng tiêu chí của câu trả lời này trên thang 1-5.</p>
            </div>
            <RubricRadar
              items={rows.map((r) => ({ label: CRITERIA[r.code]?.label ?? r.code, score: r.score }))}
            />
          </section>
          <SessionInfo session={session} result={result} question={question} />
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
      <svg viewBox="0 0 100 100" width="96" height="96" aria-hidden>
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
        {unit && <small> {unit}</small>}
      </span>
    </div>
  )
}

function Warnings({ result }) {
  const items = []
  if (result.offTopic)
    items.push('Câu trả lời được đánh giá là lạc đề so với câu hỏi, điểm tổng bị giới hạn tối đa 30.')
  if (result.injectionSuspected)
    items.push('Phát hiện nội dung có dấu hiệu yêu cầu thao túng điểm trong câu trả lời. Kết quả vẫn được chấm theo nội dung thật.')
  if (!result.delivery)
    items.push('Không đủ dữ liệu để chấm Giọng nói (dưới 30 từ). Trọng số 10% đã chia lại cho các tiêu chí nội dung.')
  if (!items.length) return null
  return (
    <div className={styles.warnings} role="status">
      {items.map((text) => (
        <p key={text}>⚠ {text}</p>
      ))}
    </div>
  )
}

const SPEEDS = [1, 1.25, 1.5]
const WAVE = [12, 20, 28, 16, 24, 32, 18, 10, 22, 30, 14, 26, 20, 12, 28, 18, 24, 10, 30, 16, 22, 14, 26, 20, 12, 18, 28, 16, 22, 10, 24, 14]

// Khối phản hồi giọng nói (UC6, Figma "Spoken Voice Feedback"): audio TTS chỉ tải khi bấm nghe
function FeedbackCard({ sessionId, result }) {
  const audioRef = useRef(null)
  const [src, setSrc] = useState(result.ttsAudioUrl ?? null)
  const [status, setStatus] = useState('idle')
  const [error, setError] = useState(null)
  const [playing, setPlaying] = useState(false)
  const [time, setTime] = useState({ current: 0, duration: 0 })
  const [speed, setSpeed] = useState(1)
  const [showText, setShowText] = useState(true)

  useEffect(() => {
    if (audioRef.current) audioRef.current.playbackRate = speed
  }, [speed, src])

  async function togglePlay() {
    const audio = audioRef.current
    if (src && audio) {
      if (audio.paused) audio.play()
      else audio.pause()
      return
    }
    setStatus('loading')
    setError(null)
    try {
      const res = await getFeedbackAudio(sessionId)
      setSrc(res.ttsAudioUrl)
      setStatus('ready')
    } catch (err) {
      setStatus('error')
      setError(err.status === 502 ? 'Dịch vụ đọc phản hồi tạm thời gián đoạn, bạn vẫn đọc được phản hồi bên dưới.' : err.message)
    }
  }

  const progress = time.duration ? time.current / time.duration : 0

  return (
    <section className={styles.card}>
      <div className={styles.cardHeader}>
        <div>
          <h2 className={styles.cardTitle}>Phản hồi âm thanh AI (Spoken Voice Feedback)</h2>
          <p className={styles.muted}>
            Tổng hợp từ kết quả chấm theo rubric • Giọng đọc: <span className={styles.accent}>Tiếng Việt (TTS)</span>
          </p>
        </div>
        <span className={styles.pillChip}>Phản hồi giọng nói</span>
      </div>

      <div className={styles.deck}>
        <div className={styles.deckRow}>
          <div className={styles.deckControls}>
            <button
              type="button"
              className={styles.roundButton}
              onClick={() => setShowText((v) => !v)}
              aria-label={showText ? 'Ẩn lời phản hồi' : 'Hiện lời phản hồi'}
              aria-pressed={showText}
            >
              <img src={iconFeedbackDoc} alt="" width="15" height="15" />
            </button>
            <button
              type="button"
              className={styles.playButton}
              onClick={togglePlay}
              disabled={status === 'loading'}
              aria-label={playing ? 'Tạm dừng phản hồi' : 'Nghe phản hồi'}
            >
              {playing ? <span className={styles.pauseGlyph} aria-hidden /> : <img src={iconPlayWhite} alt="" width="11" height="14" />}
            </button>
          </div>
          <div className={styles.wave} aria-hidden>
            {WAVE.map((h, i) => (
              <span
                key={i}
                style={{ height: h }}
                className={i / WAVE.length < progress ? styles.wavePlayed : undefined}
              />
            ))}
          </div>
          <span className={styles.deckTime}>
            {status === 'loading' ? 'Đang tạo...' : `${formatClock(time.current)} / ${formatClock(time.duration)}`}
          </span>
          <div className={styles.speeds}>
            {SPEEDS.map((s) => (
              <button
                key={s}
                type="button"
                className={`${styles.speed} ${s === speed ? styles.speedActive : ''}`}
                onClick={() => setSpeed(s)}
              >
                {s === 1 ? '1.0' : s}x
              </button>
            ))}
          </div>
        </div>
        {src && (
          <audio
            ref={audioRef}
            src={src}
            autoPlay={status === 'ready'}
            onPlay={() => setPlaying(true)}
            onPause={() => setPlaying(false)}
            onEnded={() => setPlaying(false)}
            onTimeUpdate={(e) => setTime({ current: e.currentTarget.currentTime, duration: e.currentTarget.duration || 0 })}
            onLoadedMetadata={(e) => setTime((t) => ({ ...t, duration: e.currentTarget.duration || 0 }))}
          />
        )}
        {showText && result.feedbackText && (
          <blockquote className={styles.quoteBox}>
            <img src={iconQuote} alt="" width="14.1667" height="12" />
            <p>“{result.feedbackText}”</p>
          </blockquote>
        )}
      </div>
      {error && <p className={styles.notice}>{error}</p>}
    </section>
  )
}

function RubricCard({ rows, questionType, total, band, hasDelivery }) {
  const best = rows.reduce((max, r) => (max && max.score >= r.score ? max : r), null)
  return (
    <section className={styles.card}>
      <div className={styles.cardHeader}>
        <div>
          <h2 className={styles.cardTitle}>Đánh giá theo rubric chấm điểm</h2>
          <p className={styles.muted}>
            {questionTypeLabel(questionType)}: chấm từng tiêu chí thang 1-5, quy đổi theo trọng số về thang 100.
          </p>
        </div>
        <span className={`${styles.bandChip} ${styles[`band_${band.tone}`]}`}>
          {band.label} {total}/100
        </span>
      </div>

      <div className={styles.rubricRows}>
        {rows.map((r) => {
          const meta = CRITERIA[r.code] ?? { key: r.code.charAt(0), label: r.code }
          const points = contribution(r.score, r.weight)
          return (
            <article key={r.code} className={styles.rubricRow}>
              <div className={styles.rowTop}>
                <span className={`${styles.rowKey} ${r.code === 'DELIVERY' ? styles.rowKeyAlt : ''}`}>{meta.key}</span>
                <div className={styles.rowName}>
                  <p>
                    {meta.label}
                    {best?.code === r.code && rows.length > 1 && <span className={styles.bestTag}>Cao nhất</span>}
                  </p>
                  <small>{criterionDesc(r.code, questionType)}</small>
                </div>
                <div className={styles.rowScore}>
                  <p>
                    {formatPoints(r.score)}
                    <small>/5</small>
                  </p>
                  <small>
                    +{formatPoints(points)}/{r.weight} điểm
                  </small>
                </div>
              </div>
              <div className={styles.bar}>
                <div className={styles.barFill} style={{ width: `${Math.max(3, ((r.score - 1) / 4) * 100)}%` }} />
              </div>
              {r.reasoning && (
                <p className={styles.reasoning}>
                  <strong>{r.code === 'DELIVERY' ? 'Đo tự động:' : 'Nhận xét AI:'}</strong> {r.reasoning}
                </p>
              )}
              {r.quote && (
                <p className={`${styles.evidence} ${r.quoteInvalid ? styles.evidenceInvalid : ''}`}>
                  Trích dẫn: “{r.quote}”
                  {r.quoteInvalid && <span> Không khớp với transcript nên điểm tiêu chí này đã bị hạ.</span>}
                </p>
              )}
            </article>
          )
        })}
      </div>

      <p className={styles.formula}>
        Điểm tổng = Σ trọng số × (điểm − 1) / 4. Điểm 1 ứng với 0%, điểm 5 ứng với 100% trọng số.
        {!hasDelivery && ' Thiếu dữ liệu giọng nói nên trọng số Delivery đã chia lại cho các tiêu chí nội dung.'}
      </p>
    </section>
  )
}

function TranscriptCard({ transcript, criteria }) {
  const quotes = criteria.filter((c) => c.quote && !c.quoteInvalid).map((c) => c.quote)
  const segments = highlightTranscript(transcript, quotes)
  return (
    <section className={styles.card}>
      <div className={styles.cardHeader}>
        <h2 className={`${styles.cardTitle} ${styles.withIcon}`}>
          <img src={iconTranscript} alt="" width="18.3333" height="14.6667" />
          Văn bản nhận diện giọng nói (AI Transcript)
        </h2>
        <span className={styles.legend}>
          <span className={styles.legendQuote}>
            <b>A</b> Trích dẫn chấm điểm
          </span>
          <span className={styles.legendFiller}>
            <b>!</b> Từ đệm (Filler Word)
          </span>
        </span>
      </div>
      {transcript ? (
        <p className={styles.transcript}>
          {segments.map((s, i) => {
            const className = [s.quote && styles.hlQuote, s.filler && styles.hlFiller].filter(Boolean).join(' ')
            return className ? (
              <mark key={i} className={className}>
                {s.text}
              </mark>
            ) : (
              <span key={i}>{s.text}</span>
            )
          })}
        </p>
      ) : (
        <p className={styles.muted}>Không có transcript.</p>
      )}
    </section>
  )
}

// Gợi ý nâng cấp: các tiêu chí còn dưới 5 điểm (thấp nhất trước) kèm mô tả mức 5 điểm của rubric
function SuggestionsCard({ rows, questionType, result, sessionId }) {
  const weak = rows
    .filter((r) => r.score < 5)
    .sort((a, b) => a.score - b.score || b.weight - a.weight)
    .slice(0, 3)

  return (
    <section className={styles.card}>
      <div>
        <h2 className={`${styles.cardTitle} ${styles.withIcon}`}>
          <img src={iconTrendUp} alt="" width="20" height="12" />
          Gợi ý nâng cấp câu trả lời
        </h2>
        <p className={styles.muted}>Ưu tiên các tiêu chí còn điểm thấp và có trọng số lớn để tăng điểm tổng nhanh nhất.</p>
      </div>
      {weak.map((r) => (
        <div key={r.code} className={styles.suggestion}>
          <h3>
            <img src={r.code === 'DELIVERY' ? iconChat : iconBulbSm} alt="" width="15" height="15" />
            Nâng {CRITERIA[r.code]?.label ?? r.code} từ {formatPoints(r.score)} lên 5 điểm (+
            {formatPoints(r.weight - contribution(r.score, r.weight))} điểm tổng)
          </h3>
          <p>Mức 5 điểm theo rubric: {anchor5(r.code, questionType)}</p>
        </div>
      ))}
      {result.sampleAnswer && (
        <div className={styles.suggestion}>
          <h3>
            <img src={iconBulbSm} alt="" width="11.25" height="15" />
            Câu trả lời mẫu tham khảo
          </h3>
          <p className={styles.preWrap}>{result.sampleAnswer}</p>
        </div>
      )}
      <div className={styles.actions}>
        <Link className={styles.primaryLink} to={`/practice/${sessionId}`}>
          Luyện lại câu này
        </Link>
        <Link className={styles.secondaryLink} to="/questions">
          Chọn câu hỏi khác
        </Link>
      </div>
    </section>
  )
}

function SessionInfo({ session, result, question }) {
  const level = question ? levelOf(question.level) : null
  return (
    <section className={styles.card}>
      <h3 className={styles.infoTitle}>Thông số phiên luyện tập</h3>
      <dl className={styles.facts}>
        {level && (
          <>
            <dt>Độ khó</dt>
            <dd>
              <span className={`${styles.levelBadge} ${styles[`level_${level.value}`]}`}>
                {level.value === 'MEDIUM' ? 'Trung bình' : level.label}
              </span>
            </dd>
          </>
        )}
        <dt>Thời lượng trả lời</dt>
        <dd>{session.duration ? formatClock(session.duration) : '--'}</dd>
        <dt>Thời điểm chấm</dt>
        <dd>{formatDateTime(session.completedAt ?? session.submittedAt)}</dd>
        <dt>Phiên bản rubric</dt>
        <dd>{result.rubricVersion ?? '--'}</dd>
        {result.delivery?.fillerListVersion && (
          <>
            <dt>Danh sách từ đệm</dt>
            <dd>{result.delivery.fillerListVersion}</dd>
          </>
        )}
      </dl>
    </section>
  )
}

function formatDateTime(value) {
  if (!value) return '--'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return '--'
  return date.toLocaleString('vi-VN', { dateStyle: 'short', timeStyle: 'short' })
}
