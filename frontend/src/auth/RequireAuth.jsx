import { Navigate, Outlet, useLocation } from 'react-router'
import { useAuth } from './AuthContext'

export function RequireAuth() {
  const { isAuthenticated } = useAuth()
  const location = useLocation()
  if (!isAuthenticated) return <Navigate to="/login" replace state={{ from: location }} />
  return <Outlet />
}

// Trang đăng nhập/đăng ký: đã đăng nhập thì chuyển vào app
export function GuestOnly() {
  const { isAuthenticated } = useAuth()
  if (isAuthenticated) return <Navigate to="/questions" replace />
  return <Outlet />
}
