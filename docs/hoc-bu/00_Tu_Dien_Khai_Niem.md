# Từ điển khái niệm (tra nhanh)

Mỗi dòng: khái niệm, nghĩa bằng lời thường, nơi nó xuất hiện trong dự án. Cột "GĐ" là giai đoạn của bộ tài liệu học bù (A thiết kế, B dữ liệu, C xác thực/API, D pipeline AI, E frontend, F đo/đối chiếu/RAG).

## Kiến trúc và dữ liệu
| Khái niệm | Nghĩa | Ở đâu | GĐ |
|---|---|---|---|
| Monolith | Một chương trình backend duy nhất | `backend/`, ADR-001 | A |
| 3 tầng | Controller → Service → Repository | `controller/`, `service/`, `repository/` | A |
| Port / Adapter | Interface mô tả việc + lớp cụ thể gọi dịch vụ ngoài | `SttClient`/`GeminiSttClient`, `LlmClient`, `AudioStorage`, `KnowledgeErrorDetector` | A, D, F |
| Flyway migration | File SQL đánh số chạy đúng một lần theo thứ tự; không sửa file đã chạy | `db/migration/V1..V5` | A |
| `ddl-auto: validate` | Hibernate chỉ kiểm lệch schema, không tự sửa | `application.yml` | A |
| FK, CASCADE, RESTRICT | Khóa ngoại; xóa lan theo hoặc cấm xóa | `V1__init.sql` | A |
| UNIQUE index | Cấm trùng ở mức DB; chốt cuối cùng cho lỗi đồng thời | `uq_users_email`, `uq_score_results_session` | A, C |
| OpenAPI, contract-first | Hợp đồng API viết trước; FE và BE cùng theo | `docs/api/openapi.yaml` | A, E |
| ADR | Bản ghi quyết định kiến trúc | `docs/knowledge/decisions/` | A |
| CI | Tự build/test mỗi lần đẩy code | `.github/workflows/ci.yml` | A |
| Taxonomy | Danh mục ngành/vị trí chuẩn | `Danh_Muc_Nganh_Vi_Tri.md` | B |
| JSONL | Mỗi dòng một JSON, ghi nối tiếp | `data/interim/*.jsonl` | B |
| Seed | Dữ liệu khởi tạo nạp bằng migration | `V2__seed_questions.sql` | B |

## Xác thực và API
| Khái niệm | Nghĩa | Ở đâu | GĐ |
|---|---|---|---|
| JWT (HS256) | Thẻ chữ ký số mang id, email, role, hạn 24h | `JwtService` | C |
| BCrypt | Băm mật khẩu chậm, có muối, chỉ 72 byte đầu | `AuthService`, `@MaxUtf8Bytes` | C |
| Khóa tài khoản | 5 lần sai khóa 15 phút (429) | `AuthService.LOCK_DURATION` | C |
| Pessimistic lock | Khóa dòng DB để request song song xếp hàng | `findByEmailForUpdate` | C |
| Chống dò email | Hash giả cùng cost; phản hồi giống nhau | `AuthService.dummyHash`, `PasswordResetService` | C |
| Stateless / RBAC | Không giữ phiên; phân quyền theo vai trò | `SecurityConfig` | C |
| Nạp lại user mỗi request | Đổi quyền/khóa tài khoản có hiệu lực ngay | `JwtAuthenticationFilter` | C |
| `ErrorResponse` | Dạng lỗi thống nhất `{code,message,timestamp,fieldErrors}` | `GlobalExceptionHandler` | C |
| Soft delete | Xóa mềm bằng `HIDDEN` | `AdminQuestionService` | C |
| Audit log | Nhật ký thao tác quản trị, ghi cùng transaction | `audit_logs` | C |
| Token đặt lại mật khẩu | 256 bit ngẫu nhiên; DB chỉ lưu SHA-256 | `PasswordResetService` | C |
| Phân trang an toàn | Giới hạn `page` để offset không tràn | `QuestionSpecifications.MAX_PAGE` | C |

## Pipeline AI
| Khái niệm | Nghĩa | Ở đâu | GĐ |
|---|---|---|---|
| Phiên (session) | Một lượt trả lời một câu hỏi | `PracticeSession` | D |
| Trạng thái | CREATED, UPLOADED, PROCESSING, SCORED, FAILED | `practice_sessions.status` | D |
| UPDATE có điều kiện | `UPDATE ... WHERE status IN (...)`, 0 dòng là thua cuộc đua (409) | `PracticeSessionRepository` | D |
| 202 + polling | Nhận việc trả ngay; hỏi lại định kỳ | `EvaluationService`, `useSessionResult` | A, D, E |
| Executor có queue giới hạn | Nhóm luồng nền; đầy thì từ chối (503) | `AsyncConfig.scoringExecutor` | D |
| S3 key do server sinh | Không dùng tên file client | `audio/{userId}/{sessionId}/{uuid}.{ext}` | D |
| STT, VERBATIM | Giọng nói thành chữ, giữ từ đệm | `GeminiSttClient` | D |
| `responseSchema` | Lược đồ ép LLM trả đúng JSON | `GeminiLlmClient.responseSchema` | D |
| Rubric, trọng số | Tiêu chí 1-5 theo loại câu hỏi | `RubricConfig` (`rubric-v1.0`) | D |
| Server tính điểm | LLM không trả tổng điểm | `ScoreCalculator` | D |
| Delivery | WPM + từ đệm, trọng số 10, tính bằng code | `DeliveryCalculator` | D |
| Quote hợp lệ | Trích dẫn phải nằm trong transcript, không thì hạ về 2 | `QuoteValidator` | D, F |
| offTopic | Lạc đề, tổng tối đa 30 | `ScoreCalculator.OFF_TOPIC_CAP` | D |
| Prompt injection | Thí sinh chèn chỉ thị vào lời nói | `PromptBuilder`, `injectionSuspected` | D |
| Retry đúng 1 lần | STT/LLM gọi lại một lần khi lỗi/sai schema | `OneRetry`, `LlmScorer` | D |
| `ANSWER_TOO_SHORT` | Transcript dưới 15 từ | `ScoringPipeline.MIN_WORDS` | D |
| `SERVER_RESTART`, `PROCESSING_TIMEOUT` | Mã lỗi khi mất job lúc khởi động / phiên kẹt quá 300s | `SessionRecoveryRunner` | D |
| Giới hạn theo user | 3 phiên đang chấm; 20 lượt/ngày | `evaluation_attempts` (V3) | D |
| Rescore | Chấm lại với transcript đã sửa, không gọi lại STT | `POST /{id}/rescore` | D |
| `api_usages` | Nhật ký độ trễ/token mỗi lần gọi AI | `ApiUsageRecorder` | D |
| Orphan file | File S3 còn sót không có DB trỏ tới | `AudioStorage.delete` (F5) | D |

## Đo, giải thích và mở rộng
| Khái niệm | Nghĩa | Ở đâu | GĐ |
|---|---|---|---|
| Gold set | Bộ câu trả lời có điểm người chấm để đo AI | `data/gold/` | F |
| QWK, Spearman, MAE | Thước đo đồng thuận có thứ bậc, tương quan thứ hạng, sai số trung bình | `scripts/gold/metrics.py` | F |
| Calibration / Holdout | Tập chỉnh / tập giữ lại đo một lần | `data/gold/README.md` | F |
| Mốc độ dài | Bộ chấm giả chỉ dựa vào độ dài; AI phải vượt | `metrics.py` | F |
| Trần đồng thuận | Mức đồng thuận người-người là giới hạn thực tế của AI | `data/gold/README.md` | F |
| Đối chiếu theo ý | Mỗi ý của đáp án có verdict + trích dẫn | `score_points`, `ReferencePoints` | F |
| Verdict | COVERED, PARTIAL, MISSING, INCORRECT | `ScorePoint.Verdict` | F |
| Coverage | `(COVERED + 0,5·PARTIAL − 0,5·INCORRECT − 0,5·lỗi)/số ý`, chặn dưới 0 | `CorrectnessCalculator` | F |
| Kiểm lỗi kiến thức | Lượt riêng tìm phát biểu sai, chạy song song | `GeminiKnowledgeErrorDetector` | F |
| Thinking level | Mức "suy nghĩ" của model; `minimal` để nhanh | `ai.check.thinking-level` | F |
| Luồng ảo | Luồng nhẹ của Java 21, hợp việc chờ HTTP | `AsyncConfig.knowledgeCheckExecutor` | F |
| RAG | Truy xuất tài liệu rồi buộc LLM kết luận dựa trên đó | `docs/Huong_Mo_Rong.md` | F |
| Grounding | Kết luận phải có bằng chứng | `quote`, `UNVERIFIED` (đề xuất) | F |

## Frontend
| Khái niệm | Nghĩa | Ở đâu | GĐ |
|---|---|---|---|
| SPA, router | Một trang, đổi màn bằng định tuyến | `App.jsx` | E |
| Prism mock | Server giả sinh từ OpenAPI | `npm run dev:mock` | E |
| Proxy `/api` | Dev server chuyển yêu cầu sang backend | `vite.config.js` | E |
| `MediaRecorder` | Ghi âm trong trình duyệt | `useAudioRecorder` | E |
| 401 và 403 | Chưa đăng nhập (đăng xuất) và thiếu quyền (không đăng xuất) | `api/client.js` | C, E |
| Chống race khi polling/lọc | Cờ hủy và `runRef` để phản hồi cũ bị bỏ | `useSessionResult`, trang admin | E |
| Thông báo lỗi tập trung | Mã lỗi → câu tiếng Việt ở một chỗ | `constants/scoring.js` | E |
