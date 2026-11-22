import { useEffect, useRef } from 'react'
import styles from './ConfirmDialog.module.css'

const FOCUSABLE = 'button:not([disabled]), [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'

/**
 * Hộp thoại xác nhận hành động phá huỷ (role=alertdialog). Render có điều kiện: có mặt = đang mở.
 * Focus vào nút Huỷ khi mở, Escape đóng, Tab xoay vòng trong hộp, trả focus về phần tử trước đó khi đóng.
 */
export default function ConfirmDialog({ title, message, confirmLabel, busy = false, error, onConfirm, onCancel }) {
  const dialogRef = useRef(null)
  const cancelRef = useRef(null)
  const cancelHandler = useRef(onCancel)
  const busyRef = useRef(busy)

  useEffect(() => {
    cancelHandler.current = onCancel
    busyRef.current = busy
  })

  useEffect(() => {
    const previous = document.activeElement
    cancelRef.current?.focus()
    return () => previous?.focus?.()
  }, [])

  // Nút đang focus bị disabled khi busy làm focus rơi về body: giữ focus trên hộp thoại, xong thì trả về nút Huỷ
  useEffect(() => {
    const dialog = dialogRef.current
    if (busy) dialog?.focus()
    else if (document.activeElement === dialog) cancelRef.current?.focus()
  }, [busy])

  function onKeyDown(e) {
    if (e.key === 'Escape') {
      e.stopPropagation()
      if (!busyRef.current) cancelHandler.current()
      return
    }
    if (e.key !== 'Tab') return
    if (busyRef.current) {
      e.preventDefault()
      dialogRef.current.focus()
      return
    }
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
    } else if (!dialogRef.current.contains(document.activeElement)) {
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
        style={{ outline: 'none' }}
        role="alertdialog"
        aria-modal="true"
        aria-labelledby="confirm-title"
        aria-describedby="confirm-desc"
      >
        <h2 id="confirm-title" className={styles.title}>
          {title}
        </h2>
        <p id="confirm-desc" className={styles.message}>
          {message}
        </p>
        {error && (
          <p role="alert" className="alert">
            {error}
          </p>
        )}
        <div className={styles.actions}>
          <button ref={cancelRef} type="button" className="btn btn-outline" onClick={onCancel} disabled={busy}>
            Huỷ
          </button>
          <button type="button" className="btn btn-danger" onClick={onConfirm} disabled={busy}>
            {busy ? 'Đang xử lý...' : confirmLabel}
          </button>
        </div>
      </div>
    </div>
  )
}
