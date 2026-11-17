import { useEffect, useRef, useState } from 'react'
import { Link, NavLink, Outlet, useLocation } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import Avatar from '../components/Avatar'
import Icon from '../components/Icon'
import Logo from '../components/Logo'
import styles from './AppLayout.module.css'

const NAV_ITEMS = [
  { to: '/dashboard', label: 'Tổng quan' },
  { to: '/questions', label: 'Ngân hàng câu hỏi' },
  // Màn Kết quả chấm điểm nằm trong mục Phòng luyện tập (theo Figma)
  { to: '/practice', label: 'Phòng luyện tập', also: ['/results'] },
  { to: '/history', label: 'Lịch sử & Tiến độ' },
]

// Header + footer chung cho các màn hình ứng viên sau đăng nhập
export default function AppLayout() {
  const { pathname } = useLocation()

  useEffect(() => {
    window.scrollTo(0, 0)
  }, [pathname])

  return (
    <div className={styles.shell}>
      <header className={styles.header}>
        <Logo to="/dashboard" />

        <nav className={styles.nav} aria-label="Điều hướng chính">
          {NAV_ITEMS.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
                `${styles.navLink} ${isActive || item.also?.some((p) => pathname.startsWith(p)) ? styles.navActive : ''}`
              }
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className={styles.actions}>
          {/* Contract API chưa có thông báo; nút giữ đúng vị trí theo thiết kế */}
          <button type="button" className={styles.bell} aria-label="Thông báo" title="Chưa có thông báo mới">
            <Icon name="bell" size={20} strokeWidth={1.8} />
          </button>
          <AccountMenu />
        </div>
      </header>

      <main className={styles.main}>
        <Outlet />
      </main>

      <AppFooter />
    </div>
  )
}

export function AppFooter() {
  return (
    <footer className={styles.footer}>
      <div className={`container ${styles.footerInner}`}>
        <span>© 2026 InterviewAI · Luyện phỏng vấn bằng giọng nói</span>
        <span className={styles.footerLinks}>
          <a href="#">Điều khoản sử dụng</a> · <a href="#">Chính sách bảo mật</a> · <a href="#">Hỗ trợ</a>
        </span>
      </div>
    </footer>
  )
}

function AccountMenu() {
  const { user, logout } = useAuth()
  const [open, setOpen] = useState(false)
  const ref = useRef(null)

  useEffect(() => {
    if (!open) return
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
        <Avatar name={user?.fullName} size={32} />
        <span className={styles.accountText}>
          <span className={styles.accountName}>{user?.fullName}</span>
          <span className={styles.accountEmail}>{user?.email}</span>
        </span>
      </button>

      {open && (
        <div className={styles.menu} role="menu" onClick={() => setOpen(false)}>
          <Link to="/profile" role="menuitem" className={styles.menuItem}>
            <Icon name="user" size={16} />
            Hồ sơ cá nhân
          </Link>
          <Link to="/settings" role="menuitem" className={styles.menuItem}>
            <Icon name="settings" size={16} />
            Cài đặt tài khoản
          </Link>
          <Link to="/upgrade" role="menuitem" className={styles.menuItem}>
            <Icon name="star" size={16} />
            Nâng cấp Pro
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
