import { useEffect, useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router'
import { listHistory } from '../api/history'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import Pagination from '../components/Pagination'
import { formatClock } from '../constants/practice'
import { CRITERIA, scoreBand } from '../constants/scoring'
import { INDUSTRIES } from '../constants/taxonomy'
import { loadQuestion, useProgress } from '../hooks/useProgress'
import styles from './HistoryPage.module.css'

const PAGE_SIZE = 5

const TIME_OPTIONS = [
  { value: '30', label: 'Thời gian: 30 ngày qua' },
  { value: '7', label: 'Thời gian: 7 ngày qua' },
  { value: '90', label: 'Thời gian: 90 ngày qua' },
  { value: 'all', label: 'Thời gian: Tất cả' },
]

const SCORE_OPTIONS = [
  { value: '', label: 'Mức điểm: Tất cả các bài', min: '', max: '' },
  { value: 'excellent', label: 'Mức điểm: Xuất sắc (90+)', min: 90, max: 100 },
  { value: 'great', label: 'Mức điểm: Rất tốt (80-89)', min: 80, max: 89.99 },
  { value: 'improve', label: 'Mức điểm: Cần cải thiện (<80)', min: 0, max: 79.99 },
]

const isoDate = (date) => date.toISOString().slice(0, 10)

export default function HistoryPage() {
  const progress = useProgress()
  const [searchParams, setSearchParams] = useSearchParams()
  const time = searchParams.get('time') ?? '30'
  const industry = searchParams.get('industry') ?? ''
  const scoreKey = searchParams.get('score') ?? ''
  const listKey = searchParams.toString()
  const [keyword, setKeyword] = useState('')
  const [reloadTick, setReloadTick] = useState(0)
  const [list, setList] = useState({ key: null, data: null, error: null, questions: {} })

  useEffect(() => {
    let cancelled = false
    const params = new URLSearchParams(listKey)
    const days = Number(params.get('time') ?? '30')
    const score = SCORE_OPTIONS.find((o) => o.value === (params.get('score') ?? '')) ?? SCORE_OPTIONS[0]
    listHistory({
      page: Math.max(0, Number(params.get('page')) || 0),
      size: PAGE_SIZE,
      industry: params.get('industry') ?? '',
      from: days ? isoDate(new Date(Date.now() - days * 864e5)) : '',
      to: days ? isoDate(new Date()) : '',
      minScore: score.min,
      maxScore: score.max,
    })
      .then(async (data) => {
        const rows = (data.content ?? []).slice(0, PAGE_SIZE)
        const qs = await Promise.all(rows.map((s) => loadQuestion(s.questionId)))
        if (!cancelled)
          setList({
            key: `${listKey}#${reloadTick}`,
            data: { ...data, content: rows },
            error: null,
            questions: Object.fromEntries(rows.map((s, i) => [s.id, qs[i]])),
          })
      })
      .catch((error) => !cancelled && setList({ key: `${listKey}#${reloadTick}`, data: null, error, questions: {} }))
    return () => {
      cancelled = true
    }
  }, [listKey, reloadTick])

  function setFilter(key, value) {
    const params = new URLSearchParams(searchParams)
    if (value && !(key === 'time' && value === '30')) params.set(key, value)
    else params.delete(key)
    params.delete('page')
    setSearchParams(params)
  }

  function goToPage(p) {
    const params = new URLSearchParams(searchParams)
    if (p > 0) params.set('page', String(p))
    else params.delete('page')
    setSearchParams(params)
  }

  if (progress.status === 'ready' && progress.total === 0) return <EmptyHistory />

  const data = list.data
  const total = data?.totalElements ?? 0
  const page = data?.page ?? 0
  const term = keyword.trim().toLowerCase()
  // API lịch sử chưa có tham số từ khoá: lọc trong trang đang xem theo nội dung câu hỏi
  const rows = (data?.content ?? []).filter(
    (s) => !term || (list.questions[s.id]?.content ?? '').toLowerCase().includes(term),
  )

  return (
    <div className="container page">
      <Breadcrumb current="Lịch sử & Tiến độ" />
      <Link to="/questions" className={`btn btn-primary ${styles.newButton}`}>
        <Icon name="mic" size={16} />
        Luyện phiên mới
      </Link>

      <div className={styles.charts}>
        <TrendCard weekly={progress.weekly} loading={progress.status === 'loading'} />
        <CriteriaCard progress={progress} />
      </div>

      <section className={styles.filterBar}>
        <select className={styles.filter} value={time} onChange={(e) => setFilter('time', e.target.value)} aria-label="Thời gian">
          {TIME_OPTIONS.map((o) => (
            <option key={o.value} value={o.value}>
              {o.label}
            </option>
          ))}
        </select>
        <select className={styles.filter} value={industry} onChange={(e) => setFilter('industry', e.target.value)} aria-label="Ngành nghề">
          <option value="">Ngành nghề: Tất cả</option>
          {INDUSTRIES.map((i) => (
            <option key={i.value} value={i.value}>
              Ngành nghề: {i.value}
            </option>
          ))}
        </select>
        <select className={styles.filter} value={scoreKey} onChange={(e) => setFilter('score', e.target.value)} aria-label="Mức điểm">
          {SCORE_OPTIONS.map((o) => (
            <option key={o.value} value={o.value}>
              {o.label}
            </option>
          ))}
        </select>
        <button
          type="button"
          className={styles.refresh}
          onClick={() => {
            setSearchParams(new URLSearchParams())
            setKeyword('')
            setReloadTick((t) => t + 1)
          }}
          aria-label="Đặt lại bộ lọc"
          title="Đặt lại bộ lọc"
        >
          <Icon name="rotateCcw" size={17} />
        </button>
        <label className={styles.search}>
          <Icon name="search" size={16} />
          <span className="visually-hidden">Tìm câu hỏi</span>
          <input value={keyword} onChange={(e) => setKeyword(e.target.value)} placeholder="Tìm câu hỏi, từ khóa, công ty..." />
        </label>
      </section>

      <section className={styles.tableCard}>
        <div className={styles.tableHead}>
          <h2>
            Danh sách các phiên luyện tập đã thực hiện
            {data && <span className="pill pill-indigo">{total} PHIÊN</span>}
          </h2>
          {data && (
            <p>
              Hiển thị {rows.length} trên tổng số {total} bản ghi
            </p>
          )}
        </div>

        {list.error && (
          <p role="alert" className={`alert ${styles.tableAlert}`}>
            Không tải được lịch sử: {list.error.message}
          </p>
        )}

        <div className={styles.tableScroll}>
          <table className={styles.table}>
            <thead>
              <tr>
                <th>Câu hỏi tình huống &amp; chuyên ngành</th>
                <th>Thời gian thực hiện</th>
                <th className={styles.center}>Tổng điểm</th>
                <th>Bản ghi âm &amp; waveform</th>
                <th className={styles.right}>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((s) => (
                <HistoryRow key={s.id} session={s} question={list.questions[s.id]} />
              ))}
              {data && rows.length === 0 && (
                <tr>
                  <td colSpan={5} className={styles.noRows}>
                    Không có phiên nào khớp bộ lọc.
                  </td>
                </tr>
              )}
              {!data && !list.error && (
                <tr>
                  <td colSpan={5} className={styles.noRows}>
                    Đang tải lịch sử...
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {data && data.totalPages > 0 && (
          <div className={styles.pagination}>
            <Pagination
              page={page}
              totalPages={data.totalPages}
              onChange={goToPage}
              summary={`Trang ${page + 1} trên ${data.totalPages} (Tổng ${total} bài luyện)`}
            />
          </div>
        )}
      </section>
    </div>
  )
}

function EmptyHistory() {
  return (
    <div className="container page">
      <Breadcrumb current="Lịch sử & Tiến độ" />
      <h1 className={`page-title ${styles.emptyTitle}`}>Lịch sử &amp; Tiến độ</h1>
      <section className={`card ${styles.empty}`}>
        <span className={styles.emptyEmoji} aria-hidden>
          🎙️
        </span>
        <h2>Bạn chưa có phiên luyện tập nào</h2>
        <p>Chọn một câu hỏi để bắt đầu. Kết quả mỗi lần luyện sẽ được lưu ở đây để bạn theo dõi tiến bộ.</p>
        <Link to="/questions" className="btn btn-primary">
          Chọn câu hỏi
        </Link>
      </section>
    </div>
  )
}

// Biểu đồ đường điểm trung bình theo tuần (SVG, không cần thư viện)
function TrendCard({ weekly, loading }) {
  const W = 640
  const H = 210
  const pad = { l: 18, r: 32, t: 22, b: 8 }
  const n = weekly.length
  const x = (i) => (n <= 1 ? (W - pad.l - pad.r) / 2 + pad.l + 30 : pad.l + 30 + (i * (W - pad.l - pad.r - 60)) / (n - 1))
  const y = (v) => pad.t + ((100 - v) / 100) * (H - pad.t - pad.b)
  const points = weekly.map((w, i) => [x(i), y(w.avg)])
  const line = points.map((p, i) => `${i ? 'L' : 'M'}${p[0]},${p[1]}`).join(' ')
  const area = n ? `${line} L${points.at(-1)[0]},${H - pad.b} L${points[0][0]},${H - pad.b} Z` : ''
  const growth = n > 1 ? weekly.at(-1).avg - weekly[0].avg : null

  return (
    <section className={`card ${styles.trend}`}>
      <div className={styles.chartHead}>
        <div>
          <p className={styles.eyebrowIndigo}>Xu hướng cải thiện</p>
          <h2>
            Điểm số phỏng vấn qua các tuần
            {n > 0 && ` (Tuần ${weekly[0].week}${n > 1 ? ` – Tuần ${weekly.at(-1).week}` : ''})`}
          </h2>
        </div>
        <span className={styles.legend}>
          <i /> Tổng điểm trung bình
        </span>
      </div>

      {loading ? (
        <p className={styles.chartEmpty}>Đang tải...</p>
      ) : n === 0 ? (
        <p className={styles.chartEmpty}>Chưa có phiên nào được chấm để vẽ xu hướng.</p>
      ) : (
        <>
          <div className={styles.chart}>
            <div className={styles.yAxis} aria-hidden>
              {[100, 75, 50, 25, 0].map((v) => (
                <span key={v}>{v}</span>
              ))}
            </div>
            <svg viewBox={`0 0 ${W} ${H}`} className={styles.svg} role="img" aria-label="Điểm trung bình theo tuần">
              <defs>
                <linearGradient id="trendFill" x1="0" x2="0" y1="0" y2="1">
                  <stop offset="0%" stopColor="#3525cd" stopOpacity="0.28" />
                  <stop offset="100%" stopColor="#3525cd" stopOpacity="0.02" />
                </linearGradient>
              </defs>
              {[100, 75, 50, 25].map((v) => (
                <line key={v} x1="0" x2={W} y1={y(v)} y2={y(v)} className={styles.grid} />
              ))}
              <path d={area} fill="url(#trendFill)" />
              <path d={line} className={styles.line} />
              {points.map(([px, py], i) => (
                <g key={i}>
                  <circle cx={px} cy={py} r="5.5" className={weekly[i].current ? styles.dotCurrent : styles.dot} />
                  <text x={px} y={py - 13} textAnchor="middle" className={weekly[i].current ? styles.valueCurrent : styles.value}>
                    {weekly[i].avg.toFixed(1)}
                  </text>
                </g>
              ))}
            </svg>
          </div>
          <div className={styles.xAxis} style={{ '--cols': n }}>
            {weekly.map((w) => (
              <span key={w.week} className={w.current ? styles.xCurrent : undefined}>
                Tuần {w.week}
                {w.current && ' (Hiện tại)'}
              </span>
            ))}
          </div>
        </>
      )}

      {growth != null && (
        <p className={styles.growth}>
          <Icon name="trendUp" size={18} />
          <span>
            Điểm trung bình {growth >= 0 ? 'tăng' : 'giảm'} {growth >= 0 ? '+' : ''}
            {growth.toFixed(1)} điểm sau {n} tuần luyện tập.
          </span>
          <b className={growth >= 0 ? styles.badgeGood : styles.badgeWarn}>{growth >= 0 ? 'Bền vững' : 'Cần chú ý'}</b>
        </p>
      )}
    </section>
  )
}

const CRITERION_BADGE = {
  RELEVANCE: { letter: 'L', cls: 'badgeIndigo' },
  STRUCTURE: { letter: 'C', cls: 'badgeIndigo' },
  DEPTH: { letter: 'Đ', cls: 'badgeGreen' },
  CORRECTNESS: { letter: 'K', cls: 'badgeIndigo' },
  DELIVERY: { letter: 'T', cls: 'badgeAmber' },
}

function CriteriaCard({ progress }) {
  const { criteriaAvg, weights, weakest } = progress
  return (
    <section className={`card ${styles.criteria}`}>
      <div className={styles.chartHead}>
        <div>
          <p className={styles.eyebrowGreen}>Theo rubric</p>
          <h2>Điểm trung bình theo tiêu chí</h2>
        </div>
        <span className="pill pill-indigo">THANG 1–5 / TIÊU CHÍ</span>
      </div>

      {criteriaAvg.length === 0 ? (
        <p className={styles.chartEmpty}>{progress.status === 'loading' ? 'Đang tải...' : 'Chưa có dữ liệu.'}</p>
      ) : (
        <ul className={styles.criteriaList}>
          {criteriaAvg.map((c) => {
            const badge = CRITERION_BADGE[c.code] ?? { letter: '?', cls: 'badgeIndigo' }
            const weak = weakest?.code === c.code
            return (
              <li key={c.code}>
                <div className={styles.criteriaRow}>
                  <span className={`${styles.badge} ${styles[badge.cls]}`}>{badge.letter}</span>
                  <span className={styles.criteriaName}>
                    {CRITERIA[c.code]?.label ?? c.code}
                    {weights?.[c.code] != null && ` (${weights[c.code]}%)`}
                  </span>
                  <strong className={weak ? styles.weakValue : undefined}>{c.avg.toFixed(1)} /5</strong>
                </div>
                <div className={styles.criteriaBar}>
                  <span className={weak ? styles.weakBar : undefined} style={{ width: `${(c.avg / 5) * 100}%` }} />
                </div>
              </li>
            )
          })}
        </ul>
      )}

      {weakest && (
        <div className={styles.advice}>
          <strong>Lời khuyên chiến lược từ InterviewAI</strong>
          <p>
            {CRITERIA[weakest.code]?.label}
            {weights?.[weakest.code] != null && ` (trọng số ${weights[weakest.code]}%)`} đang là tiêu chí thấp nhất (
            {weakest.avg.toFixed(1)}/5). {ADVICE[weakest.code]}
          </p>
        </div>
      )}
    </section>
  )
}

const ADVICE = {
  RELEVANCE: 'Hãy trả lời thẳng vào câu hỏi ngay câu đầu, rồi mới mở rộng bối cảnh.',
  STRUCTURE: 'Hãy theo khung gợi ý của từng loại câu hỏi để câu trả lời có mạch rõ ràng.',
  DEPTH:
    'Hãy thêm ít nhất 2 con số đo được (thời gian, %, số người dùng, chi phí) vào mỗi câu trả lời để tăng điểm nhanh nhất.',
  CORRECTNESS: 'Hãy ôn lại các ý chính của khái niệm và ưu tiên nói đúng, đủ trước khi nói dài.',
}

function formatWhen(value) {
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return { top: '--', bottom: '' }
  const pad = (n) => String(n).padStart(2, '0')
  const time = `${pad(date.getHours())}:${pad(date.getMinutes())}`
  const today = new Date()
  const days = Math.round(
    (new Date(today.getFullYear(), today.getMonth(), today.getDate()) -
      new Date(date.getFullYear(), date.getMonth(), date.getDate())) /
      864e5,
  )
  const full = `${date.getDate()} Tháng ${date.getMonth() + 1}, ${date.getFullYear()}`
  if (days === 0) return { top: `${time} - Hôm nay`, bottom: full }
  if (days === 1) return { top: `${time} - Hôm qua`, bottom: full }
  return { top: `${time} - ${pad(date.getDate())}/${pad(date.getMonth() + 1)}/${date.getFullYear()}`, bottom: `${days} ngày trước` }
}

function HistoryRow({ session, question }) {
  const when = formatWhen(session.completedAt ?? session.submittedAt ?? session.startedAt)
  const score = session.totalScore
  const band = score != null ? scoreBand(score) : null
  return (
    <tr>
      <td>
        <div className={styles.questionCell}>
          <span className={styles.thumb} aria-hidden>
            <Icon name="mic" size={14} />
          </span>
          <div className={styles.questionText}>
            <p title={question?.content}>{question?.content ?? 'Câu hỏi không còn khả dụng'}</p>
            {question && (
              <span>
                <b>{question.industry}</b>
                {question.industry} · {question.position}
              </span>
            )}
          </div>
        </div>
      </td>
      <td>
        <p className={styles.whenTop}>{when.top}</p>
        <p className={styles.whenBottom}>{when.bottom}</p>
      </td>
      <td className={styles.center}>
        {band ? (
          <div className={styles.scoreCell}>
            <span className={`${styles.score} ${styles[`score_${band.tone}`]}`}>
              <Icon name={band.tone === 'green' ? 'starCircle' : 'alert'} size={17} strokeWidth={1.8} />
              {score.toFixed(1)} / 100
            </span>
            <small className={styles[`band_${band.tone}`]}>{band.label}</small>
          </div>
        ) : (
          <span className="muted">--</span>
        )}
      </td>
      <td>
        <MiniPlayer src={session.audioUrl} duration={session.duration} seed={session.id} />
      </td>
      <td className={styles.right}>
        <Link to={`/results/${session.id}`} className={styles.detail}>
          Xem chi tiết
          <Icon name="arrowRight" size={16} />
        </Link>
      </td>
    </tr>
  )
}

// Trình phát gọn trong bảng; sóng âm chỉ để trang trí (lịch sử không có dữ liệu biên độ)
function MiniPlayer({ src, duration, seed }) {
  const audioRef = useRef(null)
  const [playing, setPlaying] = useState(false)
  const bars = Array.from({ length: 8 }, (_, i) => 6 + ((seed?.charCodeAt(i % seed.length) ?? i) * (i + 3)) % 12)

  return (
    <div className={styles.mini}>
      {src && (
        <audio ref={audioRef} src={src} preload="none" onPlay={() => setPlaying(true)} onPause={() => setPlaying(false)} onEnded={() => setPlaying(false)} />
      )}
      <button
        type="button"
        className={styles.miniPlay}
        disabled={!src}
        onClick={() => {
          const a = audioRef.current
          if (!a) return
          if (a.paused) a.play()
          else a.pause()
        }}
        aria-label={playing ? 'Tạm dừng' : 'Nghe bản ghi'}
        title={src ? undefined : 'Bản ghi đã hết hạn lưu trữ'}
      >
        <Icon name={playing ? 'pause' : 'play'} size={11} />
      </button>
      <span className={styles.miniBars} aria-hidden>
        {bars.map((h, i) => (
          <i key={i} style={{ height: h }} className={i < 3 ? styles.miniOn : undefined} />
        ))}
      </span>
      <code>{duration ? formatClock(duration) : '--:--'}</code>
    </div>
  )
}
