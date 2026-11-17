import { request } from './client'

export function login({ email, password }) {
  return request('/auth/login', { method: 'POST', body: { email, password }, auth: false })
}

export function register({ fullName, email, password, confirmPassword }) {
  return request('/auth/register', {
    method: 'POST',
    body: { fullName, email, password, confirmPassword },
    auth: false,
  })
}

// Luôn trả 200 dù email có tồn tại hay không (không lộ danh sách tài khoản)
export function forgotPassword(email) {
  return request('/auth/forgot-password', { method: 'POST', body: { email }, auth: false })
}

// Token trong email, dùng một lần, hết hạn sau 30 phút; sai/hết hạn trả 400 INVALID_TOKEN
export function resetPassword({ token, newPassword, confirmPassword }) {
  return request('/auth/reset-password', {
    method: 'POST',
    body: { token, newPassword, confirmPassword },
    auth: false,
  })
}
