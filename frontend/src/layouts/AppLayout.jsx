import { NavLink, Outlet } from 'react-router'
import iconAdminSwitch from '../assets/figma/icon-admin-switch.svg'
import iconBell from '../assets/figma/icon-bell.svg'
import iconGlobe from '../assets/figma/icon-globe.svg'
import logo from '../assets/figma/logo.jpg'
import { useAuth } from '../auth/AuthContext'
import styles from './AppLayout.module.css'

const NAV_ITEMS = [
  { to: '/questions', label: 'Ngân hàng câu hỏi' },
  { to: '/practice', label: 'Phòng luyện tập' },
  { to: '/history', label: 'Lịch sử & Tiến độ' },
]

function initials(fullName = '') {
  const parts = fullName.trim().split(/\s+/).filter(Boolean)
  if (!parts.length) return '?'
  return (parts.length > 1 ? parts[0][0] + parts.at(-1)[0] : parts[0][0]).toUpperCase()
}

// Header + footer chung cho các màn hình sau đăng nhập (Figma 15:889, 19:2921)
export default function AppLayout() {
  const { user, logout } = useAuth()

  return (
    <div className={styles.shell}>
      <header className={styles.header}>
        <div className={styles.headerInner}>
          <div className={styles.brand}>
            <img src={logo} alt="" width="32" height="32" />
            <span className={styles.brandName}>TalentSTAR AI</span>
            <span className={styles.roleBadge}>{user?.role || 'CANDIDATE'}</span>
          </div>

          <nav className={styles.nav}>
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
            <span className={styles.lang}>
              <img src={iconGlobe} alt="" width="15" height="15" />
              VI Tiếng Việt
            </span>
            {user?.role === 'ADMIN' && (
              <NavLink to="/admin" className={styles.adminSwitch}>
                <img src={iconAdminSwitch} alt="" width="13.5" height="15" />
                Chuyển sang Admin
              </NavLink>
            )}
            <button type="button" className={styles.bell} aria-label="Thông báo">
              <img src={iconBell} alt="" width="13.333" height="16.667" />
            </button>
            <div className={styles.profile}>
              <span className={styles.avatar} aria-hidden>
                {initials(user?.fullName)}
              </span>
              <span className={styles.profileText}>
                <span className={styles.profileName}>{user?.fullName}</span>
                <span className={styles.profileEmail}>{user?.email}</span>
              </span>
              <button type="button" className={styles.logout} onClick={logout}>
                Đăng xuất
              </button>
            </div>
          </div>
        </div>
      </header>

      <main className={styles.main}>
        <Outlet />
      </main>

      <footer className={styles.footer}>
        <div className={styles.footerInner}>
          <div className={styles.footerGrid}>
            <div className={styles.footerAbout}>
              <div className={styles.brand}>
                <img src={logo} alt="" width="32" height="32" />
                <span className={styles.brandName}>TalentSTAR AI</span>
              </div>
              <p>
                Nền tảng luyện phỏng vấn AI thông minh chuẩn khung năng lực STAR dành cho ứng
                viên tài năng và doanh nghiệp tuyển dụng hàng đầu.
              </p>
            </div>
            <div className={styles.footerCol}>
              <h4>Tài nguyên</h4>
              <ul>
                <li>Ngân hàng câu hỏi tuyển dụng</li>
                <li>Phòng mô phỏng AI STAR</li>
                <li>Báo cáo phân tích năng lực</li>
              </ul>
            </div>
            <div className={styles.footerCol}>
              <h4>Hỗ trợ &amp; Pháp lý</h4>
              <ul>
                <li>Hướng dẫn phương pháp STAR</li>
                <li>Chính sách bảo mật dữ liệu</li>
                <li>Điều khoản dịch vụ TalentSTAR</li>
              </ul>
            </div>
          </div>
          <div className={styles.footerBottom}>
            <span>© 2026 TalentSTAR AI. Bảo lưu mọi quyền.</span>
            <span className={styles.status}>
              <span className={styles.statusDot} aria-hidden />
              Hệ thống AI sẵn sàng
            </span>
          </div>
        </div>
      </footer>
    </div>
  )
}
