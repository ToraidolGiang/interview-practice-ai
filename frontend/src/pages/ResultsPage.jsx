import { useParams } from 'react-router'
import Placeholder from './Placeholder'

export default function ResultsPage() {
  const { sessionId } = useParams()
  return <Placeholder title="Kết quả chấm điểm" note={`Đang phát triển (#122) - phiên ${sessionId}`} />
}
