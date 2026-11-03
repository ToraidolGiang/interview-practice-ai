import { useEffect, useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router'
import { forgotPassword } from '../api/auth'
import { isValidEmail } from '../auth/validation'
import { AuthCard, FormAlert, SubmitButton, SuccessPanel, TextField } from '../components/AuthForm'
import styles from '../components/AuthForm.module.css'
import AuthLayout from '../layouts/AuthLayout'

const RESEND_SECONDS = 60

export default function ForgotPasswordPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const [email, setEmail] = useState(location.state?.email ?? '')
  const [error, setError] = useState(null)
  const [formError, setFormError] = useState(null)
  const [sentTo, setSentTo] = useState(null)
  const [submitting, setSubmitting] = useState(false)
  const [cooldown, setCooldown] = useState(0)

  useEffect(() => {
    if (cooldown <= 0) return
    const id = setTimeout(() => setCooldown((c) => c - 1), 1000)
    return () => clearTimeout(id)
  }, [cooldown])

  async function send(target) {
    setSubmitting(true)
    setFormError(null)
    try {
      await forgotPassword(target)
      setSentTo(target)
      setCooldown(RESEND_SECONDS - 1)
    } catch (err) {
      if (err.status === 400) setError('Email không hợp lệ')
      else setFormError(err.message)
    } finally {
      setSubmitting(false)
    }
  }

  function handleSubmit(e) {
    e.preventDefault()
    const value = email.trim()
    if (!value) return setError('Vui lòng nhập email')
    if (!isValidEmail(value)) return setError('Email không hợp lệ')
    send(value)
  }

  const footer = (
    <>
      Đã nhớ ra mật khẩu?
      <Link to="/login">Quay lại đăng nhập</Link>
    </>
  )

  if (sentTo) {
    return (
      <AuthLayout>
        <AuthCard title="Kiểm tra hộp thư của bạn" subtitle={`Chúng tôi đã gửi liên kết đặt lại mật khẩu tới ${sentTo}.`}>
          <SuccessPanel icon="mail" title="Email đã được gửi thành công">
            Mở email và bấm vào liên kết để tạo mật khẩu mới. Liên kết sẽ hết hạn sau 30 phút.
          </SuccessPanel>
          {formError && <FormAlert title="Không gửi lại được">{formError}</FormAlert>}
          <SubmitButton type="button" onClick={() => navigate('/login', { state: { email: sentTo } })}>
            Quay lại đăng nhập
          </SubmitButton>
          <p className={styles.center}>
            Chưa nhận được email?
            <button type="button" onClick={() => send(sentTo)} disabled={cooldown > 0 || submitting}>
              Gửi lại{cooldown > 0 ? ` (${cooldown}s)` : ''}
            </button>
          </p>
        </AuthCard>
      </AuthLayout>
    )
  }

  return (
    <AuthLayout>
      <AuthCard
        title="Quên mật khẩu?"
        subtitle="Nhập email đã đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu cho bạn."
        footer={footer}
      >
        <form onSubmit={handleSubmit} noValidate>
          {formError && <FormAlert title="Không gửi được liên kết">{formError}</FormAlert>}
          <TextField
            label="Email"
            icon="mail"
            type="email"
            name="email"
            autoComplete="email"
            placeholder="name@example.com"
            value={email}
            onChange={(e) => {
              setEmail(e.target.value)
              setError(null)
            }}
            error={error}
          />
          <p className={styles.note}>
            Liên kết có hiệu lực trong 30 phút và chỉ dùng được một lần. Kiểm tra cả hộp thư Spam nếu không thấy email.
          </p>
          <SubmitButton loading={submitting}>Gửi liên kết đặt lại</SubmitButton>
        </form>
      </AuthCard>
    </AuthLayout>
  )
}
