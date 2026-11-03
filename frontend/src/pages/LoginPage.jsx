import { useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import { toFieldErrors, validateLogin } from '../auth/validation'
import { AuthCard, Checkbox, Divider, FormAlert, GoogleButton, SubmitButton, TextField } from '../components/AuthForm'
import styles from '../components/AuthForm.module.css'
import AuthLayout from '../layouts/AuthLayout'

export default function LoginPage() {
  const { login } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()

  const [form, setForm] = useState({
    email: location.state?.registeredEmail || location.state?.email || '',
    password: '',
    remember: false,
  })
  const [errors, setErrors] = useState({})
  // null | 'invalid' (sai email/mật khẩu) | 'locked' (khoá 15 phút) | { message }
  const [failure, setFailure] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  const update = (field) => (e) => {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value
    setForm((f) => ({ ...f, [field]: value }))
    setErrors((errs) => ({ ...errs, [field]: undefined }))
    // Đổi email thì cho thử lại tài khoản khác
    if (field === 'email' && failure === 'locked') setFailure(null)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    const clientErrors = validateLogin(form)
    setErrors(clientErrors)
    if (Object.keys(clientErrors).length) return

    setSubmitting(true)
    setFailure(null)
    try {
      await login({ email: form.email.trim(), password: form.password, remember: form.remember })
      navigate(location.state?.from?.pathname || '/dashboard', { replace: true })
    } catch (err) {
      if (err.code === 'ACCOUNT_LOCKED' || err.status === 423) setFailure('locked')
      else if (err.status === 401) setFailure('invalid')
      else if (err.status === 400) setErrors(toFieldErrors(err))
      else setFailure({ message: err.message })
      setSubmitting(false)
    }
  }

  const registered = location.state?.registeredEmail && !failure

  return (
    <AuthLayout>
      <AuthCard
        title="Đăng nhập"
        subtitle="Nhập thông tin đăng nhập để truy cập tài khoản của bạn"
        footer={
          <>
            Bạn chưa có tài khoản?
            <Link to="/register">Đăng ký ngay</Link>
          </>
        }
      >
        <form onSubmit={handleSubmit} noValidate>
          {registered && (
            <FormAlert tone="success" title="Đăng ký thành công.">
              Vui lòng đăng nhập để tiếp tục.
            </FormAlert>
          )}
          {failure === 'invalid' && (
            <FormAlert title="Email hoặc mật khẩu không chính xác.">
              Vui lòng kiểm tra lại. Nếu quên mật khẩu, bấm “Quên mật khẩu?”.
            </FormAlert>
          )}
          {failure === 'locked' && (
            <FormAlert tone="warn" title="Tài khoản đang tạm khoá 15 phút">
              Bạn đã nhập sai mật khẩu 5 lần liên tiếp. Thử lại sau 15 phút, hoặc đặt lại mật khẩu để mở khoá ngay.
              <br />
              <Link to="/forgot-password" state={{ email: form.email }}>
                Đặt lại mật khẩu →
              </Link>
            </FormAlert>
          )}
          {failure?.message && <FormAlert title="Không đăng nhập được">{failure.message}</FormAlert>}

          <TextField
            label="Email"
            icon="mail"
            type="email"
            name="email"
            autoComplete="email"
            placeholder="name@example.com"
            value={form.email}
            onChange={update('email')}
            error={errors.email}
          />
          <TextField
            label="Mật khẩu"
            icon="unlock"
            type="password"
            name="password"
            autoComplete="current-password"
            placeholder="••••••••"
            value={form.password}
            onChange={update('password')}
            error={errors.password}
            invalid={failure === 'invalid'}
            labelAction={
              <Link to="/forgot-password" state={{ email: form.email }} className={styles.link}>
                Quên mật khẩu?
              </Link>
            }
          />
          <Checkbox checked={form.remember} onChange={update('remember')}>
            Ghi nhớ đăng nhập
          </Checkbox>

          <SubmitButton icon="login" loading={submitting} disabled={failure === 'locked'}>
            Đăng nhập
          </SubmitButton>
          <Divider>Hoặc đăng nhập với</Divider>
          <GoogleButton>Đăng nhập với Google</GoogleButton>
        </form>
      </AuthCard>
    </AuthLayout>
  )
}
