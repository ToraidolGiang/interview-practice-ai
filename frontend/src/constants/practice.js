// Giới hạn ghi âm theo UC4 (openapi.yaml /practice-sessions/{id}/answer): 10 giây - 3 phút,
// cảnh báo khi còn 30 giây và tự dừng khi hết giờ.
export const MIN_RECORDING_SECONDS = 10
export const MAX_RECORDING_SECONDS = 180
export const WARNING_REMAINING_SECONDS = 30

// Khung trả lời theo loại câu hỏi, lấy từ docs/business/Rubric_Cham_Diem.md (mục 3.1, STRUCTURE).
// share = tỷ lệ thời lượng gợi ý, chỉ để người luyện tập tham khảo.
export const ANSWER_FRAMEWORKS = {
  BEHAVIORAL: {
    title: 'Khung trả lời STAR',
    steps: [
      { key: 'S', name: 'Tình huống (Situation)', share: 0.15, desc: 'Bối cảnh: ở đâu, khi nào, mức độ quan trọng.' },
      { key: 'T', name: 'Nhiệm vụ (Task)', share: 0.15, desc: 'Vai trò và trách nhiệm của chính bạn.' },
      { key: 'A', name: 'Hành động (Action)', share: 0.45, desc: 'Bạn đã làm gì, theo thứ tự nào. Đây là phần cốt lõi.', core: true },
      { key: 'R', name: 'Kết quả (Result)', share: 0.25, desc: 'Kết quả đo được và bài học rút ra.' },
    ],
    tip: 'Nêu rõ vai trò cá nhân và đưa con số cụ thể ở phần Kết quả để đạt điểm Cấu trúc cao.',
  },
  SITUATIONAL: {
    title: 'Khung trả lời tình huống',
    steps: [
      { key: '1', name: 'Phân tích', share: 0.25, desc: 'Xác định vấn đề, ràng buộc và rủi ro.' },
      { key: '2', name: 'Quyết định', share: 0.45, desc: 'Các bước xử lý theo thứ tự.', core: true },
      { key: '3', name: 'Lý do', share: 0.3, desc: 'Vì sao chọn cách này, phương án dự phòng.' },
    ],
    tip: 'Giải thích lý do cho từng bước và nhắc tới phương án khác nếu cách đầu tiên không hiệu quả.',
  },
  TECHNICAL: {
    title: 'Khung trả lời chuyên môn',
    steps: [
      { key: '1', name: 'Khái niệm', share: 0.25, desc: 'Định nghĩa ngắn gọn, chính xác.' },
      { key: '2', name: 'Giải thích', share: 0.45, desc: 'Cơ chế hoạt động, so sánh khi cần.', core: true },
      { key: '3', name: 'Ví dụ', share: 0.3, desc: 'Trường hợp áp dụng thực tế.' },
    ],
    tip: 'Tiêu chí Đúng chuyên môn chiếm trọng số cao nhất, ưu tiên chính xác hơn dài dòng.',
  },
  INTRO: {
    title: 'Khung giới thiệu bản thân',
    steps: [
      { key: '1', name: 'Hiện tại', share: 0.3, desc: 'Bạn đang làm gì, thế mạnh chính.' },
      { key: '2', name: 'Quá khứ', share: 0.4, desc: 'Kinh nghiệm nổi bật liên quan vị trí.', core: true },
      { key: '3', name: 'Định hướng', share: 0.3, desc: 'Vì sao phù hợp với vị trí ứng tuyển.' },
    ],
    tip: 'Nối kinh nghiệm của bạn với vị trí đang ứng tuyển thay vì liệt kê rời rạc.',
  },
}

export function formatClock(totalSeconds) {
  const s = Math.max(0, Math.floor(totalSeconds))
  return `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`
}
