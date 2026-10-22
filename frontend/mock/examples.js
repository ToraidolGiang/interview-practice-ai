// Dữ liệu mẫu cho mock Prism. Contract gốc (docs/api/openapi.yaml, Giang quản lý) không có `example`
// cho các schema này nên Prism tự sinh "string" và số âm. build-mock-spec.mjs chèn các ví dụ dưới đây
// vào một bản sao của contract; contract gốc không bị sửa.
const questions = [
  {
    industry: 'IT',
    position: 'Backend Developer',
    level: 'HARD',
    questionType: 'BEHAVIORAL',
    content:
      'Hãy kể lại một sự cố sập hệ thống (Production Outage) nghiêm trọng mà bạn từng giải quyết. Bạn đã phối hợp xử lý và rút ra bài học gì?',
    answerHint: 'Phân tích Root Cause Analysis, khoanh vùng sự cố và phối hợp xử lý khẩn cấp.',
  },
  {
    industry: 'Marketing',
    position: 'Digital Marketing',
    level: 'MEDIUM',
    questionType: 'BEHAVIORAL',
    content:
      'Mô tả một chiến dịch ra mắt sản phẩm mà bạn đã dẫn dắt với ngân sách hạn hẹp nhưng vẫn vượt chỉ tiêu KPI ban đầu đặt ra.',
    answerHint: 'Tăng trưởng chỉ số CAC, ROAS và dữ liệu chuyển đổi thực tế đo lường qua Google Analytics & CRM.',
  },
  {
    industry: 'Kế toán / Tài chính',
    position: 'Kế toán viên',
    level: 'HARD',
    questionType: 'BEHAVIORAL',
    content:
      'Chia sẻ trường hợp bạn phát hiện sai lệch số liệu trọng yếu trong báo cáo tài chính và cách bạn thuyết phục ban điều hành điều chỉnh.',
    answerHint: 'Giữ vững tính tuân thủ chuẩn mực kế toán, giao tiếp với các bên liên quan dưới áp lực cao.',
  },
  {
    industry: 'Nhân sự',
    position: 'Chuyên viên tuyển dụng',
    level: 'EASY',
    questionType: 'SITUATIONAL',
    content:
      'Bạn xử lý thế nào khi một ứng viên tiềm năng từ chối offer vào phút chót ngay trước ngày Onboarding dự kiến?',
    answerHint: 'Phân tích lý do (counter-offer, địa điểm, văn hóa) và giải pháp dự phòng nguồn ứng viên.',
  },
  {
    industry: 'Chăm sóc khách hàng',
    position: 'Nhân viên CSKH',
    level: 'MEDIUM',
    questionType: 'BEHAVIORAL',
    content:
      'Hãy chia sẻ một tình huống khách hàng VIP giận dữ vì lỗi dịch vụ và cách bạn đã xoay chuyển họ thành người ủng hộ thương hiệu.',
    answerHint: 'Thấu cảm cảm xúc, bồi thường vượt kỳ vọng và xây dựng lòng tin dài hạn.',
  },
  {
    industry: 'IT',
    position: 'Chung',
    level: 'EASY',
    questionType: 'INTRO',
    content: 'Hãy giới thiệu ngắn gọn về bản thân và lý do bạn ứng tuyển vị trí này.',
    answerHint: 'Hiện tại bạn làm gì, kinh nghiệm nổi bật liên quan, vì sao phù hợp với vị trí.',
  },
].map((q, i) => ({
  id: `3f6c1f0e-2a54-4a54-9b1e-0d5e2f7a9c${String(i).padStart(2, '0')}`,
  ...q,
  status: 'ACTIVE',
  createdAt: '2026-10-01T08:00:00Z',
}))

function scoreResult(i) {
  return {
    id: `9a1b2c3d-0000-4000-8000-00000000000${i}`,
    sessionId: '7e0f1a30-4a4e-4c0b-b6d2-1a2b3c4d5e00',
    transcript:
      'Ừm, trong đợt Black Friday năm ngoái, hệ thống thanh toán bị sập vào giờ cao điểm. Tôi tôi là Tech Lead trực on-call nên đã khoanh vùng lỗi ở connection pool, rollback bản cập nhật và phối hợp với nhóm vận hành. Kiểu như sau 20 phút hệ thống hoạt động lại và chúng tôi bổ sung cảnh báo.',
    questionType: 'BEHAVIORAL',
    totalScore: 78.5,
    contentScore: 76.4,
    criteria: [
      { code: 'RELEVANCE', score: 5, weight: 20, reasoning: 'Trả lời đúng câu hỏi về sự cố và cách xử lý.', quote: 'hệ thống thanh toán bị sập vào giờ cao điểm', quoteInvalid: false },
      { code: 'STRUCTURE', score: 4, weight: 30, reasoning: 'Có tình huống, vai trò, hành động; kết quả còn ngắn.', quote: 'Tech Lead trực on-call', quoteInvalid: false },
      { code: 'DEPTH', score: 3, weight: 40, reasoning: 'Thiếu nguyên nhân gốc và số liệu sau khắc phục.', quote: 'khoanh vùng lỗi ở connection pool', quoteInvalid: false },
    ],
    delivery: { wpm: 138, fillerCount: 3, fillerRate: 5.36, deliveryScore: 4, fillerListVersion: 'filler-vi-v1' },
    offTopic: false,
    injectionSuspected: false,
    rubricVersion: 'rubric-v1.0',
    promptVersion: 'prompt-v1',
    modelVersion: 'mock',
    feedbackText: 'Bạn mô tả sự cố rõ ràng và nêu được vai trò của mình. Hãy bổ sung nguyên nhân gốc và số liệu sau khắc phục.',
    sampleAnswer: null,
    ttsAudioUrl: null,
  }
}

export const SCHEMA_EXAMPLES = {
  Question: questions[0],
  QuestionPage: { content: questions, page: 0, size: 6, totalElements: 128, totalPages: 22 },
  RegisterResponse: { id: '3f6c1f0e-2a54-4a54-9b1e-0d5e2f7a9c11', email: 'cand@example.com' },
  PracticeSession: {
    id: '7e0f1a30-4a4e-4c0b-b6d2-1a2b3c4d5e6f',
    userId: '3f6c1f0e-2a54-4a54-9b1e-0d5e2f7a9c11',
    questionId: questions[0].id,
    status: 'CREATED',
    audioUrl: null,
    duration: 0,
    totalScore: null,
    feedback: null,
    startedAt: '2026-10-22T08:00:00Z',
    submittedAt: null,
    completedAt: null,
    errorCode: null,
  },
  ScoreResult: scoreResult(0),
  HistoryDetail: {
    id: '7e0f1a30-4a4e-4c0b-b6d2-1a2b3c4d5e00',
    userId: '3f6c1f0e-2a54-4a54-9b1e-0d5e2f7a9c11',
    questionId: questions[0].id,
    status: 'SCORED',
    audioUrl: null,
    duration: 95,
    totalScore: 78.5,
    feedback: null,
    startedAt: '2026-10-21T14:30:00Z',
    submittedAt: '2026-10-21T14:32:00Z',
    completedAt: '2026-10-21T14:32:00Z',
    errorCode: null,
    scoreResult: scoreResult(0),
  },
  HistoryPage: {
    content: [
      { score: 78.5, q: 0, at: '2026-10-21T14:32:00Z' },
      { score: 64, q: 3, at: '2026-10-20T09:10:00Z' },
      { score: 88, q: 5, at: '2026-10-18T19:45:00Z' },
    ].map(({ score, q, at }, i) => ({
      id: `7e0f1a30-4a4e-4c0b-b6d2-1a2b3c4d5e${String(i).padStart(2, '0')}`,
      userId: '3f6c1f0e-2a54-4a54-9b1e-0d5e2f7a9c11',
      questionId: questions[q].id,
      status: 'SCORED',
      audioUrl: null,
      duration: 95,
      totalScore: score,
      feedback: null,
      startedAt: at,
      submittedAt: at,
      completedAt: at,
      errorCode: null,
    })),
    page: 0,
    size: 20,
    totalElements: 3,
    totalPages: 1,
  },
}
