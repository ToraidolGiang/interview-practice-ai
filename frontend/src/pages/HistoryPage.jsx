import { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router'
import iconArrowRight from '../assets/figma/icon-arrow-right.svg'
import iconArrowRightSm from '../assets/figma/icon-arrow-right-sm.svg'
import iconDownload from '../assets/figma/icon-download.svg'
import iconKpiCheck from '../assets/figma/icon-kpi-check.svg'
import iconKpiGauge from '../assets/figma/icon-kpi-gauge.svg'
import iconKpiSparkle from '../assets/figma/icon-kpi-sparkle.svg'
import iconKpiVideo from '../assets/figma/icon-kpi-video.svg'
import iconKpiVoice from '../assets/figma/icon-kpi-voice.svg'
import iconMicOutline from '../assets/figma/icon-mic-outline.svg'
import iconPlaySmall from '../assets/figma/icon-play-small.svg'
import iconRefresh from '../assets/figma/icon-refresh.svg'
import iconScoreStar from '../assets/figma/icon-score-star.svg'
import iconScoreWarn from '../assets/figma/icon-score-warn.svg'
import iconTrendSparkline from '../assets/figma/icon-trend-sparkline.svg'
import { getHistoryDetail, listHistory } from '../api/history'
import { getQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import Pagination from '../components/Pagination'
import { formatClock } from '../constants/practice'
import { CRITERIA, formatPoints, scoreBand, WPM_IDEAL } from '../constants/scoring'
import { INDUSTRIES, industryLabel } from '../constants/taxonomy'
import styles from './HistoryPage.module.css'

const PAGE_SIZE = 5
const RECENT_COUNT = 10

const TIME_OPTIONS = [
  { value: '', label: 'Thời gian: Tất cả' },
  { value: '7', label: 'Thời gian: 7 ngày qua' },
  { value: '30', label: 'Thời gian: 30 ngày qua' },
  { value: '90', label: 'Thời gian: 90 ngày qua' },
]

const SCORE_OPTIONS = [
  { value: '', label: 'Mức điểm: Tất cả các bài', min: '', max: '' },
  { value: 'excellent', label: 'Mức điểm: Xuất sắc (85-100)', min: 85, max: 100 },
  { value: 'good', label: 'Mức điểm: Tốt (70-84)', min: 70, max: 84.99 },
  { value: 'fair', label: 'Mức điểm: Đạt (50-69)', min: 50, max: 69.99 },
  { value: 'weak', label: 'Mức điểm: Cần cải thiện (<50)', min: 0, max: 49.99 },
]

const isoDate = (date) => date.toISOString().slice(0, 10)

// Cache nội dung câu hỏi: API lịch sử chỉ trả questionId
const questionCache = new Map()
function loadQuestion(id) {
  if (!questionCache.has(id)) questionCache.set(id, getQuestion(id).catch(() => null))
  return questionCache.get(id)
}

function average(values) {
  const list = values.filter((v) => typeof v === 'number' && !Number.isNaN(v))
  return list.length ? list.reduce((a, b) => a + b, 0) / list.length : null
}

/** Thống kê từ các phiên gần nhất (kèm scoreResult): KPI, xu hướng, điểm trung bình theo tiêu chí. */
function useProgress() {
  const [state, setState] = useState({ status: 'loading', total: 0, recent: [], latestQuestion: null })

  useEffect(() => {
    let cancelled = false
    listHistory({ page: 0, size: RECENT_COUNT })
      .then(async (page) => {
        const sessions = (page.content ?? []).slice(0, RECENT_COUNT)
        const details = await Promise.all(sessions.map((s) => getHistoryDetail(s.id).catch(() => ({ ...s }))))
        const latestQuestion = sessions[0] ? await loadQuestion(sessions[0].questionId) : null
        if (!cancelled)
          setState({ status: 'ready', total: page.totalElements ?? sessions.length, recent: details, latestQuestion })
      })
      .catch(() => !cancelled && setState((s) => ({ ...s, status: 'error' })))
    return () => {
      cancelled = true
    }
  }, [])

  return useMemo(() => {
    const recent = state.recent
    // Mới nhất trước: nửa đầu là gần đây, nửa sau là trước đó
    const half = Math.ceil(recent.length / 2)
    const newer = recent.slice(0, half)
    const older = recent.slice(half)
    const score = (list) => average(list.map((d) => d.totalScore))
    const filler = (list) => average(list.map((d) => Number(d.scoreResult?.delivery?.fillerRate)))

    const criteria = {}
    for (const d of recent) {
      for (const c of d.scoreResult?.criteria ?? []) (criteria[c.code] ??= []).push(c.score)
      const delivery = d.scoreResult?.delivery
      if (delivery) (criteria.DELIVERY ??= []).push(Number(delivery.deliveryScore))
    }
    const criteriaAvg = Object.entries(criteria)
      .map(([code, scores]) => ({ code, avg: average(scores), count: scores.length }))
      .sort((a, b) => Object.keys(CRITERIA).indexOf(a.code) - Object.keys(CRITERIA).indexOf(b.code))

    return {
      ...state,
      avgScore: score(recent),
      scoreDelta: older.length ? score(newer) - score(older) : null,
      avgWpm: average(recent.map((d) => d.scoreResult?.delivery?.wpm)),
      avgFiller: filler(recent),
      fillerDelta: older.length && filler(older) != null ? filler(newer) - filler(older) : null,
      trend: [...recent].reverse().map((d) => ({ score: d.totalScore, at: d.completedAt })),
      criteriaAvg,
    }
  }, [state])
}

export default function HistoryPage() {
  const navigate = useNavigate()
  const progress = useProgress()
  const [searchParams, setSearchParams] = useSearchParams()
  const time = searchParams.get('time') ?? ''
  const industry = searchParams.get('industry') ?? ''
  const scoreKey = searchParams.get('score') ?? ''
  const page = Math.max(0, Number(searchParams.get('page')) || 0)
  const listKey = searchParams.toString()

  const [list, setList] = useState({ key: null, data: null, error: null, questions: {} })

  useEffect(() => {
    let cancelled = false
    const params = new URLSearchParams(listKey)
    const days = Number(params.get('time'))
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
            key: listKey,
            data: { ...data, content: rows },
            error: null,
            questions: Object.fromEntries(rows.map((s, i) => [s.id, qs[i]])),
          })
      })
      .catch((error) => !cancelled && setList({ key: listKey, data: null, error, questions: {} }))
    return () => {
      cancelled = true
    }
  }, [listKey])

  function setFilter(key, value) {
    const params = new URLSearchParams(searchParams)
    if (value) params.set(key, value)
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

  const loading = list.key !== listKey
  const data = list.data
  const total = data?.totalElements ?? 0
  const filtersActive = !!(time || industry || scoreKey)

  return (
    <div className={styles.page}>
      <Breadcrumb current="Lịch sử & Tiến độ">
        <button type="button" className={styles.ghostButton} onClick={() => window.print()}>
          <img src={iconDownload} alt="" width="16" height="16" />
          Xuất PDF báo cáo
        </button>
        <Link to="/practice" className={styles.primaryButton}>
          <img src={iconMicOutline} alt="" width="14" height="19" />
          Luyện phiên mới
        </Link>
      </Breadcrumb>

      <Banner progress={progress} />
      <KpiCards progress={progress} />

      {progress.recent.length > 0 && (
        <div className={styles.twoCol}>
          <TrendCard trend={progress.trend} />
          <CriteriaCard criteriaAvg={progress.criteriaAvg} />
        </div>
      )}

      <section className={styles.filterBar}>
        <div className={styles.filters}>
          <FilterSelect value={time} onChange={(v) => setFilter('time', v)} options={TIME_OPTIONS} label="Thời gian" />
          <FilterSelect
            value={industry}
            onChange={(v) => setFilter('industry', v)}
            label="Ngành nghề"
            options={[
              { value: '', label: 'Ngành nghề: Tất cả' },
              ...INDUSTRIES.map((i) => ({ value: i.value, label: `Ngành nghề: ${i.chipLabel}` })),
            ]}
          />
          <FilterSelect value={scoreKey} onChange={(v) => setFilter('score', v)} options={SCORE_OPTIONS} label="Mức điểm" />
          <button
            type="button"
            className={styles.resetButton}
            onClick={() => setSearchParams(new URLSearchParams())}
            disabled={!filtersActive}
            aria-label="Xóa bộ lọc"
            title="Xóa bộ lọc"
          >
            <img src={iconRefresh} alt="" width="16" height="18.45" />
          </button>
        </div>
      </section>

      <section className={styles.tableCard}>
        <div className={styles.tableHeader}>
          <div className={styles.tableHeading}>
            <h2>Danh sách các phiên luyện tập đã thực hiện</h2>
            {data && <span className={styles.countBadge}>{total} PHIÊN</span>}
          </div>
          {data && total > 0 && (
            <p className={styles.muted}>
              Hiển thị {data.content.length} trên tổng số {total} bản ghi
            </p>
          )}
        </div>

        {list.error && (
          <p role="alert" className={styles.alert}>
            Không tải được lịch sử: {list.error.message}
          </p>
        )}
        {loading && !data && <p className={styles.empty}>Đang tải lịch sử...</p>}
        {data && total === 0 && (
          <div className={styles.empty}>
            <p>{filtersActive ? 'Không có phiên nào khớp bộ lọc.' : 'Bạn chưa có phiên luyện tập nào được chấm.'}</p>
            <Link to="/practice" className={styles.primaryButton}>
              Bắt đầu luyện tập
            </Link>
          </div>
        )}

        {data && total > 0 && (
          <div className={`${styles.tableWrap} ${loading ? styles.loading : ''}`}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Câu hỏi &amp; chuyên ngành</th>
                  <th>Thời gian thực hiện</th>
                  <th>Điểm tổng hợp</th>
                  <th>Bản ghi âm</th>
                  <th className={styles.right}>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {data.content.map((s) => (
                  <HistoryRow
                    key={s.id}
                    session={s}
                    question={list.questions[s.id]}
                    onOpen={() => navigate(`/results/${s.id}`)}
                  />
                ))}
              </tbody>
            </table>
          </div>
        )}

        {data && total > 0 && (
          <Pagination
            page={data.page ?? page}
            size={data.size ?? PAGE_SIZE}
            totalElements={total}
            totalPages={data.totalPages ?? 1}
            itemLabel="phiên"
            onChange={goToPage}
          />
        )}
      </section>
    </div>
  )
}

function Banner({ progress }) {
  if (progress.status === 'loading') return <section className={`${styles.banner} ${styles.bannerLoading}`} aria-busy />
  const latest = progress.recent[0]
  const weakest = [...progress.criteriaAvg].sort((a, b) => a.avg - b.avg)[0]

  return (
    <section className={styles.banner}>
      <div className={styles.bannerText}>
        <p className={styles.bannerEyebrow}>
          <span className={styles.bannerTag}>{latest ? 'Phiên gần nhất' : 'Bắt đầu'}</span>
          {latest && <span>{relativeTime(latest.completedAt)}</span>}
        </p>
        <h2 className={styles.bannerTitle}>
          {latest
            ? `Đạt ${formatPoints(latest.totalScore)}/100: ${progress.latestQuestion?.content ?? 'câu hỏi luyện tập'}`
            : 'Luyện phiên đầu tiên để bắt đầu theo dõi tiến độ'}
        </h2>
        <p className={styles.bannerSub}>
          {latest && weakest
            ? `Tiêu chí cần cải thiện nhất trong ${progress.recent.length} phiên gần đây là ${CRITERIA[weakest.code]?.label} (trung bình ${formatPoints(weakest.avg)}/5). Bấm vào một phiên bên dưới để xem chi tiết chấm điểm.`
            : 'Kết quả mỗi phiên được lưu tại đây để bạn xem lại điểm, nhận xét và phản hồi giọng nói bất cứ lúc nào.'}
        </p>
      </div>
      <div className={styles.bannerActions}>
        {latest && (
          <Link to={`/results/${latest.id}`} className={styles.bannerGhost}>
            Xem kết quả gần nhất
          </Link>
        )}
        <Link to="/practice" className={styles.bannerButton}>
          Vào phòng luyện ngay
          <img src={iconArrowRight} alt="" width="16" height="16" />
        </Link>
      </div>
    </section>
  )
}

function KpiCards({ progress }) {
  const ready = progress.status === 'ready'
  const n = progress.recent.length
  const wpmIdeal = progress.avgWpm != null && progress.avgWpm >= WPM_IDEAL[0] && progress.avgWpm <= WPM_IDEAL[1]
  return (
    <div className={styles.kpis}>
      <Kpi
        tone="brand"
        label="Tổng buổi đã luyện"
        icon={[iconKpiVideo, 20, 16]}
        value={ready ? progress.total : '--'}
        unit="buổi"
        foot={n ? `${n} phiên gần nhất dùng để tính các chỉ số bên cạnh` : 'Chưa có phiên nào được chấm'}
      />
      <Kpi
        tone="green"
        label="Điểm trung bình"
        icon={[iconKpiSparkle, 22, 22]}
        value={progress.avgScore != null ? formatPoints(progress.avgScore) : '--'}
        unit="/ 100"
        accent
        foot={
          progress.scoreDelta != null ? (
            <Delta value={progress.scoreDelta} suffix=" điểm so với các phiên trước" />
          ) : (
            'Theo thang 100 của rubric'
          )
        }
      />
      <Kpi
        tone="indigo"
        label="Tốc độ nói trung bình"
        icon={[iconKpiGauge, 20.0017, 16]}
        value={progress.avgWpm != null ? Math.round(progress.avgWpm) : '--'}
        unit="WPM"
        foot={
          <>
            {progress.avgWpm != null && (
              <b className={wpmIdeal ? styles.good : styles.warn}>{wpmIdeal ? 'CHUẨN' : 'CẦN CHỈNH'}</b>
            )}{' '}
            Tối ưu {WPM_IDEAL[0]}-{WPM_IDEAL[1]} WPM
          </>
        }
      />
      <Kpi
        tone="amber"
        label="Tỷ lệ từ đệm"
        icon={[iconKpiVoice, 22, 18.95]}
        value={progress.avgFiller != null ? progress.avgFiller.toLocaleString('en-US', { maximumFractionDigits: 1 }) : '--'}
        unit="/ 100 từ"
        foot={
          <>
            <img src={iconKpiCheck} alt="" width="14" height="14" />
            {progress.fillerDelta != null ? (
              <Delta value={progress.fillerDelta} invert suffix=" so với các phiên trước" />
            ) : (
              'Tốt nhất ≤ 2 từ đệm trên 100 từ'
            )}
          </>
        }
      />
    </div>
  )
}

function Kpi({ tone, label, icon: [src, w, h], value, unit, foot, accent }) {
  return (
    <div className={`${styles.kpi} ${styles[`kpi_${tone}`]}`}>
      <div className={styles.kpiTop}>
        <span className={styles.kpiLabel}>{label}</span>
        <span className={styles.kpiIcon}>
          <img src={src} alt="" width={w} height={h} />
        </span>
      </div>
      <p className={styles.kpiValue}>
        <span className={accent ? styles.kpiAccent : undefined}>{value}</span>
        <small> {unit}</small>
      </p>
      <p className={styles.kpiFoot}>{foot}</p>
    </div>
  )
}

function Delta({ value, suffix, invert }) {
  const better = invert ? value < 0 : value > 0
  const sign = value > 0 ? '+' : ''
  return (
    <span>
      <b className={better ? styles.good : styles.warn}>
        {sign}
        {value.toLocaleString('en-US', { maximumFractionDigits: 1 })}
      </b>
      {suffix}
    </span>
  )
}

function TrendCard({ trend }) {
  const W = 600
  const H = 200
  const pad = { l: 28, r: 16, t: 16, b: 28 }
  const n = trend.length
  const x = (i) => pad.l + (n === 1 ? (W - pad.l - pad.r) / 2 : (i * (W - pad.l - pad.r)) / (n - 1))
  const y = (v) => pad.t + (1 - v / 100) * (H - pad.t - pad.b)
  const points = trend.map((p, i) => [x(i), y(p.score ?? 0)])
  const line = points.map((p) => p.join(',')).join(' ')
  const area = n ? `${pad.l},${H - pad.b} ${line} ${points.at(-1)[0]},${H - pad.b}` : ''
  const change = n > 1 ? trend.at(-1).score - trend[0].score : 0

  return (
    <section className={styles.card}>
      <div className={styles.cardHead}>
        <div>
          <p className={styles.eyebrow}>Xu hướng cải thiện</p>
          <h3 className={styles.cardTitle}>Điểm tổng qua {n} phiên gần nhất</h3>
        </div>
        <span className={styles.legend}>
          <span className={styles.legendDot} /> Điểm tổng (thang 100)
        </span>
      </div>
      <svg viewBox={`0 0 ${W} ${H}`} className={styles.chart} role="img" aria-label="Biểu đồ điểm tổng theo phiên">
        <defs>
          <linearGradient id="trendFill" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0" stopColor="#3525cd" stopOpacity="0.22" />
            <stop offset="1" stopColor="#3525cd" stopOpacity="0" />
          </linearGradient>
        </defs>
        {[0, 25, 50, 75, 100].map((v) => (
          <g key={v}>
            <line x1={pad.l} x2={W - pad.r} y1={y(v)} y2={y(v)} className={styles.gridLine} />
            <text x={4} y={y(v) + 3} className={styles.axisText}>
              {v}
            </text>
          </g>
        ))}
        <polygon points={area} fill="url(#trendFill)" />
        <polyline points={line} className={styles.trendLine} />
        {points.map(([px, py], i) => (
          <g key={i}>
            <circle cx={px} cy={py} r="5" className={i === n - 1 ? styles.trendDotLast : styles.trendDot} />
            <text x={px} y={py - 10} textAnchor="middle" className={i === n - 1 ? styles.pointTextLast : styles.pointText}>
              {formatPoints(trend[i].score)}
            </text>
            <text
              x={px}
              y={H - 8}
              textAnchor={i === n - 1 && n > 1 ? 'end' : i === 0 && n > 1 ? 'start' : 'middle'}
              className={i === n - 1 ? styles.axisTextLast : styles.axisText}
            >
              {i === n - 1 ? 'Gần nhất' : shortDate(trend[i].at)}
            </text>
          </g>
        ))}
      </svg>
      {n > 1 && (
        <p className={styles.trendNote}>
          <img src={iconTrendSparkline} alt="" width="22" height="17" />
          <span>
            Điểm tổng {change >= 0 ? 'tăng' : 'giảm'} {formatPoints(Math.abs(change))} điểm từ phiên đầu đến phiên gần nhất
            trong {n} phiên.
          </span>
          <b className={change >= 0 ? styles.good : styles.warn}>{change >= 0 ? 'Tiến bộ' : 'Cần chú ý'}</b>
        </p>
      )}
    </section>
  )
}

function CriteriaCard({ criteriaAvg }) {
  const weakest = [...criteriaAvg].sort((a, b) => a.avg - b.avg)[0]
  return (
    <section className={styles.card}>
      <div className={styles.cardHead}>
        <div>
          <p className={styles.eyebrow}>Chẩn đoán theo rubric</p>
          <h3 className={styles.cardTitle}>Điểm trung bình từng tiêu chí</h3>
        </div>
        <span className={styles.pill}>Thang 1-5</span>
      </div>
      <div className={styles.criteria}>
        {criteriaAvg.map((c) => {
          const meta = CRITERIA[c.code] ?? { key: c.code[0], label: c.code }
          const tone = c.avg >= 4 ? 'good' : c.avg >= 3 ? 'brand' : 'warn'
          return (
            <div key={c.code} className={styles.criterion}>
              <div className={styles.criterionTop}>
                <span className={styles.criterionName}>
                  <span className={styles.criterionKey}>{meta.key}</span>
                  {meta.label}
                </span>
                <span className={`${styles.criterionScore} ${styles[tone]}`}>
                  {formatPoints(c.avg)} <small>/5</small>
                </span>
              </div>
              <div className={styles.track}>
                <div className={`${styles.fill} ${styles[`fill_${tone}`]}`} style={{ width: `${(c.avg / 5) * 100}%` }} />
              </div>
            </div>
          )
        })}
      </div>
      {weakest && (
        <div className={styles.advice}>
          <p className={styles.adviceTitle}>Lời khuyên từ TalentSTAR AI</p>
          <p>
            {CRITERIA[weakest.code]?.label} đang thấp nhất ({formatPoints(weakest.avg)}/5). Để đạt 5 điểm:{' '}
            {CRITERIA[weakest.code]?.anchor5}
          </p>
        </div>
      )}
    </section>
  )
}

function FilterSelect({ value, onChange, options, label }) {
  return (
    <select className={styles.select} value={value} onChange={(e) => onChange(e.target.value)} aria-label={label}>
      {options.map((o) => (
        <option key={o.value} value={o.value}>
          {o.label}
        </option>
      ))}
    </select>
  )
}

// Phát bản ghi âm của phiên ngay trong bảng (một audio dùng chung, phát cái này thì dừng cái khác)
let sharedAudio = null
function HistoryRow({ session, question, onOpen }) {
  const score = session.totalScore ?? 0
  const band = scoreBand(score)
  const good = score >= 70
  const [playing, setPlaying] = useState(false)
  const audioRef = useRef(null)

  useEffect(() => () => audioRef.current?.pause(), [])

  function togglePlay(e) {
    e.stopPropagation()
    if (!session.audioUrl) return
    if (playing) {
      audioRef.current?.pause()
      return
    }
    sharedAudio?.pause()
    const audio = new Audio(session.audioUrl)
    audio.onended = () => setPlaying(false)
    audio.onpause = () => setPlaying(false)
    audio.play().then(() => setPlaying(true)).catch(() => setPlaying(false))
    audioRef.current = audio
    sharedAudio = audio
  }

  return (
    <tr className={styles.row} onClick={onOpen}>
      <td>
        <div className={styles.questionCell}>
          <span className={styles.questionAvatar} aria-hidden>
            {(question?.industry ?? '?').charAt(0)}
          </span>
          <div className={styles.questionText}>
            <p className={styles.questionTitle} title={question?.content}>
              {question?.content ?? 'Câu hỏi luyện tập'}
            </p>
            {question && (
              <p className={styles.questionMeta}>
                <span className={styles.industryTag}>{industryLabel(question.industry)}</span>
                {question.position}
              </p>
            )}
          </div>
        </div>
      </td>
      <td>
        <p className={styles.timeMain}>{formatTime(session.completedAt)}</p>
        <p className={styles.timeSub}>{relativeTime(session.completedAt)}</p>
      </td>
      <td>
        <div className={styles.scoreCell}>
          <span className={`${styles.scoreBadge} ${good ? styles.scoreGood : styles.scoreWarn}`}>
            <img src={good ? iconScoreStar : iconScoreWarn} alt="" width="16" height="16" />
            {formatPoints(score)} / 100
          </span>
          <span className={`${styles.bandLabel} ${good ? styles.good : styles.warn}`}>{band.label}</span>
        </div>
      </td>
      <td>
        <div className={styles.audioCell}>
          <button
            type="button"
            className={styles.playButton}
            onClick={togglePlay}
            disabled={!session.audioUrl}
            aria-label={playing ? 'Tạm dừng bản ghi âm' : 'Nghe bản ghi âm'}
            title={session.audioUrl ? undefined : 'Không có bản ghi âm'}
          >
            {playing ? <span className={styles.pauseGlyph} aria-hidden /> : <img src={iconPlaySmall} alt="" width="11" height="14" />}
          </button>
          <span className={`${styles.miniWave} ${playing ? styles.miniWavePlaying : ''}`} aria-hidden>
            {[6, 12, 16, 10, 14, 8, 12, 6].map((h, i) => (
              <span key={i} style={{ height: h }} />
            ))}
          </span>
          <span className={styles.duration}>{session.duration ? formatClock(session.duration) : '--:--'}</span>
        </div>
      </td>
      <td className={styles.right}>
        <Link to={`/results/${session.id}`} className={styles.detailLink} onClick={(e) => e.stopPropagation()}>
          Xem chi tiết
          <img src={iconArrowRightSm} alt="" width="16" height="16" />
        </Link>
      </td>
    </tr>
  )
}

function formatTime(value) {
  if (!value) return '--'
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return '--'
  return d.toLocaleString('vi-VN', { hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit', year: 'numeric' })
}

function shortDate(value) {
  const d = new Date(value)
  return Number.isNaN(d.getTime()) ? '' : d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' })
}

function relativeTime(value) {
  if (!value) return ''
  const diff = Date.now() - new Date(value).getTime()
  if (Number.isNaN(diff)) return ''
  const minutes = Math.round(diff / 60000)
  if (minutes < 1) return 'Vừa xong'
  if (minutes < 60) return `${minutes} phút trước`
  const hours = Math.round(minutes / 60)
  if (hours < 24) return `${hours} giờ trước`
  const days = Math.round(hours / 24)
  if (days === 1) return 'Hôm qua'
  return `${days} ngày trước`
}
