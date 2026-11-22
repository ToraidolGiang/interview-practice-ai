import { useEffect, useRef } from 'react'
import Icon from './Icon'
import styles from './Modal.module.css'

const FOCUSABLE = 'button:not([disabled]), [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'

/**
 * Hộp thoại chứa form (role=dialog). Render có điều kiện: có mặt = đang mở.
 * Escape hoặc nút đóng gọi onClose (bỏ qua khi busy); bấm nền không đóng để khỏi mất nội dung đang nhập.
 * Focus vào trường đầu tiên khi mở, Tab xoay vòng trong hộp, trả focus về phần tử trước đó khi đóng.
 */
export default function Modal({ title, subtitle, busy = false, onClose, children }) {
  const dialogRef = useRef(null)
  const closeHandler = useRef(onClose)
  const busyRef = useRef(busy)

  useEffect(() => {
    closeHandler.current = onClose
    busyRef.current = busy
  })

  useEffect(() => {
    const previous = document.activeElement
    const first = dialogRef.current?.querySelector('textarea, input, select')
    ;(first ?? dialogRef.current)?.focus()
    return () => previous?.focus?.()
  }, [])

  function onKeyDown(e) {
    if (e.key === 'Escape') {
      e.stopPropagation()
      if (!busyRef.current) closeHandler.current()
      return
    }
    if (e.key !== 'Tab') return
    const items = [...dialogRef.current.querySelectorAll(FOCUSABLE)]
    if (items.length === 0) return
    const first = items[0]
    const last = items[items.length - 1]
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault()
      last.focus()
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault()
      first.focus()
    }
  }

  return (
    <div className={styles.backdrop} onKeyDown={onKeyDown}>
      <div
        ref={dialogRef}
        className={styles.dialog}
        tabIndex={-1}
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-title"
      >
        <header className={styles.header}>
          <div>
            <h2 id="modal-title" className={styles.title}>
              {title}
            </h2>
            {subtitle && <p className={styles.subtitle}>{subtitle}</p>}
          </div>
          <button type="button" className={styles.close} onClick={onClose} disabled={busy} aria-label="Đóng">
            <Icon name="x" size={16} />
          </button>
        </header>
        {children}
      </div>
    </div>
  )
}
