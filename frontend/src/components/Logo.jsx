import { Link } from 'react-router'
import styles from './Logo.module.css'

// Logo InterviewAI: ô vuông bo góc chứa bong bóng hội thoại có sóng âm
export function LogoMark({ size = 32, inverted = false }) {
  return (
    <span
      className={`${styles.mark} ${inverted ? styles.markInverted : ''}`}
      style={{ width: size, height: size, borderRadius: size * 0.25 }}
      aria-hidden
    >
      <svg width={size * 0.56} height={size * 0.56} viewBox="0 0 20 20">
        <path
          d="M4 2.5h12A2.5 2.5 0 0 1 18.5 5v7.5A2.5 2.5 0 0 1 16 15h-5.2l-3.6 2.9c-.5.4-1.2 0-1.2-.6V15H4a2.5 2.5 0 0 1-2.5-2.5V5A2.5 2.5 0 0 1 4 2.5Z"
          fill="currentColor"
        />
        <g className={styles.bars}>
          <rect x="6.2" y="7.2" width="1.6" height="3.6" rx=".8" />
          <rect x="9.2" y="5.6" width="1.6" height="6.8" rx=".8" />
          <rect x="12.2" y="7.2" width="1.6" height="3.6" rx=".8" />
        </g>
      </svg>
    </span>
  )
}

export default function Logo({ to = '/', size = 32, inverted = false, className = '' }) {
  return (
    <Link to={to} className={`${styles.logo} ${inverted ? styles.inverted : ''} ${className}`} aria-label="InterviewAI">
      <LogoMark size={size} inverted={inverted} />
      <span className={styles.word} style={{ fontSize: size * 0.62 }}>
        Interview<span className={styles.ai}>AI</span>
      </span>
    </Link>
  )
}
