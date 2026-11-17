import { Link } from 'react-router'
import styles from './Breadcrumb.module.css'

/** "Tổng quan › ... › Trang hiện tại": items là các mục có link, current là trang đang mở. */
export default function Breadcrumb({ items = [{ label: 'Tổng quan', to: '/dashboard' }], current }) {
  return (
    <nav className={styles.breadcrumb} aria-label="Breadcrumb">
      {items.map((item) => (
        <span key={item.to} className={styles.item}>
          <Link to={item.to}>{item.label}</Link>
          <span className={styles.sep} aria-hidden>
            ›
          </span>
        </span>
      ))}
      <span className={styles.current} aria-current="page">
        {current}
      </span>
    </nav>
  )
}
