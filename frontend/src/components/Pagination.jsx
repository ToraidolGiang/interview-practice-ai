import { useState } from 'react'
import iconPageNext from '../assets/figma/icon-page-next.svg'
import iconPagePrev from '../assets/figma/icon-page-prev.svg'
import { formatCount } from '../utils/format'
import styles from './Pagination.module.css'

// Trang trong API bắt đầu từ 0, hiển thị cho người dùng bắt đầu từ 1
function pageItems(current, totalPages) {
  if (totalPages <= 7) return Array.from({ length: totalPages }, (_, i) => i)
  const last = totalPages - 1
  // Như Figma: 1 2 3 ... 3402 ở đầu, cửa sổ 3 trang quanh trang hiện tại ở giữa
  if (current < 3) return [0, 1, 2, 'gap-end', last]
  if (current > last - 3) return [0, 'gap-start', last - 2, last - 1, last]
  return [0, 'gap-start', current - 1, current, current + 1, 'gap-end', last]
}

export default function Pagination({ page, size, totalElements, totalPages, itemLabel, onChange }) {
  const [jumpValue, setJumpValue] = useState('')
  if (totalElements === 0) return null

  const from = page * size + 1
  const to = Math.min(totalElements, (page + 1) * size)

  function jump(e) {
    e.preventDefault()
    const target = Number(jumpValue)
    if (Number.isInteger(target) && target >= 1 && target <= totalPages) onChange(target - 1)
    setJumpValue('')
  }

  return (
    <nav className={styles.bar} aria-label="Phân trang">
      <p className={styles.summary}>
        Hiển thị <strong>{formatCount(from)} - {formatCount(to)}</strong> trên
        tổng số <strong>{formatCount(totalElements)}</strong> {itemLabel}
      </p>

      <div className={styles.pages}>
        <button
          type="button"
          className={styles.arrow}
          onClick={() => onChange(page - 1)}
          disabled={page <= 0}
          aria-label="Trang trước"
        >
          <img src={iconPagePrev} alt="" width="6.16667" height="10" />
        </button>
        {pageItems(page, totalPages).map((item) =>
          typeof item === 'number' ? (
            <button
              key={item}
              type="button"
              className={`${styles.page} ${item === page ? styles.pageActive : ''}`}
              onClick={() => onChange(item)}
              aria-current={item === page ? 'page' : undefined}
            >
              {item + 1}
            </button>
          ) : (
            <span key={item} className={styles.gap}>
              ...
            </span>
          ),
        )}
        <button
          type="button"
          className={styles.arrow}
          onClick={() => onChange(page + 1)}
          disabled={page >= totalPages - 1}
          aria-label="Trang sau"
        >
          <img src={iconPageNext} alt="" width="6.16667" height="10" />
        </button>
      </div>

      <form className={styles.jump} onSubmit={jump}>
        <label htmlFor="pagination-jump">Đến trang:</label>
        <input
          id="pagination-jump"
          type="number"
          min="1"
          max={totalPages}
          value={jumpValue}
          onChange={(e) => setJumpValue(e.target.value)}
          placeholder={String(page + 1)}
        />
        <button type="submit">Đi</button>
      </form>
    </nav>
  )
}
