// Nhãn tiêu chí và quy tắc hiển thị, theo docs/business/Rubric_Cham_Diem.md
export const CRITERIA = {
  RELEVANCE: { key: 'R', label: 'Đúng trọng tâm', desc: 'Trả lời đúng câu hỏi được hỏi' },
  STRUCTURE: { key: 'S', label: 'Cấu trúc', desc: 'Mạch trả lời theo khung phù hợp loại câu hỏi' },
  DEPTH: { key: 'D', label: 'Chiều sâu', desc: 'Chi tiết, ví dụ và mức độ thuyết phục' },
  CORRECTNESS: { key: 'C', label: 'Đúng chuyên môn', desc: 'Chính xác về kiến thức (câu hỏi chuyên môn)' },
}

// Dải WPM tối ưu (5 điểm) trong rubric mục 5
export const WPM_IDEAL = [100, 170]
export const WPM_SCALE_MAX = 240

export const FAILED_MESSAGES = {
  ANSWER_TOO_SHORT: 'Câu trả lời quá ngắn (dưới 15 từ) nên không thể chấm. Hãy ghi âm lại câu trả lời đầy đủ hơn.',
  STT_ERROR: 'Không nhận diện được giọng nói trong bản ghi. Kiểm tra micro rồi ghi âm lại, hoặc gửi chấm lại.',
  LLM_ERROR: 'Dịch vụ chấm điểm AI đang gặp sự cố. Bạn có thể gửi chấm lại sau ít phút.',
  INVALID_RESULT: 'Kết quả chấm điểm không hợp lệ. Bạn có thể gửi chấm lại.',
  SERVER_RESTART: 'Máy chủ khởi động lại trong lúc chấm. Bạn có thể gửi chấm lại.',
}

export function scoreBand(total) {
  if (total >= 85) return { label: 'Xuất sắc', tone: 'excellent' }
  if (total >= 70) return { label: 'Tốt', tone: 'good' }
  if (total >= 50) return { label: 'Đạt', tone: 'fair' }
  return { label: 'Cần cải thiện', tone: 'weak' }
}

export function wpmVerdict(wpm) {
  if (wpm >= WPM_IDEAL[0] && wpm <= WPM_IDEAL[1]) return { label: 'Lý tưởng', tone: 'good' }
  return wpm < WPM_IDEAL[0] ? { label: 'Hơi chậm', tone: 'warn' } : { label: 'Hơi nhanh', tone: 'warn' }
}

export function fillerVerdict(rate) {
  if (rate <= 2) return { label: 'Rất tốt', tone: 'good' }
  if (rate <= 6) return { label: 'Khá', tone: 'warn' }
  return { label: 'Nhiều từ đệm', tone: 'bad' }
}
