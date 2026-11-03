import { useState } from 'react'
import { Link } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import { PASSWORD_MIN_LENGTH } from '../auth/validation'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import { loadPrefs, savePrefs } from '../utils/preferences'
import styles from './AccountPages.module.css'

const LANGUAGES = [
  { value: 'vi', label: 'Tiếng Việt', sub: 'Mặc định' },
  { value: 'en', label: 'English', sub: 'Interface only' },
]

export default function SettingsPage() {
  const { user } = useAuth()
  const [prefs, setPrefs] = useState(() => ({
    language: 'vi',
    weeklyReminder: true,
    newsletter: false,
    ...loadPrefs(user?.id),
  }))

  function update(changes) {
    setPrefs(savePrefs(user?.id, changes))
  }

  return (
    <div className="container page">
      <Breadcrumb current="Cài đặt tài khoản" />
      <h1 className={`page-title ${styles.title}`}>Cài đặt tài khoản</h1>

      <div className={styles.settings}>
        <section className="card">
          <h2 className={styles.cardTitle}>Ngôn ngữ giao diện</h2>
          <div className={styles.options} role="radiogroup" aria-label="Ngôn ngữ giao diện">
            {LANGUAGES.map((lang) => (
              <OptionCard
                key={lang.value}
                checked={prefs.language === lang.value}
                onSelect={() => update({ language: lang.value })}
                title={lang.label}
                sub={lang.sub}
              />
            ))}
          </div>
          <p className={styles.infoBox}>
            <Icon name="info" size={13} />
            Chỉ đổi ngôn ngữ hiển thị trên giao diện. Câu hỏi, phần trả lời và chấm điểm vẫn bằng tiếng Việt. Lựa chọn
            được lưu theo tài khoản.
            {prefs.language === 'en' && ' Giao diện tiếng Anh đang được hoàn thiện.'}
          </p>
        </section>

        <ChangePasswordCard />

        <section className="card">
          <h2 className={styles.cardTitle}>Thông báo qua email</h2>
          <Toggle
            title="Nhắc luyện tập hằng tuần"
            sub="Gửi vào sáng thứ Hai nếu tuần trước bạn chưa luyện."
            checked={prefs.weeklyReminder}
            onChange={(v) => update({ weeklyReminder: v })}
          />
          <Toggle
            title="Tin tức và tính năng mới"
            sub="Tối đa 1 email mỗi tháng."
            checked={prefs.newsletter}
            onChange={(v) => update({ newsletter: v })}
          />
        </section>

        <section className="card">
          <h2 className={styles.cardTitle}>Dữ liệu của bạn</h2>
          <p className={styles.paragraph}>
            Bản ghi âm được tự động xoá sau 6 tháng. Transcript, điểm số và nhận xét được giữ trong lịch sử để bạn theo dõi
            tiến bộ. Chỉ bạn xem được lịch sử của mình.
          </p>
        </section>
      </div>
    </div>
  )
}

export function OptionCard({ checked, onSelect, title, sub, aside }) {
  return (
    <button
      type="button"
      role="radio"
      aria-checked={checked}
      className={`${styles.option} ${checked ? styles.optionOn : ''}`}
      onClick={onSelect}
    >
      <span className={styles.radio} aria-hidden />
      <span className={styles.optionText}>
        <strong>{title}</strong>
        <small>{sub}</small>
      </span>
      {aside}
    </button>
  )
}

function Toggle({ title, sub, checked, onChange }) {
  return (
    <label className={styles.toggleRow}>
      <span>
        <strong>{title}</strong>
        <small>{sub}</small>
      </span>
      <input type="checkbox" role="switch" checked={checked} onChange={(e) => onChange(e.target.checked)} />
      <span className={styles.switch} aria-hidden />
    </label>
  )
}

// Contract API chỉ có đặt lại mật khẩu qua email; đổi mật khẩu khi đã đăng nhập chưa có endpoint
function ChangePasswordCard() {
  const [form, setForm] = useState({ current: '', next: '', confirm: '' })
  const [errors, setErrors] = useState({})
  const [notice, setNotice] = useState(false)

  const update = (field) => (e) => {
    setForm((f) => ({ ...f, [field]: e.target.value }))
    setErrors((errs) => ({ ...errs, [field]: undefined }))
    setNotice(false)
  }

  function submit(e) {
    e.preventDefault()
    const next = {}
    if (!form.current) next.current = 'Vui lòng nhập mật khẩu hiện tại'
    if (form.next.length < PASSWORD_MIN_LENGTH) next.next = `Mật khẩu tối thiểu ${PASSWORD_MIN_LENGTH} ký tự`
    if (form.confirm !== form.next) next.confirm = 'Mật khẩu xác nhận không khớp'
    setErrors(next)
    if (!Object.keys(next).length) setNotice(true)
  }

  return (
    <form className="card" onSubmit={submit} noValidate>
      <h2 className={styles.cardTitle}>Đổi mật khẩu</h2>
      <div className={styles.stackFields}>
        <label className="field">
          <span className="label">Mật khẩu hiện tại *</span>
          <input
            className={`input ${errors.current ? 'input-error' : ''}`}
            type="password"
            autoComplete="current-password"
            value={form.current}
            onChange={update('current')}
          />
          {errors.current && <span className="field-error">{errors.current}</span>}
        </label>
        <label className="field">
          <span className="label">Mật khẩu mới *</span>
          <input
            className={`input ${errors.next ? 'input-error' : ''}`}
            type="password"
            autoComplete="new-password"
            value={form.next}
            onChange={update('next')}
          />
          {errors.next ? (
            <span className="field-error">{errors.next}</span>
          ) : (
            <span className="hint">Tối thiểu 8 ký tự, nên có chữ hoa, chữ thường và chữ số.</span>
          )}
        </label>
        <label className="field">
          <span className="label">Xác nhận mật khẩu mới *</span>
          <input
            className={`input ${errors.confirm ? 'input-error' : ''}`}
            type="password"
            autoComplete="new-password"
            value={form.confirm}
            onChange={update('confirm')}
          />
          {errors.confirm && <span className="field-error">{errors.confirm}</span>}
        </label>
      </div>
      {notice && (
        <p role="status" className={`alert alert-warn ${styles.notice}`}>
          Máy chủ chưa hỗ trợ đổi mật khẩu khi đang đăng nhập. Bạn có thể đặt lại mật khẩu qua email tại{' '}
          <Link className="link" to="/forgot-password">
            Quên mật khẩu
          </Link>
          .
        </p>
      )}
      <div className={styles.formActions}>
        <button type="submit" className="btn btn-primary">
          Cập nhật mật khẩu
        </button>
      </div>
    </form>
  )
}
