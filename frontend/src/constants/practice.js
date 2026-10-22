// Giới hạn ghi âm theo UC4 (openapi.yaml /practice-sessions/{id}/answer): 10 giây - 3 phút,
// cảnh báo khi còn 30 giây và tự dừng khi hết giờ.
export const MIN_RECORDING_SECONDS = 10
export const MAX_RECORDING_SECONDS = 180
export const WARNING_REMAINING_SECONDS = 30

// Mẹo theo loại câu hỏi, dựa trên tiêu chí có trọng số lớn nhất trong docs/business/Rubric_Cham_Diem.md (mục 4)
export const RUBRIC_TIPS = {
  BEHAVIORAL: 'Chiều sâu chiếm 40%: nêu rõ vai trò của chính bạn và đưa số liệu, kết quả đo được.',
  SITUATIONAL: 'Chiều sâu chiếm 40%: giải thích lý do cho từng bước và nhắc tới rủi ro hoặc phương án dự phòng.',
  TECHNICAL: 'Đúng chuyên môn chiếm 35%: ưu tiên chính xác các ý chính hơn là nói dài.',
  INTRO: 'Chiều sâu chiếm 35%: nối kinh nghiệm cụ thể của bạn với vị trí đang ứng tuyển.',
}

export function formatClock(totalSeconds) {
  const s = Math.max(0, Math.floor(totalSeconds))
  return `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`
}
