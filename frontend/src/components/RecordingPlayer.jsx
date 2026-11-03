import { useRef, useState } from 'react'
import { formatClock } from '../constants/practice'
import Icon from './Icon'
import styles from './RecordingPlayer.module.css'

// Nghe lại bản thu: nút phát tròn, sóng âm (phần đã phát đậm hơn), bấm vào sóng âm để tua
export default function RecordingPlayer({ src, peaks, fallbackDuration = 0 }) {
  const audioRef = useRef(null)
  const [playing, setPlaying] = useState(false)
  const [current, setCurrent] = useState(0)
  const [duration, setDuration] = useState(fallbackDuration)

  // File webm từ MediaRecorder thường không có duration (Infinity) nên dùng thời lượng đo lúc ghi
  function handleLoaded(e) {
    const d = e.currentTarget.duration
    if (Number.isFinite(d) && d > 0) setDuration(d)
  }

  function toggle() {
    const audio = audioRef.current
    if (!audio) return
    if (audio.paused) audio.play()
    else audio.pause()
  }

  function seek(e) {
    const audio = audioRef.current
    if (!audio || !duration) return
    const rect = e.currentTarget.getBoundingClientRect()
    audio.currentTime = ((e.clientX - rect.left) / rect.width) * duration
  }

  const progress = duration ? Math.min(1, current / duration) : 0

  return (
    <div className={styles.player}>
      <audio
        ref={audioRef}
        src={src}
        preload="metadata"
        onLoadedMetadata={handleLoaded}
        onDurationChange={handleLoaded}
        onTimeUpdate={(e) => setCurrent(e.currentTarget.currentTime)}
        onPlay={() => setPlaying(true)}
        onPause={() => setPlaying(false)}
        onEnded={() => setPlaying(false)}
      />
      <button
        type="button"
        className={styles.play}
        onClick={toggle}
        aria-label={playing ? 'Tạm dừng nghe lại' : 'Nghe lại bản thu'}
      >
        <Icon name={playing ? 'pause' : 'play'} size={16} />
      </button>
      <div className={styles.body}>
        <div
          className={styles.wave}
          onClick={seek}
          role="slider"
          tabIndex={0}
          aria-label="Vị trí phát"
          aria-valuemin={0}
          aria-valuemax={Math.round(duration)}
          aria-valuenow={Math.round(current)}
          onKeyDown={(e) => {
            const audio = audioRef.current
            if (!audio) return
            if (e.key === 'ArrowRight') audio.currentTime = Math.min(duration, audio.currentTime + 5)
            if (e.key === 'ArrowLeft') audio.currentTime = Math.max(0, audio.currentTime - 5)
          }}
        >
          {peaks.map((p, i) => (
            <span
              key={i}
              className={(i + 0.5) / peaks.length <= progress ? styles.played : undefined}
              style={{ height: `${Math.round(p * 100)}%` }}
            />
          ))}
        </div>
        <div className={styles.times}>
          <span>{formatClock(current)}</span>
          <span>{formatClock(duration)}</span>
        </div>
      </div>
    </div>
  )
}
