import { initials } from '../utils/format'

// Ảnh đại diện chữ cái đầu (API người dùng chưa có ảnh đại diện)

export default function Avatar({ name, size = 32 }) {
  return (
    <span
      aria-hidden
      style={{
        display: 'inline-grid',
        placeItems: 'center',
        flexShrink: 0,
        width: size,
        height: size,
        borderRadius: '50%',
        background: 'var(--primary-soft)',
        color: 'var(--primary)',
        fontFamily: 'var(--font-heading)',
        fontWeight: 700,
        fontSize: size * 0.36,
      }}
    >
      {initials(name)}
    </span>
  )
}
