import { useState } from 'react'
import { Link } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import { FREE_MONTHLY_SESSIONS } from '../constants/plans'
import { CRITERIA } from '../constants/scoring'
import { INDUSTRIES } from '../constants/taxonomy'
import { useProgress } from '../hooks/useProgress'
import { initials } from '../utils/format'
import { loadPrefs, savePrefs } from '../utils/preferences'
import styles from './AccountPages.module.css'

function formatDate(value) {
  const d = value ? new Date(value) : null
  if (!d || Number.isNaN(d.getTime())) return null
  const pad = (n) => String(n).padStart(2, '0')
  return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}`
}

export default function ProfilePage() {
  const { user } = useAuth()
  const progress = useProgress()
  const initial = { fullName: user?.fullName ?? '', ...defaultGoal(loadPrefs(user?.id)) }
  const [form, setForm] = useState(initial)
  const [saved, setSaved] = useState(initial)
  const [notice, setNotice] = useState(null)

  const positions = INDUSTRIES.find((i) => i.value === form.industry)?.positions ?? []
  const dirty = JSON.stringify(form) !== JSON.stringify(saved)
  const joined = formatDate(user?.createdAt)

  function update(field, value) {
    setNotice(null)
    setForm((f) => ({ ...f, [field]: value, ...(field === 'industry' ? { position: '' } : {}) }))
  }

  function save(e) {
    e.preventDefault()
    savePrefs(user?.id, { industry: form.industry, position: form.position })
    const nameChanged = form.fullName.trim() !== (user?.fullName ?? '')
    setSaved({ ...form, fullName: user?.fullName ?? '' })
    setForm((f) => ({ ...f, fullName: user?.fullName ?? '' }))
    setNotice(
      nameChanged
        ? { tone: 'warn', text: 'Đã lưu mục tiêu luyện tập. Đổi họ tên cần API cập nhật hồ sơ, hiện chưa có trên máy chủ.' }
        : { tone: 'success', text: 'Đã lưu mục tiêu luyện tập. Trang Tổng quan sẽ gợi ý câu hỏi theo mục tiêu này.' },
    )
  }

  return (
    <div className="container page">
      <Breadcrumb current="Hồ sơ cá nhân" />
      <h1 className={`page-title ${styles.title}`}>Hồ sơ cá nhân</h1>

      <div className={styles.twoCol}>
        <form className={`card ${styles.profileCard}`} onSubmit={save}>
          <div className={styles.identity}>
            <span className={styles.bigAvatar} aria-hidden>
              {initials(user?.fullName)}
            </span>
            <div>
              <h2>{user?.fullName}</h2>
              <p>Ứng viên{joined && ` · Tham gia từ ${joined}`}</p>
            </div>
          </div>

          <h3 className={styles.sectionTitle}>Thông tin cá nhân</h3>
          <div className={styles.grid2}>
            <label className="field">
              <span className="label">Họ và tên *</span>
              <input className="input" value={form.fullName} onChange={(e) => update('fullName', e.target.value)} required />
            </label>
            <div className="field">
              <label className="label" htmlFor="profile-email">
                Email đăng nhập
              </label>
              <div className={styles.lockedInput}>
                <input id="profile-email" className="input" value={user?.email ?? ''} readOnly />
                <Icon name="lock" size={13} />
              </div>
              <span className="hint">Email dùng để đăng nhập nên không thay đổi được.</span>
            </div>
          </div>

          <h3 className={styles.sectionTitle}>Mục tiêu luyện tập</h3>
          <p className={styles.sectionSub}>Dùng để gợi ý câu hỏi phù hợp trên trang Tổng quan.</p>
          <div className={styles.grid2}>
            <label className="field">
              <span className="label">Ngành</span>
              <select className="select" value={form.industry} onChange={(e) => update('industry', e.target.value)}>
                <option value="">Chưa chọn</option>
                {INDUSTRIES.map((i) => (
                  <option key={i.value} value={i.value}>
                    {i.value}
                  </option>
                ))}
              </select>
            </label>
            <label className="field">
              <span className="label">Vị trí</span>
              <select
                className="select"
                value={form.position}
                onChange={(e) => update('position', e.target.value)}
                disabled={!form.industry}
              >
                <option value="">Chưa chọn</option>
                {positions.map((p) => (
                  <option key={p} value={p}>
                    {p}
                  </option>
                ))}
              </select>
            </label>
          </div>

          {notice && (
            <p role="status" className={`alert alert-${notice.tone} ${styles.notice}`}>
              {notice.text}
            </p>
          )}
          <div className={styles.formActions}>
            <button type="button" className="btn btn-outline" onClick={() => setForm(saved)} disabled={!dirty}>
              Huỷ
            </button>
            <button type="submit" className="btn btn-primary" disabled={!dirty}>
              Lưu thay đổi
            </button>
          </div>
        </form>

        <aside className={`card ${styles.summaryCard}`}>
          <h2 className={styles.cardTitle}>Tóm tắt luyện tập</h2>
          <dl className={styles.summary}>
            <div>
              <dt>Số phiên đã luyện</dt>
              <dd>{progress.status === 'ready' ? progress.total : '--'}</dd>
            </div>
            <div>
              <dt>Tổng điểm trung bình</dt>
              <dd>{progress.avgScore != null ? `${progress.avgScore.toFixed(1)} / 100` : '--'}</dd>
            </div>
            <div>
              <dt>Tiêu chí cần cải thiện</dt>
              <dd>{progress.weakest ? CRITERIA[progress.weakest.code]?.label : '--'}</dd>
            </div>
          </dl>
          <div className={styles.planBox}>
            <p className={styles.planLabel}>Gói miễn phí</p>
            <p className={styles.planText}>
              Còn {Math.max(0, FREE_MONTHLY_SESSIONS - progress.thisMonth)} / {FREE_MONTHLY_SESSIONS} lượt trong tháng
            </p>
            <Link to="/upgrade" className="link">
              Nâng cấp Pro →
            </Link>
          </div>
          <Link to="/history" className={`link ${styles.historyLink}`}>
            Xem lịch sử luyện tập →
          </Link>
        </aside>
      </div>
    </div>
  )
}

function defaultGoal(prefs) {
  return { industry: prefs.industry ?? '', position: prefs.position ?? '' }
}
