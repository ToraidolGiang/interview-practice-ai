# Phân tích ảnh hưởng: AI-PIPELINE (practice-sessions, STT/LLM, S3, async)

Lưu ý: explore.md chưa có; đọc trực tiếp code. Đường dẫn tính từ `backend/` (viết tắt `M` = `src/main/java/com/example/interviewpractice`).

## Điểm thay đổi gốc
| # | Thành phần | File/Symbol | Lý do |
|---|---|---|---|
| 1 | Dependency | `pom.xml:32-88` | Thêm AWS SDK v2 S3 (+BOM), HTTP client cho Gemini |
| 2 | Cấu hình | `src/main/resources/application.yml:19-27` | Thêm khóa ai.*, aws.* (region, bucket), multipart, executor |
| 3 | Repository | `M/repository/PracticeSessionRepository.java:12-17` | Thiếu method chuyển trạng thái có điều kiện |
| 4 | Exception | `M/exception/GlobalExceptionHandler.java` | Chưa xử lý upload quá cỡ / multipart |
| 5 | Mới | controller/service/adapter/config executor | Không có sẵn (grep `Async\|Executor` trong main: 0 kết quả) |

## Ảnh hưởng lan truyền
| # | Thành phần | Loại | Bằng chứng | Rủi ro | Cần làm |
|---|---|---|---|---|---|
| 1 | HTTP client: dùng `RestClient` (có sẵn qua `spring-boot-starter-webmvc`, `pom.xml:41-44`; Spring 7). Không cần thêm lib. JDK `java.net.http.HttpClient` cũng dùng được (Java 21). Tránh WebClient (cần webflux, chưa có). | code | pom.xml:41-44 | Thấp | Dùng `RestClient.Builder` + timeout (qua `JdkClientHttpRequestFactory`) |
| 2 | JSON: Boot 4 dùng Jackson 3 (`tools.jackson.databind.json.JsonMapper`), không phải `com.fasterxml` | code | SecurityConfig.java:22; pom.xml:49 | TB | Adapter Gemini parse bằng `JsonMapper`, đừng import `com.fasterxml.jackson.databind` |
| 3 | AWS SDK v2: Boot không quản lý BOM AWS. Thêm `dependencyManagement` import `software.amazon.awssdk:bom` (type pom, scope import) rồi dep `software.amazon.awssdk:s3` (không version). Nên loại `apache-client`/`netty-nio-client` dư, dùng `url-connection-client` hoặc giữ mặc định apache; chọn 1 để tránh cảnh báo nhiều HTTP client. `spring-boot-starter-parent` hiện không có `dependencyManagement` riêng | data/config | pom.xml:29-88 (không có dependencyManagement) | TB | Phiên bản BOM cần xác nhận lúc làm (không bịa số) |
| 4 | Biến bắt buộc `${...}` không default: `DATABASE_URL`, `JWT_SECRET`, `GEMINI_API_KEY`, `FPT_AI_API_KEY`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. Thiếu biến nào thì context fail "Could not resolve placeholder" (kể cả `BackendApplicationTests`). Hiện không code nào đọc `ai.*`/`aws.*` (grep `ai\.gemini\|aws\.` main/java: 0) nên thêm khóa mới có placeholder bắt buộc là tự gây vỡ test local | config/test | application.yml:10,16,21,23,26-27; ci.yml:36-42 | Cao | Khóa mới (`aws.region`, `aws.s3.bucket`, gemini model/base-url) dùng dạng `${ENV:default}`. Đặt default cho test: thêm `src/test/resources/application.yml` (hoặc `application-test.yml`+`@ActiveProfiles`) ghi đè `ai.*`, `aws.*` bằng giá trị giả; vẫn phải giữ `DATABASE_URL`/`JWT_SECRET` từ env/CI. Thêm env mới vào ci.yml:35-42 nếu giữ placeholder bắt buộc |
| 5 | Bean S3Client: tạo từ credential tĩnh khi context khởi động; `S3Client.builder()` cần region, thiếu thì lỗi. Tạo client lazy hoặc `@ConditionalOnProperty`; test dùng mock `S3Client`/`@MockitoBean` | code/test | application.yml:25-27 | TB | Region có default `ap-southeast-1`(hoặc theo cấu hình), không gọi mạng lúc khởi động |
| 6 | SecurityConfig: `/practice-sessions/**` rơi vào `.anyRequest().authenticated()` nên đã yêu cầu JWT, không cần sửa rule. Context-path `/api` đã tách khỏi matcher. CSRF đã tắt nên multipart POST OK. Quyền sở hữu phiên (user chỉ xem phiên của mình) phải kiểm trong service qua `AuthUser`, không có sẵn | code | SecurityConfig.java:42-48,40; server.servlet.context-path application.yml:4 | TB (IDOR) | Trả 404 khi phiên không thuộc user; test IDOR |
| 7 | GlobalExceptionHandler: `Exception.class` catch-all trả 500 (dòng 52-57). `MaxUploadSizeExceededException` (Spring 7: `ResponseEntityExceptionHandler` đã có xử lý riêng cho `MaxUploadSizeExceededException` -> 413 qua `handleExceptionInternal`; cần xác minh) và `MultipartException`/`MissingServletRequestPartException` sẽ bị `handleExceptionInternal` (dòng 113-119) biến thành code `PAYLOAD_TOO_LARGE`/`BAD_REQUEST` với message mặc định "Yêu cầu không hợp lệ" (messageFor dòng 121-127 không có case 413). Lỗi multipart ném trong filter/resolver trước controller có thể không qua advice | code | GlobalExceptionHandler.java:52,113-128 | Cao | Override `handleMaxUploadSizeExceededException` + `handleMissingServletRequestPart` hoặc thêm `case 413`; trả `ErrorResponse` chuẩn. Đặt `spring.servlet.multipart.max-file-size`/`max-request-size` (hiện chưa có trong yml; mặc định Spring 1MB) |
| 8 | PracticeSession entity: có sẵn `status` (CREATED/UPLOADED/PROCESSING/SCORED/FAILED), `audioKey`, `durationSec`, `processingStartedAt`, `errorCode`; không có `@Version` | data | PracticeSession.java:32,46-72; V1__init.sql:44-66 | TB | Chuyển trạng thái có điều kiện phải bằng `@Modifying @Query` atomic, không dựa read-modify-write |
| 9 | PracticeSessionRepository chỉ có `findByUserIdOrderByStartedAtDesc`, `existsByQuestionId` (+ CRUD). Thiếu: `findByIdAndUserId`, `@Modifying UPDATE ... SET status='PROCESSING', processing_started_at=:now WHERE id=:id AND status='UPLOADED'` (trả int; 0 = đã/đang chấm -> 409), tương tự `PROCESSING -> SCORED/FAILED`; `UPLOADED` đặt lúc upload xong (WHERE status='CREATED') | data | PracticeSessionRepository.java:12-17 | Cao | Thêm các method trên; cần `clearAutomatically=true`; test race 2 evaluate đồng thời (mẫu: AuthLoginConcurrencyTest) |
| 10 | ScoreResultRepository chỉ có `findBySessionId` (1 kết quả/phiên, cột session_id; xem chú thích V1__init.sql:68). `ScoreCriterionRepository` rỗng (criteria cascade qua ScoreResult.criteria:99). `ApiUsageRepository` rỗng (Provider STT/LLM/TTS). Re-evaluate cần xóa/ghi đè kết quả cũ | data | ScoreResultRepository.java:12; ApiUsageRepository.java; ApiUsage.java:32 | TB | Kiểm tra UNIQUE(session_id) trong V1 (chưa xác minh); ghi `ApiUsage` cho từng lần gọi STT/LLM (kể cả lỗi) |
| 11 | Chạy async: không có `@EnableAsync`/executor/`@EnableScheduling`. Thêm `ThreadPoolTaskExecutor` bean (queue có giới hạn, `AbortPolicy` -> 429/503). Async thread không có SecurityContext/transaction của request; job dọn phiên treo dựa vào `idx_sessions_processing` (V1__init.sql:66) | async | M/ (grep) ; PracticeSession.java:69 | Cao | Executor đặt tên, `setWaitForTasksToCompleteOnShutdown`; truyền `sessionId` (không truyền entity lazy); `@Transactional` ở service con, không ở phương thức submit; khi từ chối submit phải hoàn tác PROCESSING -> UPLOADED |
| 12 | Test context: `@SpringBootTest` ở BackendApplicationTests, QuestionApiIntegrationTest(:48), AuthLoginConcurrencyTest, AuthRegisterIntegrationTest đều cần Postgres thật qua `DATABASE_URL` + đủ biến env. Thêm bean S3/executor làm các test này nạp thêm; nếu bean cần env mới thì cả 4 test vỡ | test | BackendApplicationTests.java:6-7; QuestionApiIntegrationTest.java:48-49 | Cao | Xem mục 4-5; không cần sửa code 4 test nếu có default ở test resources. Test mới cho `/practice-sessions` dùng `@MockitoBean` cho adapter STT/LLM/S3 |
| 13 | Unit/WebMvc test dạng mock thuần (QuestionControllerTest dùng `mock()`), không nạp context: không bị ảnh hưởng | test | QuestionControllerTest.java:6-9 | Thấp | Mẫu cho controller test mới |
| 14 | CI: job backend có Postgres service và env giả; chạy `./mvnw -B verify` | config | .github/workflows/ci.yml:22-42,51 | TB | Thêm env mới nếu yml bắt buộc; nếu dùng test resources thì không cần. Test tích hợp tuyệt đối không gọi Gemini/S3 thật |
| 15 | Hợp đồng API: `docs/api/openapi.yaml` và `docs/api/API_Spec_Table.md` đã có mô tả practice-sessions/multipart (khớp từ khóa grep) | API | docs/api/openapi.yaml | TB | Triển khai khớp spec; không tự đổi response |
| 16 | `DeliveryCalculator`/`DeliveryMetrics` có sẵn để tính wpm/filler cho ScoreResult | code | M/service/scoring/DeliveryCalculator.java | Thấp | Tái dùng trong pipeline, không viết lại |

## Tái dùng được
`ApiException`/`ErrorResponse` (lỗi chuẩn), `JsonMapper`, `Clock` (`config/ClockConfig.java`, dùng cho timestamp để test được), `AuthUser`, `JwtProperties` làm mẫu `@ConfigurationProperties` record, `DeliveryCalculator`, `DbConstraints` (map lỗi ràng buộc DB).

## Luồng nghiệp vụ liên quan
create (CREATED) -> upload (UPLOADED, audio_key) -> evaluate 202 (PROCESSING) -> async STT -> LLM -> ghi ScoreResult+criteria+ApiUsage -> SCORED/FAILED -> GET result. Chưa có `docs/knowledge/`.

## Tương thích ngược & dữ liệu cũ
Schema đã có đủ bảng/cột (V1__init.sql:44-130): không cần migration cho luồng cơ bản. Nếu cần UNIQUE(session_id) hay cột mới thì thêm `V3__...sql`, không sửa V1/V2 (Flyway checksum). `ddl-auto: validate` (yml:13) nên entity phải khớp.

## Vùng thiếu test
Không có test cho PracticeSession/ScoreResult/ApiUsage repository; chuyển trạng thái đồng thời; multipart quá cỡ/sai content-type; IDOR; executor đầy; adapter lỗi/timeout/JSON sai của Gemini.

## Câu hỏi mở
- Boot 4 `ResponseEntityExceptionHandler` có handler 413 sẵn không (cần chạy thử xác minh).
- V1 có UNIQUE(session_id) trên score_results không (đọc phần dòng 89-100 chưa xem hết).
- Phiên bản AWS SDK BOM nào tương thích; chọn HTTP client S3 nào.
- `FPT_AI_API_KEY`/TTS có thuộc phạm vi task này không (key đang bắt buộc nhưng chưa dùng).
