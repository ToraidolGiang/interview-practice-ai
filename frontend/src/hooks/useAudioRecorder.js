import { useCallback, useEffect, useRef, useState } from 'react'

const BAR_COUNT = 64
const PREFERRED_TYPES = ['audio/webm;codecs=opus', 'audio/webm', 'audio/ogg;codecs=opus', 'audio/mp4']

function pickMimeType() {
  if (typeof MediaRecorder === 'undefined') return null
  return PREFERRED_TYPES.find((t) => MediaRecorder.isTypeSupported(t)) ?? ''
}

export function isRecordingSupported() {
  return typeof navigator !== 'undefined' && !!navigator.mediaDevices?.getUserMedia && pickMimeType() !== null
}

/**
 * Ghi âm bằng MediaRecorder (#117).
 * status: idle | requesting | recording | paused | stopped
 * elapsed: số giây đã ghi (không tính lúc tạm dừng); tự dừng khi chạm maxSeconds.
 * levels: biên độ BAR_COUNT cột gần nhất (0-1) để vẽ sóng âm; db: mức âm lượng hiện tại.
 */
export function useAudioRecorder({ maxSeconds }) {
  const [status, setStatus] = useState('idle')
  const [elapsed, setElapsed] = useState(0)
  const [levels, setLevels] = useState(() => new Array(BAR_COUNT).fill(0))
  const [db, setDb] = useState(null)
  const [recording, setRecording] = useState(null) // { blob, url, duration }
  const [error, setError] = useState(null)

  const recorderRef = useRef(null)
  const streamRef = useRef(null)
  const chunksRef = useRef([])
  const audioCtxRef = useRef(null)
  const rafRef = useRef(0)
  // Thời gian đã ghi trước lần resume gần nhất + mốc bắt đầu đoạn hiện tại
  const accumulatedRef = useRef(0)
  const segmentStartRef = useRef(0)
  const lastBarAtRef = useRef(0)

  const currentElapsed = () =>
    accumulatedRef.current + (segmentStartRef.current ? (performance.now() - segmentStartRef.current) / 1000 : 0)

  const releaseStream = useCallback(() => {
    cancelAnimationFrame(rafRef.current)
    streamRef.current?.getTracks().forEach((t) => t.stop())
    streamRef.current = null
    audioCtxRef.current?.close().catch(() => {})
    audioCtxRef.current = null
  }, [])

  const stop = useCallback(() => {
    const recorder = recorderRef.current
    if (!recorder || recorder.state === 'inactive') return
    accumulatedRef.current = currentElapsed()
    segmentStartRef.current = 0
    recorder.stop()
  }, [])

  const tick = useCallback(
    (analyser, buffer) => {
      const loop = (now) => {
        const recorder = recorderRef.current
        if (!recorder || recorder.state === 'inactive') return
        const seconds = currentElapsed()
        setElapsed(seconds)
        if (seconds >= maxSeconds) {
          stop()
          return
        }
        if (recorder.state === 'recording') {
          analyser.getFloatTimeDomainData(buffer)
          let sum = 0
          for (const v of buffer) sum += v * v
          const rms = Math.sqrt(sum / buffer.length)
          // Thêm một cột mới khoảng 12 lần/giây để sóng âm chạy đều
          if (now - lastBarAtRef.current > 80) {
            lastBarAtRef.current = now
            setLevels((prev) => [...prev.slice(1), Math.min(1, rms * 4)])
            setDb(rms > 0 ? Math.round(20 * Math.log10(rms)) : -100)
          }
        }
        rafRef.current = requestAnimationFrame(loop)
      }
      rafRef.current = requestAnimationFrame(loop)
    },
    [maxSeconds, stop],
  )

  const start = useCallback(async () => {
    setError(null)
    setStatus('requesting')
    let stream
    try {
      stream = await navigator.mediaDevices.getUserMedia({
        audio: { echoCancellation: true, noiseSuppression: true },
      })
    } catch (err) {
      setStatus('idle')
      setError(
        err?.name === 'NotAllowedError'
          ? 'Bạn chưa cấp quyền micro. Hãy cho phép truy cập micro trên trình duyệt rồi thử lại.'
          : 'Không mở được micro. Kiểm tra thiết bị thu âm rồi thử lại.',
      )
      return
    }

    streamRef.current = stream
    const mimeType = pickMimeType()
    const recorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined)
    recorderRef.current = recorder
    chunksRef.current = []
    recorder.ondataavailable = (e) => e.data.size && chunksRef.current.push(e.data)
    recorder.onstop = () => {
      const blob = new Blob(chunksRef.current, { type: recorder.mimeType || 'audio/webm' })
      setRecording({ blob, url: URL.createObjectURL(blob), duration: accumulatedRef.current })
      setElapsed(accumulatedRef.current)
      setStatus('stopped')
      releaseStream()
    }

    const AudioContextClass = window.AudioContext || window.webkitAudioContext
    const audioCtx = new AudioContextClass()
    audioCtxRef.current = audioCtx
    const analyser = audioCtx.createAnalyser()
    analyser.fftSize = 2048
    audioCtx.createMediaStreamSource(stream).connect(analyser)

    accumulatedRef.current = 0
    segmentStartRef.current = performance.now()
    setElapsed(0)
    setLevels(new Array(BAR_COUNT).fill(0))
    recorder.start(1000)
    setStatus('recording')
    tick(analyser, new Float32Array(analyser.fftSize))
  }, [releaseStream, tick])

  const pause = useCallback(() => {
    const recorder = recorderRef.current
    if (recorder?.state !== 'recording') return
    accumulatedRef.current = currentElapsed()
    segmentStartRef.current = 0
    recorder.pause()
    setStatus('paused')
  }, [])

  const resume = useCallback(() => {
    const recorder = recorderRef.current
    if (recorder?.state !== 'paused') return
    segmentStartRef.current = performance.now()
    recorder.resume()
    setStatus('recording')
  }, [])

  const reset = useCallback(() => {
    const recorder = recorderRef.current
    if (recorder && recorder.state !== 'inactive') {
      recorder.onstop = null
      recorder.stop()
    }
    recorderRef.current = null
    releaseStream()
    setRecording((prev) => {
      if (prev) URL.revokeObjectURL(prev.url)
      return null
    })
    accumulatedRef.current = 0
    segmentStartRef.current = 0
    setElapsed(0)
    setDb(null)
    setLevels(new Array(BAR_COUNT).fill(0))
    setStatus('idle')
  }, [releaseStream])

  // Rời trang khi đang ghi thì tắt micro
  useEffect(
    () => () => {
      const recorder = recorderRef.current
      if (recorder && recorder.state !== 'inactive') {
        recorder.onstop = null
        recorder.stop()
      }
      releaseStream()
    },
    [releaseStream],
  )

  return { status, elapsed, levels, db, recording, error, start, pause, resume, stop, reset }
}
