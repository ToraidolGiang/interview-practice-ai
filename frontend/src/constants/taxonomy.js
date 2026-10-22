// Danh mục ngành/vị trí theo docs/business/Danh_Muc_Nganh_Vi_Tri.md (taxonomy-v1.0).
// Giá trị gửi lên API phải đúng nguyên văn.
export const TAXONOMY_VERSION = 'taxonomy-v1.0'

export const INDUSTRIES = [
  {
    value: 'IT',
    label: 'Công nghệ thông tin (IT)',
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
    label: 'Marketing',
    positions: ['Chung', 'Digital Marketing', 'Content Marketing', 'Chuyên viên SEO'],
  },
  {
    value: 'Kinh doanh / Bán hàng',
    label: 'Kinh doanh / Bán hàng',
    positions: ['Chung', 'Nhân viên kinh doanh', 'Nhân viên bán hàng'],
  },
  {
    value: 'Kế toán / Tài chính',
    label: 'Kế toán / Tài chính',
    positions: ['Chung', 'Kế toán viên', 'Chuyên viên phân tích tài chính'],
  },
  {
    value: 'Nhân sự',
    label: 'Nhân sự (HR)',
    positions: ['Chung', 'Chuyên viên tuyển dụng', 'Chuyên viên C&B'],
  },
  {
    value: 'Chăm sóc khách hàng',
    label: 'Chăm sóc khách hàng',
    positions: ['Chung', 'Nhân viên CSKH'],
  },
]

export const LEVELS = [
  { value: 'EASY', label: 'Dễ', badge: 'DỄ' },
  { value: 'MEDIUM', label: 'TB', badge: 'TRUNG BÌNH' },
  { value: 'HARD', label: 'Khó', badge: 'KHÓ' },
]

export const QUESTION_TYPES = [
  { value: 'BEHAVIORAL', label: 'Hành vi STAR (Behavioral)' },
  { value: 'SITUATIONAL', label: 'Tình huống (Situational)' },
  { value: 'TECHNICAL', label: 'Chuyên môn (Technical)' },
  { value: 'INTRO', label: 'Giới thiệu bản thân (Intro)' },
]

export function industryLabel(value) {
  return INDUSTRIES.find((i) => i.value === value)?.label ?? value
}

export function levelOf(value) {
  return LEVELS.find((l) => l.value === value)
}

export function questionTypeLabel(value) {
  return QUESTION_TYPES.find((t) => t.value === value)?.label ?? value
}
