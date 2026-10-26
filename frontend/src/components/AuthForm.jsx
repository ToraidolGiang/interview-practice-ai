import { useId, useState } from 'react'
import googleLogo from '../assets/figma/google.svg'
import iconEyeOff from '../assets/figma/icon-eye-off.svg'
import styles from './AuthForm.module.css'

export function AuthCard({ title, subtitle, children, footer, wide }) {
  return (
    <div className={`${styles.container} ${wide ? styles.wide : ''}`}>
      <div className={styles.header}>
        <h2 className={`${styles.title} ${wide ? styles.titleLarge : ''}`}>{title}</h2>
        <p className={styles.subtitle}>{subtitle}</p>
      </div>
      <div className={styles.card}>{children}</div>
      <p className={styles.footer}>{footer}</p>
    </div>
  )
}

export function TextField({ label, icon, error, labelAction, type = 'text', ...inputProps }) {
  const id = useId()
  const [revealed, setRevealed] = useState(false)
  const isPassword = type === 'password'

  return (
    <div className={styles.field}>
      <div className={styles.labelRow}>
        <label htmlFor={id} className={styles.label}>
          {label}
        </label>
        {labelAction}
      </div>
      <div className={styles.inputWrap}>
        <img className={styles.leadingIcon} src={icon} alt="" width="16" height="16" />
        <input
          id={id}
          type={isPassword && revealed ? 'text' : type}
          className={[
            styles.input,
            isPassword ? styles.inputWithToggle : '',
            error ? styles.inputError : '',
          ].join(' ')}
          aria-invalid={!!error}
          aria-describedby={error ? `${id}-error` : undefined}
          {...inputProps}
        />
        {isPassword && (
          <button
            type="button"
            className={`${styles.toggle} ${revealed ? styles.toggleActive : ''}`}
            onClick={() => setRevealed((v) => !v)}
            aria-label={revealed ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
            aria-pressed={revealed}
          >
            <img src={iconEyeOff} alt="" width="16" height="16" />
          </button>
        )}
      </div>
      {error && (
        <p id={`${id}-error`} className={styles.fieldError}>
          {error}
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

export function SubmitButton({ icon, loading, children }) {
  return (
    <button type="submit" className={styles.submit} disabled={loading}>
      <img src={icon} alt="" width="16" height="16" />
      {loading ? 'Đang xử lý...' : children}
    </button>
  )
}

export function FormAlert({ children, tone = 'error' }) {
  if (!children) return null
  return (
    <p role={tone === 'error' ? 'alert' : 'status'} className={styles[tone]}>
      {children}
    </p>
  )
}

export function Divider({ children, uppercase }) {
  return (
    <div className={styles.divider}>
      <span className={uppercase ? styles.dividerUpper : undefined}>{children}</span>
    </div>
  )
}

// Contract API (openapi.yaml v0.2.0) chưa có endpoint OAuth Google nên nút để disabled
export function GoogleButton({ children }) {
  return (
    <button type="button" className={styles.google} disabled title="Chưa hỗ trợ">
      <img src={googleLogo} alt="" width="16" height="16" />
      {children}
    </button>
  )
}

