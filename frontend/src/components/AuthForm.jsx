import { useId, useState } from 'react'
import Icon, { GoogleLogo } from './Icon'
import styles from './AuthForm.module.css'

export function AuthCard({ title, subtitle, children, footer, wide }) {
  return (
    <div className={`${styles.container} ${wide ? styles.wide : ''}`}>
      <div className={styles.header}>
        <h2 className={styles.title}>{title}</h2>
        {subtitle && <p className={styles.subtitle}>{subtitle}</p>}
      </div>
      <div className={styles.card}>{children}</div>
      {footer && <p className={styles.footer}>{footer}</p>}
    </div>
  )
}

// invalid: chỉ tô viền đỏ (lỗi đã hiện ở hộp thông báo phía trên)
export function TextField({ label, icon, error, errorNode, invalid: markInvalid, labelAction, type = 'text', ...inputProps }) {
  const id = useId()
  const [revealed, setRevealed] = useState(false)
  const isPassword = type === 'password'
  const hasMessage = !!(error || errorNode)
  const invalid = hasMessage || !!markInvalid

  return (
    <div className={styles.field}>
      <div className={styles.labelRow}>
        <label htmlFor={id} className={styles.label}>
          {label}
        </label>
        {labelAction}
      </div>
      <div className={styles.inputWrap}>
        {icon && <Icon name={icon} size={16} strokeWidth={1.7} className={styles.leadingIcon} />}
        <input
          id={id}
          type={isPassword && revealed ? 'text' : type}
          className={`${styles.input} ${invalid ? styles.inputError : ''}`}
          aria-invalid={invalid}
          aria-describedby={hasMessage ? `${id}-error` : undefined}
          {...inputProps}
        />
        {isPassword && (
          <button
            type="button"
            className={styles.toggle}
            onClick={() => setRevealed((v) => !v)}
            aria-label={revealed ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
            aria-pressed={revealed}
          >
            <Icon name={revealed ? 'eye' : 'eyeOff'} size={16} strokeWidth={1.7} />
          </button>
        )}
      </div>
      {hasMessage && (
        <p id={`${id}-error`} className={styles.fieldError}>
          {errorNode ?? error}
        </p>
      )}
    </div>
  )
}

export function Checkbox({ children, error, ...inputProps }) {
  return (
    <div>
      <label className={styles.checkbox}>
        <input type="checkbox" {...inputProps} />
        <span>{children}</span>
      </label>
      {error && <p className={styles.fieldError}>{error}</p>}
    </div>
  )
}

export function SubmitButton({ icon, loading, disabled, children, type = 'submit', onClick }) {
  return (
    <button type={type} className={styles.submit} disabled={loading || disabled} onClick={onClick}>
      {icon && <Icon name={icon} size={16} strokeWidth={1.8} />}
      {loading ? 'Đang xử lý...' : children}
    </button>
  )
}

/** Hộp thông báo trong thẻ: tone = error | warn | success */
export function FormAlert({ tone = 'error', title, children }) {
  if (!title && !children) return null
  return (
    <div role={tone === 'error' ? 'alert' : 'status'} className={`${styles.alert} ${styles[tone]}`}>
      {title && <strong>{title}</strong>}
      {children && <div>{children}</div>}
    </div>
  )
}

/** Khối kết quả có icon tròn ở giữa (Đã gửi email, Mật khẩu đã cập nhật) */
export function SuccessPanel({ icon, title, children }) {
  return (
    <div className={styles.successPanel} role="status">
      <span className={styles.successIcon}>
        <Icon name={icon} size={20} strokeWidth={1.8} />
      </span>
      <strong>{title}</strong>
      <p>{children}</p>
    </div>
  )
}

export function Divider({ children, uppercase }) {
  return (
    <div className={styles.divider}>
      <span className={uppercase ? styles.dividerUpper : undefined}>{children}</span>
    </div>
  )
}

// Contract API chưa có endpoint OAuth Google
export function GoogleButton({ children }) {
  return (
    <button type="button" className={styles.google} title="Chưa hỗ trợ đăng nhập Google" aria-disabled>
      <GoogleLogo size={18} />
      {children}
    </button>
  )
}
