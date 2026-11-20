import { NavLink } from 'react-router'
import styles from './AdminTabs.module.css'

const TABS = [
  { to: '/admin/questions', label: 'Câu hỏi' },
  { to: '/admin/analytics', label: 'Thống kê' },
]

/** Thanh tab con của khu Quản trị: Câu hỏi | Thống kê. Tab hiện hành có aria-current="page". */
export default function AdminTabs() {
  return (
    <nav className={styles.tabs} aria-label="Khu quản trị">
      {TABS.map((tab) => (
        <NavLink key={tab.to} to={tab.to} className={({ isActive }) => `${styles.tab} ${isActive ? styles.active : ''}`}>
          {tab.label}
        </NavLink>
      ))}
    </nav>
  )
}
