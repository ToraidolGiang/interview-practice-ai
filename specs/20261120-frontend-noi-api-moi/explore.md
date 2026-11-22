## Góc nhìn: hiện trạng frontend so với hợp đồng openapi
### Điểm vào
- Router duy nhất — frontend/src/App.jsx:20-52. Public: `/`, `/login`, `/register`, `/forgot-password` (GuestOnly), `/reset-password`. Dưới RequireAuth+AppLayout: `/dashboard /questions /practice[/:sessionId] /results/:sessionId /history /profile /settings /upgrade /upgrade/success`. KHÔNG có route `/admin/*`.
- Gọi API: frontend/src/api/client.js:16 `request(path,{method,body,auth})`, base `/api`.
### Luồng / hiện trạng theo từng việc
- API client: ApiError{status,code,message,fieldErrors} (client.js:7-14). Chỉ xử lý đặc biệt 401 (có token -> event UNAUTHORIZED -> AuthContext.logout, client.js:48), 502-504 -> NETWORK_ERROR. KHÔNG có xử lý riêng 403/429 (grep "429" rỗng).
- Map mã lỗi -> tiếng Việt: FAILED_MESSAGES frontend/src/constants/scoring.js:99-105 (ANSWER_TOO_SHORT, STT_ERROR, LLM_ERROR, INVALID_RESULT, SERVER_RESTART). THIẾU PROCESSING_TIMEOUT, INTERNAL_ERROR (openapi:1215). Dùng ở ResultsPage.jsx:135-154 (FailedCard; fallback "Đã xảy ra lỗi ... (code)"; canRetry = code !== ANSWER_TOO_SHORT). PracticePage.jsx:93,165 chỉ xử lý FAILED + ANSWER_TOO_SHORT.
- Lỗi HTTP lẻ tẻ theo code: PracticePage.jsx:108-112 submitErrorMessage (400, SESSION_PROCESSING; còn lại hiện err.message của server); ResultsPage.jsx:141-150 retry (evaluateSession) chỉ `setError(err.message)` => 429 TOO_MANY_PROCESSING/DAILY_LIMIT_EXCEEDED hiện message thô từ backend, chưa map; ResultsPage.jsx:640-646 rescore xử lý SESSION_PROCESSING, ANSWER_TOO_SHORT; useStartPractice.js:26 (404); LoginPage.jsx:44 ACCOUNT_LOCKED/423; RegisterPage.jsx:42 EMAIL_EXISTS; ResetPasswordPage.jsx:42 INVALID_TOKEN.
- Polling/FAILED/PROCESSING: hooks/useSessionResult.js:7-62 (poll 2s khi PROCESSING, phase processing|scored|failed|not-submitted|error); PracticePage.jsx:66 (PROCESSING/SCORED chuyển hướng), ResultsPage.jsx dùng phase.
- (1) 3 mã lỗi 429/timeout: chưa có map nào cho TOO_MANY_PROCESSING, DAILY_LIMIT_EXCEEDED, PROCESSING_TIMEOUT. Điểm phát sinh 429: evaluateSession (PracticePage.jsx:75 `submit`; ResultsPage.jsx:142 retry) và rescoreSession (ResultsPage.jsx:637).
- (2) #161 chọn câu hỏi: ĐÃ CÓ một phần — pages/QuestionsPage.jsx (327 dòng) dùng listQuestions + randomQuestion, filter qua URL searchParams (industry, position, level, questionType, keyword; PAGE_SIZE 6), Pagination, useStartPractice; PracticeLobby.jsx dùng randomQuestion; useSuggestions.js dùng listQuestions. api/questions.js đủ 3 hàm (list/random/get).
- (3) #162 quản trị câu hỏi: CHƯA có gì (không api/admin*.js, không trang, không route, không link menu).
- (4) Đã nối sẵn (api + màn): history.js listHistory/getHistoryDetail (HistoryPage.jsx:3, hooks/useProgress.js:2); auth.js forgotPassword/resetPassword (ForgotPasswordPage, ResetPasswordPage, có route); practice.js rescoreSession (ResultsPage.jsx:3,637 — editor "Sửa transcript", MIN_RESCORE_WORDS). CHƯA có: /admin/analytics/overview, /admin/analytics/users/{userId}, /admin/analytics/export (không api, không trang).
### Pattern & quy ước
- Page = file .jsx + .module.css cùng tên; class dùng chung toàn cục trong index.css: `card`, `btn btn-primary|btn-outline`, `alert`, `alert-warn`, `alert-<tone>`, `section-title`. Lỗi hiện `<p role="alert" className="alert">`.
- Component chung: Breadcrumb, AuthForm(+Alert/SuccessPanel), Pagination, Icon (name=...), Avatar, Logo, QuestionPills, DashboardWidgets, RecordingPlayer. Hằng: constants/taxonomy.js (INDUSTRIES, LEVELS, QUESTION_TYPES, questionTypeLabel), scoring.js, practice.js.
- Token CSS: frontend/src/index.css:2-27+ (--primary #3525cd, --text*, --border, --surface*, --font-heading/body).
- Hook data tự viết (không react-query); cancel flag trong useEffect.
### Đối chiếu openapi (docs/api/openapi.yaml)
- Đường dẫn admin thật: `/admin/analytics/overview` (773, params from,to), `/admin/analytics/users/{userId}` (807), `/admin/analytics/export` (842, format csv|xlsx, from, to; trả file) — KHÁC cách gọi tắt "/users/{userId}", "/export" trong đề bài.
- `/admin/questions` GET (624: status, keyword, page, size -> AdminQuestionPage), POST (661; QuestionUpsertRequest 1149 : content, industry, position, level, questionType, answerHint, referenceAnswer; 201; 400 gắn fieldErrors; 409 DUPLICATE_QUESTION), `/admin/questions/{id}` PUT (699), DELETE (743). AdminQuestion có referenceAnswer (1138). Cần đọc thêm 699-772 để biết mã trả của DELETE/PUT.
- ErrorResponse.code liệt kê (openapi ~1015-1025): thêm TOO_MANY_PROCESSING, DAILY_LIMIT_EXCEEDED (429), SERVICE_UNAVAILABLE (503), FORBIDDEN, DUPLICATE_QUESTION; PROCESSING_TIMEOUT là errorCode của phiên FAILED (1215), không phải mã HTTP. 429 ở /evaluate (417) và /rescore (511).
- AnalyticsOverview (1389): totalUsers, activeUsers, totalSessions, scoredSessions, averageScore, aiApiCalls, estimatedCost. UserActivity ở ~1420 (chưa đọc).
### Phân quyền UI
- UserDto có `role` (enum CANDIDATE|ADMIN, openapi:950, 1090,1102) và LoginResponse.user giữ trong session (AuthContext.jsx:22-27). AuthContext chỉ phơi `user,isAuthenticated,login,logout` — chưa có isAdmin; RequireAuth.jsx:4-9 chỉ kiểm đăng nhập, KHÔNG chặn theo role; AppLayout menu (110-126) không có mục admin. user.role có sẵn trong storage để dùng. 403 chưa được xử lý ở client.
### Test / lệnh kiểm
- package.json: scripts dev, dev:mock (prism 4010 từ openapi), mock, build (vite build), lint (oxlint; có .oxlintrc.json), preview. KHÔNG có vitest/jest/playwright, không file test. Lệnh kiểm duy nhất: `npm run lint` và `npm run build` trong frontend/.
- Mock: frontend/mock/build-mock-spec.mjs + examples.js sinh từ openapi (cần cập nhật examples cho endpoint admin mới nếu dev:mock dùng).
### Rủi ro / điểm dễ vỡ
- ResultsPage.jsx 695 dòng, HistoryPage 499: file lớn, FailedCard/RescoreEditor nằm chung; sửa map lỗi nên tập trung ở constants/scoring.js.
- 401 chỉ đăng xuất khi có token; 403 sẽ hiện message thô.
- QuestionsPage hiện dùng /questions (ẩn HIDDEN, không referenceAnswer) – admin phải dùng /admin/questions riêng.
### Lệch giữa tri thức và code
- frontend/README.md:30 nói có `src/assets/figma/` — KHÔNG tồn tại (chỉ src/assets/illustrations; Icon.jsx là SVG inline). README:3 nói theo Figma "InterviewAI-MockupV1" (xác nhận).
- Đề bài coi history/forgot-reset/rescore là "cần nối"; thực tế frontend đã nối (api + màn). Chỉ analytics/admin thiếu.
### File then chốt
1. frontend/src/App.jsx:20-52  2. frontend/src/api/client.js:7-52  3. frontend/src/constants/scoring.js:99-105  4. frontend/src/pages/ResultsPage.jsx:130-160, 625-650  5. frontend/src/pages/PracticePage.jsx:66-112  6. frontend/src/auth/AuthContext.jsx + RequireAuth.jsx  7. frontend/src/pages/QuestionsPage.jsx:1-60  8. frontend/src/layouts/AppLayout.jsx:100-130  9. frontend/src/index.css:1-60  10. docs/api/openapi.yaml:624-880, 1015-1025, 1138-1160, 1389-1444
## Chưa xác minh
- Chưa đọc: AppLayout nav chính, QuestionsPage phần render, UserActivity/AdminQuestionPage schema, PUT/DELETE admin responses, examples.js/mock cho admin, mã trả của /export (binary).
- ForgotPassword/ResetPassword/HistoryPage chỉ xác nhận có gọi API, chưa đối chiếu từng tham số/schema với openapi.
