import { useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router'
import iconLock from '../assets/figma/icon-lock.svg'
import iconLogin from '../assets/figma/icon-login.svg'
import iconMail from '../assets/figma/icon-mail.svg'
import { useAuth } from '../auth/AuthContext'
import { toFieldErrors, validateLogin } from '../auth/validation'
import {
  AuthCard,
  Checkbox,
  Divider,
  FormAlert,
  GoogleButton,
  SubmitButton,
  TextField,
} from '../components/AuthForm'
import styles from '../components/AuthForm.module.css'
import AuthLayout from '../layouts/AuthLayout'

function loginErrorMessage(error) {
  if (error.status === 401) return 'Email hoặc mật khẩu không đúng'
  if (error.code === 'ACCOUNT_LOCKED')
    return 'Tài khoản tạm khoá do đăng nhập sai quá 5 lần. Vui lòng thử lại sau 15 phút.'
  if (error.status === 400) return null
  return error.message
}

export default function LoginPage() {
  const { login } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()

  const [form, setForm] = useState({
    email: location.state?.registeredEmail || '',
    password: '',
    remember: false,
  })
  const [errors, setErrors] = useState({})
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  const update = (field) => (e) => {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value
    setForm((f) => ({ ...f, [field]: value }))
    setErrors((errs) => ({ ...errs, [field]: undefined }))
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setFormError(null)
    const clientErrors = validateLogin(form)
    setErrors(clientErrors)
    if (Object.keys(clientErrors).length) return

    setSubmitting(true)
    try {
      await login({ email: form.email.trim(), password: form.password, remember: form.remember })
      navigate(location.state?.from?.pathname || '/questions', { replace: true })
    } catch (err) {
      setErrors(toFieldErrors(err))
      setFormError(loginErrorMessage(err))
      setSubmitting(false)
    }
  }

  return (
    <AuthLayout
      heroTitle="Chinh phục buổi phỏng vấn tiếp theo cùng AI"
      heroSubtitle="Nhận phản hồi cá nhân hóa, xây dựng sự tự tin và tiến gần hơn đến công việc mơ ước qua các buổi phỏng vấn thử thông minh."
      heroFooter="© 2026 TalentSTAR AI"
    >
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
        <form className={styles.form} onSubmit={handleSubmit} noValidate>
          <FormAlert tone="success">
            {location.state?.registeredEmail && !formError
              ? 'Đăng ký thành công. Vui lòng đăng nhập để tiếp tục.'
              : null}
          </FormAlert>
          <FormAlert>{formError}</FormAlert>

          <TextField
            label="Email"
            icon={iconMail}
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
            icon={iconLock}
            type="password"
            name="password"
            autoComplete="current-password"
            placeholder="••••••••"
            value={form.password}
            onChange={update('password')}
            error={errors.password}
            labelAction={
              <Link to="/forgot-password" className={styles.link}>
                Quên mật khẩu?
              </Link>
            }
          />
          <Checkbox checked={form.remember} onChange={update('remember')}>
            Ghi nhớ đăng nhập
          </Checkbox>

          <SubmitButton icon={iconLogin} loading={submitting}>
            Đăng nhập
          </SubmitButton>
          <Divider>Hoặc đăng nhập với</Divider>
          <GoogleButton>Đăng nhập với Google</GoogleButton>
        </form>
      </AuthCard>
    </AuthLayout>
  )
}
