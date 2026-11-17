import { useState } from 'react'
import { Link, useNavigate } from 'react-router'
import { register } from '../api/auth'
import { toFieldErrors, validateRegister } from '../auth/validation'
import { AuthCard, Checkbox, Divider, FormAlert, GoogleButton, SubmitButton, TextField } from '../components/AuthForm'
import styles from '../components/AuthForm.module.css'
import AuthLayout from '../layouts/AuthLayout'

export default function RegisterPage() {
  const navigate = useNavigate()
  const [form, setForm] = useState({ fullName: '', email: '', password: '', confirmPassword: '', agreed: false })
  const [errors, setErrors] = useState({})
  const [emailTaken, setEmailTaken] = useState(false)
  const [formError, setFormError] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  const update = (field) => (e) => {
    const value = e.target.type === 'checkbox' ? e.target.checked : e.target.value
    setForm((f) => ({ ...f, [field]: value }))
    setErrors((errs) => ({ ...errs, [field]: undefined }))
    if (field === 'email') setEmailTaken(false)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setFormError(null)
    const clientErrors = validateRegister(form)
    setErrors(clientErrors)
    if (Object.keys(clientErrors).length) return

    setSubmitting(true)
    const email = form.email.trim()
    try {
      await register({
        fullName: form.fullName.trim(),
        email,
        password: form.password,
        confirmPassword: form.confirmPassword,
      })
      navigate('/login', { replace: true, state: { registeredEmail: email } })
    } catch (err) {
      if (err.code === 'EMAIL_EXISTS' || err.status === 409) {
        setEmailTaken(true)
      } else {
        setErrors(toFieldErrors(err))
        if (err.status !== 400) setFormError(err.message)
      }
      setSubmitting(false)
    }
  }

  return (
    <AuthLayout
      heroTitle="Bắt đầu hành trình chinh phục phỏng vấn"
      heroSubtitle="Tham gia cùng hàng nghìn ứng viên đã cải thiện kỹ năng phỏng vấn với các buổi luyện tập AI và phản hồi theo thời gian thực."
      heroFooter="© 2026 InterviewAI. Bảo lưu mọi quyền."
      bottomNote="Hệ thống đánh giá năng lực phỏng vấn trực tuyến InterviewAI"
    >
      <AuthCard
        wide
        title="Tạo tài khoản"
        subtitle="Đăng ký để bắt đầu sử dụng InterviewAI"
        footer={
          <>
            Bạn đã có tài khoản?
            <Link to="/login">Đăng nhập</Link>
          </>
        }
      >
        <form onSubmit={handleSubmit} noValidate>
          {formError && <FormAlert title="Không đăng ký được">{formError}</FormAlert>}

          <TextField
            label="Họ và tên"
            icon="user"
            name="fullName"
            autoComplete="name"
            placeholder="Nguyễn Văn A"
            value={form.fullName}
            onChange={update('fullName')}
            error={errors.fullName}
          />
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
            errorNode={
              emailTaken ? (
                <>
                  Email này đã được sử dụng.{' '}
                  <Link to="/login" state={{ email: form.email.trim() }}>
                    Đăng nhập?
                  </Link>
                </>
              ) : undefined
            }
          />
          <div className={styles.row}>
            <TextField
              label="Mật khẩu"
              icon="unlock"
              type="password"
              name="password"
              autoComplete="new-password"
              placeholder="••••••••"
              value={form.password}
              onChange={update('password')}
              error={errors.password}
            />
            <TextField
              label="Xác nhận mật khẩu"
              icon="unlock"
              type="password"
              name="confirmPassword"
              autoComplete="new-password"
              placeholder="••••••••"
              value={form.confirmPassword}
              onChange={update('confirmPassword')}
              error={errors.confirmPassword}
            />
          </div>
          <Checkbox checked={form.agreed} onChange={update('agreed')} error={errors.agreed}>
            Tôi đồng ý với <a href="#">điều khoản sử dụng</a> và <a href="#">chính sách bảo mật</a>.
          </Checkbox>

          <SubmitButton icon="userPlus" loading={submitting}>
            Đăng ký
          </SubmitButton>
          <Divider uppercase>Hoặc đăng ký với</Divider>
          <GoogleButton>Đăng ký bằng Google</GoogleButton>
        </form>
      </AuthCard>
    </AuthLayout>
  )
}
