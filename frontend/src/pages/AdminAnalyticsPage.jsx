import { useEffect, useState } from 'react'
import { exportAnalyticsCsv, getAnalyticsOverview } from '../api/adminAnalytics'
import Breadcrumb from '../components/Breadcrumb'
import { apiErrorMessage } from '../constants/scoring'
import styles from './AdminAnalyticsPage.module.css'

const nf = new Intl.NumberFormat('vi-VN')
const scoreFmt = new Intl.NumberFormat('vi-VN', { maximumFractionDigits: 2 })
const costFmt = new Intl.NumberFormat('vi-VN', { maximumFractionDigits: 4 })

function Stat({ label, value, note }) {
  return (
    <div className={`card ${styles.stat}`}>
      <dt className={styles.statLabel}>{label}</dt>
      <dd className={styles.statValue}>{value}</dd>
      {note && <dd className={styles.statNote}>{note}</dd>}
    </div>
  )
}

export default function AdminAnalyticsPage() {
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  // key = khoảng ngày của lần tải gần nhất; khác rangeKey nghĩa là đang tải
  const [result, setResult] = useState({ key: null, data: null, error: null })
  const [exporting, setExporting] = useState(false)
  const [exportError, setExportError] = useState(null)

  const rangeError = from && to && from > to ? 'Ngày bắt đầu phải trước hoặc bằng ngày kết thúc.' : null
  const rangeKey = `${from}|${to}`

  useEffect(() => {
    if (from && to && from > to) return undefined
    let cancelled = false
    getAnalyticsOverview({ from, to })
      .then((data) => !cancelled && setResult({ key: rangeKey, data, error: null }))
      .catch((error) => !cancelled && setResult({ key: rangeKey, data: null, error }))
    return () => {
      cancelled = true
    }
  }, [from, to, rangeKey])

  async function handleExport() {
    setExporting(true)
    setExportError(null)
    try {
      await exportAnalyticsCsv({ from, to })
    } catch (err) {
      setExportError(apiErrorMessage(err, 'Không xuất được báo cáo. Vui lòng thử lại.'))
    } finally {
      setExporting(false)
    }
  }

  const loading = !rangeError && result.key !== rangeKey
  const data = !rangeError && !loading ? result.data : null
  const error = !rangeError && !loading ? result.error : null
  const empty = data && data.totalSessions === 0 && data.totalUsers === 0

  return (
    <div className="container page">
      <Breadcrumb items={[{ label: 'Tổng quan', to: '/dashboard' }]} current="Thống kê" />
      <div className={styles.titleRow}>
        <div>
          <h1 className="page-title">Thống kê hoạt động</h1>
          <p className="page-sub">Tổng quan người dùng, phiên luyện tập và lượt gọi AI trong khoảng ngày chọn.</p>
        </div>
        <button
          type="button"
          className="btn btn-outline"
          onClick={handleExport}
          disabled={exporting || Boolean(rangeError)}
        >
          {exporting ? 'Đang tải...' : 'Xuất CSV'}
        </button>
      </div>

      <section className={`card ${styles.filters}`} aria-label="Khoảng ngày">
        <label className={styles.dateField}>
          <span className={styles.label}>Từ ngày</span>
          <input type="date" value={from} max={to || undefined} onChange={(e) => setFrom(e.target.value)} />
        </label>
        <label className={styles.dateField}>
          <span className={styles.label}>Đến ngày</span>
          <input type="date" value={to} min={from || undefined} onChange={(e) => setTo(e.target.value)} />
        </label>
        {(from || to) && (
          <button
            type="button"
            className="btn btn-outline"
            onClick={() => {
              setFrom('')
              setTo('')
            }}
          >
            Bỏ lọc
          </button>
        )}
      </section>

      {rangeError && (
        <p className={styles.error} role="alert">
          {rangeError}
        </p>
      )}
      {exportError && (
        <p className={styles.error} role="alert">
          {exportError}
        </p>
      )}
      {loading && (
        <p className={styles.state} role="status">
          Đang tải số liệu...
        </p>
      )}
      {error && (
        <p className={styles.error} role="alert">
          {apiErrorMessage(error, 'Không tải được số liệu thống kê.')}
        </p>
      )}
      {empty && (
        <p className={styles.state} role="status">
          Chưa có hoạt động nào trong khoảng ngày này.
        </p>
      )}

      {data && !empty && (
        <dl className={styles.grid}>
          <Stat label="Tổng người dùng" value={nf.format(data.totalUsers)} />
          <Stat label="Người dùng hoạt động" value={nf.format(data.activeUsers)} note="Có ít nhất một phiên trong khoảng" />
          <Stat label="Tổng phiên luyện tập" value={nf.format(data.totalSessions)} />
          <Stat label="Phiên đã chấm" value={nf.format(data.scoredSessions)} />
          <Stat
            label="Điểm trung bình"
            value={data.averageScore == null ? 'Chưa có' : scoreFmt.format(data.averageScore)}
          />
          <Stat label="Chi phí AI" value={costFmt.format(data.estimatedCost ?? 0)} note="ước tính" />
          <Stat label="Lượt gọi STT" value={nf.format(data.aiApiCalls?.stt ?? 0)} />
          <Stat label="Lượt gọi LLM" value={nf.format(data.aiApiCalls?.llm ?? 0)} />
          <Stat label="Lượt gọi TTS" value={nf.format(data.aiApiCalls?.tts ?? 0)} />
        </dl>
      )}
    </div>
  )
}
