import { Navigate, Route, Routes } from 'react-router'
import { GuestOnly, RequireAuth } from './auth/RequireAuth'
import AppLayout from './layouts/AppLayout'
import HistoryPage from './pages/HistoryPage'
import LoginPage from './pages/LoginPage'
import NotFoundPage from './pages/NotFoundPage'
import PracticePage from './pages/PracticePage'
import QuestionsPage from './pages/QuestionsPage'
import RegisterPage from './pages/RegisterPage'

export default function App() {
  return (
    <Routes>
      <Route element={<GuestOnly />}>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />
      </Route>

      <Route element={<RequireAuth />}>
        <Route element={<AppLayout />}>
          <Route path="/questions" element={<QuestionsPage />} />
          <Route path="/practice" element={<PracticePage />} />
          <Route path="/history" element={<HistoryPage />} />
        </Route>
      </Route>

      <Route path="/" element={<Navigate to="/questions" replace />} />
      <Route path="*" element={<NotFoundPage />} />
    </Routes>
  )
}
