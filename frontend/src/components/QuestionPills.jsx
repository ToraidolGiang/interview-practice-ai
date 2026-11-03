import { levelOf, questionContext, questionTypeLabel } from '../constants/taxonomy'

// Nhãn câu hỏi: "IT · Backend Developer" | Hành vi | Khó
export default function QuestionPills({ question, className = '' }) {
  if (!question) return null
  const level = levelOf(question.level)
  return (
    <div className={className} style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
      <span className="pill pill-indigo">{questionContext(question)}</span>
      {question.questionType && <span className="pill pill-gray">{questionTypeLabel(question.questionType)}</span>}
      {level && <span className={`pill ${level.pill}`}>{level.label}</span>}
    </div>
  )
}
