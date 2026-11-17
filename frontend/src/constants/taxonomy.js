// Danh mục ngành/vị trí theo docs/business/Danh_Muc_Nganh_Vi_Tri.md (taxonomy-v1.0).
// Giá trị gửi lên API phải đúng nguyên văn và cũng là nhãn hiển thị trên chip/thẻ câu hỏi (Figma).
export const TAXONOMY_VERSION = 'taxonomy-v1.0'

export const INDUSTRIES = [
  {
    value: 'IT',
    positions: [
      'Chung',
      'Backend Developer',
      'Frontend Developer',
      'Fullstack Developer',
      'Mobile Developer',
      'Tester / QA',
      'DevOps / Quản trị hệ thống',
      'Data Analyst',
      'Data Scientist / AI',
      'Business Analyst',
    ],
  },
  {
    value: 'Marketing',
    positions: ['Chung', 'Digital Marketing', 'Content Marketing', 'Chuyên viên SEO'],
  },
  {
    value: 'Kinh doanh / Bán hàng',
    positions: ['Chung', 'Nhân viên kinh doanh', 'Nhân viên bán hàng'],
  },
  {
    value: 'Kế toán / Tài chính',
    positions: ['Chung', 'Kế toán viên', 'Chuyên viên phân tích tài chính'],
  },
  {
    value: 'Nhân sự',
    positions: ['Chung', 'Chuyên viên tuyển dụng', 'Chuyên viên C&B'],
  },
  {
    value: 'Chăm sóc khách hàng',
    positions: ['Chung', 'Nhân viên CSKH'],
  },
]

export const LEVELS = [
  { value: 'EASY', label: 'Dễ', pill: 'pill-green' },
  { value: 'MEDIUM', label: 'Trung bình', pill: 'pill-indigo' },
  { value: 'HARD', label: 'Khó', pill: 'pill-red' },
]

// label: nhãn ngắn trên thẻ/bộ lọc (Figma); full: tên đầy đủ kèm tiếng Anh
export const QUESTION_TYPES = [
  { value: 'BEHAVIORAL', label: 'Hành vi', full: 'Hành vi (Behavioral)' },
  { value: 'SITUATIONAL', label: 'Tình huống', full: 'Tình huống (Situational)' },
  { value: 'TECHNICAL', label: 'Kỹ thuật', full: 'Kỹ thuật (Technical)' },
  { value: 'INTRO', label: 'Giới thiệu', full: 'Giới thiệu bản thân (Intro)' },
]

export function levelOf(value) {
  return LEVELS.find((l) => l.value === value)
}

export function questionTypeLabel(value) {
  return QUESTION_TYPES.find((t) => t.value === value)?.label ?? value
}

// "IT · Backend Developer": ngành giữ nguyên giá trị taxonomy như trong Figma
export function questionContext(question) {
  return [question?.industry, question?.position].filter(Boolean).join(' · ')
}
