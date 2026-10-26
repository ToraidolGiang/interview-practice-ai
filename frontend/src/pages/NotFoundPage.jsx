import { Link } from 'react-router'
import Placeholder from './Placeholder'

export default function NotFoundPage() {
  return (
    <div>
      <Placeholder title="Không tìm thấy trang" note="Đường dẫn không tồn tại hoặc chức năng chưa sẵn sàng." />
      <p style={{ textAlign: 'center' }}>
        <Link to="/">Về trang chủ</Link>
      </p>
    </div>
  )
}
