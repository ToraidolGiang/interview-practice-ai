import { useEffect, useRef, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router'
import { evaluateSession, getFeedbackAudio, rescoreSession } from '../api/practice'
import { getQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import QuestionPills from '../components/QuestionPills'
import { formatClock } from '../constants/practice'
import {
  anchor5,
  contribution,
  CRITERIA,
  FAILED_MESSAGES,
  fillerVerdict,
  WEIGHTS,
  WPM_IDEAL,
  WPM_SCALE,
  wpmVerdict,
} from '../constants/scoring'
import { questionTypeLabel } from '../constants/taxonomy'
import { useSessionResult } from '../hooks/useSessionResult'
import { useStartPractice } from '../hooks/useStartPractice'
import { fillerBreakdown, highlightTranscript } from '../utils/fillers'
import styles from './ResultsPage.module.css'

const MIN_RESCORE_WORDS = 15

// 20 -> "20.0", 8.75 -> "8.75"
function fmt(value) {
  const n = Number(value) || 0
  return Number.isInteger(Math.round(n * 100) / 10) ? n.toFixed(1) : n.toFixed(2)
}

const wordCount = (text) => (text ?? '').trim().split(/\s+/).filter(Boolean).length

export default function ResultsPage() {
  const { sessionId } = useParams()
  return <ResultsView key={sessionId} sessionId={sessionId} />
}

function ResultsView({ sessionId }) {
  const { phase, session, result, error, pollStartedAt, reload } = useSessionResult(sessionId)
  const [question, setQuestion] = useState(null)
  const [editing, setEditing] = useState(false)

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

  const crumbs = [{ label: 'Phòng luyện tập', to: '/practice' }]
  if (editing) crumbs.push({ label: 'Kết quả chấm điểm', to: `/results/${sessionId}` })

  return (
    <div className="container page">
      <Breadcrumb items={crumbs} current={editing ? 'Sửa transcript' : 'Kết quả chấm điểm'} />

      <div className={styles.stack}>
        {phase === 'loading' && <p className="muted">Đang tải kết quả...</p>}
        {phase === 'error' && (
          <p role="alert" className="alert">
            {error.status === 404 || error.status === 403
              ? 'Không tìm thấy phiên luyện tập này.'
              : `Không tải được kết quả: ${error.message}`}{' '}
            <button type="button" className="link" onClick={reload}>
              Thử lại
            </button>
          </p>
        )}
        {phase === 'processing' && <ProcessingCard startedAt={pollStartedAt} />}
        {phase === 'failed' && <FailedCard session={session} onRetried={reload} />}
        {phase === 'not-submitted' && (
          <section className="card">
            <h2 className="section-title">Phiên này chưa được gửi chấm điểm</h2>
            <p className="muted">Hãy ghi âm và nộp câu trả lời trong phòng luyện tập.</p>
            <Link className={`btn btn-primary ${styles.mt}`} to={`/practice/${sessionId}`}>
              Đến phòng luyện tập
            </Link>
          </section>
        )}
        {phase === 'scored' && (
          <ScoredView
            session={session}
            result={result}
            question={question}
            editing={editing}
            setEditing={setEditing}
            onRescored={() => {
              setEditing(false)
              reload()
            }}
          />
        )}
      </div>
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
    <section className={`card ${styles.processing}`} aria-live="polite">
      <span className="spinner" aria-hidden />
      <h2 className="section-title">AI đang chấm câu trả lời của bạn</h2>
      <p className="muted">
        Nhận dạng giọng nói → tính tốc độ nói, từ đệm → chấm từng tiêu chí theo rubric. Thường mất khoảng 15 giây.
      </p>
      <p className={styles.waited}>Đã chờ {waited} giây</p>
      {waited > 30 && (
        <p className="alert alert-warn">
          Lâu hơn dự kiến. Bạn có thể rời trang, kết quả vẫn được lưu trong Lịch sử & Tiến độ.
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
    <section className={`card ${styles.failed}`}>
      <h2 className="section-title">Chấm điểm không thành công</h2>
      <p>{FAILED_MESSAGES[code] ?? `Đã xảy ra lỗi khi chấm điểm${code ? ` (${code})` : ''}.`}</p>
      {error && (
        <p role="alert" className="alert">
          {error}
        </p>
      )}
      <div className={styles.row}>
        {canRetry && (
          <button type="button" className="btn btn-primary" onClick={retry} disabled={retrying}>
            {retrying ? 'Đang gửi...' : 'Gửi chấm lại'}
          </button>
        )}
        <button type="button" className="btn btn-outline" onClick={() => navigate(`/practice/${session.id}`)}>
          Ghi âm lại
        </button>
      </div>
    </section>
  )
}

/** Tiêu chí nội dung do LLM chấm, kèm trọng số theo loại câu hỏi. */
function contentRows(result, questionType) {
  const weights = WEIGHTS[questionType] ?? {}
  return (result.criteria ?? []).map((c) => ({ ...c, weight: c.weight ?? weights[c.code] ?? 0 }))
}

function deliveryWeight(rows, questionType) {
  // Server không trả trọng số Delivery; lấy theo rubric (10) hoặc phần còn lại để tổng = 100
  return WEIGHTS[questionType]?.DELIVERY ?? Math.max(0, 100 - rows.reduce((sum, r) => sum + r.weight, 0))
}

function ScoredView({ session, result, question, editing, setEditing, onRescored }) {
  const questionType = result.questionType ?? question?.questionType
  const rows = contentRows(result, questionType)
  const delivery = result.delivery
  const dWeight = delivery ? deliveryWeight(rows, questionType) : 0

  return (
    <>
      <HeroCard session={session} result={result} question={question} />
      <FeedbackCard sessionId={session.id} result={result} rows={rows} questionType={questionType} />

      <div className={styles.layout}>
        <div className={styles.mainCol}>
          <CriteriaCard rows={rows} questionType={questionType} />
          {editing ? (
            <TranscriptEditor
              sessionId={session.id}
              transcript={result.transcript}
              onCancel={() => setEditing(false)}
              onDone={onRescored}
            />
          ) : (
            <TranscriptCard result={result} onEdit={() => setEditing(true)} />
          )}
          {result.sampleAnswer && (
            <section className="card">
              <h2 className={styles.cardTitle}>Câu trả lời mẫu tham khảo</h2>
              <p className={styles.sample}>“{result.sampleAnswer}”</p>
              <p className={styles.footnote}>
                Câu trả lời mẫu do AI tạo dựa trên nội dung bạn kể, số liệu chỉ mang tính minh hoạ – hãy thay bằng số
                liệu thật của bạn.
              </p>
            </section>
          )}
        </div>

        <aside className={styles.sideCol}>
          {delivery && <DeliveryCard delivery={delivery} weight={dWeight} transcript={result.transcript} />}
          <TotalCard rows={rows} delivery={delivery} deliveryWeight={dWeight} total={result.totalScore} />
          <section className={`card ${styles.sideCard}`}>
            <h3 className={styles.cardTitle}>Thông tin phiên</h3>
            <dl className={styles.facts}>
              <dt>Thời gian</dt>
              <dd>{formatDateTime(session.completedAt ?? session.submittedAt)}</dd>
              <dt>Loại câu hỏi</dt>
              <dd>{questionType ? questionTypeLabel(questionType) : '--'}</dd>
              <dt>Phiên bản chấm</dt>
              <dd>{result.rubricVersion ?? '--'}</dd>
            </dl>
          </section>
          <p className={styles.disclaimer}>
            <Icon name="info" size={14} />
            Kết quả do AI tạo ra, chỉ dùng để hỗ trợ luyện tập, không phải đánh giá tuyển dụng chính thức.
          </p>
        </aside>
      </div>
    </>
  )
}

function ScoreRing({ value }) {
  const r = 52
  const c = 2 * Math.PI * r
  const pct = Math.min(100, Math.max(0, value)) / 100
  return (
    <div className={styles.ring} role="img" aria-label={`Điểm tổng ${Number(value).toFixed(1)} trên 100`}>
      <svg viewBox="0 0 124 124" width="124" height="124" aria-hidden>
        <circle cx="62" cy="62" r={r} className={styles.ringTrack} />
        <circle
          cx="62"
          cy="62"
          r={r}
          className={styles.ringValue}
          strokeDasharray={`${c * pct} ${c}`}
          transform="rotate(-90 62 62)"
        />
      </svg>
      <span className={styles.ringText}>
        <strong>{Number(value).toFixed(1)}</strong>
        <small>/ 100 điểm</small>
      </span>
    </div>
  )
}

function HeroCard({ session, result, question }) {
  const { start, startingId, error } = useStartPractice()
  const delivery = result.delivery
  return (
    <section className={`card ${styles.hero}`}>
      <ScoreRing value={result.totalScore ?? 0} />
      <div className={styles.heroText}>
        <QuestionPills question={question} />
        <h1 className={styles.heroTitle}>{question?.content ?? 'Câu hỏi luyện tập'}</h1>
        <p className={styles.heroMeta}>
          {result.contentScore != null && (
            <span>
              Nội dung <strong>{fmt(result.contentScore)} / 100</strong>
            </span>
          )}
          {delivery && (
            <span>
              Trình bày <strong>{Number(delivery.deliveryScore).toLocaleString('en-US')} / 5</strong>
            </span>
          )}
          <span>
            Thời lượng{' '}
            <strong>
              {session.duration ? formatClock(session.duration) : '--'} · {wordCount(result.transcript)} từ
            </strong>
          </span>
        </p>
        {error && <p className="field-error">{error}</p>}
      </div>
      <div className={styles.heroActions}>
        <button
          type="button"
          className="btn btn-primary"
          onClick={() => question && start(question.id)}
          disabled={!question || startingId !== null}
        >
          <Icon name="rotateCcw" size={14} strokeWidth={2.4} />
          {startingId ? 'Đang tạo phiên...' : 'Luyện lại câu này'}
        </button>
        <Link to="/questions" className="btn btn-outline">
          Chọn câu hỏi khác
        </Link>
      </div>
    </section>
  )
}

/** Điểm mạnh / cần cải thiện suy ra từ điểm từng tiêu chí và số liệu Delivery. */
function feedbackLists(rows, questionType, result) {
  const strengths = rows.filter((r) => r.score >= 4 && r.reasoning).map((r) => r.reasoning)
  const improvements = rows
    .filter((r) => r.score <= 3)
    .sort((a, b) => a.score - b.score || b.weight - a.weight)
    .map((r) => r.reasoning || anchor5(r.code, questionType))
  const delivery = result.delivery
  if (delivery) {
    if (fillerVerdict(Number(delivery.fillerRate)).score < 5) {
      const top = fillerBreakdown(result.transcript)[0]
      improvements.push(top ? `Bớt “${top.label}” khi nói (${top.count} lần).` : 'Giảm bớt từ đệm khi nói.')
    }
    const wpm = wpmVerdict(delivery.wpm)
    if (wpm.score < 5) improvements.push(`Tốc độ nói ${delivery.wpm} từ/phút, ${wpm.label.toLowerCase()} so với dải ${WPM_IDEAL.join('–')}.`)
  }
  return { strengths, improvements }
}

function FeedbackCard({ sessionId, result, rows, questionType }) {
  const audioRef = useRef(null)
  const [src, setSrc] = useState(result.ttsAudioUrl ?? null)
  const [status, setStatus] = useState('idle') // idle | loading | ready | error
  const [playing, setPlaying] = useState(false)
  const [error, setError] = useState(null)
  const { strengths, improvements } = feedbackLists(rows, questionType, result)

  // UC6: audio TTS chỉ tải khi bấm nghe
  async function toggle() {
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
      setError(err.status === 502 ? 'Dịch vụ đọc nhận xét tạm thời gián đoạn, bạn vẫn đọc được nhận xét bên dưới.' : err.message)
    }
  }

  return (
    <section className="card">
      <div className={styles.cardHead}>
        <h2 className={styles.cardTitle}>Nhận xét của AI</h2>
        <button type="button" className="btn btn-soft" onClick={toggle} disabled={status === 'loading'}>
          <span aria-hidden>🔈</span>
          {status === 'loading' ? 'Đang tạo giọng đọc...' : playing ? 'Tạm dừng' : 'Nghe AI nhận xét'}
        </button>
        {src && (
          <audio
            ref={audioRef}
            src={src}
            autoPlay={status === 'ready'}
            onPlay={() => setPlaying(true)}
            onPause={() => setPlaying(false)}
            onEnded={() => setPlaying(false)}
          />
        )}
      </div>
      {result.feedbackText && <p className={styles.feedback}>{result.feedbackText}</p>}
      {error && <p className={`alert alert-warn ${styles.mt}`}>{error}</p>}
      <Warnings result={result} />

      <div className={styles.lists}>
        <div className={styles.strengths}>
          <h3>Điểm mạnh</h3>
          <ul>
            {(strengths.length ? strengths : ['Bạn đã hoàn thành câu trả lời, hãy tiếp tục luyện để có điểm mạnh rõ hơn.']).map(
              (text) => (
                <li key={text}>
                  <Icon name="check" size={13} strokeWidth={2.4} />
                  {text}
                </li>
              ),
            )}
          </ul>
        </div>
        <div className={styles.improvements}>
          <h3>Cần cải thiện</h3>
          <ul>
            {(improvements.length ? improvements : ['Giữ phong độ: các tiêu chí đều đạt từ 4 điểm trở lên.']).map((text) => (
              <li key={text}>
                <Icon name="arrowRight" size={13} strokeWidth={2.2} />
                {text}
              </li>
            ))}
          </ul>
        </div>
      </div>
    </section>
  )
}

function Warnings({ result }) {
  const items = []
  if (result.offTopic) items.push('Câu trả lời được đánh giá là lạc đề so với câu hỏi, điểm tổng bị giới hạn tối đa 30.')
  if (result.injectionSuspected)
    items.push('Phát hiện nội dung có dấu hiệu yêu cầu thao túng điểm. Kết quả vẫn được chấm theo nội dung thật.')
  if (!result.delivery)
    items.push('Không đủ dữ liệu để chấm Trình bày (dưới 30 từ). Trọng số 10% đã chia lại cho các tiêu chí nội dung.')
  if (!items.length) return null
  return (
    <div className={`alert alert-warn ${styles.mt}`} role="status">
      {items.map((text) => (
        <p key={text}>{text}</p>
      ))}
    </div>
  )
}

function SegmentBar({ score }) {
  const tone = score >= 4 ? styles.segGreen : styles.segAmber
  return (
    <span className={styles.segments} aria-hidden>
      {[1, 2, 3, 4, 5].map((i) => (
        <span key={i} className={i <= score ? tone : undefined} />
      ))}
    </span>
  )
}

function CriteriaCard({ rows, questionType }) {
  const typeLabel = questionType ? questionTypeLabel(questionType).toLowerCase() : ''
  return (
    <section className="card">
      <h2 className={styles.cardTitle}>Điểm nội dung theo tiêu chí</h2>
      <p className={styles.cardSub}>
        Rubric cho câu hỏi {typeLabel}. Mỗi tiêu chí chấm 1–5 kèm trích dẫn từ câu trả lời của bạn; tổng điểm do hệ
        thống tính theo trọng số.
      </p>
      <div className={styles.criteria}>
        {rows.map((r) => (
          <article key={r.code} className={styles.criterion}>
            <div className={styles.criterionHead}>
              <h3>
                {CRITERIA[r.code]?.label ?? r.code}
                {r.code === 'STRUCTURE' && questionType === 'BEHAVIORAL' && ' (STAR)'}
                <span className="pill pill-gray">{r.weight}%</span>
              </h3>
              <span className={styles.criterionScore}>
                <SegmentBar score={r.score} />
                {r.score}/5
              </span>
            </div>
            {r.reasoning && <p className={styles.reasoning}>{r.reasoning}</p>}
            {r.quote && (
              <blockquote className={`${styles.quote} ${r.quoteInvalid ? styles.quoteInvalid : ''}`}>
                “{r.quote}”
                {r.quoteInvalid && <small>Trích dẫn không khớp transcript nên điểm tiêu chí này đã bị hạ.</small>}
              </blockquote>
            )}
            <p className={styles.contribution}>
              Đóng góp {fmt(contribution(r.score, r.weight))} / {r.weight} điểm
            </p>
          </article>
        ))}
      </div>
    </section>
  )
}

function DeliveryCard({ delivery, weight, transcript }) {
  const wpm = wpmVerdict(delivery.wpm)
  const filler = fillerVerdict(Number(delivery.fillerRate))
  const [lo, hi] = WPM_SCALE
  const pos = (v) => `${Math.min(100, Math.max(0, ((v - lo) / (hi - lo)) * 100))}%`
  const breakdown = fillerBreakdown(transcript)

  return (
    <section className={`card ${styles.sideCard}`}>
      <div className={styles.deliveryHead}>
        <h2 className={styles.cardTitle}>
          Trình bày <span className="pill pill-gray">{weight}%</span>
        </h2>
        <strong>{Number(delivery.deliveryScore).toLocaleString('en-US')}/5</strong>
      </div>
      <p className={styles.cardSub}>Tính tự động từ thời lượng và transcript, tách riêng khỏi điểm nội dung.</p>

      <div className={styles.metric}>
        <p>
          <strong>{delivery.wpm}</strong> từ/phút
        </p>
        <span className={`pill pill-${wpm.tone}`}>
          {wpm.score}/5 · {wpm.label}
        </span>
      </div>
      <div className={styles.scale} aria-hidden>
        <span className={styles.scaleIdeal} style={{ left: pos(WPM_IDEAL[0]), right: `calc(100% - ${pos(WPM_IDEAL[1])})` }} />
        <span className={styles.scaleDot} style={{ left: pos(delivery.wpm) }} />
      </div>
      <div className={styles.scaleLabels}>
        <span>Chậm</span>
        <span>{WPM_IDEAL.join('–')} lý tưởng</span>
        <span>Nhanh</span>
      </div>

      <div className={`${styles.metric} ${styles.metricDivider}`}>
        <p>
          <strong>{delivery.fillerCount}</strong> từ đệm · {Number(delivery.fillerRate).toLocaleString('en-US')} / 100 từ
        </p>
        <span className={`pill pill-${filler.tone}`}>
          {filler.score}/5 · {filler.label}
        </span>
      </div>
      {breakdown.length > 0 && (
        <div className={styles.fillers}>
          {breakdown.map((f) => (
            <span key={f.label} className="pill pill-amber">
              {f.label.includes(' ') && f.label.split(' ')[0] === f.label.split(' ')[1]
                ? `lặp từ “${f.label}”`
                : `“${f.label}”`}{' '}
              ×{f.count}
            </span>
          ))}
        </div>
      )}
      <p className={styles.footnote}>
        Không tính “thì”, “là”, “mà” vì đây là từ thông dụng trong tiếng Việt. Mục tiêu: dưới 2 từ đệm / 100 từ.
      </p>
      <p className={styles.contribution}>
        Đóng góp {fmt(contribution(Number(delivery.deliveryScore), weight))} / {weight} điểm
      </p>
    </section>
  )
}

function TotalCard({ rows, delivery, deliveryWeight: dWeight, total }) {
  const lines = rows.map((r) => ({
    label: `${CRITERIA[r.code]?.label ?? r.code} · ${r.score}/5`,
    value: contribution(r.score, r.weight),
  }))
  if (delivery)
    lines.push({
      label: `Trình bày · ${Number(delivery.deliveryScore).toLocaleString('en-US')}/5`,
      value: contribution(Number(delivery.deliveryScore), dWeight),
    })
  return (
    <section className={`card ${styles.sideCard}`}>
      <h2 className={styles.cardTitle}>Cách tính tổng điểm</h2>
      <dl className={styles.sum}>
        {lines.map((l) => (
          <div key={l.label}>
            <dt>{l.label}</dt>
            <dd>{fmt(l.value)}</dd>
          </div>
        ))}
      </dl>
      <div className={styles.sumTotal}>
        <span>Tổng</span>
        <strong>{Number(total ?? 0).toFixed(1)} / 100</strong>
      </div>
      <p className={styles.footnote}>Mỗi tiêu chí: trọng số × (điểm − 1) / 4. Điểm 1 = 0%, điểm 5 = 100% trọng số.</p>
    </section>
  )
}

function TranscriptCard({ result, onEdit }) {
  const quotes = (result.criteria ?? []).filter((c) => c.quote && !c.quoteInvalid).map((c) => c.quote)
  const segments = highlightTranscript(result.transcript, quotes)
  return (
    <section className="card">
      <div className={styles.cardHead}>
        <h2 className={styles.cardTitle}>Transcript câu trả lời</h2>
        <button type="button" className="btn btn-outline" onClick={onEdit} disabled={!result.transcript}>
          <Icon name="edit" size={14} />
          Sửa transcript & chấm lại
        </button>
      </div>
      <div className={styles.legend}>
        <span>
          <i className={styles.legendFiller} /> Từ đệm
        </span>
        <span>
          <i className={styles.legendQuote} /> Đoạn được trích dẫn khi chấm
        </span>
      </div>
      {result.transcript ? (
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
        <p className="muted">Không có transcript.</p>
      )}
      <p className={styles.footnote}>
        Nhận dạng giọng nói có thể sai vài từ. Sửa lại transcript rồi chấm lại, hệ thống không cần ghi âm lại.
      </p>
    </section>
  )
}

function TranscriptEditor({ sessionId, transcript, onCancel, onDone }) {
  const [text, setText] = useState(transcript ?? '')
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState(null)
  const words = wordCount(text)

  async function save() {
    if (words < MIN_RESCORE_WORDS) {
      setError(`Transcript cần tối thiểu ${MIN_RESCORE_WORDS} từ.`)
      return
    }
    setSaving(true)
    setError(null)
    try {
      await rescoreSession(sessionId, text.trim())
      onDone()
    } catch (err) {
      setError(
        err.code === 'SESSION_PROCESSING'
          ? 'Phiên đang được chấm, vui lòng đợi rồi thử lại.'
          : err.code === 'ANSWER_TOO_SHORT'
            ? `Transcript cần tối thiểu ${MIN_RESCORE_WORDS} từ.`
            : err.message,
      )
      setSaving(false)
    }
  }

  return (
    <section className={`card ${styles.editor}`}>
      <div className={styles.cardHead}>
        <h2 className={styles.cardTitle}>Sửa transcript</h2>
        <div className={styles.row}>
          <button type="button" className="btn btn-outline" onClick={onCancel} disabled={saving}>
            <Icon name="x" size={14} />
            Huỷ
          </button>
          <button type="button" className="btn btn-primary" onClick={save} disabled={saving || text.trim() === transcript}>
            <Icon name="refresh" size={14} />
            {saving ? 'Đang gửi...' : 'Lưu & chấm lại'}
          </button>
        </div>
      </div>
      <label className="visually-hidden" htmlFor="transcript-editor">
        Transcript
      </label>
      <textarea
        id="transcript-editor"
        className={`textarea ${styles.editorArea}`}
        value={text}
        onChange={(e) => setText(e.target.value)}
        rows={9}
      />
      {error && (
        <p role="alert" className="field-error">
          {error}
        </p>
      )}
      <p className={styles.footnote}>
        Chỉ sửa những từ bị nhận dạng sai, giữ nguyên nội dung bạn đã nói. Khi chấm lại, hệ thống dùng transcript này
        và không gọi lại nhận dạng giọng nói.
      </p>
    </section>
  )
}

function formatDateTime(value) {
  if (!value) return '--'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return '--'
  const pad = (n) => String(n).padStart(2, '0')
  return `${pad(date.getDate())}/${pad(date.getMonth() + 1)}/${date.getFullYear()}, ${pad(date.getHours())}:${pad(date.getMinutes())}`
}
