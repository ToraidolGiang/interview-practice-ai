import iconVoiceBars from '../assets/figma/icon-voice-bars.svg'
import { fillerVerdict, WPM_IDEAL, WPM_SCALE_MAX, wpmVerdict } from '../constants/scoring'
import { fillerBreakdown } from '../utils/fillers'
import styles from './DeliveryPanel.module.css'

const pct = (v) => Math.min(100, Math.max(0, (v / WPM_SCALE_MAX) * 100))

// Khối "Phân tích âm học & Ngữ âm" (Figma) = Delivery trong rubric mục 5 (#125)
export default function DeliveryPanel({ delivery, transcript }) {
  return (
    <section className={styles.panel}>
      <div className={styles.header}>
        <h3>Phân tích âm học &amp; Ngữ âm</h3>
        <img src={iconVoiceBars} alt="" width="15" height="16.6667" />
      </div>

      {!delivery ? (
        <p className={styles.empty}>
          Câu trả lời dưới 30 từ nên chưa đủ dữ liệu để đánh giá tốc độ nói và từ đệm.
        </p>
      ) : (
        <>
          <WpmBlock wpm={delivery.wpm} />
          <FillerBlock
            count={delivery.fillerCount}
            rate={Number(delivery.fillerRate ?? 0)}
            breakdown={fillerBreakdown(transcript)}
          />
          <div className={styles.block}>
            <p className={styles.label}>Điểm Giọng nói (Delivery)</p>
            <p className={styles.mid}>
              {Number(delivery.deliveryScore).toFixed(1)}
              <small> / 5</small>
            </p>
            <p className={styles.note}>Trung bình điểm tốc độ nói và điểm từ đệm, chiếm 10% điểm tổng.</p>
          </div>
        </>
      )}
    </section>
  )
}

function Verdict({ verdict }) {
  return <span className={`${styles.verdict} ${styles[verdict.tone]}`}>{verdict.label}</span>
}

function WpmBlock({ wpm }) {
  return (
    <div className={styles.block}>
      <div className={styles.blockTop}>
        <p className={styles.label}>Tốc độ phát âm (Velocity)</p>
        <Verdict verdict={wpmVerdict(wpm)} />
      </div>
      <p className={styles.big}>
        {wpm}
        <small> WPM (Từ/phút)</small>
      </p>
      <div className={styles.scale} aria-hidden>
        <span
          className={styles.ideal}
          style={{ left: `${pct(WPM_IDEAL[0])}%`, right: `${100 - pct(WPM_IDEAL[1])}%` }}
        />
        <span className={styles.pin} style={{ left: `${pct(wpm)}%` }} />
      </div>
      <div className={styles.scaleLabels}>
        <span>Chậm (&lt;{WPM_IDEAL[0]})</span>
        <span className={styles.idealLabel}>
          {WPM_IDEAL[0]} - {WPM_IDEAL[1]} WPM
        </span>
        <span>Nhanh (&gt;{WPM_IDEAL[1]})</span>
      </div>
    </div>
  )
}

function FillerBlock({ count, rate, breakdown }) {
  return (
    <div className={styles.block}>
      <div className={styles.blockTop}>
        <p className={styles.label}>Đếm từ đệm (Filler Words)</p>
        <Verdict verdict={fillerVerdict(rate)} />
      </div>
      <p className={styles.big}>
        <span className={styles.fillerCount}>{count}</span>
        <small> lần xuất hiện (Tỷ lệ: {rate.toLocaleString('en-US', { maximumFractionDigits: 2 })}%)</small>
      </p>
      {breakdown.length > 0 && (
        <ul className={styles.fillerList}>
          {breakdown.slice(0, 5).map((f) => (
            <li key={f.label}>
              <span className={styles.fillerWord}>“{f.label}”</span>
              <span className={styles.fillerTimes}>{f.count} lần</span>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
