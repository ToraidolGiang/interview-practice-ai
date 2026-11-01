import { Link } from 'react-router'
import Logo from '../components/Logo'

export default function NotFoundPage() {
  return (
    <main style={{ minHeight: '100vh', display: 'grid', placeItems: 'center', padding: 24, textAlign: 'center' }}>
      <div>
        <Logo />
        <h1 className="page-title" style={{ marginTop: 32 }}>
          Không tìm thấy trang
        </h1>
        <p className="page-sub">Đường dẫn không tồn tại hoặc chức năng chưa sẵn sàng.</p>
        <Link to="/" className="btn btn-primary" style={{ marginTop: 20 }}>
          Về trang chủ
        </Link>
      </div>
    </main>
  )
}
