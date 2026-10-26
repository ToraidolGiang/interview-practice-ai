// Đánh dấu từ đệm và trích dẫn trong transcript để hiển thị. Quy tắc từ đệm giống DeliveryCalculator
// (filler-vi-v1) ở backend; số liệu chính thức vẫn là fillerCount do server trả về.
const PHRASES = [['nói', 'chung', 'là'], ['à', 'ừm'], ['kiểu', 'như'], ['kiểu', 'là']]
const WORDS = new Set(['ừm', 'ờ', 'ơ', 'hmm'])
const EDGE_PUNCT = /^[\p{P}\p{S}]+|[\p{P}\p{S}]+$/gu

const normalize = (text) => text.normalize('NFC').toLowerCase()

/** Các token từ kèm vị trí ký tự (đã bỏ dấu câu hai đầu). */
function tokens(transcript) {
  const result = []
  for (const m of transcript.matchAll(/\S+/g)) {
    const raw = m[0]
    const lead = raw.length - raw.replace(/^[\p{P}\p{S}]+/u, '').length
    const trail = raw.length - raw.replace(/[\p{P}\p{S}]+$/u, '').length
    const word = normalize(raw).replace(EDGE_PUNCT, '')
    if (word) result.push({ word, start: m.index + lead, end: m.index + raw.length - trail })
  }
  return result
}

/** Vị trí các từ đệm: [{ start, end, label }] */
export function fillerRanges(transcript) {
  const words = tokens(transcript ?? '')
  const ranges = []
  let i = 0
  while (i < words.length) {
    const phrase = PHRASES.find((ph) => ph.every((t, k) => words[i + k]?.word === t))
    if (phrase) {
      ranges.push({ start: words[i].start, end: words[i + phrase.length - 1].end, label: phrase.join(' ') })
      i += phrase.length
      continue
    }
    const { word, start, end } = words[i]
    if (WORDS.has(word)) ranges.push({ start, end, label: word })
    else if (i > 0 && word === words[i - 1].word) ranges.push({ start, end, label: `${word} ${word}` })
    i++
  }
  return ranges
}

/** Đếm theo từng loại từ đệm, nhiều nhất trước: [{ label, count }] */
export function fillerBreakdown(transcript) {
  const counts = new Map()
  for (const r of fillerRanges(transcript)) counts.set(r.label, (counts.get(r.label) ?? 0) + 1)
  return [...counts].map(([label, count]) => ({ label, count })).sort((a, b) => b.count - a.count)
}

/** Vị trí các trích dẫn (không phân biệt hoa thường, bỏ dấu câu hai đầu); trích dẫn không tìm thấy thì bỏ qua. */
export function quoteRanges(transcript, quotes) {
  const haystack = normalize(transcript ?? '')
  const ranges = []
  for (const quote of quotes) {
    const needle = normalize(quote ?? '').trim().replace(/^[\p{P}\p{S}\s]+|[\p{P}\p{S}\s]+$/gu, '')
    if (!needle) continue
    const start = haystack.indexOf(needle)
    if (start >= 0) ranges.push({ start, end: start + needle.length })
  }
  return ranges
}

/**
 * Tách transcript thành các đoạn { text, filler, quote } giữ nguyên văn bản gốc.
 */
export function highlightTranscript(transcript, quotes = []) {
  if (!transcript) return []
  const marks = Array.from({ length: transcript.length }, () => ({ filler: false, quote: false }))
  for (const r of fillerRanges(transcript)) for (let i = r.start; i < r.end; i++) marks[i].filler = true
  for (const r of quoteRanges(transcript, quotes)) for (let i = r.start; i < r.end; i++) marks[i].quote = true

  const segments = []
  for (let i = 0; i < transcript.length; i++) {
    const last = segments.at(-1)
    const { filler, quote } = marks[i]
    if (last && last.filler === filler && last.quote === quote) last.text += transcript[i]
    else segments.push({ text: transcript[i], filler, quote })
  }
  return segments
}
