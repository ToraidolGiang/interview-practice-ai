# Đối chiếu thiết kế: Class ↔ CSDL ↔ API

Sinh tự động bằng script đối chiếu (Class Diagram, schema CSDL, OpenAPI); script báo lỗi nếu có chỗ lệch, nên các bảng dưới đây khớp nhau tại thời điểm sinh.

## 1. Controller ↔ Endpoint ↔ Use case

| Controller | Phương thức | Endpoint | UC |
|---|---|---|---|
| AuthController | `register` | `POST /auth/register` | UC1 |
| AuthController | `login` | `POST /auth/login` | UC2 |
| AuthController | `requestPasswordReset` | `POST /auth/forgot-password` | UC2 |
| AuthController | `resetPassword` | `POST /auth/reset-password` | UC2 |
| QuestionController | `getQuestions` | `GET /questions` | UC3 |
| QuestionController | `getRandomQuestion` | `GET /questions/random` | UC3 |
| QuestionController | `openQuestion` | `GET /questions/{id}` | UC3 |
| QuestionController | `createPracticeSession` | `POST /practice-sessions` | UC3, UC4 |
| PracticeController | `getSession` | `GET /practice-sessions/{id}` | UC4, UC5 |
| PracticeController | `uploadAnswer` | `POST /practice-sessions/{id}/answer` | UC4 |
| PracticeController | `evaluate` | `POST /practice-sessions/{id}/evaluate` | UC5 |
| PracticeController | `getResult` | `GET /practice-sessions/{id}/result` | UC5 |
| PracticeController | `rescore` | `POST /practice-sessions/{id}/rescore` | UC5 |
| FeedbackController | `getSpokenFeedback` | `GET /practice-sessions/{id}/feedback/audio` | UC6 |
| HistoryController | `getHistory` | `GET /history` | UC7 |
| HistoryController | `getSessionDetail` | `GET /history/{id}` | UC7 |
| AdminQuestionController | `getQuestions` | `GET /admin/questions` | UC8 |
| AdminQuestionController | `create` | `POST /admin/questions` | UC8 |
| AdminQuestionController | `update` | `PUT /admin/questions/{id}` | UC8 |
| AdminQuestionController | `delete` | `DELETE /admin/questions/{id}` | UC8 |
| AnalyticsController | `buildOverview` | `GET /admin/analytics/overview` | UC9 |
| AnalyticsController | `getUserActivity` | `GET /admin/analytics/users/{userId}` | UC9 |
| AnalyticsController | `exportReport` | `GET /admin/analytics/export` | UC9 |

23 phương thức controller ứng với 23 endpoint trong OpenAPI (1-1).

## 2. Lớp miền ↔ Bảng CSDL

| Lớp | Bảng | Số thuộc tính | Số cột | Ghi chú |
|---|---|---|---|---|
| User | `users` | 9 | 9 |  |
| Question | `questions` | 11 | 11 |  |
| PracticeSession | `practice_sessions` | 13 | 13 |  |
| ScoreResult | `score_results` | 20 | 20 | gồm cả thuộc tính của DeliveryMetrics (nhúng vào cùng bảng) |
| CriterionScore | `score_criteria` | 8 | 8 |  |
| ApiUsage | `api_usages` | 7 | 7 |  |
| AuditLog | `audit_logs` | 6 | 6 |  |
| PasswordResetToken | `password_reset_tokens` | 6 | 6 |  |

Quy ước tên: thuộc tính `camelCase` ↔ cột `snake_case`; tập tên thuộc tính trùng khớp từng bảng.

## 3. Giá trị liệt kê (enum)

| Enum | Giá trị | Ràng buộc CHECK trong CSDL | Có trong OpenAPI |
|---|---|---|---|
| Role | ADMIN, CANDIDATE | users.role | có |
| UserStatus | ACTIVE, LOCKED | users.status | có |
| QuestionLevel | EASY, HARD, MEDIUM | questions.level | có |
| QuestionStatus | ACTIVE, HIDDEN | questions.status | có |
| PracticeSessionStatus | CREATED, FAILED, PROCESSING, SCORED, UPLOADED | practice_sessions.status | có |
| ApiProvider | LLM, STT, TTS | api_usages.provider | không dùng trong API |
| QuestionType | BEHAVIORAL, INTRO, SITUATIONAL, TECHNICAL | questions.question_type, score_results.question_type | có |
| CriterionCode | CORRECTNESS, DEPTH, RELEVANCE, STRUCTURE | score_criteria.code | có |

## 4. Phụ thuộc giữa các lớp thiết kế

| Lớp | Tầng | Phụ thuộc vào | Được dùng bởi |
|---|---|---|---|
| AuthController | Controller | UserService, AuthService, PasswordResetService | — |
| QuestionController | Controller | QuestionService, PracticeService | — |
| PracticeController | Controller | PracticeService, AudioUploadService, ScoringService | — |
| FeedbackController | Controller | FeedbackService | — |
| HistoryController | Controller | PracticeHistoryService | — |
| AdminQuestionController | Controller | QuestionManagementService | — |
| AnalyticsController | Controller | AnalyticsService, ReportExportService | — |
| UserService | Service (nghiệp vụ) | UserRepository, PasswordEncoder | AuthController |
| AuthService | Service (nghiệp vụ) | UserRepository, PasswordEncoder, JwtTokenProvider, LoginAttemptService | AuthController |
| PasswordResetService | Service (nghiệp vụ) | UserRepository, PasswordResetTokenRepository, PasswordEncoder, MailService | AuthController |
| LoginAttemptService | Service (nghiệp vụ) | UserRepository | AuthService |
| QuestionService | Service (nghiệp vụ) | QuestionRepository | QuestionController |
| PracticeService | Service (nghiệp vụ) | PracticeRepository, QuestionRepository | PracticeController, QuestionController |
| AudioUploadService | Service (nghiệp vụ) | PracticeRepository, FileStorageService | PracticeController |
| FeedbackService | Service (nghiệp vụ) | ScoreResultRepository, TtsService, FileStorageService | FeedbackController |
| PracticeHistoryService | Service (nghiệp vụ) | PracticeRepository, ScoreResultRepository, FileStorageService | HistoryController |
| QuestionManagementService | Service (nghiệp vụ) | QuestionRepository, PracticeRepository, AuditLogService | AdminQuestionController |
| AuditLogService | Service (nghiệp vụ) | AuditLogRepository | QuestionManagementService |
| AnalyticsService | Service (nghiệp vụ) | UserRepository, PracticeRepository, ApiUsageRepository | AnalyticsController |
| ReportExportService | Service (nghiệp vụ) | — | AnalyticsController |
| ScoringService | Service — chấm điểm AI | EvaluationExecutor, DeliveryAnalyzer, RubricProvider, PromptBuilder, QuoteValidator, ScoreCalculator, SttService, LlmService, PracticeRepository, ScoreResultRepository, CriterionScoreRepository, ApiUsageRepository | EvaluationExecutor, PracticeController |
| EvaluationExecutor | Service — chấm điểm AI | ScoringService, PracticeRepository | ScoringService |
| RubricProvider | Service — chấm điểm AI | — | PromptBuilder, ScoreCalculator, ScoringService |
| PromptBuilder | Service — chấm điểm AI | RubricProvider | ScoringService |
| DeliveryAnalyzer | Service — chấm điểm AI | — | ScoringService |
| QuoteValidator | Service — chấm điểm AI | — | ScoringService |
| ScoreCalculator | Service — chấm điểm AI | RubricProvider | ScoringService |
| SttService | Adapter (Adapter Pattern) | ISttProvider | ScoringService |
| LlmService | Adapter (Adapter Pattern) | ILlmProvider | ScoringService |
| TtsService | Adapter (Adapter Pattern) | ITtsProvider | FeedbackService |
| MailService | Adapter (Adapter Pattern) | IMailProvider | PasswordResetService |
| FileStorageService | Adapter (Adapter Pattern) | IObjectStorageProvider | AudioUploadService, FeedbackService, PracticeHistoryService |
| ISttProvider | Provider (giao diện nhà cung cấp) | — | SttService |
| ILlmProvider | Provider (giao diện nhà cung cấp) | — | LlmService |
| ITtsProvider | Provider (giao diện nhà cung cấp) | — | TtsService |
| IMailProvider | Provider (giao diện nhà cung cấp) | — | MailService |
| IObjectStorageProvider | Provider (giao diện nhà cung cấp) | — | FileStorageService |
| UserRepository | Repository (Spring Data JPA) | — | AnalyticsService, AuthService, LoginAttemptService, PasswordResetService, UserService |
| PasswordResetTokenRepository | Repository (Spring Data JPA) | — | PasswordResetService |
| QuestionRepository | Repository (Spring Data JPA) | — | PracticeService, QuestionManagementService, QuestionService |
| PracticeRepository | Repository (Spring Data JPA) | — | AnalyticsService, AudioUploadService, EvaluationExecutor, PracticeHistoryService, PracticeService, QuestionManagementService, ScoringService |
| ScoreResultRepository | Repository (Spring Data JPA) | — | FeedbackService, PracticeHistoryService, ScoringService |
| CriterionScoreRepository | Repository (Spring Data JPA) | — | ScoringService |
| AuditLogRepository | Repository (Spring Data JPA) | — | AuditLogService |
| ApiUsageRepository | Repository (Spring Data JPA) | — | AnalyticsService, ScoringService |
| JwtAuthFilter | Bảo mật | JwtTokenProvider | — |
| JwtTokenProvider | Bảo mật | — | AuthService, AuthorizationService, JwtAuthFilter |
| PasswordEncoder | Bảo mật | — | AuthService, PasswordResetService, UserService |
| AuthorizationService | Bảo mật | JwtTokenProvider | — |
| GlobalExceptionHandler | Bảo mật | — | — |
