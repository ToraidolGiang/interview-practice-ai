import flagVn from '../assets/figma/flag-vn.svg'
import iconChevronDown from '../assets/figma/icon-chevron-down.svg'
import iconMoon from '../assets/figma/icon-moon.svg'
import iconTrend from '../assets/figma/icon-trend.svg'
import iconUsers from '../assets/figma/icon-users.svg'
import logo from '../assets/figma/logo.jpg'
import styles from './AuthLayout.module.css'

// Bố cục chia đôi của màn hình Đăng nhập / Đăng ký (Figma 8:991, 8:1106)
export default function AuthLayout({ heroTitle, heroSubtitle, heroFooter, bottomNote, children }) {
  return (
    <div className={styles.page}>
      <section className={styles.hero}>
        <span className={`${styles.diamond} ${styles.diamondTopLeft}`} aria-hidden />
        <span className={`${styles.diamond} ${styles.diamondRight}`} aria-hidden />
        <span className={`${styles.diamond} ${styles.diamondLeft}`} aria-hidden />
        <span className={`${styles.diamond} ${styles.diamondBottomRight}`} aria-hidden />

        <div className={styles.heroCenter}>
          <div className={styles.brand}>
            <span className={styles.brandLogo}>
              <img src={logo} alt="" />
            </span>
            <span className={styles.brandName}>
              TalentSTAR <span className={styles.brandAi}>AI</span>
            </span>
          </div>
          <h1 className={styles.heroTitle}>{heroTitle}</h1>
          <p className={styles.heroSubtitle}>{heroSubtitle}</p>
          <div className={styles.badges}>
            <span className={styles.badge}>
              <img src={iconUsers} alt="" width="16" height="16" />
              <strong>10K+</strong> người dùng
            </span>
            <span className={styles.badge}>
              <img src={iconTrend} alt="" width="16" height="16" />
              <strong>95%</strong> thành công
            </span>
          </div>
        </div>

        <p className={styles.heroFooter}>{heroFooter}</p>
      </section>

      <section className={styles.panel}>
        <div className={styles.topActions}>
          {/* Chọn ngôn ngữ và chế độ tối làm ở #149 (i18n), hiện chỉ hiển thị theo thiết kế */}
          <button type="button" className={styles.langButton} disabled title="Sắp hỗ trợ">
            <img src={flagVn} alt="" width="16" height="12" />
            Tiếng Việt
            <img src={iconChevronDown} alt="" width="14" height="14" />
          </button>
          <button
            type="button"
            className={styles.iconButton}
            aria-label="Chuyển chế độ tối"
            disabled
            title="Sắp hỗ trợ"
          >
            <img src={iconMoon} alt="" width="16" height="16" />
          </button>
        </div>

        <div className={styles.panelCenter}>{children}</div>

        <p className={styles.bottomNote}>{bottomNote}</p>
      </section>
    </div>
  )
}
