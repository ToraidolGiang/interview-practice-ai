import { Link } from 'react-router'
import { useAuth } from '../auth/AuthContext'
import { RecentSessions, SuggestionGrid } from '../components/DashboardWidgets'
import Icon from '../components/Icon'
import { FREE_MONTHLY_SESSIONS, WEEKLY_GOAL } from '../constants/plans'
import { CRITERIA, WPM_IDEAL } from '../constants/scoring'
import { questionContext, questionTypeLabel } from '../constants/taxonomy'
import { useProgress } from '../hooks/useProgress'
import { useStartPractice } from '../hooks/useStartPractice'
import { useSuggestions } from '../hooks/useSuggestions'
import { loadPrefs } from '../utils/preferences'
import styles from './DashboardPage.module.css'

function greeting(hour) {
  if (hour < 11) return 'Chào buổi sáng'
  if (hour < 13) return 'Chào buổi trưa'
  if (hour < 18) return 'Chào buổi chiều'
  return 'Chào buổi tối'
}

const WEAK_HINTS = {
  RELEVANCE: 'Câu trả lời đôi khi chưa đi thẳng vào câu hỏi',
  STRUCTURE: 'Mạch trả lời chưa theo khung rõ ràng',
  DEPTH: 'Thiếu số liệu đo được trong câu trả lời',
  CORRECTNESS: 'Còn thiếu ý chính của đáp án chuẩn',
}

export default function DashboardPage() {
  const { user } = useAuth()
  const progress = useProgress()
  const firstName = user?.fullName ?? ''

  const latest = progress.details[0]
  // Ưu tiên mục tiêu luyện tập đã lưu ở Hồ sơ, nếu chưa có thì theo lần luyện gần nhất
  const goal = loadPrefs(user?.id)
  const target = goal.industry ? goal : latest?.question
  const suggestions = useSuggestions({
    industry: target?.industry,
    position: target?.position || undefined,
    exclude: progress.details.map((d) => d.questionId),
  })

  const streakText =
    progress.streak > 0
      ? `Bạn đang có chuỗi luyện tập ${progress.streak} ngày liên tiếp. Giữ nhịp thêm 1 phiên hôm nay nhé!`
      : 'Hôm nay là ngày tốt để bắt đầu một phiên luyện tập mới.'

  return (
    <div className="container page">
      <div className={styles.welcome}>
        <div>
          <h1 className="page-title">
            {greeting(new Date().getHours())}, {firstName} <span aria-hidden>👋</span>
          </h1>
          <p className="page-sub">{streakText}</p>
        </div>
        <Link to="/questions" className={`btn btn-primary ${styles.newSession}`}>
          <Icon name="plus" size={15} strokeWidth={2.4} />
          Bắt đầu phiên luyện mới
        </Link>
      </div>

      <div className={styles.topRow}>
        <RetryHero details={progress.details} loading={progress.status === 'loading'} />
        <WeeklyGoal days={progress.weekDays} done={progress.thisWeek} />
      </div>

      <Kpis progress={progress} />

      <div className={styles.bottomRow}>
        <section className="card">
          <div className={styles.cardHead}>
            <div>
              <h2 className={styles.cardTitle}>Đề xuất cho bạn</h2>
              <p className={styles.cardSub}>
                {progress.weakest
                  ? `AI chọn dựa trên tiêu chí ${CRITERIA[progress.weakest.code]?.label} đang thấp nhất${target?.position ? ` và vị trí ${target.position}` : ''}.`
                  : 'Các câu hỏi phổ biến để bạn bắt đầu luyện tập.'}
              </p>
            </div>
            <Link to="/questions" className="link">
              Ngân hàng câu hỏi
              <Icon name="arrowRight" size={13} strokeWidth={2.2} />
            </Link>
          </div>
          <SuggestionGrid questions={suggestions} />
        </section>

        <section className="card">
          <div className={styles.cardHead}>
            <h2 className={styles.cardTitle}>Phiên gần đây</h2>
            <Link to="/history" className="link">
              Xem tất cả
              <Icon name="arrowRight" size={13} strokeWidth={2.2} />
            </Link>
          </div>
          <RecentSessions
            items={
              progress.status === 'loading'
                ? null
                : progress.details.slice(0, 3).map((d) => ({ session: d, question: d.question }))
            }
          />
        </section>
      </div>
    </div>
  )
}

// Thẻ lớn: gợi ý luyện lại câu có điểm thấp nhất trong các phiên gần đây
function RetryHero({ details, loading }) {
  const { start, startingId, error } = useStartPractice()
  const target = details
    .filter((d) => d.question && d.totalScore != null)
    .sort((a, b) => a.totalScore - b.totalScore)[0]

  if (!target) {
    return (
      <section className={styles.hero}>
        <span className={styles.heroTag}>BẮT ĐẦU NGAY</span>
        <h2 className={styles.heroTitle}>
          {loading ? 'Đang tải...' : 'Chọn câu hỏi đầu tiên và luyện trả lời bằng giọng nói'}
        </h2>
        <p className={styles.heroMeta}>Chấm điểm theo rubric trong khoảng 15 giây, kèm nhận xét chi tiết.</p>
        <div className={styles.heroActions}>
          <Link to="/questions" className={styles.heroButton}>
            Chọn câu hỏi
            <Icon name="arrowRight" size={14} strokeWidth={2.2} />
          </Link>
        </div>
      </section>
    )
  }

  const q = target.question
  const weakest = [...(target.scoreResult?.criteria ?? [])].sort((a, b) => a.score - b.score)[0]
  return (
    <section className={styles.hero}>
      <span className={styles.heroTag}>LUYỆN LẠI ĐỂ CẢI THIỆN ĐIỂM</span>
      <h2 className={styles.heroTitle}>{q.content}</h2>
      <p className={styles.heroMeta}>
        {questionContext(q)} • {questionTypeLabel(q.questionType)} • Lần trước {target.totalScore.toFixed(1)} điểm
        {weakest && `, ${CRITERIA[weakest.code]?.label} ${weakest.score}/5`}
      </p>
      {error && <p className={styles.heroError}>{error}</p>}
      <div className={styles.heroActions}>
        <button type="button" className={styles.heroButton} onClick={() => start(q.id)} disabled={startingId !== null}>
          {startingId ? 'Đang tạo phiên...' : 'Luyện lại câu này'}
          <Icon name="arrowRight" size={14} strokeWidth={2.2} />
        </button>
        <Link to="/questions" className={styles.heroLink}>
          hoặc chọn câu khác
        </Link>
      </div>
    </section>
  )
}

function WeeklyGoal({ days, done }) {
  const left = Math.max(0, WEEKLY_GOAL - done)
  return (
    <section className={`card ${styles.goal}`}>
      <div className={styles.goalHead}>
        <h2 className={styles.cardTitle}>Mục tiêu tuần này</h2>
        <strong>
          {done} / {WEEKLY_GOAL} phiên
        </strong>
      </div>
      <div className="meter">
        <span style={{ width: `${Math.min(100, (done / WEEKLY_GOAL) * 100)}%` }} />
      </div>
      <ol className={styles.days}>
        {days.map((d) => (
          <li key={d.label}>
            <span className={d.done ? styles.dayDone : styles.dayTodo}>
              {d.done && <Icon name="check" size={12} strokeWidth={3} />}
            </span>
            {d.label}
          </li>
        ))}
      </ol>
      <p className={styles.goalNote}>
        {left > 0 ? `Còn ${left} phiên nữa là đạt mục tiêu tuần này.` : 'Bạn đã đạt mục tiêu tuần này. Tuyệt vời!'}
      </p>
    </section>
  )
}

function Kpis({ progress }) {
  const { avgScore, scoreDelta, avgWpm, avgFiller, olderFiller, weakest, thisMonth } = progress
  const dash = '--'
  const wpmIdeal = avgWpm != null && avgWpm >= WPM_IDEAL[0] && avgWpm <= WPM_IDEAL[1]
  const freeLeft = Math.max(0, FREE_MONTHLY_SESSIONS - thisMonth)

  return (
    <div className={styles.kpis}>
      <article className={`card ${styles.kpi}`}>
        <p className={styles.kpiLabel}>Tổng điểm trung bình</p>
        <p className={styles.kpiValue}>
          {avgScore != null ? avgScore.toFixed(1) : dash}
          <small>/ 100</small>
        </p>
        {scoreDelta != null && (
          <p className={scoreDelta >= 0 ? styles.good : styles.warn}>
            {scoreDelta >= 0 ? '↑' : '↓'} {scoreDelta >= 0 ? '+' : ''}
            {scoreDelta.toFixed(1)} điểm so với các phiên trước
          </p>
        )}
      </article>
      <article className={`card ${styles.kpi}`}>
        <p className={styles.kpiLabel}>Tốc độ nói trung bình</p>
        <p className={styles.kpiValue}>
          {avgWpm != null ? Math.round(avgWpm) : dash}
          <small>WPM</small>
        </p>
        <p className={wpmIdeal || avgWpm == null ? styles.good : styles.warn}>
          Lý tưởng {WPM_IDEAL.join('–')} từ/phút
        </p>
      </article>
      <article className={`card ${styles.kpi}`}>
        <p className={styles.kpiLabel}>Từ đệm / 100 từ</p>
        <p className={styles.kpiValue}>
          {avgFiller != null ? avgFiller.toFixed(1) : dash}
          <small>lần</small>
        </p>
        {olderFiller != null && avgFiller != null && (
          <p className={avgFiller <= olderFiller ? styles.good : styles.warn}>
            {avgFiller <= olderFiller ? 'Giảm' : 'Tăng'} từ {olderFiller.toFixed(1)} ở các phiên trước
          </p>
        )}
      </article>
      <article className={`card ${styles.kpi}`}>
        <p className={styles.kpiLabel}>Điểm yếu cần cải thiện</p>
        <p className={styles.kpiValue}>
          {weakest ? CRITERIA[weakest.code]?.label : dash}
          {weakest && <small>{weakest.avg.toFixed(1)} / 5</small>}
        </p>
        {weakest && <p className={styles.orange}>{WEAK_HINTS[weakest.code]}</p>}
      </article>
      <article className={`card ${styles.kpi} ${styles.plan}`}>
        <p className={styles.kpiLabel}>Gói miễn phí</p>
        <p className={styles.kpiValue}>
          {freeLeft}
          <small>/ {FREE_MONTHLY_SESSIONS} lượt còn lại</small>
        </p>
        <Link to="/upgrade" className="link">
          Nâng cấp Pro
          <Icon name="arrowRight" size={12} strokeWidth={2.2} />
        </Link>
      </article>
    </div>
  )
}
