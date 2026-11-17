import { useState } from 'react'
import { useAuth } from '../auth/AuthContext'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import { formatVnd, PRO_PRICES } from '../constants/plans'
import styles from './AccountPages.module.css'
import { OptionCard } from './SettingsPage'

const METHODS = [
  { value: 'momo', label: 'Ví MoMo', sub: 'Quét mã QR hoặc mở ứng dụng MoMo', badge: 'MoMo', cls: 'brandMomo' },
  { value: 'vnpay', label: 'VNPay', sub: 'Thanh toán qua ứng dụng ngân hàng (QR)', badge: 'VNPAY', cls: 'brandVnpay' },
  { value: 'card', label: 'Thẻ quốc tế', sub: 'Visa, Mastercard, JCB', badge: 'VISA • MC', cls: 'brandCard' },
]

// Màn Thanh toán gói Pro. Contract API chưa có cổng thanh toán nên nút thanh toán chỉ báo chưa hỗ trợ.
export default function UpgradePage() {
  const { user } = useAuth()
  const [cycle, setCycle] = useState('monthly')
  const [method, setMethod] = useState('momo')
  const [billing, setBilling] = useState({ name: user?.fullName ?? '', email: user?.email ?? '', vat: false })
  const [coupon, setCoupon] = useState('')
  const [notice, setNotice] = useState(null)

  const price = PRO_PRICES[cycle]
  const listPrice = PRO_PRICES.monthly.perMonth * price.months
  const discount = listPrice - price.total
  const methodLabel = METHODS.find((m) => m.value === method)?.label.replace('Ví ', '')

  return (
    <div className="container page">
      <Breadcrumb current="Nâng cấp Pro" />
      <h1 className={`page-title ${styles.title}`}>Nâng cấp lên InterviewAI Pro</h1>
      <p className="page-sub">Luyện phỏng vấn không giới hạn, phân tích âm học và phản hồi giọng nói chuyên sâu.</p>

      <div className={styles.checkout}>
        <div className={styles.checkoutMain}>
          <section className="card">
            <h2 className={styles.stepTitle}>1. Chu kỳ thanh toán</h2>
            <div className={styles.options} role="radiogroup" aria-label="Chu kỳ thanh toán">
              <OptionCard
                checked={cycle === 'monthly'}
                onSelect={() => setCycle('monthly')}
                title="Theo tháng"
                sub={`${formatVnd(PRO_PRICES.monthly.perMonth)} / tháng`}
              />
              <OptionCard
                checked={cycle === 'yearly'}
                onSelect={() => setCycle('yearly')}
                title="Theo năm"
                sub={`${formatVnd(PRO_PRICES.yearly.perMonth)} / tháng • ${formatVnd(PRO_PRICES.yearly.total)} / năm`}
                aside={<span className="pill pill-green">-{PRO_PRICES.yearly.discount}%</span>}
              />
            </div>
          </section>

          <section className="card">
            <h2 className={styles.stepTitle}>2. Phương thức thanh toán</h2>
            <div className={styles.methods} role="radiogroup" aria-label="Phương thức thanh toán">
              {METHODS.map((m) => (
                <OptionCard
                  key={m.value}
                  checked={method === m.value}
                  onSelect={() => setMethod(m.value)}
                  title={m.label}
                  sub={m.sub}
                  aside={<span className={`${styles.brand} ${styles[m.cls]}`}>{m.badge}</span>}
                />
              ))}
            </div>
          </section>

          <section className="card">
            <h2 className={styles.stepTitle}>3. Thông tin hoá đơn</h2>
            <div className={styles.grid2}>
              <label className="field">
                <span className="label">Họ và tên</span>
                <input
                  className={`input ${styles.softInput}`}
                  value={billing.name}
                  onChange={(e) => setBilling((b) => ({ ...b, name: e.target.value }))}
                />
              </label>
              <label className="field">
                <span className="label">Email nhận hoá đơn</span>
                <input
                  className={`input ${styles.softInput}`}
                  type="email"
                  value={billing.email}
                  onChange={(e) => setBilling((b) => ({ ...b, email: e.target.value }))}
                />
              </label>
            </div>
            <label className={`checkbox ${styles.vat}`}>
              <input
                type="checkbox"
                checked={billing.vat}
                onChange={(e) => setBilling((b) => ({ ...b, vat: e.target.checked }))}
              />
              Xuất hoá đơn VAT cho công ty
            </label>
          </section>
        </div>

        <aside className={`card ${styles.order}`}>
          <h2 className={styles.stepTitle}>Tóm tắt đơn hàng</h2>
          <div className={styles.product}>
            <span className={styles.productIcon}>
              <Icon name="star" size={18} />
            </span>
            <span>
              <strong>InterviewAI Pro</strong>
              <small>Gói {price.months} tháng</small>
            </span>
          </div>
          <dl className={styles.lines}>
            <div>
              <dt>Giá gói ({price.months} tháng)</dt>
              <dd>{formatVnd(listPrice)}</dd>
            </div>
            {discount > 0 && (
              <div>
                <dt>Ưu đãi thanh toán theo năm</dt>
                <dd className={styles.discount}>-{formatVnd(discount)}</dd>
              </div>
            )}
          </dl>
          <form
            className={styles.coupon}
            onSubmit={(e) => {
              e.preventDefault()
              if (coupon.trim()) setNotice('Mã giảm giá chưa được hỗ trợ.')
            }}
          >
            <input
              className={`input ${styles.softInput}`}
              placeholder="Mã giảm giá"
              value={coupon}
              onChange={(e) => setCoupon(e.target.value)}
              aria-label="Mã giảm giá"
            />
            <button type="submit" className="btn btn-soft">
              Áp dụng
            </button>
          </form>
          <div className={styles.totalRow}>
            <span>Tổng thanh toán</span>
            <strong>{formatVnd(price.total)}</strong>
          </div>
          <p className={styles.vatNote}>Đã bao gồm VAT</p>
          <button
            type="button"
            className={`btn btn-primary btn-lg btn-block ${styles.payButton}`}
            onClick={() => setNotice('Cổng thanh toán chưa được tích hợp, bạn chưa bị trừ tiền.')}
          >
            Thanh toán {formatVnd(price.total)} qua {methodLabel}
          </button>
          {notice && (
            <p role="status" className={`alert alert-warn ${styles.notice}`}>
              {notice}
            </p>
          )}
          <p className={styles.fine}>
            {cycle === 'monthly' ? 'Tự động gia hạn mỗi tháng.' : 'Tự động gia hạn sau 12 tháng.'} Bạn có thể huỷ gia hạn
            bất cứ lúc nào trong Cài đặt tài khoản. Hoàn tiền trong 7 ngày nếu không hài lòng.
          </p>
          <p className={styles.secure}>
            <span aria-hidden>🔒</span> Thanh toán được mã hoá SSL 256-bit
          </p>
        </aside>
      </div>
    </div>
  )
}
