// Giới hạn ghi âm theo UC4 (openapi.yaml /practice-sessions/{id}/answer): 10 giây - 3 phút,
// cảnh báo khi còn 30 giây và tự dừng khi hết giờ.
export const MIN_RECORDING_SECONDS = 10
export const MAX_RECORDING_SECONDS = 180
export const WARNING_REMAINING_SECONDS = 30

// Khung cấu trúc gợi ý theo loại câu hỏi (rubric mục 3.1), hiển thị ở thẻ "Gợi ý trả lời"
export const STRUCTURE_STEPS = {
  BEHAVIORAL: {
    title: 'Khung cấu trúc – câu hỏi hành vi',
    steps: [
      { key: 'S', name: 'Tình huống', desc: 'Sự cố gì, quy mô ảnh hưởng ra sao' },
      { key: 'T', name: 'Nhiệm vụ', desc: 'Vai trò và trách nhiệm của bạn' },
      { key: 'A', name: 'Hành động', desc: 'Những bước chính bạn đã làm' },
      { key: 'R', name: 'Kết quả', desc: 'Con số đo được và bài học rút ra' },
    ],
  },
  SITUATIONAL: {
    title: 'Khung cấu trúc – câu hỏi tình huống',
    steps: [
      { key: '1', name: 'Phân tích', desc: 'Vấn đề cốt lõi và các bên liên quan' },
      { key: '2', name: 'Quyết định', desc: 'Cách bạn xử lý, theo thứ tự ưu tiên' },
      { key: '3', name: 'Lý do', desc: 'Vì sao chọn cách đó, rủi ro và phương án khác' },
    ],
  },
  TECHNICAL: {
    title: 'Khung cấu trúc – câu hỏi kỹ thuật',
    steps: [
      { key: '1', name: 'Khái niệm', desc: 'Định nghĩa ngắn gọn, chính xác' },
      { key: '2', name: 'Cơ chế', desc: 'Cách hoạt động, ưu nhược điểm' },
      { key: '3', name: 'Ví dụ', desc: 'Trường hợp áp dụng thực tế' },
    ],
  },
  INTRO: {
    title: 'Khung cấu trúc – giới thiệu bản thân',
    steps: [
      { key: '1', name: 'Hiện tại', desc: 'Bạn đang làm gì, thế mạnh chính' },
      { key: '2', name: 'Kinh nghiệm', desc: 'Dự án, thành tựu liên quan vị trí' },
      { key: '3', name: 'Định hướng', desc: 'Vì sao phù hợp với vị trí này' },
    ],
  },
}

// Mẹo theo loại câu hỏi, dựa trên tiêu chí có trọng số lớn nhất (rubric mục 4)
export const RUBRIC_TIPS = {
  BEHAVIORAL:
    'Mẹo: đưa số liệu cụ thể (thời gian khôi phục, % người dùng bị ảnh hưởng) vào câu trả lời để tăng điểm Độ cụ thể – tiêu chí nặng nhất.',
  SITUATIONAL:
    'Mẹo: giải thích lý do cho từng bước và nhắc tới rủi ro hoặc phương án dự phòng để tăng điểm Độ cụ thể – tiêu chí nặng nhất.',
  TECHNICAL: 'Mẹo: ưu tiên nói đúng và đủ các ý chính hơn là nói dài – Đúng chuyên môn là tiêu chí nặng nhất.',
  INTRO: 'Mẹo: nối kinh nghiệm cụ thể của bạn với vị trí đang ứng tuyển để tăng điểm Độ cụ thể – tiêu chí nặng nhất.',
}

export function formatClock(totalSeconds) {
  const s = Math.max(0, Math.floor(totalSeconds))
  return `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`
}
