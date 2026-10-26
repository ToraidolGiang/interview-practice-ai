import { useEffect, useRef, useState } from 'react'
import iconPlay from '../assets/figma/icon-play.svg'
import { formatClock } from '../constants/practice'
import styles from './AudioPlayer.module.css'

const SPEEDS = [1, 1.25, 1.5]

// Trình nghe lại bản thu (Figma: "Player nghe thử bản thu nhanh")
export default function AudioPlayer({ src, fallbackDuration = 0 }) {
  const audioRef = useRef(null)
  const [playing, setPlaying] = useState(false)
  const [current, setCurrent] = useState(0)
  const [duration, setDuration] = useState(fallbackDuration)
  const [speed, setSpeed] = useState(1)

  useEffect(() => {
    if (audioRef.current) audioRef.current.playbackRate = speed
  }, [speed])

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

  const progress = duration ? Math.min(100, (current / duration) * 100) : 0

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
        className={styles.playButton}
        onClick={toggle}
        aria-label={playing ? 'Tạm dừng nghe lại' : 'Nghe lại bản thu'}
      >
        {playing ? <span className={styles.pauseGlyph} aria-hidden /> : <img src={iconPlay} alt="" width="11" height="14" />}
      </button>
      <span className={styles.time}>
        {formatClock(current)} / {formatClock(duration)}
      </span>
      <div
        className={styles.track}
        onClick={seek}
        role="slider"
        aria-label="Vị trí phát"
        aria-valuemin={0}
        aria-valuemax={Math.round(duration)}
        aria-valuenow={Math.round(current)}
        tabIndex={0}
      >
        <div className={styles.fill} style={{ width: `${progress}%` }} />
      </div>
      <div className={styles.speeds}>
        {SPEEDS.map((s) => (
          <button
            key={s}
            type="button"
            className={`${styles.speed} ${s === speed ? styles.speedActive : ''}`}
            onClick={() => setSpeed(s)}
          >
            {s === 1 ? '1.0' : s}x
          </button>
        ))}
      </div>
    </div>
  )
}
