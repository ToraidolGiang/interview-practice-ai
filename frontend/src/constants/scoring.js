// Rubric chấm điểm cho giao diện, theo docs/business/Rubric_Cham_Diem.md (rubric-v1.0).
// Không còn chấm 4 trụ S/T/A/R cố định: mỗi loại câu hỏi có bộ tiêu chí và trọng số riêng.
// Trình tự tình huống → nhiệm vụ → hành động → kết quả chỉ là mô tả tiêu chí Cấu trúc của câu hỏi hành vi.
export const RUBRIC_VERSION = 'rubric-v1.0'

export const CRITERIA = {
  RELEVANCE: {
    key: 'R',
    label: 'Độ liên quan',
    desc: 'Trả lời trúng và đủ các ý câu hỏi yêu cầu',
    anchor5: 'Trả lời trúng và đầy đủ các ý câu hỏi yêu cầu, không lạc đề.',
  },
  STRUCTURE: {
    key: 'S',
    label: 'Cấu trúc',
    desc: 'Mạch trả lời theo khung của loại câu hỏi',
    anchor5: 'Mạch trả lời rõ ràng theo khung của loại câu hỏi.',
  },
  DEPTH: {
    key: 'D',
    label: 'Độ cụ thể',
    desc: 'Ví dụ, số liệu, vai trò cá nhân, lập luận',
    anchor5: 'Chi tiết cụ thể, có số liệu hoặc kết quả đo được, nêu rõ đóng góp cá nhân và bài học.',
  },
  CORRECTNESS: {
    key: 'C',
    label: 'Đúng chuyên môn',
    desc: 'Đối chiếu với các ý chính của đáp án tham chiếu',
    anchor5: 'Đúng và đủ các ý chính của đáp án tham chiếu, không có sai sót đáng kể.',
  },
  DELIVERY: {
    key: 'V',
    label: 'Trình bày',
    longLabel: 'Trình bày (tốc độ, từ đệm)',
    desc: 'Tốc độ nói và từ đệm, tính tự động không dùng AI',
    anchor5: 'Tốc độ 100-170 từ/phút và không quá 2 từ đệm trên 100 từ.',
  },
}

// Khung của tiêu chí Cấu trúc theo loại câu hỏi (rubric mục 3.1)
export const STRUCTURE_FRAMEWORK = {
  BEHAVIORAL: {
    name: 'Trình tự kể',
    steps: 'Tình huống → Nhiệm vụ → Hành động → Kết quả',
    anchor5: 'Đủ tình huống, nhiệm vụ, hành động và kết quả, rõ vai trò cá nhân, trình tự hợp lý.',
  },
  SITUATIONAL: {
    name: 'Trình tự',
    steps: 'Phân tích → Quyết định → Lý do',
    anchor5: 'Nêu cách tiếp cận có thứ tự, giải thích lý do, cân nhắc rủi ro hoặc phương án khác.',
  },
  TECHNICAL: {
    name: 'Trình tự',
    steps: 'Khái niệm → Giải thích → Ví dụ',
    anchor5: 'Mạch rõ: khái niệm, cơ chế, ví dụ hoặc trường hợp áp dụng.',
  },
  INTRO: {
    name: 'Trình tự',
    steps: 'Hiện tại → Quá khứ → Định hướng',
    anchor5: 'Mạch lạc, nối kinh nghiệm với vị trí ứng tuyển và định hướng.',
  },
}

// Trọng số theo loại câu hỏi (rubric mục 4), tổng mỗi loại = 100
export const WEIGHTS = {
  BEHAVIORAL: { RELEVANCE: 20, STRUCTURE: 30, DEPTH: 40, DELIVERY: 10 },
  SITUATIONAL: { RELEVANCE: 25, STRUCTURE: 25, DEPTH: 40, DELIVERY: 10 },
  TECHNICAL: { RELEVANCE: 15, STRUCTURE: 15, DEPTH: 25, CORRECTNESS: 35, DELIVERY: 10 },
  INTRO: { RELEVANCE: 25, STRUCTURE: 30, DEPTH: 35, DELIVERY: 10 },
}

export function criterionDesc(code, questionType) {
  if (code === 'STRUCTURE' && STRUCTURE_FRAMEWORK[questionType]) {
    const f = STRUCTURE_FRAMEWORK[questionType]
    return `${f.name}: ${f.steps}`
  }
  return CRITERIA[code]?.desc ?? ''
}

export function anchor5(code, questionType) {
  if (code === 'STRUCTURE' && STRUCTURE_FRAMEWORK[questionType]) return STRUCTURE_FRAMEWORK[questionType].anchor5
  return CRITERIA[code]?.anchor5 ?? ''
}

// Điểm 1 ứng với 0%, điểm 5 ứng với 100% trọng số (rubric mục 4)
export function contribution(score, weight) {
  return (weight * (score - 1)) / 4
}

export function formatPoints(value) {
  return Number(value).toLocaleString('en-US', { maximumFractionDigits: 1 })
}

// Dải WPM tối ưu (5 điểm) trong rubric mục 5
export const WPM_IDEAL = [100, 170]
// Thang hiển thị tốc độ nói trên màn kết quả (Chậm ... Nhanh)
export const WPM_SCALE = [40, 240]

export const FAILED_MESSAGES = {
  ANSWER_TOO_SHORT: 'Câu trả lời quá ngắn (dưới 15 từ) nên không thể chấm. Hãy ghi âm lại câu trả lời đầy đủ hơn.',
  STT_ERROR: 'Không nhận diện được giọng nói trong bản ghi. Kiểm tra micro rồi ghi âm lại, hoặc gửi chấm lại.',
  LLM_ERROR: 'Dịch vụ chấm điểm AI đang gặp sự cố. Bạn có thể gửi chấm lại sau ít phút.',
  INVALID_RESULT: 'Kết quả chấm điểm không hợp lệ. Bạn có thể gửi chấm lại.',
  SERVER_RESTART: 'Máy chủ khởi động lại trong lúc chấm. Bạn có thể gửi chấm lại.',
}

// Mức điểm hiển thị ở Lịch sử / Tổng quan (Figma: Xuất sắc, Rất tốt, Cần cải thiện)
export function scoreBand(total) {
  if (total >= 90) return { label: 'Xuất sắc', tone: 'green' }
  if (total >= 80) return { label: 'Rất tốt', tone: 'green' }
  if (total >= 60) return { label: 'Cần cải thiện', tone: 'amber' }
  return { label: 'Chưa đạt', tone: 'red' }
}

// Điểm phụ của Delivery theo Rubric_Cham_Diem.md mục 5 (giá trị khởi đầu, khớp DeliveryCalculator)
export function wpmScore(wpm) {
  if (wpm >= 100 && wpm <= 170) return 5
  if ((wpm >= 80 && wpm <= 99) || (wpm >= 171 && wpm <= 190)) return 4
  if ((wpm >= 60 && wpm <= 79) || (wpm >= 191 && wpm <= 210)) return 3
  if ((wpm >= 40 && wpm <= 59) || (wpm >= 211 && wpm <= 240)) return 2
  return 1
}

export function fillerScore(rate) {
  if (rate <= 2) return 5
  if (rate <= 4) return 4
  if (rate <= 6) return 3
  if (rate <= 9) return 2
  return 1
}

const SCORE_WORDS = { 5: 'Lý tưởng', 4: 'Khá', 3: 'Trung bình', 2: 'Yếu', 1: 'Kém' }

export function wpmVerdict(wpm) {
  const score = wpmScore(wpm)
  const label = score === 5 ? 'Lý tưởng' : wpm < WPM_IDEAL[0] ? 'Hơi chậm' : 'Hơi nhanh'
  return { score, label, tone: score >= 4 ? 'green' : 'amber' }
}

export function fillerVerdict(rate) {
  const score = fillerScore(rate)
  return { score, label: score === 5 ? 'Rất tốt' : SCORE_WORDS[score], tone: score >= 4 ? 'green' : 'amber' }
}
