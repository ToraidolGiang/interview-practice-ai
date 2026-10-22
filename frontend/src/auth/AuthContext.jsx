import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react'
import * as authApi from '../api/auth'
import { UNAUTHORIZED_EVENT } from '../api/client'
import { clearSession, loadSession, saveSession } from './authStorage'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [session, setSession] = useState(loadSession)

  const logout = useCallback(() => {
    clearSession()
    setSession(null)
  }, [])

  useEffect(() => {
    window.addEventListener(UNAUTHORIZED_EVENT, logout)
    return () => window.removeEventListener(UNAUTHORIZED_EVENT, logout)
  }, [logout])

  const login = useCallback(async ({ email, password, remember }) => {
    const res = await authApi.login({ email, password })
    const next = {
      accessToken: res.accessToken,
      expiresAt: Date.now() + (res.expiresInHours ?? 24) * 3600 * 1000,
      user: res.user,
    }
    saveSession(next, remember)
    setSession(next)
    return next.user
  }, [])

  const value = useMemo(
    () => ({ user: session?.user ?? null, isAuthenticated: !!session, login, logout }),
    [session, login, logout],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth phải dùng bên trong AuthProvider')
  return ctx
}
