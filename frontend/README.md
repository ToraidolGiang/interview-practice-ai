# Frontend - TalentSTAR AI

React 19 + Vite, router `react-router` v7, CSS Modules. Giao diện theo Figma "AI-Interview".

## Chạy

```bash
npm install
npm run dev        # proxy /api -> backend Spring (mặc định http://localhost:8080)
```

Chưa có backend thì chạy với mock sinh từ contract `docs/api/openapi.yaml`:

```bash
npm run mock       # Prism mock ở cổng 4010 (terminal 1)
npm run dev:mock   # Vite proxy /api -> mock (terminal 2), cấu hình trong .env.mock
```

Mock trả dữ liệu `example` trong contract; muốn thử nhánh lỗi thì thêm header `Prefer: code=401` (Prism).
Đổi địa chỉ backend bằng biến `API_PROXY_TARGET` trong `.env.local`.

## Cấu trúc

- `src/api/` - `client.js` (fetch + gắn JWT, chuẩn hoá `ErrorResponse`), mỗi nhóm API một file
- `src/auth/` - phiên đăng nhập (JWT 24h, "Ghi nhớ đăng nhập" lưu localStorage), route guard, validate form
- `src/layouts/` - `AuthLayout` (màn chia đôi đăng nhập/đăng ký), `AppLayout` (header + footer sau đăng nhập)
- `src/components/` - component dùng chung
- `src/pages/` - mỗi màn hình một file
- `src/assets/figma/` - icon, logo tải từ Figma
