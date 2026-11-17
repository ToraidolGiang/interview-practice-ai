import Icon from './Icon'
import styles from './Pagination.module.css'

// Trang trong API bắt đầu từ 0, hiển thị cho người dùng bắt đầu từ 1. Như Figma: 1 2 3 ... 31
function pageItems(current, totalPages) {
  if (totalPages <= 6) return Array.from({ length: totalPages }, (_, i) => i)
  const last = totalPages - 1
  if (current < 3) return [0, 1, 2, 'gap-end', last]
  if (current > last - 3) return [0, 'gap-start', last - 2, last - 1, last]
  return [0, 'gap-start', current - 1, current, current + 1, 'gap-end', last]
}

/**
 * Thanh phân trang: summary bên trái, nút trang ở giữa (hoặc bên phải khi không có `aside`), aside bên phải.
 */
export default function Pagination({ page, totalPages, onChange, summary, aside }) {
  if (totalPages <= 0) return null
  return (
    <nav className={`${styles.bar} ${aside ? '' : styles.noAside}`} aria-label="Phân trang">
      <p className={styles.summary}>{summary}</p>
      <div className={styles.pages}>
        <button
          type="button"
          className={styles.page}
          onClick={() => onChange(page - 1)}
          disabled={page <= 0}
          aria-label="Trang trước"
        >
          <Icon name="chevronLeft" size={14} />
        </button>
        {pageItems(page, totalPages).map((item) =>
          typeof item === 'number' ? (
            <button
              key={item}
              type="button"
              className={`${styles.page} ${item === page ? styles.active : ''}`}
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
          className={styles.page}
          onClick={() => onChange(page + 1)}
          disabled={page >= totalPages - 1}
          aria-label="Trang sau"
        >
          <Icon name="chevronRight" size={14} />
        </button>
      </div>
      {aside && <p className={styles.aside}>{aside}</p>}
    </nav>
  )
}
