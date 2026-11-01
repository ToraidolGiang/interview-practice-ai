import { useEffect, useState } from 'react'
import { Link, Navigate, useNavigate, useParams } from 'react-router'
import { evaluateSession, getPracticeSession, uploadAnswer } from '../api/practice'
import { getQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import QuestionPills from '../components/QuestionPills'
import RecordingPlayer from '../components/RecordingPlayer'
import {
  formatClock,
  MAX_RECORDING_SECONDS,
  MIN_RECORDING_SECONDS,
  RUBRIC_TIPS,
  STRUCTURE_STEPS,
  WARNING_REMAINING_SECONDS,
} from '../constants/practice'
import { CRITERIA, WEIGHTS } from '../constants/scoring'
import { isRecordingSupported, useAudioRecorder } from '../hooks/useAudioRecorder'
import PracticeLobby from './PracticeLobby'
import styles from './PracticePage.module.css'

export default function PracticePage() {
  const { sessionId } = useParams()
  // Mở từ menu (chưa có phiên): màn chọn cách bắt đầu
  if (!sessionId) return <PracticeLobby />
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
      <div className="container page">
        <p role="alert" className="alert">
          {error.status === 404 || error.status === 403
            ? 'Không tìm thấy phiên luyện tập này.'
            : `Không tải được phiên luyện tập: ${error.message}`}{' '}
          <Link className="link" to="/questions">
            Quay lại Ngân hàng câu hỏi
          </Link>
        </p>
      </div>
    )
  }
  if (!session) return <p className={`container page ${styles.loading}`}>Đang tải phiên luyện tập...</p>

  // Phiên đã gửi chấm thì chuyển sang màn kết quả
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
    <div className="container page">
      <Breadcrumb items={[{ label: 'Ngân hàng câu hỏi', to: '/questions' }]} current="Luyện tập" />
      <div className={styles.layout}>
        <div className={styles.main}>
          <section className={`card ${styles.questionCard}`}>
            <QuestionPills question={question} />
            <h1 className={styles.question}>{question.content}</h1>
          </section>
          <RecorderCard
            canReuseUpload={session.status === 'UPLOADED' || session.status === 'FAILED'}
            failedCode={session.status === 'FAILED' ? session.errorCode : null}
            submitState={submitState}
            onSubmit={submit}
            onCancel={() => navigate('/questions')}
          />
        </div>
        <aside className={styles.side}>
          <HintCard question={question} />
          <WeightsCard questionType={question.questionType} />
        </aside>
      </div>
    </div>
  )
}

function submitErrorMessage(err) {
  if (err.status === 400) return err.message || 'File ghi âm không hợp lệ hoặc ngoài khoảng 10 giây - 3 phút.'
  if (err.code === 'SESSION_PROCESSING') return 'Bài của bạn đang được chấm, vui lòng đợi.'
  return err.message
}

const PROGRESS_MARKS = [
  { at: 0, label: '00:00' },
  { at: MIN_RECORDING_SECONDS, label: `Tối thiểu ${formatClock(MIN_RECORDING_SECONDS)}` },
  {
    at: MAX_RECORDING_SECONDS - WARNING_REMAINING_SECONDS,
    label: `Nhắc lúc ${formatClock(MAX_RECORDING_SECONDS - WARNING_REMAINING_SECONDS)}`,
  },
  { at: MAX_RECORDING_SECONDS, label: formatClock(MAX_RECORDING_SECONDS) },
]

function RecorderCard({ canReuseUpload, failedCode, submitState, onSubmit, onCancel }) {
  const recorder = useAudioRecorder({ maxSeconds: MAX_RECORDING_SECONDS })
  const { status, elapsed, levels, recording, deviceLabel } = recorder
  const supported = isRecordingSupported()

  const isLive = status === 'recording' || status === 'paused'
  const remaining = MAX_RECORDING_SECONDS - elapsed
  const nearLimit = isLive && remaining <= WARNING_REMAINING_SECONDS
  const tooShort = recording && recording.duration < MIN_RECORDING_SECONDS
  const busy = submitState.step !== null

  return (
    <section className={`card ${styles.recorder}`}>
      <div className={styles.recorderTop}>
        {status === 'stopped' ? (
          <span className="pill pill-green">
            <Icon name="check" size={12} strokeWidth={2.6} />
            Đã ghi {formatClock(recording?.duration ?? elapsed)}
          </span>
        ) : isLive ? (
          <span className="pill pill-red pill-dot">Đang ghi âm</span>
        ) : (
          <span className="pill pill-green">{status === 'requesting' ? 'Đang xin quyền micro...' : 'Sẵn sàng ghi âm'}</span>
        )}
        <span className={styles.device}>
          <span aria-hidden>🎙️</span> Microphone: {deviceLabel || 'Mặc định của hệ thống'}
        </span>
      </div>

      {!supported && (
        <p role="alert" className="alert">
          Trình duyệt không hỗ trợ ghi âm. Hãy dùng Chrome, Edge hoặc Firefox bản mới.
        </p>
      )}
      {recorder.error && (
        <p role="alert" className="alert">
          {recorder.error}
        </p>
      )}
      {failedCode && status === 'idle' && (
        <p role="alert" className="alert alert-warn">
          {failedCode === 'ANSWER_TOO_SHORT'
            ? 'Lần chấm trước thất bại vì câu trả lời quá ngắn (dưới 15 từ). Hãy ghi âm lại.'
            : `Lần chấm trước thất bại (${failedCode}). Bạn có thể gửi chấm lại bản đã nộp hoặc ghi âm lại.`}
        </p>
      )}

      {(status === 'idle' || status === 'requesting') && (
        <div className={styles.ready}>
          <button
            type="button"
            className={styles.micButton}
            onClick={recorder.start}
            disabled={!supported || status === 'requesting' || busy}
            aria-label="Bắt đầu ghi âm"
          >
            <Icon name="mic" size={26} strokeWidth={2} />
          </button>
          <p className={styles.readyTitle}>Bắt đầu ghi âm</p>
          <p className={styles.readyHint}>
            Nói từ {MIN_RECORDING_SECONDS} giây đến tối đa {MAX_RECORDING_SECONDS / 60} phút. Hệ thống nhắc khi còn{' '}
            {WARNING_REMAINING_SECONDS} giây và tự dừng ở {formatClock(MAX_RECORDING_SECONDS)}.
          </p>
          {canReuseUpload ? (
            <button type="button" className="btn btn-soft" onClick={() => onSubmit(null)} disabled={busy}>
              <Icon name="sparkle" size={14} />
              {busy ? 'Đang gửi chấm điểm...' : 'Chấm điểm bản đã nộp'}
            </button>
          ) : null}
          <button type="button" className={styles.cancelLink} onClick={onCancel}>
            Huỷ, quay lại danh sách
          </button>
        </div>
      )}

      {isLive && (
        <div className={styles.live}>
          <p className={styles.timer} aria-live="off">
            <span className={nearLimit ? styles.timerWarn : undefined}>{formatClock(elapsed)}</span>
            <small> / {formatClock(MAX_RECORDING_SECONDS)}</small>
          </p>
          <LiveWave levels={levels} />
          <div className={styles.progress}>
            <span style={{ width: `${Math.min(100, (elapsed / MAX_RECORDING_SECONDS) * 100)}%` }} />
          </div>
          <div className={styles.marks}>
            {PROGRESS_MARKS.map((m) => (
              <span key={m.label} style={{ left: `${(m.at / MAX_RECORDING_SECONDS) * 100}%` }}>
                {m.label}
              </span>
            ))}
          </div>
          {nearLimit && (
            <p role="status" className={styles.warn}>
              Còn {Math.ceil(remaining)} giây, hệ thống sẽ tự dừng khi hết giờ.
            </p>
          )}
          <div className={styles.liveActions}>
            <button type="button" className="btn btn-danger btn-lg" onClick={recorder.stop}>
              <Icon name="stop" size={12} />
              Dừng ghi âm
            </button>
            <button type="button" className="btn btn-outline btn-lg" onClick={recorder.reset}>
              Huỷ
            </button>
          </div>
        </div>
      )}

      {status === 'stopped' && recording && (
        <div className={styles.review}>
          <RecordingPlayer src={recording.url} peaks={recording.peaks} fallbackDuration={recording.duration} />
          <p className={styles.reviewNote}>
            {tooShort
              ? `Bản thu ngắn hơn ${MIN_RECORDING_SECONDS} giây nên chưa thể chấm. Hãy ghi âm lại.`
              : 'Nghe lại để chắc chắn giọng rõ, không bị tạp âm. Sau khi nộp, bản ghi được tải lên và chấm điểm trong khoảng 15 giây.'}
          </p>
          <div className={styles.reviewActions}>
            <button type="button" className="btn btn-outline btn-lg" onClick={recorder.reset} disabled={busy}>
              <Icon name="rotateCcw" size={15} />
              Ghi âm lại
            </button>
            <button type="button" className={styles.ghostCancel} onClick={onCancel} disabled={busy}>
              Huỷ
            </button>
            <button
              type="button"
              className={`btn btn-primary btn-lg ${styles.submit}`}
              onClick={() => onSubmit(recording)}
              disabled={tooShort || busy}
            >
              <Icon name="sparkle" size={15} />
              {submitState.step === 'uploading'
                ? 'Đang tải bản thu...'
                : submitState.step === 'evaluating'
                  ? 'Đang gửi chấm điểm...'
                  : 'Nộp bài chấm điểm'}
            </button>
          </div>
        </div>
      )}

      {submitState.error && (
        <p role="alert" className="alert">
          {submitState.error}
        </p>
      )}
    </section>
  )
}

// Sóng âm khi đang ghi: cột mới nhất ở bên phải; cột chưa có âm thanh hiển thị nhạt
function LiveWave({ levels }) {
  const bars = levels.slice(-56)
  return (
    <div className={styles.wave} aria-hidden>
      {bars.map((level, i) => (
        <span
          key={i}
          className={level > 0.02 ? undefined : styles.waveIdle}
          style={{ height: `${Math.max(12, Math.min(100, level * 140))}%` }}
        />
      ))}
    </div>
  )
}

function HintCard({ question }) {
  const structure = STRUCTURE_STEPS[question.questionType]
  return (
    <section className={`card ${styles.sideCard}`}>
      <h2 className={styles.sideTitle}>Gợi ý trả lời</h2>
      {question.answerHint && <p className={styles.hintText}>{question.answerHint}</p>}
      {structure && (
        <>
          <p className={styles.structureTitle}>{structure.title}</p>
          <ol className={styles.steps}>
            {structure.steps.map((step) => (
              <li key={step.key}>
                <span className={styles.stepKey}>{step.key}</span>
                <span>
                  <strong>{step.name}</strong>
                  <small>{step.desc}</small>
                </span>
              </li>
            ))}
          </ol>
        </>
      )}
    </section>
  )
}

function WeightsCard({ questionType }) {
  const weights = WEIGHTS[questionType]
  if (!weights) return null
  return (
    <section className={`card ${styles.sideCard}`}>
      <h2 className={styles.sideTitle}>Bạn sẽ được chấm theo</h2>
      <ul className={styles.weights}>
        {Object.entries(weights).map(([code, weight]) => (
          <li key={code}>
            <div className={styles.weightRow}>
              <span>{CRITERIA[code]?.longLabel ?? CRITERIA[code]?.label ?? code}</span>
              <strong>{weight}%</strong>
            </div>
            <div className={`meter ${styles.weightMeter}`}>
              <span
                style={{ width: `${weight}%` }}
                className={code === 'DELIVERY' ? styles.weightMuted : undefined}
              />
            </div>
          </li>
        ))}
      </ul>
      <p className={styles.tip}>{RUBRIC_TIPS[questionType]}</p>
    </section>
  )
}
