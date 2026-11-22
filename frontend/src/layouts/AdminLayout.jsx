import { useEffect, useRef, useState } from 'react'
import { Link, NavLink, Outlet, useLocation } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import Icon from '../components/Icon'
import Logo from '../components/Logo'
import { initials } from '../utils/format'
import styles from './AdminLayout.module.css'

const NAV_ITEMS = [
  { to: '/admin/questions', label: 'Quản lý câu hỏi' },
  { to: '/admin/analytics', label: 'Thống kê' },
]

// Vỏ riêng của khu Quản trị (theo thiết kế pics/admin): header có nhãn QUẢN TRỊ, thanh điều hướng, footer riêng
export default function AdminLayout() {
  const { pathname } = useLocation()

  useEffect(() => {
    window.scrollTo(0, 0)
  }, [pathname])

  return (
    <div className={styles.shell}>
      <header className={styles.header}>
        <div className={styles.brand}>
          <Logo to="/admin/questions" />
          <span className={styles.badge}>QUẢN TRỊ</span>
        </div>

        <nav className={styles.nav} aria-label="Khu quản trị">
          {NAV_ITEMS.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) => `${styles.navLink} ${isActive ? styles.navActive : ''}`}
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className={styles.actions}>
          <AdminAccountMenu />
        </div>
      </header>

      <main className={styles.main}>
        <Outlet />
      </main>

      <footer className={styles.footer}>
        <div className={`container ${styles.footerInner}`}>
          <span>© 2026 InterviewAI · Trang quản trị</span>
          <span>Chỉ tài khoản Quản trị viên được truy cập</span>
        </div>
      </footer>
    </div>
  )
}

function AdminAccountMenu() {
  const { user, logout } = useAuth()
  const [open, setOpen] = useState(false)
  const ref = useRef(null)

  useEffect(() => {
    if (!open) return undefined
    const close = (e) => {
      if (e.type === 'keydown' ? e.key === 'Escape' : !ref.current?.contains(e.target)) setOpen(false)
    }
    document.addEventListener('mousedown', close)
    document.addEventListener('keydown', close)
    return () => {
      document.removeEventListener('mousedown', close)
      document.removeEventListener('keydown', close)
    }
  }, [open])

  return (
    <div className={styles.account} ref={ref}>
      <button
        type="button"
        className={styles.accountButton}
        onClick={() => setOpen((v) => !v)}
        aria-haspopup="menu"
        aria-expanded={open}
      >
        <span className={styles.avatar} aria-hidden>
          {initials(user?.fullName)}
        </span>
        <span className={styles.accountText}>
          <span className={styles.accountName}>{user?.fullName}</span>
          <span className={styles.accountRole}>Quản trị viên</span>
        </span>
      </button>

      {open && (
        <div className={styles.menu} role="menu" onClick={() => setOpen(false)}>
          <Link to="/dashboard" role="menuitem" className={styles.menuItem}>
            <Icon name="user" size={16} />
            Về trang ứng viên
          </Link>
          <div className={styles.menuDivider} />
          <button type="button" role="menuitem" className={`${styles.menuItem} ${styles.menuDanger}`} onClick={logout}>
            <Icon name="logout" size={16} />
            Đăng xuất
          </button>
        </div>
      )}
    </div>
  )
}
