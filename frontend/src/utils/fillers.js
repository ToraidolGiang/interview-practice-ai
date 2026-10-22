// Đánh dấu từ đệm trong transcript để hiển thị, cùng quy tắc với DeliveryCalculator (filler-vi-v1)
// ở backend. Chỉ dùng cho giao diện; số liệu chính thức là fillerCount do server trả về.
const PHRASES = [['nói', 'chung', 'là'], ['à', 'ừm'], ['kiểu', 'như'], ['kiểu', 'là']]
const WORDS = new Set(['ừm', 'ờ', 'ơ', 'hmm'])

const normalize = (token) =>
  token
    .normalize('NFC')
    .toLowerCase()
    .replace(/^[\p{P}\p{S}]+|[\p{P}\p{S}]+$/gu, '')

/**
 * Tách transcript thành các đoạn { text, filler } giữ nguyên khoảng trắng gốc.
 */
export function splitFillers(transcript) {
  if (!transcript) return []
  const parts = transcript.split(/(\s+)/)
  // Chỉ số các token là từ (bỏ khoảng trắng và token chỉ có dấu câu)
  const wordIdx = []
  parts.forEach((p, i) => {
    if (!/^\s*$/.test(p) && normalize(p)) wordIdx.push(i)
  })
  const words = wordIdx.map((i) => normalize(parts[i]))
  const marked = new Set()

  let w = 0
  while (w < words.length) {
    const phrase = PHRASES.find((ph) => ph.every((t, k) => words[w + k] === t))
    if (phrase) {
      // Đánh dấu cả khoảng trắng giữa các từ trong cụm để tô liền một khối
      for (let i = wordIdx[w]; i <= wordIdx[w + phrase.length - 1]; i++) marked.add(i)
      w += phrase.length
      continue
    }
    if (WORDS.has(words[w]) || (w > 0 && words[w] === words[w - 1])) marked.add(wordIdx[w])
    w++
  }

  const segments = []
  parts.forEach((text, i) => {
    const filler = marked.has(i)
    const last = segments.at(-1)
    if (last && last.filler === filler) last.text += text
    else segments.push({ text, filler })
  })
  return segments
}
