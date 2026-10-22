import { useEffect, useState } from 'react'
import { Link, Navigate, useNavigate, useParams } from 'react-router'
import iconCheckBadgeSm from '../assets/figma/icon-check-badge-sm.svg'
import iconChevronUp from '../assets/figma/icon-chevron-up.svg'
import iconClock from '../assets/figma/icon-clock.svg'
import iconFolder from '../assets/figma/icon-folder.svg'
import iconLightbulb from '../assets/figma/icon-lightbulb.svg'
import iconMicLevel from '../assets/figma/icon-mic-level.svg'
import iconMicWhite from '../assets/figma/icon-mic-white.svg'
import iconNotes from '../assets/figma/icon-notes.svg'
import iconPause from '../assets/figma/icon-pause.svg'
import iconRerecord from '../assets/figma/icon-rerecord.svg'
import iconSparkle from '../assets/figma/icon-sparkle.svg'
import iconSpeaker from '../assets/figma/icon-speaker.svg'
import iconStarFrame from '../assets/figma/icon-star-frame.svg'
import iconStop from '../assets/figma/icon-stop.svg'
import { evaluateSession, getPracticeSession, uploadAnswer } from '../api/practice'
import { getQuestion } from '../api/questions'
import AudioPlayer from '../components/AudioPlayer'
import {
  ANSWER_FRAMEWORKS,
  formatClock,
  MAX_RECORDING_SECONDS,
  MIN_RECORDING_SECONDS,
  WARNING_REMAINING_SECONDS,
} from '../constants/practice'
import { CRITERIA, WEIGHTS } from '../constants/scoring'
import { industryLabel, levelOf, questionTypeLabel } from '../constants/taxonomy'
import { isRecordingSupported, useAudioRecorder } from '../hooks/useAudioRecorder'
import Placeholder from './Placeholder'
import styles from './PracticePage.module.css'

export default function PracticePage() {
  const { sessionId } = useParams()
  if (!sessionId) {
    return (
      <div>
        <Placeholder
          title="Phòng luyện tập"
          note="Chọn một câu hỏi trong Ngân hàng câu hỏi để bắt đầu phiên luyện tập."
        />
        <p style={{ textAlign: 'center' }}>
          <Link to="/questions">Đến Ngân hàng câu hỏi</Link>
        </p>
      </div>
    )
  }
  // key: đổi phiên thì dựng lại toàn bộ trạng thái ghi âm
  return <PracticeRoom key={sessionId} sessionId={sessionId} />
}

function PracticeRoom({ sessionId }) {
  const navigate = useNavigate()
  const [loaded, setLoaded] = useState({ session: null, question: null, error: null })
  const [submitState, setSubmitState] = useState({ step: null, error: null }) // step: uploading | evaluating

  useEffect(() => {
    let cancelled = false
    getPracticeSession(sessionId)
      .then(async (session) => {
        const question = await getQuestion(session.questionId)
        if (!cancelled) setLoaded({ session, question, error: null })
      })
      .catch((error) => !cancelled && setLoaded({ session: null, question: null, error }))
    return () => {
      cancelled = true
    }
  }, [sessionId])

  const { session, question, error } = loaded
  if (error) {
    return (
      <p role="alert" className={styles.alert}>
        {error.status === 404 || error.status === 403
          ? 'Không tìm thấy phiên luyện tập này.'
          : `Không tải được phiên luyện tập: ${error.message}`}{' '}
        <Link to="/questions">Quay lại Ngân hàng câu hỏi</Link>
      </p>
    )
  }
  if (!session) return <p className={styles.loading}>Đang tải phiên luyện tập...</p>

  // Phiên đã gửi chấm thì chuyển sang màn kết quả (#122)
  if (session.status === 'PROCESSING' || session.status === 'SCORED') {
    return <Navigate to={`/results/${sessionId}`} replace />
  }

  async function submit(recording) {
    setSubmitState({ step: 'uploading', error: null })
    try {
      if (recording) await uploadAnswer(sessionId, recording.blob, recording.duration)
      setSubmitState({ step: 'evaluating', error: null })
      await evaluateSession(sessionId)
      navigate(`/results/${sessionId}`)
    } catch (err) {
      setSubmitState({ step: null, error: submitErrorMessage(err) })
    }
  }

  return (
    <div className={styles.page}>
      <div className={styles.topBar}>
        <nav className={styles.breadcrumb} aria-label="Breadcrumb">
          <img src={iconFolder} alt="" width="21.5" height="16" />
          <Link to="/questions">Ngân hàng câu hỏi</Link>
          <span aria-hidden>/</span>
          <span className={styles.breadcrumbCurrent}>
            <span className={styles.dot} aria-hidden />
            Phiên luyện tập
          </span>
        </nav>
      </div>

      <div className={styles.column}>
        <QuestionCard question={question} />
        <RecorderCard
          canReuseUpload={session.status === 'UPLOADED' || session.status === 'FAILED'}
          failedCode={session.status === 'FAILED' ? session.errorCode : null}
          submitState={submitState}
          onSubmit={submit}
        />
        <FrameworkCard questionType={question.questionType} />
        <NotesCard sessionId={sessionId} />
      </div>
    </div>
  )
}

function submitErrorMessage(err) {
  if (err.status === 400) return err.message || 'File ghi âm không hợp lệ hoặc ngoài khoảng 10 giây - 3 phút.'
  if (err.code === 'SESSION_PROCESSING') return 'Bài của bạn đang được chấm, vui lòng đợi.'
  return err.message
}

function QuestionCard({ question }) {
  const level = levelOf(question.level)
  return (
    <section className={styles.card}>
      <div className={styles.questionTags}>
        <span className={styles.tag}>
          {industryLabel(question.industry)} / {question.position}
        </span>
        <span className={styles.tagMuted}>
          {level ? `${level.badge} • ` : ''}
          {questionTypeLabel(question.questionType).split(' (')[0]}
        </span>
        <span className={styles.tagWarning}>
          <img src={iconClock} alt="" width="20" height="20" />
          Thời lượng tối đa: {formatClock(MAX_RECORDING_SECONDS)}
        </span>
        {/* Đọc đề bằng TTS chưa có trong contract (TTS #121 chỉ đọc phản hồi) */}
        <button type="button" className={styles.listenButton} disabled title="Sắp hỗ trợ">
          <img src={iconSpeaker} alt="" width="18" height="17.5" />
          Nghe AI đọc đề bài
        </button>
      </div>

      <p className={styles.eyebrow}>
        <span className={styles.dot} aria-hidden />
        Đề bài phỏng vấn
      </p>
      <h1 className={styles.questionText}>“{question.content}”</h1>

      {question.answerHint && (
        <div className={styles.hint}>
          <span className={styles.hintIcon}>
            <img src={iconLightbulb} alt="" width="15" height="20" />
          </span>
          <p>
            <strong>Gợi ý trả lời:</strong> {question.answerHint}
          </p>
        </div>
      )}
    </section>
  )
}

function RecorderCard({ canReuseUpload, failedCode, submitState, onSubmit }) {
  const recorder = useAudioRecorder({ maxSeconds: MAX_RECORDING_SECONDS })
  const { status, elapsed, levels, db, recording } = recorder
  const supported = isRecordingSupported()

  const isLive = status === 'recording' || status === 'paused'
  const remaining = MAX_RECORDING_SECONDS - elapsed
  const nearLimit = isLive && remaining <= WARNING_REMAINING_SECONDS
  const tooShort = recording && recording.duration < MIN_RECORDING_SECONDS
  const busy = submitState.step !== null
  const progress = Math.min(100, (elapsed / MAX_RECORDING_SECONDS) * 100)

  let headline = 'Sẵn sàng ghi âm'
  let subline = `Câu trả lời cần dài ${MIN_RECORDING_SECONDS} giây - ${MAX_RECORDING_SECONDS / 60} phút.`
  if (status === 'requesting') headline = 'Đang xin quyền micro...'
  if (status === 'recording') {
    headline = 'Đang thu âm trực tiếp'
    subline = 'Nói rõ ràng, giữ tốc độ vừa phải.'
  }
  if (status === 'paused') {
    headline = 'Đã tạm dừng'
    subline = 'Bấm Tiếp tục để ghi tiếp.'
  }
  if (status === 'stopped') {
    headline = 'Đã ghi xong'
    subline = tooShort
      ? `Bản thu ngắn hơn ${MIN_RECORDING_SECONDS} giây, hãy ghi âm lại.`
      : 'Nghe lại bản thu, ghi lại nếu cần, rồi nộp bài để AI chấm điểm.'
  }

  return (
    <section className={styles.card}>
      <div className={styles.recorderHeader}>
        <div className={styles.recorderStatus}>
          <span
            className={`${styles.liveDot} ${status === 'recording' ? styles.liveDotOn : ''}`}
            aria-hidden
          />
          <div>
            <p className={`${styles.statusTitle} ${isLive ? styles.statusTitleLive : ''}`}>{headline}</p>
            <p className={styles.statusSub}>{subline}</p>
          </div>
        </div>
        {isLive && (
          <span className={styles.meter}>
            <img src={iconMicLevel} alt="" width="14" height="19" />
            Cường độ: <code>{db ?? '--'} dB</code>
          </span>
        )}
      </div>

      {!supported && (
        <p role="alert" className={styles.alert}>
          Trình duyệt không hỗ trợ ghi âm. Hãy dùng Chrome, Edge hoặc Firefox bản mới.
        </p>
      )}
      {recorder.error && (
        <p role="alert" className={styles.alert}>
          {recorder.error}
        </p>
      )}
      {failedCode && status === 'idle' && (
        <p role="alert" className={styles.alert}>
          {failedCode === 'ANSWER_TOO_SHORT'
            ? 'Lần chấm trước thất bại vì câu trả lời quá ngắn (dưới 15 từ). Hãy ghi âm lại.'
            : `Lần chấm trước thất bại (${failedCode}). Bạn có thể gửi chấm lại bản đã nộp hoặc ghi âm lại.`}
        </p>
      )}

      <div className={styles.timerRow}>
        <p className={styles.timer} aria-live="off">
          <span className={nearLimit ? styles.timerWarn : undefined}>{formatClock(elapsed)}</span>
          <span className={styles.timerMax}> / {formatClock(MAX_RECORDING_SECONDS)}</span>
        </p>
        {nearLimit && (
          <p role="status" className={styles.warnChip}>
            Còn {Math.ceil(remaining)} giây, hệ thống sẽ tự dừng khi hết giờ
          </p>
        )}
      </div>

      <div className={styles.progressTrack}>
        <div className={styles.progressFill} style={{ width: `${progress}%` }} />
        <span
          className={styles.minMarker}
          style={{ left: `${(MIN_RECORDING_SECONDS / MAX_RECORDING_SECONDS) * 100}%` }}
          aria-hidden
        />
      </div>
      <div className={styles.progressLabels}>
        <span>0:00</span>
        <span>Tối thiểu {formatClock(MIN_RECORDING_SECONDS)}</span>
        <span>{formatClock(MAX_RECORDING_SECONDS)} (Tối đa)</span>
      </div>

      <div className={styles.waveBox}>
        <p className={styles.waveLabel}>
          <span className={styles.dotGreen} aria-hidden />
          Sóng âm giọng nói
        </p>
        <div className={styles.wave} aria-hidden>
          {levels.map((level, i) => (
            <span key={i} style={{ height: `${Math.max(6, level * 100)}%` }} />
          ))}
        </div>
      </div>

      <div className={styles.controls}>
        <div className={styles.controlsLeft}>
          {(status === 'idle' || status === 'requesting') && (
            <button
              type="button"
              className={styles.recordButton}
              onClick={recorder.start}
              disabled={!supported || status === 'requesting' || busy}
            >
              <img src={iconMicWhite} alt="" width="9.33333" height="12.6667" />
              Bắt đầu ghi âm
            </button>
          )}
          {isLive && (
            <>
              <button type="button" className={styles.stopButton} onClick={recorder.stop}>
                <img src={iconStop} alt="" width="20" height="20" />
                Hoàn thành câu trả lời
              </button>
              <button
                type="button"
                className={styles.secondaryButton}
                onClick={status === 'recording' ? recorder.pause : recorder.resume}
              >
                {status === 'recording' ? (
                  <img src={iconPause} alt="" width="14" height="14" />
                ) : (
                  <img src={iconMicLevel} alt="" width="14" height="19" />
                )}
                {status === 'recording' ? 'Tạm dừng' : 'Tiếp tục'}
              </button>
            </>
          )}
          {(isLive || status === 'stopped') && (
            <button type="button" className={styles.ghostButton} onClick={recorder.reset} disabled={busy}>
              <img src={iconRerecord} alt="" width="18" height="21" />
              Ghi âm lại
            </button>
          )}
        </div>

        {status === 'stopped' && (
          <button
            type="button"
            className={styles.submitButton}
            onClick={() => onSubmit(recording)}
            disabled={tooShort || busy}
          >
            <img src={iconSparkle} alt="" width="22" height="22" />
            {submitState.step === 'uploading'
              ? 'Đang tải bản thu...'
              : submitState.step === 'evaluating'
                ? 'Đang gửi chấm điểm...'
                : 'Nộp bài & Chấm điểm AI'}
          </button>
        )}
        {status === 'idle' && canReuseUpload && (
          <button type="button" className={styles.submitButton} onClick={() => onSubmit(null)} disabled={busy}>
            <img src={iconSparkle} alt="" width="22" height="22" />
            {busy ? 'Đang gửi chấm điểm...' : 'Chấm điểm bản đã nộp'}
          </button>
        )}
      </div>

      {submitState.error && (
        <p role="alert" className={styles.alert}>
          {submitState.error}
        </p>
      )}

      {recording && <AudioPlayer src={recording.url} fallbackDuration={recording.duration} />}
    </section>
  )
}

function FrameworkCard({ questionType }) {
  const [open, setOpen] = useState(true)
  const framework = ANSWER_FRAMEWORKS[questionType]
  if (!framework) return null
  // Thời lượng gợi ý tính trên 150 giây (khoảng giữa giới hạn ghi âm)
  const target = 150
  const weights = WEIGHTS[questionType] ?? {}

  return (
    <section className={`${styles.card} ${styles.frameworkCard}`}>
      <button
        type="button"
        className={styles.frameworkHeader}
        onClick={() => setOpen((v) => !v)}
        aria-expanded={open}
      >
        <span className={styles.frameworkIcon}>
          <img src={iconStarFrame} alt="" width="11" height="18" />
        </span>
        <span className={styles.frameworkTitles}>
          <span className={styles.frameworkTitle}>
            {framework.title}
            <span className={styles.frameworkBadge}>Gợi ý {target}s</span>
          </span>
          <span className={styles.frameworkSub}>
            Khung của tiêu chí Cấu trúc ({weights.STRUCTURE}% điểm) • phân bổ thời lượng gợi ý cho từng phần
          </span>
        </span>
        <span className={styles.collapse}>
          {open ? 'Thu gọn' : 'Mở rộng'}
          <img
            src={iconChevronUp}
            alt=""
            width="12"
            height="7.4"
            className={open ? styles.chevronFlip : undefined}
          />
        </span>
      </button>

      {open && (
        <div className={styles.frameworkBody}>
          <div className={styles.steps} style={{ '--step-count': framework.steps.length }}>
            {framework.steps.map((step) => (
              <div key={step.key} className={`${styles.step} ${step.core ? styles.stepCore : ''}`}>
                <div className={styles.stepTop}>
                  <span className={styles.stepKey}>{step.key}</span>
                  <code>
                    ~{Math.round(step.share * target)}s ({Math.round(step.share * 100)}%)
                  </code>
                </div>
                <p className={styles.stepName}>{step.name}</p>
                <p className={styles.stepDesc}>{step.desc}</p>
              </div>
            ))}
          </div>
          <div className={styles.weights}>
            <span className={styles.weightsLabel}>Câu này được chấm theo:</span>
            {Object.entries(weights).map(([code, weight]) => (
              <span key={code} className={`${styles.weightChip} ${code === 'STRUCTURE' ? styles.weightChipActive : ''}`}>
                {CRITERIA[code]?.label ?? code} <b>{weight}%</b>
              </span>
            ))}
          </div>
          <p className={styles.tip}>
            <img src={iconCheckBadgeSm} alt="" width="22" height="21" />
            <span>
              <strong>Mẹo:</strong> {framework.tip}
            </span>
          </p>
        </div>
      )}
    </section>
  )
}

const NOTES_KEY = (sessionId) => `talentstar.notes.${sessionId}`

// Ghi chú chỉ lưu trên trình duyệt (sessionStorage), không gửi lên server
function NotesCard({ sessionId }) {
  const [notes, setNotes] = useState(() => {
    try {
      return sessionStorage.getItem(NOTES_KEY(sessionId)) || ''
    } catch {
      return ''
    }
  })

  function update(e) {
    setNotes(e.target.value)
    try {
      sessionStorage.setItem(NOTES_KEY(sessionId), e.target.value)
    } catch {
      // bỏ qua
    }
  }

  return (
    <section className={`${styles.card} ${styles.notesCard}`}>
      <div className={styles.notesHeader}>
        <label htmlFor="practice-notes" className={styles.notesTitle}>
          <img src={iconNotes} alt="" width="18" height="16" />
          Ghi chú nháp cá nhân (chỉ hiển thị cho bạn)
        </label>
        <span className={styles.notesBadge}>Lưu trên trình duyệt này</span>
      </div>
      <textarea
        id="practice-notes"
        className={styles.notes}
        value={notes}
        onChange={update}
        rows={3}
        placeholder="Ghi nhanh các từ khóa, ý chính muốn nói..."
      />
    </section>
  )
}
