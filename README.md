# Interview Practice AI

Nền tảng luyện phỏng vấn xin việc tích hợp AI (tiếng Việt là ngôn ngữ chính, mở rộng tiếng Anh ở giai đoạn sau).

## Tech Stack

| Layer | Công nghệ | Ghi chú |
|---|---|---|
| Backend | Spring Boot (Java 21) — Web MVC, Data JPA, Security | Security dùng cho JWT + RBAC |
| Frontend | React (Vite) | Ghi âm qua MediaRecorder API |
| Database | PostgreSQL | Hỗ trợ JSONB cho dữ liệu điểm STAR |
| STT + LLM | Gemini 3.7 Flash | Qua `generateContent` |
| TTS | FPT.AI Text-to-Speech | Giọng tiếng Việt bản địa |
| Object Storage | AWS S3 | Lưu file ghi âm câu trả lời |
| Auth | JWT | Token 24h, RBAC qua role claim |
| Deploy | Docker + Render | Backend (Web Service) và Frontend (Static Site) |
| Tools | Git (GitHub), Jira, Postman | |

Kiến trúc: Web API monolithic, 3-layer (Controller – Service – Repository); các dịch vụ AI (STT/LLM/TTS) tách theo Adapter Pattern trong `service/ai/`. Chi tiết đầy đủ xem `Kien_Truc_He_Thong.docx`.

## Cấu trúc repo

```
interview-practice-ai/
├── backend/    # Spring Boot API
├── frontend/   # React (Vite)
├── docs/diagrams/
└── scripts/
```

## Chạy local

### Backend

Yêu cầu **JDK 21** cài sẵn (dự án dùng Maven Wrapper nên không cần cài Maven hệ thống).

```bash
cd backend
cp ../.env.example ../.env   # điền giá trị thật, không commit file này
# export các biến trong .env vào shell, hoặc cấu hình trong IDE
./mvnw spring-boot:run
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

