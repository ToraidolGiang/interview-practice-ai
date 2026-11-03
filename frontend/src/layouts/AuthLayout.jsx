import heroArt from '../assets/illustrations/auth-hero.png'
import Icon from '../components/Icon'
import Logo from '../components/Logo'
import styles from './AuthLayout.module.css'

const DEFAULT_TITLE = 'Chinh phục buổi phỏng vấn tiếp theo cùng AI'
const DEFAULT_SUBTITLE =
  'Nhận phản hồi cá nhân hóa, xây dựng sự tự tin và tiến gần hơn đến công việc mơ ước qua các buổi phỏng vấn thử thông minh.'

// Bố cục chia đôi của nhóm màn Đăng nhập / Đăng ký / Quên mật khẩu (Figma "Split Screen")
export default function AuthLayout({
  heroTitle = DEFAULT_TITLE,
  heroSubtitle = DEFAULT_SUBTITLE,
  heroFooter = '© 2026 InterviewAI',
  bottomNote,
  children,
}) {
  return (
    <div className={styles.page}>
      <section className={styles.hero}>
        <Logo inverted size={40} />
        <span className={styles.dots} aria-hidden />
        <h1 className={styles.heroTitle}>{heroTitle}</h1>
        <p className={styles.heroSubtitle}>{heroSubtitle}</p>
        <img className={styles.art} src={heroArt} alt="" width="640" height="540" />
        <p className={styles.heroFooter}>{heroFooter}</p>
      </section>

      <section className={styles.panel}>
        <div className={styles.topActions}>
          {/* Đổi ngôn ngữ và chế độ tối chưa có trong phạm vi; hiển thị theo thiết kế */}
          <button type="button" className={styles.langButton} title="Tiếng Việt">
            <Icon name="globe" size={14} strokeWidth={1.8} className={styles.globe} />
            VI
            <span className={styles.caret} aria-hidden>
              ▾
            </span>
          </button>
          <button type="button" className={styles.iconButton} aria-label="Chế độ tối" title="Sắp hỗ trợ">
            <Icon name="moon" size={16} strokeWidth={1.8} />
          </button>
        </div>

        <div className={styles.panelCenter}>{children}</div>

        {bottomNote && <p className={styles.bottomNote}>{bottomNote}</p>}
      </section>
    </div>
  )
}
