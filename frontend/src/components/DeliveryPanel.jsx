import iconVoiceBars from '../assets/figma/icon-voice-bars.svg'
import { fillerVerdict, WPM_IDEAL, WPM_SCALE_MAX, wpmVerdict } from '../constants/scoring'
import styles from './DeliveryPanel.module.css'

const pct = (v) => `${Math.min(100, Math.max(0, (v / WPM_SCALE_MAX) * 100))}%`

// Khối Delivery trong màn kết quả (#125): tốc độ nói, từ đệm, điểm Delivery 1-5
export default function DeliveryPanel({ delivery }) {
  return (
    <section className={styles.panel}>
      <div className={styles.header}>
        <h3>Phân tích giọng nói</h3>
        <img src={iconVoiceBars} alt="" width="15" height="16.6667" />
      </div>

      {!delivery ? (
        <p className={styles.empty}>
          Câu trả lời dưới 30 từ nên chưa đủ dữ liệu để đánh giá tốc độ nói và từ đệm.
        </p>
      ) : (
        <>
          <WpmBlock wpm={delivery.wpm} />
          <FillerBlock count={delivery.fillerCount} rate={Number(delivery.fillerRate ?? 0)} />
          <div className={styles.block}>
            <p className={styles.label}>Điểm Delivery</p>
            <p className={styles.big}>
              {Number(delivery.deliveryScore).toFixed(1)}
              <small> / 5</small>
            </p>
            <p className={styles.note}>Trung bình điểm tốc độ nói và điểm từ đệm, hiển thị tách riêng khỏi điểm nội dung.</p>
          </div>
        </>
      )}
    </section>
  )
}

function WpmBlock({ wpm }) {
  const verdict = wpmVerdict(wpm)
  return (
    <div className={styles.block}>
      <div className={styles.blockTop}>
        <p className={styles.label}>Tốc độ nói</p>
        <span className={`${styles.verdict} ${styles[verdict.tone]}`}>{verdict.label}</span>
      </div>
      <p className={styles.big}>
        {wpm}
        <small> từ/phút</small>
      </p>
      <div className={styles.scale} aria-hidden>
        <span
          className={styles.ideal}
          style={{ left: pct(WPM_IDEAL[0]), width: `calc(${pct(WPM_IDEAL[1])} - ${pct(WPM_IDEAL[0])})` }}
        />
        <span className={styles.marker} style={{ left: pct(wpm) }} />
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

function FillerBlock({ count, rate }) {
  const verdict = fillerVerdict(rate)
  return (
    <div className={styles.block}>
      <div className={styles.blockTop}>
        <p className={styles.label}>Từ đệm</p>
        <span className={`${styles.verdict} ${styles[verdict.tone]}`}>{verdict.label}</span>
      </div>
      <p className={styles.big}>
        <span className={styles.fillerCount}>{count}</span>
        <small> lần xuất hiện (tỷ lệ {rate.toLocaleString('vi-VN', { maximumFractionDigits: 2 })}%)</small>
      </p>
      <p className={styles.note}>
        Đếm “ừm”, “ờ”, “kiểu như”, “nói chung là”... và lặp từ liền kề. Từ đệm được tô màu trong transcript.
      </p>
    </div>
  )
}
