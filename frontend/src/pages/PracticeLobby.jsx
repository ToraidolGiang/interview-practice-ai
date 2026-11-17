import { Link } from 'react-router'
import { randomQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import { RecentSessions, SuggestionGrid } from '../components/DashboardWidgets'
import Icon from '../components/Icon'
import { MAX_RECORDING_SECONDS, MIN_RECORDING_SECONDS } from '../constants/practice'
import { useProgress } from '../hooks/useProgress'
import { useStartPractice } from '../hooks/useStartPractice'
import { useSuggestions } from '../hooks/useSuggestions'
import styles from './PracticeLobby.module.css'

// Phòng luyện tập khi mở từ menu, chưa gắn với phiên nào (Figma chưa có màn riêng; dùng thành phần của Tổng quan)
export default function PracticeLobby() {
  const progress = useProgress()
  const latest = progress.details[0]?.question
  const suggestions = useSuggestions({ industry: latest?.industry, position: latest?.position })
  const { start, startingId, error } = useStartPractice()

  async function practiceRandom() {
    try {
      await start(async () => (await randomQuestion({ industry: latest?.industry })).id, 'random')
    } catch {
      // Không có câu theo ngành: lấy ngẫu nhiên trong toàn ngân hàng
      await start(async () => (await randomQuestion({})).id, 'random').catch(() => {})
    }
  }

  return (
    <div className="container page">
      <Breadcrumb current="Phòng luyện tập" />
      <div className={styles.titleRow}>
        <div>
          <h1 className="page-title">Phòng luyện tập</h1>
          <p className="page-sub">
            Chọn một câu hỏi, trả lời bằng giọng nói từ {MIN_RECORDING_SECONDS} giây đến {MAX_RECORDING_SECONDS / 60}{' '}
            phút, AI chấm theo rubric và gợi ý cách cải thiện.
          </p>
        </div>
        <div className={styles.actions}>
          <button type="button" className="btn btn-outline" onClick={practiceRandom} disabled={startingId !== null}>
            <span aria-hidden>🎲</span>
            {startingId === 'random' ? 'Đang chuẩn bị...' : 'Chọn ngẫu nhiên'}
          </button>
          <Link to="/questions" className="btn btn-primary">
            <Icon name="search" size={15} />
            Chọn trong ngân hàng
          </Link>
        </div>
      </div>
      {error && (
        <p role="alert" className="alert">
          {error}
        </p>
      )}

      <div className={styles.layout}>
        <section className="card">
          <h2 className={styles.cardTitle}>Gợi ý để bắt đầu</h2>
          <p className={styles.cardSub}>
            {latest ? `Cùng vị trí ${latest.position} với lần luyện gần nhất.` : 'Các câu hỏi phổ biến trong ngân hàng.'}
          </p>
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
                : progress.details.slice(0, 4).map((d) => ({ session: d, question: d.question }))
            }
          />
        </section>
      </div>
    </div>
  )
}
