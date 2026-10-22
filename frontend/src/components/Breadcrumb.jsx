import { Link } from 'react-router'
import iconBreadcrumbChevron from '../assets/figma/icon-breadcrumb-chevron.svg'
import iconHome from '../assets/figma/icon-home.svg'
import styles from './Breadcrumb.module.css'

const Chevron = () => <img src={iconBreadcrumbChevron} alt="" width="4.31667" height="7" />

/**
 * Breadcrumb dùng chung cho các trang sau đăng nhập, theo màn Ngân hàng câu hỏi (Figma 15:464):
 * "Ứng viên › ... › Trang hiện tại". `children` hiển thị bên phải cùng hàng (nút, chip trạng thái).
 */
export default function Breadcrumb({ items = [], current, tag, children }) {
  return (
    <div className={styles.row}>
      <nav className={styles.breadcrumb} aria-label="Breadcrumb">
        <img src={iconHome} alt="" width="10.6667" height="12" />
        <span>Ứng viên</span>
        {items.map((item) => (
          <span key={item.to} className={styles.item}>
            <Chevron />
            <Link to={item.to}>{item.label}</Link>
          </span>
        ))}
        <Chevron />
        <span className={styles.current} aria-current="page">
          {current}
        </span>
        {tag && <span className={styles.tag}>{tag}</span>}
      </nav>
      {children && <div className={styles.actions}>{children}</div>}
    </div>
  )
}
