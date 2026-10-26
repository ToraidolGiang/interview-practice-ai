import styles from './RubricRadar.module.css'

const SIZE = 240
const CENTER = SIZE / 2
const RADIUS = 78

function point(index, count, value) {
  const angle = -Math.PI / 2 + (2 * Math.PI * index) / count
  const r = (RADIUS * value) / 5
  return [CENTER + r * Math.cos(angle), CENTER + r * Math.sin(angle)]
}

const polygon = (values) => values.map((v, i) => point(i, values.length, v).join(',')).join(' ')

// Radar điểm các tiêu chí rubric (thang 1-5), giữ hình thức khối "Đối sánh năng lực" của Figma.
// Chưa có dữ liệu trung bình người dùng khác nên chỉ vẽ điểm của câu trả lời này.
export default function RubricRadar({ items }) {
  if (items.length < 3) return null
  const n = items.length
  return (
    <figure className={styles.figure}>
      <svg viewBox={`0 0 ${SIZE} ${SIZE}`} className={styles.svg} role="img" aria-label="Biểu đồ điểm theo tiêu chí">
        {[5, 4, 3, 2, 1].map((level) => (
          <polygon
            key={level}
            points={polygon(new Array(n).fill(level))}
            className={level === 5 ? styles.gridOuter : styles.grid}
          />
        ))}
        {items.map((_, i) => {
          const [x, y] = point(i, n, 5)
          return <line key={i} x1={CENTER} y1={CENTER} x2={x} y2={y} className={styles.axis} />
        })}
        <polygon points={polygon(items.map((it) => it.score))} className={styles.area} />
        {items.map((it, i) => {
          const [x, y] = point(i, n, it.score)
          return <circle key={it.label} cx={x} cy={y} r="4" className={styles.dot} />
        })}
        {items.map((it, i) => {
          const [x, y] = point(i, n, 6.3)
          const anchor = Math.abs(x - CENTER) < 4 ? 'middle' : x > CENTER ? 'start' : 'end'
          return (
            <text key={it.label} x={x} y={y + 3} textAnchor={anchor} className={styles.label}>
              {it.label}
            </text>
          )
        })}
      </svg>
      <figcaption className={styles.legend}>
        <span className={styles.legendDot} aria-hidden />
        Điểm câu trả lời này (thang 1-5)
      </figcaption>
    </figure>
  )
}
