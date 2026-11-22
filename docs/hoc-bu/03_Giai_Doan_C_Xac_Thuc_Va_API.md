# Giai đoạn C: Xác thực, phân quyền và API nghiệp vụ

Thời gian: 27/10 - 20/11/2026. Người làm chính: Giang (auth #112 PR #9/#13/#14 merge 28/10, câu hỏi #116 PR #15/#16 merge 17/11, thống kê admin #163). Tuấn Anh làm API lịch sử (#118, PR #18) và quên mật khẩu (#157, PR #21), cả hai merge 20/11.

## 1. Hiểu nhanh trong 1 phút
- **Một câu:** biến hợp đồng OpenAPI thành các API chạy thật có bảo mật: đăng ký/đăng nhập bằng JWT, phân quyền ADMIN/CANDIDATE, tra cứu câu hỏi, lịch sử, quên mật khẩu, quản trị.
- **Hình ảnh đời thường:** tòa nhà có thẻ ra vào (JWT). Thẻ ghi tên và tầng được phép (role), nhưng bảo vệ vẫn tra sổ mỗi lần quẹt để biết thẻ đó còn hiệu lực không.
- **Ba ý chính:**
  1. Mật khẩu băm BCrypt; khóa 15 phút sau 5 lần sai; chống dò email và chống vượt giới hạn khi gửi song song.
  2. JWT HS256 sống 24 giờ, nhưng **trạng thái và role được nạp lại từ DB mỗi request**.
  3. Mọi lỗi trả về cùng một dạng `ErrorResponse`.

## 2. Từ điển nhanh
| Từ | Nghĩa |
|---|---|
| JWT | Chuỗi chữ ký số chứa thông tin người dùng (id, email, role, hạn); server không cần lưu phiên |
| HS256 | Ký JWT bằng một khóa bí mật chung (HMAC-SHA256); khóa ≥ 256 bit |
| BCrypt | Hàm băm mật khẩu cố ý chậm, tự có muối (salt); **chỉ xử lý 72 byte đầu** |
| RBAC | Phân quyền theo vai trò: `/admin/**` chỉ ADMIN |
| Stateless | Server không giữ phiên đăng nhập trong bộ nhớ; mọi request tự mang JWT |
| Pessimistic lock | Khóa dòng DB khi đọc để request song song phải xếp hàng (`PESSIMISTIC_WRITE`) |
| Enumeration (dò tài khoản) | Kẻ xấu thử email để biết email nào tồn tại; chống bằng cách phản hồi và thời gian giống nhau |
| `ErrorResponse` | Dạng lỗi thống nhất `{code, message, timestamp, fieldErrors}` |
| Soft delete | Xóa mềm: đánh dấu `HIDDEN`, không xóa dòng |
| `Specification` | Cách ghép điều kiện lọc động (ngành, vị trí, mức, từ khóa) bằng JPA |

## 3. Thân bài theo bước

### Bước 1. Đăng ký (`AuthService.register`)
- **Vì sao cần chuẩn hóa email:** `A@x.com` và `a@x.com` là một người. Email được hạ chữ theo `Locale.ROOT` (không phụ thuộc máy), và có chỉ mục duy nhất `uq_users_email` trên `lower(email)`.
- **Trùng email đồng thời:** hai request cùng lúc cùng email: một thắng, một chạm ràng buộc DB và trả **409**. Code chỉ đổi sang 409 khi vi phạm đúng chỉ mục `uq_users_email` (các lỗi ràng buộc khác không bị che).
- **Giới hạn mật khẩu theo byte:** BCrypt chỉ dùng 72 byte đầu. Tiếng Việt có dấu chiếm 2-3 byte mỗi ký tự, nên kiểm theo **byte UTF-8** (`@MaxUtf8Bytes(72)`), không theo số ký tự; nếu không, hai mật khẩu dài khác nhau có thể bị coi là một.

### Bước 2. Đăng nhập và khóa tài khoản (`AuthService.login`)
- **Quy tắc:** sai 5 lần (`MAX_FAILED_LOGINS`) thì khóa 15 phút (`LOCK_DURATION`) và trả **429 `ACCOUNT_LOCKED`** kèm số giây còn lại; hết hạn khóa thì tự mở.
- **Chống vượt giới hạn khi gửi song song:** tìm user bằng `findByEmailForUpdate` (`@Lock PESSIMISTIC_WRITE`). 20 request cùng lúc phải xếp hàng, nên bộ đếm sai không bị đọc cũ mà vượt 5.
- **Chống dò email:** nếu email không tồn tại vẫn tính một lần `passwordEncoder.matches(...)` với hash giả (`dummyHash`) cùng cost, để thời gian phản hồi giống nhau và không lộ email nào có thật.
- **Ví dụ số nhỏ:** lần sai 1-4 trả 401, lần sai thứ 5 đặt `lockedUntil = now + 15 phút`, request thứ 6 trả 429 dù mật khẩu đúng cho đến khi hết hạn.

### Bước 3. JWT và bộ lọc (`JwtService`, `JwtAuthenticationFilter`, `SecurityConfig`)
- **Phát hành:** HS256, mang `email`, `role` (claim), hạn từ `jwt.expiration-hours = 24`. Khóa lấy từ biến môi trường `JWT_SECRET`, không có trong code.
- **Điểm tinh tế:** bộ lọc **không tin role trong token**. Mỗi request nó nạp lại user từ DB theo khóa chính, nên tài khoản bị khóa, bị xóa hoặc bị đổi role có hiệu lực ngay, không phải chờ token hết hạn. Đánh đổi: thêm một truy vấn khóa chính mỗi request.
- **Phân quyền:** `SecurityConfig`: phiên `STATELESS`; `/auth/register`, `/auth/login`, `/auth/forgot-password`, `/auth/reset-password` công khai; `/error` công khai (để 404 không bị che thành 401); `/admin/**` yêu cầu `ADMIN`; còn lại phải đăng nhập.
- **Tách 401/403:** chưa đăng nhập hoặc token sai là 401; đã đăng nhập nhưng không đủ quyền là 403 (frontend không đăng xuất khi gặp 403).

### Bước 4. Xử lý lỗi thống nhất (`GlobalExceptionHandler`, `ApiException`)
- **Vì sao cần:** frontend chỉ cần một cách đọc lỗi. `ApiException(status, code, message)` ném từ service; handler đổi sang `ErrorResponse`. Lỗi bất ngờ trả 500 với thông báo chung, **không lộ chi tiết nội bộ**. Lỗi tham số sai kiểu hoặc vượt giới hạn trả 400.
- **`DbConstraints`:** đối chiếu tên ràng buộc DB để biết lỗi 409 là do ràng buộc nào, tránh nuốt nhầm lỗi khác.

### Bước 5. API câu hỏi (#116) và quản trị
- **Tra cứu:** `GET /questions` lọc theo ngành, vị trí, mức, từ khóa; khi lọc có ngành thì **tự gồm cả câu `Chung` của ngành đó** (`position IN (:position, 'Chung')`). Từ khóa dùng `lower()` ở DB cùng quy tắc locale và **escape ký tự đặc biệt của LIKE** (`%`, `_`). Phân trang có giới hạn (page ≤ 1.000.000 để offset không tràn int, trả 400 thay vì 500). `GET /questions/random`, `GET /questions/{id}`.
- **Quản trị (`AdminQuestionService`):** thêm, sửa, xóa; mọi thao tác ghi `AuditLog` trong **cùng transaction** (NF2). Xóa mềm đặt `HIDDEN`; trùng nội dung trả 409 `DUPLICATE_QUESTION`.
- **`referenceAnswer`:** chỉ gửi khi loại câu là `TECHNICAL`; `PUT` thay thế toàn bộ nên đổi sang loại khác thì đáp án cũ bị xóa (hành vi chủ ý).

### Bước 6. API lịch sử (#118, PR #18, Tuấn Anh)
`GET /history` (lọc theo thời gian, ngành, điểm) chỉ trả phiên `SCORED` của chính người dùng; `GET /history/{id}` trả chi tiết **bất kể trạng thái** (kể cả đang chấm hay lỗi), nên hai API khác nhau có chủ đích.

### Bước 7. Quên và đặt lại mật khẩu (#157, PR #21, Tuấn Anh)
- **Token:** 256 bit ngẫu nhiên (`SecureRandom`), chỉ nằm trong email. **DB chỉ lưu SHA-256 của token** nên lộ bảng `password_reset_tokens` cũng không dùng được.
- **Chống spam:** có thời gian chờ gửi lại (`resendCooldown`): nếu đã có token chưa dùng còn hiệu lực lâu hơn `(ttl − cooldown)` thì không gửi thêm email. Phản hồi luôn giống nhau dù email có tồn tại hay không.
- **Dùng token:** tìm theo hash và khóa dòng (`findByTokenHashForUpdate`) để một token không dùng được hai lần song song. `MailService` gửi SMTP, hoặc ghi log khi chạy dev.

### Bước 8. Thống kê admin (#163)
`/admin/analytics/overview`, `/users/{userId}`, `/export` (CSV; `xlsx` trả 400 vì chưa dùng Apache POI). Tổng hợp từ `api_usages` và phiên.

## 4. Luồng nên nói được: đăng nhập rồi gọi API admin
`POST /auth/login → (khóa dòng user, kiểm khóa/mật khẩu) → JWT 24h → mọi request kèm Authorization: Bearer → JwtAuthenticationFilter parse JWT, nạp lại user từ DB, nếu bị khóa/xóa/đổi role thì áp dụng ngay → SecurityConfig: /admin/** cần ADMIN, không đủ thì 403 → Controller → Service → ErrorResponse nếu lỗi`.

## 5. Khung giảng lại
**Nói (45 giây):** "Mình làm xác thực bằng JWT và BCrypt, khóa 15 phút sau 5 lần sai, bộ lọc nạp lại user từ DB mỗi request nên đổi quyền có hiệu lực ngay. Lỗi thống nhất qua `ErrorResponse`. Phần câu hỏi có lọc động và quản trị ghi audit log cùng transaction."

| Câu hỏi có thể bị hỏi | Gợi ý trả lời |
|---|---|
| Vì sao nạp lại user từ DB mỗi request? | Tài khoản bị khóa/xóa/đổi role phải có hiệu lực ngay, không đợi token hết hạn; đánh đổi một truy vấn khóa chính |
| Vì sao kiểm mật khẩu theo byte? | BCrypt chỉ xử lý 72 byte; tiếng Việt có dấu 2-3 byte/ký tự |
| Chống dò email đăng nhập thế nào? | Hash giả cùng cost cho email không tồn tại, phản hồi giống nhau |
| Hai người đăng ký cùng email cùng lúc? | Chỉ mục duy nhất trên `lower(email)`; một bên 409 |
| Lộ bảng reset token thì sao? | Chỉ lưu SHA-256, không dùng được |
| Hạn chế nên nói thẳng | Chưa rate limit đăng nhập theo IP; JWT chưa có thu hồi chủ động ngoài việc khóa user; chưa xlsx |

## 6. Câu hỏi ôn
1. Nếu bỏ `PESSIMISTIC_WRITE` ở đăng nhập, 20 request sai mật khẩu song song gây vấn đề gì?
2. Admin bị hạ xuống CANDIDATE lúc token của họ còn 20 giờ. Họ còn vào được `/admin` không? Nếu bộ lọc tin role trong token thì sao?
3. Tại sao email không tồn tại vẫn tốn thời gian băm?
4. Người dùng nhập mật khẩu 30 ký tự tiếng Việt có dấu. Có thể bị từ chối dù ít hơn 72 ký tự không?
5. Từ khóa tìm kiếm `100%` cho kết quả sai nếu không escape LIKE. Sai thế nào?

## 7. Đáp án
1. Cả 20 request cùng đọc bộ đếm cũ (ví dụ 0) rồi cùng cộng, có thể vượt hẳn 5 lần thử trước khi khóa được áp dụng.
2. Không: bộ lọc nạp role mới từ DB nên bị 403 ngay. Nếu tin role trong token thì vẫn vào được đến khi token hết hạn.
3. Để thời gian phản hồi giống trường hợp email có thật, không lộ email nào tồn tại.
4. Có: 30 ký tự có dấu có thể chiếm hơn 72 byte (2-3 byte mỗi ký tự), nên bị `@MaxUtf8Bytes` từ chối với thông báo rõ.
5. `%` là ký tự đại diện của LIKE nên khớp mọi chuỗi bắt đầu bằng `100`; phải escape để tìm đúng ký tự `%`.
