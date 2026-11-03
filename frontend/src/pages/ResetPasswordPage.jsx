import { useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router'
import { resetPassword } from '../api/auth'
import { passwordChecks, passwordStrength, PASSWORD_MIN_LENGTH } from '../auth/validation'
import { AuthCard, FormAlert, SubmitButton, SuccessPanel, TextField } from '../components/AuthForm'
import styles from '../components/AuthForm.module.css'
import Icon from '../components/Icon'
import AuthLayout from '../layouts/AuthLayout'

// Liên kết trong email: /reset-password?token=...&email=...
export default function ResetPasswordPage() {
  const navigate = useNavigate()
  const [params] = useSearchParams()
  const token = params.get('token')
  const email = params.get('email')

  const [form, setForm] = useState({ newPassword: '', confirmPassword: '' })
  const [errors, setErrors] = useState({})
  const [formError, setFormError] = useState(null)
  const [status, setStatus] = useState(token ? 'form' : 'expired') // form | done | expired
  const [submitting, setSubmitting] = useState(false)

  const update = (field) => (e) => {
    setForm((f) => ({ ...f, [field]: e.target.value }))
    setErrors((errs) => ({ ...errs, [field]: undefined }))
  }

  async function handleSubmit(e) {
    e.preventDefault()
    const next = {}
    if (form.newPassword.length < PASSWORD_MIN_LENGTH) next.newPassword = `Mật khẩu tối thiểu ${PASSWORD_MIN_LENGTH} ký tự`
    if (form.confirmPassword !== form.newPassword) next.confirmPassword = 'Mật khẩu xác nhận không khớp'
    setErrors(next)
    if (Object.keys(next).length) return

    setSubmitting(true)
    setFormError(null)
    try {
      await resetPassword({ token, ...form })
      setStatus('done')
    } catch (err) {
      if (err.code === 'INVALID_TOKEN') setStatus('expired')
      else if (err.status === 400) setErrors(Object.fromEntries((err.fieldErrors ?? []).map((f) => [f.field, f.message])))
      else setFormError(err.message)
    } finally {
      setSubmitting(false)
    }
  }

  const footer = (
    <>
      Đã nhớ ra mật khẩu?
      <Link to="/login">Quay lại đăng nhập</Link>
    </>
  )

  if (status === 'done') {
    return (
      <AuthLayout>
        <AuthCard title="Đổi mật khẩu thành công" subtitle="Bạn có thể đăng nhập bằng mật khẩu mới ngay bây giờ.">
          <SuccessPanel icon="check" title="Mật khẩu đã được cập nhật">
            Vì an toàn, các phiên đăng nhập trên thiết bị khác đã được đăng xuất.
          </SuccessPanel>
          <SubmitButton type="button" onClick={() => navigate('/login', { replace: true, state: { email } })}>
            Đăng nhập ngay
          </SubmitButton>
        </AuthCard>
      </AuthLayout>
    )
  }

  if (status === 'expired') {
    return (
      <AuthLayout>
        <AuthCard
          title="Liên kết không hợp lệ hoặc đã hết hạn"
          subtitle="Liên kết đặt lại mật khẩu chỉ dùng được một lần và có hiệu lực 30 phút. Hãy yêu cầu gửi liên kết mới."
          footer={footer}
        >
          <FormAlert tone="warn" title="Liên kết đã hết hạn">
            Vì an toàn, mỗi liên kết chỉ dùng được một lần.
          </FormAlert>
          <SubmitButton type="button" onClick={() => navigate('/forgot-password', { state: { email } })}>
            Gửi lại liên kết
          </SubmitButton>
        </AuthCard>
      </AuthLayout>
    )
  }

  const strength = passwordStrength(form.newPassword)
  const checks = passwordChecks(form.newPassword)

  return (
    <AuthLayout>
      <AuthCard
        title="Đặt mật khẩu mới"
        subtitle={email ? `Tạo mật khẩu mới cho tài khoản ${email}.` : 'Tạo mật khẩu mới cho tài khoản của bạn.'}
        footer={footer}
      >
        <form onSubmit={handleSubmit} noValidate>
          {formError && <FormAlert title="Không cập nhật được mật khẩu">{formError}</FormAlert>}
          <TextField
            label="Mật khẩu mới"
            icon="unlock"
            type="password"
            autoComplete="new-password"
            placeholder="••••••••"
            value={form.newPassword}
            onChange={update('newPassword')}
            error={errors.newPassword}
          />
          <TextField
            label="Xác nhận mật khẩu mới"
            icon="unlock"
            type="password"
            autoComplete="new-password"
            placeholder="••••••••"
            value={form.confirmPassword}
            onChange={update('confirmPassword')}
            error={errors.confirmPassword}
          />
          <div className={styles.strength} aria-hidden>
            {[1, 2, 3, 4].map((i) => (
              <span key={i} className={i <= strength.level ? styles.on : undefined} />
            ))}
          </div>
          <p className={styles.strengthLabel}>Độ mạnh: {strength.label}</p>
          <ul className={styles.rules}>
            {checks.map((c) => (
              <li key={c.label} className={c.ok ? styles.ok : undefined}>
                <Icon name={c.ok ? 'check' : 'circle'} size={12} strokeWidth={c.ok ? 2.4 : 2} />
                {c.label}
              </li>
            ))}
          </ul>
          <SubmitButton loading={submitting}>Cập nhật mật khẩu</SubmitButton>
        </form>
      </AuthCard>
    </AuthLayout>
  )
}
