import { Link, Navigate, useLocation } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import Icon from '../components/Icon'
import { formatVnd } from '../constants/plans'
import styles from './AccountPages.module.css'

/**
 * Màn "Thanh toán thành công". Chỉ hiển thị khi cổng thanh toán trả về kết quả qua state điều hướng:
 * { plan, amount, method, transactionId, renewAt }. Không có kết quả thật thì quay lại màn Nâng cấp.
 */
export default function UpgradeSuccessPage() {
  const { user } = useAuth()
  const receipt = useLocation().state?.receipt
  if (!receipt) return <Navigate to="/upgrade" replace />

  return (
    <div className={`container page ${styles.successPage}`}>
      <section className={`card ${styles.successCard}`}>
        <span className={styles.successIcon} aria-hidden>
          <span>
            <Icon name="check" size={22} strokeWidth={3} />
          </span>
        </span>
        <h1>Chào mừng bạn đến với Pro!</h1>
        <p>
          Thanh toán thành công. Mọi tính năng Pro đã được mở khoá cho tài khoản {user?.email}.
        </p>
        <dl className={styles.receipt}>
          <div>
            <dt>Gói</dt>
            <dd>{receipt.plan}</dd>
          </div>
          <div>
            <dt>Số tiền</dt>
            <dd>{formatVnd(receipt.amount)}</dd>
          </div>
          <div>
            <dt>Phương thức</dt>
            <dd>{receipt.method}</dd>
          </div>
          <div>
            <dt>Mã giao dịch</dt>
            <dd>{receipt.transactionId}</dd>
          </div>
          <div>
            <dt>Gia hạn tiếp theo</dt>
            <dd>{receipt.renewAt}</dd>
          </div>
        </dl>
        <div className={styles.successActions}>
          <Link to="/dashboard" className="btn btn-soft">
            Về Bảng điều khiển
          </Link>
          <Link to="/questions" className="btn btn-primary">
            Bắt đầu luyện ngay
          </Link>
        </div>
        <small>Hoá đơn điện tử đã được gửi tới email của bạn.</small>
      </section>
    </div>
  )
}
