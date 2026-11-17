// Chữ cái đầu của họ và tên cuối: "Nguyễn Văn A" -> "NA"
export function initials(fullName = '') {
  const parts = fullName.trim().split(/\s+/).filter(Boolean)
  if (!parts.length) return '?'
  return (parts.length > 1 ? parts[0][0] + parts.at(-1)[0] : parts[0][0]).toUpperCase()
}

// "14:25 • Hôm nay" / "14:25 • Hôm qua" / "21/10/2025"
export function formatRecentTime(value) {
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return ''
  const pad = (n) => String(n).padStart(2, '0')
  const today = new Date()
  const days = Math.round(
    (new Date(today.getFullYear(), today.getMonth(), today.getDate()) -
      new Date(date.getFullYear(), date.getMonth(), date.getDate())) /
      864e5,
  )
  const time = `${pad(date.getHours())}:${pad(date.getMinutes())}`
  if (days === 0) return `${time} • Hôm nay`
  if (days === 1) return `${time} • Hôm qua`
  return `${pad(date.getDate())}/${pad(date.getMonth() + 1)}/${date.getFullYear()}`
}
