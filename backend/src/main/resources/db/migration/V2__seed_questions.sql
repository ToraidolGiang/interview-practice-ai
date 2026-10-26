-- Flyway migration V2: seed ngân hàng câu hỏi (sinh bởi scripts/dataset/build_seed_sql.py, không sửa tay).
-- Câu hỏi được chuyển thể sang tiếng Việt bằng Gemini từ các nguồn mở sau (giữ ghi nguồn theo license):
--   https://github.com/Gauthamjm007/Backend-NodeJS-Golang-Interview_QA (MIT, commit 2cbec619bd7d)
--   https://github.com/ViacheslavChernyshov/java-interview-questions-and-answers (MIT, commit 597e08112ab6)
--   https://github.com/alexeygrigorev/data-science-interviews (CC-BY-4.0, commit 919f44547ef5)
--   https://github.com/h5bp/Front-end-Developer-Interview-Questions (MIT, commit 33f5498b653e)
--   https://github.com/sudheerj/reactjs-interview-questions (MIT, commit 55b7d491cd74)
--   https://github.com/trimstray/test-your-sysadmin-skills (MIT, commit d566322e4f6a)
--   https://github.com/yangshun/tech-interview-handbook (MIT, commit e1d28e8886c0)
-- Danh mục ngành/vị trí: docs/business/Danh_Muc_Nganh_Vi_Tri.md

-- Tài khoản hệ thống làm created_by cho câu hỏi seed; password_hash không phải BCrypt nên không đăng nhập được
INSERT INTO users (id, full_name, email, password_hash, role, status)
VALUES ('00000000-0000-0000-0000-000000000001', 'Hệ thống', 'system@interview-practice.local', '!disabled', 'ADMIN', 'LOCKED');

INSERT INTO questions (id, content, industry, position, level, question_type, answer_hint, reference_answer, status, created_by) VALUES
('c97618ab-6ce2-5e4a-9341-431ade6917c0', 'Bạn hãy giải thích cách dùng SGD (stochastic gradient descent) để huấn luyện mạng nơ-ron.', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu ý tưởng ước lượng gradient trên một phần nhỏ dữ liệu -> so sánh với batch gradient descent -> nói về ưu nhược điểm khi huấn luyện mạng nơ-ron.', '- SGD ước lượng gradient của hàm mất mát trên một hoặc vài mẫu (mini-batch) chọn ngẫu nhiên thay vì toàn bộ dữ liệu
- Mỗi bước cập nhật trọng số theo hướng ngược gradient, nhân với learning rate
- So với batch gradient descent, mỗi bước rẻ hơn nhiều nên phù hợp với tập dữ liệu lớn, giảm mạnh thời gian huấn luyện
- Nhiễu do lấy mẫu ngẫu nhiên làm đường hội tụ dao động, cần nhiều bước hơn nhưng có thể giúp thoát điểm cực tiểu cục bộ kém
- Trong thực tế thường dùng mini-batch SGD, kết hợp xáo trộn dữ liệu mỗi epoch', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('241935fe-bcef-521c-8c82-cd2ace31a07f', 'Learning rate là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa learning rate là siêu tham số -> giải thích vai trò "độ dài bước" khi cập nhật trọng số -> ví dụ ảnh hưởng của giá trị lớn hoặc nhỏ.', '- Là siêu tham số (hyperparameter) quyết định mô hình được điều chỉnh nhanh hay chậm trong quá trình huấn luyện
- Có thể hiểu là độ dài bước khi cập nhật trọng số theo hướng ngược gradient
- Trọng số mới = trọng số cũ trừ learning rate nhân gradient
- Chọn learning rate phù hợp ảnh hưởng trực tiếp tới tốc độ và chất lượng hội tụ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1ea397b3-25e8-5036-b6d6-fff343a49bc0', 'Chuyện gì xảy ra khi learning rate quá lớn? Còn khi quá nhỏ thì sao?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Phân tích riêng hai trường hợp quá lớn và quá nhỏ -> nêu hậu quả với quá trình hội tụ -> có thể nhắc cách nhận biết qua đường loss.', '- Learning rate quá lớn: bước nhảy vượt qua điểm cực tiểu, loss dao động hoặc tăng vọt, mô hình có thể không hội tụ (phân kỳ)
- Learning rate quá nhỏ: hội tụ rất chậm, tốn thời gian huấn luyện
- Learning rate nhỏ cũng dễ bị kẹt ở cực tiểu cục bộ hoặc vùng phẳng
- Có thể nhận biết qua đường loss: dao động mạnh khi quá lớn, giảm rất chậm khi quá nhỏ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1bfc386d-1600-54f4-985e-ba8651c3ce58', 'Bạn chọn giá trị learning rate như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nói rằng không có công thức cố định -> trình bày các cách thực tế (giá trị khởi điểm, thử nghiệm, LR finder, lịch giảm) -> nêu cách theo dõi để điều chỉnh.', '- Không có giá trị tối ưu cố định, phải thử nghiệm và theo dõi loss trên tập validation
- Thường bắt đầu với giá trị phổ biến (ví dụ 0.01 với SGD, 0.001 với Adam) rồi tinh chỉnh
- Có thể dùng grid/random search trên thang logarit hoặc kỹ thuật learning rate finder (tăng dần LR và quan sát loss)
- Kết hợp lịch điều chỉnh learning rate (step decay, cosine, warmup) trong quá trình huấn luyện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6675b61c-8656-5ad1-8eed-5194486efc28', 'Adam là gì? Điểm khác biệt chính giữa Adam và SGD là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa Adam (adaptive moment estimation) -> giải thích cơ chế momentum bậc 1 và bậc 2 -> so sánh với SGD về tốc độ hội tụ và khả năng tổng quát hoá.', '- Adam (Adaptive Moment Estimation) là thuật toán tối ưu dùng để huấn luyện mạng nơ-ron
- Adam lưu trung bình động của gradient (moment bậc 1, giống momentum) và của bình phương gradient (moment bậc 2)
- Nhờ đó mỗi tham số có learning rate thích ứng riêng, giảm ảnh hưởng của gradient nhiễu
- SGD dùng một learning rate chung cho mọi tham số, không tự thích ứng
- Adam thường hội tụ nhanh hơn và ít phải tinh chỉnh, còn SGD (có momentum) đôi khi cho mô hình tổng quát hoá tốt hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6deeb307-3141-5f37-9645-247ba94ea937', 'Khi nào bạn dùng Adam và khi nào dùng SGD?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu điểm mạnh của từng optimizer -> gắn với tình huống cụ thể (thử nghiệm nhanh, mô hình lớn, cần tổng quát hoá tốt) -> có thể nhắc kinh nghiệm thực tế.', '- Adam hội tụ nhanh, ít nhạy với learning rate nên hợp khi cần thử nghiệm nhanh, dữ liệu thưa hoặc mô hình như Transformer/NLP
- SGD có momentum thường tổng quát hoá tốt hơn, hay được dùng cho bài toán thị giác máy tính (CNN) khi có thời gian tinh chỉnh
- SGD cần chọn learning rate và lịch giảm learning rate cẩn thận hơn
- Có thể kết hợp: bắt đầu bằng Adam rồi chuyển sang SGD, hoặc dùng biến thể như AdamW', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('21c6acaa-a278-5e41-8348-2277424fa991', 'Nên giữ learning rate cố định hay thay đổi nó trong quá trình huấn luyện? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Đưa ra lựa chọn -> giải thích lý do giảm dần learning rate -> kể tên vài kỹ thuật learning rate schedule.', '- Thường nên thay đổi learning rate trong quá trình huấn luyện thay vì giữ cố định
- Giai đoạn đầu dùng learning rate tương đối lớn để tiến nhanh tới vùng tốt
- Giai đoạn sau giảm learning rate để không vượt qua điểm cực tiểu và hội tụ ổn định
- Các kỹ thuật phổ biến: step decay (ví dụ StepLR), exponential decay, cosine annealing, warmup, giảm khi validation loss không cải thiện (ReduceLROnPlateau)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6ae34417-b48c-5577-91ab-d3d6b193e665', 'Làm sao bạn quyết định thời điểm dừng huấn luyện một mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu tiêu chí dựa trên tập validation -> giải thích early stopping -> nhắc tới overfitting.', '- Theo dõi lỗi (loss) trên tập validation song song với tập train
- Dừng khi validation loss đạt mức thấp nhất và bắt đầu tăng trở lại, vì đó là dấu hiệu overfitting
- Kỹ thuật early stopping: dừng nếu validation loss không cải thiện sau một số epoch (patience)
- Giữ lại trọng số tại thời điểm validation loss tốt nhất', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1fd0e0da-e41f-5216-85bf-26493b99bbd7', 'Model checkpointing là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa checkpoint -> giải thích lợi ích khi huấn luyện lâu -> ví dụ cách lưu (mỗi epoch, lưu bản tốt nhất).', '- Là việc lưu lại trọng số (và trạng thái optimizer) của mô hình tại các thời điểm giữa quá trình huấn luyện
- Giúp tiếp tục huấn luyện từ checkpoint khi quá trình dài bị gián đoạn
- Có thể giữ lại phiên bản mô hình tốt nhất theo chỉ số trên tập validation
- Thường lưu định kỳ theo epoch/bước hoặc khi chỉ số validation cải thiện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b683bf19-f20d-5da7-a794-71e02257fe66', 'Bạn có thể chia sẻ quy trình bạn thường làm khi huấn luyện một mô hình không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày theo các bước: chuẩn bị dữ liệu -> huấn luyện và theo dõi -> tinh chỉnh, chống overfitting -> đánh giá trên tập test.', '- Chuẩn bị dữ liệu: làm sạch, chuẩn hoá đặc trưng, chia tập train/validation/test
- Chọn kiến trúc mô hình và siêu tham số ban đầu
- Huấn luyện: forward, tính loss, cập nhật trọng số bằng backpropagation, theo dõi cả train loss và validation loss
- Tinh chỉnh siêu tham số và dùng regularization (dropout, weight decay, early stopping) để tránh overfitting
- Đánh giá mô hình cuối trên tập test chưa từng thấy để ước lượng hiệu năng thực tế', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('986e7786-2b51-591f-9220-d76030b84041', 'Mạng nơ-ron được ứng dụng cho thị giác máy tính (computer vision) như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giới thiệu CNN là kiến trúc chủ đạo -> giải thích vì sao phù hợp với ảnh -> kể vài bài toán ứng dụng.', '- Kiến trúc phổ biến nhất là mạng nơ-ron tích chập (CNN)
- Lớp tích chập trích xuất đặc trưng cục bộ của ảnh và chia sẻ trọng số, giảm số tham số
- Các lớp nông học đặc trưng đơn giản (cạnh, góc), các lớp sâu học đặc trưng trừu tượng (hình dạng, vật thể)
- Ứng dụng: phân loại ảnh, phát hiện đối tượng, phân đoạn ảnh, nhận diện khuôn mặt
- Ngoài CNN còn có Vision Transformer và thường dùng transfer learning từ mô hình huấn luyện sẵn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('320c7e82-76a3-581b-ae55-cdf68564c334', 'Lớp tích chập (convolutional layer) là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa phép tích chập với kernel -> giải thích giả định thông tin cục bộ và chia sẻ trọng số -> nói về nhiều kernel tạo nhiều kênh đầu ra.', '- Lớp tích chập trượt các kernel (bộ lọc) nhỏ trên đầu vào, tính tổng có trọng số của các giá trị lân cận
- Dựa trên giả định thông tin cần thiết thường nằm gần nhau về không gian
- Cùng một kernel được dùng lại trên mọi vị trí (chia sẻ trọng số), giảm mạnh số tham số
- Dùng nhiều kernel để học nhiều đặc trưng, tạo ra nhiều kênh (feature map) đầu ra
- Xếp chồng nhiều lớp giúp mạng học các đặc trưng ở mức trừu tượng cao hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d3280ce2-5d63-5045-b59f-8a999acbf1f9', 'Tại sao cần dùng phép tích chập? Dùng lớp fully-connected cho ảnh có được không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'So sánh số tham số của hai cách -> nêu các tính chất tích chập tận dụng được (cục bộ, chia sẻ trọng số, bất biến dịch chuyển) -> kết luận.', '- Về lý thuyết dùng được, nhưng lớp fully-connected cần một trọng số cho mỗi kết nối nên số tham số bùng nổ với ảnh lớn
- Nhiều tham số khiến tốn bộ nhớ, tính toán và dễ overfitting
- Fully-connected bỏ qua cấu trúc không gian của ảnh (điểm ảnh lân cận có liên quan)
- Tích chập tận dụng tính cục bộ và chia sẻ trọng số, đồng thời phát hiện được đặc trưng ở bất kỳ vị trí nào (bất biến dịch chuyển)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c07dd3c0-4e54-5856-acff-f73c76be8ffe', 'Pooling trong CNN là gì? Tại sao chúng ta cần nó?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa pooling là phép giảm kích thước feature map -> nêu lợi ích -> có thể ví dụ max pooling.', '- Pooling là phép giảm kích thước (downsample) feature map bằng cách gộp các vùng nhỏ thành một giá trị
- Giảm số tham số và khối lượng tính toán ở các lớp sau
- Tăng vùng nhìn (receptive field), giúp các lớp sâu học đặc trưng trừu tượng hơn
- Giúp mô hình ít nhạy với dịch chuyển nhỏ của đối tượng trong ảnh và giảm overfitting', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cc511648-3386-5e33-a65c-b077bb5ecb56', 'Max pooling hoạt động như thế nào? Ngoài ra còn những kỹ thuật pooling nào khác?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Mô tả cách max pooling lấy giá trị lớn nhất trong cửa sổ -> nêu cấu hình phổ biến -> kể các kiểu pooling khác.', '- Max pooling chia feature map thành các vùng (cửa sổ) và lấy giá trị lớn nhất trong mỗi vùng
- Cấu hình phổ biến là cửa sổ 2x2, stride 2, giảm kích thước từ NxN xuống N/2xN/2
- Cửa sổ lớn hơn 3x3 ít dùng vì mất quá nhiều thông tin
- Kỹ thuật khác: average pooling (lấy trung bình), min pooling, global pooling (gộp toàn bộ feature map thành một giá trị cho mỗi kênh)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fe69022c-e6d3-53cf-a3db-865bd5c0b34b', 'Event loop trong JavaScript là gì? Call stack và task queue khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích JavaScript chạy đơn luồng -> mô tả vai trò call stack, task queue -> trình bày cách event loop điều phối, có thể nhắc microtask.', '- JavaScript chạy đơn luồng, mỗi lúc chỉ thực thi một đoạn code trên call stack
- Call stack lưu các hàm đang thực thi theo thứ tự LIFO
- Task queue chứa các callback chờ chạy (setTimeout, sự kiện DOM, I/O) sau khi tác vụ bất đồng bộ hoàn tất
- Event loop liên tục kiểm tra: khi call stack rỗng thì lấy task tiếp theo trong queue đưa vào stack
- Microtask queue (Promise, queueMicrotask) được xử lý hết trước khi lấy task (macrotask) tiếp theo', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('39184c7f-c548-5c04-a512-294026685055', 'Biến khai báo bằng let, var và const khác nhau thế nào? Có thể thay đổi thuộc tính của object khai báo bằng const không, và làm sao để ngăn điều đó?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'So sánh ba từ khoá theo phạm vi, hoisting, khả năng gán lại -> giải thích const chỉ khoá tham chiếu -> nêu cách dùng Object.freeze.', '- var có phạm vi hàm (function scope), được hoisting và khởi tạo undefined, cho phép khai báo lại
- let và const có phạm vi khối (block scope), nằm trong temporal dead zone trước khi khai báo
- let cho phép gán lại, const không cho phép gán lại
- const chỉ cố định tham chiếu, vẫn có thể thay đổi thuộc tính của object/mảng
- Muốn ngăn thay đổi thuộc tính dùng Object.freeze (chỉ đóng băng nông, cần freeze đệ quy cho object lồng nhau)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dca74e24-b00c-5ede-b449-ad98003c278d', 'Class trong ES6 và hàm khởi tạo (function constructor) trong ES5 khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nói rằng class là cú pháp trên nền prototype -> liệt kê các khác biệt về cú pháp và hành vi -> ví dụ kế thừa.', '- Class ES6 về bản chất vẫn dựa trên prototype, chủ yếu là cú pháp gọn hơn (syntactic sugar)
- Class bắt buộc gọi bằng new, gọi như hàm thường sẽ lỗi; function constructor thì gọi được
- Khai báo class không được hoisting như khai báo hàm (nằm trong temporal dead zone) và luôn chạy ở strict mode
- Kế thừa với class dùng extends và super gọn hơn so với tự gán prototype và gọi Parent.call(this)
- Phương thức trong class mặc định không liệt kê được (non-enumerable)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fc667b31-a99c-57d7-9e77-73b4ccec2b9a', 'Bạn hãy nêu một trường hợp nên dùng arrow function. Arrow function khác hàm thông thường ở điểm nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu ví dụ sử dụng (callback, giữ this) -> liệt kê khác biệt về this, arguments, new -> nói khi nào không nên dùng.', '- Thường dùng cho callback ngắn (map, filter) hoặc khi cần giữ this của ngữ cảnh bên ngoài (ví dụ trong setTimeout, event handler trong class)
- Arrow function không có this riêng, this được lấy theo phạm vi bao quanh (lexical this)
- Không có đối tượng arguments riêng, không dùng được làm constructor với new, không có prototype
- Cú pháp ngắn gọn, có thể trả về ngầm định khi thân hàm là một biểu thức
- Không nên dùng làm method của object khi method cần this trỏ tới chính object đó', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('93d564dc-7888-5eba-834f-d528bd244c74', 'Dùng arrow function để định nghĩa method trong constructor có lợi ích gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích vấn đề mất this khi truyền method làm callback -> nêu cách arrow function giải quyết -> nhắc đánh đổi về bộ nhớ.', '- Arrow function giữ this theo ngữ cảnh lúc tạo, nên this luôn trỏ tới instance
- Có thể truyền method làm callback (event handler, setTimeout) mà không bị mất this, không cần bind
- Thường gặp trong React class component khi khai báo handler
- Đánh đổi: mỗi instance có một bản sao hàm riêng thay vì dùng chung trên prototype, tốn bộ nhớ hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8e888281-b29e-5214-abaa-5627ad4ea9ac', 'Higher-order function là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> giải thích dựa trên tính chất hàm là first-class -> lấy ví dụ trong JavaScript.', '- Là hàm nhận một hoặc nhiều hàm khác làm tham số, hoặc trả về một hàm
- Có được nhờ hàm trong JavaScript là first-class (có thể gán, truyền, trả về như giá trị)
- Ví dụ có sẵn: map, filter, reduce, forEach, setTimeout
- Giúp trừu tượng hoá hành vi, tái sử dụng code (ví dụ hàm tạo middleware, debounce)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3a4cf2a4-a658-54a7-b234-9098d5e19da9', 'Destructuring trong JavaScript là gì? Bạn hãy lấy ví dụ với object hoặc mảng.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa destructuring -> mô tả ví dụ với object và với mảng -> nêu các tính năng đi kèm như giá trị mặc định, đổi tên.', '- Destructuring là cú pháp tách giá trị từ mảng hoặc thuộc tính từ object ra các biến riêng
- Với object: lấy theo tên thuộc tính, ví dụ lấy name và age từ object user
- Với mảng: lấy theo vị trí, ví dụ lấy phần tử thứ nhất và thứ hai
- Hỗ trợ giá trị mặc định, đổi tên biến, lấy phần còn lại bằng rest
- Hay dùng khi nhận tham số hàm, props trong React, hoặc hoán đổi giá trị hai biến', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9e42acc3-d3dd-5380-815e-8e0f152dc875', 'Currying là gì? Kỹ thuật này mang lại lợi ích gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa currying -> mô tả ví dụ đơn giản bằng lời -> nêu lợi ích như partial application, tái sử dụng hàm.', '- Currying biến một hàm nhiều tham số thành chuỗi các hàm, mỗi hàm nhận một tham số
- Ví dụ: hàm cộng ba số trở thành add(1)(2)(3)
- Cho phép áp dụng một phần (partial application): cố định vài tham số để tạo hàm mới chuyên biệt
- Giúp tái sử dụng và kết hợp hàm (function composition) theo phong cách lập trình hàm
- Dựa trên closure để ghi nhớ các tham số đã truyền', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5812ba7e-48da-5257-8cdd-d95091607369', 'Spread syntax có lợi ích gì và khác rest syntax như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích chung cú pháp dấu ba chấm -> phân biệt spread (mở rộng) và rest (gom lại) -> ví dụ sử dụng.', '- Cả hai dùng cú pháp dấu ba chấm nhưng ngữ nghĩa ngược nhau
- Spread trải các phần tử của mảng/thuộc tính của object ra: sao chép, gộp mảng hoặc object, truyền mảng làm danh sách tham số
- Spread giúp tạo bản sao mới thay vì sửa trực tiếp, hữu ích cho dữ liệu bất biến (ví dụ state trong React)
- Rest gom các phần tử còn lại thành một mảng/object: tham số rest của hàm, phần còn lại khi destructuring
- Lưu ý spread chỉ sao chép nông (shallow copy)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('13644ccb-ffe0-53e9-8070-d0ac4e27b8ac', 'Trong JavaScript, làm thế nào để chia sẻ code giữa các file?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày khái niệm module -> so sánh ES Modules và CommonJS -> có thể nhắc cách cũ và vai trò bundler.', '- Dùng hệ thống module để tách code ra nhiều file và chia sẻ qua export/import
- ES Modules: dùng export (named hoặc default) và import, là chuẩn hiện tại trên trình duyệt và Node.js
- CommonJS: dùng module.exports và require, phổ biến trong Node.js trước đây
- Trước khi có module, code được chia sẻ qua biến toàn cục hoặc mẫu IIFE/AMD
- Bundler như Webpack, Vite gom các module lại để triển khai trên trình duyệt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3e0bfacd-7a10-5ef7-a55c-b63b830004f8', 'Khi nào bạn nên tạo thành viên tĩnh (static) trong class?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa static member -> nêu các trường hợp dùng điển hình -> lấy ví dụ.', '- Thành viên static thuộc về class, không thuộc từng instance, truy cập qua tên class
- Dùng cho hàm tiện ích liên quan tới class nhưng không cần dữ liệu của instance (ví dụ Math.max, Array.isArray)
- Dùng cho factory method tạo instance (ví dụ User.fromJSON)
- Dùng cho hằng số, cấu hình hoặc bộ đếm/cache dùng chung giữa các instance
- Tránh nhân bản dữ liệu dùng chung trên mỗi instance', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d19f9ec8-03f2-5f3f-b11b-b5374d343083', 'Promise là gì? Bạn dùng Promise ở đâu và như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa Promise và các trạng thái -> nêu cách dùng then/catch, async/await -> ví dụ tình huống thực tế như gọi API.', '- Promise là đối tượng đại diện cho kết quả của một thao tác bất đồng bộ sẽ có trong tương lai
- Có ba trạng thái: pending, fulfilled (thành công), rejected (thất bại)
- Xử lý kết quả bằng then, catch, finally hoặc cú pháp async/await
- Giúp tránh callback hell, dễ nối chuỗi các thao tác bất đồng bộ
- Dùng khi gọi API (fetch), đọc file, chờ nhiều tác vụ song song với Promise.all', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c205e40f-51c4-5b7d-9cf0-bdd354a44a30', 'Bạn áp dụng các nguyên lý lập trình hướng đối tượng (OOP) khi viết JavaScript như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu lần lượt các nguyên lý OOP -> giải thích cách hiện thực trong JavaScript (class, prototype, closure) -> kèm ví dụ từ dự án.', '- Đóng gói (encapsulation): dùng class với trường private (#) hoặc closure để ẩn dữ liệu nội bộ
- Kế thừa: dùng extends/super hoặc chuỗi prototype để tái sử dụng hành vi
- Đa hình: các lớp con ghi đè phương thức, cùng giao diện nhưng hành vi khác nhau
- Trừu tượng hoá: chỉ công khai các phương thức cần thiết, ẩn chi tiết cài đặt
- Trong JavaScript nên ưu tiên composition hơn kế thừa sâu và hiểu rằng class được xây trên prototype', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0b0ca7cb-bfcf-5afe-8b29-4ea889938cc2', 'event.target và event.currentTarget khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa từng thuộc tính -> giải thích qua cơ chế event bubbling -> ví dụ với event delegation.', '- event.target là phần tử thực sự phát sinh sự kiện (nơi người dùng click)
- event.currentTarget là phần tử đang gắn listener xử lý sự kiện tại thời điểm đó
- Hai giá trị khác nhau khi sự kiện nổi bọt (bubbling) từ phần tử con lên phần tử cha có listener
- Hữu ích trong event delegation: gắn listener ở cha, dùng target để biết phần tử con nào được click', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4600f452-60e8-54d7-a824-77b172d78ea4', 'event.preventDefault() và event.stopPropagation() khác nhau thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích tác dụng của từng hàm -> nêu ví dụ tình huống dùng -> nhấn mạnh hai hàm độc lập với nhau.', '- preventDefault ngăn hành vi mặc định của trình duyệt (submit form, mở link, tick checkbox)
- stopPropagation ngăn sự kiện lan truyền tiếp lên (hoặc xuống) các phần tử khác trong cây DOM
- Hai hàm độc lập: preventDefault không chặn lan truyền, stopPropagation không chặn hành vi mặc định
- Ví dụ: chặn submit form để gửi bằng AJAX dùng preventDefault; click nút trong modal mà không muốn đóng modal dùng stopPropagation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0c2fef7c-457e-5fd9-aa5c-feb965acc218', 'Trước đây, vì sao người ta thường phục vụ tài nguyên của website từ nhiều domain khác nhau?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu giới hạn kết nối của trình duyệt với HTTP/1.1 -> giải thích domain sharding và cookie-free domain -> nhắc rằng với HTTP/2 kỹ thuật này không còn cần thiết.', '- Với HTTP/1.1, trình duyệt giới hạn số kết nối song song tới mỗi domain (khoảng 6)
- Chia tài nguyên ra nhiều domain (domain sharding) giúp tải song song nhiều file hơn
- Domain riêng cho tài nguyên tĩnh không gửi kèm cookie, giảm kích thước request
- Có thể tận dụng CDN đặt gần người dùng
- Với HTTP/2 và HTTP/3 (multiplexing trên một kết nối), sharding không còn lợi và còn tốn thêm DNS lookup, kết nối', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c458c6a4-67a6-5f68-9ab1-06636d1d6145', 'Bạn hãy mô tả chi tiết nhất có thể quá trình từ lúc gõ URL vào trình duyệt đến khi trang web hiển thị xong.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày theo trình tự: phân giải tên miền -> thiết lập kết nối -> gửi request và nhận response -> trình duyệt phân tích và render trang.', '- Trình duyệt phân tích URL, kiểm tra cache, rồi phân giải tên miền qua DNS để lấy địa chỉ IP
- Thiết lập kết nối TCP (bắt tay ba bước) và TLS handshake nếu là HTTPS
- Gửi HTTP request, server xử lý và trả về response (HTML, có thể kèm redirect, cache header)
- Trình duyệt phân tích HTML thành DOM, CSS thành CSSOM, tải thêm CSS/JS/ảnh, chạy JavaScript
- Kết hợp DOM và CSSOM thành render tree, tính layout, paint và composite để hiển thị lên màn hình', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('72cbd3a7-9904-5e0d-933a-0156b7c8f4ab', 'Long-polling, WebSocket và Server-Sent Events khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Mô tả cơ chế của từng kỹ thuật -> so sánh hướng truyền dữ liệu và chi phí -> nêu trường hợp nên dùng mỗi loại.', '- Long-polling: client gửi request, server giữ kết nối tới khi có dữ liệu mới rồi trả về, client lập tức gửi request mới
- WebSocket: một kết nối lâu dài, hai chiều (full-duplex) sau khi nâng cấp từ HTTP, độ trễ thấp
- Server-Sent Events: server đẩy dữ liệu một chiều tới client qua HTTP, trình duyệt tự kết nối lại
- Long-polling tốn tài nguyên vì liên tục mở request; SSE đơn giản, hợp thông báo/feed; WebSocket hợp chat, game, cộng tác thời gian thực', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4bff05a2-8a84-5007-9213-12e614fcf02f', 'HTTP method là gì? Bạn hãy kể các HTTP method mà bạn biết và giải thích từng loại.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa HTTP method -> liệt kê và giải thích các method phổ biến -> nhắc tới tính idempotent và safe.', '- HTTP method cho biết hành động client muốn thực hiện với tài nguyên trên server
- GET lấy dữ liệu; POST tạo mới hoặc gửi dữ liệu xử lý
- PUT thay thế toàn bộ tài nguyên; PATCH cập nhật một phần; DELETE xoá tài nguyên
- HEAD giống GET nhưng chỉ trả header; OPTIONS hỏi các method được hỗ trợ (dùng trong CORS preflight)
- GET, HEAD, OPTIONS là safe; GET, PUT, DELETE là idempotent, còn POST thì không', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('09043973-55b2-5de1-851e-e51efbe02941', 'DNS prefetching là gì và nó giúp cải thiện hiệu năng như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> giải thích chi phí DNS lookup -> nêu cách khai báo và các kỹ thuật liên quan như preconnect.', '- Là kỹ thuật yêu cầu trình duyệt phân giải tên miền trước khi trang thực sự cần tải tài nguyên từ domain đó
- DNS lookup có thể tốn hàng chục tới hàng trăm mili giây, làm trước giúp giảm độ trễ khi tải tài nguyên
- Khai báo bằng thẻ link rel="dns-prefetch" trỏ tới domain bên thứ ba (CDN, font, analytics)
- Có thể dùng preconnect để làm thêm cả bước kết nối TCP/TLS', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d945b3c8-ca70-588e-b74d-0b1f3205939c', 'CDN là gì và dùng CDN mang lại lợi ích gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa CDN -> giải thích cơ chế lưu đệm tại các máy chủ biên -> liệt kê lợi ích.', '- CDN (Content Delivery Network) là mạng lưới máy chủ phân tán ở nhiều vị trí địa lý, lưu bản sao nội dung tĩnh
- Người dùng được phục vụ từ máy chủ gần nhất, giảm độ trễ và tăng tốc tải trang
- Giảm tải cho máy chủ gốc và tiết kiệm băng thông
- Tăng khả năng chịu tải, sẵn sàng cao và hỗ trợ chống tấn công DDoS
- Thường kèm tính năng nén, HTTP/2, cache theo header', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a19b3867-aa1e-58ef-9d9e-a83ee4ce2452', 'Bạn dùng những công cụ nào để tìm lỗi hiệu năng trong code frontend?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Kể tên công cụ -> nói rõ mỗi công cụ dùng để phát hiện vấn đề gì -> mô tả quy trình đo, tìm nguyên nhân, sửa, đo lại.', '- Chrome DevTools: tab Performance để ghi lại và xem flame chart, long task, layout/paint
- Tab Network để xem thời gian tải, kích thước tài nguyên, request chặn render
- Lighthouse/PageSpeed Insights để đo Core Web Vitals (LCP, INP, CLS) và nhận gợi ý
- React DevTools Profiler để tìm component re-render thừa; tab Memory để phát hiện rò rỉ bộ nhớ
- Đo trước và sau khi sửa để xác nhận cải thiện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('107a0bfa-902b-5115-aa4a-2bb18d90fb8a', 'Có những cách nào để cải thiện hiệu năng khi cuộn trang (scroll) của website?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu nguyên nhân thường gây giật khi cuộn -> liệt kê các kỹ thuật khắc phục -> nhắc cách đo kiểm.', '- Tránh xử lý nặng trong sự kiện scroll: dùng debounce/throttle, requestAnimationFrame, passive event listener
- Dùng IntersectionObserver thay cho tính vị trí phần tử liên tục khi cuộn (lazy load, infinite scroll)
- Tránh gây layout thrashing (đọc rồi ghi kích thước DOM xen kẽ)
- Animate bằng transform và opacity để chạy trên compositor, hạn chế hiệu ứng tốn paint như box-shadow lớn
- Với danh sách dài, dùng virtualization chỉ render phần đang hiển thị', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b01eac7c-2bf3-5d1f-a4e5-57e50381dd71', 'Bạn hãy giải thích sự khác nhau giữa layout, paint và compositing trong quá trình render của trình duyệt.', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Mô tả lần lượt ba giai đoạn trong pipeline render -> giải thích thay đổi CSS nào kích hoạt giai đoạn nào -> rút ra cách tối ưu.', '- Layout (reflow): tính kích thước và vị trí của từng phần tử trên trang
- Paint: vẽ điểm ảnh cho từng phần tử (màu, chữ, viền, bóng) vào các layer
- Compositing: ghép các layer đã vẽ theo đúng thứ tự để hiển thị, thường do GPU đảm nhận
- Đổi width/top gây chạy lại cả layout, paint và composite; đổi màu chỉ cần paint và composite
- Đổi transform/opacity chỉ cần composite nên rẻ nhất, phù hợp cho animation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4afa7291-3700-5ebc-b736-22d5cc7143c8', 'Theo bạn, viết test cho code có những ưu điểm và nhược điểm gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê ưu điểm -> liệt kê nhược điểm, chi phí -> nêu quan điểm cân bằng của bản thân.', '- Ưu điểm: phát hiện lỗi sớm, giảm lỗi khi lên production
- Giúp tự tin refactor và thay đổi code mà không làm hỏng chức năng cũ
- Test đóng vai trò tài liệu mô tả hành vi mong muốn, khuyến khích thiết kế code dễ tách rời
- Nhược điểm: tốn thời gian viết và bảo trì, test sai hoặc dễ vỡ (flaky) gây mất thời gian
- Không đảm bảo hết lỗi; cần cân bằng độ bao phủ với chi phí', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3305ee4a-e033-5fbf-a40d-3d4a01ff0209', 'Bạn dùng những công cụ nào để kiểm thử chức năng của code frontend?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Phân theo cấp độ test -> kể công cụ tương ứng -> chia sẻ công cụ đã dùng trong dự án.', '- Unit test: Jest hoặc Vitest
- Test component: React Testing Library, kiểm tra theo hành vi người dùng
- End-to-end test: Cypress, Playwright
- Mock API bằng MSW hoặc mock của Jest
- Chạy tự động trong CI để kiểm tra mỗi lần push/PR', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bd3b9fc6-9006-502e-b76c-eb2abc2a78a3', 'Unit test và functional/integration test khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa từng loại -> so sánh phạm vi, tốc độ, mức độ phụ thuộc -> nhắc tới mô hình kim tự tháp kiểm thử.', '- Unit test kiểm tra một đơn vị nhỏ (hàm, component) một cách độc lập, phụ thuộc bên ngoài được mock
- Integration/functional test kiểm tra nhiều thành phần phối hợp với nhau hoặc một chức năng từ góc nhìn người dùng
- Unit test chạy nhanh, dễ chỉ ra vị trí lỗi; integration test chậm hơn nhưng phát hiện lỗi khi ghép nối
- Theo kim tự tháp kiểm thử: nhiều unit test, ít integration test, ít nhất là end-to-end test', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce4a562f-8566-59e9-b4c5-d25beeecc570', 'Công cụ lint kiểm tra code style dùng để làm gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa linter -> nêu lợi ích cho cá nhân và nhóm -> kể ví dụ công cụ và cách tích hợp.', '- Linter phân tích tĩnh mã nguồn để phát hiện lỗi tiềm ẩn và vi phạm quy ước code
- Giúp cả nhóm viết code thống nhất, dễ đọc, giảm tranh luận về style khi review
- Bắt sớm lỗi như biến không dùng, so sánh sai kiểu, thiếu dependency trong hook
- Ví dụ: ESLint cho lỗi và quy tắc, Prettier cho định dạng
- Tích hợp vào editor, pre-commit hook và CI', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eeeb0472-a47d-575b-bcfb-116b5c7f0bc0', 'Bạn hãy kể một số best practice khi viết test.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Liệt kê các nguyên tắc chính -> giải thích ngắn lý do -> lấy ví dụ từ kinh nghiệm.', '- Test hành vi thay vì chi tiết cài đặt, để refactor không làm vỡ test
- Mỗi test độc lập, có thể chạy theo thứ tự bất kỳ, không phụ thuộc trạng thái chung
- Đặt tên test rõ ràng, theo cấu trúc Arrange - Act - Assert
- Bao phủ cả trường hợp biên và trường hợp lỗi, không chỉ trường hợp thành công
- Test chạy nhanh, ổn định (tránh flaky), được chạy tự động trong CI', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34dea465-c740-553a-8412-1201aef163cc', 'Gần đây bạn đã làm dự án nào mà bạn thấy thú vị? Hãy kể về dự án đó.', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh dự án -> nhiệm vụ và vai trò của bạn -> cách bạn thực hiện, công nghệ dùng -> kết quả và điều học được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e5d2f1c4-5643-52fb-84ae-3de75eb40a7b', 'Bạn thích điều gì ở những công cụ phát triển mà bạn đang dùng?', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Nói về công cụ hiện tại -> lý do và trải nghiệm đã có với công cụ -> cách bạn muốn tiếp tục cải thiện quy trình làm việc.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7ca9161f-2773-5d58-a89b-f0399b9edf79', 'Trong cộng đồng frontend, ai là người truyền cảm hứng cho bạn?', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Nêu tên người hoặc nguồn bạn theo dõi -> điều cụ thể bạn học được từ họ -> ảnh hưởng tới định hướng của bạn.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('47d9f3bf-55dc-5938-b27c-54893e653c4b', 'Bạn có dự án cá nhân nào không? Đó là loại dự án gì?', 'IT', 'Chung', 'EASY', 'INTRO', 'Giới thiệu dự án hiện tại -> lý do bạn bắt đầu và những gì đã làm -> dự định phát triển tiếp.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e2b052f6-c083-5415-8788-ab4f7372deff', 'React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa React -> nêu các đặc điểm chính -> nói về ứng dụng thực tế.', '- React là thư viện JavaScript mã nguồn mở để xây dựng giao diện người dùng, do Facebook (Meta) phát triển
- Xây dựng UI theo mô hình component có thể tái sử dụng
- Quản lý state của component và tự cập nhật giao diện khi dữ liệu thay đổi (declarative UI)
- Dùng Virtual DOM để cập nhật DOM hiệu quả
- Chỉ lo phần view; dùng cho web, và cho mobile qua React Native', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6df6818b-a071-5bdb-82fe-7305d7bbdca9', 'Những tính năng chính của React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các tính năng chính -> giải thích ngắn từng tính năng -> nêu lợi ích khi làm dự án.', '- Kiến trúc component: chia UI thành các phần độc lập, tái sử dụng
- Virtual DOM: tính toán khác biệt và chỉ cập nhật phần DOM thay đổi
- JSX: cú pháp giống HTML trong JavaScript để mô tả UI
- Luồng dữ liệu một chiều từ cha xuống con qua props
- Hooks để dùng state và side effect trong function component; hệ sinh thái lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa6f8f1c-f122-57cd-aa41-8688d7a95a7c', 'JSX là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa JSX -> giải thích JSX được biên dịch thành gì -> nêu lợi ích và lưu ý khi viết.', '- JSX (JavaScript XML) là cú pháp mở rộng cho JavaScript, cho phép viết markup giống HTML trong code
- Là cú pháp gọn cho lời gọi React.createElement (hoặc hàm jsx của runtime mới)
- Cần được biên dịch (Babel, TypeScript, SWC) thành JavaScript thuần trước khi chạy
- Có thể nhúng biểu thức JavaScript trong dấu ngoặc nhọn
- Khác HTML ở vài điểm: dùng className, thuộc tính camelCase, phải đóng thẻ, chỉ trả về một phần tử gốc', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('88c8ab9d-89a2-5868-9a0d-0fe24b273abf', 'Element và Component trong React khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa từng khái niệm -> so sánh bản chất và vai trò -> nêu mối quan hệ giữa hai khái niệm.', '- Element là object JavaScript thuần mô tả những gì cần hiển thị (loại thẻ hoặc component, props, children)
- Element là bất biến và tạo rất nhẹ, không trực tiếp tạo DOM
- Component là hàm hoặc class nhận props và trả về element
- Component có thể có state, logic và tái sử dụng nhiều lần
- Nói gọn: component là bản thiết kế, element là kết quả component trả về tại một thời điểm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('15bfdc7f-8314-5d9c-ad67-02d1576712ca', 'Có những cách nào để tạo component trong React?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu hai cách tạo component -> so sánh ngắn -> nói cách nào được khuyến nghị hiện nay.', '- Function component: hàm JavaScript nhận props và trả về JSX
- Class component: class kế thừa React.Component, có phương thức render
- Từ khi có Hooks, function component dùng được state và side effect nên là cách được khuyến nghị
- Class component chủ yếu còn trong code cũ hoặc khi làm Error Boundary', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fbd6711a-0525-5757-afe8-95b7171f8c40', 'Khi nào nên dùng class component thay vì function component?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khuyến nghị chung hiện nay -> chỉ ra các trường hợp hiếm vẫn cần class -> giải thích vì sao Hooks thay đổi lựa chọn.', '- Từ React 16.8 có Hooks, function component làm được hầu hết mọi thứ nên được ưu tiên
- Class component vẫn cần cho Error Boundary (componentDidCatch, getDerivedStateFromError)
- Gặp class component khi bảo trì codebase cũ, không nhất thiết phải viết lại
- Function component ngắn gọn, dễ tái sử dụng logic qua custom hook hơn class', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa7af0c8-5534-5465-bf5c-977b87909f6b', 'Pure component trong React là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> nêu cách tạo với class và function component -> giải thích lợi ích hiệu năng và lưu ý so sánh nông.', '- Pure component luôn render cùng kết quả với cùng props và state
- Class component: kế thừa React.PureComponent, tự triển khai shouldComponentUpdate với so sánh nông
- Function component: bọc bằng React.memo để bỏ qua render khi props không đổi
- Giúp tránh re-render không cần thiết, tối ưu hiệu năng
- So sánh nông nên nếu truyền object/hàm mới mỗi lần render thì vẫn re-render, cần useMemo/useCallback', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('23735afa-4516-5080-99a3-2d9aa0547812', 'State trong React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa state -> giải thích cách cập nhật và cơ chế re-render -> ví dụ dùng useState.', '- State là dữ liệu nội bộ của component, có thể thay đổi trong vòng đời của component
- Khi state thay đổi, component được render lại để cập nhật giao diện
- Trong function component dùng hook useState, trả về giá trị hiện tại và hàm cập nhật
- Không sửa state trực tiếp, phải dùng hàm cập nhật; cập nhật có thể bất đồng bộ và được gộp
- Nên giữ state tối giản, chỉ lưu dữ liệu không tính được từ props hoặc state khác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1dbad85b-9238-5473-b2fc-b65b3229b7d1', 'Props trong React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa props -> giải thích luồng dữ liệu từ cha xuống con -> nêu các mục đích sử dụng.', '- Props là dữ liệu đầu vào của component, truyền từ component cha xuống con giống thuộc tính HTML
- Props là chỉ đọc, component con không được sửa props
- Dùng để truyền dữ liệu, cấu hình component và truyền hàm callback để con báo ngược lên cha
- Có prop đặc biệt children để truyền nội dung lồng bên trong
- Khi props thay đổi, component con được render lại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('33d68321-e768-513c-a855-5a2f232b4f3b', 'State và props khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'So sánh theo các tiêu chí: ai quản lý, có thay đổi được không, phạm vi -> ví dụ minh hoạ.', '- State do chính component quản lý, props do component cha truyền vào
- State thay đổi được qua hàm cập nhật; props là chỉ đọc với component nhận
- State là cục bộ của component; props dùng để giao tiếp giữa các component
- Cả hai thay đổi đều khiến component render lại
- State của cha thường được truyền xuống con dưới dạng props', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4d7e5d06-4fea-506a-9696-135a89841276', 'Xử lý sự kiện trong React khác với trong HTML như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các điểm khác biệt về cách đặt tên, cách truyền handler, cách ngăn hành vi mặc định.', '- Tên sự kiện trong React viết kiểu camelCase (onClick) thay vì chữ thường (onclick)
- React truyền vào một hàm, HTML truyền vào chuỗi code
- Trong React không thể return false để chặn hành vi mặc định, phải gọi preventDefault
- React dùng SyntheticEvent bọc sự kiện gốc để hoạt động nhất quán giữa các trình duyệt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8c3ba5c9-7464-548d-8de0-0132a7b699b9', 'Synthetic event trong React là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> giải thích lý do React dùng synthetic event -> nêu cách truy cập sự kiện gốc.', '- SyntheticEvent là lớp bọc của React quanh sự kiện gốc của trình duyệt
- Có cùng API với sự kiện gốc (preventDefault, stopPropagation, target)
- Đảm bảo sự kiện hoạt động nhất quán trên mọi trình duyệt
- Có thể truy cập sự kiện gốc qua thuộc tính nativeEvent
- React gắn listener ở root (event delegation) thay vì từng phần tử', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3207008f-a6ed-5d30-b08f-7425741fcad3', 'Trong React, có những cách nào để render có điều kiện ngay trong JSX?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các cách -> nêu khi nào dùng cách nào -> nhắc bẫy thường gặp.', '- Dùng toán tử ba ngôi (điều kiện ? A : B) khi có hai nhánh hiển thị
- Dùng toán tử && khi chỉ hiển thị nếu điều kiện đúng
- Dùng if/else hoặc biến trung gian bên ngoài JSX khi logic phức tạp, hoặc return sớm
- Bẫy với &&: nếu vế trái là số 0 thì sẽ hiển thị số 0, nên ép về boolean', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9768c260-f8ed-54f6-ba14-2e01468d936e', 'Prop key là gì và vì sao cần dùng key khi render danh sách phần tử?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa key -> giải thích vai trò trong reconciliation -> nêu cách chọn key đúng và hậu quả khi dùng index.', '- key là thuộc tính đặc biệt giúp React nhận diện từng phần tử trong danh sách
- Giúp React biết phần tử nào được thêm, xoá, thay đổi để cập nhật DOM hiệu quả
- key phải duy nhất giữa các phần tử anh em và ổn định, thường dùng id từ dữ liệu
- Dùng index làm key chỉ khi danh sách không đổi thứ tự; nếu không dễ gây lỗi state và hiệu năng kém
- Thiếu key thì React cảnh báo', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a92fddee-cae8-56ac-bdda-c5d703097349', 'Virtual DOM là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa Virtual DOM -> giải thích lý do cần nó -> mô tả ngắn cách React dùng để cập nhật DOM thật.', '- Virtual DOM là bản biểu diễn nhẹ của DOM thật dưới dạng object JavaScript, lưu trong bộ nhớ
- Thao tác trực tiếp với DOM thật tốn kém vì có thể gây tính lại layout và vẽ lại
- Khi state thay đổi, React tạo cây Virtual DOM mới và so sánh (diffing) với cây cũ
- Chỉ những thay đổi cần thiết được áp vào DOM thật theo lô
- Giúp lập trình viên viết UI theo kiểu khai báo mà vẫn đạt hiệu năng tốt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('82c14627-9187-57de-a354-b01aa4fa888f', 'Virtual DOM hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày theo các bước: render lần đầu -> state thay đổi tạo cây mới -> so sánh -> cập nhật DOM thật.', '- Lần render đầu, React tạo cây Virtual DOM từ JSX và dựng DOM thật tương ứng
- Khi state hoặc props thay đổi, component render lại và tạo cây Virtual DOM mới
- React so sánh cây mới với cây cũ (diffing), dựa trên giả định phần tử khác loại thì thay cả cây con và dùng key cho danh sách
- Tính ra tập thay đổi tối thiểu và áp vào DOM thật (commit) theo lô
- Quá trình này gọi là reconciliation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34eeef6a-928f-5134-9a31-851d87dba62b', 'Shadow DOM và Virtual DOM khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa từng khái niệm -> so sánh mục đích và nơi hiện thực -> kết luận chúng giải quyết hai bài toán khác nhau.', '- Shadow DOM là công nghệ của trình duyệt, dùng để đóng gói DOM và CSS trong web component
- Virtual DOM là khái niệm do thư viện JavaScript (như React) hiện thực, nằm trên các API của trình duyệt
- Shadow DOM giải quyết bài toán cô lập style và cấu trúc, tránh xung đột CSS
- Virtual DOM giải quyết bài toán cập nhật giao diện hiệu quả
- Hai khái niệm độc lập và có thể dùng cùng nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f765c0ee-cbc1-53ba-ab8a-183c403dfef1', 'React Fiber là gì?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa Fiber -> so sánh với thuật toán cũ dựa trên stack -> nêu các khả năng mới mà Fiber mang lại.', '- React Fiber là engine reconciliation mới được viết lại từ React 16
- Thay thế thuật toán cũ dựa trên đệ quy (stack), vốn phải render liền một mạch không dừng được
- Chia công việc render thành các đơn vị nhỏ (fiber) có thể tạm dừng, tiếp tục hoặc huỷ
- Cho phép gán độ ưu tiên cho cập nhật, ưu tiên tương tác người dùng hơn công việc nền
- Là nền tảng cho concurrent rendering, Suspense, transitions', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d41ffb6b-56f5-5093-827a-612918ae8511', 'Mục tiêu chính của React Fiber là gì?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu vấn đề của cách render cũ -> trình bày incremental rendering -> liệt kê các mục tiêu đi kèm.', '- Mục tiêu chính là incremental rendering: chia nhỏ việc render và rải ra nhiều frame
- Có thể tạm dừng, huỷ hoặc dùng lại công việc render khi có cập nhật mới
- Gán độ ưu tiên cho các loại cập nhật khác nhau
- Giúp giao diện mượt hơn với animation, layout, cử chỉ, tránh khoá luồng chính lâu
- Hỗ trợ trả về nhiều phần tử (fragment) và error boundary', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('297767fc-4384-5a19-b009-8e9aa7555a1a', 'Controlled component là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> mô tả cách hoạt động với value và onChange -> nêu ưu điểm.', '- Controlled component là phần tử form (input, textarea, select) có giá trị do state của React quản lý
- Giá trị được truyền qua prop value, mỗi thay đổi được xử lý qua onChange để cập nhật state
- React state là nguồn dữ liệu duy nhất (single source of truth)
- Dễ validate tức thời, định dạng dữ liệu nhập, bật tắt nút submit theo dữ liệu
- Nhược điểm: render lại theo mỗi lần gõ, nhiều code hơn với form lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d0989628-0f15-578a-a937-d1803b09f9d2', 'Uncontrolled component là gì? Khi nào nên dùng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> mô tả cách lấy giá trị qua ref -> so sánh với controlled component và nêu trường hợp dùng.', '- Uncontrolled component là phần tử form tự quản lý giá trị trong DOM, không qua React state
- Lấy giá trị khi cần bằng ref (useRef), có thể đặt giá trị ban đầu bằng defaultValue
- Ít code hơn, không render lại mỗi lần gõ
- Phù hợp với form đơn giản, input file, hoặc tích hợp thư viện không dùng React
- Khó validate tức thời và đồng bộ với phần khác của UI hơn controlled component', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('abdbf7bc-43e0-58ab-92da-5298af81dd94', 'Lifting state up trong React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> nêu tình huống cần dùng -> mô tả cách truyền dữ liệu và callback xuống các component con.', '- Khi nhiều component cần dùng chung một dữ liệu thay đổi, chuyển state lên component cha chung gần nhất
- Component cha giữ state và truyền xuống con qua props
- Con cập nhật dữ liệu bằng cách gọi callback được cha truyền xuống
- Đảm bảo một nguồn dữ liệu duy nhất, các component luôn đồng bộ
- Nếu phải truyền qua quá nhiều tầng thì cân nhắc Context hoặc thư viện quản lý state', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b4a2482-5861-5657-9ff0-0da1fb5b8c9c', 'Higher-Order Component (HOC) là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa HOC -> nêu mục đích và ví dụ sử dụng -> so sánh với custom hook hiện nay.', '- HOC là hàm nhận vào một component và trả về một component mới được bổ sung props, hành vi hoặc dữ liệu
- Dùng để tái sử dụng logic giữa nhiều component mà không sửa component gốc
- Ví dụ: withRouter, connect của Redux, HOC kiểm tra đăng nhập
- Nhược điểm: lồng nhiều tầng (wrapper hell), dễ trùng tên props
- Hiện nay phần lớn trường hợp có thể thay bằng custom hook', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac71b100-90cc-551a-87c9-a0a9d366870a', 'Prop children trong React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> mô tả cách truyền -> ví dụ component layout hoặc wrapper.', '- children là prop đặc biệt chứa nội dung nằm giữa thẻ mở và thẻ đóng của component
- Có thể là text, element, mảng element hoặc thậm chí là hàm
- Thường dùng cho component bố cục và bao bọc như Card, Modal, Layout
- Giúp tạo component linh hoạt theo hướng composition thay vì kế thừa', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3f86299-2658-5659-8f0d-f6f0bcbb8935', 'Reconciliation trong React là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> giải thích thuật toán diffing và các giả định của nó -> nhắc vai trò của key.', '- Reconciliation là quá trình React so sánh cây element mới với cây cũ để quyết định cập nhật DOM thế nào
- Dùng thuật toán diffing độ phức tạp O(n) dựa trên các giả định heuristic
- Phần tử khác loại thì huỷ cây con cũ và tạo mới; cùng loại thì giữ và chỉ cập nhật thuộc tính
- Với danh sách, React dùng key để nhận diện phần tử
- Kết quả là chỉ những thay đổi tối thiểu được áp vào DOM thật', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8c7cd8c7-de2a-5234-befb-8c4060ef1232', 'Vì sao React dùng thuộc tính className thay cho class?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích xung đột từ khoá -> nhắc JSX được biên dịch thành JavaScript -> liên hệ với thuộc tính DOM.', '- class là từ khoá dành riêng trong JavaScript (dùng để khai báo class)
- JSX được biên dịch thành JavaScript nên tránh dùng từ khoá này làm tên thuộc tính
- className cũng trùng với tên thuộc tính trong DOM API (element.className)
- Tương tự, React dùng htmlFor thay cho for', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3739f7c1-bb0e-551a-8960-ccdee38bbf04', 'Fragment trong React là gì? Vì sao nên dùng fragment thay cho thẻ div bao ngoài?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa fragment -> nêu cú pháp -> trình bày lợi ích so với div bao ngoài.', '- Fragment cho phép component trả về nhiều phần tử mà không thêm node thừa vào DOM
- Cú pháp Fragment hoặc dạng rút gọn thẻ rỗng; dùng Fragment đầy đủ khi cần truyền key
- Không làm hỏng bố cục CSS như flexbox, grid hay cấu trúc table vốn yêu cầu quan hệ cha con trực tiếp
- DOM gọn hơn, tiết kiệm bộ nhớ chút ít với cây lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('60b6496b-8ade-5a72-836d-63f28c331e13', 'Portal trong React là gì? Khi nào nên dùng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa portal -> nêu vấn đề nó giải quyết -> ví dụ trường hợp sử dụng và lưu ý về event.', '- Portal cho phép render component con vào một node DOM nằm ngoài cây DOM của component cha (createPortal)
- Vẫn giữ nguyên quan hệ trong cây component React: context và event bubbling vẫn đi theo cây React
- Giải quyết vấn đề overflow hidden, z-index, stacking context của phần tử cha
- Thường dùng cho modal, tooltip, dropdown, thông báo', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a9cf39ee-75e3-5826-bd55-e1b859d0fbc8', 'Stateless component và stateful component khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa hai loại -> ví dụ -> nêu cách phối hợp giữa chúng trong ứng dụng.', '- Stateless component không có state riêng, chỉ hiển thị dựa trên props
- Stateful component có state riêng (useState hoặc this.state) và thay đổi giao diện khi state đổi
- Stateless dễ test, dễ tái sử dụng, dễ dự đoán
- Thường tách component chứa logic, state (container) với component chỉ hiển thị (presentational)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4c05dfe3-b3a9-50b0-b2cc-7ce4539ddc77', 'React có những ưu điểm gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các ưu điểm chính -> giải thích ngắn gọn -> liên hệ trải nghiệm thực tế.', '- Hiệu năng tốt nhờ Virtual DOM và cơ chế cập nhật tối ưu
- Kiến trúc component giúp tái sử dụng và bảo trì code
- JSX dễ đọc, kết hợp logic và giao diện
- Hỗ trợ render phía server (SSR) và nhiều framework như Next.js
- Hệ sinh thái và cộng đồng lớn, có React Native cho mobile', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eda2e3bd-089c-545a-a65c-65c4a45434a4', 'React có những hạn chế gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các hạn chế -> giải thích ngắn -> nêu cách khắc phục thường dùng.', '- React chỉ là thư viện cho tầng view, không phải framework đầy đủ, phải tự chọn router, quản lý state, gọi API
- Có đường cong học tập với người mới (JSX, hooks, tư duy component)
- Hệ sinh thái thay đổi nhanh, nhiều lựa chọn khiến khó thống nhất
- Ứng dụng client-side rendering thuần có thể kém SEO và tải lần đầu chậm, cần SSR
- Cần chú ý tối ưu re-render khi ứng dụng lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('919c5245-b4a1-5088-8e2a-f422e9d68a74', 'Bạn kiểm tra kiểu dữ liệu (type checking) trong ứng dụng React như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu lựa chọn khuyến nghị hiện nay -> so sánh kiểm tra tĩnh với kiểm tra lúc chạy -> chia sẻ cách áp dụng trong dự án.', '- TypeScript là lựa chọn chuẩn hiện nay để kiểm tra kiểu tĩnh trong React
- Kiểm tra kiểu lúc biên dịch, phát hiện lỗi trước khi chạy, hỗ trợ gợi ý code trong editor
- Định nghĩa kiểu cho props, state, hook, dữ liệu API
- PropTypes chỉ kiểm tra lúc chạy ở môi trường dev và đã bị loại khỏi React 19
- Có thể kết hợp thư viện validate lúc chạy (như Zod) cho dữ liệu từ bên ngoài', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9c344832-da22-536a-a3fc-8bcc6bfcae79', 'Làm thế nào để chèn HTML thô vào component React? Cần lưu ý gì về bảo mật?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu cách làm trong React -> giải thích rủi ro XSS -> đưa ra biện pháp an toàn.', '- React dùng thuộc tính dangerouslySetInnerHTML thay cho innerHTML, truyền object có khoá __html
- Tên thuộc tính cố ý cảnh báo vì có nguy cơ tấn công XSS khi chèn nội dung không tin cậy
- Mặc định React tự escape nội dung text nên an toàn hơn
- Nếu buộc phải dùng, cần làm sạch HTML trước (ví dụ thư viện DOMPurify)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b8bbd25d-7ece-5566-9499-e431fa2f1c1c', 'Có những cách nào để style component trong React?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các cách -> nêu ưu nhược điểm ngắn -> chia sẻ cách bạn hay dùng.', '- Inline style: thuộc tính style nhận object JavaScript với tên thuộc tính camelCase
- File CSS thông thường hoặc CSS Modules để giới hạn phạm vi class
- CSS-in-JS như styled-components, Emotion
- Utility-first CSS như Tailwind CSS
- Inline style không hỗ trợ pseudo-class, media query nên chỉ hợp với style động đơn giản', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('be6d489c-1a93-5e76-a44f-cbc409959213', 'Dùng index của mảng làm key có ảnh hưởng gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích yêu cầu với key -> mô tả vấn đề khi danh sách thay đổi thứ tự -> nêu khi nào dùng index vẫn chấp nhận được.', '- key cần ổn định, dự đoán được và duy nhất để React theo dõi đúng phần tử
- Index gắn với vị trí chứ không gắn với dữ liệu; khi thêm, xoá, sắp xếp thì key của phần tử bị đổi
- Hậu quả: React render lại thừa và có thể gán nhầm state của component/input sang phần tử khác
- Chỉ nên dùng index khi danh sách tĩnh, không đổi thứ tự và không có id ổn định', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ebeb6bc4-4af2-52d6-bbf5-ff63c47ed206', 'Vì sao cần cẩn thận khi spread toàn bộ props vào phần tử DOM?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu rủi ro -> giải thích hậu quả -> đưa ra cách làm an toàn.', '- Spread toàn bộ props có thể đưa các thuộc tính không hợp lệ hoặc không mong muốn xuống DOM
- Gây cảnh báo của React, HTML không hợp lệ hoặc vô tình ghi đè thuộc tính quan trọng
- Có thể lộ dữ liệu nội bộ hoặc gắn handler ngoài ý muốn
- Nên destructure lấy các props cần xử lý, chỉ spread phần còn lại (rest) đã biết là hợp lệ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eaa2f248-85ab-548a-b485-bfe81e726b95', 'Làm thế nào để memoize một component trong React?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu công cụ React cung cấp -> giải thích cơ chế so sánh props -> nói khi nào nên và không nên dùng.', '- Bọc function component bằng React.memo để bỏ qua render khi props không đổi (so sánh nông)
- Có thể truyền hàm so sánh tuỳ chỉnh làm tham số thứ hai
- Kết hợp useCallback, useMemo để giữ tham chiếu ổn định cho hàm và object truyền xuống
- Chỉ nên dùng khi component render tốn kém và hay nhận props giống nhau, vì so sánh cũng có chi phí
- React Compiler có thể tự động memoize trong các phiên bản mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a91df9a4-5849-5a18-b592-d682614d5a20', 'Server-side rendering (SSR) trong React là gì và bạn triển khai nó như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa SSR -> mô tả luồng render trên server và hydrate ở client -> nêu công cụ và đánh đổi.', '- SSR là render component thành HTML trên server rồi gửi về trình duyệt
- React cung cấp API phía server như renderToString hoặc renderToPipeableStream (streaming)
- Ở client, React hydrate HTML có sẵn (hydrateRoot) để gắn sự kiện và tiếp tục tương tác
- Lợi ích: hiển thị nội dung đầu nhanh hơn, tốt cho SEO
- Thực tế thường dùng framework như Next.js hoặc Remix; đánh đổi là tăng tải server và độ phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7d32860d-4414-57f1-a546-831373d39cba', 'Hooks có thay thế được render props và higher-order component không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu mục đích chung của ba kỹ thuật -> so sánh ưu điểm của hooks -> nói các trường hợp HOC/render props vẫn hữu ích.', '- Cả ba đều nhằm tái sử dụng logic giữa các component
- Trong đa số trường hợp, custom hook là cách đơn giản hơn, không làm lồng thêm tầng component
- Hooks tránh wrapper hell và xung đột tên props của HOC
- Render props và HOC vẫn còn chỗ dùng, ví dụ khi cần điều khiển việc render hoặc với class component
- Không bắt buộc viết lại code cũ dùng HOC/render props', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7229e946-b6a3-505a-8d2f-e6ac82441d21', 'Vì sao tên component trong React phải bắt đầu bằng chữ hoa?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích cách JSX phân biệt thẻ HTML và component -> nêu hậu quả nếu viết thường.', '- JSX dùng chữ cái đầu để phân biệt: chữ thường là thẻ HTML/SVG, chữ hoa là component
- Tên viết thường được biên dịch thành chuỗi tên thẻ, viết hoa được biên dịch thành tham chiếu tới biến component
- Nếu viết thường, React coi đó là thẻ HTML không xác định và không render component
- Quy ước cũng giúp code dễ đọc hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('953140aa-6a63-561d-b760-f34e9bbef428', 'Package react và react-dom khác nhau như thế nào? Vì sao React tách chúng ra?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu vai trò từng package -> giải thích lý do tách -> ví dụ các renderer khác ngoài DOM.', '- react chứa phần lõi không phụ thuộc môi trường: tạo element, component, hooks, context
- react-dom chứa phần gắn với DOM của trình duyệt: createRoot, hydrateRoot, createPortal, và API render phía server
- Tách ra để cùng một lõi React dùng được với nhiều môi trường (renderer) khác nhau
- Ví dụ renderer khác: React Native cho mobile, react-three-fiber cho 3D, renderer cho terminal', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a4acf544-52c0-5b22-b3f1-1ecf79c9d2c0', 'Làm sao để component React cập nhật lại khi người dùng thay đổi kích thước cửa sổ trình duyệt? Cần lưu ý gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Mô tả cách lưu kích thước vào state và lắng nghe sự kiện -> nhấn mạnh việc dọn dẹp listener -> nêu cách tối ưu.', '- Lưu kích thước cửa sổ trong state (useState)
- Trong useEffect, đăng ký listener cho sự kiện resize để cập nhật state
- Bắt buộc gỡ listener trong hàm cleanup của useEffect để tránh rò rỉ bộ nhớ
- Nên debounce/throttle vì sự kiện resize bắn liên tục
- Nếu chỉ cần thay đổi giao diện, ưu tiên CSS media query hoặc ResizeObserver cho từng phần tử', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('312adfbb-2764-5b10-b889-7d418b01babe', 'Tại sao component không được tự sửa props của nó?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu nguyên tắc props bất biến -> giải thích luồng dữ liệu một chiều -> nêu cách đúng để thay đổi dữ liệu.', '- Theo triết lý của React, props là bất biến (chỉ đọc) và đi từ trên xuống
- Component cha sở hữu dữ liệu, con sửa props sẽ làm dữ liệu không đồng bộ và khó dự đoán
- Luồng dữ liệu một chiều giúp dễ theo dõi và debug
- Muốn thay đổi, con gọi callback do cha truyền xuống để cha cập nhật state, hoặc dùng state riêng của con', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('db3a3ef7-f051-549a-bd61-2e0870a676aa', 'Bạn gọi API bất đồng bộ (async/await) trong component React như thế nào? Cần chú ý những gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Mô tả cách gọi trong useEffect -> nêu cách xử lý trạng thái loading, lỗi -> nhắc các vấn đề như race condition, huỷ request.', '- Không truyền trực tiếp hàm async cho useEffect; khai báo hàm async bên trong rồi gọi nó
- Quản lý các trạng thái loading, dữ liệu, lỗi bằng state
- Huỷ request hoặc bỏ qua kết quả cũ khi component unmount hoặc tham số đổi (AbortController, cờ ignore) để tránh race condition
- Bắt lỗi bằng try/catch và hiển thị cho người dùng
- Trong dự án thực tế thường dùng thư viện như React Query/SWR để lo cache, retry, đồng bộ dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d1717be7-3e47-50b0-9341-2017daa74c02', 'Bạn thường tổ chức cấu trúc thư mục cho một dự án React như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giới thiệu các cách tổ chức phổ biến -> so sánh ưu nhược -> chia sẻ cách bạn đã dùng và lý do.', '- Nhóm theo loại file: components, pages, hooks, services, utils; đơn giản, hợp dự án nhỏ
- Nhóm theo tính năng hoặc route: mỗi tính năng chứa component, hook, API, test của riêng nó; dễ mở rộng cho dự án lớn
- Tách phần dùng chung (UI components, utils) khỏi phần theo tính năng
- Tránh lồng thư mục quá sâu, đặt tên nhất quán, dùng alias import
- Không có chuẩn bắt buộc, quan trọng là cả nhóm thống nhất', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('020b3746-6b7e-5a8c-959c-de417e9fa2f4', 'React Router là gì và nó giúp gì cho ứng dụng React?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> giải thích routing phía client trong SPA -> kể các tính năng chính.', '- React Router là thư viện định tuyến phổ biến cho ứng dụng React
- Cho phép điều hướng giữa các trang trong SPA mà không tải lại toàn bộ trang, đồng bộ giao diện với URL
- Hỗ trợ route lồng nhau, tham số động trên URL, query string
- Có hook điều hướng bằng code (useNavigate) và đọc tham số (useParams)
- Các phiên bản mới hỗ trợ tải dữ liệu theo route (loader, action) và lazy load', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bd47bc90-4750-5dd1-9953-02b40c3ea4b3', 'Khi điều hướng trong ứng dụng web, push và replace khác nhau như thế nào? Khi nào dùng replace?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích ngăn xếp lịch sử trình duyệt -> so sánh hai thao tác -> ví dụ tình huống dùng replace.', '- Trình duyệt lưu lịch sử điều hướng như một ngăn xếp
- push thêm một mục mới vào lịch sử, người dùng bấm Back sẽ quay lại trang trước
- replace thay thế mục hiện tại, không tạo mục mới
- Dùng replace khi không muốn người dùng quay lại trang cũ, ví dụ sau đăng nhập hoặc redirect từ trang không hợp lệ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('df4bfff0-2654-55bc-b15f-c9d30f8525dc', 'Trong ứng dụng React, bạn bảo vệ các trang yêu cầu đăng nhập và chuyển hướng người dùng sau khi đăng nhập như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Mô tả cách kiểm tra trạng thái đăng nhập -> trình bày mẫu protected route -> nêu cách đưa người dùng về đúng trang sau khi đăng nhập.', '- Lưu trạng thái xác thực (token, thông tin user) trong context hoặc store
- Tạo component bảo vệ route: chưa đăng nhập thì chuyển hướng tới trang login (Navigate với replace)
- Lưu lại đường dẫn người dùng định vào để sau khi đăng nhập điều hướng về đúng trang đó
- Kiểm tra phía client chỉ để trải nghiệm; quyền truy cập thật phải được backend kiểm tra', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ebd115f8-524b-5ea7-9e88-e1427809f9eb', 'Bạn làm đa ngôn ngữ (i18n) cho ứng dụng React như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu thư viện thường dùng -> mô tả cách tổ chức file dịch và chuyển ngôn ngữ -> nhắc định dạng ngày, số, số nhiều theo locale.', '- Dùng thư viện như react-i18next hoặc React Intl (FormatJS)
- Tách chuỗi hiển thị ra file dịch theo từng ngôn ngữ, truy cập qua khoá
- Cung cấp ngôn ngữ hiện tại qua context/provider, cho phép người dùng chuyển và lưu lựa chọn
- Định dạng ngày giờ, số, tiền tệ, số nhiều theo locale (Intl API)
- Có thể lazy load file dịch để giảm dung lượng tải ban đầu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f205f059-8a62-5223-8d40-bb4efb87770e', 'Jest là gì? Bạn dùng Jest để kiểm thử ứng dụng React như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa Jest -> nêu các tính năng chính -> mô tả cách kết hợp với thư viện test component.', '- Jest là framework kiểm thử JavaScript do Facebook (Meta) phát triển
- Tích hợp sẵn test runner, thư viện assertion, mock, đo độ bao phủ code
- Cung cấp môi trường jsdom để giả lập DOM khi test component
- Thường kết hợp với React Testing Library để render component và tương tác như người dùng
- Hỗ trợ snapshot test và chạy ở chế độ watch', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7507fd6e-05e5-5657-bea2-0708174cea54', 'Redux là gì? Khi nào nên dùng Redux?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa Redux -> mô tả luồng dữ liệu action, reducer, store -> nêu khi nào nên và không nên dùng.', '- Redux là thư viện quản lý state tập trung, có thể dự đoán được, thường dùng với React
- Toàn bộ state chung lưu trong một store; muốn đổi state phải dispatch action
- Reducer là hàm thuần nhận state cũ và action, trả về state mới
- Phù hợp với ứng dụng lớn, nhiều state dùng chung giữa nhiều nơi, cần debug/theo dõi thay đổi
- Ứng dụng nhỏ có thể chỉ cần useState/Context; hiện nay nên dùng Redux Toolkit để giảm boilerplate', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fbef8489-b270-531a-82ba-cb091d53b8d4', 'Redux dựa trên những nguyên tắc cốt lõi nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu ba nguyên tắc -> giải thích từng nguyên tắc -> nêu lợi ích chúng mang lại.', '- Single source of truth: toàn bộ state chung nằm trong một store duy nhất
- State là chỉ đọc: cách duy nhất để thay đổi là dispatch một action mô tả điều đã xảy ra
- Thay đổi bằng hàm thuần: reducer nhận state cũ và action, trả về state mới mà không sửa trực tiếp
- Nhờ đó dễ dự đoán, dễ debug, hỗ trợ time-travel debugging và test reducer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c2ffb564-f6ae-5876-8f53-f81247ec5050', 'Có nên dispatch action bên trong reducer của Redux không? Vì sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Đưa ra câu trả lời -> giải thích yêu cầu reducer là hàm thuần -> nêu nơi đúng để xử lý side effect.', '- Không nên, dispatch trong reducer là anti-pattern và Redux sẽ báo lỗi
- Reducer phải là hàm thuần: chỉ tính state mới từ state cũ và action, không có side effect
- Dispatch trong reducer gây cập nhật lồng nhau, khó dự đoán và khó debug
- Side effect và chuỗi action nên đặt trong middleware (thunk, saga, listener) hoặc trong component', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1b68dee9-7f8d-5e05-8e10-07bee4dc2998', 'React Context và Redux khác nhau như thế nào? Khi nào bạn chọn cái nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu mục đích của từng công cụ -> so sánh về hiệu năng, công cụ hỗ trợ, độ phức tạp -> đưa ra tiêu chí lựa chọn.', '- Context là cơ chế có sẵn của React để truyền dữ liệu xuống cây component mà không phải truyền props qua nhiều tầng
- Redux là thư viện quản lý state đầy đủ: store, action, reducer, middleware, DevTools
- Context làm mọi component dùng nó render lại khi giá trị đổi; Redux cho phép chọn từng phần state bằng selector nên tối ưu hơn
- Context hợp với dữ liệu ít thay đổi như theme, ngôn ngữ, user đăng nhập
- Redux hợp với state phức tạp, cập nhật thường xuyên, nhiều nơi dùng chung, cần debug', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6e4463f3-ca7c-5124-9e69-75c1a4821401', 'Trong Redux, bạn xử lý các tác vụ bất đồng bộ như gọi API như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích vì sao reducer không làm được -> trình bày vai trò middleware -> kể các lựa chọn phổ biến.', '- Reducer phải thuần nên không gọi API trong reducer
- Dùng middleware xử lý side effect, phổ biến nhất là redux-thunk: action creator trả về hàm nhận dispatch
- Thường dispatch các action pending, fulfilled, rejected để cập nhật trạng thái loading và lỗi
- Redux Toolkit có createAsyncThunk giúp viết gọn, hoặc RTK Query để fetch và cache dữ liệu
- Với luồng phức tạp có thể dùng redux-saga', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('79ecd993-a978-511b-9867-3b30ec8a4331', 'Có nên đưa toàn bộ state của component vào Redux store không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Đưa ra quan điểm -> phân loại state nào nên để global, state nào để local -> nêu hậu quả của việc đưa hết vào store.', '- Không nên, chỉ đưa vào store những state dùng chung hoặc cần tồn tại lâu dài
- Dữ liệu dùng ở nhiều nơi, dữ liệu từ server, trạng thái đăng nhập phù hợp để trong store
- State chỉ liên quan tới giao diện của một component (mở dropdown, giá trị input tạm) nên để local
- Đưa hết vào store làm code dài dòng, khó bảo trì và có thể làm render lại nhiều hơn
- Có thể dùng thư viện riêng cho dữ liệu server như React Query', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a19580db-5d33-55aa-b62f-4dfa76248384', 'redux-thunk và redux-saga khác nhau như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Giới thiệu mục đích chung -> so sánh cơ chế hoạt động -> nêu khi nào nên dùng từng thư viện.', '- Cả hai là middleware xử lý side effect (bất đồng bộ) trong Redux
- redux-thunk cho phép action creator trả về hàm nhận dispatch và getState, đơn giản, dễ học
- redux-saga dùng generator function, mô tả side effect dưới dạng effect (call, put, take)
- Saga mạnh hơn với luồng phức tạp: huỷ tác vụ, debounce, chạy song song, lắng nghe chuỗi action; dễ test vì effect là object thuần
- Thunk hợp với đa số ứng dụng; saga hợp khi luồng bất đồng bộ phức tạp nhưng đổi lại phức tạp hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b4352503-10c1-518e-a326-a6dda9baacf9', 'Selector trong Redux là gì và tại sao nên dùng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa selector -> nêu lợi ích -> giải thích memoized selector (Reselect).', '- Selector là hàm nhận state của Redux và trả về một phần dữ liệu hoặc dữ liệu được tính từ state
- Đóng gói cách truy cập state, khi cấu trúc state đổi chỉ cần sửa selector
- Giúp tái sử dụng logic tính toán và dễ test
- Memoized selector (Reselect, createSelector) chỉ tính lại khi đầu vào đổi, tránh tính toán và render thừa
- Dùng với hook useSelector trong component', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a0742efb-3120-5c5c-b5de-b6f035a33995', 'React và React Native khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa từng công nghệ -> so sánh nền tảng, cách render, cách style -> nêu điểm chung.', '- React là thư viện xây dựng giao diện web, render ra DOM của trình duyệt
- React Native là framework xây dựng ứng dụng mobile (iOS, Android), render ra component giao diện native
- React Native dùng component riêng (View, Text) thay cho thẻ HTML, style bằng object JavaScript theo flexbox
- Cả hai dùng chung tư duy component, JSX, state, props, hooks
- Có thể chia sẻ một phần logic giữa web và mobile', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('56c3ac6a-3448-5446-89e5-78c90f708c22', 'React Developer Tools là gì? Bạn dùng nó để debug ứng dụng như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giới thiệu công cụ -> mô tả các tab chính -> lấy ví dụ một lần dùng nó để tìm lỗi.', '- Là tiện ích mở rộng của trình duyệt để kiểm tra ứng dụng React
- Tab Components: xem cây component, props, state, hooks và sửa trực tiếp để thử
- Tab Profiler: ghi lại các lần render, xem component nào render bao lâu và vì sao render
- Có thể bật làm nổi bật component khi render lại để phát hiện render thừa
- Kết hợp với DevTools của trình duyệt (Console, Network) khi debug', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('31816bfd-25f8-5fab-bf2b-a8218999e3b4', 'Theo bạn, React có những ưu điểm và hạn chế gì so với Vue.js?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh theo vài tiêu chí rõ ràng (cách viết, hệ sinh thái, độ linh hoạt, đường cong học tập) -> nêu quan điểm và bối cảnh lựa chọn.', '- React linh hoạt, chỉ lo tầng view, tự chọn thư viện đi kèm; Vue cung cấp sẵn nhiều thứ chính thức (router, store) hơn
- React dùng JSX, mọi thứ là JavaScript; Vue dùng template gần HTML, dễ tiếp cận với người mới
- React có hệ sinh thái, cộng đồng và thị trường việc làm lớn hơn, có React Native cho mobile
- Vue có hệ thống reactivity tự theo dõi phụ thuộc, React cập nhật theo state và cần chú ý tối ưu render
- Lựa chọn tuỳ theo đội ngũ, quy mô dự án và hệ sinh thái cần dùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('42e517c8-b3e1-50bb-bacd-e8af1e6c7c7c', 'React và Angular khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh theo các tiêu chí: bản chất (thư viện hay framework), ngôn ngữ, data binding, cấu trúc dự án -> nêu khi nào phù hợp với mỗi lựa chọn.', '- React là thư viện cho tầng view; Angular là framework đầy đủ (router, form, HTTP client, DI có sẵn)
- React dùng JSX và JavaScript/TypeScript; Angular dùng TypeScript với template HTML riêng
- React theo luồng dữ liệu một chiều; Angular hỗ trợ two-way data binding
- Angular có cấu trúc chặt chẽ, quy ước rõ ràng, hợp dự án doanh nghiệp lớn; React linh hoạt hơn nhưng cần tự chọn kiến trúc
- Angular có đường cong học tập dốc hơn (RxJS, DI, module)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('259dfef0-e879-55d8-b73c-c3093d1faef7', 'CSS-in-JS (ví dụ styled-components) là gì? Ưu nhược điểm của cách tiếp cận này?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> nêu ưu điểm -> nêu nhược điểm -> so sánh ngắn với CSS Modules hoặc Tailwind.', '- CSS-in-JS là cách viết style ngay trong JavaScript, gắn trực tiếp với component; styled-components là thư viện tiêu biểu
- Ưu điểm: style có phạm vi riêng theo component, không xung đột tên class
- Dễ tạo style động theo props, hỗ trợ theme, xoá code thừa cùng component
- Nhược điểm: tốn chi phí runtime, tăng dung lượng bundle, phức tạp hơn khi SSR
- Xu hướng gần đây chuyển sang CSS Modules, Tailwind hoặc CSS-in-JS không runtime', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fb9512f4-e5b9-5ba7-8d79-af8353b769f2', 'React.lazy là gì? Bạn dùng nó để code splitting như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa React.lazy -> giải thích kết hợp với Suspense -> nêu lợi ích và trường hợp áp dụng.', '- React.lazy cho phép tải một component bằng dynamic import, chỉ tải khi component cần được render
- Phải bọc trong Suspense để hiển thị giao diện chờ (fallback) trong lúc tải
- Giúp tách bundle (code splitting), giảm dung lượng tải ban đầu, trang mở nhanh hơn
- Thường áp dụng theo route hoặc cho component nặng ít dùng (modal, biểu đồ)
- React.lazy chỉ hỗ trợ default export; nên kết hợp Error Boundary để xử lý lỗi tải', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2cc1460c-89c5-552f-80a3-f988022b342e', 'Hooks trong React là gì? Vì sao React giới thiệu hooks?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa hooks -> kể các hook phổ biến -> giải thích vấn đề hooks giải quyết so với class component.', '- Hooks là các hàm đặc biệt cho phép function component dùng state, side effect và tính năng khác của React
- Hook phổ biến: useState, useEffect, useContext, useRef, useMemo, useCallback, useReducer
- Ra đời từ React 16.8 để thay thế phần lớn nhu cầu dùng class component
- Giúp tái sử dụng logic có state qua custom hook thay vì HOC hay render props
- Gom logic liên quan vào một chỗ thay vì rải trong các lifecycle method', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2f6d182b-eaee-5ed6-87bd-1ac39f6a8e83', 'Khi dùng hooks cần tuân thủ những quy tắc nào? Làm sao đảm bảo cả dự án tuân thủ?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu hai quy tắc -> giải thích lý do kỹ thuật -> nêu công cụ kiểm tra tự động.', '- Chỉ gọi hook ở cấp cao nhất của component, không gọi trong vòng lặp, điều kiện hay hàm lồng
- Chỉ gọi hook trong function component hoặc custom hook, không gọi trong hàm JavaScript thường
- Lý do: React dựa vào thứ tự gọi hook để gắn đúng state cho mỗi hook giữa các lần render
- Dùng plugin eslint-plugin-react-hooks (rules-of-hooks, exhaustive-deps) để kiểm tra tự động', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('675d4c1e-0262-5096-81fb-0b548a2aa64d', 'Error Boundary trong React là gì và hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> mô tả cách tạo bằng các lifecycle method -> nêu nơi nên đặt error boundary.', '- Error Boundary là component bắt lỗi JavaScript xảy ra khi render trong cây component con
- Hiển thị giao diện dự phòng thay vì làm sập toàn bộ ứng dụng
- Hiện chỉ tạo được bằng class component với getDerivedStateFromError (đổi state để hiện fallback) và componentDidCatch (ghi log lỗi)
- componentDidCatch nhận lỗi và thông tin component stack để gửi về hệ thống log
- Có thể đặt ở cấp toàn ứng dụng hoặc bao từng khu vực/route để cô lập lỗi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('58dc5c69-c97f-5f95-aa21-7f183e16e6e2', 'Những trường hợp nào Error Boundary không bắt được lỗi? Khi đó bạn xử lý thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Liệt kê các trường hợp -> giải thích lý do -> nêu cách xử lý thay thế.', '- Lỗi trong event handler (vì không xảy ra khi render)
- Lỗi trong code bất đồng bộ như setTimeout, Promise, callback
- Lỗi khi render phía server
- Lỗi phát sinh trong chính error boundary
- Xử lý bằng try/catch trong handler, bắt lỗi Promise và đưa vào state để hiển thị, hoặc ghi log toàn cục', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c30d4fe8-8528-520e-975f-b987a19a10a6', 'Code splitting là gì? Bạn áp dụng nó trong ứng dụng frontend như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> giải thích vì sao cần -> nêu cách hiện thực (dynamic import, theo route) và cách kiểm tra hiệu quả.', '- Code splitting là chia bundle JavaScript thành nhiều phần nhỏ, chỉ tải khi cần
- Giảm dung lượng tải ban đầu, giúp trang hiển thị nhanh hơn
- Hiện thực bằng dynamic import, được bundler như Webpack, Vite tự tách thành chunk
- Trong React dùng React.lazy kết hợp Suspense; vị trí hiệu quả nhất thường là theo route
- Dùng công cụ phân tích bundle để tìm phần nặng cần tách', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26653ae2-ec61-5bbd-bb59-0f6c28a6e3c6', 'Next.js là gì? Nó có những tính năng chính nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa Next.js -> liệt kê các tính năng chính -> nêu khi nào nên dùng thay vì React thuần.', '- Next.js là framework xây dựng trên React để làm ứng dụng web hoàn chỉnh
- Hỗ trợ nhiều cách render: SSR, static generation (SSG), incremental static regeneration, client-side rendering
- Định tuyến dựa trên cấu trúc thư mục, hỗ trợ React Server Components (App Router)
- Có sẵn API routes/route handlers, tối ưu ảnh, font, code splitting tự động
- Phù hợp khi cần SEO, tải trang đầu nhanh hoặc muốn làm cả phần backend nhẹ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7b032fb5-7645-5b7e-a745-21cd706afbc4', 'Làm thế nào để tránh một hàm bị gọi quá nhiều lần liên tiếp, ví dụ khi người dùng gõ tìm kiếm hoặc bấm nút liên tục?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giới thiệu debounce và throttle -> so sánh cách hoạt động -> lấy ví dụ áp dụng.', '- Debounce: chỉ gọi hàm sau khi sự kiện ngừng xảy ra một khoảng thời gian, hợp với ô tìm kiếm
- Throttle: giới hạn hàm chỉ chạy tối đa một lần trong mỗi khoảng thời gian, hợp với scroll, resize
- Với nút submit có thể vô hiệu hoá nút trong lúc đang xử lý để tránh gửi trùng
- Trong React cần giữ hàm debounce ổn định giữa các lần render (useMemo/useRef) và huỷ khi unmount
- Có thể dùng thư viện như lodash', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4f76ace3-02a4-5aab-8769-c70cdacbe9ee', 'JSX giúp ngăn chặn tấn công injection (XSS) như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích cơ chế escape mặc định -> nêu các trường hợp vẫn có rủi ro -> đưa ra cách phòng tránh.', '- React tự động escape mọi giá trị nhúng trong JSX trước khi render
- Nội dung người dùng nhập được hiển thị như text, không được thực thi như HTML hay script
- Rủi ro vẫn còn khi dùng dangerouslySetInnerHTML, gán URL dạng javascript: vào href, hoặc thao tác DOM trực tiếp
- Cần làm sạch HTML (DOMPurify), kiểm tra URL và áp dụng Content Security Policy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f74672d5-aee3-5721-9723-7d455ccbb4c6', 'Bạn thường xử lý form phức tạp trong React như thế nào? Có dùng thư viện nào không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu các vấn đề khi làm form lớn -> giới thiệu thư viện đã dùng và lý do -> nói về validate.', '- Form lớn gặp các vấn đề: quản lý nhiều giá trị, validate, hiển thị lỗi, trạng thái submit
- Thư viện phổ biến: React Hook Form (dựa trên uncontrolled input, ít render lại), Formik
- Kết hợp thư viện schema như Zod hoặc Yup để validate
- Validate cả phía client để có trải nghiệm tốt và phía server để đảm bảo an toàn
- Xử lý trạng thái submit: vô hiệu hoá nút, hiển thị lỗi từ server', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('98030556-5ce0-59f7-99c5-d5f079b13ac4', 'Vì sao React khuyến khích dùng composition thay vì kế thừa giữa các component?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích composition -> so sánh với kế thừa -> lấy ví dụ cách tái sử dụng logic và giao diện.', '- Composition là ghép các component lại với nhau qua props và children thay vì tạo lớp con
- Props và children đủ linh hoạt để tuỳ biến giao diện và hành vi
- Kế thừa tạo ràng buộc chặt, khó thay đổi và khó hiểu khi phân cấp sâu
- Logic không liên quan tới UI nên tách ra module hoặc custom hook để tái sử dụng
- Ví dụ: Dialog chung nhận children và props, các dialog cụ thể chỉ việc ghép lại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4021b9f6-4f62-54cc-a185-bc8275d452e3', 'Suspense trong React là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> nêu các trường hợp sử dụng -> giải thích cách hiển thị fallback và lồng nhiều Suspense.', '- Suspense là component có sẵn cho phép hiển thị giao diện chờ (fallback) trong lúc phần con chưa sẵn sàng
- Dùng với React.lazy để chờ tải code của component
- Dùng với các nguồn dữ liệu hỗ trợ Suspense (framework, React Query, use) để chờ dữ liệu
- Có thể lồng nhiều Suspense để hiển thị từng phần trang khi sẵn sàng
- Hỗ trợ streaming khi render phía server', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3513102-4084-5f7f-a20a-3a983b54c829', 'Khi nào bạn cần dùng ref trong React?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa ref -> liệt kê các trường hợp nên dùng -> nêu lưu ý tránh lạm dụng.', '- Ref (useRef) giữ một giá trị thay đổi được qua các lần render mà không gây render lại
- Truy cập trực tiếp phần tử DOM: focus, chọn text, phát media, đo kích thước, cuộn tới vị trí
- Tích hợp thư viện bên thứ ba thao tác DOM trực tiếp (biểu đồ, bản đồ)
- Lưu giá trị không cần hiển thị như id timer, giá trị trước đó
- Không nên dùng ref thay cho state khi dữ liệu ảnh hưởng tới giao diện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('54e013eb-b360-5641-b70c-97a2734958da', 'Kỹ thuật windowing (virtualization) danh sách là gì? Khi nào nên dùng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> giải thích lợi ích hiệu năng -> nêu thư viện và trường hợp áp dụng.', '- Windowing chỉ render những phần tử đang nằm trong vùng nhìn thấy của danh sách, thay vì toàn bộ
- Khi cuộn, các phần tử ra khỏi vùng nhìn bị bỏ và phần tử mới được render
- Giảm mạnh số node DOM, thời gian render và bộ nhớ
- Dùng khi danh sách hoặc bảng có hàng nghìn dòng
- Thư viện: react-window, react-virtualized, TanStack Virtual', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d24152b3-b032-5496-a8a5-e571d0d251b5', 'Bộ công nghệ (tech stack) React mà bạn ưa thích là gì? Vì sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'INTRO', 'Giới thiệu stack hiện tại đang dùng -> lý do chọn dựa trên trải nghiệm dự án trước -> định hướng tìm hiểu thêm.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ccb3648c-acea-5ec2-a05f-f8b1bba05061', 'Hook useEffect dùng để làm gì? Bạn hãy giải thích vai trò của mảng dependency và hàm cleanup.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa useEffect -> giải thích dependency array với các trường hợp -> giải thích cleanup và ví dụ fetch dữ liệu.', '- useEffect dùng để chạy side effect sau khi render: gọi API, đăng ký sự kiện, đồng bộ với hệ thống bên ngoài
- Không có mảng dependency: chạy sau mỗi lần render; mảng rỗng: chỉ chạy sau lần mount đầu
- Có dependency: chạy lại khi một giá trị trong mảng thay đổi; phải khai báo đủ các giá trị được dùng
- Hàm cleanup trả về từ effect chạy trước lần effect kế tiếp và khi unmount, dùng để gỡ listener, huỷ request, xoá timer
- Không nên dùng useEffect cho dữ liệu có thể tính trực tiếp khi render', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c5fe9c6a-9a65-5203-98bb-8bab9dfe9962', 'Bạn hãy mô tả luồng dữ liệu trong React.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích luồng dữ liệu một chiều -> mô tả cách dữ liệu đi xuống và sự kiện đi lên -> nêu lợi ích.', '- React theo luồng dữ liệu một chiều: dữ liệu đi từ component cha xuống con qua props
- Mỗi state thuộc về một component; khi state đổi, component đó và các con được render lại
- Con muốn thay đổi dữ liệu thì gọi callback do cha truyền xuống (sự kiện đi lên)
- Dữ liệu dùng chung được đưa lên cha chung hoặc vào context/store
- Giúp ứng dụng dễ dự đoán, dễ debug', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c7e7b92a-b7d4-5140-b9c8-c558fb767eea', 'MobX là gì? Nó khác Redux như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa MobX -> giải thích cơ chế reactive -> so sánh với Redux.', '- MobX là thư viện quản lý state theo mô hình lập trình phản ứng (reactive)
- State được đánh dấu observable, component tự cập nhật khi phần state nó dùng thay đổi
- Cho phép thay đổi state trực tiếp (mutable) trong action, ít boilerplate
- Redux dùng state bất biến, thay đổi qua action và reducer thuần, luồng dữ liệu tường minh hơn
- MobX viết nhanh hơn, Redux dễ dự đoán và debug hơn với ứng dụng lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('169f040b-35c0-54b1-b181-5d359ce1b8a3', 'Concurrent rendering trong React là gì? Bạn hãy lấy ví dụ.', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa -> so sánh với render đồng bộ trước đây -> mô tả API liên quan và ví dụ ô tìm kiếm với danh sách lớn.', '- Concurrent rendering cho phép React chuẩn bị nhiều phiên bản UI, tạm dừng hoặc huỷ việc render đang dở
- Trước đây render là đồng bộ, một lần render nặng sẽ chặn tương tác của người dùng
- React ưu tiên cập nhật khẩn cấp (gõ phím, click) hơn cập nhật không khẩn cấp
- API liên quan: useTransition, startTransition, useDeferredValue, Suspense
- Ví dụ: gõ vào ô tìm kiếm vẫn mượt trong khi danh sách kết quả lớn được lọc và render ở mức ưu tiên thấp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('799e748c-1572-5ba2-9517-d761c0214a6d', 'Lập trình imperative và declarative khác nhau như thế nào? React theo cách nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa hai cách tiếp cận -> ví dụ so sánh khi cập nhật giao diện -> liên hệ với React.', '- Imperative: mô tả từng bước cần làm để đạt kết quả (ví dụ tự tìm phần tử DOM, thêm class, đổi text)
- Declarative: mô tả kết quả mong muốn, để thư viện lo cách thực hiện
- React theo hướng declarative: mô tả UI ứng với state hiện tại, React tự cập nhật DOM
- Declarative giúp code dễ đọc, dễ dự đoán và ít lỗi khi UI phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9f360fa7-a889-5a22-83e4-9a2bda01aacf', 'Dùng TypeScript với React mang lại những lợi ích gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê lợi ích -> ví dụ cụ thể trong React (props, hooks) -> nêu chi phí đi kèm.', '- Phát hiện lỗi kiểu dữ liệu ngay khi viết code và biên dịch, trước khi chạy
- Định nghĩa rõ kiểu props, state, dữ liệu API, giúp component tự mô tả cách dùng
- Gợi ý code và refactor an toàn hơn trong editor
- Dễ bảo trì và cộng tác trong dự án lớn
- Đổi lại cần học thêm và tốn thời gian khai báo kiểu ban đầu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b12455f3-6147-5add-a31a-910cba165d0c', 'Làm thế nào để người dùng vẫn giữ trạng thái đăng nhập khi tải lại trang trong ứng dụng React?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu nơi lưu thông tin xác thực -> mô tả bước khôi phục khi ứng dụng khởi động -> so sánh các lựa chọn lưu trữ về bảo mật.', '- State trong bộ nhớ mất khi tải lại trang nên cần lưu thông tin xác thực bền vững
- Lưu token trong cookie HttpOnly (an toàn hơn trước XSS) hoặc localStorage/sessionStorage
- Khi ứng dụng khởi động, đọc token hoặc gọi API kiểm tra phiên (ví dụ /me) để khôi phục user vào context/store
- Hiển thị trạng thái đang kiểm tra để tránh nhảy về trang login
- Xử lý token hết hạn: refresh token hoặc đăng xuất', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4f26ee05-90ed-5fbd-86a4-adf99b848529', 'React Server Components là gì? Khi nào nên dùng server component và client component?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa -> so sánh với client component và SSR truyền thống -> nêu tiêu chí chọn loại component.', '- Server Component chạy trên server, không gửi code JavaScript của nó xuống trình duyệt
- Có thể truy cập trực tiếp dữ liệu phía server (database, file) và giảm dung lượng bundle
- Server Component không dùng được state, effect hay event handler
- Client Component (đánh dấu use client) dùng cho phần cần tương tác, state, API trình duyệt
- Khác SSR: SSR render client component ra HTML rồi hydrate, còn Server Component không bao giờ hydrate', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('767d23df-c5a3-50fc-ad17-7bf9b781aeac', 'Prop drilling là gì? Có những cách nào để tránh nó?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> nêu nhược điểm -> liệt kê các cách giải quyết.', '- Prop drilling là việc truyền props qua nhiều tầng component trung gian vốn không dùng tới dữ liệu đó
- Làm code rối, khó bảo trì và dễ sai khi đổi cấu trúc
- Giải pháp: dùng Context cho dữ liệu dùng chung
- Dùng thư viện quản lý state (Redux, Zustand)
- Dùng composition: truyền component qua children thay vì truyền dữ liệu xuống sâu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('88824e37-0010-54f5-aa11-4b6b50e476b3', 'useState và useRef khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh về việc gây render lại, cách cập nhật giá trị -> nêu trường hợp dùng mỗi hook.', '- Cập nhật state qua useState gây render lại component; đổi giá trị ref.current thì không
- Giá trị state cập nhật cho lần render sau; ref được thay đổi ngay lập tức
- Cả hai đều giữ giá trị qua các lần render
- useState dùng cho dữ liệu hiển thị trên giao diện
- useRef dùng để truy cập DOM hoặc lưu giá trị không ảnh hưởng giao diện như id timer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b19f9a1c-f369-5cbe-a74e-1935509edb86', 'useEffect và useLayoutEffect khác nhau như thế nào? Khi nào dùng useLayoutEffect?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'So sánh thời điểm chạy -> giải thích ảnh hưởng tới hiển thị -> nêu trường hợp cần useLayoutEffect và lưu ý hiệu năng.', '- useEffect chạy sau khi trình duyệt đã vẽ giao diện lên màn hình, không chặn hiển thị
- useLayoutEffect chạy đồng bộ sau khi cập nhật DOM nhưng trước khi trình duyệt vẽ
- Dùng useLayoutEffect khi cần đo kích thước hoặc vị trí DOM rồi cập nhật ngay để tránh nhấp nháy (ví dụ định vị tooltip)
- useLayoutEffect chặn việc vẽ nên dùng nhiều sẽ làm chậm giao diện
- Mặc định nên dùng useEffect, chỉ chuyển khi thấy lỗi hiển thị', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3b165423-4228-53e9-955f-306eec35c98b', 'StrictMode trong React là gì? Vì sao ở chế độ development component lại render hai lần?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa StrictMode -> nêu các kiểm tra nó thực hiện -> giải thích lý do render và chạy effect hai lần.', '- StrictMode là component chỉ hoạt động ở môi trường development, giúp phát hiện vấn đề tiềm ẩn
- Không render giao diện gì thêm và không ảnh hưởng bản production
- Cố ý render component hai lần để phát hiện render không thuần (có side effect)
- Chạy effect thêm một chu kỳ setup, cleanup, setup để phát hiện effect thiếu cleanup
- Cảnh báo việc dùng API cũ hoặc không an toàn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('af73b924-adaa-5017-9fb7-7204f015265d', 'React gộp (batching) nhiều lần cập nhật state như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa batching -> mô tả thay đổi từ React 18 -> nêu cách bỏ batching khi cần.', '- Batching là gộp nhiều lần cập nhật state thành một lần render để tăng hiệu năng
- Trước React 18 chỉ gộp trong event handler của React
- Từ React 18 có automatic batching: gộp cả trong Promise, setTimeout, event gốc
- Vì vậy sau khi gọi hàm cập nhật, giá trị state chưa đổi ngay trong cùng lần chạy
- Có thể dùng flushSync để buộc cập nhật ngay khi thật sự cần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4a67dd6-07ae-58ae-958a-1beb377cf4e1', 'Hydration trong React là gì?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa -> mô tả vị trí của hydration trong luồng SSR -> nêu lỗi hydration mismatch và cách tránh.', '- Hydration là quá trình React gắn logic và event handler vào HTML đã được render sẵn từ server
- React không tạo lại DOM mà dùng DOM có sẵn, so khớp với cây component phía client (hydrateRoot)
- Sau hydration trang mới tương tác được
- Lỗi hydration mismatch xảy ra khi HTML từ server khác với kết quả render ở client
- Nguyên nhân thường gặp: dùng thời gian hiện tại, số ngẫu nhiên, API trình duyệt khi render; xử lý bằng cách chuyển sang useEffect', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6bdeab64-23e0-5800-9971-064e0457c300', 'Làm thế nào để cập nhật object hoặc mảng trong state của React? Vì sao không nên sửa trực tiếp?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu nguyên tắc bất biến -> mô tả cách tạo bản sao khi cập nhật object, object lồng nhau, mảng -> giải thích lợi ích.', '- State phải được coi là bất biến: tạo object/mảng mới thay vì sửa trực tiếp
- React so sánh tham chiếu để biết state đổi; sửa trực tiếp giữ nguyên tham chiếu nên có thể không render lại
- Object: dùng spread để sao chép rồi ghi đè trường cần đổi; object lồng nhau phải sao chép từng tầng
- Mảng: dùng map, filter, concat, spread thay cho push, splice, sort trực tiếp
- Có thể dùng thư viện Immer để viết kiểu sửa trực tiếp mà vẫn tạo state mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b5e17a7-f70f-53fa-a490-708c2ef68d47', 'Điều gì xảy ra nếu bạn khai báo một component bên trong một component khác?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích cơ chế tạo hàm mới mỗi lần render -> nêu hậu quả -> đưa ra cách khắc phục.', '- Về kỹ thuật vẫn chạy được nhưng là anti-pattern
- Mỗi lần component cha render, component con được tạo lại thành một hàm mới
- React coi đó là loại component khác, nên huỷ và tạo lại toàn bộ cây con
- Hậu quả: mất state của con (ví dụ input mất nội dung, mất focus) và hiệu năng kém
- Nên khai báo component ở cấp module và truyền dữ liệu qua props', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('476029e2-02d8-577b-9be4-83e0ec751f30', 'useReducer khác useState như thế nào? Khi nào nên dùng useReducer?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa useReducer -> so sánh với useState -> nêu tiêu chí lựa chọn.', '- useReducer quản lý state qua hàm reducer nhận state hiện tại và action, trả về state mới
- useState phù hợp với state đơn giản, độc lập
- useReducer phù hợp khi state phức tạp, nhiều trường liên quan hoặc state mới phụ thuộc state cũ theo nhiều kiểu cập nhật
- Gom logic cập nhật vào một chỗ, dễ test reducer riêng
- Có thể kết hợp với Context để chia sẻ state và dispatch cho cây component', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa26c050-b18f-5fb2-bfd1-5095f259b79d', 'useContext là gì? Các bước để dùng Context trong React là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> mô tả các bước tạo, cung cấp, sử dụng -> nêu các trường hợp sử dụng.', '- useContext là hook đọc giá trị của một Context từ Provider gần nhất phía trên
- Bước 1: tạo context bằng createContext (có thể kèm giá trị mặc định)
- Bước 2: bọc cây component bằng Provider và truyền value
- Bước 3: trong component con gọi useContext để lấy giá trị
- Dùng cho dữ liệu chung như theme, ngôn ngữ, user đăng nhập, tránh prop drilling', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('07a2c57d-e003-51a1-942c-9559701fc682', 'Trong Next.js, Pages Router và App Router khác nhau như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Giới thiệu hai cách định tuyến -> so sánh về cấu trúc thư mục, cách lấy dữ liệu, loại component -> nêu khi nào chọn cái nào.', '- Pages Router là cách định tuyến cũ dựa trên thư mục pages; App Router dùng thư mục app, ra đời từ Next.js 13
- App Router mặc định dùng React Server Components; Pages Router chỉ có client component render qua SSR
- Pages Router lấy dữ liệu bằng getServerSideProps, getStaticProps; App Router fetch trực tiếp trong server component
- App Router hỗ trợ layout lồng nhau, loading và error theo route, streaming với Suspense
- Dự án mới nên dùng App Router; Pages Router vẫn được hỗ trợ cho dự án cũ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0840e0f1-c854-5036-9044-86363d442179', 'Hook useMemo dùng để làm gì? Nó khác useCallback thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa useMemo -> so sánh với useCallback -> nêu khi nào nên dùng và khi nào không cần.', '- useMemo ghi nhớ kết quả của một phép tính, chỉ tính lại khi dependency thay đổi
- useCallback ghi nhớ chính hàm, giữ tham chiếu hàm ổn định giữa các lần render
- Dùng useMemo cho phép tính tốn kém hoặc để giữ tham chiếu object ổn định truyền cho component memo
- Dùng useCallback khi truyền callback cho component con đã memo hoặc làm dependency của effect
- Không nên dùng tràn lan vì cũng tốn chi phí so sánh và bộ nhớ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('01e37fe7-5361-5be3-8ee4-8f3b14e6cacb', 'Updater function khi cập nhật state là gì? Có nên luôn dùng nó không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> giải thích vấn đề nó giải quyết -> nêu khi nào cần và khi nào không bắt buộc.', '- Updater function là hàm truyền vào hàm set state, nhận state trước đó và trả về state mới
- Đảm bảo tính từ giá trị mới nhất khi có nhiều cập nhật liên tiếp được gộp trong một lần render
- Ví dụ gọi tăng biến đếm ba lần liên tiếp chỉ đúng khi dùng updater function
- Cần khi state mới phụ thuộc state cũ, đặc biệt trong callback bất đồng bộ
- Không bắt buộc khi gán giá trị mới không phụ thuộc giá trị cũ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a18612a4-1fe3-5b30-83e2-3f7ea1c27c96', 'Khi dùng Context để truyền object, lỗi hiệu năng thường gặp là gì và cách khắc phục?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Mô tả vấn đề tham chiếu object mới mỗi lần render -> giải thích hậu quả -> nêu các cách khắc phục.', '- Nếu value của Provider là object tạo mới mỗi lần render, tham chiếu luôn khác
- Mọi component dùng context đó đều render lại dù dữ liệu thực tế không đổi
- Khắc phục: bọc value bằng useMemo, hàm bằng useCallback
- Tách context theo phần dữ liệu (ví dụ tách state và dispatch, tách theo tần suất thay đổi)
- Với state thay đổi thường xuyên có thể dùng thư viện hỗ trợ chọn từng phần state', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('555fbdc5-598b-5257-8173-b9e33abe13fa', 'Nguyên nhân nào khiến useEffect chạy lặp vô hạn và làm sao để tránh?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu các nguyên nhân phổ biến -> giải thích cơ chế vòng lặp -> đưa ra cách khắc phục.', '- Effect cập nhật state, state đó lại nằm trong dependency (hoặc không có mảng dependency) gây chạy lại liên tục
- Dependency là object, mảng hoặc hàm tạo mới mỗi lần render nên luôn bị coi là thay đổi
- Khắc phục: khai báo đúng dependency, dùng updater function để không phụ thuộc state cũ
- Ổn định tham chiếu bằng useMemo, useCallback hoặc chuyển giá trị ra ngoài component/vào trong effect
- Thêm điều kiện trong effect để chỉ cập nhật khi giá trị thực sự khác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d9c70018-95b6-5c6d-a56f-881df24a4ef5', 'Hook useImperativeHandle dùng để làm gì và khi nào nên dùng?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa -> giải thích cách kết hợp với ref -> nêu trường hợp sử dụng và lý do nên hạn chế.', '- useImperativeHandle cho phép component tuỳ chỉnh những gì được lộ ra cho component cha qua ref
- Thay vì lộ toàn bộ node DOM, chỉ lộ một số phương thức như focus, scrollIntoView, reset
- Dùng khi component cha cần ra lệnh trực tiếp cho con: điều khiển focus, phát media, mở modal, kích hoạt animation
- Nên hạn chế vì đi ngược tư duy khai báo; ưu tiên điều khiển bằng props', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0baebb2d-6a00-535c-8602-c02457cbd097', 'Dùng useMemo có ngăn được component con render lại không?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Trả lời trực tiếp -> giải thích cơ chế render của React -> nêu cách kết hợp đúng để ngăn render lại.', '- Tự bản thân useMemo không ngăn component con render lại
- Mặc định khi cha render lại, mọi component con đều render lại bất kể props
- useMemo chỉ giữ tham chiếu ổn định cho giá trị được ghi nhớ
- Phải kết hợp component con bọc React.memo với props ổn định (useMemo, useCallback) thì con mới bỏ qua render
- Ngoại lệ: dùng useMemo để ghi nhớ chính phần tử JSX con thì React có thể bỏ qua render phần đó', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('159df02a-7571-5d14-bdf8-9fbe4be72b24', 'Custom hook là gì? Bạn xây dựng và dùng custom hook để chia sẻ logic như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> nêu quy tắc đặt tên và cách hoạt động -> ví dụ custom hook đã viết trong dự án.', '- Custom hook là hàm JavaScript tên bắt đầu bằng use, bên trong gọi các hook khác
- Dùng để tách và tái sử dụng logic có state giữa nhiều component (ví dụ useFetch, useDebounce, useLocalStorage)
- Mỗi component gọi custom hook có state riêng, hook chia sẻ logic chứ không chia sẻ state
- Phải tuân thủ quy tắc của hooks
- Giúp component gọn hơn và dễ test logic', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8ed80cf7-d35d-5333-ab3d-fd68b3b078ab', 'Hook useId dùng để làm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> nêu trường hợp sử dụng -> giải thích vì sao không dùng số ngẫu nhiên.', '- useId sinh ra id duy nhất và ổn định cho mỗi component
- Dùng cho thuộc tính accessibility như liên kết label với input, aria-describedby
- Id giống nhau giữa server và client nên tránh lỗi hydration mismatch, khác với số ngẫu nhiên hay biến đếm
- Không dùng useId để làm key cho danh sách', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aecec575-3354-592a-a956-c281eb04d70d', 'Hook useTransition là gì và khác useDeferredValue như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa từng hook -> so sánh cái được đánh dấu là không khẩn cấp -> nêu trường hợp dùng mỗi hook.', '- Cả hai thuộc concurrent features, giúp giao diện vẫn phản hồi khi có cập nhật nặng
- useTransition đánh dấu một cập nhật state là không khẩn cấp (startTransition) và cho biết isPending
- useDeferredValue nhận một giá trị và trả về phiên bản chậm hơn của giá trị đó
- Dùng useTransition khi bạn kiểm soát nơi cập nhật state
- Dùng useDeferredValue khi giá trị đến từ props hoặc nơi khác mà bạn không kiểm soát việc cập nhật', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('79789e02-86aa-5a02-b4c4-955d0e56bcd0', 'Bạn hãy kể một số best practice khi sử dụng React Hooks.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Liệt kê các nguyên tắc chính -> giải thích ngắn lý do -> lấy ví dụ từ kinh nghiệm.', '- Tuân thủ quy tắc của hooks và bật eslint-plugin-react-hooks
- Khai báo đầy đủ dependency cho useEffect, useMemo, useCallback
- Mỗi effect chỉ lo một việc, luôn dọn dẹp trong cleanup
- Tách logic tái sử dụng thành custom hook
- Không lạm dụng useEffect cho dữ liệu tính được khi render; chỉ dùng useMemo/useCallback khi thật sự cần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d7b1dc02-39b0-505f-9792-1991f2762983', 'React 18 giới thiệu những tính năng chính nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Liệt kê các tính năng -> giải thích ngắn từng tính năng -> nêu tác động khi nâng cấp.', '- Concurrent rendering làm nền tảng cho các tính năng mới
- Automatic batching gộp cập nhật state ở mọi nơi
- API root mới createRoot, hydrateRoot
- Transitions: useTransition, startTransition, useDeferredValue
- Streaming SSR với Suspense và selective hydration; thêm hook useId, useSyncExternalStore', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cbe603e6-07d6-59c0-bcfa-2b08835f0c6d', 'React 19 có những tính năng mới đáng chú ý nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Liệt kê các tính năng chính -> giải thích ngắn -> nêu tác động tới cách viết code.', '- Actions: hỗ trợ hàm bất đồng bộ trong transition để xử lý form, trạng thái pending và lỗi
- Hook mới: useActionState, useFormStatus, useOptimistic và API use để đọc Promise/Context
- Server Components và Server Actions ổn định
- ref được truyền như một prop bình thường, không cần forwardRef trong đa số trường hợp
- Hỗ trợ khai báo metadata, stylesheet trong component; React Compiler tự động memoize (phát hành riêng)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8fc7f434-6c42-5ccf-b1d6-36dff4882399', 'Server Actions trong React là gì?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa -> mô tả cách hoạt động với form -> nêu lợi ích và lưu ý bảo mật.', '- Server Action là hàm bất đồng bộ chạy trên server, được đánh dấu bằng chỉ thị use server
- Có thể gọi trực tiếp từ client component hoặc gắn vào action của form
- Không cần tự viết API endpoint để thay đổi dữ liệu
- Hoạt động cùng useActionState, useFormStatus để hiển thị trạng thái pending và kết quả
- Vẫn là endpoint công khai nên phải kiểm tra xác thực, phân quyền và validate dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6b565306-551c-5395-a4c8-1e4ed364ca3e', 'Optimistic update là gì? Hook useOptimistic hỗ trợ điều đó như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa optimistic UI -> mô tả cách useOptimistic hoạt động -> nêu cách xử lý khi request thất bại.', '- Optimistic update là cập nhật giao diện ngay như thể thao tác đã thành công, không chờ server phản hồi
- Giúp ứng dụng có cảm giác nhanh, ví dụ nút thích, gửi tin nhắn
- useOptimistic trả về state tạm thời hiển thị trong lúc action đang chạy
- Khi action kết thúc, React quay về state thật từ server
- Nếu request lỗi cần hoàn tác và thông báo cho người dùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d5e3088e-7210-5008-b54f-6b7e0368b5fc', 'React Compiler là gì và nó giải quyết vấn đề gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> nêu vấn đề memoize thủ công -> giải thích lợi ích và điều kiện để compiler hoạt động tốt.', '- React Compiler là công cụ chạy lúc build, tự động tối ưu component và hook
- Tự động memoize giá trị, hàm và phần tử JSX để tránh render lại không cần thiết
- Giảm nhu cầu viết useMemo, useCallback, React.memo thủ công
- Yêu cầu code tuân thủ quy tắc của React (render thuần, không sửa props/state trực tiếp)
- Component vi phạm quy tắc sẽ được bỏ qua thay vì tối ưu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61229c8f-40fa-5015-b487-ea5206a4f7ee', 'Streaming SSR là gì và React 18 trở lên cải thiện nó như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu hạn chế của SSR truyền thống -> giải thích streaming với Suspense -> nêu selective hydration.', '- SSR truyền thống phải chờ lấy xong toàn bộ dữ liệu và render xong cả trang mới gửi HTML
- Streaming SSR gửi HTML theo từng phần, phần sẵn sàng được gửi trước
- Các phần đang chờ dữ liệu được bọc trong Suspense, hiển thị fallback rồi thay bằng nội dung khi xong
- Selective hydration cho phép hydrate từng phần độc lập, ưu tiên phần người dùng đang tương tác
- Dùng API renderToPipeableStream (Node) hoặc renderToReadableStream (Web Streams)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f7a81bf7-ab8f-5871-95ce-49c425d03928', 'React.memo có ngăn component dùng Context render lại khi giá trị Context thay đổi không?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Trả lời trực tiếp -> giải thích cơ chế cập nhật của Context -> nêu cách giảm render lại.', '- Không, React.memo chỉ so sánh props
- Component đọc Context sẽ render lại mỗi khi value của Provider thay đổi, bất kể có bọc memo
- Memo vẫn giúp bỏ qua render do cha render lại khi props không đổi
- Giảm render bằng cách tách Context nhỏ hơn, ổn định value bằng useMemo
- Hoặc tách phần đọc Context ra component nhỏ, truyền dữ liệu cần thiết xuống phần nặng đã memo', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa279ea6-dd4c-550f-be5a-fd4746c74e6c', 'Vì sao Redux Toolkit được khuyến nghị thay cho cách viết Redux truyền thống?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu các vấn đề của Redux truyền thống -> liệt kê các API của Redux Toolkit giải quyết chúng -> nêu kết quả.', '- Redux truyền thống nhiều boilerplate: action type, action creator, switch reducer, cấu hình store thủ công
- configureStore thiết lập sẵn DevTools, middleware thunk và kiểm tra lỗi phổ biến
- createSlice gộp reducer và action creator, dùng Immer nên viết kiểu sửa trực tiếp mà vẫn bất biến
- createAsyncThunk và RTK Query đơn giản hoá gọi API, cache dữ liệu
- Là cách viết chính thức được đội ngũ Redux khuyến nghị', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('abe93773-b44c-5692-a66f-f1772c7e3f46', 'Client state và server state khác nhau như thế nào? Có nên đưa toàn bộ dữ liệu từ API vào Redux không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa hai loại state -> so sánh đặc điểm -> nêu công cụ phù hợp cho từng loại.', '- Client state là dữ liệu do giao diện sở hữu: trạng thái mở modal, bộ lọc, theme
- Server state là dữ liệu thuộc về server, chỉ là bản sao tạm ở client, có thể cũ bất cứ lúc nào
- Server state cần xử lý cache, làm mới, loading, lỗi, đồng bộ, phân trang
- Không nên mặc định đưa hết dữ liệu API vào Redux; dùng thư viện chuyên dụng như React Query, SWR, RTK Query
- Client state dùng state cục bộ, Context hoặc store nhỏ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('540cce9d-781d-5a03-a667-7b5937137c20', 'Làm sao để tránh component render lại không cần thiết khi dùng Redux?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Giải thích cơ chế useSelector so sánh kết quả -> nêu các lỗi phổ biến -> đưa ra cách khắc phục và công cụ kiểm tra.', '- useSelector render lại component khi kết quả selector thay đổi theo so sánh tham chiếu
- Lỗi phổ biến: selector trả về object/mảng mới mỗi lần (ví dụ dùng filter, map) nên luôn render lại
- Chọn phần state nhỏ nhất cần dùng, tách nhiều useSelector
- Dùng memoized selector (createSelector) hoặc shallowEqual khi trả về object
- Kiểm tra bằng React DevTools Profiler và Redux DevTools', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('19bd0569-98b2-5e7f-9bda-f9b16d3d0787', 'Normalized state trong Redux là gì và vì sao nó quan trọng?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa -> so sánh với dữ liệu lồng nhau -> nêu lợi ích về hiệu năng và tính nhất quán.', '- Normalized state lưu dữ liệu giống bảng trong database: mỗi loại thực thể một nơi, dạng map theo id và danh sách id
- Quan hệ giữa các thực thể được tham chiếu bằng id thay vì lồng object
- Truy cập và cập nhật một phần tử theo id nhanh (O(1))
- Tránh trùng lặp dữ liệu, cập nhật một chỗ là đồng bộ mọi nơi
- Giảm render lại vì chỉ thực thể thay đổi có tham chiếu mới; Redux Toolkit có createEntityAdapter hỗ trợ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7b379ce4-59c3-5c2d-a865-893153c284f8', 'Middleware trong Redux là gì? Bạn hãy mô tả luồng xử lý khi dispatch một action.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa middleware -> mô tả luồng dispatch qua middleware, reducer, store, UI -> ví dụ middleware phổ biến.', '- Middleware là lớp chặn giữa lúc dispatch action và lúc action tới reducer
- Dùng để xử lý side effect, ghi log, xử lý bất đồng bộ, báo lỗi
- Luồng: dispatch action -> lần lượt đi qua chuỗi middleware -> reducer tính state mới -> store cập nhật -> các subscriber (useSelector) được báo và component render lại
- Middleware có thể sửa, chặn, trì hoãn action hoặc dispatch action khác
- Ví dụ: redux-thunk, redux-saga, listener middleware, logger', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('27943bb9-f8b7-5963-a194-5888729ad0e0', 'Bạn tổ chức Redux trong một ứng dụng lớn như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Trình bày cách chia theo tính năng -> nêu cách tổ chức slice, selector, API -> nói về giao tiếp giữa các slice.', '- Tổ chức theo tính năng (feature folder), mỗi tính năng có slice, selector, thunk riêng
- Dùng Redux Toolkit: createSlice, configureStore, RTK Query cho dữ liệu server
- Chỉ lưu state tối thiểu, chuẩn hoá dữ liệu, dữ liệu dẫn xuất tính bằng selector
- Slice phản ứng với action của slice khác qua extraReducers hoặc listener middleware thay vì gọi trực tiếp
- Dùng TypeScript cho kiểu RootState, AppDispatch và hook có kiểu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4caad1d1-6651-5ada-814e-9837ea68636b', 'Race condition khi gọi API trong ứng dụng frontend là gì và bạn xử lý như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Mô tả tình huống race condition -> giải thích hậu quả -> nêu các cách xử lý.', '- Race condition xảy ra khi nhiều request chạy song song và phản hồi về không theo thứ tự gửi
- Ví dụ gõ tìm kiếm nhanh: kết quả của từ khoá cũ về sau và ghi đè kết quả mới
- Huỷ request cũ bằng AbortController khi có request mới
- Bỏ qua phản hồi cũ bằng cách so sánh id/thời điểm request, hoặc chỉ nhận request mới nhất (takeLatest)
- Thư viện như React Query, RTK Query tự xử lý phần lớn trường hợp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ea6c8ece-2ad6-5d23-ba41-c8e416f7a182', 'Dữ liệu nào nên lưu trong store và dữ liệu nào nên tính ra bằng selector?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu nguyên tắc state tối thiểu -> ví dụ dữ liệu gốc và dữ liệu dẫn xuất -> giải thích lợi ích.', '- Chỉ lưu state tối thiểu, dữ liệu gốc không tính được từ dữ liệu khác
- Dữ liệu dẫn xuất như tổng tiền giỏ hàng, danh sách đã lọc, số lượng nên tính bằng selector
- Lưu cả dữ liệu dẫn xuất dễ gây lệch, phải nhớ cập nhật nhiều nơi
- Dùng memoized selector để tránh tính lại khi đầu vào không đổi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8c0064a1-5a36-515c-aaea-0b3af4fd2457', 'BrowserRouter, HashRouter và MemoryRouter khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Mô tả cách mỗi loại lưu vị trí URL -> nêu yêu cầu với server -> nêu trường hợp dùng.', '- BrowserRouter dùng History API của HTML5, URL sạch; server phải trả index.html cho mọi đường dẫn
- HashRouter lưu đường dẫn sau dấu # trong URL, không cần cấu hình server, hợp với hosting tĩnh đơn giản
- HashRouter có URL kém đẹp và không tốt cho SEO
- MemoryRouter lưu lịch sử trong bộ nhớ, không đổi URL; dùng cho test hoặc môi trường không có trình duyệt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa540e8a-b180-5a3f-a61c-e820beb2e8f2', 'Dynamic route và route parameter là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa -> ví dụ đường dẫn có tham số -> mô tả cách đọc tham số trong component.', '- Dynamic route là route có phần đường dẫn thay đổi, ví dụ trang chi tiết sản phẩm theo id
- Phần thay đổi được khai báo là tham số, ví dụ đường dẫn products/:id
- Một route phục vụ được nhiều URL khác nhau
- Trong React Router đọc tham số bằng hook useParams
- Khác với query string dùng cho bộ lọc, sắp xếp (đọc bằng useSearchParams)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('28a45cfd-8326-5b66-aa69-b3f90419556a', 'Loader và action trong React Router phiên bản mới là gì?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Định nghĩa từng khái niệm -> so sánh với việc fetch trong useEffect -> nêu lợi ích.', '- Loader là hàm gắn với route, tải dữ liệu trước khi route render; component đọc bằng useLoaderData
- Action là hàm gắn với route để xử lý gửi dữ liệu (form submit, thay đổi dữ liệu)
- Sau khi action chạy, React Router tự gọi lại loader để làm mới dữ liệu
- Tránh hiện tượng waterfall khi fetch trong useEffect và giảm code quản lý loading
- Hỗ trợ trạng thái điều hướng, xử lý lỗi theo route (errorElement)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7bd67661-ebcd-5afa-8259-b32ab05ee05b', 'Vòng đời (lifecycle) của một component React gồm những giai đoạn nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu ba giai đoạn -> kể phương thức tương ứng ở class component -> liên hệ cách làm tương đương bằng hooks.', '- Mounting: component được tạo và gắn vào DOM (constructor, render, componentDidMount)
- Updating: component render lại khi props hoặc state đổi (render, componentDidUpdate)
- Unmounting: component bị gỡ khỏi DOM (componentWillUnmount)
- Có thêm giai đoạn xử lý lỗi với error boundary
- Với function component dùng useEffect: mảng rỗng tương ứng mount, dependency tương ứng update, cleanup tương ứng unmount', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('35b7c91e-30b3-5e6b-9add-43f4cd10fe4b', 'Điều gì xảy ra nếu bạn dùng props để khởi tạo state? Khi nào cách này là hợp lý?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích state chỉ khởi tạo một lần -> nêu hậu quả khi props đổi -> đưa ra các cách xử lý đúng.', '- Giá trị khởi tạo của state chỉ được dùng ở lần render đầu tiên
- Khi props thay đổi sau đó, state không tự cập nhật theo nên giao diện bị lệch với dữ liệu mới
- Nếu chỉ cần hiển thị theo props thì dùng props trực tiếp hoặc tính toán khi render, không sao chép vào state
- Hợp lý khi props chỉ là giá trị ban đầu có chủ đích (ví dụ initialValue cho form), nên đặt tên rõ ràng
- Muốn reset state khi props đổi có thể đổi key của component', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac4957d8-96d3-50b1-8b0e-722767369f0a', 'Render props là gì? Kỹ thuật này dùng để làm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa -> mô tả cách hoạt động -> so sánh với HOC và custom hook.', '- Render props là kỹ thuật truyền một hàm qua props, component gọi hàm đó để quyết định render gì
- Dùng để chia sẻ logic có state (ví dụ theo dõi vị trí chuột, tải dữ liệu) giữa nhiều component
- Component chứa logic, còn phần giao diện do bên sử dụng quyết định
- Nhược điểm: dễ lồng nhiều tầng hàm, khó đọc
- Hiện nay đa số trường hợp có thể thay bằng custom hook', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5ccb1d8b-0346-54ef-b474-6877bbad4bf0', 'Nếu có thể dùng công nghệ để giải quyết một vấn đề lớn của xã hội ngay hôm nay, bạn sẽ chọn vấn đề nào? Vì sao?', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Nêu vấn đề bạn chọn -> giải thích vì sao nó quan trọng với bạn, gắn với trải nghiệm thực tế -> phác thảo hướng giải quyết bằng công nghệ.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f9ad8d28-66ec-5405-bd85-f48b262d6a44', 'Điều gì ở công việc hoặc kỳ thực tập trước mà bạn không muốn gặp lại ở công việc tiếp theo?', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Nêu điều bạn muốn tránh một cách khách quan, không chê bai -> giải thích vì sao nó ảnh hưởng tới hiệu quả của bạn -> nói về môi trường bạn mong muốn.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a5cc96fe-afc1-556c-bed6-4a80fb4b76fc', 'Hãy kể về một lần bạn chủ động giúp một đồng nghiệp hoặc thành viên mới hoà nhập với nhóm.', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1956d8c6-9ba6-5daa-b07f-68cc9d8c51eb', 'Trong vài phút, bạn hãy giải thích cho tôi một điều thú vị mà bạn biết rõ.', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Chọn một chủ đề bạn nắm chắc -> giải thích từ tổng quan tới chi tiết bằng ví dụ dễ hiểu -> kiểm tra lại người nghe đã hiểu chưa.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('48748cf7-af82-534c-96f4-5a75a2b33bd3', 'Hãy kể về một lần bạn rơi vào tình huống không thoải mái trong công việc và cách bạn xử lý.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9e3ec25c-fecf-5dba-aefd-5388675e8353', 'Bạn biết gì về công ty chúng tôi và sản phẩm của chúng tôi?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu những gì bạn đã tìm hiểu về công ty và sản phẩm -> điều bạn ấn tượng -> liên hệ với mong muốn đóng góp của bạn.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('414af7cd-b237-5db6-a641-a79bac74026f', 'Hãy kể về cách bạn làm việc với cấp quản lý và phối hợp với nhiều nhóm khác nhau trong một dự án lớn.', 'IT', 'Chung', 'HARD', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bca550d3-dedb-5fd7-9f15-eb2933d1adbb', 'Hãy kể về một lần bạn phải báo tin xấu, ví dụ trễ hạn hoặc sự cố nghiêm trọng, cho quản lý hoặc khách hàng.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9a85eade-40ab-5e02-aec1-6fe7191bcdef', 'Giá trị hoặc sứ mệnh nào của công ty chúng tôi khiến bạn thấy phù hợp nhất với bản thân?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu giá trị hoặc sứ mệnh cụ thể -> giải thích vì sao nó phù hợp với bạn qua trải nghiệm thực tế -> liên hệ với cách bạn sẽ đóng góp.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0aaddc0d-ff94-51c2-b12d-14c620992caf', 'Hãy kể về một lần bạn không hoàn thành công việc đúng hạn. Bạn đã xử lý như thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6f6ae763-e39c-54fe-88a9-c7d97b180bbe', 'Bạn đã từng chủ động làm một việc khi chưa được quản lý phê duyệt chưa? Hãy kể lại.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a9c585d1-5984-5dd5-982d-fb85c7ec4ec4', 'Hãy kể về một tình huống mà nếu được làm lại, bạn sẽ xử lý khác đi.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7458bf14-e9b6-5a75-afd4-74551f9a3c7b', 'Nếu được đề xuất cải thiện một sản phẩm phần mềm mà bạn thường dùng, bạn sẽ cải thiện điều gì và vì sao?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a24cd040-148c-5eec-870d-ab4cf51b1729', 'Bạn hiểu thế nào về vị trí mà bạn đang ứng tuyển?', 'IT', 'Chung', 'EASY', 'INTRO', 'Mô tả công việc và trách nhiệm chính của vị trí -> những kỹ năng cần có và bạn đã có gì -> điều bạn muốn học thêm ở vị trí này.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('69bd5e07-69d9-5d86-bc9e-cee4da7e1cf8', 'Hãy kể về một sản phẩm hoặc tính năng mà bạn tham gia từ đầu đến khi ra mắt.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8f16d26f-b09d-5375-ab3c-ffc8c4b3e77b', 'Bạn hãy giới thiệu về bản thân.', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại (vai trò, việc đang làm) -> quá khứ (học vấn, kinh nghiệm, thành tựu nổi bật) -> định hướng và lý do ứng tuyển vị trí này.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6a66b23b-d4eb-5f1e-bc23-c4a3f35f937a', 'Điểm mạnh lớn nhất của bạn là gì, và điểm nào bạn đang cần cải thiện?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu điểm mạnh kèm ví dụ chứng minh -> nêu điểm cần cải thiện một cách thật lòng -> nói rõ bạn đang làm gì để cải thiện.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0590bf35-2ac0-5b8f-aca4-2de54e538e34', 'Mức lương mong muốn của bạn là bao nhiêu?', 'IT', 'Chung', 'EASY', 'INTRO', 'Đưa ra khoảng lương dựa trên tìm hiểu thị trường và kinh nghiệm của bạn -> giải thích căn cứ -> thể hiện sự cởi mở khi trao đổi về tổng đãi ngộ.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('89165f94-0804-5632-a91c-fc3d05b05438', 'Hãy kể về một lần khối lượng công việc trở nên quá tải. Bạn đã làm gì?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1cf7469-73be-5077-aecd-ccb6de4184d3', 'Hãy kể về một lần bạn cần thông tin từ một người nhưng họ không phản hồi. Bạn đã làm gì?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('98590e24-0855-509e-ad40-e1bd1bb506f7', 'Có quan điểm nào trong nghề mà bạn nghĩ khác với số đông không? Vì sao?', 'IT', 'Chung', 'HARD', 'INTRO', 'Nêu quan điểm của bạn -> lập luận và dẫn chứng từ trải nghiệm -> thừa nhận góc nhìn của số đông và giới hạn của quan điểm mình.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ab79d5bc-14e4-55b3-b78a-9d93f98e9e47', 'Trong môi trường làm việc hoặc học tập hiện tại, bạn thấy điều gì đang chưa ổn và bạn sẽ cải thiện nó như thế nào?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34684467-cd20-5d05-a8ab-72cd4ffa2721', 'Hãy kể về một bài toán cần phân tích mà bạn từng giải quyết.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('845c20b5-c7ff-527b-b2e8-567dd04a649c', 'Bạn hãy giải thích công việc hoặc dự án gần nhất của mình cho một người không có nền tảng kỹ thuật.', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Bắt đầu bằng vấn đề mà dự án giải quyết -> giải thích bằng ví dụ đời thường, tránh thuật ngữ -> nêu giá trị mang lại cho người dùng.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7d07ddb0-894a-541a-a0be-e18b3d099cba', 'Hãy kể về kỳ thực tập của bạn.', 'IT', 'Chung', 'EASY', 'INTRO', 'Giới thiệu nơi thực tập và vai trò -> những việc bạn đã làm và kết quả -> điều bạn học được và định hướng tiếp theo.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a7c488fd-07c0-56ea-8ae4-75a243212c44', 'Hãy trình bày dự án khó nhất bạn từng làm và kiến trúc hệ thống của dự án đó.', 'IT', 'Chung', 'HARD', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh và mục tiêu dự án -> vai trò của bạn -> mô tả kiến trúc, các thành phần chính và lý do chọn thiết kế -> kết quả và điều bạn sẽ làm khác.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6ab1d604-8e38-536e-b2d0-eee2f57122dd', 'Nếu một thành viên trong nhóm muốn làm dự án theo cách khác bạn, ví dụ dùng ngôn ngữ lập trình khác, bạn sẽ xử lý thế nào?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7310dcaa-5cda-5324-a251-9257443e1dc9', 'Môn học hoặc lĩnh vực nào bạn thấy thú vị nhất? Vì sao?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bb0af7ff-2d81-533a-97fd-f2608458b3d0', 'Bạn cập nhật kiến thức và công nghệ mới bằng cách nào?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu các nguồn và thói quen học hiện tại -> ví dụ một công nghệ bạn đã học và áp dụng -> kế hoạch học tập sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a82ae6e3-3925-5374-b53c-29445c9e454b', 'Các tín hiệu SIGHUP, SIGINT, SIGTERM và SIGKILL khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SIGHUP gửi khi terminal điều khiển bị đóng; nhiều daemon dùng nó làm tín hiệu nạp lại cấu hình
- SIGINT là tín hiệu ngắt khi người dùng bấm Ctrl+C
- SIGTERM yêu cầu tiến trình kết thúc một cách lịch sự, tiến trình có thể bắt để dọn dẹp; là mặc định của lệnh kill
- SIGKILL buộc tiến trình dừng ngay, không thể bắt hay bỏ qua, nên không có cơ hội dọn dẹp
- Nên gửi SIGTERM trước, chỉ dùng SIGKILL khi tiến trình không phản hồi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c23a8bea-f5bf-53fd-a568-8e4dbc8c16ee', 'Khi chỉnh sửa file cấu hình trên máy chủ, bạn làm thế nào để có thể hoàn tác thay đổi nếu có sự cố?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Sao lưu file trước khi sửa (bản copy kèm ngày giờ)
- Quản lý file cấu hình bằng hệ thống quản lý phiên bản như Git (ví dụ etckeeper)
- Dùng công cụ quản lý cấu hình (Ansible, Puppet) để cấu hình được khai báo và tái lập được
- Kiểm tra cú pháp cấu hình trước khi nạp lại dịch vụ (ví dụ nginx -t)
- Snapshot máy ảo hoặc ổ đĩa trước các thay đổi lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7941855a-c796-5a0e-acc7-8991d15f64e8', 'Vì sao cần lưu giữ các file log cũ?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phục vụ điều tra sự cố và tìm nguyên nhân gốc khi lỗi xảy ra
- Phục vụ điều tra bảo mật, phát hiện truy cập trái phép sau khi sự việc đã xảy ra
- Đáp ứng yêu cầu tuân thủ, pháp lý, kiểm toán về thời gian lưu trữ
- Phân tích xu hướng, hiệu năng và lập kế hoạch tài nguyên
- Cần có chính sách xoay vòng, nén, lưu trữ tập trung và thời hạn xoá rõ ràng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ee7258ff-4c1d-5cc3-ad18-ce22126b7f0e', 'Incremental backup là gì? Nó khác full backup và differential backup như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Full backup sao lưu toàn bộ dữ liệu mỗi lần
- Incremental backup chỉ sao lưu phần thay đổi kể từ lần sao lưu gần nhất (bất kể loại nào)
- Differential backup sao lưu phần thay đổi kể từ lần full backup gần nhất
- Incremental tiết kiệm dung lượng và thời gian sao lưu nhất nhưng khôi phục phải ghép full backup với toàn bộ chuỗi incremental
- Differential khôi phục nhanh hơn (chỉ cần full và bản differential cuối) nhưng dung lượng tăng dần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('21262e67-05f6-5d0a-af01-67179db62f49', 'RAID là gì? Bạn hãy giải thích RAID 0, RAID 1, RAID 5, RAID 6 và RAID 10.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- RAID kết hợp nhiều ổ đĩa để tăng hiệu năng, khả năng chịu lỗi hoặc cả hai
- RAID 0 chia dữ liệu (striping) lên các ổ: nhanh, tận dụng hết dung lượng nhưng hỏng một ổ là mất toàn bộ
- RAID 1 nhân bản (mirroring) dữ liệu: chịu được hỏng một ổ, mất một nửa dung lượng
- RAID 5 striping kèm parity, tối thiểu 3 ổ, chịu hỏng 1 ổ; RAID 6 có hai parity, chịu hỏng 2 ổ
- RAID 10 kết hợp mirroring và striping: nhanh và chịu lỗi tốt, mất một nửa dung lượng
- RAID không thay thế được backup', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e71773ff-6ac9-52f6-b886-3b84219eac95', 'Theo bạn, những điều quan trọng nhất cần hiểu về mô hình OSI là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- OSI chia việc truyền thông mạng thành 7 tầng, mỗi tầng có trách nhiệm riêng và chỉ giao tiếp với tầng kề
- Các tầng: Physical, Data Link, Network, Transport, Session, Presentation, Application
- Mỗi tầng đóng gói dữ liệu của tầng trên kèm header riêng (encapsulation)
- Giúp xác định vị trí sự cố khi xử lý lỗi mạng (ví dụ lỗi ở tầng 2 hay tầng 3)
- Thực tế dùng mô hình TCP/IP gọn hơn, nhưng thuật ngữ tầng OSI vẫn dùng phổ biến (thiết bị tầng 2, cân bằng tải tầng 7)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bb3064fb-0ce2-5249-a903-3bcc22cfd5d8', 'VLAN và subnet khác nhau như thế nào? Có cần VLAN để tạo subnet không?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- VLAN hoạt động ở tầng 2, chia một switch vật lý thành nhiều miền broadcast logic
- Subnet hoạt động ở tầng 3, chia dải địa chỉ IP thành các mạng con
- Thường mỗi VLAN tương ứng với một subnet để dễ quản lý và định tuyến
- Không bắt buộc cần VLAN để tạo subnet; nhiều subnet có thể cùng chạy trên một mạng tầng 2
- Muốn các VLAN giao tiếp với nhau cần thiết bị định tuyến tầng 3', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a27d972e-83a4-597f-84ab-288cf3b03ef4', 'Bạn hãy kể một số cổng mạng (port) phổ biến mà một quản trị hệ thống cần biết.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SSH 22, HTTP 80, HTTPS 443
- DNS 53 (UDP và TCP)
- SMTP 25 (587 cho gửi mail có xác thực), FTP 20 và 21
- Cơ sở dữ liệu: MySQL 3306, PostgreSQL 5432, Redis 6379
- Biết port giúp cấu hình firewall và xử lý sự cố kết nối', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('696abf52-8e86-52b5-9b33-eb64485296aa', '127.0.0.1 và localhost khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- 127.0.0.1 là địa chỉ IPv4 loopback, trỏ về chính máy hiện tại
- localhost là tên miền, phải phân giải (thường qua /etc/hosts) thành địa chỉ loopback
- localhost có thể phân giải thành ::1 (IPv6) thay vì 127.0.0.1
- Một số chương trình xử lý khác nhau, ví dụ MySQL client với localhost sẽ kết nối qua Unix socket thay vì TCP', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2548b013-293c-5efa-84df-d95f5067b250', 'Lệnh ping dùng cổng (port) nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ping không dùng port nào
- ping dùng giao thức ICMP với gói echo request và echo reply, nằm ở tầng mạng (tầng 3)
- Khái niệm port chỉ có ở tầng transport như TCP và UDP
- Firewall chặn ICMP thì ping thất bại dù dịch vụ khác vẫn hoạt động', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9c969bba-c937-5e41-875c-6f213bd508b6', 'Máy chủ A không kết nối được tới máy chủ B. Bạn sẽ kiểm tra những nguyên nhân nào theo các bước ra sao?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Kiểm tra theo từng tầng: kết nối vật lý và giao diện mạng có hoạt động không
- Kiểm tra cấu hình IP, subnet, gateway, bảng định tuyến ở cả hai phía
- Kiểm tra phân giải tên miền nếu kết nối bằng hostname
- Kiểm tra kết nối tầng 3 bằng ping, traceroute; kiểm tra port bằng nc hoặc telnet
- Kiểm tra firewall, security group, ACL ở hai phía và trên đường đi
- Kiểm tra dịch vụ trên B có đang lắng nghe đúng địa chỉ và port không, xem log', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0edd57f8-5b25-508c-8785-b13454840adb', 'Máy chủ không phân giải được tên miền. Bạn sẽ kiểm tra và xử lý như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Kiểm tra cấu hình DNS resolver (/etc/resolv.conf hoặc systemd-resolved) có máy chủ DNS đúng không
- Kiểm tra thứ tự tra cứu trong /etc/nsswitch.conf và nội dung /etc/hosts
- Thử truy vấn trực tiếp bằng dig hoặc nslookup tới DNS server cụ thể
- Kiểm tra kết nối tới DNS server và firewall có chặn port 53 UDP/TCP không
- Kiểm tra bản ghi DNS của tên miền có tồn tại và đúng không', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6bbfe8ad-0dd3-5e31-a07b-715f28f8b562', 'Vì sao không nên dùng telnet để quản trị hệ thống từ xa?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Telnet truyền dữ liệu, kể cả tên đăng nhập và mật khẩu, dưới dạng văn bản không mã hoá
- Kẻ tấn công trên đường truyền có thể nghe lén và lấy thông tin đăng nhập
- Không có cơ chế xác thực máy chủ nên dễ bị tấn công man-in-the-middle
- Nên dùng SSH: mã hoá, xác thực máy chủ, hỗ trợ đăng nhập bằng khoá
- Telnet chỉ nên dùng để kiểm tra kết nối tới một port', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e3c3158b-64d7-5e35-97d6-c93a60d4a0a1', 'SSH là gì và hoạt động như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SSH (Secure Shell) là giao thức truy cập và quản trị máy từ xa qua kênh mã hoá, mặc định port 22
- Khi kết nối, hai bên thoả thuận thuật toán và trao đổi khoá (ví dụ Diffie-Hellman) để tạo khoá phiên mã hoá
- Client xác minh máy chủ bằng host key (lưu trong known_hosts)
- Người dùng xác thực bằng mật khẩu hoặc cặp khoá công khai/bí mật
- Ngoài shell từ xa còn hỗ trợ truyền file (scp, sftp) và port forwarding', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2942f839-acb1-59c8-a5ea-397b51d6e1ea', 'Vì sao xác thực SSH bằng khoá được coi là an toàn hơn xác thực bằng mật khẩu?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khoá bí mật dài và ngẫu nhiên nên gần như không thể dò bằng brute force như mật khẩu
- Khoá bí mật không bao giờ được gửi lên máy chủ, chỉ dùng để ký chứng minh danh tính
- Máy chủ giả mạo không thu được thông tin đăng nhập có thể dùng lại
- Có thể bảo vệ khoá bí mật bằng passphrase và quản lý quyền theo từng khoá
- Cho phép tắt hẳn đăng nhập bằng mật khẩu để chặn tấn công dò mật khẩu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c9a4dd07-3060-50a4-a094-2623c717114f', 'Packet filter là gì và hoạt động như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Packet filter là kỹ thuật firewall kiểm soát truy cập bằng cách kiểm tra từng gói tin
- Quyết định cho qua hay chặn dựa trên luật: địa chỉ IP nguồn/đích, port, giao thức, giao diện mạng
- Stateless filter xét từng gói độc lập; stateful filter theo dõi trạng thái kết nối nên cho phép gói trả lời hợp lệ
- Luật được xét theo thứ tự, áp dụng luật khớp đầu tiên hoặc chính sách mặc định
- Ví dụ: iptables/nftables trên Linux, pf trên BSD', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('229c78ad-3010-5c43-903d-b748ce3587e3', 'Dùng reverse proxy mang lại những lợi ích gì?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ẩn cấu trúc và địa chỉ của các máy chủ backend phía sau
- Cân bằng tải giữa nhiều máy chủ backend
- Kết thúc TLS (SSL termination) tập trung, giảm tải cho backend
- Cache nội dung, nén dữ liệu, giới hạn tốc độ request
- Là điểm tập trung để áp dụng bảo mật (WAF), ghi log và định tuyến theo đường dẫn hoặc tên miền', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('86edddec-31bb-54cd-9850-4686a9aab230', 'Router và gateway khác nhau như thế nào? Default gateway là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Router là thiết bị chuyển tiếp gói tin giữa các mạng ở tầng 3 dựa trên bảng định tuyến
- Gateway là điểm nối giữa hai mạng, có thể khác giao thức; trong thực tế thường là một router
- Default gateway là địa chỉ mà máy gửi gói tin tới khi đích không thuộc mạng cục bộ và không khớp tuyến nào khác
- Thiếu hoặc sai default gateway thì máy chỉ liên lạc được trong cùng subnet', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('28721e7a-b0fb-5c4f-bf85-e25c06df979c', 'Bạn hãy giải thích chức năng của các bản ghi DNS: A, CNAME, MX, PTR và SOA.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- A ánh xạ tên miền tới địa chỉ IPv4 (AAAA cho IPv6)
- CNAME đặt bí danh, trỏ một tên miền tới tên miền khác
- MX chỉ định máy chủ nhận email cho tên miền, kèm độ ưu tiên
- PTR dùng cho tra cứu ngược, ánh xạ địa chỉ IP về tên miền
- SOA chứa thông tin quản lý của zone: máy chủ chính, email quản trị, số serial, thời gian làm mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a8d0c616-5243-5190-a4ac-9dee7c26c458', 'Vì sao không dùng địa chỉ MAC thay cho địa chỉ IP để định tuyến trên mạng?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Địa chỉ MAC phẳng, gắn với phần cứng, không phản ánh vị trí trong mạng
- Router không thể gom nhóm địa chỉ MAC, bảng định tuyến sẽ phải chứa từng thiết bị trên thế giới
- Địa chỉ IP có cấu trúc phân cấp (mạng và host) nên định tuyến gom theo prefix được
- MAC chỉ có ý nghĩa trong một phân đoạn tầng 2, còn IP thuộc tầng 3 để đi qua nhiều mạng
- Tách hai tầng giúp thay phần cứng mà không đổi địa chỉ logic', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1831fcc-aad7-5335-8591-34a6b42a07d7', 'Subnet mask nhỏ nhất dùng được cho một mạng có tối đa 30 thiết bị là gì? Hãy giải thích cách tính.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cần ít nhất 30 địa chỉ host cộng thêm địa chỉ mạng và địa chỉ broadcast
- Với n bit host, số host dùng được là 2^n - 2
- 5 bit host cho 2^5 - 2 = 30 host là vừa đủ
- Vậy prefix là /27, tương ứng mask 255.255.255.224', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cfe029e8-0a6b-5792-a138-b525b21e04ec', 'Bạn hãy kể một số mã trạng thái HTTP phổ biến và ý nghĩa của chúng.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nhóm 1xx thông tin, 2xx thành công, 3xx chuyển hướng, 4xx lỗi phía client, 5xx lỗi phía server
- 200 OK, 201 Created, 204 No Content
- 301 chuyển hướng vĩnh viễn, 302 chuyển hướng tạm thời, 304 Not Modified
- 400 Bad Request, 401 chưa xác thực, 403 không có quyền, 404 không tìm thấy, 429 quá nhiều request
- 500 lỗi máy chủ, 502 Bad Gateway, 503 dịch vụ không sẵn sàng, 504 Gateway Timeout', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bbcebe59-e123-57ab-9d3d-7eba0a95f6d8', 'DevOps là gì? Theo bạn, cách mọi người giao tiếp hay công cụ được chọn quan trọng hơn với thành công của DevOps?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- DevOps là văn hoá và tập hợp thực hành kết hợp phát triển (Dev) và vận hành (Ops) để giao phần mềm nhanh và ổn định hơn
- Các thực hành chính: CI/CD, hạ tầng dưới dạng code, giám sát, tự động hoá
- Con người và cách giao tiếp quan trọng hơn: phá rào cản giữa các nhóm, chia sẻ trách nhiệm, phản hồi nhanh
- Công cụ chỉ hỗ trợ; công cụ tốt mà văn hoá rời rạc thì DevOps không hiệu quả
- Đo lường bằng các chỉ số như tần suất deploy, thời gian khôi phục, tỉ lệ lỗi khi thay đổi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8405c530-2b03-53cd-852d-20d93f558c0f', 'Hệ thống quản lý phiên bản là gì? Thế nào là một commit message tốt?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hệ thống quản lý phiên bản ghi lại lịch sử thay đổi của file theo thời gian, cho phép quay lại phiên bản cũ
- Hỗ trợ làm việc nhóm qua nhánh, merge, review; ví dụ Git
- Commit message tốt có dòng tiêu đề ngắn (khoảng 50 ký tự) ở thể mệnh lệnh, mô tả thay đổi gì
- Phần thân giải thích lý do thay đổi, không chỉ lặp lại nội dung code
- Mỗi commit nên là một thay đổi logic, có thể tham chiếu mã ticket', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb3f3c41-ac67-5325-8456-07cde95760c6', 'Bạn hãy mô tả một pipeline Continuous Integration đơn giản.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi lần push hoặc tạo pull request sẽ kích hoạt pipeline tự động
- Lấy code, cài dependency, build ứng dụng
- Chạy kiểm tra: lint, unit test, integration test, quét bảo mật
- Đóng gói artifact (ví dụ Docker image) và lưu vào registry
- Thông báo kết quả; nếu có Continuous Delivery thì triển khai tiếp lên môi trường staging rồi production
- Pipeline thất bại thì chặn merge để giữ nhánh chính luôn ổn định', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26b3ebc8-627b-54ec-9e45-b757dbdd72a4', 'Security misconfiguration là gì? Hãy lấy ví dụ.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là lỗ hổng do hệ thống, ứng dụng hoặc mạng được cấu hình sai hoặc không an toàn
- Ví dụ: dùng tài khoản và mật khẩu mặc định, bật dịch vụ hoặc port không cần thiết
- Lộ thông báo lỗi chi tiết, bật directory listing, để trang quản trị công khai
- Phân quyền quá rộng, ví dụ bucket lưu trữ công khai
- Phòng tránh bằng quy trình hardening, cấu hình tự động hoá, rà soát và quét định kỳ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e22d3750-f3ec-561d-b78c-27b04507fbd5', 'Hãy kể về kinh nghiệm của bạn khi làm việc với môi trường production.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh hệ thống -> nhiệm vụ của bạn -> hành động cụ thể -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26891e49-9528-5288-92c1-f9aec580c01e', 'Bạn sẽ chọn bản phân phối Linux nào để chạy một web server quan trọng? Vì sao?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ưu tiên bản phân phối ổn định, có chu kỳ hỗ trợ dài (LTS)
- Ví dụ: Ubuntu LTS, Debian stable, RHEL hoặc các bản tương thích như Rocky Linux, AlmaLinux
- Tiêu chí: thời gian nhận bản vá bảo mật, hệ sinh thái gói, hỗ trợ thương mại nếu cần
- Kinh nghiệm của đội ngũ và sự đồng nhất với hạ tầng hiện có
- Khả năng tự động hoá và tương thích với công cụ quản lý cấu hình, container', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('245d12dc-caa2-55a1-9494-2e706510df05', 'Bạn hãy trình bày ngắn gọn quá trình khởi động của hệ điều hành Linux.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- BIOS/UEFI kiểm tra phần cứng (POST) và tìm thiết bị khởi động
- Bootloader (ví dụ GRUB) nạp kernel và initramfs vào bộ nhớ
- Kernel khởi tạo phần cứng, nạp driver, mount root filesystem
- Kernel chạy tiến trình đầu tiên PID 1 (systemd hoặc init)
- systemd khởi động các dịch vụ theo target (runlevel) rồi hiển thị màn hình đăng nhập', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3bb83769-bc09-5926-90a9-f89c0d99fa19', 'Vì sao một số daemon cần quyền root để khởi động rồi lại hạ quyền (drop privileges)? Việc này diễn ra như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Một số thao tác cần quyền root, ví dụ bind vào port nhỏ hơn 1024 hoặc đọc khoá TLS
- Chạy lâu dài với quyền root rất nguy hiểm: nếu daemon bị khai thác, kẻ tấn công có toàn quyền hệ thống
- Daemon khởi động bằng root, làm xong các việc cần quyền rồi chuyển sang user ít quyền (setuid, setgid)
- Ví dụ nginx: tiến trình master chạy root, các worker chạy bằng user www-data
- Theo nguyên tắc đặc quyền tối thiểu; thay thế khác là dùng capabilities như CAP_NET_BIND_SERVICE', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9ca5df09-fc28-51ac-8907-ccf2897a6c07', 'Load average là gì? Vì sao load 1.00 trên máy một nhân CPU chưa phải là lý tưởng?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Load average là số tiến trình trung bình đang chạy hoặc chờ CPU (và chờ I/O trên Linux) trong 1, 5, 15 phút
- Phải so với số nhân CPU: load bằng số nhân nghĩa là CPU đang dùng hết công suất
- Load 1.00 trên máy một nhân nghĩa là không còn dư địa, chỉ cần tải tăng thêm là tiến trình phải xếp hàng
- Thực tế nên giữ load dưới khoảng 0.7 trên mỗi nhân để có khoảng an toàn
- Load cao có thể do CPU hoặc do chờ I/O, cần xem thêm công cụ khác để phân biệt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7439f586-8a68-5de2-b53f-39327f67dd69', 'Real user ID và effective user ID khác nhau như thế nào? Điều gì xảy ra khi effective user là root nhưng real user vẫn là bạn?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Real UID là người dùng thực sự khởi chạy tiến trình
- Effective UID là danh tính hệ thống dùng để kiểm tra quyền truy cập của tiến trình
- Khi chạy chương trình có bit SUID của root (ví dụ passwd), effective UID là root còn real UID vẫn là bạn
- Tiến trình có quyền root tạm thời để làm việc cần thiết, nhưng vẫn biết ai là người gọi
- Chương trình có thể hạ quyền về real UID sau khi làm xong việc cần đặc quyền', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61a80260-dc0f-59f3-8bc9-4d0fb11e328d', 'Một cron job do developer thêm vào sinh ra file log rất lớn. Bạn xử lý thế nào để log không phình quá mức?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng logrotate để xoay vòng log theo kích thước hoặc thời gian, nén và giữ số bản giới hạn
- Trao đổi với developer để giảm mức log (log level) hoặc bỏ log không cần thiết
- Chuyển log sang hệ thống ghi log tập trung (journald, syslog, ELK) có chính sách lưu trữ
- Giám sát dung lượng đĩa và cảnh báo trước khi đầy
- Đặt log trên phân vùng riêng để không làm đầy phân vùng hệ thống', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2e2dc22f-3130-5910-af83-d4dd19884e83', 'Kernel Linux tạo, quản lý và kết thúc tiến trình như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tiến trình mới được tạo bằng fork (hoặc clone) nhân bản tiến trình cha, rồi thường gọi exec để nạp chương trình mới
- Kernel quản lý mỗi tiến trình qua cấu trúc mô tả (task_struct) gồm PID, trạng thái, bộ nhớ, file đang mở
- Bộ lập lịch (scheduler) phân chia thời gian CPU giữa các tiến trình theo độ ưu tiên
- Tiến trình kết thúc bằng exit; tiến trình cha thu kết quả bằng wait, nếu không sẽ thành zombie
- Tiến trình mồ côi được nhận nuôi bởi PID 1', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c3276d6b-f741-54c4-b91f-0aaee94c029d', 'Các thông tin chính trong top hoặc htop là gì? Bạn dùng chúng để chẩn đoán tải cao, CPU user cao hoặc hết bộ nhớ như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Phần đầu: load average, số tiến trình, phân bổ CPU (us, sy, wa, id), bộ nhớ và swap
- Danh sách tiến trình: PID, user, %CPU, %MEM, RES, trạng thái, thời gian chạy
- CPU user cao: sắp xếp theo %CPU để tìm tiến trình ứng dụng tiêu tốn CPU
- wa cao kèm load cao: nghẽn I/O đĩa, cần xem thêm iostat, iotop
- Hết bộ nhớ: sắp xếp theo %MEM, theo dõi swap tăng, kiểm tra log của OOM killer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cef0740e-6d1b-5174-8ce1-2bb8fd0ca70b', 'Bạn cần nâng cấp một dịch vụ trên 200 máy chủ. Cách tốt nhất để làm việc này là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng công cụ quản lý cấu hình hoặc tự động hoá như Ansible, Puppet, Chef, Salt thay vì làm tay
- Thử nghiệm trên môi trường staging hoặc một nhóm nhỏ máy trước
- Triển khai cuốn chiếu (rolling) theo từng đợt, theo dõi lỗi sau mỗi đợt
- Chuẩn bị phương án rollback
- Với hạ tầng bất biến, xây image mới rồi thay máy cũ thay vì nâng cấp tại chỗ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('23ac5528-28d0-5d87-99eb-9dd9ad8cd5cc', 'Mức dùng swap quá cao có thể do những nguyên nhân nào và bạn xử lý ra sao?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Swap là vùng trên đĩa dùng khi RAM không đủ; truy cập chậm hơn RAM rất nhiều
- Nguyên nhân: thiếu RAM so với tải, tiến trình rò rỉ bộ nhớ, cấu hình ứng dụng dùng quá nhiều bộ nhớ
- Xác định tiến trình dùng nhiều bộ nhớ, theo dõi si/so trong vmstat để biết swap có đang diễn ra liên tục
- Xử lý: tối ưu hoặc giới hạn bộ nhớ ứng dụng, sửa rò rỉ, thêm RAM
- Có thể điều chỉnh vm.swappiness để kernel ít swap hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3fdfa0f8-d213-5a83-818f-8a597223fb4b', 'umask là gì? Bạn hãy giải thích sự khác nhau giữa các giá trị umask phổ biến như 022, 002 và 077.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- umask xác định những quyền bị loại bỏ khỏi quyền mặc định khi tạo file và thư mục mới
- Quyền mặc định gốc là 666 cho file và 777 cho thư mục, trừ đi umask
- 022: file 644, thư mục 755; chỉ chủ sở hữu được ghi
- 002: file 664, thư mục 775; nhóm cũng được ghi, hợp với làm việc nhóm
- 077: file 600, thư mục 700; chỉ chủ sở hữu truy cập được
- Đặt cố định cho user trong file khởi tạo shell hoặc cấu hình PAM, login.defs', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cac896fc-8c3b-516c-b667-2a961638ba93', 'Symbolic link và hard link khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hard link là một tên khác trỏ tới cùng inode, cùng dữ liệu với file gốc
- Xoá một tên thì dữ liệu vẫn còn cho tới khi không còn hard link nào
- Hard link không trỏ được tới thư mục và không vượt qua filesystem khác
- Symbolic link là file đặc biệt chứa đường dẫn tới file đích, có inode riêng
- Symlink trỏ được tới thư mục, vượt filesystem, nhưng bị hỏng nếu file đích bị xoá hoặc di chuyển', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1c7f6747-18de-59b7-972b-728db8dc6ea7', 'Sticky bit hoạt động như thế nào? SUID và SGID có giống sticky bit không?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Sticky bit trên thư mục: chỉ chủ file (hoặc root) mới được xoá hoặc đổi tên file trong thư mục đó, ví dụ /tmp
- SUID trên file thực thi: chương trình chạy với quyền của chủ sở hữu file, ví dụ passwd
- SGID trên file thực thi chạy với quyền nhóm của file; trên thư mục thì file mới tạo kế thừa nhóm của thư mục
- Ba bit này khác nhau về mục đích
- SUID/SGID cần dùng cẩn thận vì là bề mặt tấn công leo thang đặc quyền', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5760f445-8a3a-5bde-a4e4-d17ae9eb21f3', 'Bạn thiết kế hệ thống như thế nào để ứng dụng web có tính sẵn sàng cao (high availability)?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Loại bỏ điểm lỗi đơn lẻ: chạy nhiều instance ứng dụng phía sau load balancer
- Load balancer cũng phải dự phòng (cặp active-passive, dịch vụ cloud)
- Cơ sở dữ liệu có bản sao (replication) và cơ chế failover tự động
- Phân bố trên nhiều vùng sẵn sàng hoặc trung tâm dữ liệu; ứng dụng stateless, session lưu ngoài
- Health check, giám sát, cảnh báo, sao lưu và quy trình khôi phục được diễn tập', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a80ca2ae-4927-582b-86a3-78777ef25ba8', 'Khi cấu hình máy chủ mới, bạn phân quyền cho các thư mục ứng dụng như thế nào và cần tránh những sai lầm gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định rõ user nào chạy ứng dụng, ai được đọc, ai được ghi
- Tạo user và nhóm riêng cho ứng dụng, không chạy ứng dụng bằng root
- Áp dụng đặc quyền tối thiểu: code chỉ đọc, chỉ cho ghi ở thư mục cần thiết như log, upload
- Sai lầm cần tránh: chmod 777, để file cấu hình chứa mật khẩu đọc được bởi mọi người
- Thư mục upload không được phép thực thi script; dùng ACL khi cần phân quyền chi tiết', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b0c13bc9-856a-5f71-9000-ce60c762f272', 'Làm thế nào để thay đổi tham số kernel? Bạn thường tinh chỉnh những tham số nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng sysctl để đọc và đổi tham số lúc chạy (thông qua /proc/sys)
- Ghi vào /etc/sysctl.conf hoặc /etc/sysctl.d/ để giữ sau khi khởi động lại
- Tham số mạng: net.core.somaxconn, dải port tạm, kích thước buffer TCP, bật ip_forward cho router
- Tham số bộ nhớ: vm.swappiness, vm.overcommit_memory
- Tham số file: fs.file-max; thay đổi phải được thử nghiệm và đo lường trước', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7f2c0371-44c9-54a5-96c7-aadf2b0cb98a', 'Bạn hãy giải thích filesystem /proc.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- /proc là filesystem ảo do kernel tạo ra trong bộ nhớ, không nằm trên đĩa
- Cung cấp thông tin về kernel, phần cứng và tiến trình đang chạy
- Mỗi tiến trình có thư mục /proc/PID chứa trạng thái, lệnh chạy, file đang mở, bộ nhớ
- Các file như /proc/cpuinfo, /proc/meminfo, /proc/loadavg cho thông tin hệ thống
- /proc/sys cho phép đọc và thay đổi tham số kernel lúc chạy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f0dea84f-85fd-54a5-aedf-a0d776503691', 'Bạn hãy mô tả quy trình sao lưu dữ liệu của bạn. Bao lâu nên kiểm tra khôi phục bản sao lưu một lần?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định dữ liệu cần sao lưu và mục tiêu RPO, RTO
- Áp dụng quy tắc 3-2-1: 3 bản sao, trên 2 loại phương tiện, 1 bản ở nơi khác (offsite)
- Kết hợp full và incremental, tự động hoá, mã hoá và giám sát kết quả sao lưu
- Kiểm tra khôi phục định kỳ (ví dụ hằng tháng hoặc hằng quý) và sau mỗi thay đổi lớn
- Bản sao lưu chưa từng khôi phục thử thì không thể tin cậy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e69d6ebd-8e27-55ac-9f3f-9ce990239d7a', 'Journaling trên filesystem ext3/ext4 là gì? Có những chế độ journaling nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Journaling ghi trước các thay đổi vào nhật ký để khôi phục nhất quán sau khi mất điện hoặc sập
- Chế độ journal: ghi cả dữ liệu và metadata vào journal; an toàn nhất nhưng chậm nhất
- Chế độ ordered (mặc định): chỉ journal metadata, nhưng dữ liệu được ghi xuống đĩa trước metadata
- Chế độ writeback: chỉ journal metadata, không đảm bảo thứ tự; nhanh nhất nhưng có thể thấy dữ liệu cũ sau sự cố', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('95d45cdb-904c-5bdd-a4ec-9ee6990577d7', 'Inode là gì? Bạn có thể dùng số inode của file vào việc gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Inode là cấu trúc dữ liệu lưu metadata của file: quyền, chủ sở hữu, kích thước, thời gian, vị trí các block dữ liệu
- Inode không chứa tên file; tên nằm trong thư mục, trỏ tới số inode
- Xem số inode bằng ls -i hoặc stat
- Dùng để xoá file có tên đặc biệt khó gõ, tìm các hard link của cùng một file
- Filesystem có thể hết inode dù vẫn còn dung lượng khi có quá nhiều file nhỏ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ae408ec1-7208-5c02-9cbc-df62dd76f32c', 'LVM là gì? Dùng LVM mang lại những lợi ích gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- LVM (Logical Volume Manager) tạo lớp trừu tượng giữa ổ đĩa vật lý và filesystem: physical volume, volume group, logical volume
- Mở rộng hoặc thu nhỏ logical volume linh hoạt, thêm ổ mới vào volume group
- Gộp nhiều ổ đĩa thành một không gian lưu trữ
- Hỗ trợ snapshot để sao lưu nhất quán
- Di chuyển dữ liệu giữa các ổ khi hệ thống đang chạy; đổi lại tăng độ phức tạp khi khôi phục', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('344962c2-6296-5088-b23c-23d71406bae3', 'Zombie process (defunct) là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là tiến trình đã kết thúc nhưng vẫn còn mục trong bảng tiến trình
- Tồn tại vì tiến trình cha chưa gọi wait để lấy trạng thái thoát
- Zombie không dùng CPU hay bộ nhớ nhưng chiếm một PID
- Không thể kill zombie; phải để tiến trình cha thu dọn hoặc kết thúc tiến trình cha để PID 1 nhận nuôi và dọn
- Nhiều zombie tích tụ là dấu hiệu lỗi ở chương trình cha', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('69dbd25c-aaf7-51d9-b444-5692ac68406a', 'Cách đúng để cập nhật hệ thống trên môi trường production là gì? Bạn có tự động hoá và có lên lịch downtime không?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Theo dõi bản vá bảo mật và phân loại mức độ ưu tiên
- Thử nghiệm cập nhật trên staging giống production trước
- Tự động hoá bằng công cụ quản lý cấu hình, cập nhật cuốn chiếu từng nhóm máy
- Thông báo và lên lịch bảo trì cho thay đổi có rủi ro; thiết kế dự phòng để không cần downtime
- Sao lưu hoặc snapshot trước khi cập nhật, có kế hoạch rollback và giám sát sau cập nhật', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1f11741a-00da-5f71-8823-cce9c0fb0d9e', 'Vì sao không nên dùng kill -9 ngay khi muốn dừng một tiến trình? Cách dừng tiến trình đúng là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- kill -9 gửi SIGKILL, tiến trình bị dừng ngay mà không kịp dọn dẹp
- Có thể gây mất dữ liệu, file tạm và lock file còn sót, kết nối không được đóng đúng cách, tiến trình con mồ côi
- Nên gửi SIGTERM trước để tiến trình tự kết thúc an toàn
- Chờ một khoảng thời gian, nếu không dừng mới thử SIGINT, SIGHUP rồi cuối cùng mới SIGKILL
- Với dịch vụ nên dừng qua trình quản lý dịch vụ như systemctl stop', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cfc1ea3d-7b52-5012-b1c3-bdf810bf1236', 'strace là gì và bạn dùng nó để xử lý sự cố như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- strace theo dõi các system call và tín hiệu mà một tiến trình thực hiện
- Dùng để xem chương trình mở file nào, kết nối tới đâu, bị lỗi ở system call nào
- Có thể gắn vào tiến trình đang chạy theo PID mà không cần khởi động lại
- Có thể lọc theo loại system call và đo thời gian từng lời gọi để tìm điểm chậm
- Ví dụ: tìm ra ứng dụng lỗi vì không đọc được file cấu hình do sai quyền', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('63a38256-1954-50c3-8e93-93f5b8e5bca3', 'Khi nào bạn dùng ACL thay vì hoặc kết hợp với chmod?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- chmod chỉ phân quyền cho ba đối tượng: chủ sở hữu, nhóm và người khác
- ACL cho phép cấp quyền chi tiết cho nhiều user hoặc nhóm cụ thể trên cùng một file, thư mục
- Dùng khi nhiều nhóm cần quyền khác nhau mà không muốn tạo nhóm trung gian hoặc đổi chủ sở hữu
- ACL mặc định trên thư mục giúp file mới tạo tự kế thừa quyền
- Quản lý bằng setfacl và getfacl; filesystem phải hỗ trợ ACL', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9acc7838-fbbf-5605-8194-754d6b4aa786', 'ulimit dùng để làm gì? Soft limit và hard limit khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ulimit giới hạn tài nguyên một user hoặc tiến trình được dùng: số file mở, số tiến trình, kích thước core dump, bộ nhớ
- Giúp ngăn một tiến trình làm cạn tài nguyên của cả hệ thống
- Soft limit là giới hạn đang áp dụng, user có thể tự tăng tới mức hard limit
- Hard limit là trần tối đa, chỉ root mới tăng được
- Cấu hình cố định trong /etc/security/limits.conf hoặc LimitNOFILE trong unit systemd', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('84c7ff6b-4b07-5e95-8eaf-0f8f383606f8', 'Bạn hãy giải thích những khái niệm cơ bản của SELinux và cách xử lý khi SELinux chặn một dịch vụ.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- SELinux là cơ chế kiểm soát truy cập bắt buộc (MAC), bổ sung cho phân quyền thông thường
- Mỗi tiến trình, file, port có security context (nhãn); chính sách quy định context nào được truy cập context nào
- Ba chế độ: enforcing, permissive, disabled
- Khi bị chặn, xem log audit (audit.log, ausearch) để thấy thông báo AVC denied
- Xử lý đúng cách: bật boolean phù hợp, gán đúng nhãn cho file hoặc port, hoặc viết module chính sách; không nên tắt hẳn SELinux', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2090c4f2-b808-5ed6-bb1b-f2d087e1c7cf', 'Bạn đã cấu hình đăng nhập SSH bằng khoá nhưng máy chủ vẫn từ chối khoá. Bạn sẽ tìm nguyên nhân ở đâu?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Phía client: chạy ssh với chế độ verbose để xem khoá nào được thử
- Phía server: xem log xác thực (auth.log, secure, journalctl) và tăng LogLevel của sshd nếu cần
- Kiểm tra public key đã nằm đúng trong authorized_keys của đúng user
- Kiểm tra quyền: thư mục home và .ssh không được để người khác ghi, authorized_keys nên là 600
- Kiểm tra cấu hình sshd có cho phép PubkeyAuthentication, thuật toán khoá được hỗ trợ, SELinux context của thư mục .ssh', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('63c780be-a13f-5119-8212-b87fa7016e86', 'Một quản lý dự án cần một máy chủ cơ sở dữ liệu mới. Bạn sẽ hỏi họ những gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống và yêu cầu -> nêu các bước bạn sẽ làm -> giải thích lý do và rủi ro cần lưu ý.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0cbae922-02a7-54c3-8edb-60cc10f22c57', 'Tài khoản nobody dùng để làm gì? Vì sao nên chạy dịch vụ bằng một user riêng thay vì dùng chung nobody?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- nobody là tài khoản không sở hữu file nào, không có quyền đặc biệt, dùng để chạy dịch vụ với quyền tối thiểu
- Nếu nhiều dịch vụ cùng chạy bằng nobody, một dịch vụ bị chiếm quyền có thể ảnh hưởng tới các dịch vụ khác
- User riêng cho từng dịch vụ (ví dụ www-data cho web server) giúp cô lập và phân quyền file chính xác
- Theo nguyên tắc đặc quyền tối thiểu
- User dịch vụ không cần shell đăng nhập và mật khẩu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d4f35079-1ed4-594e-aaa7-1d24e367a33f', 'Bạn cần chạy một lệnh mất rất nhiều thời gian qua SSH. Làm sao để tiến trình không bị dừng khi phiên SSH bị ngắt?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khi phiên SSH ngắt, các tiến trình con nhận SIGHUP và thường bị dừng
- Dùng nohup để tiến trình bỏ qua SIGHUP, ghi output ra file
- Dùng terminal multiplexer như tmux hoặc screen để có thể kết nối lại phiên làm việc
- Với tác vụ lâu dài nên chạy như một dịch vụ hoặc job được quản lý (systemd-run, hàng đợi job)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a25233bc-f9de-5399-bdc8-65fbae6c6440', 'Mục đích chính của intermediate certificate authority (CA trung gian) là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Root CA là gốc tin cậy, khoá bí mật cực kỳ quan trọng nên được giữ offline
- CA trung gian được root CA ký và dùng để ký chứng chỉ cho người dùng cuối
- Nếu CA trung gian bị lộ, có thể thu hồi nó mà không phải thay root CA đã cài trên mọi thiết bị
- Tạo chuỗi tin cậy: chứng chỉ máy chủ, CA trung gian, root CA
- Máy chủ phải gửi kèm chứng chỉ trung gian, thiếu thì client có thể báo lỗi chứng chỉ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b3311adc-44b5-5775-b14a-aefecca093bf', 'Bạn được giao nhiệm vụ đồng bộ môi trường testing với production. Bạn sẽ thực hiện những bước nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định mục tiêu: những gì cần giống (phiên bản phần mềm, cấu hình, hạ tầng) và những gì được phép khác
- Mô tả hạ tầng và cấu hình bằng code (Terraform, Ansible) để hai môi trường dựng từ cùng nguồn
- Dùng cùng artifact hoặc image cho cả hai môi trường, chỉ khác biến cấu hình
- Dữ liệu: dùng bản sao đã ẩn danh hoá, không dùng trực tiếp dữ liệu thật của người dùng
- Tách biệt thông tin bí mật và kiểm tra định kỳ để phát hiện sai lệch cấu hình', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3e455941-13c6-52f9-b264-1149fd0c5f81', 'Công cụ giám sát báo website bị sập nhưng bạn vẫn telnet được tới port của web server. Bạn sẽ xử lý thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Telnet được nghĩa là dịch vụ đang lắng nghe, vấn đề nằm ở tầng ứng dụng
- Gửi thử request HTTP thật (curl) để xem mã trạng thái và thời gian phản hồi
- Kiểm tra log của web server và ứng dụng, các tiến trình worker có bị treo hoặc cạn không
- Kiểm tra các thành phần phía sau như cơ sở dữ liệu, cache, dịch vụ phụ thuộc
- Kiểm tra cấu hình virtual host, chứng chỉ TLS và chính công cụ giám sát có kiểm tra đúng URL không', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('48c55e3f-e8e4-5137-a5d4-2949fd220a0a', 'Bạn hãy trình bày một số cơ chế cân bằng tải phổ biến.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cân bằng tải tầng 4 dựa trên IP và port; tầng 7 dựa trên nội dung HTTP như đường dẫn, header
- Thuật toán: round robin, weighted round robin, least connections, IP hash
- DNS round robin là cách đơn giản nhưng không biết tình trạng máy chủ
- Health check để loại máy chủ lỗi khỏi nhóm
- Sticky session khi ứng dụng cần giữ phiên; tốt hơn là làm ứng dụng stateless', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('03336cda-ecac-55bd-a610-189b1136ec71', 'HTTP/1.1 và HTTP/2 khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HTTP/2 dùng định dạng nhị phân thay vì văn bản
- Multiplexing: nhiều request và response song song trên một kết nối TCP, giảm head-of-line blocking ở tầng HTTP
- Nén header bằng HPACK, giảm dữ liệu trùng lặp
- Hỗ trợ độ ưu tiên luồng
- Không còn cần các mẹo của HTTP/1.1 như domain sharding, gộp file; HTTP/3 tiếp tục chạy trên QUIC', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('82972a26-ac8c-56e0-8706-5bd5741551df', 'Đội phát triển báo lỗi 413 Request Entity Too Large khi gửi request POST lên API. Nguyên nhân là gì và xử lý ra sao?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Mã 413 nghĩa là phần thân request vượt quá giới hạn kích thước mà máy chủ cho phép
- Thường do giới hạn của reverse proxy hoặc web server, ví dụ client_max_body_size của Nginx (mặc định 1MB)
- Cũng có thể do giới hạn ở ứng dụng hoặc load balancer phía trước
- Tăng giới hạn ở đúng nơi cho đúng endpoint rồi nạp lại cấu hình
- Cân nhắc cách khác cho file lớn như upload trực tiếp lên object storage hoặc chia nhỏ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('274dd3e0-dcc7-5207-ac4a-e1450e5b4fcd', 'Bắt tay ba bước (3-way handshake) trong TCP là gì và vì sao cần ba bước?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Client gửi SYN kèm số thứ tự ban đầu
- Server trả SYN-ACK: xác nhận số thứ tự của client và gửi số thứ tự của mình
- Client gửi ACK xác nhận, kết nối được thiết lập
- Cần ba bước để cả hai bên đều xác nhận được bên kia nhận và gửi được, và thống nhất số thứ tự hai chiều
- Giúp loại bỏ các gói kết nối cũ bị trễ trên mạng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c2d542b1-5383-56a4-aec4-187842b8d80a', 'Vì sao UDP nhanh hơn TCP? Khi nào nên dùng UDP?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- UDP không cần thiết lập kết nối, không có bắt tay
- Không có cơ chế xác nhận, truyền lại, đảm bảo thứ tự, kiểm soát luồng và tắc nghẽn như TCP
- Header nhỏ hơn, độ trễ thấp hơn
- Đổi lại gói tin có thể mất, trùng hoặc sai thứ tự
- Dùng cho DNS, streaming, game, VoIP, nơi độ trễ quan trọng hơn độ tin cậy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('582a73db-42a1-54b3-a1c5-a31b601f4532', 'Theo bạn, những cấu hình OpenSSH nào quan trọng nhất để tăng cường bảo mật?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tắt đăng nhập trực tiếp bằng root (PermitRootLogin no)
- Tắt xác thực bằng mật khẩu, chỉ dùng khoá (PasswordAuthentication no)
- Giới hạn user hoặc nhóm được phép đăng nhập (AllowUsers, AllowGroups)
- Giới hạn số lần thử đăng nhập, thời gian chờ; kết hợp fail2ban
- Chỉ dùng thuật toán mã hoá mạnh, tắt các tính năng không cần như forwarding; có thể đổi port hoặc chỉ cho phép qua VPN/bastion', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0a6d81f6-a427-5fef-88a3-e7c53b51a0ca', 'NAT là gì và dùng để làm gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- NAT (Network Address Translation) chuyển đổi địa chỉ IP trong header gói tin khi đi qua router
- Cho phép nhiều máy dùng IP private truy cập Internet qua một hoặc vài IP public
- Giúp tiết kiệm địa chỉ IPv4
- SNAT/PAT đổi địa chỉ nguồn khi đi ra; DNAT (port forwarding) đổi địa chỉ đích để công khai dịch vụ bên trong
- Gián tiếp ẩn cấu trúc mạng nội bộ nhưng không thay thế firewall', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('343692e7-eb18-5411-9c0a-b98037135031', 'Giao thức Spanning Tree (STP) dùng để làm gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- STP hoạt động ở tầng 2, ngăn vòng lặp trong mạng có nhiều switch kết nối dự phòng
- Vòng lặp tầng 2 gây broadcast storm và làm sập mạng
- STP bầu root bridge và chặn các cổng thừa để tạo cấu trúc cây không vòng lặp
- Khi đường chính hỏng, cổng bị chặn được mở lại để đảm bảo dự phòng
- RSTP là phiên bản hội tụ nhanh hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce7e69e8-d763-5b75-b155-bf512add7e02', 'Thông báo Host key verification failed khi SSH tới máy chủ có nghĩa là gì? Bạn có chấp nhận khoá mới ngay không?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Host key của máy chủ khác với khoá đã lưu trong known_hosts từ lần kết nối trước
- Có thể do máy chủ được cài lại, đổi IP sang máy khác, hoặc đang bị tấn công man-in-the-middle
- Không nên tự động chấp nhận khoá mới
- Xác minh fingerprint của khoá mới qua kênh tin cậy (quản trị viên, console)
- Khi đã xác nhận an toàn mới xoá khoá cũ khỏi known_hosts và chấp nhận khoá mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('838a4c3a-1522-5f71-801d-67a0092c2a2c', 'Khi gặp lỗi connection reset by peer lúc gọi tới một dịch vụ, bạn sẽ xử lý như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Lỗi nghĩa là phía bên kia hoặc thiết bị trung gian gửi gói RST, đóng kết nối đột ngột
- Kiểm tra URL, host header, giao thức (HTTP hay HTTPS, phiên bản TLS) có đúng không
- Kiểm tra log của máy chủ đích và reverse proxy, dịch vụ có bị crash hoặc quá tải không
- Kiểm tra firewall, IPS, load balancer có cắt kết nối, giới hạn thời gian kết nối
- Dùng công cụ như curl chế độ verbose, tcpdump để xem gói RST đến từ đâu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('03d06821-0363-5d69-9b32-c7b001eaead7', 'Một developer để private key cá nhân trên máy chủ để deploy ứng dụng qua SSH. Vì sao làm vậy là sai và nên thay bằng cách nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Private key cá nhân phải chỉ nằm trên máy của người sở hữu; để trên server thì ai có quyền vào server đều có thể lấy và mạo danh
- Lộ key ảnh hưởng tới mọi hệ thống mà key đó truy cập được
- Cách tốt hơn: dùng deploy key riêng chỉ có quyền đọc với đúng repository
- Hoặc dùng SSH agent forwarding có kiểm soát, hoặc để pipeline CI/CD thực hiện deploy
- Lưu bí mật trong secret manager và giới hạn quyền của key', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bbdbaf32-89f2-5270-a221-de877812fac9', 'CORS và CSP khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cả hai đều là cơ chế bảo mật của trình duyệt cấu hình qua HTTP header, nhưng mục đích khác nhau
- CORS nới lỏng Same-Origin Policy: máy chủ cho phép origin nào được đọc response của mình qua JavaScript (Access-Control-Allow-Origin)
- CSP (Content-Security-Policy) giới hạn trang được tải và thực thi tài nguyên từ đâu: script, style, ảnh, frame
- CORS do máy chủ chứa tài nguyên quyết định; CSP do trang đang hiển thị quyết định
- CSP là lớp phòng thủ quan trọng chống XSS, còn CORS cấu hình sai có thể làm lộ dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0622ba90-1ea1-5f22-8285-9cf787a2ed7f', 'Bạn đã làm việc với những công cụ DevOps nào và chúng phối hợp với nhau ra sao trong quy trình của bạn?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Quản lý mã nguồn: Git (GitHub, GitLab)
- CI/CD: Jenkins, GitHub Actions, GitLab CI để build, test, deploy tự động
- Container và điều phối: Docker, Kubernetes
- Hạ tầng dưới dạng code và quản lý cấu hình: Terraform, Ansible
- Giám sát và log: Prometheus, Grafana, ELK
- Luồng chung: commit kích hoạt CI, build image, chạy test, deploy bằng công cụ hạ tầng, giám sát phản hồi lại cho đội phát triển', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1ad1dab7-89bb-58a3-aa9b-b9083768e840', 'Playbook trong Ansible là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Playbook là file YAML mô tả trạng thái mong muốn và các bước cấu hình, triển khai trên một nhóm máy
- Gồm các play, mỗi play áp dụng danh sách task cho nhóm host trong inventory
- Mỗi task gọi một module (cài gói, sao chép file, khởi động dịch vụ)
- Các task nên idempotent: chạy lại nhiều lần cho cùng kết quả
- Hỗ trợ biến, template, handler, role để tái sử dụng; Ansible chạy agentless qua SSH', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5683d916-552b-5919-af62-4d20e2586e6d', 'Trong giám sát hệ thống, kiểm tra chủ động (active check) và bị động (passive check) khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Active check: máy chủ giám sát chủ động gọi tới đối tượng theo lịch để kiểm tra (mô hình pull)
- Passive check: đối tượng hoặc ứng dụng tự gửi kết quả về hệ thống giám sát (mô hình push)
- Active check đơn giản, chủ động phát hiện mất kết nối
- Passive check hợp với tác vụ bất đồng bộ như job sao lưu, máy nằm sau firewall
- Với passive check cần cảnh báo khi quá thời gian không nhận được kết quả', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bf509d95-d929-5ac8-995f-3fd36e47cd1b', 'Redis là gì? Dùng Redis có những ưu điểm gì?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Redis là kho dữ liệu key-value lưu trong bộ nhớ, tốc độ đọc ghi rất cao
- Hỗ trợ nhiều cấu trúc dữ liệu: string, hash, list, set, sorted set, stream
- Thường dùng làm cache, lưu session, hàng đợi, rate limit, bảng xếp hạng, pub/sub
- Có cơ chế lưu xuống đĩa (RDB, AOF), replication, Sentinel và cluster cho tính sẵn sàng
- Hạn chế: dữ liệu bị giới hạn bởi RAM', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eec90b45-02d4-52d2-bbfa-1ad97df90121', 'XSS là gì và bạn phòng chống nó như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- XSS (Cross-Site Scripting) là lỗ hổng cho phép kẻ tấn công chèn script độc hại chạy trong trình duyệt của người dùng khác
- Ba loại chính: stored, reflected, DOM-based
- Hậu quả: đánh cắp cookie, phiên đăng nhập, thực hiện hành động thay người dùng
- Phòng chống: escape dữ liệu theo ngữ cảnh khi hiển thị, validate đầu vào, làm sạch HTML
- Đặt Content-Security-Policy, cookie HttpOnly, dùng framework tự escape', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f8035aa9-448e-58c5-ba2d-bc020c536b8b', 'HIDS và NIDS khác nhau như thế nào? Loại nào tốt hơn?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HIDS (Host-based IDS) chạy trên từng máy, giám sát log, tính toàn vẹn file, tiến trình, system call
- NIDS (Network-based IDS) đặt ở điểm trong mạng, phân tích lưu lượng đi qua
- HIDS thấy được hoạt động trên máy kể cả với dữ liệu đã giải mã; NIDS bao quát toàn mạng, phát hiện quét và tấn công mạng
- NIDS khó phân tích lưu lượng mã hoá; HIDS phải cài và bảo trì trên từng máy
- Không loại nào tốt hơn tuyệt đối, nên kết hợp cả hai theo chiều sâu phòng thủ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f4d193db-5c2d-5b2b-8cf9-61065d559438', 'Compliance (tuân thủ) trong vận hành hệ thống là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là việc đáp ứng các tiêu chuẩn, quy định do nhà nước, tổ chức độc lập hoặc chính công ty đặt ra
- Ví dụ: PCI DSS cho dữ liệu thẻ thanh toán, ISO 27001, GDPR, quy định bảo vệ dữ liệu cá nhân
- Yêu cầu về kiểm soát truy cập, mã hoá, lưu log, sao lưu, quy trình xử lý sự cố
- Cần kiểm toán định kỳ và lưu bằng chứng
- Vi phạm có thể dẫn tới phạt tiền và mất uy tín', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6d34a00c-c5d1-5dd4-9661-60f5f6d45124', 'WAF là gì và có những loại nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- WAF (Web Application Firewall) lọc và giám sát lưu lượng HTTP tới ứng dụng web
- Chặn các tấn công tầng ứng dụng như SQL injection, XSS, path traversal
- Hoạt động theo luật dựa trên chữ ký (blacklist), mô hình cho phép (whitelist) hoặc phân tích hành vi
- Các loại triển khai: dựa trên mạng (thiết bị phần cứng), dựa trên máy chủ (module như ModSecurity), dựa trên cloud
- WAF là lớp bổ sung, không thay thế việc viết code an toàn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('feecf631-b1e2-5c16-8686-a79eb81da334', 'Bạn hãy trình bày kiến trúc hệ thống mà bạn đang phụ trách và chỉ ra những điểm có khả năng mở rộng hoặc chịu lỗi.', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'BEHAVIORAL', 'Mô tả tổng quan kiến trúc và các thành phần chính -> chỉ ra điểm mở rộng và cơ chế chịu lỗi -> nêu điểm yếu còn tồn tại và hướng cải thiện.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('047b3afb-5ef6-5fcf-b110-e14c7c797d7f', 'Bạn hãy kể quy trình đưa code lên môi trường production tại nơi bạn đang làm việc.', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'BEHAVIORAL', 'Mô tả từ lúc commit tới khi lên production -> nêu các bước kiểm tra, phê duyệt, công cụ dùng -> nói về cách rollback và điều bạn muốn cải thiện.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d3aa77bb-d12a-58c3-8ea4-e4641c3e1311', 'Có những loại kernel nào? Bạn hãy giải thích.', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Monolithic kernel: toàn bộ dịch vụ hệ điều hành (driver, filesystem, mạng) chạy trong không gian kernel; nhanh nhưng một lỗi có thể làm sập hệ thống, ví dụ Linux
- Microkernel: chỉ giữ phần tối thiểu trong kernel, các dịch vụ khác chạy ở user space; ổn định, an toàn hơn nhưng chi phí giao tiếp cao, ví dụ MINIX, QNX
- Hybrid kernel: kết hợp hai cách, ví dụ Windows NT, macOS XNU
- Linux là monolithic nhưng hỗ trợ module nạp động
- Exokernel và unikernel là các hướng ít phổ biến hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cffe33cb-dfef-5a4b-9064-81f61f49fb5c', 'Chương trình báo lỗi thiếu thư viện động. Bạn xử lý như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Xác định thư viện nào thiếu bằng ldd trên file thực thi
- Cài gói chứa thư viện đó bằng trình quản lý gói
- Nếu thư viện nằm ở thư mục không chuẩn, thêm đường dẫn vào cấu hình ld.so.conf.d rồi chạy ldconfig
- Có thể dùng LD_LIBRARY_PATH tạm thời, nhưng không nên dùng lâu dài vì ảnh hưởng toàn cục
- Kiểm tra đúng phiên bản và kiến trúc (32 hay 64 bit) của thư viện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('533f9553-c238-5475-a131-f29299e65d97', 'Bạn hãy nêu những nguyên tắc quan trọng nhất để dùng quyền root an toàn cho một quản trị viên mới.', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không đăng nhập và làm việc thường xuyên bằng root, chỉ dùng sudo khi cần
- Cấp quyền sudo tối thiểu cho từng lệnh hoặc nhóm lệnh cần thiết
- Kiểm tra kỹ lệnh trước khi chạy, đặc biệt lệnh xoá, đổi quyền đệ quy
- Ghi log và kiểm toán các lệnh chạy bằng quyền root
- Tắt đăng nhập SSH trực tiếp bằng root, dùng khoá và xác thực nhiều lớp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('25d7e633-d6d5-59bc-9a75-b23b82c7a151', 'Đồng bộ UID/GID giữa nhiều máy chủ mang lại lợi ích gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Quyền file dựa trên số UID/GID chứ không dựa trên tên user
- Khi dùng chung filesystem mạng như NFS, UID khác nhau giữa các máy sẽ gây sai quyền truy cập
- Sao lưu và khôi phục, di chuyển dữ liệu giữa các máy giữ đúng chủ sở hữu
- Đơn giản hoá quản lý và kiểm toán người dùng
- Thường giải quyết bằng quản lý định danh tập trung như LDAP, FreeIPA', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('74dc326a-800f-5a5d-b761-710749a72431', 'Bạn tuân theo những nguyên tắc nào để tinh chỉnh hiệu năng hệ thống hiệu quả?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Đo trước khi tối ưu: xác định baseline và mục tiêu cụ thể
- Tìm nút thắt cổ chai thật sự (CPU, bộ nhớ, I/O, mạng) bằng số liệu, không đoán
- Mỗi lần chỉ thay đổi một thứ và đo lại để đánh giá tác động
- Ưu tiên tối ưu ở tầng mang lại nhiều lợi ích nhất (ứng dụng, truy vấn) trước khi chỉnh kernel
- Ghi chép lại thay đổi, thử nghiệm trên môi trường giống production', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1666e07f-7c60-5a3a-a471-92ef43fdf517', 'CPU dành phần lớn thời gian chờ I/O. Bạn dùng công cụ gì để tìm tiến trình nào đang chờ I/O và xử lý như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Dấu hiệu: chỉ số wa (iowait) cao trong top hoặc vmstat
- Dùng iostat để xem ổ đĩa nào bận, độ trễ, hàng đợi
- Dùng iotop hoặc pidstat -d để tìm tiến trình đọc ghi nhiều
- Tìm tiến trình ở trạng thái D (uninterruptible sleep) đang chờ I/O
- Xử lý: tối ưu truy vấn hoặc ứng dụng, thêm cache, chuyển sang ổ nhanh hơn, phân tán tải, điều chỉnh ưu tiên I/O bằng ionice', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('59a5f950-e157-58c9-847e-b3b0564a3878', 'Một developer junior vô tình xoá mất cơ sở dữ liệu production. Bạn làm gì để phòng tránh những tình huống như vậy?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khôi phục trước mắt từ bản sao lưu, sau đó họp rút kinh nghiệm không đổ lỗi
- Phân quyền tối thiểu: developer không có quyền ghi trực tiếp vào production
- Tách biệt rõ môi trường và thông tin kết nối, phân biệt trực quan production
- Sao lưu tự động, point-in-time recovery và kiểm tra khôi phục định kỳ
- Thay đổi dữ liệu qua quy trình review và migration, có kế hoạch khôi phục thảm hoạ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('98f1578c-9817-53d8-811a-a07c99c9b290', 'Hệ thống không mount được root filesystem khi khởi động. Nguyên nhân có thể là gì và bạn xử lý ra sao?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Sai tham số root trong cấu hình bootloader hoặc /etc/fstab (sai UUID, sai thiết bị)
- initramfs thiếu driver cho bộ điều khiển đĩa, RAID, LVM hoặc mã hoá
- Filesystem bị hỏng cần chạy fsck
- Ổ đĩa hỏng hoặc không được nhận diện
- Xử lý bằng cách khởi động vào chế độ rescue hoặc live CD, kiểm tra log kernel, sửa fstab, tạo lại initramfs, chạy fsck', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bdddf4bf-697b-528f-b79b-bc87e36c377c', 'Interrupt và interrupt handler trong Linux là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Interrupt là tín hiệu từ phần cứng (hoặc phần mềm) báo CPU có sự kiện cần xử lý ngay, ví dụ card mạng nhận gói tin
- CPU tạm dừng việc đang làm và chạy interrupt handler tương ứng do driver đăng ký
- Handler phải chạy rất nhanh; phần việc nặng được hoãn lại (softirq, tasklet, workqueue)
- Xem thống kê ngắt trong /proc/interrupts
- Ngắt quá nhiều có thể làm tải CPU tăng; có thể phân phối ngắt cho nhiều CPU (IRQ affinity)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('001d384a-6a2a-58b3-9a7d-fce2f37cc0ea', 'Người dùng thường có thể đọc file /etc/passwd. Đây có phải là lỗ hổng bảo mật không?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không phải lỗ hổng: /etc/passwd chỉ chứa thông tin tài khoản như tên, UID, GID, thư mục home, shell
- Nhiều chương trình cần đọc file này để ánh xạ UID sang tên user
- Mật khẩu đã băm được tách sang /etc/shadow, chỉ root đọc được (cơ chế shadow password)
- Trước đây hash nằm trong /etc/passwd nên có thể bị lấy để dò mật khẩu offline
- Hash nên dùng thuật toán mạnh có salt như SHA-512 hoặc yescrypt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fad364aa-c118-55a2-ac96-7c0661162148', 'systemd có những ưu điểm gì so với SysV init?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khởi động các dịch vụ song song nên khởi động nhanh hơn
- Quản lý phụ thuộc giữa các dịch vụ một cách khai báo trong unit file
- Theo dõi tiến trình bằng cgroups, tự khởi động lại dịch vụ khi lỗi
- Ghi log tập trung qua journald, hỗ trợ socket activation, timer thay cho cron
- Đổi lại systemd phức tạp hơn và gom nhiều chức năng vào một hệ thống', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('88f4b5a8-908f-5282-8a79-3bb0e813575d', 'Bạn cần sao chép một lượng dữ liệu rất lớn. Cách hiệu quả nhất là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng rsync để có thể tiếp tục khi bị ngắt và chỉ truyền phần thay đổi
- Nén dữ liệu khi truyền qua mạng chậm, hoặc tắt nén khi mạng nhanh và CPU là nút thắt
- Truyền song song nhiều luồng hoặc dùng tar qua pipe để giảm chi phí với rất nhiều file nhỏ
- Với dữ liệu cực lớn có thể dùng snapshot, sao chép ở mức block hoặc vận chuyển ổ cứng
- Kiểm tra toàn vẹn bằng checksum sau khi sao chép', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('afe0636b-8bce-55a0-8d03-5768721be2cb', 'Nếu kill -9 không dừng được tiến trình thì nguyên nhân có thể là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không đủ quyền gửi tín hiệu tới tiến trình đó
- Tiến trình đang ở trạng thái D (uninterruptible sleep), thường do chờ I/O như ổ đĩa hoặc NFS bị treo; tín hiệu chỉ được xử lý khi I/O kết thúc
- Tiến trình là zombie: đã chết rồi, cần tiến trình cha thu dọn
- Xử lý bằng cách khắc phục nguồn I/O bị treo, kết thúc tiến trình cha, hoặc khởi động lại máy nếu bắt buộc', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('79c62eeb-3278-588b-bf16-1d8c01248e55', 'chroot là gì? Khi nào và vì sao bạn dùng nó?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- chroot đổi thư mục gốc của một tiến trình, tiến trình chỉ thấy cây thư mục bên trong
- Dùng để cô lập dịch vụ (ví dụ SFTP cho user), dựng môi trường build, sửa hệ thống khi khởi động bằng live CD
- Khi cứu hệ thống cần mount /dev, /proc, /sys vào trong chroot để các lệnh hoạt động bình thường
- chroot không phải cơ chế bảo mật đầy đủ, tiến trình root có thể thoát ra
- Container hiện đại dùng namespaces và cgroups để cô lập tốt hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1d126f4b-5cc2-5235-854b-003d1887f677', 'Segmentation fault là gì và làm sao xác định nguyên nhân?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Segfault xảy ra khi chương trình truy cập vùng bộ nhớ không được phép, kernel gửi SIGSEGV
- Nguyên nhân thường gặp: con trỏ null, truy cập ngoài mảng, dùng bộ nhớ đã giải phóng, tràn stack
- Xem log kernel (dmesg) để biết tiến trình và địa chỉ lỗi
- Bật core dump rồi phân tích bằng gdb để xem stack trace
- Dùng công cụ như Valgrind, AddressSanitizer để tìm lỗi bộ nhớ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e947a944-e90d-5d80-9d9b-c0fb4a20587f', 'Một tiến trình chạy rất chậm. Bạn kiểm tra nó đã chạy bao lâu và dùng công cụ gì để tìm nguyên nhân?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Xem thời gian bắt đầu và thời gian chạy bằng ps với các trường etime, start
- Xem tiến trình đang dùng CPU hay chờ (trạng thái R, S, D) bằng top, pidstat
- Kiểm tra I/O bằng iotop, kết nối mạng và file đang mở bằng lsof
- Dùng strace để xem tiến trình đang bị chặn ở system call nào, perf để tìm hàm tốn CPU
- Kiểm tra log của ứng dụng và tài nguyên phụ thuộc như cơ sở dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e125953d-5d5c-549d-a388-e826f32954e9', 'File descriptor trong Linux là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- File descriptor là số nguyên không âm mà kernel cấp cho tiến trình để đại diện một tài nguyên đang mở
- Tài nguyên có thể là file, socket, pipe, thiết bị
- Mặc định 0 là stdin, 1 là stdout, 2 là stderr
- Mỗi tiến trình có giới hạn số file descriptor (ulimit -n), vượt quá sẽ báo lỗi Too many open files
- Xem danh sách bằng lsof hoặc /proc/PID/fd', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b577b107-d419-5c62-8bb4-340c580d4a05', 'Những dấu hiệu nào cho thấy hệ thống đang bị nghẽn ổ đĩa (disk bottleneck)?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- iowait cao, load average cao trong khi CPU còn rảnh
- Độ trễ đọc ghi (await) cao và hàng đợi I/O dài, mức sử dụng ổ (%util) gần 100%
- Nhiều tiến trình ở trạng thái D
- Ứng dụng phản hồi chậm, truy vấn cơ sở dữ liệu chậm bất thường
- Theo dõi bằng iostat, vmstat, iotop, sar', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eaecd4b8-c446-5cb6-a103-82506cb81b60', 'Khách hàng báo website chỉ đạt hạng B khi kiểm tra cấu hình SSL/TLS. Bạn sẽ kiểm tra và cải thiện những gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Chỉ bật TLS 1.2 và 1.3, tắt SSL và TLS 1.0, 1.1
- Chỉ dùng cipher suite mạnh, ưu tiên có forward secrecy (ECDHE), tắt RC4, 3DES
- Gửi đầy đủ chuỗi chứng chỉ trung gian, dùng khoá đủ mạnh
- Bật HSTS, OCSP stapling
- Kiểm tra lại bằng công cụ quét sau khi thay đổi và cân nhắc tương thích với client cũ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fb908037-4fce-547c-8f00-4f5525ca2e4e', 'Máy chủ 24 nhân có load average trên 30 nhưng CPU vẫn rảnh khoảng 70%. Nguyên nhân thường gặp là gì và bạn kiểm tra thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Trên Linux, load average tính cả tiến trình đang chờ I/O ở trạng thái D, không chỉ tiến trình dùng CPU
- Load cao mà CPU rảnh thường do nghẽn I/O: đĩa chậm, storage mạng hoặc NFS bị treo
- Kiểm tra iowait trong top, vmstat; dùng iostat để xem độ trễ của từng ổ
- Tìm các tiến trình ở trạng thái D và xem chúng đang chờ tài nguyên nào
- Xử lý nguồn gốc: storage có vấn đề, mount mạng treo, tải ghi quá lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c99379b2-7642-5fcc-8bb8-a06c45661906', 'Cơ sở dữ liệu báo lỗi Too many open files. Bạn xử lý như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Lỗi xảy ra khi tiến trình vượt giới hạn số file descriptor được mở
- Kiểm tra số file đang mở của tiến trình và giới hạn hiện tại (/proc/PID/limits)
- Tăng giới hạn cho dịch vụ (LimitNOFILE trong systemd hoặc limits.conf) và kiểm tra giới hạn toàn hệ thống fs.file-max
- Hoặc giảm số file mỗi tiến trình được mở trong cấu hình của cơ sở dữ liệu, giảm số kết nối bằng connection pooling
- Kiểm tra rò rỉ file descriptor hoặc kết nối trong ứng dụng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ad98ec18-94b8-5d09-bf52-43fd55be08d5', 'Trong trường hợp nào df và du cho kết quả dung lượng khác nhau? Bạn xử lý thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- df đọc thông tin từ filesystem, du cộng kích thước các file nhìn thấy được trong cây thư mục
- Trường hợp phổ biến: file đã bị xoá nhưng vẫn đang được tiến trình mở (ví dụ file log), dung lượng chưa được giải phóng
- Tìm bằng lsof các file đã bị xoá còn mở, sau đó khởi động lại hoặc báo cho tiến trình mở lại file
- Nguyên nhân khác: dữ liệu bị che bởi một điểm mount chồng lên, block dành riêng cho root
- Phòng tránh bằng cách xoay vòng log đúng cách thay vì xoá file log đang được ghi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a8c19136-e4c8-542d-a71f-aebfce532191', 'Mã hoá (encryption) và băm (hashing) khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mã hoá là quá trình hai chiều: có khoá thì giải mã được để lấy lại dữ liệu gốc
- Băm là một chiều: không thể khôi phục dữ liệu gốc từ giá trị băm
- Mã hoá dùng để bảo vệ tính bí mật khi lưu trữ và truyền dữ liệu
- Băm dùng để kiểm tra toàn vẹn dữ liệu và lưu mật khẩu
- Lưu mật khẩu phải dùng hàm băm chậm có salt như bcrypt, Argon2, không dùng MD5, SHA-1', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a0ad6258-bef5-557f-b0d0-ecf6db5cb5a6', 'Làm thế nào để ghi lại mọi lệnh được chạy bằng quyền root trên máy chủ production?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng auditd với luật ghi lại các lời gọi execve của user có UID 0
- Cấu hình sudo ghi log và có thể ghi lại cả phiên làm việc (sudo I/O logging)
- Gửi log về hệ thống log tập trung để người có quyền root không xoá được dấu vết tại chỗ
- Không dựa vào lịch sử shell vì dễ bị sửa hoặc tắt
- Kết hợp với quản lý truy cập đặc quyền như bastion host ghi lại phiên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ddec6700-80c2-56ff-8537-dd4818e677fa', 'Làm thế nào để giới hạn một tiến trình không dùng quá X% CPU?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- nice và renice thay đổi độ ưu tiên, nhưng chỉ có tác dụng khi có cạnh tranh CPU
- cgroups cho phép giới hạn cứng mức CPU (cpu.max), ví dụ qua thuộc tính CPUQuota của systemd
- Container dùng tham số giới hạn CPU dựa trên cgroups
- cpulimit giới hạn bằng cách tạm dừng và tiếp tục tiến trình, ít chính xác hơn
- Chọn cách phù hợp tuỳ cần giới hạn mềm hay cứng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d6c2f8cd-7ae4-52c5-9075-cf1f72a36814', 'Gắn strace vào một tiến trình đang chạy trên production có an toàn không? Hậu quả có thể là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- strace dùng ptrace, dừng tiến trình ở mỗi system call nên làm tiến trình chậm đi rất nhiều
- Với tiến trình nhiều system call, hiệu năng có thể giảm hàng chục lần, ảnh hưởng người dùng
- Có thể làm lộ dữ liệu nhạy cảm trong output như mật khẩu, nội dung request
- Nên dùng ngắn, lọc đúng loại system call cần xem, hoặc thử trên một instance đã được rút khỏi tải
- Thay thế ít ảnh hưởng hơn: perf, eBPF (bpftrace)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b352854-d35b-5643-ac48-f69864d0ecf5', 'Salted hash là gì? Vì sao cần salt khi lưu mật khẩu?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Salt là chuỗi ngẫu nhiên riêng cho mỗi mật khẩu, được ghép với mật khẩu trước khi băm
- Salt được lưu cùng hash, không cần giữ bí mật
- Hai người dùng cùng mật khẩu vẫn có hash khác nhau
- Vô hiệu hoá bảng tra cứu tính sẵn (rainbow table) và buộc kẻ tấn công dò từng mật khẩu riêng
- Trong /etc/shadow, hash có dạng gồm mã thuật toán, salt và giá trị băm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('53e1cbe6-0126-5d2c-a0dc-d91a5ec57017', 'Bản ghi SPF là gì và giúp chống thư rác như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SPF là bản ghi TXT trong DNS liệt kê các máy chủ được phép gửi email thay mặt tên miền
- Máy chủ nhận kiểm tra địa chỉ IP gửi có nằm trong danh sách SPF không
- Giúp phát hiện email giả mạo tên miền người gửi
- Bản ghi gồm phiên bản, các cơ chế như ip4, include, mx và quy tắc kết thúc như -all hoặc ~all
- Nên dùng kèm DKIM và DMARC để bảo vệ đầy đủ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('45d4aa13-d4cb-5814-96b0-fa8070dcbc78', 'Câu trả lời DNS authoritative và non-authoritative khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Câu trả lời authoritative đến từ máy chủ DNS quản lý trực tiếp zone của tên miền
- Câu trả lời non-authoritative đến từ máy chủ trung gian (resolver) trả kết quả trong cache của nó
- Kết quả non-authoritative có thể đã cũ cho tới khi hết TTL
- Khi kiểm tra thay đổi DNS nên truy vấn thẳng máy chủ authoritative', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c6e8404e-9910-5ebd-a566-ad63c2d517bb', 'Bạn thực hiện kiểm thử tải (load testing) và lập kế hoạch năng lực (capacity planning) cho website như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định mục tiêu: số người dùng đồng thời, request mỗi giây, thời gian phản hồi chấp nhận được
- Xây kịch bản mô phỏng hành vi người dùng thật, chạy bằng công cụ như k6, JMeter, Locust
- Tăng tải dần để tìm điểm gãy và nút thắt, theo dõi tài nguyên hệ thống trong lúc test
- Test trên môi trường giống production
- Dựa trên số liệu và xu hướng tăng trưởng để dự báo tài nguyên, chừa dư địa và lập kế hoạch mở rộng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6772627e-0547-5f17-97ca-8ab8c00660c0', 'Đặt một cache server như Varnish trước website có nghĩa là không cần quan tâm tới cân bằng tải và dự phòng nữa không?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không, cache server chỉ giảm tải bằng cách phục vụ nội dung đã cache
- Request không cache được (nội dung động, POST, cache miss) vẫn đi tới backend
- Bản thân cache server có thể trở thành điểm lỗi đơn lẻ nếu chỉ có một máy
- Vẫn cần nhiều backend, cân bằng tải, health check và dự phòng cho cả lớp cache
- Cache có thể giúp phục vụ nội dung cũ tạm thời khi backend lỗi nhưng không thay thế thiết kế sẵn sàng cao', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('19ac40bc-4a47-5268-ab58-5d50ceacbfa0', 'SNI trong TLS là gì và vì sao nó cần thiết?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SNI (Server Name Indication) là phần mở rộng của TLS, client gửi tên miền muốn truy cập ngay trong lúc bắt tay
- Cho phép một địa chỉ IP phục vụ nhiều website HTTPS với các chứng chỉ khác nhau
- Nếu không có SNI, máy chủ không biết trả chứng chỉ nào
- Hiện được mọi trình duyệt và client hiện đại hỗ trợ, an toàn để dùng trên production
- Tên miền trong SNI không mã hoá (trừ khi dùng ECH) nên thiết bị trung gian thấy được', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('62758577-350c-5ecd-83ed-36e22c9c52dc', 'Cookie được truyền trong giao thức HTTP như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Máy chủ gửi header Set-Cookie trong response để yêu cầu trình duyệt lưu cookie
- Trình duyệt gửi lại cookie phù hợp trong header Cookie ở các request sau tới cùng tên miền và đường dẫn
- Thuộc tính Expires, Max-Age quyết định thời gian sống
- Thuộc tính bảo mật: Secure (chỉ gửi qua HTTPS), HttpOnly (JavaScript không đọc được), SameSite (hạn chế gửi kèm request từ trang khác)
- Domain và Path giới hạn phạm vi gửi cookie', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('19385d7a-3d78-5f87-bc87-5e7b9a306475', 'Làm thế nào để web server không xử lý các request có tên miền (Host header) không được khai báo? Vì sao điều này quan trọng?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nếu không có cấu hình mặc định rõ ràng, request với Host lạ sẽ rơi vào virtual host đầu tiên và được xử lý như website thật
- Rủi ro: bị trỏ tên miền lạ vào máy chủ, tấn công Host header injection (ví dụ link đặt lại mật khẩu sai tên miền)
- Tạo một server block mặc định bắt mọi Host không khai báo
- Trả về lỗi hoặc đóng kết nối ngay (ví dụ mã 444 trong Nginx)
- Ứng dụng cũng nên kiểm tra danh sách Host được phép', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b934e5f8-a589-5153-9c6a-5b79790c88d0', 'Khi chuyển hướng một request POST có dữ liệu sang địa chỉ khác, dữ liệu bị mất. Vì sao và xử lý thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Với redirect 301 hoặc 302, nhiều client đổi POST thành GET và bỏ phần thân request
- Dùng mã 307 (tạm thời) hoặc 308 (vĩnh viễn) để giữ nguyên method và body
- Hoặc dùng reverse proxy chuyển tiếp request nội bộ thay vì redirect về client
- Kiểm tra client có tự theo redirect với POST không
- Tốt nhất là cập nhật client gọi thẳng địa chỉ mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('70065bf7-052e-5cb6-943c-469eecdf35e5', 'Bạn sẽ làm gì để giảm thời gian tải của một website động?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cache ở nhiều tầng: CDN, reverse proxy, cache ứng dụng, cache truy vấn cơ sở dữ liệu
- Tối ưu truy vấn cơ sở dữ liệu và thêm index phù hợp
- Nén dữ liệu (gzip, brotli), tối ưu và nén ảnh, gộp và thu nhỏ tài nguyên tĩnh
- Dùng HTTP/2 hoặc HTTP/3, đặt cache header hợp lý cho tài nguyên tĩnh
- Đo bằng công cụ phân tích hiệu năng để tìm nút thắt trước khi tối ưu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5bda7aff-c44d-5e21-9c50-ae1584608127', 'Khi bạn gõ một tên miền vào trình duyệt, có những tầng cache DNS nào tham gia?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cache DNS của trình duyệt
- Cache của hệ điều hành (stub resolver, ví dụ systemd-resolved) và file hosts
- Cache của router hoặc DNS resolver nội bộ
- Cache của DNS resolver của nhà mạng hoặc dịch vụ DNS công cộng
- Nếu không có trong cache, resolver hỏi lần lượt root, TLD và máy chủ authoritative; mỗi bản ghi được cache theo TTL', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cf357a6b-224d-5905-9126-09cadaf5f9a8', 'Cache-Control: max-age=0 và Cache-Control: no-cache khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- max-age=0 cho biết bản cache hết hạn ngay, nhưng cache có thể vẫn dùng bản cũ trong một số trường hợp (ví dụ khi mất kết nối, nếu không có must-revalidate)
- no-cache cho phép lưu nhưng bắt buộc xác thực lại với máy chủ trước mỗi lần dùng
- Xác thực lại qua ETag hoặc Last-Modified, máy chủ trả 304 nếu nội dung không đổi
- no-store mới là không được lưu cache
- max-age=0 kèm must-revalidate gần tương đương no-cache', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2d88f2d2-6a88-5baa-b56c-d92fb8e8ca02', 'Thiết lập header Access-Control-Allow-Origin có những rủi ro bảo mật gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Đặt giá trị * cho phép mọi website đọc response từ trình duyệt của người dùng
- Phản chiếu lại nguyên header Origin mà không kiểm tra tương đương với cho phép tất cả
- Đặc biệt nguy hiểm khi kết hợp Allow-Credentials, trang độc hại có thể đọc dữ liệu riêng của người dùng đã đăng nhập
- Cần dùng danh sách origin được phép rõ ràng và kiểm tra chặt chẽ
- Không dựa vào CORS thay cho xác thực và phân quyền phía server', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1a0a6210-5974-567e-ac66-2184c905913e', 'Container hoá có những ưu điểm gì so với ảo hoá bằng máy ảo?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Container dùng chung kernel của máy chủ, không cần hệ điều hành khách riêng nên nhẹ hơn
- Khởi động trong vài giây, mật độ chạy trên mỗi máy cao hơn
- Đóng gói ứng dụng cùng dependency, chạy nhất quán giữa các môi trường
- Phù hợp với microservices và CI/CD
- Đổi lại mức cô lập yếu hơn máy ảo vì dùng chung kernel, không chạy được hệ điều hành khác kernel', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('86499e94-43f6-5f21-8c2c-a763beb90588', 'Dùng trực tiếp image từ Docker Hub cho production có ổn không? Có những rủi ro bảo mật gì và cách giảm thiểu?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Image có thể chứa lỗ hổng, phần mềm độc hại hoặc cấu hình không an toàn
- Image không chính thức có thể không được cập nhật bản vá
- Ưu tiên image chính thức hoặc đã xác minh, ghim phiên bản cụ thể hoặc digest thay vì tag latest
- Quét lỗ hổng image (Trivy), dùng image tối giản, chạy bằng user không phải root
- Xây image nội bộ và lưu trong registry riêng có kiểm soát', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ec0e9eed-455e-57c4-bb18-729072893d90', 'Bạn cần dựng một cụm Redis. Bạn đảm bảo bảo mật cho nó như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không để Redis truy cập được từ Internet: bind vào địa chỉ nội bộ, chặn bằng firewall
- Bật xác thực, dùng ACL để cấp quyền theo user
- Mã hoá kết nối bằng TLS khi đi qua mạng không tin cậy
- Đổi tên hoặc vô hiệu hoá các lệnh nguy hiểm như FLUSHALL, CONFIG
- Chạy Redis bằng user không phải root và giám sát truy cập', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('35f68209-30dc-500a-91c7-028b1944d4b1', 'CSRF là gì và phòng chống như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CSRF (Cross-Site Request Forgery) lừa trình duyệt của người dùng đã đăng nhập gửi request không mong muốn tới ứng dụng
- Trình duyệt tự gửi kèm cookie phiên nên server tưởng là người dùng thật
- Phòng chống bằng CSRF token ngẫu nhiên gắn với phiên và kiểm tra ở mỗi request thay đổi dữ liệu
- Dùng thuộc tính cookie SameSite, kiểm tra header Origin/Referer
- Không dùng GET cho các thao tác thay đổi dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('737f20c6-2f9e-58df-84d6-000f140b9d5c', 'False positive và false negative trong hệ thống phát hiện xâm nhập (IDS) là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- False positive: IDS cảnh báo tấn công nhưng thực tế là hoạt động bình thường
- False negative: có tấn công thật nhưng IDS không phát hiện
- Nhiều false positive gây mệt mỏi cảnh báo, đội vận hành dễ bỏ qua cảnh báo thật
- False negative nguy hiểm hơn vì tấn công diễn ra mà không ai biết
- Cần tinh chỉnh luật để cân bằng giữa hai loại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c3e0ff1c-4330-52e7-8441-77c9f5c5fcf5', 'Bạn hãy nêu các bước quan trọng để hardening một web server.', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cập nhật hệ điều hành và phần mềm, gỡ dịch vụ và module không dùng
- Chỉ mở port cần thiết bằng firewall, SSH chỉ dùng khoá và không cho root đăng nhập
- Chạy web server bằng user ít quyền, phân quyền file chặt chẽ
- Cấu hình TLS mạnh, ẩn thông tin phiên bản, thêm security header
- Bật ghi log, giám sát, sao lưu; cân nhắc WAF và fail2ban', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1d0a505c-f2fc-5a0f-9a4e-1e64b0aeb545', 'Kiến trúc hướng sự kiện (event-driven) là gì và nó cải thiện hiệu năng như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Các thành phần giao tiếp bằng cách phát và lắng nghe sự kiện thay vì gọi trực tiếp nhau
- Thường dùng message broker như Kafka, RabbitMQ làm trung gian
- Bên phát không cần chờ bên xử lý, xử lý bất đồng bộ giúp phản hồi nhanh hơn
- Dễ mở rộng từng consumer độc lập, hấp thụ tải tăng đột biến bằng hàng đợi
- Ở mức máy chủ, mô hình event loop (như Nginx) xử lý nhiều kết nối với ít luồng; đổi lại khó debug và phải xử lý tính nhất quán cuối cùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('379ccb2f-a805-5f59-8907-bf835643df6a', 'Ứng dụng gặp vấn đề hiệu năng và bạn cần tìm đoạn code cần tối ưu. Bạn profile ứng dụng trên Linux như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định triệu chứng: tốn CPU, tốn bộ nhớ, hay chờ I/O
- Dùng perf để lấy mẫu stack, vẽ flame graph để tìm hàm tốn thời gian nhất
- Dùng profiler theo ngôn ngữ (py-spy, async-profiler cho Java, pprof cho Go) có thể gắn vào tiến trình đang chạy
- eBPF (bpftrace) để theo dõi chi tiết với chi phí thấp
- Đo lại sau khi tối ưu để xác nhận cải thiện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b292544d-43db-5dbe-83c5-2d49aa4a5f40', 'Hai nguyên tắc quan trọng nhất để giảm thiệt hại khi một hệ thống bị xâm nhập là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nguyên tắc đặc quyền tối thiểu: dịch vụ và người dùng chỉ có đúng quyền cần thiết, kẻ tấn công chiếm được cũng bị giới hạn
- Phân tách và cô lập: chia nhỏ hệ thống, mạng, thông tin bí mật để một phần bị xâm nhập không lan sang phần khác
- Kết hợp giám sát và ghi log để phát hiện sớm
- Có bản sao lưu cách ly để khôi phục', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26f05359-1559-5390-8b67-680fad205ff2', 'Fork bomb là gì? Nếu hệ thống đang bị fork bomb, bạn xử lý thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Fork bomb là đoạn mã tự nhân bản tiến trình liên tục cho tới khi cạn bảng tiến trình và tài nguyên
- Hệ thống trở nên không phản hồi, không tạo được tiến trình mới
- Xử lý: dùng shell đang mở sẵn, gửi SIGSTOP để dừng các tiến trình trước rồi mới kill (dùng lệnh có sẵn trong shell vì không tạo được tiến trình mới)
- Phòng tránh bằng giới hạn số tiến trình mỗi user (ulimit -u, limits.conf) hoặc pids limit của cgroups', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c08e7fb-52da-5691-9edb-9006bf1d87e4', 'Một file đã bị xoá nhưng vẫn đang được một tiến trình mở. Làm sao để khôi phục file đó?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dữ liệu chưa bị giải phóng khi vẫn còn tiến trình giữ file descriptor
- Tìm tiến trình và file descriptor bằng lsof (các file có đánh dấu deleted)
- Sao chép nội dung từ /proc/PID/fd/số_fd ra một file mới
- Phải làm trước khi tiến trình đóng file hoặc bị khởi động lại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('616d4258-c84c-5f3a-85ef-daa98f2cc0bb', 'OOM killer trong Linux chọn tiến trình để kill như thế nào? Làm sao kiểm soát hành vi này?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khi hết bộ nhớ, OOM killer chọn tiến trình có điểm oom_score cao nhất để giải phóng bộ nhớ
- Điểm chủ yếu dựa trên lượng bộ nhớ tiến trình dùng, điều chỉnh bởi oom_score_adj
- Có thể giảm khả năng bị kill cho dịch vụ quan trọng bằng oom_score_adj âm (ví dụ OOMScoreAdjust trong systemd)
- Giới hạn bộ nhớ theo cgroups để OOM xảy ra trong phạm vi nhóm tiến trình
- Điều chỉnh chính sách overcommit (vm.overcommit_memory) và tìm nguyên nhân dùng bộ nhớ thay vì chỉ né OOM', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a2567b76-b5d7-532c-8953-c8a179e7f561', 'Máy chủ có rất nhiều socket ở trạng thái TIME_WAIT khi phục vụ nhiều request HTTP nhỏ sau proxy. Bạn kiểm tra và giảm chúng như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- TIME_WAIT là trạng thái bình thường của bên chủ động đóng kết nối TCP, kéo dài khoảng 2 lần MSL
- Nhiều kết nối ngắn làm TIME_WAIT tích tụ, có thể cạn port tạm phía client hoặc proxy
- Kiểm tra số lượng bằng ss theo trạng thái
- Giải pháp chính: dùng keep-alive và connection pooling giữa proxy và backend để tái sử dụng kết nối
- Có thể bật tcp_tw_reuse, mở rộng dải port tạm; không dùng tcp_tw_recycle (đã bị loại bỏ)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b00f66b-ea57-570e-9687-7ece0081aff5', 'Tuỳ chọn socket SO_REUSEADDR và SO_REUSEPORT khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SO_REUSEADDR cho phép bind lại vào địa chỉ và port khi còn kết nối cũ ở TIME_WAIT, giúp khởi động lại dịch vụ ngay
- SO_REUSEPORT (Linux 3.9 trở lên) cho phép nhiều socket cùng bind vào một địa chỉ và port
- Với SO_REUSEPORT, kernel phân phối kết nối đến giữa các socket, giúp nhiều tiến trình cùng nhận kết nối và cân bằng tải
- Các socket dùng SO_REUSEPORT phải thuộc cùng user để tránh bị chiếm port
- Hành vi chi tiết khác nhau giữa các hệ điều hành như BSD và Linux', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e96bfeee-bb4c-5096-ae2f-7d45d5e6f64b', 'Học có giám sát (supervised learning) là gì? Bạn hãy cho ví dụ.', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là phương pháp học máy huấn luyện mô hình trên dữ liệu đã gán nhãn, gồm cặp đầu vào và đầu ra mong muốn
- Mô hình học hàm ánh xạ từ đặc trưng đầu vào sang nhãn để dự đoán cho dữ liệu mới
- Hai nhóm bài toán chính: hồi quy (dự đoán giá trị liên tục) và phân loại (dự đoán nhãn rời rạc)
- Ví dụ thuật toán: hồi quy tuyến tính, hồi quy logistic, cây quyết định, random forest, SVM
- Khác với học không giám sát, vốn làm việc với dữ liệu không có nhãn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('02691895-ee60-51a5-bc84-6affa341ebde', 'Bài toán hồi quy (regression) là gì? Có thể dùng những mô hình nào để giải?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hồi quy là bài toán học có giám sát dự đoán một giá trị liên tục, ví dụ giá nhà, doanh thu
- Mô hình tìm mối quan hệ giữa các biến đầu vào và biến mục tiêu
- Mô hình thường dùng: hồi quy tuyến tính, Ridge, Lasso
- Mô hình phi tuyến: cây quyết định, random forest, gradient boosting, mạng nơ-ron
- Đánh giá bằng các chỉ số như MSE, RMSE, MAE, R bình phương', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ee883a3b-4449-5d82-b48b-3a79af0ebc1b', 'Hồi quy tuyến tính là gì? Khi nào nên dùng?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mô hình giả định biến mục tiêu là tổ hợp tuyến tính của các đặc trưng cộng sai số
- Học các hệ số sao cho tổng bình phương sai số nhỏ nhất
- Dùng khi quan hệ giữa đầu vào và đầu ra xấp xỉ tuyến tính, cần mô hình đơn giản, dễ giải thích
- Thường là mô hình nền (baseline) cho bài toán hồi quy
- Không phù hợp khi quan hệ phi tuyến mạnh nếu không biến đổi đặc trưng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('128cf028-1405-5eee-b2a9-531694f018ee', 'Hồi quy tuyến tính dựa trên những giả định chính nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Quan hệ giữa đặc trưng và biến mục tiêu là tuyến tính
- Các sai số độc lập với nhau
- Phương sai của sai số không đổi (homoscedasticity)
- Sai số có phân phối chuẩn, quan trọng khi cần suy diễn thống kê
- Các đặc trưng không bị đa cộng tuyến nghiêm trọng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d6a02936-6161-5434-917d-1a1100965d1e', 'Phân phối chuẩn là gì? Vì sao nó quan trọng trong thống kê và học máy?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là phân phối xác suất liên tục có dạng hình chuông, đối xứng quanh giá trị trung bình
- Được xác định bởi hai tham số: trung bình và độ lệch chuẩn
- Khoảng 68%, 95%, 99.7% dữ liệu nằm trong 1, 2, 3 độ lệch chuẩn quanh trung bình
- Định lý giới hạn trung tâm: trung bình mẫu có xu hướng phân phối chuẩn, làm nền cho nhiều kiểm định thống kê
- Nhiều mô hình và phương pháp giả định dữ liệu hoặc sai số có phân phối chuẩn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('30e7d54f-f1ba-5dbc-a546-21802d4fd6d9', 'Làm sao kiểm tra một biến có tuân theo phân phối chuẩn không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Vẽ histogram và quan sát có dạng hình chuông, đối xứng không
- Dùng biểu đồ Q-Q: các điểm nằm gần đường thẳng thì gần phân phối chuẩn
- Xem độ lệch (skewness) và độ nhọn (kurtosis)
- Dùng kiểm định thống kê như Shapiro-Wilk, Kolmogorov-Smirnov, D''Agostino
- Với dữ liệu lớn, kiểm định rất nhạy nên cần kết hợp với quan sát trực quan', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fb647b79-d36c-5411-ab79-79b83cee6acd', 'Khi xây dựng mô hình dự đoán giá, giá có phân phối chuẩn không? Cần tiền xử lý gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Giá thường không phân phối chuẩn mà lệch phải: nhiều giá trị thấp, một số ít giá trị rất cao
- Phân phối lệch và ngoại lai làm mô hình tuyến tính kém chính xác
- Thường biến đổi log (log1p) để phân phối cân đối hơn, dự đoán xong biến đổi ngược lại
- Xử lý ngoại lai và giá trị không hợp lệ (âm, bằng 0)
- Có thể chọn hàm mất mát hoặc chỉ số phù hợp như RMSLE', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cce0c40c-2277-5581-93a5-f201ce575753', 'Bạn biết những phương pháp nào để giải bài toán hồi quy tuyến tính?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Giải tích bằng phương trình chuẩn (normal equation), cho nghiệm chính xác
- Dùng phân rã ma trận như QR hoặc SVD để tính ổn định hơn về số học
- Gradient descent cập nhật hệ số lặp lại theo hướng giảm hàm mất mát
- Stochastic hoặc mini-batch gradient descent cho dữ liệu lớn
- Phương pháp giải tích chậm khi số đặc trưng rất lớn, khi đó dùng phương pháp lặp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bcd4f279-cd40-5e8d-b05a-65df4d9d0760', 'Gradient descent là gì và hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là thuật toán tối ưu lặp để tìm cực tiểu của hàm mất mát
- Tính gradient (đạo hàm) của hàm mất mát theo các tham số
- Cập nhật tham số theo hướng ngược gradient, bước nhảy bằng learning rate nhân gradient
- Lặp lại cho tới khi hội tụ hoặc đạt số vòng tối đa
- Learning rate quá lớn có thể không hội tụ, quá nhỏ thì hội tụ chậm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0483b9fa-25d0-56ba-a03e-ee70b8dae588', 'Phương trình chuẩn (normal equation) trong hồi quy tuyến tính là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là cách giải trực tiếp hệ số của hồi quy tuyến tính bằng đại số tuyến tính
- Có được bằng cách cho đạo hàm của tổng bình phương sai số bằng 0
- Nghiệm là nghịch đảo của X chuyển vị nhân X, nhân với X chuyển vị nhân y
- Không cần chọn learning rate hay lặp
- Chi phí tính nghịch đảo ma trận lớn khi có nhiều đặc trưng và không dùng được khi ma trận suy biến (đa cộng tuyến)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ca6e5d22-3a4e-5e1c-b355-20b4b10113c3', 'Bạn biết những chỉ số nào để đánh giá mô hình hồi quy?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- MSE: trung bình bình phương sai số, phạt nặng sai số lớn
- RMSE: căn bậc hai của MSE, cùng đơn vị với biến mục tiêu
- MAE: trung bình trị tuyệt đối sai số, ít nhạy với ngoại lai
- R bình phương: tỉ lệ phương sai của biến mục tiêu được mô hình giải thích
- MAPE hoặc RMSLE khi quan tâm sai số tương đối', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('31d51b3e-43ba-52f5-860f-ea7145081a21', 'MSE và RMSE là gì? Khi nào nên dùng RMSE thay cho MAE?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- MSE là trung bình bình phương hiệu giữa giá trị dự đoán và giá trị thật
- RMSE là căn bậc hai của MSE, có cùng đơn vị với biến mục tiêu nên dễ diễn giải
- Cả hai phạt nặng các sai số lớn do bình phương
- Dùng RMSE khi sai số lớn đặc biệt có hại; dùng MAE khi muốn ít nhạy với ngoại lai', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61127aa6-6ba5-587c-9512-45059e7f348d', 'Bias-variance trade-off là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bias là sai số do mô hình quá đơn giản, không nắm được quy luật thật (underfitting)
- Variance là sai số do mô hình quá nhạy với dữ liệu huấn luyện (overfitting)
- Mô hình phức tạp hơn thường giảm bias nhưng tăng variance và ngược lại
- Mục tiêu là tìm độ phức tạp cân bằng để sai số trên dữ liệu mới nhỏ nhất
- Điều chỉnh qua chọn mô hình, regularization, thêm dữ liệu, ensemble', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('22aebe4f-a65c-5eb1-844e-7031f83dadd6', 'Overfitting là gì? Làm sao phát hiện và khắc phục?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Overfitting là khi mô hình học quá khớp dữ liệu huấn luyện, kể cả nhiễu, nên dự đoán kém trên dữ liệu mới
- Phát hiện khi sai số trên tập train thấp nhưng trên tập validation cao
- Khắc phục bằng thêm dữ liệu, đơn giản hoá mô hình, chọn bớt đặc trưng
- Dùng regularization (L1, L2, dropout), early stopping
- Dùng cross-validation để đánh giá đáng tin cậy hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e918086c-e260-52e2-b4f0-1bbfde56e5eb', 'Vì sao cần chia dữ liệu thành ba phần train, validation và test?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tập train dùng để huấn luyện mô hình, học tham số
- Tập validation dùng để chọn mô hình, tinh chỉnh siêu tham số
- Tập test chỉ dùng một lần ở cuối để ước lượng hiệu năng thực tế trên dữ liệu chưa thấy
- Nếu dùng tập test để tinh chỉnh, kết quả sẽ lạc quan quá mức do rò rỉ thông tin
- Với dữ liệu theo thời gian cần chia theo thứ tự thời gian', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bac2caf3-362b-512a-8ba8-36523b3531ff', 'Cross-validation hoạt động như thế nào? K-fold cross-validation là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cross-validation đánh giá mô hình bằng cách huấn luyện và kiểm tra trên nhiều cách chia dữ liệu khác nhau
- K-fold chia dữ liệu thành K phần bằng nhau
- Lần lượt dùng một phần làm validation, K-1 phần còn lại để huấn luyện, lặp K lần
- Lấy trung bình kết quả K lần để có ước lượng ổn định hơn một lần chia
- Biến thể: stratified K-fold cho dữ liệu mất cân bằng, time series split cho dữ liệu thời gian', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c83c251e-2d8d-5adc-8f2c-af6482a08fb4', 'Bạn chọn K trong K-fold cross-validation như thế nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- K lớn: mỗi lần huấn luyện dùng nhiều dữ liệu hơn, ước lượng ít thiên lệch nhưng tốn thời gian tính toán
- K nhỏ: nhanh hơn nhưng ước lượng có thể thiên lệch hơn
- Giá trị phổ biến là 5 hoặc 10
- Dữ liệu ít có thể dùng K lớn hoặc leave-one-out; dữ liệu rất lớn có thể chỉ cần một lần chia
- Cân nhắc thời gian huấn luyện của mô hình', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3eae03f-cfd2-5831-a78f-84933c068ccd', 'Bài toán phân loại (classification) là gì? Bạn dùng những mô hình nào để giải?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phân loại là bài toán học có giám sát dự đoán nhãn rời rạc, ví dụ email spam hay không
- Có phân loại nhị phân và phân loại nhiều lớp
- Mô hình tuyến tính: hồi quy logistic, SVM tuyến tính
- Mô hình dựa trên cây: cây quyết định, random forest, gradient boosting
- Ngoài ra có KNN, Naive Bayes, mạng nơ-ron', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c3c5eb05-d995-595f-bc55-85527130540a', 'Hồi quy logistic là gì? Khi nào nên dùng?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là mô hình phân loại, thường là nhị phân, dự đoán xác suất thuộc lớp dương
- Tính tổ hợp tuyến tính của đặc trưng rồi đưa qua hàm sigmoid để ra xác suất trong khoảng 0 đến 1
- Huấn luyện bằng cách tối thiểu log loss (cross-entropy)
- Dùng khi cần mô hình đơn giản, nhanh, dễ giải thích, cần xác suất; là baseline tốt
- Mở rộng cho nhiều lớp bằng softmax hoặc one-vs-rest', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9a815135-f998-5333-a0af-d8653280aa98', 'Hồi quy logistic có phải là mô hình tuyến tính không? Vì sao?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, hồi quy logistic là mô hình tuyến tính tổng quát
- Log-odds (logit) của xác suất là hàm tuyến tính của các đặc trưng
- Hàm sigmoid chỉ biến đổi kết quả tuyến tính thành xác suất
- Biên quyết định giữa hai lớp là một siêu phẳng tuyến tính
- Muốn biên phi tuyến cần tự tạo đặc trưng phi tuyến', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('064a2bee-87fc-52df-955c-65c5dd95eee2', 'Hàm sigmoid là gì và dùng để làm gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Sigmoid là hàm hình chữ S, biến số thực bất kỳ thành giá trị trong khoảng 0 đến 1
- Công thức là 1 chia cho 1 cộng e mũ trừ x
- Dùng trong hồi quy logistic để biến điểm tuyến tính thành xác suất
- Từng là hàm kích hoạt trong mạng nơ-ron; dùng ở lớp đầu ra cho bài toán nhị phân
- Nhược điểm khi làm hàm kích hoạt lớp ẩn: gradient rất nhỏ ở hai đầu gây vanishing gradient', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2b998e30-c8d2-5c4e-b7e3-95dcc490f3f6', 'Bạn đánh giá mô hình phân loại bằng những cách nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ma trận nhầm lẫn để thấy số dự đoán đúng sai theo từng lớp
- Accuracy cho dữ liệu cân bằng
- Precision, recall, F1-score khi dữ liệu mất cân bằng hoặc chi phí sai khác nhau
- ROC AUC và PR AUC để đánh giá khả năng xếp hạng không phụ thuộc ngưỡng
- Log loss để đánh giá chất lượng xác suất dự đoán', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c7e1b863-eeba-5082-89ac-482d5762db5f', 'Accuracy là gì? Có phải lúc nào accuracy cũng là chỉ số tốt không?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Accuracy là tỉ lệ dự đoán đúng trên tổng số mẫu
- Không phù hợp khi dữ liệu mất cân bằng lớp
- Ví dụ 99% mẫu âm tính thì mô hình luôn đoán âm tính vẫn đạt 99% accuracy nhưng vô dụng
- Khi chi phí của false positive và false negative khác nhau, accuracy không phản ánh đúng
- Khi đó dùng precision, recall, F1, PR AUC', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4ba85b1c-860c-5b3a-9d74-8188282b598f', 'Ma trận nhầm lẫn (confusion matrix) là gì? Các ô trong đó có ý nghĩa gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là bảng so sánh nhãn dự đoán với nhãn thật
- True positive: dự đoán dương và thật sự dương
- True negative: dự đoán âm và thật sự âm
- False positive: dự đoán dương nhưng thật ra âm (lỗi loại I)
- False negative: dự đoán âm nhưng thật ra dương (lỗi loại II); từ bảng này tính precision, recall, accuracy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dbe550fc-8c74-5b38-9177-b3f0644e9587', 'Precision, recall và F1-score là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Precision: trong các mẫu dự đoán dương, bao nhiêu là dương thật (TP chia TP cộng FP)
- Recall: trong các mẫu dương thật, mô hình bắt được bao nhiêu (TP chia TP cộng FN)
- F1-score là trung bình điều hoà của precision và recall
- Ưu tiên precision khi false positive tốn kém (ví dụ lọc spam)
- Ưu tiên recall khi bỏ sót tốn kém (ví dụ phát hiện bệnh, gian lận)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9eb36fde-613a-5aea-8935-d3371604b83b', 'Precision-recall trade-off là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Precision và recall thường tỉ lệ nghịch khi thay đổi ngưỡng phân loại
- Tăng ngưỡng: ít dự đoán dương hơn, precision tăng nhưng recall giảm
- Giảm ngưỡng: bắt được nhiều mẫu dương hơn, recall tăng nhưng precision giảm
- Chọn ngưỡng dựa trên chi phí thực tế của từng loại lỗi
- Có thể quan sát qua đường cong precision-recall', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1a178329-378b-5da6-b6fc-4c75d16eb2c2', 'Đường cong ROC là gì? Khi nào nên dùng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ROC biểu diễn true positive rate theo false positive rate khi thay đổi ngưỡng phân loại
- Mô hình ngẫu nhiên nằm trên đường chéo, mô hình tốt cong về góc trên bên trái
- Giúp chọn ngưỡng phù hợp và so sánh mô hình không phụ thuộc một ngưỡng cụ thể
- Phù hợp khi dữ liệu tương đối cân bằng
- Với dữ liệu mất cân bằng nặng nên xem thêm đường cong precision-recall', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('68e8833a-0d28-5e3d-8816-33a667a97e61', 'ROC AUC là gì và diễn giải giá trị của nó như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- AUC là diện tích dưới đường cong ROC, có giá trị từ 0 đến 1
- Bằng xác suất mô hình xếp một mẫu dương ngẫu nhiên cao hơn một mẫu âm ngẫu nhiên
- 0.5 tương đương đoán ngẫu nhiên, 1 là phân tách hoàn hảo, dưới 0.5 là tệ hơn ngẫu nhiên
- Không phụ thuộc ngưỡng và tỉ lệ lớp
- Không phản ánh chất lượng xác suất dự đoán (calibration)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c0e1c68d-75d7-5d10-89aa-cf47885b47fa', 'Đường cong precision-recall là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là đồ thị precision theo recall khi thay đổi ngưỡng phân loại
- Tập trung vào lớp dương, không dùng true negative
- Diện tích dưới đường cong (PR AUC hoặc average precision) tóm tắt thành một con số
- Mô hình ngẫu nhiên có precision bằng tỉ lệ mẫu dương
- Hữu ích khi lớp dương hiếm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1e452829-c563-5bb4-b130-45da155b3739', 'Trong trường hợp nào PR AUC tốt hơn ROC AUC?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khi dữ liệu mất cân bằng nặng, lớp dương hiếm
- ROC dùng false positive rate, mẫu số chứa rất nhiều true negative nên FPR luôn nhỏ, làm ROC AUC trông lạc quan
- PR AUC dựa trên precision nên nhạy với số false positive
- Khi quan tâm chủ yếu tới lớp dương, ví dụ phát hiện gian lận, bệnh hiếm
- Khi số true negative không quan trọng với bài toán', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26630bbf-7463-5895-9f06-21b2ce12afff', 'Bạn xử lý biến phân loại (categorical) như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phần lớn mô hình cần đầu vào số nên phải mã hoá biến phân loại
- One-hot encoding cho biến không có thứ tự và ít giá trị
- Ordinal/label encoding cho biến có thứ tự hoặc cho mô hình dựa trên cây
- Target encoding hoặc frequency encoding cho biến có rất nhiều giá trị, cần chống rò rỉ dữ liệu
- Một số thư viện như CatBoost, LightGBM xử lý trực tiếp biến phân loại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7f53d2ba-d12f-52d6-9432-1bec543d443b', 'Vì sao cần one-hot encoding?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Label encoding gán số nguyên cho từng giá trị, tạo ra thứ tự và khoảng cách giả
- Mô hình tuyến tính sẽ hiểu sai rằng giá trị 3 lớn hơn giá trị 1
- One-hot tạo mỗi giá trị một cột nhị phân, không áp đặt thứ tự
- Nhược điểm: tăng số chiều khi biến có nhiều giá trị
- Với mô hình tuyến tính có thể bỏ một cột để tránh đa cộng tuyến', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2a1480b5-0f05-5441-aab2-268bbba50133', 'Curse of dimensionality (lời nguyền số chiều) là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là các vấn đề phát sinh khi số đặc trưng rất lớn
- Dữ liệu trở nên thưa, cần lượng dữ liệu tăng theo cấp số mũ để phủ không gian
- Khoảng cách giữa các điểm trở nên gần như bằng nhau, làm phương pháp dựa trên khoảng cách (KNN, clustering) kém
- Tăng nguy cơ overfitting và chi phí tính toán
- Khắc phục bằng chọn đặc trưng, giảm chiều (PCA), regularization', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dc179445-2e63-51d9-89d3-968581150d6d', 'Điều gì xảy ra với hồi quy tuyến tính nếu một cột bằng tổng hai cột khác, hoặc gần bằng do có thêm nhiễu?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nếu bằng chính xác, các cột phụ thuộc tuyến tính hoàn toàn, ma trận không khả nghịch, phương trình chuẩn không có nghiệm duy nhất
- Nếu có thêm nhiễu, xảy ra đa cộng tuyến: vẫn giải được nhưng hệ số rất bất ổn, phương sai lớn
- Hệ số khó diễn giải và có thể đổi dấu khi dữ liệu thay đổi nhẹ
- Phát hiện bằng ma trận tương quan, chỉ số VIF
- Khắc phục bằng bỏ bớt cột, dùng regularization L2 hoặc PCA', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('47db2fbb-8237-5678-bf68-f58c7510105b', 'Regularization là gì? Tại sao cần nó?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Regularization thêm thành phần phạt vào hàm mất mát để hạn chế độ phức tạp của mô hình
- Giúp giảm overfitting, mô hình tổng quát hoá tốt hơn
- Thường phạt độ lớn của trọng số, ví dụ L1, L2
- Với mạng nơ-ron còn có dropout, early stopping, data augmentation
- Mức phạt được điều khiển bởi siêu tham số, chọn bằng validation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('162e4b22-a13c-5586-b420-13b0f8f0cd44', 'Bạn biết những kỹ thuật regularization nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- L1 (Lasso): phạt tổng trị tuyệt đối trọng số, có thể đưa trọng số về 0
- L2 (Ridge): phạt tổng bình phương trọng số, làm trọng số nhỏ lại
- Elastic Net: kết hợp L1 và L2
- Với mạng nơ-ron: dropout, weight decay, batch normalization, early stopping
- Data augmentation và giới hạn độ sâu cây với mô hình dựa trên cây', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2d0c3f8f-e0cc-527f-804d-83f2e1d26077', 'L2 regularization ảnh hưởng thế nào tới trọng số của mô hình tuyến tính?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- L2 thêm vào hàm mất mát tổng bình phương các trọng số nhân với hệ số lambda
- Phạt nặng trọng số lớn nên kéo các trọng số về gần 0 nhưng hiếm khi bằng 0
- Trọng số được phân bố đều hơn giữa các đặc trưng tương quan
- Giúp ổn định nghiệm khi có đa cộng tuyến
- Lambda càng lớn trọng số càng nhỏ, mô hình càng đơn giản', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9fe803bb-9818-5bdc-8cef-66ad45167bf5', 'L1 và L2 regularization khác nhau như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- L1 phạt tổng trị tuyệt đối trọng số, L2 phạt tổng bình phương trọng số
- L1 tạo nghiệm thưa, đưa nhiều trọng số về 0 nên dùng được để chọn đặc trưng
- L2 làm trọng số nhỏ dần nhưng hiếm khi bằng 0
- L2 ổn định hơn khi các đặc trưng tương quan; L1 có thể chọn ngẫu nhiên một trong các đặc trưng tương quan
- L2 có nghiệm dạng đóng, L1 không khả vi tại 0', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0f9f6f71-5f28-5f74-b6aa-816204428824', 'Có thể kết hợp cả L1 và L2 regularization trong một mô hình tuyến tính không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, đó là Elastic Net
- Hàm mất mát cộng cả hai thành phần phạt L1 và L2, có tham số điều chỉnh tỉ lệ giữa hai loại
- Vừa tạo nghiệm thưa như L1 vừa ổn định như L2
- Hữu ích khi có nhiều đặc trưng tương quan với nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9778f6ff-4a19-53bb-b9d6-92628f505359', 'Hệ số chặn (bias term) trong mô hình tuyến tính có ý nghĩa gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là giá trị dự đoán khi tất cả đặc trưng bằng 0
- Cho phép đường hoặc siêu phẳng không bắt buộc đi qua gốc toạ độ
- Nếu các đặc trưng được chuẩn hoá về trung bình 0, hệ số chặn bằng giá trị trung bình của biến mục tiêu
- Thường không bị phạt khi dùng regularization', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa5c3387-51b1-554e-bc35-ebdee41aefbe', 'Bạn diễn giải trọng số trong mô hình tuyến tính như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Trọng số cho biết biến mục tiêu thay đổi bao nhiêu khi đặc trưng tăng một đơn vị, các đặc trưng khác giữ nguyên
- Dấu của trọng số cho biết chiều ảnh hưởng
- Độ lớn phụ thuộc vào thang đo của đặc trưng
- Với hồi quy logistic, trọng số là thay đổi của log-odds
- Diễn giải sai khi có đa cộng tuyến hoặc đặc trưng chưa chuẩn hoá', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a4915680-1c1a-5679-9d03-d1ef270556e4', 'Nếu trọng số của biến này lớn hơn biến kia, có thể kết luận biến đó quan trọng hơn không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Chỉ so sánh được khi các đặc trưng đã được chuẩn hoá cùng thang đo
- Nếu chưa chuẩn hoá, độ lớn trọng số phụ thuộc đơn vị đo nên không so sánh được
- Đa cộng tuyến làm trọng số bất ổn, có thể dẫn tới kết luận sai
- Nên kết hợp thêm kiểm định thống kê hoặc phương pháp như permutation importance', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ec03f626-99fe-52b3-a9e3-7708b78c1ecb', 'Khi nào cần chuẩn hoá đặc trưng cho mô hình tuyến tính? Khi nào không cần?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cần khi dùng regularization L1, L2 vì mức phạt phụ thuộc thang đo của trọng số
- Cần khi huấn luyện bằng gradient descent để hội tụ nhanh và ổn định
- Cần khi muốn so sánh độ lớn trọng số giữa các đặc trưng
- Không bắt buộc với hồi quy tuyến tính thường giải bằng phương trình chuẩn, kết quả dự đoán không đổi
- Mô hình dựa trên cây không cần chuẩn hoá', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('72c1bc84-0a98-54ec-bc86-4fb72efa713d', 'Feature selection là gì? Vì sao cần nó?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là quá trình chọn ra tập con đặc trưng liên quan nhất để huấn luyện mô hình
- Giảm overfitting và giảm nhiễu từ đặc trưng không liên quan
- Giảm thời gian huấn luyện và suy luận
- Mô hình đơn giản, dễ giải thích hơn
- Giảm ảnh hưởng của lời nguyền số chiều', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a5bab229-0fc3-532a-a5f3-efe980bce807', 'Feature selection có quan trọng với mô hình tuyến tính không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, mô hình tuyến tính nhạy với đặc trưng nhiễu và đặc trưng tương quan
- Bớt đặc trưng giúp giảm overfitting khi số đặc trưng lớn so với số mẫu
- Giảm đa cộng tuyến, giúp hệ số ổn định và dễ diễn giải
- Có thể dùng L1 regularization để tự động chọn đặc trưng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bb546949-035e-56e2-9da3-f9bc57574354', 'Bạn biết những kỹ thuật chọn đặc trưng (feature selection) nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Filter: dựa trên thống kê độc lập với mô hình như tương quan, chi bình phương, mutual information
- Wrapper: thử nhiều tập đặc trưng với mô hình, ví dụ forward selection, backward elimination, RFE
- Embedded: chọn trong lúc huấn luyện, ví dụ L1 regularization, feature importance của cây
- Permutation importance để đo mức giảm hiệu năng khi xáo trộn một đặc trưng
- Giảm chiều như PCA là trích xuất đặc trưng mới, không phải chọn đặc trưng gốc', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7c43d94b-6457-5d13-ae05-e7070f937238', 'Có thể dùng L1 regularization để chọn đặc trưng không? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, L1 có xu hướng đưa trọng số của đặc trưng ít quan trọng về đúng 0
- Đặc trưng có trọng số khác 0 là đặc trưng được chọn
- Hình học: vùng ràng buộc của L1 có góc nhọn trên các trục nên nghiệm tối ưu hay nằm ở các góc
- Mức độ thưa điều khiển bởi lambda
- Với các đặc trưng tương quan cao, L1 có thể chỉ giữ một đặc trưng một cách tuỳ ý', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('11d46719-74a1-5150-8c87-7eff73dde13f', 'Có thể dùng L2 regularization để chọn đặc trưng không? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không trực tiếp, vì L2 làm trọng số nhỏ lại nhưng hiếm khi bằng đúng 0
- Mọi đặc trưng vẫn còn trong mô hình
- Vùng ràng buộc của L2 là hình tròn, không có góc nên nghiệm ít khi nằm trên trục
- Có thể xếp hạng theo độ lớn trọng số sau chuẩn hoá nhưng đó là chọn thủ công
- Muốn chọn đặc trưng tự động nên dùng L1 hoặc Elastic Net', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6c9b879a-82f2-5480-aff1-35c71dca02c6', 'Cây quyết định (decision tree) là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là mô hình học có giám sát dùng cho cả phân loại và hồi quy
- Chia dữ liệu liên tiếp theo các điều kiện trên đặc trưng, tạo cấu trúc cây
- Mỗi nút trong là một điều kiện, mỗi lá là một dự đoán
- Dễ hiểu, dễ giải thích, không cần chuẩn hoá dữ liệu
- Dễ overfitting nếu cây quá sâu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4ccf868d-358f-5190-bdf7-0f290f2f38c0', 'Cây quyết định được huấn luyện như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bắt đầu từ nút gốc chứa toàn bộ dữ liệu
- Với mỗi đặc trưng và ngưỡng, tính mức giảm độ hỗn tạp (Gini, entropy cho phân loại; MSE cho hồi quy)
- Chọn cách chia giảm hỗn tạp nhiều nhất, tách dữ liệu thành các nút con
- Lặp đệ quy cho từng nút con theo cách tham lam
- Dừng khi đạt độ sâu tối đa, số mẫu tối thiểu hoặc nút đã thuần nhất; có thể cắt tỉa (pruning)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('00913266-6466-5f46-94fb-7c648d2c66e0', 'Những tham số chính của mô hình cây quyết định là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Độ sâu tối đa của cây
- Số mẫu tối thiểu để chia một nút và số mẫu tối thiểu ở mỗi lá
- Tiêu chí đo độ hỗn tạp: Gini, entropy hoặc MSE
- Số đặc trưng tối đa được xét ở mỗi lần chia
- Các tham số này dùng để kiểm soát overfitting', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('465db769-e1c9-5fae-aecb-16e3fe0ff40c', 'Cây quyết định xử lý biến phân loại như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Một số cài đặt xử lý trực tiếp bằng cách chia theo nhóm giá trị (ví dụ thuật toán C4.5, LightGBM, CatBoost)
- Nhiều thư viện như scikit-learn yêu cầu mã hoá thành số trước
- Label encoding thường dùng được với cây vì cây chia theo ngưỡng
- One-hot có thể làm cây kém hiệu quả khi biến có rất nhiều giá trị
- Target encoding là lựa chọn cho biến có nhiều giá trị', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c2a182c-c575-5fae-b871-8106d02ce6cf', 'Một cây quyết định đơn lẻ có những ưu điểm gì so với các mô hình phức tạp hơn?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dễ hiểu và giải thích, có thể trực quan hoá thành các luật
- Huấn luyện và dự đoán nhanh
- Không cần chuẩn hoá đặc trưng, xử lý được quan hệ phi tuyến và tương tác
- Ít yêu cầu tiền xử lý
- Đổi lại độ chính xác thường thấp hơn và dễ overfitting', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('108a2c63-6c4a-599b-9187-95bb462f1bc9', 'Làm sao biết đặc trưng nào quan trọng hơn trong mô hình cây quyết định?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tổng mức giảm độ hỗn tạp mà đặc trưng mang lại ở tất cả các lần chia (impurity-based importance)
- Số lần đặc trưng được dùng để chia
- Đặc trưng ở gần gốc thường quan trọng hơn
- Impurity-based importance thiên vị đặc trưng có nhiều giá trị, nên kiểm tra thêm bằng permutation importance hoặc SHAP', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8a7e7a4d-f3c9-519d-a57f-72cc4538d454', 'Random forest là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là mô hình ensemble gồm nhiều cây quyết định, dùng cho phân loại và hồi quy
- Mỗi cây huấn luyện trên một mẫu bootstrap của dữ liệu (bagging)
- Ở mỗi lần chia chỉ xét ngẫu nhiên một tập con đặc trưng
- Kết quả là bỏ phiếu đa số (phân loại) hoặc trung bình (hồi quy)
- Giảm variance so với một cây, ít overfitting, ít cần tinh chỉnh', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d1c7c319-40fc-5c3d-bb12-6fb3aee43a7d', 'Vì sao random forest cần yếu tố ngẫu nhiên?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nếu mọi cây giống nhau thì gộp lại không mang thêm lợi ích
- Lấy mẫu bootstrap và chọn ngẫu nhiên đặc trưng làm các cây khác nhau, ít tương quan
- Trung bình nhiều mô hình ít tương quan giúp giảm variance mạnh
- Chọn ngẫu nhiên đặc trưng ngăn một vài đặc trưng mạnh chi phối mọi cây
- Mẫu không được chọn (out-of-bag) dùng để ước lượng sai số', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('64d2bc28-6847-5818-a109-385a38273267', 'Những tham số chính của random forest là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Số cây (n_estimators)
- Số đặc trưng xét ở mỗi lần chia (max_features)
- Độ sâu tối đa của cây, số mẫu tối thiểu để chia và ở lá
- Có dùng bootstrap hay không, kích thước mẫu
- Tiêu chí đo độ hỗn tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2030c933-3fdb-59e2-9599-ef315483894f', 'Bạn chọn độ sâu của cây trong random forest như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cây sâu học được nhiều chi tiết hơn nhưng dễ overfitting từng cây
- Random forest thường dùng cây khá sâu vì việc gộp nhiều cây giảm variance
- Chọn bằng cross-validation, thử một dải giá trị và theo dõi sai số validation
- Có thể giới hạn gián tiếp qua số mẫu tối thiểu ở lá
- Dữ liệu nhiễu nên giới hạn độ sâu nhiều hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('08880788-2f9b-5113-81f8-d5e8388ffa43', 'Làm sao biết random forest cần bao nhiêu cây?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thêm cây hầu như không gây overfitting, chỉ tốn thêm thời gian
- Vẽ sai số validation hoặc out-of-bag theo số cây, chọn điểm khi sai số không còn giảm đáng kể
- Thường vài trăm cây là đủ
- Cân nhắc thời gian huấn luyện và suy luận', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bcc2c205-2d78-5011-ab39-a8c5097a4451', 'Huấn luyện random forest có dễ song song hoá không? Làm như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, rất dễ vì các cây được huấn luyện độc lập với nhau
- Mỗi cây có thể huấn luyện trên một lõi CPU hoặc một máy khác nhau
- Thư viện hỗ trợ sẵn, ví dụ tham số n_jobs trong scikit-learn
- Dự đoán cũng có thể song song theo cây
- Khác với gradient boosting, nơi các cây phải huấn luyện tuần tự', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61837749-2f6f-588e-beaf-57e025d956d0', 'Dùng nhiều cây lớn trong random forest có thể gặp những vấn đề gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tốn nhiều bộ nhớ để lưu mô hình
- Thời gian dự đoán chậm, khó dùng cho ứng dụng cần độ trễ thấp
- Thời gian huấn luyện lâu
- Cây quá sâu trên dữ liệu nhiễu vẫn có thể overfitting
- Mô hình khó giải thích hơn một cây đơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('635e9337-504e-51e1-9207-e817bdb25232', 'Nếu thay vì tìm điểm chia tốt nhất, ta chọn ngẫu nhiên vài điểm chia rồi lấy cái tốt nhất trong số đó, mô hình có hoạt động không?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, đây chính là ý tưởng của Extremely Randomized Trees (Extra Trees)
- Ngưỡng chia được chọn ngẫu nhiên thay vì tối ưu, rồi chọn cách chia tốt nhất trong các ứng viên
- Tăng độ ngẫu nhiên nên các cây càng ít tương quan, giảm variance
- Huấn luyện nhanh hơn vì không phải tìm ngưỡng tối ưu
- Đổi lại bias có thể tăng nhẹ, thường cần nhiều cây hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fd8cc599-404d-55b6-a3fc-eec2d1d0f190', 'Điều gì xảy ra với random forest khi dữ liệu có các đặc trưng tương quan?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Độ chính xác dự đoán thường không bị ảnh hưởng nhiều
- Mức độ quan trọng bị chia sẻ giữa các đặc trưng tương quan nên mỗi đặc trưng trông kém quan trọng hơn thực tế
- Cách chọn ngẫu nhiên đặc trưng làm các đặc trưng tương quan thay phiên được dùng
- Diễn giải feature importance cần thận trọng
- Có thể gom hoặc loại bớt đặc trưng tương quan để dễ diễn giải', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6e12dc1a-8a81-531d-9707-8492f984b547', 'Gradient boosting trees là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là mô hình ensemble xây các cây quyết định một cách tuần tự
- Mỗi cây mới học để sửa sai số (gradient của hàm mất mát) của tổ hợp các cây trước
- Kết quả là tổng có trọng số của các cây, nhân với learning rate
- Thường dùng cây nông (weak learner)
- Các thư viện phổ biến: XGBoost, LightGBM, CatBoost; mạnh với dữ liệu dạng bảng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fac4f01b-a09a-5eec-bf69-cf171284f757', 'Random forest và gradient boosting khác nhau như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Random forest xây các cây độc lập, song song; gradient boosting xây tuần tự, cây sau sửa lỗi cây trước
- Random forest chủ yếu giảm variance; boosting chủ yếu giảm bias
- Random forest dùng cây sâu, boosting thường dùng cây nông
- Random forest ít nhạy siêu tham số và ít overfitting; boosting thường chính xác hơn nhưng cần tinh chỉnh cẩn thận
- Random forest dễ song song hoá hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ba78177a-00ef-5039-98e4-dc735b09cd3c', 'Có thể song song hoá việc huấn luyện gradient boosting không? Bằng cách nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không song song được ở mức các cây vì cây sau phụ thuộc kết quả cây trước
- Có thể song song hoá bên trong việc xây một cây: tìm điểm chia tốt nhất trên nhiều đặc trưng cùng lúc
- Dùng histogram để gom giá trị đặc trưng, giúp tính nhanh và dễ song song
- Thư viện như XGBoost, LightGBM hỗ trợ đa luồng, GPU và huấn luyện phân tán', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('97b8de0e-d5f9-5b45-a9e6-55efad3b1467', 'Có những cách nào để đo mức độ quan trọng của đặc trưng trong gradient boosting?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gain: tổng mức giảm hàm mất mát do các lần chia dùng đặc trưng đó
- Split count (weight): số lần đặc trưng được dùng để chia
- Cover: số mẫu chịu ảnh hưởng bởi các lần chia trên đặc trưng
- Permutation importance: mức giảm hiệu năng khi xáo trộn đặc trưng
- SHAP values: đóng góp của đặc trưng cho từng dự đoán, nhất quán hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6934538d-b956-5e1b-9c66-ff5919c5247d', 'Với feature importance trong gradient boosting, biến liên tục và biến rời rạc có khác biệt gì không?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, độ quan trọng dựa trên số lần chia hoặc gain thường thiên vị biến liên tục và biến có nhiều giá trị
- Biến liên tục có nhiều ngưỡng chia hơn nên dễ được chọn, kể cả khi chỉ khớp nhiễu
- Biến nhị phân hoặc ít giá trị có thể bị đánh giá thấp
- Nên dùng permutation importance hoặc SHAP trên tập validation để so sánh công bằng hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('80d537fb-5401-5f64-90bf-0614e4871988', 'Những tham số chính của mô hình gradient boosting là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Learning rate: mức đóng góp của mỗi cây, nhỏ thì cần nhiều cây hơn nhưng thường tổng quát tốt hơn
- Số cây (số vòng boosting), thường kết hợp early stopping
- Độ sâu tối đa hoặc số lá của mỗi cây
- Tỉ lệ lấy mẫu dữ liệu và đặc trưng cho mỗi cây (subsample, colsample)
- Các tham số regularization như lambda, alpha, số mẫu tối thiểu ở lá', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ea90e3fa-9bec-5a28-9c01-1331c1bf9a42', 'Bạn tinh chỉnh tham số cho XGBoost hoặc LightGBM như thế nào?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cố định learning rate tương đối lớn và dùng early stopping để tìm số cây phù hợp
- Tinh chỉnh tham số cấu trúc cây trước: độ sâu, số lá, số mẫu tối thiểu ở lá
- Sau đó chỉnh tỉ lệ lấy mẫu dữ liệu và đặc trưng, rồi đến tham số regularization
- Cuối cùng giảm learning rate và tăng số cây để có kết quả tốt hơn
- Dùng random search hoặc Bayesian optimization (Optuna) kết hợp cross-validation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd352141-64aa-551d-89f3-2b84c8bf32eb', 'Bạn chọn số cây cho mô hình gradient boosting như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Số cây phụ thuộc chặt vào learning rate: learning rate nhỏ cần nhiều cây hơn
- Khác với random forest, quá nhiều cây trong boosting có thể gây overfitting
- Dùng early stopping: theo dõi sai số trên tập validation, dừng khi không cải thiện sau một số vòng
- Hoặc chọn bằng cross-validation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f4741f54-511f-5e0c-bd49-404b3acc9839', 'Bạn biết những chiến lược tinh chỉnh siêu tham số nào? Grid search và random search khác nhau thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tinh chỉnh thủ công dựa trên kinh nghiệm
- Grid search thử mọi tổ hợp trên lưới giá trị, chắc chắn nhưng tốn kém khi nhiều tham số
- Random search lấy ngẫu nhiên tổ hợp, thường hiệu quả hơn khi chỉ vài tham số thật sự quan trọng
- Bayesian optimization (ví dụ Optuna, Hyperopt) dùng kết quả trước để chọn điểm thử tiếp theo
- Luôn đánh giá bằng tập validation hoặc cross-validation, không dùng tập test', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2f13241e-9878-5b8c-9f3c-7a7af48085f3', 'Mạng nơ-ron có thể giải quyết những loại bài toán nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phù hợp với bài toán phi tuyến phức tạp và dữ liệu lớn
- Thị giác máy tính: phân loại ảnh, phát hiện vật thể, phân đoạn ảnh
- Xử lý ngôn ngữ tự nhiên: phân loại văn bản, dịch máy, mô hình ngôn ngữ
- Xử lý tiếng nói: nhận dạng và tổng hợp giọng nói
- Ngoài ra còn dùng cho chuỗi thời gian, hệ gợi ý, học tăng cường', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5e6988df-4f36-5915-a372-3298c5c460cc', 'Mạng nơ-ron truyền thẳng kết nối đầy đủ (fully-connected feed-forward) hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gồm lớp đầu vào, một hoặc nhiều lớp ẩn và lớp đầu ra
- Mỗi nơ-ron nhận toàn bộ đầu ra của lớp trước, tính tổng có trọng số cộng bias
- Kết quả đi qua hàm kích hoạt phi tuyến rồi truyền sang lớp tiếp theo
- Dữ liệu chỉ đi một chiều từ đầu vào tới đầu ra
- Trọng số được học bằng backpropagation và gradient descent', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3a172cbf-b748-5ae5-817f-7d22049715b2', 'Tại sao mạng nơ-ron cần hàm kích hoạt?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hàm kích hoạt đưa tính phi tuyến vào mạng
- Không có nó, nhiều lớp tuyến tính chồng lên nhau vẫn chỉ tương đương một phép biến đổi tuyến tính
- Nhờ phi tuyến, mạng xấp xỉ được các hàm phức tạp
- Ví dụ: ReLU, sigmoid, tanh, GELU
- Hàm ở lớp đầu ra chọn theo bài toán: sigmoid cho nhị phân, softmax cho nhiều lớp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('359aab20-54b2-5b6b-b7bc-bee685105f86', 'Dùng sigmoid làm hàm kích hoạt có những vấn đề gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bão hoà ở hai đầu: đạo hàm gần 0 khi đầu vào lớn hoặc nhỏ
- Gây vanishing gradient, mạng sâu học rất chậm
- Đầu ra không có trung tâm bằng 0, làm cập nhật gradient kém hiệu quả
- Tính hàm mũ tốn kém hơn ReLU
- Vì vậy lớp ẩn thường dùng ReLU hoặc biến thể', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac9c3bda-12d3-5361-afaa-af02ddff6b5b', 'ReLU là gì? Vì sao nó tốt hơn sigmoid hoặc tanh?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ReLU trả về chính đầu vào nếu dương, ngược lại trả về 0
- Không bão hoà ở phía dương nên giảm vanishing gradient, mạng sâu học nhanh hơn
- Tính toán rất đơn giản
- Tạo kích hoạt thưa
- Nhược điểm dying ReLU: nơ-ron có thể luôn ra 0; khắc phục bằng Leaky ReLU, ELU, GELU', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d182dae4-4671-5b70-b943-dece917364af', 'Có những cách nào để khởi tạo trọng số cho mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không khởi tạo tất cả bằng nhau mà khởi tạo ngẫu nhiên để phá tính đối xứng
- Giá trị quá lớn hoặc quá nhỏ gây bùng nổ hoặc tiêu biến gradient
- Xavier/Glorot initialization phù hợp với tanh, sigmoid
- He initialization phù hợp với ReLU
- Bias thường khởi tạo bằng 0; có thể dùng trọng số huấn luyện sẵn (transfer learning)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6ceb7669-c59c-545f-a383-54509cdbbc22', 'Điều gì xảy ra nếu khởi tạo toàn bộ trọng số của mạng nơ-ron bằng 0?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mọi nơ-ron trong cùng một lớp cho ra kết quả giống nhau
- Gradient của chúng cũng giống nhau nên được cập nhật giống nhau
- Các nơ-ron luôn giống hệt nhau, mạng không học được đặc trưng đa dạng (vấn đề đối xứng)
- Mạng hoạt động như chỉ có một nơ-ron mỗi lớp
- Cần khởi tạo ngẫu nhiên để phá đối xứng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cdbd93b0-ed11-5ff6-b17c-5795cbb06955', 'Dropout là gì? Vì sao nó hữu ích và hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dropout là kỹ thuật regularization cho mạng nơ-ron
- Mỗi bước huấn luyện tắt ngẫu nhiên một tỉ lệ nơ-ron (đặt đầu ra bằng 0)
- Ngăn các nơ-ron phụ thuộc lẫn nhau quá mức, giảm overfitting
- Có thể xem như huấn luyện một tổ hợp nhiều mạng con
- Khi suy luận không tắt nơ-ron nào; đầu ra được điều chỉnh tỉ lệ cho phù hợp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7678aaf7-c56f-591d-ac54-9a6c84a67e0b', 'Backpropagation là gì? Hoạt động thế nào và vì sao cần nó?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là thuật toán tính gradient của hàm mất mát theo mọi trọng số trong mạng
- Lan truyền xuôi để tính đầu ra và loss, rồi lan truyền ngược từ lớp cuối về lớp đầu
- Dùng quy tắc chuỗi (chain rule) để tính đạo hàm từng lớp, tái sử dụng kết quả trung gian
- Gradient sau đó được optimizer dùng để cập nhật trọng số
- Giúp tính gradient hiệu quả cho mạng có hàng triệu tham số', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb051263-faeb-500b-a8f2-9fae01f55799', 'Bạn biết những kỹ thuật tối ưu nào để huấn luyện mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gradient descent, stochastic và mini-batch gradient descent
- SGD kết hợp momentum hoặc Nesterov momentum
- Optimizer thích ứng: AdaGrad, RMSProp, Adam, AdamW
- Lịch điều chỉnh learning rate: step decay, cosine, warmup
- Kỹ thuật hỗ trợ: batch normalization, gradient clipping', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9e5838a0-ee64-52b2-a2d5-89d4c63ed109', 'CNN có bất biến với phép xoay ảnh không? Điều gì xảy ra với dự đoán khi ảnh bị xoay?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không, CNN không bất biến với phép xoay theo thiết kế
- Tích chập có tính bất biến dịch chuyển, nhưng kernel nhận diện đặc trưng theo hướng cố định
- Ảnh bị xoay có thể khiến dự đoán sai hoặc giảm độ tin cậy
- Khắc phục bằng data augmentation với ảnh xoay khi huấn luyện
- Hoặc dùng kiến trúc chuyên biệt như rotation-equivariant CNN, test-time augmentation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1dd0309d-e58c-54a8-a159-97fe399ea5e1', 'Data augmentation là gì? Vì sao cần nó?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là kỹ thuật tạo thêm dữ liệu huấn luyện bằng cách biến đổi dữ liệu có sẵn mà không đổi nhãn
- Tăng lượng và độ đa dạng dữ liệu khi dữ liệu ít
- Giúp mô hình bền vững với biến thể thực tế như góc chụp, ánh sáng
- Giảm overfitting
- Biến đổi phải giữ nguyên ý nghĩa của nhãn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4bbd4bdc-7865-5799-8452-861fd4b063dd', 'Bạn biết những kiểu data augmentation nào cho ảnh?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Biến đổi hình học: lật, xoay, cắt ngẫu nhiên, co giãn, dịch chuyển
- Biến đổi màu sắc: độ sáng, tương phản, bão hoà, chuyển ảnh xám
- Thêm nhiễu, làm mờ
- Che ngẫu nhiên một vùng ảnh (cutout, random erasing)
- Trộn ảnh: mixup, cutmix', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b2617936-1441-57d4-9168-ffda9a474140', 'Bạn chọn những kiểu augmentation nào để dùng như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dựa trên các biến thể có thể gặp trong dữ liệu thực tế
- Không dùng biến đổi làm đổi nhãn, ví dụ lật ngang chữ số hoặc lật ảnh có hướng quan trọng
- Phù hợp với miền bài toán: ảnh y tế khác ảnh chụp đời thường
- Thử nghiệm và đánh giá trên tập validation
- Có thể dùng phương pháp tự động như AutoAugment, RandAugment', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('da6acd11-aec8-5eae-abe5-13a0080a4c8d', 'Bạn biết những kiến trúc CNN nào cho bài toán phân loại ảnh?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Kiến trúc kinh điển: LeNet, AlexNet, VGG
- Inception (GoogLeNet) dùng khối nhiều kích thước kernel song song
- ResNet dùng kết nối tắt (residual connection) để huấn luyện mạng rất sâu
- DenseNet, MobileNet và EfficientNet cho cân bằng giữa độ chính xác và chi phí tính toán
- Hiện nay còn có Vision Transformer và ConvNeXt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('28ba7ff7-1ad6-5f71-b49c-6417324b3ac8', 'Transfer learning là gì? Nó hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là tận dụng mô hình đã huấn luyện trên bài toán hoặc tập dữ liệu lớn cho bài toán mới
- Các lớp đầu đã học được đặc trưng tổng quát có thể dùng lại
- Thay lớp đầu ra cho phù hợp với bài toán mới
- Có thể đóng băng các lớp đầu và chỉ huấn luyện lớp cuối, hoặc fine-tune toàn bộ với learning rate nhỏ
- Giúp đạt kết quả tốt với ít dữ liệu và ít thời gian huấn luyện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61cd6fcd-f2c2-5193-a951-43289900133f', 'Object detection là gì? Bạn biết những kiến trúc nào cho bài toán này?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là bài toán xác định vị trí (bounding box) và loại của các đối tượng trong ảnh
- Two-stage: họ R-CNN (Fast R-CNN, Faster R-CNN) đề xuất vùng rồi phân loại
- One-stage: YOLO, SSD, RetinaNet dự đoán trực tiếp, nhanh hơn
- Kiến trúc dựa trên Transformer như DETR
- Đánh giá bằng chỉ số mAP dựa trên IoU', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('902ed8e4-5f3f-51ca-9b63-78dd1fbd55ce', 'Object segmentation là gì? Bạn biết những kiến trúc nào cho bài toán này?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là bài toán dự đoán mặt nạ ở mức điểm ảnh cho đối tượng
- Semantic segmentation gán nhãn lớp cho từng điểm ảnh
- Instance segmentation phân biệt từng đối tượng riêng lẻ
- Kiến trúc: FCN, U-Net, DeepLab cho semantic; Mask R-CNN cho instance
- Mô hình mới như Segment Anything', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('490386c5-eea0-59f4-b6d2-0deba26a49b5', 'Học máy được dùng để phân loại văn bản như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thu thập và gán nhãn dữ liệu văn bản
- Tiền xử lý: tách từ, chuẩn hoá, có thể bỏ stop word
- Biểu diễn văn bản thành vector: bag of words, TF-IDF, word embedding hoặc mô hình Transformer
- Huấn luyện bộ phân loại như hồi quy logistic, Naive Bayes, SVM hoặc fine-tune mô hình ngôn ngữ
- Đánh giá bằng precision, recall, F1', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('015d0a8a-afcd-56cf-862b-66f236918420', 'Bag of words là gì? Dùng nó để phân loại văn bản như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bag of words biểu diễn văn bản bằng số lần xuất hiện của từng từ trong từ vựng
- Bỏ qua thứ tự và ngữ pháp của từ
- Mỗi văn bản thành một vector thưa có độ dài bằng kích thước từ vựng
- Vector này làm đặc trưng đầu vào cho bộ phân loại như hồi quy logistic, Naive Bayes
- Có thể dùng trọng số TF-IDF thay cho đếm thô', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34a21154-d9bd-5f91-86ac-1488ec208f84', 'Bag of words có những ưu và nhược điểm gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ưu điểm: đơn giản, dễ hiểu, dễ cài đặt, nhanh
- Hoạt động khá tốt với mô hình tuyến tính cho nhiều bài toán phân loại
- Nhược điểm: mất thông tin thứ tự từ và ngữ cảnh
- Vector rất thưa và nhiều chiều khi từ vựng lớn
- Không hiểu từ đồng nghĩa, không xử lý được từ chưa gặp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6c278150-21d6-5db1-ac8d-12c119bf9566', 'N-gram là gì? Bạn dùng n-gram như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- N-gram là chuỗi n từ (hoặc ký tự) liên tiếp trong văn bản
- Unigram là từng từ, bigram là cặp hai từ liền nhau
- Thêm n-gram vào bag of words giúp giữ một phần thứ tự và cụm từ
- Ví dụ phân biệt được không tốt với tốt
- Đổi lại số đặc trưng tăng mạnh, thường chỉ dùng n bằng 2 hoặc 3', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fc9cf5c7-deac-58eb-9fa5-4cfaa92151ec', 'TF-IDF là gì? Nó hữu ích như thế nào cho phân loại văn bản?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- TF (term frequency) đo tần suất từ xuất hiện trong một văn bản
- IDF (inverse document frequency) giảm trọng số của từ xuất hiện trong nhiều văn bản
- TF-IDF bằng TF nhân IDF, làm nổi bật từ đặc trưng cho văn bản
- Giảm ảnh hưởng của từ phổ biến ít mang thông tin
- Thường cho kết quả tốt hơn đếm thô khi dùng với mô hình tuyến tính', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac387eb0-d406-56b5-bf97-c07f60f753aa', 'Khi phân loại văn bản với đặc trưng bag of words, bạn chọn gradient boosting hay hồi quy logistic? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thường chọn hồi quy logistic hoặc mô hình tuyến tính khác
- Bag of words tạo rất nhiều đặc trưng thưa, mô hình tuyến tính xử lý hiệu quả
- Gradient boosting chậm và kém hiệu quả với không gian thưa rất nhiều chiều
- Mô hình tuyến tính nhanh, ít overfitting khi có regularization, dễ giải thích
- Có thể thử Naive Bayes, SVM tuyến tính làm baseline', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dc6bf5e3-328b-551b-a286-ecbbf0f7b330', 'Word embedding là gì và vì sao hữu ích? Bạn có biết Word2Vec không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Word embedding biểu diễn mỗi từ bằng một vector số thực dày, ít chiều
- Từ có nghĩa gần nhau có vector gần nhau
- Học từ dữ liệu lớn không cần nhãn, chuyển được tri thức sang bài toán khác
- Word2Vec học embedding bằng cách dự đoán từ từ ngữ cảnh (CBOW) hoặc ngữ cảnh từ từ (skip-gram)
- Khắc phục nhược điểm vector thưa và không hiểu ngữ nghĩa của bag of words', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9b0e6594-96bc-532b-8e9f-26ab5430954d', 'Ngoài Word2Vec, còn những cách nào để có word embedding?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- GloVe học từ thống kê đồng xuất hiện của từ trên toàn bộ dữ liệu
- FastText dùng n-gram ký tự nên xử lý được từ chưa gặp
- Embedding theo ngữ cảnh từ mô hình Transformer như BERT, mỗi từ có vector khác nhau tuỳ ngữ cảnh
- Có thể học embedding trực tiếp trong lúc huấn luyện mạng cho bài toán cụ thể', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('839dce12-430a-5ad7-b32f-dbd31f53258f', 'Nếu một câu có nhiều từ, bạn gộp các word embedding thành một vector như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Lấy trung bình hoặc tổng các vector từ, đơn giản và là baseline tốt
- Trung bình có trọng số, ví dụ theo TF-IDF
- Max pooling theo từng chiều
- Dùng mô hình học được như RNN, CNN, hoặc attention
- Dùng mô hình sentence embedding chuyên dụng như Sentence-BERT', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('40470e69-3f5f-546e-936e-5246c3522b02', 'Khi phân loại văn bản với đặc trưng là embedding, bạn chọn gradient boosting hay hồi quy logistic?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Embedding là vector dày, ít chiều nên cả hai mô hình đều dùng được
- Gradient boosting có thể học quan hệ phi tuyến giữa các chiều embedding
- Hồi quy logistic nhanh, ổn định, thường vẫn là baseline tốt
- Quyết định nên dựa trên thử nghiệm với validation
- Embedding chất lượng cao thường làm mô hình tuyến tính đã đủ tốt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c5a022a-6257-54da-aaef-563d09f0f537', 'Bạn dùng mạng nơ-ron để phân loại văn bản như thế nào?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Biểu diễn từ bằng embedding, khởi tạo ngẫu nhiên hoặc dùng embedding huấn luyện sẵn
- Dùng mô hình xử lý chuỗi: CNN cho văn bản, RNN/LSTM/GRU, hoặc Transformer
- Gộp thông tin chuỗi thành một vector rồi đưa qua lớp phân loại softmax
- Hiện nay phổ biến nhất là fine-tune mô hình huấn luyện sẵn như BERT
- Huấn luyện bằng cross-entropy, chú ý overfitting khi dữ liệu ít', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('20ae2fab-00cb-5a90-a2c1-3db287a44c0a', 'Học không giám sát (unsupervised learning) là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là học từ dữ liệu không có nhãn để tìm cấu trúc hoặc mẫu ẩn
- Bài toán điển hình: phân cụm (clustering)
- Giảm chiều dữ liệu như PCA
- Phát hiện bất thường và học biểu diễn
- Khó đánh giá hơn vì không có nhãn đúng để so sánh', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('af7bc9b1-857b-53ad-b04d-d1135758bfb2', 'Phân cụm (clustering) là gì? Khi nào cần dùng?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phân cụm là nhóm các đối tượng sao cho đối tượng trong cùng cụm giống nhau hơn so với cụm khác
- Là bài toán học không giám sát
- Dùng để phân khúc khách hàng, gom nhóm tài liệu, khám phá dữ liệu
- Dùng để phát hiện bất thường hoặc làm đặc trưng cho mô hình khác
- Thuật toán phổ biến: K-means, DBSCAN, phân cụm phân cấp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4679385-9c49-5b81-8f54-18c2614b1c7b', 'Thuật toán K-means hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Chọn K tâm cụm ban đầu (ngẫu nhiên hoặc theo K-means++)
- Gán mỗi điểm vào cụm có tâm gần nhất
- Cập nhật tâm mỗi cụm bằng trung bình các điểm trong cụm
- Lặp lại gán và cập nhật cho tới khi tâm không đổi nhiều
- Kết quả phụ thuộc khởi tạo, nên chạy nhiều lần; giả định cụm dạng cầu, kích thước tương đương', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9ad89411-9aa3-51b4-98db-9bc11b589237', 'Bạn chọn K cho K-means như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dựa trên hiểu biết nghiệp vụ nếu đã biết số nhóm mong muốn
- Phương pháp khuỷu tay (elbow): vẽ tổng bình phương khoảng cách trong cụm theo K, chọn điểm gãy
- Silhouette score đo mức tách biệt giữa các cụm
- Gap statistic
- Đánh giá thêm theo mức hữu ích của cụm với bài toán thực tế', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a05f454f-38e1-50db-92dc-1c41a860a90b', 'Ngoài K-means, bạn biết những thuật toán phân cụm nào khác?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- K-medoids dùng điểm thực tế làm tâm, ít nhạy với ngoại lai
- Phân cụm phân cấp (hierarchical) tạo cây gộp hoặc tách cụm
- DBSCAN và HDBSCAN dựa trên mật độ, tìm cụm hình dạng bất kỳ và phát hiện nhiễu
- Gaussian Mixture Model gán xác suất thuộc cụm
- Spectral clustering cho cụm có cấu trúc phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('03cbe15b-d7d6-5dc0-8e39-82412dc076f5', 'Thuật toán DBSCAN hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dựa trên mật độ, có hai tham số: bán kính lân cận epsilon và số điểm tối thiểu
- Điểm lõi có ít nhất số điểm tối thiểu trong bán kính epsilon
- Các điểm lõi gần nhau và điểm lân cận của chúng tạo thành một cụm
- Điểm không thuộc cụm nào được coi là nhiễu
- Không cần chọn trước số cụm, tìm được cụm hình dạng bất kỳ; khó khi mật độ các cụm khác nhau nhiều', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3854dd5-09b5-554f-b156-8d1c0d814a11', 'Khi nào bạn chọn K-means và khi nào chọn DBSCAN?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- K-means khi cụm có dạng cầu, kích thước tương đương và biết trước số cụm
- K-means nhanh, mở rộng tốt với dữ liệu lớn
- DBSCAN khi cụm có hình dạng bất kỳ và không biết số cụm
- DBSCAN chịu nhiễu và ngoại lai tốt hơn
- DBSCAN khó khi mật độ cụm khác nhau và với dữ liệu nhiều chiều', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('894bf5ac-ec16-54f9-9eeb-13e9e97dcbf9', 'Bạn biết những kỹ thuật giảm chiều dữ liệu nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- PCA chiếu dữ liệu lên các hướng có phương sai lớn nhất
- SVD, truncated SVD cho ma trận thưa (ví dụ LSA với văn bản)
- t-SNE và UMAP chủ yếu dùng để trực quan hoá
- Autoencoder học biểu diễn nén bằng mạng nơ-ron
- LDA (Linear Discriminant Analysis) khi có nhãn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('38b1f1e1-934b-53bf-9d0f-5cd7f83228db', 'SVD là gì? Nó thường được dùng như thế nào trong học máy?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SVD phân rã một ma trận thành tích ba ma trận U, Sigma, V chuyển vị
- Sigma chứa các giá trị kỳ dị sắp xếp giảm dần, thể hiện mức quan trọng của mỗi thành phần
- Giữ lại k thành phần lớn nhất cho xấp xỉ hạng thấp tốt nhất
- Dùng để giảm chiều, là nền tảng tính PCA
- Ứng dụng: hệ gợi ý (phân rã ma trận), phân tích ngữ nghĩa văn bản, khử nhiễu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('47e7c519-5b9c-55bd-830a-f1fbba4430d4', 'Bài toán xếp hạng (ranking) là gì? Có thể dùng những mô hình nào để giải?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là bài toán sắp xếp danh sách đối tượng theo mức liên quan với truy vấn hoặc người dùng
- Ứng dụng trong tìm kiếm, hệ gợi ý, quảng cáo
- Pointwise: dự đoán điểm liên quan của từng đối tượng như hồi quy hoặc phân loại
- Pairwise: học thứ tự giữa cặp đối tượng (RankNet); listwise: tối ưu cả danh sách (LambdaMART, ListNet)
- Gradient boosting với mục tiêu xếp hạng và mô hình neural là lựa chọn phổ biến', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('33eeaa43-0c52-5578-a013-5cb30f7f7297', 'Những baseline không giám sát nào tốt cho bài toán truy hồi thông tin văn bản?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- TF-IDF kết hợp độ tương đồng cosine
- BM25, baseline mạnh và phổ biến nhất trong tìm kiếm văn bản
- Truy vấn mở rộng hoặc khớp n-gram
- Embedding câu huấn luyện sẵn kết hợp tìm kiếm vector
- Nên so sánh mô hình học có giám sát với các baseline này', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('edacdbcc-19cf-5187-8cbe-7533a63e108b', 'Bạn đánh giá thuật toán xếp hạng như thế nào? Dùng những chỉ số offline nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cần tập dữ liệu có đánh giá mức liên quan cho các cặp truy vấn và tài liệu
- Precision at k và recall at k
- MAP (mean average precision)
- NDCG tính tới vị trí và mức độ liên quan nhiều bậc
- MRR khi chỉ quan tâm kết quả đúng đầu tiên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('501ad722-898d-5782-98a5-a258e814eb7b', 'Precision at k và recall at k là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Precision at k: tỉ lệ kết quả liên quan trong k kết quả đầu tiên
- Recall at k: tỉ lệ kết quả liên quan được tìm thấy trong k kết quả đầu so với tổng số kết quả liên quan
- Phản ánh việc người dùng thường chỉ xem vài kết quả đầu
- Không quan tâm thứ tự bên trong k kết quả
- Chọn k theo cách hiển thị thực tế, ví dụ 10 kết quả trên trang đầu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('330b0a87-f450-58d8-af84-5071b6f29d21', 'Mean average precision at k (MAP@k) là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Average precision tính trung bình các giá trị precision tại mỗi vị trí có kết quả liên quan, trong k kết quả đầu
- Thưởng cho việc đặt kết quả liên quan ở vị trí cao
- MAP@k là trung bình average precision trên tất cả truy vấn
- Chỉ dùng mức liên quan nhị phân (liên quan hoặc không)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('94cd2be8-5fd1-5692-a1bf-e154d0ce45a3', 'Học máy được ứng dụng vào hệ thống tìm kiếm như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hiểu truy vấn: sửa lỗi chính tả, phân loại ý định, mở rộng truy vấn
- Truy hồi ứng viên nhanh bằng BM25 hoặc tìm kiếm vector dựa trên embedding
- Xếp hạng lại ứng viên bằng mô hình learning to rank với nhiều đặc trưng
- Đặc trưng gồm mức khớp văn bản, độ phổ biến, độ mới, hành vi người dùng
- Học liên tục từ dữ liệu click và đánh giá bằng A/B test', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34ff0490-8a45-5c27-af80-9255dce4216f', 'Làm sao có dữ liệu huấn luyện cho thuật toán xếp hạng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Đánh giá thủ công của người gán nhãn về mức liên quan giữa truy vấn và tài liệu
- Dữ liệu hành vi ngầm: click, thời gian xem, mua hàng
- Cần xử lý thiên lệch vị trí trong dữ liệu click
- Có thể sinh dữ liệu từ log tìm kiếm hoặc dùng mô hình lớn hỗ trợ gán nhãn
- Kết hợp các nguồn và kiểm tra chất lượng nhãn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7ca27243-cd20-5cd9-b4a3-2eebb0d2d3ce', 'Có thể biến bài toán tìm kiếm thành bài toán phân loại không? Bằng cách nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, theo cách pointwise
- Mỗi cặp truy vấn và tài liệu là một mẫu, nhãn là liên quan hoặc không liên quan
- Huấn luyện bộ phân loại dự đoán xác suất liên quan
- Sắp xếp tài liệu theo xác suất dự đoán
- Hạn chế: không tối ưu trực tiếp thứ tự; cách pairwise hoặc listwise thường tốt hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('232e1c5e-1ee1-5a32-aaf4-e6448cda004b', 'Dùng dữ liệu click làm dữ liệu huấn luyện cho thuật toán xếp hạng như thế nào?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Coi click là tín hiệu liên quan ngầm, kết quả bị bỏ qua là tín hiệu kém liên quan
- Thiên lệch vị trí: kết quả ở trên được click nhiều hơn dù không liên quan hơn
- Xử lý bằng mô hình click (click model), inverse propensity weighting hoặc xáo trộn ngẫu nhiên có kiểm soát
- Tạo cặp ưu tiên: tài liệu được click tốt hơn tài liệu phía trên nhưng bị bỏ qua
- Kết hợp thời gian xem để lọc click không thật sự hài lòng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('39c204e9-1471-57d9-be86-999be31bb7c1', 'Bạn dùng gradient boosting trees cho bài toán xếp hạng như thế nào?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng hàm mục tiêu xếp hạng thay vì hồi quy hay phân loại thông thường
- LambdaMART kết hợp gradient boosting với gradient LambdaRank, tối ưu gián tiếp NDCG
- Dữ liệu được nhóm theo truy vấn, mô hình so sánh tài liệu trong cùng nhóm
- Hỗ trợ sẵn trong XGBoost, LightGBM, CatBoost (ví dụ mục tiêu lambdarank)
- Đặc trưng là các thuộc tính của cặp truy vấn và tài liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd150046-c1fe-505c-87a5-3d640362f893', 'Bạn đánh giá online một thuật toán xếp hạng mới như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- A/B test: chia ngẫu nhiên người dùng, so sánh nhóm dùng thuật toán mới với nhóm cũ
- Chỉ số: tỉ lệ click, thời gian tới click đầu tiên, tỉ lệ chuyển đổi, tỉ lệ thoát
- Interleaving: trộn kết quả hai thuật toán trong một danh sách, nhạy hơn và cần ít lưu lượng hơn
- Kiểm tra ý nghĩa thống kê và các chỉ số bảo vệ
- Triển khai dần sau khi có kết quả tốt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('df61fecd-9611-5afa-8322-94e36a1c8d5f', 'Hệ thống gợi ý (recommender system) là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là hệ thống đề xuất sản phẩm, nội dung phù hợp với từng người dùng
- Dựa trên hành vi quá khứ, sở thích và thông tin sản phẩm
- Ứng dụng trong thương mại điện tử, video, nhạc, tin tức
- Các cách tiếp cận: lọc cộng tác, lọc theo nội dung, kết hợp
- Mục tiêu: tăng mức hài lòng và tương tác của người dùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2bf9b958-63b9-56d1-8038-44679064404c', 'Những baseline nào tốt khi xây dựng hệ thống gợi ý?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gợi ý sản phẩm phổ biến nhất, toàn cục hoặc theo từng nhóm
- Gợi ý sản phẩm mới hoặc đang thịnh hành
- Gợi ý sản phẩm người dùng đã xem gần đây hoặc mua lại
- Sản phẩm thường được mua cùng nhau
- Baseline đơn giản thường khó vượt qua nên cần so sánh với mô hình phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c39e281-4620-5c5c-996c-f151c388ccce', 'Lọc cộng tác (collaborative filtering) là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gợi ý dựa trên hành vi của nhiều người dùng, không cần thông tin nội dung sản phẩm
- User-based: tìm người dùng tương tự và gợi ý thứ họ thích
- Item-based: gợi ý sản phẩm tương tự với sản phẩm người dùng đã thích
- Phân rã ma trận (matrix factorization) học vector ẩn cho người dùng và sản phẩm
- Hạn chế: vấn đề khởi đầu lạnh và dữ liệu thưa', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('254de265-de8e-5718-9a6e-01f2315977fd', 'Làm sao đưa phản hồi ngầm (click, lượt xem) vào hệ thống gợi ý?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phản hồi ngầm nhiều hơn phản hồi tường minh nhưng nhiễu và không có tín hiệu tiêu cực rõ ràng
- Coi tương tác là mức độ ưa thích kèm độ tin cậy theo tần suất (ví dụ implicit ALS)
- Lấy mẫu âm từ các sản phẩm không tương tác
- Dùng hàm mất mát xếp hạng như BPR
- Gán trọng số khác nhau cho các loại hành vi: xem, thêm giỏ hàng, mua', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa5bc309-b889-582a-8bdf-1395819ba725', 'Vấn đề khởi đầu lạnh (cold start) trong hệ thống gợi ý là gì? Có những cách nào giải quyết?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xảy ra khi có người dùng mới hoặc sản phẩm mới chưa có dữ liệu tương tác
- Lọc cộng tác không đưa ra gợi ý tốt cho họ
- Dùng lọc theo nội dung dựa trên thuộc tính sản phẩm và thông tin người dùng
- Gợi ý sản phẩm phổ biến, hỏi sở thích khi đăng ký
- Mô hình kết hợp và khám phá chủ động (exploration) để nhanh chóng thu thập dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ae79fa9a-ebc7-5828-8486-d6a2a3197d07', 'Chuỗi thời gian (time series) là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là tập quan sát được sắp xếp theo thời gian, thường cách đều nhau
- Các quan sát liên tiếp thường phụ thuộc nhau (tự tương quan)
- Thường có các thành phần xu hướng, mùa vụ và nhiễu
- Ví dụ: doanh số theo ngày, giá cổ phiếu, nhiệt độ
- Bài toán phổ biến: dự báo giá trị tương lai, phát hiện bất thường', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c73f3428-4d5d-5a57-bfe5-f319cb52d021', 'Bài toán chuỗi thời gian khác bài toán hồi quy thông thường như thế nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Các quan sát không độc lập, giá trị hiện tại phụ thuộc giá trị quá khứ
- Thứ tự thời gian quan trọng, không được xáo trộn dữ liệu
- Chia train, validation theo thời gian để tránh dùng thông tin tương lai
- Cần xử lý xu hướng, mùa vụ, tính dừng
- Đặc trưng thường là giá trị trễ (lag), trung bình trượt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b01fa2c-e414-5c62-ba69-54846a7dae46', 'Bạn biết những mô hình nào cho bài toán chuỗi thời gian?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mô hình đơn giản: naive, trung bình trượt, exponential smoothing, Holt-Winters
- Mô hình thống kê: ARIMA, SARIMA
- Prophet cho chuỗi có mùa vụ và ngày lễ
- Mô hình học máy như gradient boosting với đặc trưng lag
- Mạng nơ-ron: LSTM, mô hình Transformer cho chuỗi thời gian', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c718eeb-0b58-5c87-9ce8-df3d0ac32459', 'Nếu chuỗi thời gian có xu hướng (trend), bạn loại bỏ nó như thế nào và vì sao cần làm vậy?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nhiều mô hình như ARIMA yêu cầu chuỗi dừng (stationary)
- Sai phân: lấy hiệu giữa giá trị hiện tại và giá trị trước
- Ước lượng xu hướng (ví dụ hồi quy theo thời gian) rồi trừ đi
- Biến đổi log để ổn định phương sai
- Phân rã chuỗi thành xu hướng, mùa vụ và phần dư', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7f79af4a-b2a7-505e-8ee8-6630b2d56672', 'Bạn có một chuỗi chỉ gồm một biến y đo theo thời gian. Làm sao dự đoán y ở thời điểm tiếp theo?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bắt đầu với baseline: giá trị cuối cùng hoặc giá trị cùng kỳ mùa vụ trước
- Phân tích tự tương quan để xem giá trị quá khứ ảnh hưởng ra sao
- Dùng mô hình tự hồi quy (AR, ARIMA) với các giá trị trễ làm biến đầu vào
- Exponential smoothing hoặc Holt-Winters khi có xu hướng, mùa vụ
- Đánh giá bằng backtest theo thời gian', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac325c6e-2314-5c17-ad52-b7f2b13dd9b0', 'Bạn có một chuỗi biến y kèm một tập đặc trưng. Bạn dự đoán y ở thời điểm tiếp theo như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tạo đặc trưng trễ của y và của các đặc trưng khác, trung bình trượt, đặc trưng thời gian
- Chỉ dùng thông tin có sẵn tại thời điểm dự đoán để tránh rò rỉ
- Mô hình: hồi quy tuyến tính, ARIMAX, gradient boosting, mạng nơ-ron
- Chia dữ liệu và kiểm định theo thời gian (walk-forward)
- So sánh với baseline chỉ dùng y', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('24f5c880-d4a7-5b45-a169-b5356840164e', 'Dùng mô hình dựa trên cây cho chuỗi thời gian có những vấn đề gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cây không ngoại suy được: dự đoán bị giới hạn trong khoảng giá trị đã thấy khi huấn luyện
- Khó nắm bắt xu hướng tăng hoặc giảm kéo dài
- Không tự hiểu thứ tự thời gian, cần tự tạo đặc trưng lag
- Khắc phục bằng cách dự đoán sai phân hoặc loại xu hướng trước, hoặc kết hợp với mô hình tuyến tính', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b21d5a75-4de9-5c23-873f-56e37d0e6542', 'Gần đây bạn đã học được điều gì mới?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu điều bạn vừa học -> vì sao bạn học nó và đã áp dụng vào đâu -> điều bạn muốn tìm hiểu tiếp.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4a43dcad-55f2-585b-8cfb-784d4e1da387', 'Điều gì trong lập trình khiến bạn hào hứng nhất?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('01818968-9c0c-521f-9bf2-fc3d803e85b0', 'Hãy kể về một thách thức kỹ thuật gần đây bạn gặp phải và cách bạn giải quyết nó.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb091d18-cc5b-5d70-872f-4c1fe5dce30d', 'Khi xây dựng hoặc bảo trì website, bạn đã dùng những kỹ thuật nào để tăng hiệu năng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Giảm dung lượng tải: nén (gzip, brotli), minify, tối ưu ảnh, dùng định dạng ảnh hiện đại
- Tận dụng cache trình duyệt và CDN
- Code splitting, lazy load ảnh và component, loại bỏ code thừa (tree shaking)
- Tối ưu đường render quan trọng: CSS quan trọng tải trước, script dùng defer hoặc async
- Đo bằng Lighthouse, Core Web Vitals trước và sau khi tối ưu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f71d064d-a809-5f1a-a7e8-4ae99f1243db', 'Bạn đã áp dụng những best practice SEO nào cho website?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng HTML ngữ nghĩa, cấu trúc heading hợp lý, thẻ title và meta description riêng cho từng trang
- URL rõ ràng, sitemap, robots.txt, canonical để tránh nội dung trùng
- Thuộc tính alt cho ảnh, dữ liệu có cấu trúc (schema.org)
- Tốc độ tải trang và trải nghiệm di động tốt (Core Web Vitals)
- Với ứng dụng SPA, dùng SSR hoặc static rendering để công cụ tìm kiếm đọc được nội dung', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('edba0faf-87a4-53c9-b57e-33eeeb2d9b0f', 'Bạn biết những kỹ thuật hoặc vấn đề bảo mật phổ biến nào ở phía frontend?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- XSS: escape dữ liệu khi hiển thị, hạn chế chèn HTML thô, dùng Content-Security-Policy
- CSRF: dùng token, cookie SameSite
- Lưu token cẩn thận: ưu tiên cookie HttpOnly, Secure thay vì localStorage
- Chống clickjacking bằng header X-Frame-Options hoặc frame-ancestors
- Cập nhật thư viện để tránh lỗ hổng, không để lộ thông tin bí mật trong code frontend', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa316420-0140-5c29-9b4c-130c52a3f8e5', 'Trong các dự án gần đây, bạn đã làm gì để code dễ bảo trì hơn?', 'IT', 'Frontend Developer', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9d936dcb-38bf-5c2f-a3a5-2de97efc513e', 'Bạn hãy chia sẻ về môi trường phát triển mà bạn ưa thích.', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Giới thiệu công cụ và thiết lập bạn đang dùng -> lý do chọn dựa trên trải nghiệm -> điều bạn muốn cải thiện trong quy trình làm việc.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('262aeee1-d991-5964-9d63-68c1c4d6eca8', 'Bạn hãy mô tả quy trình làm việc của bạn khi xây dựng một trang web.', 'IT', 'Frontend Developer', 'MEDIUM', 'INTRO', 'Mô tả các bước từ nhận yêu cầu, thiết kế tới triển khai -> nêu công cụ và cách kiểm tra chất lượng ở mỗi bước -> nói về cách phối hợp với thiết kế và backend.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('791256e4-ba7c-5364-a3b7-6a1a1b48dccc', 'Progressive enhancement và graceful degradation khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Progressive enhancement: bắt đầu từ phiên bản cơ bản chạy trên mọi trình duyệt rồi bổ sung tính năng nâng cao khi trình duyệt hỗ trợ
- Graceful degradation: xây cho trình duyệt hiện đại trước rồi đảm bảo vẫn dùng được ở mức chấp nhận trên trình duyệt cũ
- Progressive enhancement đặt nội dung và chức năng cốt lõi làm trung tâm
- Progressive enhancement thường tốt hơn cho khả năng truy cập và SEO
- Cả hai đều nhằm phục vụ người dùng trên nhiều môi trường khác nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1c0abc44-4995-5ad4-99c1-6709246718a7', 'Bạn tối ưu tài nguyên (asset) của website như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Minify và nén CSS, JavaScript; loại bỏ code không dùng
- Tối ưu ảnh: nén, đúng kích thước, định dạng WebP hoặc AVIF, ảnh responsive
- Đặt cache header dài hạn kèm tên file có hash
- Phục vụ qua CDN, dùng HTTP/2 hoặc HTTP/3
- Lazy load tài nguyên không cần ngay, preload tài nguyên quan trọng như font', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('75312e48-d442-5121-83c7-9b41352c7b42', 'Nếu tham gia một dự án đang dùng quy ước code khác với thói quen của bạn, ví dụ thụt dòng bằng tab thay vì space, bạn sẽ làm gì?', 'IT', 'Chung', 'EASY', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dbb72106-0aa1-5801-bfc5-93feda9d5c13', 'Nếu được chọn thành thạo một công nghệ mới trong năm nay, bạn sẽ chọn công nghệ nào? Vì sao?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1592d3d6-00fe-56d9-a3e1-ee9d2f4b357b', 'Flash of Unstyled Content (FOUC) là gì? Làm sao để tránh?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- FOUC là hiện tượng trang hiển thị nội dung chưa có style trong chốc lát rồi mới áp dụng CSS
- Nguyên nhân: CSS tải muộn, được chèn bằng JavaScript hoặc đặt sai vị trí
- Tránh bằng cách đặt thẻ link CSS trong phần head để chặn render tới khi có CSS
- Inline CSS quan trọng cho phần đầu trang
- Với CSS-in-JS cần trích xuất style khi render phía server', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e623b586-90db-59d6-92aa-c79cddbf0b9c', 'ARIA và trình đọc màn hình là gì? Làm sao để website dễ tiếp cận (accessibility)?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Trình đọc màn hình là phần mềm đọc nội dung trang cho người khiếm thị
- ARIA là bộ thuộc tính bổ sung vai trò, trạng thái, nhãn cho phần tử khi HTML ngữ nghĩa chưa đủ
- Ưu tiên dùng thẻ HTML ngữ nghĩa (button, nav, label) trước khi dùng ARIA
- Hỗ trợ điều hướng bằng bàn phím, focus rõ ràng, văn bản thay thế cho ảnh
- Độ tương phản màu đủ; kiểm tra bằng công cụ như Lighthouse, axe và trình đọc màn hình thật', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4c3038b-d1f8-57ce-a07a-5c3b03edb9a1', 'CSS animation và JavaScript animation có ưu nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CSS animation và transition đơn giản, khai báo, trình duyệt tối ưu tốt, phù hợp hiệu ứng đơn giản
- Animate transform và opacity bằng CSS có thể chạy trên compositor, mượt kể cả khi luồng chính bận
- JavaScript animation linh hoạt hơn: điều khiển phức tạp, tạm dừng, đảo ngược, phụ thuộc tương tác, vật lý
- JavaScript nên dùng requestAnimationFrame hoặc Web Animations API
- Thư viện như GSAP, Framer Motion hỗ trợ animation phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a5fcdaf6-234a-5449-8dbf-c68f4b23e392', 'CORS là gì và nó giải quyết vấn đề gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CORS (Cross-Origin Resource Sharing) là cơ chế cho phép máy chủ chỉ định origin nào được truy cập tài nguyên của nó từ trình duyệt
- Same-origin policy mặc định chặn JavaScript đọc response từ origin khác
- Máy chủ trả header Access-Control-Allow-Origin và các header liên quan để cho phép
- Request không đơn giản sẽ có preflight request bằng method OPTIONS
- CORS do trình duyệt thực thi, không bảo vệ API khỏi client khác như curl', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e87b0303-fb88-5926-9291-4ccaa207137b', 'Hãy kể về một lần bạn bất đồng ý kiến với quản lý hoặc đồng nghiệp. Bạn đã xử lý như thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6497b0ec-c9ff-5065-841e-d13ada58dbe2', 'Theo bạn, một frontend developer giỏi cần những kỹ năng gì?', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Nêu các nhóm kỹ năng chuyên môn và kỹ năng mềm -> liên hệ với những gì bạn đã có qua trải nghiệm -> nói kỹ năng bạn đang bổ sung.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd0fabc0-1d39-58a1-90e3-3714716160a8', 'Bạn định hướng phát triển bản thân theo vai trò nào trong 3 đến 5 năm tới?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ef6095b7-a0cf-55d1-b331-4a0125ca63f1', 'SSR và CSR khác nhau như thế nào? Bạn có biết static rendering và hydration không?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CSR: trình duyệt tải JavaScript rồi mới render giao diện; tương tác mượt sau khi tải nhưng hiển thị lần đầu chậm và kém SEO
- SSR: máy chủ render HTML cho mỗi request; hiển thị nhanh, tốt cho SEO nhưng tăng tải máy chủ
- Static rendering (SSG): render HTML lúc build, phục vụ qua CDN rất nhanh, hợp nội dung ít thay đổi
- Hydration: JavaScript ở client gắn sự kiện và trạng thái vào HTML có sẵn để trang tương tác được
- Có thể kết hợp tuỳ trang, ví dụ incremental static regeneration, streaming SSR', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('75b6201b-b2de-51e8-9184-020ee3ce2e21', 'Khai báo doctype ở đầu tài liệu HTML có tác dụng gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Doctype cho trình duyệt biết tài liệu dùng chuẩn HTML nào
- Với HTML5, khai báo doctype html giúp trình duyệt render ở chế độ chuẩn (standards mode)
- Thiếu doctype, trình duyệt chuyển sang quirks mode mô phỏng hành vi trình duyệt cũ
- Quirks mode khiến box model và bố cục hiển thị khác nhau giữa các trình duyệt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('85954413-9cb9-546f-9eba-240ff62a5995', 'Bạn phục vụ một trang web có nội dung đa ngôn ngữ như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khai báo thuộc tính lang cho trang và cho đoạn nội dung khác ngôn ngữ
- Tách nội dung theo ngôn ngữ bằng URL riêng (ví dụ đường dẫn có mã ngôn ngữ) thay vì chỉ dựa vào cookie
- Dùng header Accept-Language để gợi ý ngôn ngữ nhưng cho phép người dùng tự chọn
- Khai báo hreflang để công cụ tìm kiếm hiểu các phiên bản ngôn ngữ
- Dùng thư viện i18n và file dịch thay vì viết cứng chuỗi trong code', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6aa1e8b2-2287-52f6-b832-f83cb385e240', 'Khi thiết kế website đa ngôn ngữ cần lưu ý những gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Độ dài văn bản thay đổi theo ngôn ngữ, giao diện phải co giãn được
- Hỗ trợ ngôn ngữ viết từ phải sang trái
- Định dạng ngày giờ, số, tiền tệ, số nhiều theo locale
- Không chèn chữ vào ảnh, không ghép chuỗi dịch theo thứ tự cứng
- Font hỗ trợ đủ ký tự, màu sắc và hình ảnh phù hợp văn hoá', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('251715fe-c1ba-54c6-9820-f5d066293416', 'Thuộc tính data trong HTML dùng để làm gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thuộc tính data cho phép gắn dữ liệu tuỳ chỉnh vào phần tử HTML mà vẫn hợp lệ
- Đọc từ JavaScript qua thuộc tính dataset của phần tử
- Có thể dùng làm selector trong CSS
- Hay dùng để gắn id, trạng thái cho xử lý sự kiện hoặc làm mốc cho kiểm thử tự động
- Không nên lưu dữ liệu nhạy cảm hoặc dữ liệu lớn vì ai cũng đọc được', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fda4e038-e0c7-52d2-a763-fe25728444f1', 'Những thành phần chính tạo nên nền tảng HTML5 là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thẻ ngữ nghĩa mới: header, footer, nav, article, section, main
- Đa phương tiện có sẵn: audio, video, không cần plugin
- Đồ hoạ: canvas, SVG
- Lưu trữ phía client: localStorage, sessionStorage, IndexedDB
- Các API: geolocation, drag and drop, web worker, WebSocket, form với kiểu input và validate mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('27119408-0cfd-5c38-bd98-f617d227ee6d', 'Cookie, sessionStorage và localStorage khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cookie được gửi kèm mỗi request tới máy chủ, dung lượng khoảng 4KB, có thời hạn và cờ bảo mật như HttpOnly
- localStorage lưu lâu dài tới khi bị xoá, dung lượng vài MB, không gửi lên máy chủ
- sessionStorage chỉ tồn tại trong một tab và mất khi đóng tab
- Cả localStorage và sessionStorage đọc được bằng JavaScript nên không nên lưu thông tin nhạy cảm
- Cookie hợp với phiên đăng nhập; storage hợp với dữ liệu giao diện phía client', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('75d391ea-0108-568b-8e6d-fa586c2e94aa', 'Thẻ script thông thường, script với async và script với defer khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Script thông thường chặn việc phân tích HTML trong lúc tải và chạy
- async tải song song và chạy ngay khi tải xong, có thể chen giữa lúc phân tích HTML, không giữ thứ tự
- defer tải song song và chỉ chạy sau khi phân tích xong HTML, giữ đúng thứ tự
- Dùng async cho script độc lập như analytics; defer cho script phụ thuộc DOM hoặc phụ thuộc nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('343f3b60-263b-5251-b8fe-79b5c7452863', 'Vì sao thường đặt thẻ CSS trong phần head và thẻ script ngay trước khi kết thúc body? Có ngoại lệ nào không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CSS đặt trong head để trình duyệt có style trước khi render, tránh nhấp nháy nội dung chưa có style
- Script đặt cuối body để không chặn việc phân tích và hiển thị HTML
- Script ở cuối cũng truy cập được các phần tử DOM đã có
- Ngoại lệ: script cần chạy sớm như polyfill, phát hiện tính năng, analytics
- Hiện nay có thể đặt script trong head với defer hoặc async', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ee425d44-d5e4-5b5d-af0c-33f265ef5620', 'Progressive rendering là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là các kỹ thuật giúp hiển thị nội dung cho người dùng càng sớm càng tốt
- Lazy load ảnh và nội dung nằm ngoài màn hình
- Ưu tiên nội dung phía trên màn hình, inline CSS quan trọng
- Gửi HTML theo từng phần (streaming) để trình duyệt hiển thị dần
- Giúp cải thiện thời gian hiển thị nội dung đầu tiên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34111d16-4782-5b45-8e8c-224ae8bd083b', 'Vì sao nên dùng thuộc tính srcset trên thẻ ảnh? Trình duyệt chọn ảnh từ thuộc tính này như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- srcset cung cấp nhiều phiên bản ảnh với độ phân giải hoặc kích thước khác nhau
- Trình duyệt chọn ảnh phù hợp với kích thước hiển thị và mật độ điểm ảnh của màn hình
- Kết hợp với sizes để cho biết ảnh chiếm bao nhiêu chiều rộng ở mỗi điều kiện
- Giúp thiết bị nhỏ tải ảnh nhẹ hơn, màn hình độ phân giải cao có ảnh sắc nét
- Trình duyệt có thể cân nhắc thêm tốc độ mạng và cache', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('24e1e541-a723-53cb-bd04-a3e472ac24b4', 'Canvas và SVG khác nhau như thế nào? Khi nào nên chọn cái nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SVG là đồ hoạ vector dựa trên các phần tử trong DOM, co giãn không vỡ hình
- Canvas vẽ theo điểm ảnh bằng JavaScript, không giữ đối tượng sau khi vẽ
- SVG dễ gắn sự kiện, style bằng CSS, tốt cho accessibility; chậm khi có rất nhiều phần tử
- Canvas hiệu năng cao với số lượng đối tượng lớn, phù hợp game, xử lý ảnh, biểu đồ dữ liệu lớn
- Chọn SVG cho icon, biểu đồ đơn giản, minh hoạ; chọn canvas cho đồ hoạ động phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8c868cc9-7926-501c-af28-5986e3fa70b6', 'CSS specificity là gì và được tính như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Specificity quyết định quy tắc CSS nào được áp dụng khi nhiều quy tắc cùng nhắm tới một phần tử
- Thứ tự mức độ: style inline, rồi selector id, rồi class, thuộc tính và pseudo-class, cuối cùng là thẻ và pseudo-element
- Selector có specificity cao hơn thắng; nếu bằng nhau thì quy tắc khai báo sau thắng
- important ghi đè specificity thông thường, nên hạn chế dùng
- Giữ selector đơn giản, ít lồng giúp CSS dễ bảo trì', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1dd8745-a97b-5d9c-aa68-ca49440230aa', 'Reset CSS và normalize CSS khác nhau như thế nào? Bạn chọn cách nào và vì sao?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Reset CSS xoá gần như toàn bộ style mặc định của trình duyệt, đưa về điểm xuất phát trống
- Normalize CSS giữ style mặc định hữu ích và chỉ sửa sự khác nhau giữa các trình duyệt
- Normalize ít phải viết lại style cơ bản hơn và dễ debug hơn
- Reset hợp khi thiết kế hoàn toàn tuỳ chỉnh
- Nhiều dự án dùng phiên bản reset hiện đại tối giản hoặc lớp base của framework CSS', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eccf3b24-1bec-54af-a232-27a744df7ae3', 'Float trong CSS hoạt động như thế nào? Làm sao xử lý việc phần tử cha không bao được phần tử float?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Float đưa phần tử ra khỏi luồng bình thường, đẩy sang trái hoặc phải, nội dung inline bao quanh nó
- Phần tử cha không tính chiều cao của phần tử float nên có thể bị sụp chiều cao
- Khắc phục bằng clearfix: thêm pseudo-element sau cùng với thuộc tính clear
- Hoặc tạo block formatting context cho phần tử cha, ví dụ display flow-root
- Ngày nay bố cục nên dùng flexbox hoặc grid; float chủ yếu dùng cho văn bản bao quanh ảnh', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('78832ddf-7f64-5999-8b28-5a00a14228e4', 'z-index là gì và stacking context được hình thành như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- z-index quyết định thứ tự chồng lớp của phần tử theo trục z, chỉ có tác dụng với phần tử được định vị hoặc phần tử con của flex, grid
- Stacking context là một nhóm phần tử được sắp xếp lớp độc lập với bên ngoài
- Tạo ra bởi phần tử gốc, phần tử định vị có z-index khác auto, opacity nhỏ hơn 1, transform, filter, position fixed hoặc sticky
- z-index của phần tử con chỉ so sánh trong stacking context của cha
- Vì vậy z-index rất lớn vẫn có thể nằm dưới phần tử thuộc stacking context khác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('505ec29a-9c64-540b-bfc2-791cbdf88830', 'Block Formatting Context (BFC) là gì và hoạt động như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- BFC là một vùng bố cục độc lập, nơi các khối được sắp xếp theo chiều dọc
- Phần tử tạo BFC bao trọn các phần tử float bên trong
- Margin của phần tử bên trong không bị gộp (collapse) với margin bên ngoài
- Không bị phần tử float bên ngoài đè lên
- Tạo bởi phần tử gốc, float, position absolute hoặc fixed, overflow khác visible, display flow-root, flex hoặc grid item', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3a601fb2-d0f1-523f-83c2-662f28b67815', 'Bạn xử lý lỗi hiển thị chỉ xảy ra trên một số trình duyệt như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định chính xác trình duyệt và phiên bản bị lỗi, tái hiện bằng công cụ dev hoặc dịch vụ kiểm thử trình duyệt
- Kiểm tra mức hỗ trợ của tính năng (ví dụ trang Can I use)
- Dùng normalize CSS, autoprefixer, polyfill
- Dùng feature query để cung cấp phương án dự phòng
- Hạn chế hack theo trình duyệt cụ thể, ghi chú lý do khi buộc phải dùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa55c991-075b-5b77-8565-2fac3c475dff', 'Có những cách nào để ẩn nội dung về mặt hiển thị nhưng vẫn cho trình đọc màn hình đọc được?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- display none và visibility hidden ẩn với cả trình đọc màn hình nên không dùng cho mục đích này
- Dùng lớp visually-hidden: kích thước 1px, clip, overflow hidden, position absolute
- Không dùng chữ màu trùng nền hay text-indent âm quá lớn vì gây vấn đề khác
- Có thể dùng aria-label cho phần tử cần nhãn mà không hiển thị chữ
- Ngược lại aria-hidden giúp ẩn phần tử trang trí khỏi trình đọc màn hình', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('83f8a11b-b036-5337-b8d2-498c035f6dd6', 'Ngoài screen, media query còn hỗ trợ những loại nào khác? Hãy cho ví dụ sử dụng.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- print: tạo style riêng khi in trang, ví dụ ẩn menu, quảng cáo
- all: áp dụng cho mọi thiết bị
- Đặc tính media như prefers-color-scheme để hỗ trợ chế độ tối
- prefers-reduced-motion để giảm animation cho người nhạy cảm
- hover và pointer để phân biệt thiết bị cảm ứng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e7c9f1d7-ce4c-5d51-95a0-7b39bccde7f4', 'Những lưu ý nào giúp viết CSS hiệu quả?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Giữ selector đơn giản, ít lồng, tránh selector quá cụ thể
- Đặt tên theo quy ước rõ ràng như BEM để dễ bảo trì
- Tránh lạm dụng important
- Hạn chế thuộc tính gây tính lại layout khi animate; dùng transform và opacity
- Loại bỏ CSS không dùng, tách CSS quan trọng cho lần hiển thị đầu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('53333af2-59c4-5d0b-add2-60f2b174194e', 'CSS preprocessor có những ưu và nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ví dụ: Sass, Less
- Ưu điểm: biến, mixin, hàm, lồng selector, chia file giúp code dễ tổ chức và tái sử dụng
- Nhược điểm: cần bước build, lồng quá sâu tạo selector phức tạp, khó debug hơn
- CSS hiện đại đã có biến (custom properties) và lồng selector gốc nên nhu cầu giảm
- Lựa chọn tuỳ dự án và công cụ như PostCSS, Tailwind', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('398c80ff-2f64-57d1-802a-27f51081c229', 'Bạn triển khai một thiết kế dùng font không phổ biến như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng web font khai báo bằng font-face hoặc dịch vụ như Google Fonts
- Dùng định dạng WOFF2 để nhẹ, chỉ tải các kiểu và bộ ký tự cần thiết (subset)
- Đặt font-display như swap để chữ vẫn hiện trong lúc tải font
- Preload font quan trọng
- Khai báo font dự phòng tương tự để giảm nhảy bố cục; kiểm tra bản quyền font', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e28f6ee3-8941-5d12-9bc1-cefa5a7c0fa9', 'Trình duyệt xác định phần tử nào khớp với một CSS selector như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Trình duyệt so khớp selector từ phải sang trái
- Bắt đầu từ phần cuối cùng (key selector) để tìm các phần tử ứng viên
- Sau đó đi ngược lên cây DOM để kiểm tra các điều kiện tổ tiên
- Cách này giúp loại nhanh phần lớn phần tử không khớp
- Vì vậy key selector quá chung kèm nhiều cấp lồng tốn kém hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3fa755ef-c1d1-54b5-aace-b7b699f96dc3', 'Pseudo-element là gì và dùng để làm gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Pseudo-element cho phép style một phần cụ thể của phần tử hoặc chèn nội dung ảo
- Viết với hai dấu hai chấm, ví dụ before, after, first-line, first-letter, placeholder, selection
- before và after kết hợp thuộc tính content để thêm biểu tượng, trang trí, clearfix
- Không tạo thêm phần tử trong HTML
- Nội dung chèn bằng CSS không nên chứa thông tin quan trọng vì kém tiếp cận', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('20b2ebf8-74b6-5578-8f63-5449f3cbf5e2', 'Box model trong CSS là gì? Làm sao bảo trình duyệt dùng box model khác nhau? Thuộc tính box-sizing với giá trị border-box có lợi ích gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi phần tử là một hộp gồm content, padding, border và margin
- Mặc định content-box: width và height chỉ tính phần content
- border-box: width và height đã bao gồm padding và border
- border-box giúp tính kích thước dễ dự đoán, đặc biệt với bố cục theo phần trăm
- Thường áp dụng border-box cho mọi phần tử ngay từ đầu dự án', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e01a64bc-7c65-5770-a67d-3dd7baadbae4', 'Thuộc tính display trong CSS dùng để làm gì? Bạn hãy kể vài giá trị phổ biến.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- display quyết định cách phần tử tạo hộp và tham gia bố cục
- block: chiếm toàn bộ chiều ngang, xuống dòng mới
- inline: nằm trên cùng dòng, không đặt được width, height
- inline-block: nằm trên dòng nhưng đặt được kích thước
- flex và grid cho bố cục hiện đại; none để ẩn hoàn toàn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('df384f17-0682-55f4-9401-037de3e5f1d9', 'Inline và inline-block khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cả hai đều nằm trên cùng dòng với nội dung khác
- Inline không nhận width và height
- Padding và margin theo chiều dọc của inline không đẩy các dòng xung quanh
- Inline-block nhận width, height, padding, margin đầy đủ như một khối
- Inline-block hợp với nút, thẻ nhãn cần kích thước cố định', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26171cbc-fc24-5033-820e-6de52d51cb0c', 'Selector nth-child và nth-of-type khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- nth-child đếm theo vị trí trong tất cả phần tử con của cha, không phân biệt loại thẻ
- nth-of-type chỉ đếm các phần tử con cùng loại thẻ
- Ví dụ cha có lẫn thẻ h2 và p thì p thứ hai theo nth-of-type có thể không phải là con thứ hai theo nth-child
- Chọn nth-of-type khi danh sách con trộn nhiều loại thẻ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('383e41f2-b679-5220-97d8-7c7cc8965bf2', 'Các giá trị static, relative, absolute, fixed và sticky của thuộc tính position khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- static: mặc định, theo luồng bình thường, không dùng top, left
- relative: vẫn giữ chỗ trong luồng, dịch chuyển tương đối so với vị trí gốc; làm mốc cho con absolute
- absolute: ra khỏi luồng, định vị theo tổ tiên gần nhất có position khác static
- fixed: định vị theo khung nhìn, đứng yên khi cuộn
- sticky: như relative cho tới khi cuộn tới ngưỡng thì dính lại như fixed trong phạm vi cha', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa9abdcf-bf65-59b1-a692-300bff423556', 'Thiết kế responsive và chiến lược mobile-first khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Responsive là website tự điều chỉnh bố cục theo kích thước màn hình
- Mobile-first là cách tiếp cận viết style cho màn hình nhỏ trước rồi mở rộng bằng media query min-width
- Cách ngược lại là viết cho desktop trước rồi thu nhỏ bằng max-width
- Mobile-first buộc tập trung vào nội dung cốt lõi và thường nhẹ hơn trên di động
- Mobile-first là một cách để làm responsive, không phải thay thế', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('82a46fdf-0f0b-5237-a656-7df86f41bcf1', 'Bạn xử lý hình ảnh cho màn hình độ phân giải cao (retina) như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Màn hình retina có mật độ điểm ảnh cao nên ảnh thường bị mờ
- Dùng srcset với ảnh 2x, 3x để trình duyệt chọn phù hợp
- Dùng SVG hoặc icon font cho icon và hình vector
- Dùng media query theo độ phân giải cho ảnh nền
- Cân bằng giữa độ nét và dung lượng tải', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4a4f3ea7-6eb4-59c6-9054-5418f7164ce9', 'Khi di chuyển phần tử, khi nào nên dùng transform translate thay vì định vị absolute với top và left, và ngược lại?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- translate không làm thay đổi luồng bố cục, phần tử vẫn giữ chỗ ban đầu
- Animate translate chỉ cần composite, có thể dùng GPU nên mượt hơn
- Thay đổi top, left gây tính lại layout và paint mỗi khung hình
- Dùng translate cho animation và hiệu ứng di chuyển
- Dùng absolute khi cần đặt phần tử cố định trong bố cục', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b0b02c6b-5c83-5be3-a955-aad28d2ec6e2', 'Các đơn vị px, em và rem khác nhau như thế nào khi đặt cỡ chữ?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- px là đơn vị cố định
- em tương đối so với cỡ chữ của phần tử cha, dễ bị cộng dồn khi lồng nhau
- rem tương đối so với cỡ chữ của phần tử gốc html
- rem giúp tôn trọng thiết lập cỡ chữ của người dùng và dễ kiểm soát hơn
- Thường dùng rem cho cỡ chữ, em cho khoảng cách phụ thuộc cỡ chữ của chính thành phần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ff49020a-f86e-5a75-8858-2220afb97762', 'Pseudo-class là gì? Hãy cho ví dụ sử dụng.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Pseudo-class chọn phần tử theo trạng thái hoặc vị trí, không cần thêm class
- Trạng thái tương tác: hover, focus, active, visited
- Trạng thái form: checked, disabled, invalid
- Vị trí: first-child, last-child, nth-child
- Ví dụ đổi màu nút khi hover, hiển thị viền khi ô nhập không hợp lệ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c289b4c-ade7-5e68-ad5f-7509aafadeb2', 'Phần tử block và phần tử inline khác nhau như thế nào? Hãy cho ví dụ.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phần tử block bắt đầu dòng mới và chiếm toàn bộ chiều ngang có sẵn
- Phần tử block nhận width, height, margin đầy đủ
- Phần tử inline nằm trên cùng dòng, chỉ chiếm độ rộng nội dung
- Ví dụ block: div, p, h1, ul, section
- Ví dụ inline: span, a, strong, em', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a32281ea-ab75-5c56-b6d1-011299885b4b', 'CSS Grid và Flexbox khác nhau như thế nào? Khi nào dùng cái nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Flexbox bố cục theo một chiều: hàng hoặc cột
- Grid bố cục hai chiều: cả hàng và cột cùng lúc
- Flexbox phù hợp sắp xếp thành phần trong một dải như thanh menu, căn giữa, danh sách nút
- Grid phù hợp bố cục trang tổng thể, lưới thẻ, vùng có hàng và cột rõ ràng
- Hai cách thường được kết hợp: grid cho khung, flexbox cho chi tiết bên trong', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eeae1b5c-4267-55e2-9472-6766bac094fb', 'Bố cục fixed, fluid và responsive khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Fixed: chiều rộng cố định bằng px, không đổi theo màn hình, dễ tràn trên màn hình nhỏ
- Fluid: dùng đơn vị tương đối như phần trăm, co giãn theo màn hình nhưng có thể quá hẹp hoặc quá rộng
- Responsive: kết hợp bố cục linh hoạt với media query để đổi bố cục theo điểm ngắt
- Responsive mang lại trải nghiệm tốt nhất trên nhiều thiết bị', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0b8345aa-5a3c-5a8a-a374-b2350f50f8a7', 'Event delegation là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gắn một listener ở phần tử cha thay vì gắn cho từng phần tử con
- Dựa trên cơ chế event bubbling: sự kiện ở con nổi lên cha
- Trong handler dùng event.target để xác định phần tử con được tương tác
- Tiết kiệm bộ nhớ khi có nhiều phần tử
- Hoạt động cả với phần tử con được thêm động sau này', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d3d4de9e-f6eb-5360-a0f4-12c2a0258d25', 'Từ khoá this trong JavaScript hoạt động như thế nào? ES6 đã thay đổi cách làm việc với this ra sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Giá trị this phụ thuộc cách hàm được gọi, không phụ thuộc nơi khai báo
- Gọi với new: this là object mới; gọi như method: this là object chứa method
- Gọi hàm thông thường: this là undefined ở strict mode hoặc global object
- call, apply, bind cho phép chỉ định this
- Arrow function trong ES6 không có this riêng mà lấy this của phạm vi bao quanh', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4e1697f-8477-5e8e-a92f-1721adc5dfda', 'Kế thừa nguyên mẫu (prototypal inheritance) trong JavaScript hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi object có liên kết tới một object khác gọi là prototype
- Khi truy cập thuộc tính không có trên object, JavaScript tìm lên chuỗi prototype
- Chuỗi kết thúc ở Object.prototype rồi tới null
- Hàm khởi tạo gán prototype cho object tạo bằng new; có thể tạo trực tiếp bằng Object.create
- Class trong ES6 là cú pháp dựa trên cơ chế này', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('927f172c-3a55-5806-8cbd-aa73c7d2d99e', 'Biến có giá trị null, undefined và biến chưa khai báo khác nhau như thế nào? Kiểm tra từng trường hợp ra sao?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Chưa khai báo: truy cập sẽ báo lỗi ReferenceError; typeof vẫn trả về chuỗi undefined mà không lỗi
- undefined: đã khai báo nhưng chưa gán giá trị
- null: được gán chủ đích để biểu thị không có giá trị
- Kiểm tra null và undefined bằng so sánh nghiêm ngặt ba dấu bằng
- So sánh hai dấu bằng coi null và undefined là bằng nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('89a2a451-c35e-5436-baba-a7e29669a469', 'Closure là gì? Bạn dùng closure trong trường hợp nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Closure là khi một hàm ghi nhớ và truy cập được biến trong phạm vi nơi nó được tạo, kể cả khi phạm vi đó đã kết thúc
- Hình thành mỗi khi hàm được tạo bên trong hàm khác
- Dùng để tạo biến riêng tư, đóng gói dữ liệu
- Dùng trong hàm factory, currying, callback, debounce
- Cần lưu ý giữ tham chiếu không cần thiết có thể gây tốn bộ nhớ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e8f1ace0-2965-509d-943f-2baf06dac92e', 'Bạn dùng những cách nào để duyệt thuộc tính của object và phần tử của mảng?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Object: for...in (kèm kiểm tra thuộc tính riêng), Object.keys, Object.values, Object.entries
- Mảng: vòng for truyền thống, for...of, forEach
- Các phương thức map, filter, reduce khi cần tạo kết quả mới
- for...in không nên dùng cho mảng
- for và for...of cho phép dừng sớm bằng break, forEach thì không', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('809f1d41-ba6b-5169-a49f-293771b9d1f5', 'Phương thức forEach và map của mảng khác nhau như thế nào? Khi nào chọn cái nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- forEach chạy hàm cho từng phần tử và không trả về gì
- map chạy hàm cho từng phần tử và trả về mảng mới chứa kết quả
- Dùng map khi cần biến đổi dữ liệu thành mảng mới, giữ mảng gốc không đổi
- Dùng forEach khi chỉ cần thực hiện tác vụ phụ như ghi log
- Phương thức khác: filter, reduce, find, some, every', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('800d501b-9c04-5092-81f4-803d42b3a08b', 'Hàm ẩn danh (anonymous function) thường được dùng trong trường hợp nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Làm callback ngắn cho map, filter, xử lý sự kiện, setTimeout
- Dùng trong IIFE để tạo phạm vi riêng
- Dùng khi hàm chỉ cần dùng một lần, không cần đặt tên
- Nhược điểm: khó nhận biết trong stack trace khi debug và không gỡ listener được nếu không giữ tham chiếu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ca2de1ae-fa00-56c7-a2c5-b72866877c0f', 'Gọi một hàm khởi tạo có và không có từ khoá new khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khai báo hàm chỉ định nghĩa hàm, chưa chạy
- Gọi với new: tạo object mới, gán làm this, liên kết prototype và trả về object đó
- Gọi không có new: chạy như hàm thường, this là undefined ở strict mode hoặc global object
- Nếu hàm không return gì, gọi không có new trả về undefined và có thể vô tình gán thuộc tính lên global
- Class trong ES6 bắt buộc gọi bằng new để tránh lỗi này', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3837380e-3bb4-5dc4-8d9a-b53c62422c68', 'Khai báo hàm (function declaration) và biểu thức hàm (function expression) khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Function declaration được hoisting cả phần thân nên gọi được trước dòng khai báo
- Function expression gán hàm cho biến, chỉ biến được hoisting nên gọi trước khi gán sẽ lỗi
- Function expression có thể ẩn danh hoặc có tên
- Function expression hợp khi truyền hàm làm tham số hoặc gán có điều kiện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f157c871-e363-5c5c-81f8-c5c018c76d7d', 'Phương thức call và apply của hàm dùng để làm gì? Chúng khác nhau ở điểm nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cả hai gọi hàm ngay lập tức với giá trị this được chỉ định
- call nhận các đối số truyền lần lượt
- apply nhận các đối số dưới dạng một mảng
- Dùng để mượn method của object khác hoặc gọi hàm với this tuỳ chọn
- Hiện nay có thể dùng spread syntax thay cho nhiều trường hợp dùng apply', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c561224-7cf8-55a8-a839-9db0a2767c64', 'Phương thức bind của hàm dùng để làm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- bind tạo ra hàm mới có this được cố định theo giá trị truyền vào
- Không gọi hàm ngay, khác với call và apply
- Có thể cố định trước một số đối số (partial application)
- Hay dùng khi truyền method làm callback để không bị mất this
- Hàm đã bind không thể bị đổi this bằng bind lần nữa', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e0e55f33-42d1-5eed-aaca-db7f043e44aa', 'Feature detection, feature inference và kiểm tra chuỗi user agent khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Feature detection: kiểm tra trực tiếp trình duyệt có hỗ trợ tính năng hay không rồi mới dùng
- Feature inference: thấy có tính năng A rồi suy ra có tính năng B, dễ sai
- Kiểm tra user agent: đoán trình duyệt từ chuỗi định danh, dễ bị giả mạo và lỗi thời
- Feature detection là cách được khuyến nghị
- CSS cũng có feature query để kiểm tra hỗ trợ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5f726ca6-757c-51f6-a074-b6fc787440e0', 'Hoisting trong JavaScript là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hoisting là việc khai báo biến và hàm được đưa lên đầu phạm vi trong giai đoạn biên dịch
- var được hoisting và khởi tạo bằng undefined
- let, const, class được hoisting nhưng nằm trong temporal dead zone, truy cập trước khai báo sẽ lỗi
- Function declaration được hoisting cả phần thân
- Chỉ khai báo được đưa lên, phép gán vẫn nằm ở vị trí cũ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('91b901a7-fb26-539f-82cc-8fb6dcf6343d', 'Ép kiểu ngầm (type coercion) là gì? Dựa vào ép kiểu ngầm trong JavaScript có những rủi ro gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ép kiểu ngầm là JavaScript tự chuyển giá trị sang kiểu khác khi thực hiện phép toán hoặc so sánh
- Ví dụ cộng số với chuỗi thành nối chuỗi, so sánh hai dấu bằng giữa số và chuỗi
- Rủi ro: kết quả khó đoán, lỗi khó phát hiện, ví dụ chuỗi rỗng và số 0 đều là falsy
- Nên dùng so sánh nghiêm ngặt và chuyển kiểu tường minh bằng Number, String, Boolean
- TypeScript giúp phát hiện sớm lỗi kiểu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('73d6f2f9-5221-5167-b1c7-33eb7a64514c', 'Event bubbling và event capturing trong JavaScript là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Một sự kiện DOM đi qua ba pha: capturing, target, bubbling
- Capturing: sự kiện đi từ gốc tài liệu xuống tới phần tử đích
- Bubbling: sự kiện nổi ngược từ phần tử đích lên các tổ tiên
- Mặc định listener chạy ở pha bubbling; truyền tuỳ chọn capture để chạy ở pha capturing
- stopPropagation dừng lan truyền; bubbling là nền tảng của event delegation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d46b0749-586a-5e90-8dae-0913d5c90038', 'Attribute và property của phần tử DOM khác nhau như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Attribute được định nghĩa trong HTML, luôn là chuỗi
- Property là thuộc tính của object DOM trong JavaScript, có thể có nhiều kiểu dữ liệu
- Khi tải trang, nhiều attribute được dùng để khởi tạo property tương ứng
- Một số property thay đổi theo tương tác mà attribute không đổi, ví dụ value của ô input
- Đọc ghi attribute qua getAttribute, setAttribute; property truy cập trực tiếp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('45d084ea-7ba3-5bb3-b473-bbff35d6beb1', 'Mở rộng các object có sẵn của JavaScript (như Array.prototype) có ưu nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ưu điểm: thêm phương thức tiện dụng có thể gọi trực tiếp
- Nhược điểm: dễ xung đột với thư viện khác hoặc với phương thức chuẩn trong tương lai
- Ảnh hưởng toàn cục, khó debug và gây hành vi bất ngờ
- Ngoại lệ chấp nhận được là polyfill cho tính năng chuẩn còn thiếu
- Nên viết hàm tiện ích riêng thay vì sửa prototype có sẵn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('93da094b-8c65-5b1e-84a8-057f6fbefcec', 'Toán tử hai dấu bằng và ba dấu bằng khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hai dấu bằng so sánh sau khi ép kiểu ngầm
- Ba dấu bằng so sánh nghiêm ngặt cả giá trị và kiểu, không ép kiểu
- Hai dấu bằng cho các kết quả khó đoán, ví dụ số 0 bằng chuỗi rỗng
- Nên dùng ba dấu bằng mặc định
- Ngoại lệ phổ biến: so sánh hai dấu bằng với null để kiểm tra cả null và undefined', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('746fe4ae-5b92-5938-bf21-642b8ac8a9b4', 'Same-origin policy trong JavaScript là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là chính sách bảo mật của trình duyệt giới hạn cách tài liệu ở một origin tương tác với tài nguyên origin khác
- Origin gồm giao thức, tên miền và cổng
- Ngăn script độc hại ở một trang đọc dữ liệu nhạy cảm ở trang khác
- Áp dụng cho việc đọc response của request, truy cập DOM của iframe, storage
- Có thể nới lỏng có kiểm soát bằng CORS, postMessage', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1c396359-4bb2-5286-9610-88fc45e6fa84', 'Strict mode trong JavaScript là gì? Ưu nhược điểm khi dùng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Strict mode là chế độ chạy chặt chẽ hơn, bật bằng chỉ thị use strict
- Biến lỗi im lặng thành lỗi rõ ràng, ví dụ gán vào biến chưa khai báo
- this trong hàm thường là undefined thay vì global object
- Cấm một số cú pháp dễ gây lỗi, giúp engine tối ưu tốt hơn
- Module ES và class tự động ở strict mode; nhược điểm là code cũ có thể không tương thích', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('53a562cd-9a33-53ba-af9a-75f4a097c995', 'Viết code bằng ngôn ngữ biên dịch sang JavaScript (như TypeScript) có ưu nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ưu điểm: kiểu tĩnh giúp phát hiện lỗi sớm, gợi ý code tốt, refactor an toàn
- Hỗ trợ cú pháp mới và biên dịch cho môi trường cũ
- Nhược điểm: thêm bước build và cấu hình
- Cần học thêm, đôi khi định nghĩa kiểu cho thư viện chưa đầy đủ
- Debug cần source map để khớp với code gốc', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b57546c0-b107-532b-9ca7-4dcd1752bfc5', 'Bạn dùng công cụ và kỹ thuật gì để debug code JavaScript?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- DevTools của trình duyệt: breakpoint, xem biến, call stack, chạy từng bước
- Lệnh debugger trong code, breakpoint có điều kiện
- console.log, console.table có chọn lọc
- Tab Network để xem request, tab Performance để phân tích hiệu năng
- React DevTools, source map, công cụ theo dõi lỗi như Sentry trên production', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('027acb2f-04fe-5b44-bd3c-4a991d956dea', 'Object mutable và immutable khác nhau như thế nào? Bất biến (immutability) có ưu nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Object mutable có thể thay đổi sau khi tạo; immutable thì không, mọi thay đổi tạo ra bản mới
- Trong JavaScript, giá trị nguyên thuỷ như chuỗi, số là bất biến; object và mảng mặc định thay đổi được
- Ưu điểm: dễ dự đoán, dễ debug, phát hiện thay đổi nhanh bằng so sánh tham chiếu (hữu ích cho React)
- Nhược điểm: tạo nhiều object mới tốn bộ nhớ, code cập nhật lồng nhau dài
- Thực hiện bằng Object.freeze, spread, hoặc thư viện như Immer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd965f5b-4f99-53ad-b8bd-9b1e42fe4067', 'Hàm đồng bộ và bất đồng bộ khác nhau như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hàm đồng bộ chạy tuần tự, câu lệnh sau phải chờ câu lệnh trước xong
- Hàm bất đồng bộ khởi động tác vụ rồi trả quyền điều khiển ngay, kết quả xử lý sau
- JavaScript đơn luồng nên tác vụ chậm như gọi mạng phải làm bất đồng bộ để không treo giao diện
- Xử lý kết quả bằng callback, Promise hoặc async/await
- Event loop điều phối việc chạy các callback khi call stack rỗng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7058e2a9-d07c-559f-b6ee-4b03a416083e', 'Vì sao bạn muốn làm việc tại công ty chúng tôi?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu những điểm bạn tìm hiểu được về công ty -> liên hệ với kinh nghiệm và giá trị của bạn -> nói bạn muốn đóng góp và phát triển gì ở đây.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce260428-37e3-5fbd-a82f-9c3fd339b9fa', 'Vì sao bạn muốn rời công ty hiện tại (hoặc gần nhất)?', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Nêu lý do một cách tích cực, không chê bai công ty cũ -> liên hệ với điều bạn đã học được ở đó -> hướng tới điều bạn tìm kiếm ở cơ hội mới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7eb84664-d80e-5984-ad39-62ba897bb957', 'Bạn tìm kiếm điều gì ở công việc tiếp theo?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8a8f933c-6a9b-5df9-85fa-fce5dbfd60bf', 'Hãy kể về một lần bạn phải thuyết phục người khác đồng ý với giải pháp hoặc ý tưởng của mình.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('49bacf96-13c6-53f8-a7fa-e2b8c4127549', 'Lỗi (bug) khó nhất mà bạn từng sửa trong 6 tháng gần đây là gì?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e01f20cb-12d5-51fa-9060-16ded4f21857', 'Điều gì trong công việc dễ khiến bạn nản lòng, và bạn xử lý điều đó thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5d636db2-e97a-57af-98ea-b4e45674f25f', 'Giả sử hôm nay là ngày đầu tiên bạn làm việc ở đây, bạn muốn bắt tay vào việc gì hoặc cải thiện điều gì của sản phẩm?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0de2852a-17e3-5842-af3d-5c876229dabb', 'Một ngày làm việc hiệu quả nhất của bạn diễn ra như thế nào?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3f3dcef-8b3b-5105-98cf-78876c4bf685', 'Góp ý mang tính xây dựng nhất mà bạn từng nhận được là gì, và bạn đã thay đổi ra sao sau góp ý đó?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4bd464a2-2e12-55d2-b27c-15d3ea7e538d', 'Hãy kể về một mục tiêu đòi hỏi bạn kiên trì trong nhiều tháng liên tục.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1ddb1545-286f-5de6-bdf6-8c8572be59f4', 'Hãy kể về một lần bạn phải hoàn thành công việc với hạn chót rất gấp.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('15363f91-7dc1-592a-b19b-f3412fe8f3d5', 'Nếu đây là buổi đánh giá cuối năm đầu tiên của bạn ở công ty chúng tôi, bạn mong tôi sẽ nhận xét gì về bạn?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('122f12fa-6efa-5097-aa34-ffab15a027a0', 'Bạn hãy chia sẻ một kỹ năng quản lý thời gian mà bạn đã học và áp dụng hiệu quả trong công việc.', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('907e492e-28a9-5ab7-8497-fc52d5309aab', 'Theo bạn, những thế mạnh nào quan trọng nhất để làm tốt vị trí bạn đang ứng tuyển?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu các thế mạnh quan trọng và lý do -> chứng minh bạn có những thế mạnh đó qua ví dụ -> nói điều bạn đang tiếp tục rèn luyện.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b501452f-889d-5223-9456-e6cfc1ba91a7', 'Bạn mong muốn đạt được những gì trong 6 tháng đầu sau khi được tuyển?', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('13bfd435-bda7-5cd5-9496-23f0f7a5cf06', 'Vì sao bạn là ứng viên phù hợp với vị trí này?', 'IT', 'Chung', 'EASY', 'INTRO', 'Tóm tắt yêu cầu chính của vị trí -> đối chiếu với kinh nghiệm, kỹ năng và thành tựu cụ thể của bạn -> nói thêm giá trị bạn mang lại.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c4afc902-93d3-54a4-8bec-c83c2f2e5453', 'Điều gì ở công việc quản trị hệ thống và vận hành khiến bạn hứng thú?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3cc7e082-0929-560c-806a-ac82f361c11f', 'Bạn có đóng góp cho dự án mã nguồn mở nào không? Hãy chia sẻ trải nghiệm đó.', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0675061b-36d6-529c-99a6-7a54963aaa97', 'Bạn hãy mô tả hệ thống lab cá nhân (homelab) mà bạn đã dựng để học hoặc thử nghiệm.', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'INTRO', 'Giới thiệu thành phần và mục đích của lab -> những gì bạn đã học hoặc thử nghiệm được -> dự định mở rộng tiếp theo.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5ea88f82-dab5-524e-a572-1c322ecf488e', 'Thành tựu cá nhân nào khiến bạn tự hào nhất?', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('71afce3a-8fb9-5d85-8214-ce2a021c7c0a', 'Sai lầm lớn nhất bạn từng mắc trong công việc là gì? Nếu gặp lại, bạn sẽ làm khác thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c3c06c73-010a-5ec5-a0ad-5dd9f6cd42ce', 'Ngày đầu tiên ở công việc mới, bạn sẽ cài đặt và thiết lập những công cụ nào cho mình?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'INTRO', 'Kể các công cụ chính và mục đích sử dụng -> giải thích lựa chọn dựa trên trải nghiệm trước -> nói cách bạn làm quen với công cụ sẵn có của đội.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('02758af3-b0e0-598e-819c-2ae78e79fa30', 'Bạn quản lý và chia sẻ tài liệu, kiến thức vận hành (wiki, runbook) như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1fbffb5-a631-52be-bd69-13814d31d72a', 'Nếu công ty hỗ trợ chi phí thi chứng chỉ, bạn sẽ chọn chứng chỉ nào? Vì sao?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('109183b9-da6f-5c8e-b58f-6353900bb9c1', 'Bạn phối hợp với đội phát triển như thế nào để tránh tình trạng hai bên đổ lỗi cho nhau?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('97d5404f-f495-5fd5-8860-1fc547357e3c', 'Unix, Linux, BSD và GNU khác nhau như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Unix là hệ điều hành gốc phát triển tại Bell Labs, sau thành họ hệ điều hành và tiêu chuẩn thương mại
- Linux là kernel do Linus Torvalds viết, kết hợp với công cụ GNU tạo thành các bản phân phối
- GNU là dự án phần mềm tự do cung cấp trình biên dịch, shell, thư viện và công cụ dòng lệnh
- BSD là họ hệ điều hành bắt nguồn từ Unix của Berkeley, gồm cả kernel và userland, ví dụ FreeBSD, OpenBSD
- Linux và BSD đều tương tự Unix nhưng khác nhau về giấy phép (GPL so với BSD) và cách tổ chức', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4515bfc2-2301-57a6-bb1d-e249667a98de', 'Chạy lệnh bằng tài khoản root thường xuyên là thói quen tốt hay xấu? Vì sao?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là thói quen xấu
- Một lệnh gõ nhầm có thể phá hỏng cả hệ thống vì root không bị giới hạn quyền
- Phần mềm độc hại hoặc lỗ hổng chạy dưới root sẽ chiếm toàn quyền
- Khó truy vết ai đã làm gì khi mọi người dùng chung root
- Nên dùng tài khoản thường và sudo cho từng lệnh cần quyền cao, có ghi log', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7bc63ff7-c65c-5641-aab3-76ca74ff4f3a', 'Mọi lệnh đều báo command not found. Bạn tìm nguyên nhân và khắc phục thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Nguyên nhân thường gặp là biến PATH bị ghi đè hoặc bị xoá
- Kiểm tra giá trị PATH hiện tại
- Dùng đường dẫn tuyệt đối để chạy lệnh, ví dụ gọi trực tiếp trong thư mục bin
- Tạm thời đặt lại PATH với các thư mục chuẩn
- Tìm và sửa dòng gán PATH sai trong các file khởi tạo shell như bashrc, profile', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2370c99c-568c-531b-9855-fd85b7498a3f', 'Bạn bấm Ctrl+C nhưng script vẫn tiếp tục chạy. Bạn dừng nó như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày các bước kiểm tra từ tổng quát tới cụ thể -> nêu công cụ dùng ở mỗi bước -> nói cách xử lý và phòng tránh lần sau.', '- Ctrl+C gửi SIGINT, script có thể bắt hoặc bỏ qua tín hiệu này (trap) hoặc đang chờ tiến trình con
- Thử Ctrl+Z để tạm dừng rồi kill tiến trình theo job
- Từ terminal khác tìm PID và gửi SIGTERM
- Nếu vẫn không dừng mới dùng SIGKILL
- Kiểm tra và dừng cả các tiến trình con còn sót', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d27de116-f921-523f-b82e-a96a9b28d18e', 'Index trong cơ sở dữ liệu là gì và vì sao cần nó?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Index là cấu trúc dữ liệu phụ giúp tìm bản ghi nhanh mà không phải quét toàn bộ bảng
- Phổ biến nhất là B-tree, cho phép tìm theo giá trị và theo khoảng trong thời gian logarit
- Tăng tốc truy vấn có điều kiện lọc, sắp xếp và join trên cột được đánh index
- Đổi lại tốn thêm dung lượng và làm chậm thao tác ghi vì phải cập nhật index
- Khoá chính và ràng buộc unique thường tự tạo index', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e7cafce9-7837-5b71-aef6-7a00d51f5b9f', 'Correlated subquery là gì? Nó ảnh hưởng hiệu năng thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là truy vấn con tham chiếu tới cột của truy vấn bên ngoài
- Về mặt logic được thực thi lại cho từng dòng của truy vấn ngoài
- Có thể rất chậm với bảng lớn nếu bộ tối ưu không viết lại được
- Thường thay bằng JOIN, EXISTS hoặc window function để hiệu quả hơn
- Ví dụ: tìm nhân viên có lương cao hơn lương trung bình của phòng ban mình', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f7562029-df58-51c5-9bcf-934d0e3aa1bc', 'WHERE và HAVING khác nhau như thế nào? GROUP BY dùng để làm gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- GROUP BY gom các dòng có cùng giá trị ở các cột chỉ định thành một nhóm để tính hàm tổng hợp
- WHERE lọc từng dòng trước khi gom nhóm, không dùng được hàm tổng hợp
- HAVING lọc các nhóm sau khi gom, dùng được hàm tổng hợp như COUNT, SUM
- Nên lọc bằng WHERE khi có thể để giảm dữ liệu phải gom nhóm
- Ví dụ: lọc đơn hàng năm nay bằng WHERE, rồi chỉ giữ khách có trên 5 đơn bằng HAVING', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('acc0341b-5f6b-5624-b031-52fbe92b14f0', 'Window function trong SQL là gì? ROW_NUMBER, RANK và DENSE_RANK khác nhau ra sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Window function tính toán trên một tập dòng liên quan (cửa sổ) nhưng không gộp dòng như GROUP BY
- Khai báo bằng mệnh đề OVER với PARTITION BY và ORDER BY
- ROW_NUMBER đánh số liên tục, không trùng
- RANK cho cùng hạng khi bằng nhau và bỏ qua số tiếp theo; DENSE_RANK cho cùng hạng nhưng không bỏ số
- Dùng cho xếp hạng, top N mỗi nhóm, tổng luỹ kế, so sánh với dòng trước sau (LAG, LEAD)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('299d6dda-a1ba-58a9-9ff4-56b959e2f287', 'MVCC trong PostgreSQL hoạt động như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- MVCC (Multi-Version Concurrency Control) giữ nhiều phiên bản của một dòng thay vì khoá khi đọc
- Mỗi phiên bản dòng có thông tin transaction tạo và transaction xoá (xmin, xmax)
- Mỗi transaction đọc theo snapshot, chỉ thấy các phiên bản hợp lệ với snapshot đó
- Đọc không chặn ghi và ghi không chặn đọc
- UPDATE tạo phiên bản mới, phiên bản cũ thành dòng chết cần VACUUM dọn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('08662e0f-d05d-56ee-b85b-088670c73d66', 'VACUUM trong PostgreSQL là gì và vì sao cần nó?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Do MVCC, UPDATE và DELETE để lại các phiên bản dòng chết
- VACUUM thu hồi không gian của dòng chết để tái sử dụng
- Ngăn bảng và index phình to (bloat)
- Ngăn lỗi transaction ID wraparound bằng cách đóng băng các dòng cũ
- Autovacuum chạy tự động; ANALYZE đi kèm cập nhật thống kê cho bộ tối ưu truy vấn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('12f5392a-a7f3-56d6-b737-da015a2b5e94', 'Index B-tree hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- B-tree là cây cân bằng, các khoá được sắp xếp, mỗi nút chứa nhiều khoá
- Tìm kiếm đi từ gốc xuống lá, số bước tỉ lệ logarit với số bản ghi
- Các nút lá liên kết với nhau nên quét theo khoảng và sắp xếp hiệu quả
- Hỗ trợ so sánh bằng, lớn hơn, nhỏ hơn, BETWEEN, LIKE có tiền tố
- Không hiệu quả với LIKE bắt đầu bằng ký tự đại diện hoặc khi bọc cột trong hàm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3956dd6f-655a-5178-87ea-71c8e275dce5', 'EXPLAIN dùng để làm gì? Bạn đọc kế hoạch thực thi truy vấn như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- EXPLAIN hiển thị kế hoạch mà bộ tối ưu chọn để thực thi truy vấn
- EXPLAIN ANALYZE chạy thật và cho biết thời gian, số dòng thực tế
- Xem kiểu truy cập: sequential scan, index scan, index only scan
- Xem kiểu join (nested loop, hash join, merge join) và chi phí ước tính
- So sánh số dòng ước tính với thực tế để phát hiện thống kê sai, tìm bước tốn kém nhất', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0fc29bd6-0b79-581c-ae59-351ca7fed93e', 'Bạn tối ưu một truy vấn SQL chậm như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác định truy vấn chậm qua log truy vấn chậm hoặc công cụ như pg_stat_statements
- Phân tích bằng EXPLAIN ANALYZE để tìm bước tốn kém
- Thêm hoặc sửa index phù hợp, tránh bọc cột trong hàm làm mất index
- Chỉ lấy cột cần thiết, phân trang hợp lý, viết lại subquery thành join khi phù hợp
- Cập nhật thống kê, cân nhắc cache, denormalize hoặc chia nhỏ bảng khi cần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce8515c4-0d1e-5d65-a8ea-ca5c57194ab4', 'Composite index là gì? Thứ tự cột trong composite index có quan trọng không?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Composite index là index trên nhiều cột
- Thứ tự cột rất quan trọng: index được dùng theo tiền tố từ trái sang phải
- Index trên (a, b) dùng được cho điều kiện trên a hoặc a và b, nhưng không hiệu quả khi chỉ lọc b
- Thường đặt cột lọc bằng trước, cột lọc theo khoảng hoặc sắp xếp sau
- Có thể tạo covering index để truy vấn chỉ cần đọc index', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dcb1fff7-ab5f-54bb-a60b-0a84e436d8bc', 'Khi nào nên tạo index và index có những nhược điểm gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nên tạo cho cột thường dùng trong WHERE, JOIN, ORDER BY trên bảng lớn
- Cột có độ chọn lọc cao (nhiều giá trị khác nhau) hưởng lợi nhiều hơn
- Nhược điểm: tốn dung lượng lưu trữ
- Làm chậm INSERT, UPDATE, DELETE vì phải cập nhật index
- Index không dùng tới vẫn tốn chi phí, cần rà soát định kỳ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b95b268-e0f4-5d5d-ba5e-d92a8d2ce857', 'Có những loại JOIN nào trong SQL? INNER JOIN và LEFT JOIN khác nhau thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- INNER JOIN chỉ trả về các dòng khớp ở cả hai bảng
- LEFT JOIN trả về mọi dòng bảng trái, cột bảng phải là NULL nếu không khớp
- RIGHT JOIN ngược lại với LEFT JOIN
- FULL OUTER JOIN trả về mọi dòng của cả hai bảng
- CROSS JOIN tạo tích Descartes; SELF JOIN là join một bảng với chính nó', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4c599838-23b5-5499-85f4-87fb5a83d208', 'Nên dùng JOIN hay subquery? Vì sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nhiều trường hợp hai cách cho cùng kết quả và bộ tối ưu có thể biến đổi qua lại
- JOIN thường hiệu quả và dễ tối ưu hơn khi cần lấy cột từ nhiều bảng
- Subquery với EXISTS hoặc IN rõ nghĩa khi chỉ cần kiểm tra tồn tại
- Correlated subquery có thể chậm với dữ liệu lớn
- Nên kiểm tra bằng EXPLAIN thay vì theo quy tắc cứng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d9799b16-80d4-536f-8e5d-d02684ee36a9', 'HashMap trong Java hoạt động bên trong như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HashMap lưu dữ liệu trong mảng các bucket
- Vị trí bucket được tính từ hashCode của key sau khi trộn bit, chia lấy dư theo kích thước mảng
- Khi put, nếu bucket đã có phần tử thì so sánh bằng equals để ghi đè hoặc thêm vào
- Khi get, tính bucket rồi tìm phần tử có key bằng equals
- Khi số phần tử vượt ngưỡng load factor, mảng được mở rộng gấp đôi và phân bổ lại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ee717606-def4-5924-b665-fa0e791d1398', 'Collision trong HashMap là gì và được xử lý như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Collision xảy ra khi nhiều key khác nhau rơi vào cùng một bucket
- HashMap xử lý bằng cách lưu các phần tử trong cùng bucket thành danh sách liên kết
- Từ Java 8, khi một bucket có quá nhiều phần tử (từ 8) và mảng đủ lớn, danh sách được chuyển thành cây đỏ đen
- Nhờ đó trường hợp xấu giảm từ O(n) xuống O(log n)
- hashCode phân bố tốt giúp giảm collision', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e8922f8d-5d49-564b-a394-6941a0558500', 'Hợp đồng giữa equals và hashCode trong Java là gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hai object bằng nhau theo equals thì bắt buộc có cùng hashCode
- Hai object cùng hashCode không nhất thiết bằng nhau theo equals
- hashCode phải ổn định nếu các trường dùng trong equals không đổi
- equals phải có tính phản xạ, đối xứng, bắc cầu, nhất quán và trả về false khi so với null
- Vi phạm hợp đồng làm HashMap, HashSet hoạt động sai', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('44f84126-d24d-53cd-b362-59956d5a0a9c', 'Điều gì xảy ra nếu override equals mà không override hashCode?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hai object bằng nhau theo equals có thể có hashCode khác nhau
- Khi dùng làm key trong HashMap hoặc phần tử HashSet, chúng rơi vào bucket khác nhau
- Không tìm thấy phần tử đã thêm khi dùng object tương đương để tra cứu
- HashSet có thể chứa phần tử trùng lặp
- Luôn override cả hai cùng nhau, dựa trên cùng tập trường', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('568017ce-d43c-50c4-ad98-60ad6ae3d6f0', 'Có nên dùng object có thể thay đổi (mutable) làm key trong HashMap không? Điều gì xảy ra nếu sửa key sau khi thêm vào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không nên, key nên bất biến
- Nếu sửa trường dùng trong hashCode sau khi thêm, hashCode thay đổi
- HashMap tìm ở bucket mới nên không lấy lại được giá trị, dù phần tử vẫn còn trong map
- Gây rò rỉ bộ nhớ và lỗi khó phát hiện
- Vì vậy String, Integer hoặc record là lựa chọn tốt cho key', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dd042ef6-e9af-5338-87a6-40a9682c6e43', 'Load factor và capacity của HashMap là gì? Rehashing xảy ra khi nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Capacity là số bucket của mảng bên trong, mặc định 16 và luôn là luỹ thừa của 2
- Load factor là ngưỡng tỉ lệ đầy, mặc định 0.75
- Khi số phần tử vượt capacity nhân load factor, HashMap mở rộng gấp đôi
- Rehashing phân bổ lại mọi phần tử sang mảng mới, tốn chi phí O(n)
- Biết trước số phần tử thì nên đặt capacity ban đầu để tránh rehash nhiều lần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dba240ad-8c93-5556-9ef6-cd0aa6a9563b', 'Độ phức tạp của get và put trong HashMap là bao nhiêu? Khi nào nó trở thành O(n)?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Trung bình là O(1) khi hashCode phân bố tốt
- Trường hợp xấu là khi rất nhiều key rơi vào cùng bucket
- Trước Java 8, bucket là danh sách liên kết nên trường hợp xấu là O(n)
- Từ Java 8, bucket lớn được chuyển thành cây nên trường hợp xấu là O(log n)
- hashCode kém (ví dụ luôn trả cùng giá trị) làm mất ưu điểm của HashMap', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('767d2b54-6dac-5c30-b86f-c8118ba4f81b', 'ConcurrentHashMap là gì và khác HashMap như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HashMap không an toàn luồng: ghi đồng thời có thể mất dữ liệu hoặc hỏng cấu trúc
- ConcurrentHashMap an toàn luồng mà vẫn cho hiệu năng cao
- Đọc hầu như không khoá; ghi khoá ở mức từng bucket và dùng CAS thay vì khoá toàn bộ map
- Không cho phép key hoặc value null
- Có các thao tác nguyên tử như putIfAbsent, computeIfAbsent, merge', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0d053429-b7de-54a0-ba4b-c8750a8ffeca', 'Bạn chọn cài đặt Map nào (HashMap, LinkedHashMap, TreeMap, ConcurrentHashMap) trong từng trường hợp?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HashMap: mặc định khi không cần thứ tự, nhanh nhất
- LinkedHashMap: giữ thứ tự thêm vào hoặc thứ tự truy cập, dùng làm cache LRU
- TreeMap: key được sắp xếp, hỗ trợ tìm theo khoảng, thao tác O(log n)
- ConcurrentHashMap: dùng chung giữa nhiều luồng
- EnumMap cho key là enum, hiệu quả về bộ nhớ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('84dff17d-406e-5aa3-9b82-dc8e90f4174c', 'ACID là gì? Bạn hãy giải thích từng chữ cái.', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Atomicity: transaction thực hiện trọn vẹn hoặc không thực hiện gì
- Consistency: dữ liệu chuyển từ trạng thái hợp lệ này sang trạng thái hợp lệ khác, giữ mọi ràng buộc
- Isolation: các transaction chạy đồng thời không ảnh hưởng sai lệch lẫn nhau
- Durability: transaction đã commit thì không mất kể cả khi hệ thống sập
- Ví dụ chuyển tiền: trừ tài khoản này và cộng tài khoản kia phải cùng thành công', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('96261626-8bea-5df6-98c7-f52c954e3ffc', 'Có những mức cô lập (isolation level) nào trong transaction?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Read Uncommitted: có thể đọc dữ liệu chưa commit (dirty read)
- Read Committed: chỉ đọc dữ liệu đã commit, nhưng đọc lại có thể ra kết quả khác
- Repeatable Read: đọc lại cùng dòng cho cùng kết quả, có thể gặp phantom read tuỳ hệ quản trị
- Serializable: kết quả như các transaction chạy tuần tự, an toàn nhất nhưng chậm nhất
- Mức càng cao càng ít hiện tượng bất thường nhưng giảm khả năng đồng thời; PostgreSQL mặc định Read Committed, MySQL InnoDB mặc định Repeatable Read', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b67d6c55-a865-5e0c-a5e3-442b2c94a323', 'Dirty read, non-repeatable read và phantom read là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dirty read: đọc dữ liệu mà transaction khác chưa commit, có thể bị rollback sau đó
- Non-repeatable read: đọc lại cùng một dòng nhưng giá trị đã bị transaction khác sửa và commit
- Phantom read: chạy lại cùng truy vấn nhưng xuất hiện hoặc mất dòng do transaction khác thêm hoặc xoá
- Mỗi mức cô lập ngăn được một phần các hiện tượng này
- Serializable ngăn được tất cả', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('03d5be3d-8c14-50c0-9281-f81fb59a8160', 'Lost update là gì và làm sao phòng tránh?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Lost update xảy ra khi hai transaction cùng đọc rồi ghi đè một dòng, thay đổi của một bên bị mất
- Ví dụ hai người cùng trừ tồn kho dựa trên giá trị đọc được trước đó
- Cập nhật nguyên tử ngay trong câu lệnh, ví dụ cộng trừ trực tiếp trên cột
- Khoá bi quan bằng SELECT FOR UPDATE
- Khoá lạc quan bằng cột version, hoặc dùng mức cô lập cao hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d69a4ec1-ad83-55f9-b7b4-9e5d843ac293', 'Transaction propagation trong Spring là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Propagation quy định method có annotation Transactional tham gia transaction hiện có hay tạo mới
- REQUIRED (mặc định): dùng transaction hiện có, nếu chưa có thì tạo mới
- REQUIRES_NEW: luôn tạo transaction mới, tạm dừng transaction hiện tại
- NESTED: tạo savepoint trong transaction hiện tại
- Các mức khác: SUPPORTS, NOT_SUPPORTED, MANDATORY, NEVER', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d85d336d-aae4-59fb-8b21-32e6cce496a5', 'Propagation REQUIRED và REQUIRES_NEW khác nhau như thế nào? Khi nào dùng REQUIRES_NEW?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- REQUIRED tham gia transaction đang có, mọi thao tác commit hoặc rollback cùng nhau
- REQUIRES_NEW tạm dừng transaction ngoài và chạy transaction độc lập, commit hoặc rollback riêng
- Lỗi trong transaction trong REQUIRED làm cả transaction ngoài bị đánh dấu rollback
- Dùng REQUIRES_NEW khi cần lưu kết quả bất kể transaction ngoài thất bại, ví dụ ghi log kiểm toán
- Lưu ý REQUIRES_NEW chiếm thêm kết nối cơ sở dữ liệu và có thể gây deadlock', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ceefb9ef-68c5-5f35-a3ac-7738b8cd6948', 'Annotation Transactional trong Spring hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Đánh dấu method hoặc class cần chạy trong transaction
- Spring tạo proxy bọc bean, mở transaction trước khi gọi method và commit hoặc rollback sau đó
- Có thể cấu hình propagation, isolation, timeout, readOnly, rollbackFor
- Thường đặt ở tầng service, nơi chứa nghiệp vụ
- Chỉ có tác dụng khi gọi qua proxy, với method public', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1ee7c980-0121-5eb3-b986-2a5a5465570e', 'Mặc định Spring rollback transaction với những exception nào? Làm sao rollback với checked exception?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mặc định rollback với unchecked exception (RuntimeException) và Error
- Checked exception mặc định không làm rollback, transaction vẫn commit
- Cấu hình rollbackFor để rollback với checked exception cụ thể
- Có thể dùng noRollbackFor để không rollback với một số runtime exception
- Nếu exception bị bắt và nuốt trong method thì transaction không rollback', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('16833fe3-750e-5b04-8354-dfa17feb5d39', 'Transaction readOnly là gì và có tác dụng gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Đánh dấu transaction chỉ đọc dữ liệu
- Hibernate có thể bỏ qua dirty checking và flush, giảm tốn bộ nhớ và CPU
- Một số driver và cơ sở dữ liệu tối ưu cho truy vấn chỉ đọc
- Có thể dùng để định tuyến truy vấn sang bản sao đọc (read replica)
- Là gợi ý, không phải cơ chế bảo vệ chắc chắn chống ghi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0ab9fe02-c823-5b7f-aa02-c0f30278ba7e', 'Điều gì xảy ra khi một method gọi method có Transactional khác trong cùng class?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Lời gọi nội bộ (self-invocation) đi thẳng tới đối tượng thật, không qua proxy
- Do đó cấu hình transaction của method được gọi không được áp dụng
- Ví dụ REQUIRES_NEW hoặc readOnly bị bỏ qua
- Khắc phục: tách method sang bean khác, hoặc tự inject proxy của chính bean
- Hoặc dùng AspectJ weaving thay vì proxy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7a00fab1-c4f4-554b-8598-6b2f9970ffcf', 'String pool trong Java hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- String pool là vùng lưu các chuỗi literal dùng chung để tiết kiệm bộ nhớ
- Chuỗi literal giống nhau trỏ tới cùng một object trong pool
- Tạo bằng new String luôn tạo object mới ngoài pool
- Phương thức intern trả về chuỗi tương ứng trong pool, thêm vào nếu chưa có
- Từ Java 7, string pool nằm trong heap', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('15a9afe7-5757-589a-9a02-1a51ce9e87d6', 'Vì sao String trong Java là bất biến?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cho phép dùng chung chuỗi trong string pool an toàn
- An toàn luồng mà không cần đồng bộ
- Có thể cache hashCode, giúp String là key tốt cho HashMap
- Bảo mật: tham số như đường dẫn file, URL, tên lớp không bị thay đổi sau khi kiểm tra
- Đổi lại mỗi lần sửa chuỗi đều tạo object mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('20b74a86-c0b3-5fac-8216-2c2fccf64e7b', 'Khi nào dùng StringBuilder và khi nào dùng StringBuffer?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cả hai là chuỗi có thể thay đổi, dùng khi cần ghép chuỗi nhiều lần
- StringBuffer đồng bộ các method nên an toàn luồng nhưng chậm hơn
- StringBuilder không đồng bộ, nhanh hơn
- Hầu hết trường hợp dùng StringBuilder vì chuỗi thường chỉ dùng trong một luồng
- StringBuffer chủ yếu còn trong code cũ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eadcb04a-2d77-54df-9b1b-b2625ad7a4f9', 'Điều gì xảy ra khi nối chuỗi bằng toán tử cộng trong Java? Vì sao nối trong vòng lặp lại chậm?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Vì String bất biến, mỗi lần nối tạo ra một object chuỗi mới
- Trình biên dịch tối ưu biểu thức nối đơn lẻ (dùng StringBuilder hoặc invokedynamic từ Java 9)
- Trong vòng lặp, mỗi vòng tạo chuỗi mới và sao chép dữ liệu cũ, tổng chi phí O(n bình phương)
- Nên dùng StringBuilder khi nối trong vòng lặp
- Hoặc dùng String.join, Collectors.joining', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7839105a-9d9b-5ab7-a887-9c2a754a408d', 'So sánh chuỗi bằng toán tử == và equals khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- == so sánh tham chiếu, kiểm tra hai biến có trỏ cùng một object
- equals so sánh nội dung ký tự của chuỗi
- Hai chuỗi literal giống nhau có thể == là true do string pool, nhưng không nên dựa vào đó
- Chuỗi tạo lúc chạy (new, nối chuỗi, đọc từ input) thường == là false dù nội dung giống
- Luôn dùng equals hoặc equalsIgnoreCase để so sánh nội dung', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2f9e857a-f670-5163-a70e-200a6afe5f21', 'Immutable object là gì và mang lại những lợi ích gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là object không thể thay đổi trạng thái sau khi được tạo
- An toàn luồng mà không cần đồng bộ
- Dễ hiểu, dễ dự đoán, không lo bị sửa ngoài ý muốn khi truyền đi
- An toàn khi làm key cho HashMap, phần tử cho HashSet, dễ cache
- Ví dụ trong Java: String, Integer, LocalDate, record', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c30d94fe-2caf-5994-96cd-2a6fce4b80a5', 'Làm thế nào để tạo một class bất biến trong Java?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khai báo class là final để không bị kế thừa
- Mọi trường là private final, gán giá trị trong constructor
- Không cung cấp setter hay method làm thay đổi trạng thái
- Với trường tham chiếu tới object mutable, sao chép phòng thủ khi nhận vào và khi trả ra
- Có thể dùng record cho các class dữ liệu đơn giản', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('03c73286-fc6c-5d9f-bf30-9fea1a57cf9a', 'Chỉ khai báo mọi trường là final có đủ để class bất biến không?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không đủ
- final chỉ ngăn gán lại tham chiếu, không ngăn sửa nội dung object được tham chiếu
- Trường là List hoặc Date vẫn có thể bị sửa qua getter hoặc qua tham chiếu bên ngoài
- Cần sao chép phòng thủ và trả về bản sao hoặc view không sửa được
- Class cũng cần là final để lớp con không phá vỡ tính bất biến', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('32eaa19a-7930-533f-9f53-80c84939cb15', 'Defensive copy là gì và khi nào cần dùng?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là tạo bản sao của object mutable thay vì giữ hoặc trả về tham chiếu gốc
- Dùng trong constructor khi nhận tham số mutable, để bên ngoài không sửa được trạng thái nội bộ
- Dùng trong getter khi trả về trường mutable
- Cần thiết khi xây class bất biến hoặc bảo vệ bất biến của đối tượng
- Với collection có thể dùng List.copyOf để vừa sao chép vừa không sửa được', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e97683df-5855-544a-badd-8926cc2795a2', 'Collections.unmodifiableList khác gì với một danh sách thật sự bất biến như List.copyOf?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- unmodifiableList trả về view chỉ đọc bọc quanh danh sách gốc
- Mọi thao tác sửa qua view ném UnsupportedOperationException
- Nhưng nếu danh sách gốc bị sửa, view vẫn thấy thay đổi
- List.copyOf hoặc List.of tạo bản sao độc lập, thật sự bất biến, không chấp nhận null
- Muốn bảo vệ trạng thái nội bộ nên sao chép rồi mới bọc, hoặc dùng List.copyOf', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c9f29b7-d483-51f6-8d30-60d46cbde49e', 'Shallow copy và deep copy khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Shallow copy tạo object mới nhưng các trường tham chiếu vẫn trỏ cùng object con với bản gốc
- Sửa object con qua bản sao sẽ ảnh hưởng bản gốc
- Deep copy sao chép đệ quy cả các object con, hai bản hoàn toàn độc lập
- Deep copy tốn chi phí hơn, cần cẩn thận với tham chiếu vòng
- clone mặc định của Java là shallow copy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3e70762c-7497-5966-a915-874cc6b9f8a3', 'Vì sao class bất biến nên được khai báo final?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Nếu không final, lớp con có thể thêm trạng thái mutable
- Lớp con có thể override method để trả về giá trị khác hoặc làm lộ trạng thái
- Code nhận kiểu của lớp cha sẽ tưởng object bất biến nhưng thực ra không
- Thay thế: để constructor private và dùng factory method
- Record trong Java mặc định là final', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ddad7ca0-c526-50e7-8f42-907eb4100214', 'Record trong Java là gì và giúp gì cho việc tạo class bất biến?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Record (từ Java 16) là class dữ liệu ngắn gọn, khai báo các thành phần trong phần header
- Tự sinh constructor, các method truy cập, equals, hashCode, toString
- Các trường là private final và record là final
- Có thể thêm kiểm tra trong compact constructor
- Bất biến nông: thành phần là object mutable vẫn cần sao chép phòng thủ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c52df108-89f9-51bd-b934-c44d090a3da3', 'Object bất biến có những nhược điểm gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi thay đổi tạo object mới nên tốn bộ nhớ và tăng áp lực cho garbage collector
- Cập nhật cấu trúc lồng nhau dài dòng
- Không phù hợp với object thay đổi thường xuyên hoặc rất lớn
- Thường giảm thiểu bằng builder, tái sử dụng object hoặc cấu trúc dữ liệu persistent
- Trong phần lớn trường hợp, lợi ích về an toàn và đơn giản lớn hơn chi phí', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce3f4b93-7330-5618-b9f0-b29a8fd56c92', 'Container hoá là gì và vì sao các ứng dụng backend cần nó?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Container hoá đóng gói ứng dụng cùng thư viện và cấu hình vào một image chạy độc lập
- Chạy nhất quán giữa máy dev, test và production
- Nhẹ hơn máy ảo vì dùng chung kernel của máy chủ, khởi động nhanh
- Dễ triển khai, mở rộng và rollback theo phiên bản image
- Là nền tảng cho microservices và điều phối bằng Kubernetes', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ba49e126-11ee-5bee-9ee0-e5ad33ef879d', 'Dockerfile là gì? Những chỉ thị chính trong Dockerfile là gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dockerfile là file mô tả các bước xây dựng một Docker image
- FROM chọn image nền; WORKDIR đặt thư mục làm việc
- COPY đưa file vào image; RUN chạy lệnh lúc build như cài thư viện
- ENV đặt biến môi trường; EXPOSE khai báo port
- CMD và ENTRYPOINT quy định lệnh chạy khi container khởi động; mỗi chỉ thị tạo một layer có thể cache', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('11b1abd2-e4bf-5024-ba4e-83480982e0dc', 'CMD và ENTRYPOINT trong Dockerfile khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ENTRYPOINT quy định chương trình chính luôn được chạy khi container khởi động
- CMD cung cấp lệnh hoặc tham số mặc định, dễ bị ghi đè khi chạy container
- Khi dùng cả hai, CMD trở thành tham số mặc định cho ENTRYPOINT
- Nên dùng dạng mảng (exec form) để tiến trình là PID 1 và nhận tín hiệu dừng đúng
- Ví dụ ENTRYPOINT là java -jar app.jar, CMD là các tham số mặc định', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0dc5a21b-5bbb-532d-88eb-b20c933249dd', 'Multi-stage build trong Docker là gì và có lợi ích gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng nhiều câu lệnh FROM trong một Dockerfile, mỗi stage có môi trường riêng
- Stage build chứa công cụ build như JDK, Maven để biên dịch
- Stage cuối chỉ sao chép artifact cần thiết sang image nền nhỏ như JRE
- Image cuối nhỏ hơn, ít lỗ hổng bảo mật hơn vì không chứa công cụ build
- Tận dụng cache layer để build nhanh hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('096062dd-17ff-5b23-877e-c70166f5eed4', 'Docker Compose là gì và dùng khi nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Docker Compose định nghĩa và chạy ứng dụng nhiều container bằng một file YAML
- Khai báo service, image, port, biến môi trường, volume, mạng và phụ thuộc giữa các service
- Một lệnh để khởi động hoặc dừng toàn bộ hệ thống
- Phù hợp cho môi trường dev, test, ví dụ chạy ứng dụng kèm PostgreSQL, Redis
- Không thay thế được công cụ điều phối như Kubernetes cho production quy mô lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('70a1879c-d5cc-5a11-9512-f980cae2d094', 'Kubernetes là gì và vì sao cần nó?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Kubernetes là nền tảng điều phối container trên một cụm nhiều máy
- Tự động triển khai, mở rộng và khởi động lại container lỗi
- Phân phối tải, phát hiện dịch vụ, cấu hình và quản lý bí mật
- Rolling update và rollback không gián đoạn
- Mô tả trạng thái mong muốn bằng khai báo, Kubernetes liên tục đưa hệ thống về trạng thái đó', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a387de34-6620-5454-ab6a-fb7a9eb6ea05', 'Pod trong Kubernetes là gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Pod là đơn vị triển khai nhỏ nhất trong Kubernetes
- Chứa một hoặc nhiều container dùng chung mạng (cùng địa chỉ IP) và volume
- Thường mỗi pod chạy một container chính, có thể kèm sidecar
- Pod là tạm thời, có thể bị xoá và tạo lại với IP khác
- Thường được quản lý qua Deployment hoặc StatefulSet thay vì tạo trực tiếp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0dbb88e9-e7f1-5cbf-b9f0-6e3519a45c75', 'Service trong Kubernetes là gì? Có những loại Service nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Service cung cấp địa chỉ và tên DNS ổn định cho một nhóm pod được chọn bằng label
- Cân bằng tải giữa các pod phía sau
- ClusterIP (mặc định): chỉ truy cập trong cụm
- NodePort: mở một port trên mọi node để truy cập từ ngoài
- LoadBalancer: tạo cân bằng tải của nhà cung cấp cloud; ngoài ra có ExternalName', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ab52fc3e-6a57-588c-bbf7-4f3908ac209f', 'Mở rộng (scaling) trong Kubernetes hoạt động như thế nào? HorizontalPodAutoscaler là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mở rộng ngang bằng cách tăng giảm số bản sao pod của Deployment
- Có thể chỉnh số bản sao thủ công
- HorizontalPodAutoscaler tự điều chỉnh số pod dựa trên chỉ số như CPU, bộ nhớ hoặc chỉ số tuỳ chỉnh
- Cần đặt resource request cho container để autoscaler tính toán đúng
- Cluster autoscaler thêm bớt node khi cụm thiếu hoặc thừa tài nguyên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('27c974f6-ac15-5e0d-903b-8705e04bd4f0', 'ConfigMap và Secret trong Kubernetes khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cả hai tách cấu hình khỏi image, đưa vào pod qua biến môi trường hoặc file
- ConfigMap lưu cấu hình không nhạy cảm như URL, cờ tính năng
- Secret lưu dữ liệu nhạy cảm như mật khẩu, token, chứng chỉ
- Secret mặc định chỉ mã hoá base64, cần bật mã hoá khi lưu và phân quyền chặt
- Có thể tích hợp kho bí mật bên ngoài như Vault', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('23ba6c80-3b4e-57f6-aae8-220a5ae86eed', 'Liveness probe và readiness probe khác nhau như thế nào? Vì sao cần health check?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Liveness probe kiểm tra container còn sống không; thất bại thì Kubernetes khởi động lại container
- Readiness probe kiểm tra container sẵn sàng nhận request chưa; thất bại thì bị loại khỏi Service
- Startup probe dùng cho ứng dụng khởi động chậm
- Health check giúp tự phục hồi và tránh gửi request tới instance chưa sẵn sàng
- Liveness không nên phụ thuộc dịch vụ bên ngoài để tránh khởi động lại hàng loạt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6f9d9747-57f1-5f91-a81f-c0e180f94d90', 'Ingress trong Kubernetes là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Ingress định nghĩa luật định tuyến HTTP và HTTPS từ bên ngoài vào các Service trong cụm
- Định tuyến theo tên miền và đường dẫn
- Hỗ trợ kết thúc TLS tập trung
- Cần một Ingress controller (ví dụ Nginx Ingress) để thực thi luật
- Giúp dùng một điểm vào cho nhiều service thay vì nhiều LoadBalancer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('abab1ef0-2d38-53e8-8c3f-a3781745ab45', 'Rolling update trong Kubernetes được thực hiện như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Deployment thay dần pod cũ bằng pod mới thay vì dừng tất cả cùng lúc
- maxSurge và maxUnavailable kiểm soát số pod thêm và số pod được phép không sẵn sàng
- Readiness probe đảm bảo pod mới sẵn sàng trước khi nhận tải
- Theo dõi tiến trình rollout và có thể rollback về phiên bản trước
- Ứng dụng cần tương thích ngược (ví dụ thay đổi cơ sở dữ liệu) vì hai phiên bản chạy song song', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f4403ead-cfbc-57d6-991a-d20695d2dfb0', 'StatefulSet là gì và khi nào nên dùng?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- StatefulSet quản lý các pod cần định danh và lưu trữ ổn định
- Mỗi pod có tên cố định theo thứ tự và volume riêng giữ lại khi pod được tạo lại
- Pod được tạo, cập nhật và xoá theo thứ tự
- Dùng cho ứng dụng có trạng thái như cơ sở dữ liệu, Kafka, Zookeeper
- Ứng dụng không trạng thái nên dùng Deployment', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6d141e98-7157-5875-a35d-abc296471fea', 'Bạn giám sát ứng dụng chạy trên Kubernetes như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thu thập metrics bằng Prometheus, hiển thị bằng Grafana
- Ứng dụng xuất metrics, ví dụ Spring Boot Actuator với Micrometer
- Gom log tập trung bằng ELK, Loki hoặc dịch vụ cloud
- Tracing phân tán bằng OpenTelemetry, Jaeger
- Thiết lập cảnh báo dựa trên chỉ số quan trọng như tỉ lệ lỗi, độ trễ, tài nguyên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c7c7be5e-b1cc-59f4-aaf2-35d8b40990a6', 'Topic và partition trong Kafka là gì? Vì sao cần partition?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Topic là kênh logic chứa các message cùng loại
- Mỗi topic chia thành nhiều partition, mỗi partition là log có thứ tự, chỉ ghi nối thêm
- Partition cho phép phân tán dữ liệu trên nhiều broker và xử lý song song
- Thứ tự message chỉ được đảm bảo trong một partition
- Số partition giới hạn mức song song tối đa của consumer group', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8f7c7d76-2257-5019-99f5-db0340d2804b', 'Message key trong Kafka ảnh hưởng tới việc phân bổ partition như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Message có key được đưa vào partition theo hash của key
- Mọi message cùng key luôn vào cùng partition nên giữ được thứ tự theo key
- Message không có key được phân bổ theo cơ chế mặc định (sticky hoặc round robin)
- Chọn key phù hợp, ví dụ mã đơn hàng, để đảm bảo thứ tự cho từng thực thể
- Key phân bố lệch có thể làm một partition quá tải', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d1dd1a70-1e26-5b4e-8636-e3ecc32edfe8', 'Consumer group trong Kafka là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Consumer group là nhóm consumer cùng đọc một topic để chia tải
- Mỗi partition chỉ được giao cho một consumer trong nhóm tại một thời điểm
- Nhiều group khác nhau có thể đọc cùng topic độc lập, mỗi group có offset riêng
- Thêm consumer giúp xử lý song song, tối đa bằng số partition
- Kafka tự phân bổ lại partition khi consumer tham gia hoặc rời nhóm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cbb631a0-89d1-5319-8d7e-e4ee90e8a0ad', 'Nếu số consumer trong group nhiều hơn số partition thì điều gì xảy ra?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi partition chỉ giao cho một consumer trong group
- Các consumer dư sẽ không được giao partition nào và đứng chờ
- Chúng chỉ hữu ích như dự phòng khi consumer khác lỗi
- Muốn tăng song song cần tăng số partition
- Nên lên kế hoạch số partition từ đầu vì tăng sau có thể làm thay đổi phân bổ theo key', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('85214ced-0536-53c7-9ede-977a068065c9', 'Các đảm bảo giao nhận at-most-once, at-least-once và exactly-once khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- At-most-once: message có thể mất nhưng không bao giờ xử lý lặp (commit offset trước khi xử lý)
- At-least-once: không mất message nhưng có thể xử lý lặp (commit sau khi xử lý), phổ biến nhất
- Exactly-once: mỗi message có tác động đúng một lần
- Kafka hỗ trợ exactly-once trong phạm vi Kafka bằng idempotent producer và transaction
- Với hệ thống bên ngoài, thường dùng at-least-once kèm xử lý idempotent', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5256fde9-5699-5a87-a5f4-779f5fff8c14', 'Làm thế nào để cấu hình exactly-once semantics trong Kafka?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bật idempotent producer để broker loại bỏ message trùng do retry
- Dùng transactional producer với transactional id để ghi nhiều partition một cách nguyên tử
- Gửi offset của consumer vào cùng transaction (mô hình đọc, xử lý, ghi)
- Consumer đặt isolation level là read_committed để chỉ đọc message đã commit
- Với ghi ra hệ thống ngoài Kafka cần idempotency ở phía đích hoặc lưu offset cùng dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d6ad42ab-48fd-53c8-a138-caf9eb534385', 'Offset trong Kafka là gì? Commit offset hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Offset là vị trí tuần tự của message trong một partition
- Consumer group lưu offset đã xử lý vào topic nội bộ của Kafka
- Khi consumer khởi động lại hoặc partition được giao cho consumer khác, việc đọc tiếp tục từ offset đã commit
- Commit trước khi xử lý có thể mất message; commit sau khi xử lý có thể xử lý lặp
- auto.offset.reset quy định đọc từ đầu hay từ mới nhất khi chưa có offset', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cbcc166a-52f7-5ab5-83de-667245f075e3', 'Auto commit và manual commit offset trong Kafka khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Auto commit định kỳ commit offset của các message đã poll, đơn giản
- Auto commit có thể commit message chưa xử lý xong, dẫn tới mất message khi lỗi
- Manual commit để ứng dụng tự commit sau khi xử lý thành công
- Manual commit có dạng đồng bộ (chắc chắn hơn) và bất đồng bộ (nhanh hơn)
- Hệ thống cần độ tin cậy cao nên dùng manual commit kèm xử lý idempotent', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('86863471-742c-5496-a999-545fb1cb5501', 'Rebalancing trong Kafka là gì và khi nào xảy ra?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Rebalancing là quá trình phân bổ lại partition giữa các consumer trong group
- Xảy ra khi consumer tham gia, rời đi, bị coi là chết do không gửi heartbeat hoặc xử lý quá lâu, hoặc khi số partition thay đổi
- Trong lúc rebalance, việc tiêu thụ có thể bị tạm dừng
- Có thể gây xử lý lặp nếu offset chưa được commit
- Giảm ảnh hưởng bằng cooperative rebalancing, static membership, chỉnh thời gian poll hợp lý', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26314ac9-7fdc-5d85-a4ed-9b37b3885cca', 'ISR (In-Sync Replicas) trong Kafka là gì?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi partition có một leader và các follower nhân bản dữ liệu
- ISR là tập các bản sao đang bắt kịp leader
- Bản sao tụt lại quá lâu bị loại khỏi ISR
- Với acks=all, message chỉ được xác nhận khi mọi bản sao trong ISR đã ghi
- min.insync.replicas quy định số bản sao tối thiểu trong ISR để chấp nhận ghi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('93c06661-9760-555b-853f-34a4fe687bdc', 'Kafka đảm bảo khả năng chịu lỗi như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi partition được nhân bản trên nhiều broker theo replication factor
- Một bản sao là leader xử lý đọc ghi, các follower đồng bộ dữ liệu
- Khi leader lỗi, một bản sao trong ISR được bầu làm leader mới
- Producer dùng acks=all và min.insync.replicas để không mất dữ liệu đã xác nhận
- Dữ liệu được ghi xuống đĩa và giữ theo chính sách retention', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9ab47e2a-67ce-5ab4-ba07-4b5699fe2c96', 'Cấu hình acks của Kafka producer (0, 1, all) có ý nghĩa gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- acks=0: producer không chờ xác nhận, nhanh nhất nhưng dễ mất message
- acks=1: chờ leader ghi xong; mất message nếu leader lỗi trước khi follower sao chép
- acks=all: chờ mọi bản sao trong ISR ghi xong, an toàn nhất nhưng độ trễ cao hơn
- acks=all nên đi kèm min.insync.replicas lớn hơn 1
- Chọn theo mức độ quan trọng của dữ liệu và yêu cầu độ trễ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('edb5965e-033d-5bf4-aee9-6e3a141d8fa4', 'Idempotent producer trong Kafka là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là producer đảm bảo retry không tạo message trùng trong một partition
- Mỗi producer có id và mỗi message có số thứ tự, broker loại bỏ message trùng
- Bật bằng enable.idempotence, mặc định bật từ các phiên bản Kafka mới
- Yêu cầu acks=all
- Là nền tảng cho exactly-once khi kết hợp transaction', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('46b461a3-e8a9-5313-bfd5-2a05f05750c8', 'Dead Letter Queue (DLQ) là gì? Bạn xử lý lỗi khi consumer đọc message như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- DLQ là topic hoặc hàng đợi riêng chứa các message xử lý thất bại
- Lỗi tạm thời thì retry có giới hạn, thường kèm backoff
- Lỗi vĩnh viễn (dữ liệu sai định dạng) thì chuyển sang DLQ thay vì chặn cả partition
- Lưu kèm thông tin lỗi để phân tích và xử lý lại sau
- Theo dõi và cảnh báo khi DLQ có message', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c971822d-7923-5637-92c8-d42aaeee36a5', 'Consumer lag trong Kafka là gì và bạn giám sát nó như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Consumer lag là khoảng cách giữa offset mới nhất của partition và offset consumer đã commit
- Lag tăng liên tục nghĩa là consumer xử lý chậm hơn tốc độ ghi
- Giám sát bằng công cụ dòng lệnh của Kafka, Burrow, Prometheus exporter, Grafana
- Đặt cảnh báo theo ngưỡng lag hoặc thời gian trễ
- Xử lý bằng tăng consumer và partition hoặc tối ưu logic xử lý', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b76b0c89-3521-548f-9f0d-b2500f9193a0', 'Retention policy trong Kafka là gì? Message cũ bị xoá như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Kafka giữ message theo thời gian hoặc dung lượng, không xoá khi đã được đọc
- Cấu hình retention.ms và retention.bytes
- Dữ liệu được lưu theo segment; cả segment cũ hết hạn mới bị xoá
- Log compaction giữ lại message mới nhất cho mỗi key thay vì xoá theo thời gian
- Cho phép đọc lại dữ liệu cũ khi cần xử lý lại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f8d86431-b9af-56bb-9ed4-4b65254b401f', 'Vấn đề N+1 trong Hibernate/JPA là gì và giải quyết thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xảy ra khi tải danh sách N entity rồi mỗi entity lại chạy thêm một truy vấn để tải quan hệ
- Tổng cộng N+1 truy vấn, rất chậm khi N lớn
- Giải quyết bằng JOIN FETCH trong JPQL hoặc EntityGraph
- Dùng batch fetching (BatchSize) để tải quan hệ theo lô
- Hoặc dùng projection/DTO chỉ lấy dữ liệu cần; phát hiện bằng cách bật log SQL', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c201bc7e-f90a-5750-9e31-6008967f256d', 'Lazy loading và eager loading khác nhau như thế nào? Khi nào dùng loại nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Lazy loading chỉ tải quan hệ khi lần đầu truy cập, eager loading tải ngay cùng entity cha
- Lazy tiết kiệm truy vấn khi không cần quan hệ nhưng dễ gây N+1 và LazyInitializationException
- Eager dễ tải thừa dữ liệu, khó tắt khi không cần
- Mặc định nên dùng lazy, rồi chủ động fetch theo từng use case bằng JOIN FETCH hoặc EntityGraph
- Trong JPA, quan hệ ToOne mặc định eager, ToMany mặc định lazy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0522def3-7de2-5ffe-b98a-2137b9176119', 'LazyInitializationException là gì và làm sao tránh?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xảy ra khi truy cập quan hệ lazy sau khi session hoặc persistence context đã đóng
- Thường gặp khi trả entity ra controller hoặc serialize ngoài transaction
- Tránh bằng cách fetch đủ dữ liệu cần trong transaction (JOIN FETCH, EntityGraph)
- Chuyển entity sang DTO trong tầng service
- Không nên dựa vào open-session-in-view hay chuyển hết sang eager', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4c8f4e23-0bf9-5fad-9098-65907ec831cc', 'Vòng đời của entity trong Hibernate gồm những trạng thái nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Transient: object mới tạo, chưa gắn với persistence context, chưa có trong cơ sở dữ liệu
- Persistent (managed): được persistence context quản lý, thay đổi tự động được đồng bộ
- Detached: đã từng được quản lý nhưng context đã đóng hoặc bị tách ra
- Removed: đã đánh dấu xoá, sẽ bị xoá khi flush
- Chuyển trạng thái qua persist, merge, detach, remove', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f90c6c48-36d8-541e-8b04-d258d8079263', 'First-level cache và second-level cache trong Hibernate khác nhau như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- First-level cache gắn với một session hoặc persistence context, luôn bật
- Trong cùng session, tải cùng entity theo id hai lần chỉ truy vấn một lần
- Second-level cache dùng chung giữa các session, phải cấu hình thêm (ví dụ Ehcache, Caffeine)
- Hợp với dữ liệu đọc nhiều, ít thay đổi như danh mục
- Cần chú ý tính nhất quán khi dữ liệu bị sửa ngoài Hibernate hoặc chạy nhiều instance', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3209ab6e-c6f2-53fd-b401-391e2d857f75', 'Dirty checking và cơ chế flush trong Hibernate hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Hibernate giữ bản chụp trạng thái của entity khi tải vào persistence context
- Khi flush, so sánh trạng thái hiện tại với bản chụp để tìm entity bị thay đổi
- Tự sinh câu UPDATE cho entity thay đổi mà không cần gọi save
- Flush xảy ra khi commit transaction, trước một số truy vấn, hoặc khi gọi flush thủ công
- Transaction readOnly có thể bỏ qua dirty checking để tiết kiệm tài nguyên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0ec3cfb5-3039-5496-ab72-9fc4f6959d9c', 'persist và merge trong JPA khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- persist chuyển entity mới (transient) sang trạng thái managed, chính object đó được quản lý
- persist với entity detached sẽ báo lỗi
- merge sao chép trạng thái của object (thường detached) vào một entity managed và trả về entity đó
- Object truyền vào merge vẫn không được quản lý, phải dùng giá trị trả về
- save của Spring Data gọi persist với entity mới và merge với entity đã có id', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a0048501-3b49-519a-98d2-2656503d68e8', 'Optimistic locking và pessimistic locking trong JPA khác nhau như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Optimistic locking không khoá dữ liệu, kiểm tra xung đột khi cập nhật bằng cột version
- Nếu version đã thay đổi thì ném OptimisticLockException, ứng dụng cần retry hoặc báo người dùng
- Phù hợp khi xung đột hiếm, hệ thống đọc nhiều
- Pessimistic locking khoá dòng khi đọc (SELECT FOR UPDATE), transaction khác phải chờ
- Phù hợp khi xung đột thường xuyên và chi phí retry cao; cần chú ý deadlock và timeout', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1acdc0ff-f117-5481-9a2a-753f5d2dfe08', 'Cascade trong JPA là gì? Orphan removal là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cascade lan truyền thao tác từ entity cha sang entity con như persist, merge, remove
- Các loại: PERSIST, MERGE, REMOVE, REFRESH, DETACH, ALL
- Orphan removal tự xoá entity con khi nó bị gỡ khỏi collection của cha
- Dùng cho quan hệ sở hữu chặt, ví dụ đơn hàng và các dòng đơn hàng
- Không nên cascade REMOVE trên quan hệ dùng chung hoặc ManyToOne', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8587d8c1-7032-5ddb-8f03-5ca6f602183d', 'Bạn sử dụng quan hệ OneToMany và ManyToOne trong JPA đúng cách như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phía ManyToOne giữ khoá ngoại và thường là phía sở hữu quan hệ
- Quan hệ hai chiều dùng mappedBy ở phía OneToMany
- Cập nhật cả hai phía bằng method tiện ích để giữ đồng bộ trong bộ nhớ
- Mặc định dùng lazy và fetch theo nhu cầu
- Tránh vòng lặp vô hạn khi serialize bằng cách dùng DTO thay vì trả entity trực tiếp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2d59a22f-1eac-5c51-8563-b90d6c5d9419', 'JPQL là gì và khác SQL như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- JPQL là ngôn ngữ truy vấn của JPA, làm việc trên entity và thuộc tính thay vì bảng và cột
- Không phụ thuộc hệ quản trị cơ sở dữ liệu, được dịch sang SQL tương ứng
- Hỗ trợ điều hướng quan hệ và JOIN FETCH
- Hạn chế hơn SQL thuần với tính năng đặc thù của từng hệ quản trị
- Khi cần có thể dùng native query', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('13ee5945-ce03-5742-a310-019f19eea482', 'Projection trong JPA là gì và khi nào nên dùng?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Projection chỉ lấy một phần dữ liệu thay vì toàn bộ entity
- Có thể dùng DTO qua constructor expression, interface projection của Spring Data, hoặc tuple
- Giảm dữ liệu truyền tải và không đưa entity vào persistence context
- Phù hợp cho truy vấn chỉ đọc, màn hình danh sách, báo cáo
- Tránh được LazyInitializationException và N+1 khi chỉ cần vài trường', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('118234d1-d63f-567f-ad65-b503aa7b7617', 'JPA hỗ trợ những chiến lược ánh xạ kế thừa nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SINGLE_TABLE: mọi lớp con chung một bảng với cột phân loại; nhanh nhưng nhiều cột null
- JOINED: mỗi lớp một bảng, join khi truy vấn; chuẩn hoá nhưng truy vấn chậm hơn
- TABLE_PER_CLASS: mỗi lớp cụ thể một bảng đầy đủ cột; truy vấn đa hình cần UNION
- MappedSuperclass chỉ chia sẻ ánh xạ trường, không phải entity
- Chọn theo nhu cầu truy vấn đa hình và tính toàn vẹn dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bd57b19f-9325-5456-aa13-d66b1ed99ec4', 'Saga pattern là gì và khi nào nên dùng? Choreography và orchestration khác nhau ra sao?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Saga quản lý transaction trải dài nhiều service bằng chuỗi transaction cục bộ
- Mỗi bước thất bại sẽ kích hoạt các transaction bù trừ để hoàn tác bước trước
- Choreography: các service phát và lắng nghe sự kiện, không có bộ điều phối trung tâm
- Orchestration: một orchestrator ra lệnh cho từng service và theo dõi trạng thái
- Dùng khi không thể hoặc không nên dùng transaction phân tán hai pha; đổi lại chỉ có nhất quán cuối cùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ed275e1c-0ce5-57fe-bb06-17ab6b10a2fc', 'Bạn xử lý transaction phân tán giữa các microservice như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tránh transaction phân tán khi có thể bằng thiết kế ranh giới service hợp lý
- Two-phase commit đảm bảo nhất quán mạnh nhưng chậm, khoá lâu và kém sẵn sàng
- Saga với các transaction bù trừ là cách phổ biến
- Outbox pattern để ghi dữ liệu và phát sự kiện một cách tin cậy
- Consumer xử lý idempotent để chịu được message lặp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('692779cd-8939-5982-b1a0-d25bbca73c2a', 'Circuit breaker pattern là gì và hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Circuit breaker ngăn gọi liên tục tới service đang lỗi để tránh lỗi lan truyền
- Closed: gọi bình thường, đếm lỗi
- Open: khi lỗi vượt ngưỡng thì chặn gọi, trả lỗi hoặc fallback ngay
- Half-open: sau một thời gian cho thử vài request, thành công thì đóng lại, thất bại thì mở tiếp
- Thư viện phổ biến: Resilience4j', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('28804cc0-5fbf-5dad-92c7-55aea1619786', 'Service discovery là gì và vì sao cần nó?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Trong microservices, địa chỉ instance thay đổi liên tục do mở rộng và triển khai lại
- Service discovery giúp tìm địa chỉ instance đang hoạt động của một service theo tên
- Client-side discovery: client hỏi registry rồi tự chọn instance (Eureka)
- Server-side discovery: client gọi qua load balancer hoặc router, nó tra registry (Kubernetes Service)
- Registry dựa vào health check để loại instance lỗi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('50f81cfe-252c-58c1-b8f1-554440a489fd', 'API Gateway là gì và giải quyết những vấn đề gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- API Gateway là điểm vào duy nhất cho client gọi tới các microservice
- Định tuyến request tới service phù hợp
- Xử lý tập trung xác thực, giới hạn tốc độ, CORS, ghi log
- Có thể gộp dữ liệu từ nhiều service, chuyển đổi giao thức
- Cần thiết kế để không thành điểm lỗi đơn lẻ hay nút thắt hiệu năng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b8bcc3f0-076b-5e77-8d86-ca0db340679a', 'Sharding là gì? Sharding và partitioning khác nhau như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Sharding chia dữ liệu theo dòng ra nhiều cơ sở dữ liệu hoặc máy chủ khác nhau
- Partitioning thường là chia bảng thành nhiều phần trong cùng một cơ sở dữ liệu
- Sharding giúp mở rộng ngang khả năng lưu trữ và ghi
- Chọn shard key quan trọng để phân bố đều và tránh truy vấn chéo shard
- Nhược điểm: join và transaction chéo shard phức tạp, khó chia lại shard', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eb338f8c-bdb6-566a-b7d9-4a9f85b67b33', 'Làm thế nào để mở rộng ngang (horizontal scaling) một microservice?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Chạy nhiều instance phía sau load balancer
- Service phải stateless: session, file, cache chung lưu ở hệ thống ngoài như Redis, object storage
- Tự động mở rộng theo tải (ví dụ HPA của Kubernetes)
- Chú ý nút thắt ở cơ sở dữ liệu: read replica, cache, sharding
- Xử lý tác vụ nặng bất đồng bộ qua hàng đợi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('741b6236-39bd-5c2d-9a46-77b8f35cece9', 'Database per service là gì? Dùng chung một cơ sở dữ liệu giữa các microservice có vấn đề gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi service sở hữu cơ sở dữ liệu riêng, service khác chỉ truy cập qua API hoặc sự kiện
- Giúp service độc lập về triển khai, thay đổi schema và chọn công nghệ lưu trữ
- Dùng chung cơ sở dữ liệu tạo ràng buộc chặt: đổi schema ảnh hưởng nhiều service
- Khó xác định ai sở hữu dữ liệu, dễ tranh chấp tải và khoá
- Đổi lại phải xử lý dữ liệu phân tán, truy vấn chéo service và nhất quán cuối cùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ad3a4ba6-268d-53ba-8337-f7554471d018', 'Các microservice giao tiếp với nhau như thế nào? Giao tiếp đồng bộ và bất đồng bộ khác nhau ra sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Đồng bộ: REST hoặc gRPC, bên gọi chờ phản hồi
- Đồng bộ đơn giản, phản hồi ngay nhưng tạo phụ thuộc thời gian chạy, lỗi dễ lan truyền
- Bất đồng bộ: qua message broker như Kafka, RabbitMQ
- Bất đồng bộ giảm phụ thuộc, chịu tải tốt nhưng phức tạp hơn và chỉ nhất quán cuối cùng
- Chọn theo nhu cầu: truy vấn cần kết quả ngay dùng đồng bộ, sự kiện nghiệp vụ dùng bất đồng bộ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61fddeaa-b0df-5a87-acb9-f2545e7e55de', 'Bạn đảm bảo khả năng chịu lỗi cho microservices như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Timeout cho mọi lời gọi ra ngoài
- Retry có giới hạn kèm exponential backoff và jitter, chỉ với thao tác idempotent
- Circuit breaker và fallback
- Bulkhead: cô lập tài nguyên (thread pool, kết nối) theo từng phụ thuộc
- Nhiều instance, health check, giao tiếp bất đồng bộ khi phù hợp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('abccf74a-911a-5246-9349-e43cad2cc04e', 'Retry pattern là gì và dùng như thế nào cho đúng? Exponential backoff là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Retry thử lại thao tác thất bại do lỗi tạm thời như mất mạng, timeout
- Chỉ retry thao tác idempotent hoặc có idempotency key
- Giới hạn số lần thử
- Exponential backoff tăng thời gian chờ theo cấp số nhân giữa các lần thử, thêm jitter ngẫu nhiên để tránh dồn tải
- Kết hợp circuit breaker để không retry vào service đang sập', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f9543497-1ad5-5278-ba2f-7757a4833366', 'Distributed tracing là gì? Bạn giám sát hệ thống microservices như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Distributed tracing theo dõi một request đi qua nhiều service bằng trace id được truyền theo
- Mỗi bước là một span có thời gian, giúp tìm service chậm hoặc lỗi
- Công cụ: OpenTelemetry, Jaeger, Zipkin
- Kết hợp metrics (Prometheus, Grafana) và log tập trung có kèm trace id
- Đặt cảnh báo theo tỉ lệ lỗi, độ trễ, độ bão hoà tài nguyên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fd892baa-e89b-573a-aad1-3a5920580f4c', 'Bạn triển khai xác thực và phân quyền trong hệ thống microservices như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xác thực tập trung qua identity provider dùng OAuth2 hoặc OpenID Connect
- Client gửi access token (thường là JWT); API Gateway kiểm tra token
- Các service tự kiểm tra chữ ký và quyền trong token, không cần gọi lại máy chủ xác thực
- Phân quyền dựa trên role hoặc scope, kiểm tra ở từng service
- Giao tiếp giữa service dùng token của service hoặc mTLS', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2f58bd74-7865-5cff-bf53-802bddc4e65a', 'Strangler fig pattern là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là cách chuyển dần hệ thống cũ (monolith) sang hệ thống mới
- Đặt một lớp định tuyến phía trước, chuyển từng chức năng sang service mới
- Chức năng nào đã chuyển thì định tuyến sang hệ thống mới
- Hệ thống cũ thu hẹp dần cho tới khi gỡ bỏ hoàn toàn
- Giảm rủi ro so với viết lại toàn bộ một lần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cf479396-ab19-5cff-87a9-9b6c3640e130', 'Bạn kiểm thử microservices như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Unit test cho logic nghiệp vụ trong từng service
- Integration test với cơ sở dữ liệu và broker thật, ví dụ bằng Testcontainers
- Contract test giữa bên gọi và bên cung cấp API (Spring Cloud Contract, Pact)
- End-to-end test cho một số luồng quan trọng
- Kiểm thử khả năng chịu lỗi và theo dõi trên môi trường staging', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('29e7a6c0-a4e0-5253-96f3-7c15bba16a04', 'Nguyên tắc Single Responsibility là gì? Làm sao biết một class đang vi phạm?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi class chỉ nên có một lý do để thay đổi, tức chịu trách nhiệm cho một phần chức năng
- Dấu hiệu vi phạm: class quá lớn, có nhiều nhóm method phục vụ các mục đích khác nhau
- Thay đổi một yêu cầu kéo theo sửa nhiều phần không liên quan trong class
- Ví dụ class vừa xử lý nghiệp vụ, vừa truy cập cơ sở dữ liệu, vừa gửi email
- Khắc phục bằng cách tách thành các class nhỏ có độ gắn kết cao', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('74feb982-2b91-519a-947f-3aadd475a014', 'Nguyên tắc Open/Closed là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Module nên mở để mở rộng nhưng đóng để sửa đổi
- Thêm hành vi mới bằng cách thêm code mới thay vì sửa code đã ổn định
- Thực hiện qua interface, đa hình, Strategy pattern, plugin
- Ví dụ thay chuỗi if-else theo loại thanh toán bằng các class triển khai chung một interface
- Giảm rủi ro làm hỏng chức năng cũ khi mở rộng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7ab05b3a-e562-5954-9729-50e772571998', 'Nguyên tắc Liskov Substitution là gì? Hãy cho ví dụ vi phạm.', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Object của lớp con phải thay thế được lớp cha mà không làm sai hành vi của chương trình
- Lớp con không được làm yếu hậu điều kiện hay tăng tiền điều kiện so với lớp cha
- Ví dụ kinh điển: Square kế thừa Rectangle làm sai khi đặt riêng chiều rộng và chiều cao
- Ví dụ khác: lớp con ném UnsupportedOperationException cho method của lớp cha
- Vi phạm thường là dấu hiệu nên dùng composition hoặc tách interface', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('45570829-5946-5bb6-bd00-c7a9dfe37e07', 'Nguyên tắc Interface Segregation là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Client không nên bị buộc phụ thuộc vào method mà nó không dùng
- Nên chia interface lớn thành nhiều interface nhỏ, chuyên biệt
- Tránh class triển khai phải để trống hoặc ném lỗi cho method không liên quan
- Giảm ảnh hưởng khi interface thay đổi
- Ví dụ tách interface đọc và ghi của một repository', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a2d18445-03c7-534c-9e73-8792b3900eeb', 'Nguyên tắc Dependency Inversion là gì? Nó liên quan gì tới Dependency Injection?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Module cấp cao không phụ thuộc module cấp thấp, cả hai phụ thuộc vào abstraction
- Abstraction không phụ thuộc chi tiết, chi tiết phụ thuộc abstraction
- Ví dụ service phụ thuộc interface repository thay vì class truy cập cơ sở dữ liệu cụ thể
- Dependency Injection là kỹ thuật hiện thực hoá nguyên tắc này, cung cấp phụ thuộc từ bên ngoài
- Giúp dễ thay thế triển khai và dễ test bằng mock', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7677dbf3-cb0b-5fba-aac0-9ef0cfc77b92', 'Vì sao cần tuân theo các nguyên tắc SOLID? Có nên áp dụng tuyệt đối không?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- SOLID giúp code dễ bảo trì, dễ mở rộng và dễ đọc
- Giảm phụ thuộc chặt giữa các thành phần, thay đổi ít ảnh hưởng lan
- Dễ viết unit test vì các thành phần nhỏ và có thể thay thế
- Không nên áp dụng máy móc: quá nhiều abstraction gây phức tạp không cần thiết
- Cân nhắc theo quy mô và tốc độ thay đổi của dự án', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('378cf19e-f432-5b6c-80ad-7a805b5b237d', 'Composition và inheritance khác nhau như thế nào? Khi nào nên ưu tiên composition?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Inheritance là quan hệ là một: lớp con kế thừa hành vi lớp cha
- Composition là quan hệ có một: object chứa và uỷ quyền cho object khác
- Inheritance gắn chặt lớp con với chi tiết lớp cha, thay đổi lớp cha dễ phá lớp con
- Composition linh hoạt hơn, có thể thay đổi hành vi lúc chạy và dễ test
- Ưu tiên composition khi chỉ cần tái sử dụng hành vi; dùng inheritance khi thật sự có quan hệ là một và tuân thủ Liskov', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c2c9a916-fe5d-5bfa-be6c-7c5bc1380cf5', 'Law of Demeter (nguyên tắc biết ít nhất) là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Một object chỉ nên gọi method của chính nó, tham số, object nó tạo ra và các thành phần trực tiếp
- Tránh chuỗi gọi dài qua nhiều object, ví dụ lấy đơn hàng rồi lấy khách hàng rồi lấy địa chỉ
- Giảm phụ thuộc vào cấu trúc bên trong của object khác
- Code dễ thay đổi hơn khi cấu trúc nội bộ thay đổi
- Khắc phục bằng cách thêm method uỷ quyền phù hợp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5f406030-e1f8-575f-a1b7-9be55a944d8d', 'God object là gì và bạn refactor nó như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- God object là class biết và làm quá nhiều việc, vi phạm Single Responsibility
- Khó hiểu, khó test, thay đổi nhỏ dễ gây lỗi
- Viết test bao quanh hành vi hiện tại trước khi refactor
- Xác định các nhóm trách nhiệm và tách dần thành class riêng
- Thực hiện từng bước nhỏ, giữ hệ thống chạy được sau mỗi bước', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('424ce423-c46c-504b-81d4-228d69bb78db', 'CompletableFuture là gì và có ưu điểm gì so với Future?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Future chỉ cho phép chờ kết quả bằng get (chặn luồng) và kiểm tra hoàn thành
- CompletableFuture cho phép nối chuỗi xử lý không chặn bằng các callback
- Kết hợp nhiều tác vụ (thenCombine, allOf, anyOf)
- Xử lý lỗi trong chuỗi (exceptionally, handle)
- Có thể hoàn thành thủ công và chỉ định executor riêng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d25a547e-22cc-5f8f-9152-e9acb135ae21', 'thenApply và thenCompose trong CompletableFuture khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- thenApply biến đổi kết quả bằng hàm trả về giá trị thường, giống map
- thenCompose dùng khi hàm trả về một CompletableFuture khác, giống flatMap
- Dùng thenApply với hàm trả về future sẽ tạo future lồng nhau
- thenCompose dùng để nối các tác vụ bất đồng bộ phụ thuộc nhau
- thenCombine dùng để gộp kết quả của hai future độc lập', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('354bf299-8089-5d30-9455-139b536f1dc4', 'Xử lý exception trong chuỗi CompletableFuture như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khi một bước lỗi, các bước phụ thuộc phía sau bị bỏ qua và future hoàn thành với lỗi
- exceptionally chỉ chạy khi có lỗi, trả về giá trị thay thế
- handle luôn chạy, nhận cả kết quả và lỗi, có thể đổi kết quả
- whenComplete luôn chạy để làm tác vụ phụ, không đổi kết quả
- Lỗi thường được bọc trong CompletionException', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d7c24de5-b1fd-589b-b8d8-de0b12f14ded', 'Bạn thực hiện nhiều request song song tới các microservice và gộp kết quả như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khởi chạy mỗi lời gọi bằng supplyAsync với executor riêng phù hợp cho I/O
- Dùng allOf để chờ tất cả hoàn thành rồi lấy kết quả từng future
- Dùng anyOf khi chỉ cần kết quả nhanh nhất
- Đặt timeout cho từng lời gọi và xử lý lỗi riêng (fallback) để một lỗi không làm hỏng toàn bộ
- Giới hạn số lời gọi đồng thời để không quá tải service đích', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb7fc3d1-2f56-58b4-ae33-6526fa67e9b0', 'Các method async của CompletableFuture mặc định dùng thread pool nào? Vì sao nên tự chỉ định executor?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mặc định dùng ForkJoinPool.commonPool, dùng chung toàn ứng dụng
- Common pool có số luồng xấp xỉ số nhân CPU, thiết kế cho tác vụ tính toán
- Tác vụ chặn như gọi mạng, truy vấn cơ sở dữ liệu có thể làm cạn common pool, ảnh hưởng phần khác
- Nên truyền executor riêng cho tác vụ I/O, có kích thước và tên luồng phù hợp
- Với Java 21 có thể cân nhắc virtual thread cho tác vụ I/O', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f1079272-686d-589e-bddc-3e95388c6576', 'Code chặn (blocking) và không chặn (non-blocking) khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Code chặn giữ luồng đứng chờ cho tới khi thao tác như I/O hoàn thành
- Code không chặn trả quyền điều khiển ngay, kết quả được xử lý qua callback hoặc future
- Code chặn với nhiều request đồng thời cần nhiều luồng, tốn bộ nhớ và chi phí chuyển ngữ cảnh
- Không nên gọi thao tác chặn trong luồng của event loop hoặc pool dùng chung
- Virtual thread trong Java giúp viết code kiểu chặn mà vẫn mở rộng tốt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6e0700b1-e8b1-57a6-b026-0fb77451d064', 'Làm thế nào để đặt timeout cho CompletableFuture?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Từ Java 9 dùng orTimeout: hoàn thành với TimeoutException nếu quá thời gian
- completeOnTimeout: hoàn thành với giá trị mặc định nếu quá thời gian
- Timeout không tự huỷ tác vụ bên dưới, cần đặt timeout ở chính client gọi mạng
- Trước Java 9 có thể dùng get có timeout (chặn) hoặc tự lập lịch hoàn thành
- Kết hợp xử lý lỗi để trả fallback', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6d30f403-e92c-5986-bda2-6f0f36cce125', 'Khi nào nên dùng CompletableFuture và khi nào nên dùng lập trình reactive?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CompletableFuture phù hợp với một kết quả bất đồng bộ và vài tác vụ cần kết hợp
- Reactive (Reactor, RxJava) phù hợp với luồng dữ liệu nhiều phần tử, có backpressure
- Reactive hợp với hệ thống cần xử lý rất nhiều kết nối đồng thời với ít luồng (WebFlux)
- Reactive khó học, khó debug hơn
- Với Java 21, virtual thread là lựa chọn đơn giản cho nhiều trường hợp I/O', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('67092464-1042-586c-bfc9-459c7ea8c3e6', 'Design pattern là gì? Có những nhóm design pattern nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Design pattern là giải pháp đã được kiểm chứng cho các vấn đề thiết kế thường gặp
- Giúp chia sẻ từ vựng chung và tránh tự phát minh lại
- Nhóm khởi tạo (creational): Singleton, Factory Method, Abstract Factory, Builder, Prototype
- Nhóm cấu trúc (structural): Adapter, Decorator, Proxy, Facade, Composite
- Nhóm hành vi (behavioral): Strategy, Observer, Command, State, Template Method', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('db93a16f-67fb-5f4a-91dd-44b63d5249d5', 'Singleton là gì? Làm sao triển khai Singleton an toàn luồng và Singleton có những vấn đề gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Singleton đảm bảo một class chỉ có một instance và có điểm truy cập toàn cục
- Cách an toàn luồng: khởi tạo sớm, enum, holder class, hoặc double-checked locking với volatile
- Vấn đề: trạng thái toàn cục, phụ thuộc ẩn, khó test và khó thay thế
- Có thể bị phá qua reflection hoặc serialization nếu không dùng enum
- Trong Spring, bean mặc định là singleton do container quản lý nên ít khi cần tự viết', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('91fbeb68-b24d-5975-8383-4ec29a1456c8', 'Factory Method và Abstract Factory khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Factory Method để lớp con quyết định tạo object cụ thể nào qua một method
- Abstract Factory cung cấp interface để tạo cả một họ object liên quan
- Factory Method tạo một sản phẩm; Abstract Factory tạo nhiều sản phẩm đồng bộ với nhau
- Ví dụ Abstract Factory tạo bộ nút và hộp thoại cùng phong cách giao diện
- Cả hai giúp code phụ thuộc vào abstraction thay vì class cụ thể', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4dacaee9-4bca-5cdc-a9d8-f4efb1726778', 'Khi nào nên dùng Builder pattern?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khi object có nhiều tham số, nhất là nhiều tham số tuỳ chọn
- Tránh constructor quá dài hoặc nhiều constructor nạp chồng
- Code tạo object dễ đọc nhờ đặt tên từng bước
- Có thể kiểm tra tính hợp lệ trước khi tạo và tạo object bất biến
- Trong Java thường dùng Lombok Builder để giảm code mẫu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8d496d49-7c51-5adf-8910-eed139da3e70', 'Strategy pattern là gì và khi nào nên dùng? Strategy khác State như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Strategy đóng gói các thuật toán thay thế được lẫn nhau sau một interface chung
- Dùng khi có nhiều cách thực hiện một việc và muốn chọn lúc chạy, thay cho chuỗi if-else
- Ví dụ tính phí vận chuyển theo nhiều phương thức
- State thay đổi hành vi theo trạng thái nội bộ, và các trạng thái tự chuyển sang nhau
- Strategy thường do client chọn; cấu trúc hai pattern giống nhau nhưng mục đích khác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa0a7a35-6525-5bed-9e1a-b12bb5dac7db', 'Observer pattern là gì và thường được áp dụng như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Observer cho phép nhiều đối tượng đăng ký nhận thông báo khi đối tượng khác thay đổi
- Bên phát không cần biết chi tiết bên nhận, giảm phụ thuộc
- Trong Spring có ApplicationEvent và EventListener
- Là nền tảng của hệ thống hướng sự kiện, message broker, lập trình reactive
- Cần chú ý rò rỉ bộ nhớ khi không huỷ đăng ký và thứ tự xử lý', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c6821b47-a093-5238-bae8-33eeb5af05aa', 'Decorator pattern có ưu điểm gì so với kế thừa?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Decorator bọc object để thêm hành vi mà không sửa class gốc
- Có thể kết hợp nhiều decorator linh hoạt lúc chạy
- Kế thừa phải tạo lớp con cho mỗi tổ hợp tính năng, dễ bùng nổ số lớp
- Tuân thủ nguyên tắc Open/Closed
- Ví dụ: các luồng I/O trong Java, thêm cache hoặc log quanh một service', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('24ad7ee7-94bb-5464-be50-48a6d73a954b', 'Proxy pattern là gì? Có những loại proxy nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Proxy là đối tượng đại diện kiểm soát truy cập tới đối tượng thật
- Virtual proxy: trì hoãn tạo object tốn kém (lazy loading của Hibernate)
- Protection proxy: kiểm tra quyền truy cập
- Remote proxy: đại diện cho object ở xa; caching proxy: lưu kết quả
- Spring dùng proxy (JDK dynamic proxy hoặc CGLIB) cho Transactional, AOP', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7c2d78dc-50eb-5675-808a-9a76aff9b0c7', 'Bạn biết những anti-pattern nào trong thiết kế phần mềm?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- God object: class làm quá nhiều việc
- Spaghetti code: luồng xử lý rối, không cấu trúc
- Copy-paste code, magic number, hard-code cấu hình
- Anemic domain model khi nghiệp vụ bị rải khắp các service
- Over-engineering: thêm abstraction và pattern không cần thiết', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6409c519-6c6f-5c5a-abf0-3217f092c0d7', 'Record khác class thông thường như thế nào trong Java?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Record là class dữ liệu bất biến, khai báo ngắn gọn các thành phần
- Tự sinh constructor, method truy cập, equals, hashCode, toString
- Record là final và không kế thừa được class khác, nhưng triển khai được interface
- Không có trường instance ngoài các thành phần đã khai báo
- Phù hợp làm DTO, giá trị trả về, key trong map', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('36e316ac-a578-5fba-8061-4b0d710ed8ee', 'Generics trong Java là gì và có lợi ích gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Generics cho phép class, interface, method làm việc với kiểu dữ liệu được tham số hoá
- Kiểm tra kiểu lúc biên dịch, phát hiện lỗi sớm
- Không cần ép kiểu thủ công khi lấy dữ liệu
- Tái sử dụng code cho nhiều kiểu, ví dụ List, Map, Optional
- Không dùng được kiểu nguyên thuỷ trực tiếp, phải dùng lớp bao như Integer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b6392611-61f5-54bf-b5d1-623a006047cb', 'Type erasure trong Java là gì và gây ra những hạn chế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thông tin kiểu generic bị xoá khi biên dịch, thay bằng kiểu giới hạn hoặc Object
- Lúc chạy, List of String và List of Integer là cùng một class
- Không thể tạo object new T, tạo mảng generic, hay kiểm tra instanceof với kiểu tham số
- Không nạp chồng được method chỉ khác nhau tham số generic
- Lý do là tương thích ngược với code Java trước khi có generics', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8809f9c0-d0e4-525b-9c25-73df97e4ee93', 'Wildcard extends và super trong generics khác nhau như thế nào? Nguyên tắc PECS là gì?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Wildcard extends T chấp nhận T hoặc lớp con, dùng để đọc giá trị kiểu T
- Wildcard super T chấp nhận T hoặc lớp cha, dùng để ghi giá trị kiểu T vào
- PECS: Producer Extends, Consumer Super
- Ví dụ method sao chép: nguồn dùng extends, đích dùng super
- Giúp API linh hoạt hơn mà vẫn an toàn kiểu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bb442283-6694-5cf3-8a08-c502af2f3157', 'Heap và stack trong JVM khác nhau như thế nào? Mỗi vùng lưu những gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Stack là vùng nhớ riêng của mỗi luồng, lưu các frame gọi method với biến cục bộ và tham chiếu
- Heap dùng chung giữa các luồng, lưu object và mảng
- Stack cấp phát và giải phóng tự động theo lời gọi method, rất nhanh
- Heap được dọn bởi garbage collector
- Lỗi tương ứng: StackOverflowError khi đệ quy quá sâu, OutOfMemoryError khi heap đầy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e8adf959-4578-5ec1-909b-c5d2013768d2', 'Bạn biết những thuật toán GC nào trong JVM? G1 và ZGC khác nhau thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Serial GC cho ứng dụng nhỏ; Parallel GC tối ưu thông lượng
- G1 là mặc định từ Java 9, chia heap thành nhiều region, cân bằng giữa thông lượng và thời gian dừng
- ZGC và Shenandoah làm hầu hết công việc đồng thời với ứng dụng, thời gian dừng chỉ vài mili giây kể cả heap rất lớn
- Stop-the-world là thời điểm mọi luồng ứng dụng bị dừng để GC làm việc
- Chọn theo ưu tiên độ trễ hay thông lượng và kích thước heap', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e5b8980b-b96a-5e38-819f-c18e9183f5a6', 'Tham số -Xms và -Xmx của JVM là gì? Bạn đặt chúng như thế nào khi chạy trong container?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xms là kích thước heap ban đầu, Xmx là kích thước heap tối đa
- Đặt bằng nhau giúp tránh chi phí mở rộng heap lúc chạy
- Bộ nhớ của tiến trình Java lớn hơn heap (metaspace, stack của luồng, bộ nhớ native)
- Trong container nên dùng MaxRAMPercentage để JVM tự tính theo giới hạn của container
- Để dư địa cho bộ nhớ ngoài heap để tránh container bị kill vì vượt giới hạn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cfcc74bd-28c0-5b87-92c5-bb9cc64d1d8a', 'Có những loại OutOfMemoryError nào trong Java? Khi gặp lỗi này bạn làm gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Java heap space: heap không đủ chỗ cho object mới
- Metaspace: quá nhiều class được nạp, thường do rò rỉ classloader
- GC overhead limit exceeded: GC chạy liên tục mà thu hồi được rất ít
- Unable to create new native thread: hết tài nguyên tạo luồng
- Xử lý: bật tự động tạo heap dump khi OOM, phân tích tìm nguyên nhân, sửa rò rỉ hoặc điều chỉnh bộ nhớ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('976cf839-2c43-503d-9641-16e88cf75353', 'Rò rỉ bộ nhớ trong Java là gì, xảy ra như thế nào và làm sao phát hiện?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Rò rỉ bộ nhớ là khi object không còn cần nhưng vẫn bị tham chiếu nên GC không thu hồi được
- Nguyên nhân thường gặp: collection static tăng mãi, cache không giới hạn, listener không huỷ đăng ký
- ThreadLocal không được dọn trong thread pool, tài nguyên không được đóng
- Dấu hiệu: bộ nhớ old generation tăng dần sau mỗi lần GC, cuối cùng OutOfMemoryError
- Phát hiện bằng giám sát bộ nhớ và phân tích heap dump với công cụ như Eclipse MAT, VisualVM', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0df15b92-114b-5ef6-bb5f-d3fcce096344', 'Heap dump là gì? Làm sao lấy và phân tích heap dump?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Heap dump là ảnh chụp toàn bộ object trong heap tại một thời điểm
- Lấy bằng jcmd, jmap hoặc tự động khi OOM với HeapDumpOnOutOfMemoryError
- Phân tích bằng Eclipse MAT, VisualVM, IntelliJ để tìm object chiếm nhiều bộ nhớ và đường giữ tham chiếu
- Lấy heap dump có thể làm dừng ứng dụng, cần cẩn thận trên production
- File có thể chứa dữ liệu nhạy cảm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ad701172-db1a-59bf-a3c3-506dae2794d0', 'Có thể gọi GC thủ công không? Vì sao không nên gọi System.gc?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- System.gc chỉ là gợi ý, JVM có thể bỏ qua
- Nếu chạy, thường kích hoạt full GC gây dừng ứng dụng lâu
- JVM tự quyết định thời điểm GC tốt hơn dựa trên tình trạng bộ nhớ
- Gọi GC thủ công thường che giấu vấn đề thật như rò rỉ bộ nhớ
- Có thể tắt bằng tham số DisableExplicitGC', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('261bd1a5-adfc-5ee0-bbf1-52c2b3d7a6c2', 'Garbage collection trong Java là gì? Khi nào một object đủ điều kiện bị thu hồi?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Garbage collection tự động thu hồi bộ nhớ của object không còn được dùng
- Object đủ điều kiện thu hồi khi không còn đường tham chiếu nào tới nó từ GC roots
- GC roots gồm biến cục bộ trên stack, biến static, luồng đang chạy, tham chiếu JNI
- Lập trình viên không giải phóng bộ nhớ thủ công nhưng vẫn có thể gây rò rỉ bằng cách giữ tham chiếu
- Gọi System.gc chỉ là gợi ý và không nên dùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c08ef902-77ec-5b2a-be91-f2b228bf82f5', 'Các thế hệ (generation) trong GC là gì? Vì sao chia heap thành young và old generation?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dựa trên giả thuyết đa số object chết sớm
- Young generation chứa object mới tạo, gồm Eden và các vùng Survivor
- Minor GC dọn young generation thường xuyên và nhanh
- Object sống qua nhiều lần GC được chuyển lên old generation
- Old generation được dọn ít hơn bằng major hoặc full GC, thường tốn thời gian hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('074bf6e8-dd91-5ca0-abe6-b67ecf32d621', 'Collection Framework trong Java có những interface chính nào? List, Set và Queue khác nhau ra sao?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Các interface chính: Collection, List, Set, Queue, Deque và Map (không kế thừa Collection)
- List có thứ tự, cho phép phần tử trùng, truy cập theo chỉ số
- Set không cho phép phần tử trùng
- Queue xử lý theo thứ tự lấy ra, thường là FIFO; Deque thêm bớt ở cả hai đầu
- Map lưu cặp key và value với key duy nhất', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('093f0375-3858-5fd8-b1ac-348527f4dec2', 'HashSet, LinkedHashSet và TreeSet khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HashSet dựa trên HashMap, không giữ thứ tự, thao tác trung bình O(1)
- LinkedHashSet giữ thứ tự thêm vào nhờ danh sách liên kết, chậm hơn chút
- TreeSet dựa trên cây đỏ đen, phần tử được sắp xếp, thao tác O(log n)
- TreeSet cần phần tử Comparable hoặc Comparator
- HashSet và LinkedHashSet dựa vào equals và hashCode, TreeSet dựa vào so sánh', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e291c481-c3f3-58e9-8ebf-caa1e8da77db', 'CopyOnWriteArrayList là gì và khi nào nên dùng? Còn các collection synchronized thì sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CopyOnWriteArrayList tạo bản sao mảng mới mỗi lần ghi
- Đọc và duyệt không cần khoá, không ném ConcurrentModificationException
- Phù hợp khi đọc rất nhiều, ghi rất ít, ví dụ danh sách listener
- Ghi tốn kém với danh sách lớn
- Collections.synchronizedList khoá toàn bộ mỗi thao tác, khi duyệt vẫn phải tự đồng bộ; thường nên chọn collection trong java.util.concurrent', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('59b7fe3c-b7d7-572b-9f9b-a018dfca3942', 'Iterator fail-fast và fail-safe khác nhau như thế nào? ConcurrentModificationException xảy ra khi nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Fail-fast iterator ném ConcurrentModificationException khi collection bị sửa cấu trúc trong lúc duyệt
- Ví dụ xoá phần tử trong vòng for-each của ArrayList
- Fail-safe iterator duyệt trên bản sao hoặc cấu trúc đồng thời nên không ném lỗi, có thể không thấy thay đổi mới
- Ví dụ CopyOnWriteArrayList, ConcurrentHashMap
- Xoá đúng cách khi duyệt: dùng iterator.remove hoặc removeIf', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('370ebcf8-0c6d-54b6-a3f3-5d441b3e107b', 'Comparable và Comparator khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Comparable định nghĩa thứ tự tự nhiên ngay trong class qua compareTo
- Comparator là đối tượng so sánh tách rời, định nghĩa nhiều cách sắp xếp khác nhau
- Một class chỉ có một thứ tự tự nhiên nhưng có nhiều Comparator
- Comparator hỗ trợ kết hợp như comparing, thenComparing, reversed
- Thứ tự nên nhất quán với equals khi dùng trong TreeSet, TreeMap', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d296374b-f826-5b80-81e1-5e4d61949063', 'ArrayList và LinkedList khác nhau như thế nào? Khi nào dùng loại nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ArrayList dựa trên mảng động, truy cập theo chỉ số O(1)
- Thêm hoặc xoá ở giữa ArrayList phải dịch phần tử, O(n); thêm cuối trung bình O(1)
- LinkedList là danh sách liên kết đôi, thêm xoá ở đầu cuối O(1), truy cập theo chỉ số O(n)
- LinkedList tốn bộ nhớ hơn và kém thân thiện với cache CPU
- Thực tế hầu hết trường hợp dùng ArrayList; cần hàng đợi hai đầu thì dùng ArrayDeque', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('454334f4-13b3-5a71-9326-6a0a7191239a', 'Dependency Injection là gì và vì sao hữu ích?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dependency Injection là việc đối tượng nhận các phụ thuộc từ bên ngoài thay vì tự tạo bằng new
- Là cách hiện thực Inversion of Control: container quản lý việc tạo và nối các đối tượng
- Giảm phụ thuộc chặt giữa các class, phụ thuộc vào interface
- Dễ thay đổi triển khai và dễ unit test bằng mock
- Trong Spring, IoC container tạo bean và inject theo cấu hình hoặc annotation', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eedb6b5f-cb41-56d7-ae06-fb0d1807765c', 'Constructor injection, setter injection và field injection khác nhau như thế nào? Nên dùng loại nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Constructor injection truyền phụ thuộc qua constructor, có thể khai báo final
- Setter injection qua setter, phù hợp với phụ thuộc tuỳ chọn
- Field injection dùng Autowired trên trường, ngắn gọn nhưng ẩn phụ thuộc và khó test
- Constructor injection được khuyến nghị: bắt buộc đủ phụ thuộc khi tạo, object bất biến, dễ test không cần container
- Constructor quá nhiều tham số là dấu hiệu class làm quá nhiều việc', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f26bb034-2499-57e1-bdee-68e9cad2bc85', 'Bean trong Spring là gì và có những cách nào để tạo bean?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Bean là đối tượng được Spring IoC container tạo và quản lý vòng đời
- Đánh dấu class bằng Component, Service, Repository, Controller để component scan tự phát hiện
- Khai báo method có annotation Bean trong class Configuration
- Spring Boot auto-configuration tự tạo nhiều bean theo thư viện có trên classpath
- Bean có tên, scope và có thể được inject vào bean khác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ba42dab2-1612-5fa9-b6a5-bba6e6688ece', 'Vòng đời của một bean trong Spring gồm những giai đoạn nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Container tạo instance, thường qua constructor
- Inject các phụ thuộc
- Gọi các callback Aware và BeanPostProcessor trước khởi tạo
- Gọi method khởi tạo (PostConstruct, afterPropertiesSet, initMethod), rồi BeanPostProcessor sau khởi tạo (tạo proxy ở đây)
- Bean sẵn sàng dùng; khi đóng context gọi PreDestroy và destroy method', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ca8aa61b-2d40-5011-abb6-b9654140a524', 'BeanPostProcessor trong Spring là gì?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là interface cho phép can thiệp vào bean trước và sau khi khởi tạo
- Áp dụng cho mọi bean trong container
- Spring dùng nó để xử lý annotation như Autowired và tạo proxy cho AOP, Transactional
- Có thể trả về object khác (proxy) thay cho bean gốc
- Dùng khi cần thêm hành vi chung cho nhiều bean', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4716766c-45bf-5bad-9618-cb99e144f002', 'Bean scope trong Spring là gì? Singleton và prototype khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Scope quyết định số instance và thời gian sống của bean
- Singleton (mặc định): một instance cho mỗi container, dùng chung
- Prototype: mỗi lần yêu cầu tạo instance mới, container không quản lý việc huỷ
- Scope web: request, session, application
- Inject prototype vào singleton chỉ tạo một lần, cần ObjectProvider hoặc lookup method nếu muốn mới mỗi lần; bean singleton phải không có trạng thái thay đổi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e038b4bb-cc3a-554a-8497-2c412c8a0b11', 'Proxy trong Spring là gì và khi nào Spring tạo proxy?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Proxy là đối tượng bọc bean thật để thêm hành vi trước và sau khi gọi method
- Spring tạo proxy cho Transactional, Cacheable, Async, PreAuthorize và các aspect AOP
- Dùng JDK dynamic proxy khi bean triển khai interface hoặc CGLIB tạo lớp con
- Chỉ lời gọi đi qua proxy mới được áp dụng hành vi, lời gọi nội bộ trong class thì không
- CGLIB không proxy được method final hay private', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4b3da63b-b467-5d89-87ae-82e2216cabcb', 'AOP là gì? Giải thích các khái niệm aspect, advice, pointcut và join point.', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- AOP (lập trình hướng khía cạnh) tách các mối quan tâm cắt ngang như log, bảo mật, transaction khỏi nghiệp vụ
- Aspect là module chứa logic cắt ngang
- Join point là điểm trong chương trình có thể chèn logic, trong Spring là lời gọi method
- Pointcut là biểu thức chọn các join point áp dụng
- Advice là đoạn code chạy tại join point: before, after, around', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('23326e06-0234-5166-b560-b00809078e36', 'Vì sao Transactional không có tác dụng khi gọi method trong cùng một class, và cách khắc phục?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Spring áp dụng Transactional qua proxy bọc bean
- Lời gọi từ method này sang method khác trong cùng class đi qua this, không qua proxy
- Vì vậy transaction của method được gọi không được mở hoặc cấu hình bị bỏ qua
- Khắc phục: tách method sang bean khác và inject vào
- Hoặc inject chính proxy của bean (self-injection), dùng TransactionTemplate, hoặc AspectJ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce348c99-e722-51a1-b981-372f19089da3', 'Auto-configuration trong Spring Boot là gì và hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Spring Boot tự cấu hình bean dựa trên thư viện có trên classpath và thuộc tính cấu hình
- Các lớp auto-configuration được khai báo trong file metadata của các starter
- Dùng điều kiện như ConditionalOnClass, ConditionalOnMissingBean, ConditionalOnProperty
- Bean do người dùng khai báo được ưu tiên, auto-configuration lùi lại
- Xem báo cáo điều kiện bằng chế độ debug hoặc endpoint actuator để biết cấu hình nào được áp dụng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5df9381d-7e58-5d0b-8438-63a90af9c509', 'Annotation SpringBootApplication hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là annotation gộp của Configuration, EnableAutoConfiguration và ComponentScan
- Configuration cho phép khai báo bean trong class
- EnableAutoConfiguration bật cơ chế tự cấu hình
- ComponentScan quét các component trong package của class và các package con
- Vì vậy class main nên đặt ở package gốc của ứng dụng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7f9fb4cb-ec59-5fec-8f8f-c23419403a8b', 'Starter trong Spring Boot là gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Starter là gói dependency gom sẵn các thư viện cần cho một chức năng
- Ví dụ spring-boot-starter-web, spring-boot-starter-data-jpa, spring-boot-starter-security
- Phiên bản các thư viện đã được kiểm tra tương thích với nhau
- Đi kèm auto-configuration nên chỉ cần thêm dependency là dùng được
- Giảm cấu hình thủ công và xung đột phiên bản', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bc12ab84-829f-5dc8-ada8-adcd4bdc5b04', 'Các annotation Component, Service, Repository và Controller khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Cả bốn đều đánh dấu class là bean để component scan phát hiện
- Service, Repository, Controller là chuyên biệt hoá của Component theo tầng
- Repository bật chuyển đổi exception truy cập dữ liệu sang hệ exception của Spring
- Controller (và RestController) đánh dấu class xử lý request web
- Dùng đúng annotation giúp code rõ tầng và cho phép áp dụng xử lý riêng theo tầng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b8df225f-1860-546c-b5d7-8a6bb2f5a729', 'Nếu có nhiều bean cùng kiểu thì Spring inject bean nào? Bạn xử lý tình huống này thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Spring báo lỗi vì không xác định được bean duy nhất
- Dùng Qualifier để chỉ định tên bean cần inject
- Đánh dấu Primary cho bean mặc định
- Inject List hoặc Map để nhận tất cả bean cùng kiểu, ví dụ để chọn strategy lúc chạy
- Tên tham số trùng tên bean cũng có thể được dùng để phân giải', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('49fc01a4-b4d0-5cf1-9648-bd0dc3f25f5e', 'Profile trong Spring là gì và dùng khi nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Profile cho phép kích hoạt cấu hình và bean khác nhau theo môi trường
- Ví dụ dev, test, prod với cơ sở dữ liệu và mức log khác nhau
- Khai báo file cấu hình riêng theo profile và đánh dấu bean bằng annotation Profile
- Kích hoạt bằng thuộc tính spring.profiles.active hoặc biến môi trường
- Thông tin bí mật nên lấy từ biến môi trường hoặc kho bí mật thay vì ghi vào file', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('69a10b4b-859b-5222-8ad1-47c31c95e29c', 'REST là gì? Stateless trong REST nghĩa là gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- REST là phong cách kiến trúc cho API dựa trên tài nguyên, dùng các phương thức HTTP chuẩn
- Tài nguyên được định danh bằng URL, biểu diễn thường là JSON
- Stateless: mỗi request chứa đủ thông tin để xử lý, server không lưu trạng thái phiên của client
- Nhờ stateless, dễ mở rộng ngang và cân bằng tải
- Các ràng buộc khác: client-server, cacheable, giao diện thống nhất, hệ thống phân lớp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5e55810a-d105-5732-bf32-0c7ba3a3c5df', 'PUT và PATCH khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- PUT thay thế toàn bộ tài nguyên bằng dữ liệu gửi lên
- Trường không gửi trong PUT có thể bị xoá hoặc đặt mặc định
- PATCH chỉ cập nhật một phần các trường được gửi
- PUT là idempotent; PATCH không nhất thiết idempotent tuỳ cách cài đặt
- Chọn PATCH cho cập nhật một vài trường để giảm dữ liệu gửi đi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5ffe876b-890e-5413-a35d-39b182e7cb9a', 'Idempotency là gì? Những HTTP method nào là idempotent, POST có idempotent không?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Idempotent là gọi một lần hay nhiều lần cùng request thì trạng thái server vẫn như nhau
- GET, HEAD, PUT, DELETE, OPTIONS là idempotent; GET còn là safe vì không thay đổi dữ liệu
- POST không idempotent: gửi lặp có thể tạo nhiều bản ghi
- Quan trọng khi client retry do mất mạng
- Làm POST an toàn khi retry bằng idempotency key do client gửi kèm', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5ccfa5e3-0f55-5e6b-b9aa-d544bca15cbf', 'Những mã trạng thái HTTP nào bạn hay dùng khi thiết kế API? Mã 401 và 403 khác nhau ra sao?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- 2xx thành công: 200 OK, 201 Created, 202 Accepted cho xử lý bất đồng bộ, 204 No Content
- 4xx lỗi phía client: 400 dữ liệu sai, 404 không tìm thấy, 409 xung đột, 422 không xử lý được, 429 quá nhiều request
- 5xx lỗi phía server: 500, 502, 503, 504
- 401 Unauthorized: chưa xác thực hoặc token không hợp lệ
- 403 Forbidden: đã xác thực nhưng không có quyền thực hiện', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8354527c-0572-569a-b7c8-d27d99c78c37', 'Bạn thiết kế RESTful API như thế nào cho tốt? Đặt tên endpoint ra sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng danh từ số nhiều cho tài nguyên, không dùng động từ trong URL (ví dụ /orders, /orders/{id})
- Dùng đúng HTTP method cho hành động và đúng mã trạng thái
- Quan hệ lồng nhau vừa phải, ví dụ /orders/{id}/items
- Hỗ trợ phân trang, lọc, sắp xếp qua query parameter
- Định dạng lỗi thống nhất, có versioning và tài liệu (OpenAPI)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6bddd7ce-b18c-5ada-ab66-fa419f3cf2c8', 'HATEOAS là gì?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- HATEOAS là ràng buộc của REST: response chứa liên kết tới các hành động liên quan tiếp theo
- Client khám phá API qua liên kết thay vì cứng URL
- Ví dụ đơn hàng trả kèm liên kết huỷ, thanh toán khi trạng thái cho phép
- Spring HATEOAS hỗ trợ xây dựng response dạng này
- Thực tế ít API áp dụng đầy đủ vì tăng độ phức tạp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('99b1475c-ea44-5eb1-82cd-8a306850d29e', 'Bạn tổ chức versioning cho REST API như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Version trong URL (ví dụ /v1/orders): rõ ràng, dễ dùng, phổ biến nhất
- Version qua header hoặc media type: URL sạch nhưng khó thử nghiệm hơn
- Version qua query parameter
- Ưu tiên thay đổi tương thích ngược để hạn chế tăng version
- Thông báo và giữ version cũ một thời gian trước khi ngừng hỗ trợ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('721aa6c1-bf33-511d-a95a-018cee3b3e3c', 'Header Content-Type và Accept khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Content-Type mô tả định dạng dữ liệu của phần thân request hoặc response đang gửi
- Accept do client gửi để cho biết định dạng response mong muốn
- Server dựa vào Accept để chọn định dạng trả về (content negotiation)
- Không hỗ trợ định dạng yêu cầu thì trả 406; không hỗ trợ Content-Type gửi lên thì trả 415
- Ví dụ application/json, multipart/form-data', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5a5b8443-3dda-5b01-ac36-49a0b72f1f9e', 'Checked exception và unchecked exception khác nhau như thế nào? Khi nào dùng loại nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Checked exception bắt buộc phải bắt hoặc khai báo throws, trình biên dịch kiểm tra
- Unchecked exception (RuntimeException và lớp con) không bắt buộc
- Checked dùng cho tình huống có thể phục hồi mà bên gọi nên xử lý, ví dụ lỗi I/O
- Unchecked dùng cho lỗi lập trình hoặc vi phạm điều kiện như tham số không hợp lệ
- Nhiều framework như Spring ưa dùng unchecked để code gọn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cafba9f2-afe8-5e63-a593-c4d1912ddcc7', 'Hệ thống phân cấp exception trong Java như thế nào? Error và Exception khác nhau ra sao?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Gốc là Throwable, có hai nhánh Error và Exception
- Error là lỗi nghiêm trọng của JVM như OutOfMemoryError, StackOverflowError, ứng dụng thường không nên bắt
- Exception là lỗi ứng dụng có thể xử lý
- RuntimeException là nhánh unchecked của Exception
- Các Exception còn lại là checked', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('082df946-9deb-5ea2-b50b-1895f3368436', 'Khối finally có luôn được thực thi không? Điều gì xảy ra nếu exception xảy ra trong finally?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- finally chạy dù try kết thúc bình thường, có exception hay có return
- Không chạy nếu JVM dừng (System.exit, crash) hoặc luồng bị huỷ đột ngột
- Exception ném ra trong finally sẽ thay thế exception gốc, làm mất thông tin lỗi ban đầu
- return trong finally cũng ghi đè giá trị trả về hoặc nuốt exception
- Nên dùng try-with-resources thay cho finally để đóng tài nguyên', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('86e57e4b-5caa-53de-882b-a1a375493dbf', 'try-with-resources là gì? Suppressed exception là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- try-with-resources tự động đóng tài nguyên khai báo trong ngoặc khi khối try kết thúc
- Tài nguyên phải triển khai AutoCloseable (Closeable là trường hợp riêng cho I/O)
- Tài nguyên được đóng theo thứ tự ngược với khi khai báo
- Nếu cả khối try và close đều ném exception, exception khi close được gắn vào exception chính dưới dạng suppressed
- Code gọn và an toàn hơn so với tự đóng trong finally', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('024460ad-8246-5a34-a2bb-6bda84ef1644', 'Khi nào nên tạo exception riêng? Nên kế thừa Exception hay RuntimeException?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Tạo exception riêng khi cần biểu diễn lỗi nghiệp vụ rõ nghĩa, ví dụ không đủ số dư
- Giúp bên gọi xử lý phân biệt và ánh xạ sang mã lỗi API phù hợp
- Thường kế thừa RuntimeException cho lỗi nghiệp vụ trong ứng dụng Spring
- Kế thừa Exception (checked) khi muốn buộc bên gọi xử lý
- Kèm thông điệp rõ ràng và giữ nguyên exception gốc (cause)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bff8730d-25ea-5c6d-90e9-894ac8aa1724', 'Bạn ghi log exception đúng cách như thế nào? Vì sao không nên nuốt exception?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng framework log (SLF4J) và truyền exception làm tham số để giữ stack trace
- Không dùng printStackTrace trong code thực tế
- Log kèm ngữ cảnh như id request, id người dùng, nhưng không log dữ liệu nhạy cảm
- Chỉ log một lần ở nơi xử lý để tránh log trùng
- Nuốt exception (bắt rồi bỏ qua) che giấu lỗi, làm dữ liệu sai mà không ai biết', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('918227e8-f49e-5284-8c10-112d03f1c563', 'Exception wrapping và exception chaining là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là bắt exception cấp thấp rồi ném exception cấp cao hơn có ý nghĩa với tầng hiện tại
- Exception gốc được giữ làm cause để không mất thông tin
- Giúp tầng trên không phụ thuộc chi tiết cài đặt như SQLException
- Stack trace hiển thị cả chuỗi nguyên nhân
- Ví dụ bọc lỗi truy cập dữ liệu thành exception nghiệp vụ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c8dc33a9-cadf-54e4-b891-e5bce14348fd', 'Khi có nhiều khối catch, thứ tự của chúng có quan trọng không? Multi-catch là gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Có, exception được so khớp với các catch theo thứ tự từ trên xuống
- Phải đặt exception cụ thể (lớp con) trước exception tổng quát (lớp cha)
- Đặt ngược thì trình biên dịch báo lỗi vì catch phía sau không bao giờ chạy tới
- Multi-catch bắt nhiều loại exception không liên quan trong một khối bằng dấu gạch đứng
- Giúp tránh lặp code xử lý giống nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cefbc650-d4ba-5230-a621-702ebd3d2f0d', 'Stream API trong Java mang lại những lợi ích gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Xử lý collection theo phong cách khai báo, ngắn gọn và dễ đọc hơn vòng lặp
- Kết hợp các thao tác như filter, map, reduce thành pipeline
- Đánh giá lười, chỉ xử lý phần tử cần thiết
- Dễ chuyển sang xử lý song song
- Khuyến khích tránh thay đổi trạng thái bên ngoài', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b2371fe4-b380-5c8d-ac26-220834261e7e', 'Thao tác intermediate và terminal trong Stream khác nhau như thế nào? Lazy evaluation là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Intermediate operation như filter, map, sorted trả về stream mới và không chạy ngay
- Terminal operation như collect, forEach, count, reduce kích hoạt việc xử lý và kết thúc stream
- Lazy evaluation: pipeline chỉ chạy khi có terminal operation
- Các phần tử đi qua toàn bộ pipeline từng cái một, kết hợp short-circuit như findFirst, limit
- Stream chỉ dùng được một lần', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('01a015e5-09b4-57d5-9269-87f3a81ca653', 'map và flatMap trong Stream khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- map biến đổi mỗi phần tử thành đúng một phần tử khác
- flatMap biến mỗi phần tử thành một stream rồi làm phẳng tất cả thành một stream
- Dùng flatMap khi mỗi phần tử chứa danh sách con, ví dụ lấy tất cả sản phẩm trong các đơn hàng
- map với hàm trả về stream sẽ tạo stream lồng stream
- Optional cũng có map và flatMap với ý nghĩa tương tự', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b87a4e5f-d0ba-5884-a4e1-0ec1a01de438', 'Parallel stream là gì? Khi nào nên dùng và có những vấn đề gì?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Parallel stream chia dữ liệu và xử lý trên nhiều luồng của ForkJoinPool.commonPool
- Phù hợp với dữ liệu lớn, thao tác tính toán nặng, độc lập, nguồn dễ chia như ArrayList
- Không phù hợp với tác vụ I/O, dữ liệu nhỏ hoặc nguồn khó chia như LinkedList
- Thao tác có trạng thái chung hoặc side effect gây race condition
- Dùng chung common pool nên có thể ảnh hưởng phần khác của ứng dụng; cần đo trước khi dùng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a53dfc6b-8874-513b-9d61-15f84a73c6b3', 'Side effect trong Stream là gì và vì sao nên tránh?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Side effect là thao tác thay đổi trạng thái bên ngoài stream, ví dụ thêm vào list bên ngoài trong forEach hoặc map
- Lambda trong stream chỉ dùng được biến effectively final nhưng vẫn có thể sửa object bên ngoài
- Gây lỗi khó đoán, đặc biệt với parallel stream
- Làm code khó đọc và khó test
- Nên dùng collect, reduce để tạo kết quả thay vì sửa trạng thái ngoài', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('313e241b-bb02-5e07-8172-7852116cebc0', 'reduce và collect trong Stream khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- reduce gộp các phần tử thành một giá trị bằng phép kết hợp bất biến, ví dụ tính tổng
- collect gộp vào một vùng chứa có thể thay đổi như List, Map, StringBuilder
- Dùng reduce để tạo collection mới sẽ tốn kém vì tạo nhiều object trung gian
- Collectors cung cấp sẵn toList, groupingBy, joining, toMap
- Với số học nên dùng sum, count hoặc mapToInt', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('662f8d89-50c9-517c-ae14-4e7b98874b81', 'Thu thập stream vào Map như thế nào? Xử lý trùng key ra sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng Collectors.toMap với hàm lấy key và hàm lấy value
- Nếu trùng key, toMap mặc định ném IllegalStateException
- Truyền thêm hàm merge để quyết định giữ giá trị nào hoặc gộp giá trị
- Có thể chỉ định loại Map, ví dụ LinkedHashMap để giữ thứ tự
- groupingBy dùng khi muốn gom nhiều phần tử theo cùng key', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dc3dcd48-f0b7-5ed1-8c13-efe4034c48e5', 'synchronized và volatile khác nhau như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- volatile đảm bảo khả năng hiển thị: thay đổi của một luồng được luồng khác thấy ngay, và ngăn sắp xếp lại lệnh
- volatile không đảm bảo tính nguyên tử cho thao tác ghép như tăng biến đếm
- synchronized đảm bảo cả loại trừ lẫn nhau và khả năng hiển thị
- synchronized có chi phí khoá, có thể gây tranh chấp
- volatile dùng cho cờ trạng thái; synchronized hoặc lớp Atomic dùng cho thao tác phức hợp', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('48e5acbe-ad92-5f34-b948-17248b1bf56b', 'Quan hệ happens-before và vấn đề visibility trong Java Memory Model là gì?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Do cache CPU và tối ưu của trình biên dịch, giá trị một luồng ghi có thể không được luồng khác thấy (visibility problem)
- Happens-before là quy tắc đảm bảo kết quả của thao tác A được thấy bởi thao tác B
- Ví dụ: mở khoá monitor happens-before lần khoá tiếp theo; ghi volatile happens-before đọc volatile đó
- Thread.start và join cũng tạo quan hệ happens-before
- Không có quan hệ này thì chương trình đa luồng có thể đọc dữ liệu cũ hoặc không nhất quán', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5cc3a7ba-fbe5-5cbe-bd48-b7ef31dd1309', 'Monitor trong Java là gì và synchronized hoạt động như thế nào? synchronized method khác synchronized block ra sao?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Mỗi object có một monitor (khoá nội tại); synchronized giành monitor trước khi vào và trả khi ra
- Chỉ một luồng giữ monitor tại một thời điểm, luồng khác phải chờ
- synchronized method khoá trên this (hoặc class với method static)
- synchronized block khoá trên object chỉ định và chỉ bao phần code cần thiết, giảm tranh chấp
- Khoá nội tại có tính reentrant: luồng đang giữ có thể vào lại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('71e9fd9c-2891-573c-aeb0-f6ba81e375b9', 'ReentrantLock là gì và khác synchronized ở điểm nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- ReentrantLock là khoá tường minh trong java.util.concurrent, cùng tính reentrant như synchronized
- Hỗ trợ tryLock có timeout, khoá có thể bị ngắt (lockInterruptibly)
- Hỗ trợ chế độ công bằng và nhiều Condition
- Phải tự gọi unlock trong finally, dễ quên gây treo
- Dùng khi cần tính năng nâng cao; trường hợp đơn giản synchronized là đủ', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b61ab239-1d66-52e0-9eb4-551f1bbf7078', 'CAS (Compare-And-Swap) là gì? Các lớp Atomic hoạt động như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- CAS là lệnh nguyên tử của CPU: chỉ cập nhật giá trị nếu giá trị hiện tại bằng giá trị mong đợi
- Các lớp như AtomicInteger dùng CAS trong vòng lặp để cập nhật không cần khoá
- Không chặn luồng nên hiệu năng tốt khi tranh chấp thấp
- Khi tranh chấp cao, vòng lặp thử lại có thể tốn CPU; LongAdder phù hợp hơn cho biến đếm
- Vấn đề ABA có thể giải bằng AtomicStampedReference', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ef6114d2-f81f-52e1-83b2-4d20427aea50', 'Thread pool là gì? ExecutorService dùng để làm gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Thread pool là tập luồng tạo sẵn và tái sử dụng để chạy nhiều tác vụ
- Tránh chi phí tạo và huỷ luồng liên tục, giới hạn số luồng đồng thời
- ExecutorService nhận tác vụ Runnable hoặc Callable, trả về Future
- Cần shutdown khi không dùng nữa để giải phóng tài nguyên
- Nên tự cấu hình ThreadPoolExecutor với hàng đợi có giới hạn và chính sách từ chối rõ ràng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3a5446c6-920a-58d8-9b3d-72d21613e002', 'newFixedThreadPool và newCachedThreadPool khác nhau như thế nào? Rủi ro của từng loại?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Fixed thread pool có số luồng cố định và hàng đợi không giới hạn
- Rủi ro của fixed: tác vụ dồn vào hàng đợi vô hạn có thể gây hết bộ nhớ
- Cached thread pool tạo luồng mới khi cần và thu hồi luồng rảnh
- Rủi ro của cached: tải tăng đột biến có thể tạo quá nhiều luồng
- Thực tế nên tự cấu hình ThreadPoolExecutor với giới hạn rõ ràng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8e5ca66f-cef6-52f1-aa7f-64eca25998e5', 'Deadlock là gì? Điều kiện xảy ra và cách phòng tránh?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Deadlock là khi các luồng chờ nhau giải phóng khoá mãi mãi
- Bốn điều kiện: loại trừ lẫn nhau, giữ và chờ, không thể cưỡng đoạt, chờ vòng tròn
- Phòng tránh bằng cách luôn lấy các khoá theo cùng một thứ tự
- Dùng tryLock có timeout, giảm phạm vi và thời gian giữ khoá
- Phát hiện bằng thread dump (jstack) để thấy các luồng đang chờ nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a7509e00-4eef-5fbb-a1aa-071c6985376f', 'Race condition là gì và làm sao tránh?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Race condition xảy ra khi kết quả phụ thuộc thứ tự thực thi không xác định của nhiều luồng truy cập dữ liệu chung
- Ví dụ hai luồng cùng tăng một biến đếm và mất một lần cập nhật
- Tránh bằng đồng bộ hoá (synchronized, lock) cho vùng găng
- Dùng lớp Atomic hoặc collection đồng thời
- Ưu tiên object bất biến và tránh chia sẻ trạng thái thay đổi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('492bd9cd-b150-5087-815d-dd5ea2272022', 'Virtual thread trong Java 21 là gì? Nó có ưu điểm gì và khi nào nên dùng?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Virtual thread là luồng nhẹ do JVM quản lý, chạy trên một số ít luồng hệ điều hành (carrier thread)
- Tạo rất rẻ, có thể chạy hàng triệu luồng
- Khi gặp thao tác chặn như I/O, virtual thread nhả carrier thread cho việc khác
- Cho phép viết code kiểu chặn đơn giản mà vẫn mở rộng tốt như code bất đồng bộ
- Phù hợp với tác vụ I/O nhiều; không tăng tốc tác vụ tính toán nặng; chú ý pinning khi giữ khoá synchronized lâu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('31028b85-76a8-5600-bfbd-367275a20b50', 'Runnable, Callable và Future khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Runnable là tác vụ không trả về kết quả và không ném checked exception
- Callable trả về kết quả và có thể ném exception
- Gửi tác vụ vào ExecutorService sẽ nhận về Future
- Future cho phép lấy kết quả (get, có thể chờ), kiểm tra hoàn thành, huỷ tác vụ
- Thread là luồng thực thi, còn Runnable là công việc được giao cho luồng', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d8649a06-7ae0-5635-b7c1-460389490591', 'Node.js là gì? Vì sao Node.js chạy đơn luồng mà vẫn xử lý được nhiều request?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Node.js là môi trường chạy JavaScript phía server, xây trên engine V8
- Mã JavaScript chạy trên một luồng chính với event loop
- I/O được xử lý bất đồng bộ, không chặn, qua libuv và thread pool của nó
- Một luồng phục vụ được rất nhiều kết nối vì không phải chờ I/O
- Không phù hợp với tác vụ nặng CPU vì làm chặn event loop', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa1d3e82-e71a-593f-8ae0-580e2fe9780d', 'Callback hell là gì và làm sao tránh trong Node.js?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Callback hell là khi các callback lồng nhau nhiều tầng, code khó đọc và khó xử lý lỗi
- Tách callback thành các hàm có tên
- Dùng Promise để nối chuỗi
- Dùng async/await để viết code bất đồng bộ như tuần tự
- Xử lý lỗi tập trung bằng try/catch với async/await', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('27e8b98b-57ab-59b2-aa79-463066c67f5f', 'Khi nào nên dùng background job hoặc worker process trong backend?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Khi tác vụ tốn thời gian và không cần trả kết quả ngay cho người dùng, ví dụ gửi email, xử lý ảnh, xuất báo cáo
- Giúp API phản hồi nhanh, không bị timeout
- Dùng hàng đợi như RabbitMQ, Kafka, Redis để giao việc cho worker
- Worker có thể mở rộng độc lập và retry khi lỗi
- Cần theo dõi trạng thái job và xử lý idempotent', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2641eb33-5d9f-56b8-8775-133bb80c2ae8', 'Stream trong Node.js là gì? Có những loại stream nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Stream xử lý dữ liệu theo từng phần thay vì đọc hết vào bộ nhớ
- Readable để đọc, Writable để ghi
- Duplex vừa đọc vừa ghi, ví dụ socket
- Transform là Duplex biến đổi dữ liệu, ví dụ nén
- Dùng pipe hoặc pipeline để nối stream và xử lý backpressure, tiết kiệm bộ nhớ với file lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d86bfd5c-9067-5d3d-9493-4ae51aeec349', 'Bạn áp dụng những biện pháp bảo mật nào cho ứng dụng Node.js?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Validate và làm sạch đầu vào, dùng truy vấn tham số hoá để chống injection
- Đặt security header (ví dụ helmet), cấu hình CORS chặt
- Xác thực và phân quyền đúng, băm mật khẩu bằng bcrypt hoặc argon2
- Giới hạn tốc độ request, kích thước body
- Cập nhật và quét lỗ hổng dependency, lưu bí mật trong biến môi trường', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('60666ef8-7948-5b18-8ee5-8d9376fc5c4a', 'Middleware trong Node.js/Express là gì? Middleware có thể làm những việc gì?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Middleware là hàm nhận request, response và next, chạy trong chuỗi xử lý request
- Có thể đọc hoặc sửa request và response
- Có thể kết thúc request hoặc gọi next để chuyển cho middleware tiếp theo
- Dùng cho log, xác thực, parse body, CORS, xử lý lỗi
- Thứ tự đăng ký middleware quyết định thứ tự chạy', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f4a57d2b-6db4-5fe1-8fd2-3b18e8f986c4', 'libuv là gì và vai trò của nó trong Node.js?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- libuv là thư viện C cung cấp event loop và I/O bất đồng bộ cho Node.js
- Trừu tượng hoá cơ chế I/O của từng hệ điều hành (epoll, kqueue, IOCP)
- Có thread pool cho tác vụ không có API bất đồng bộ như file system, DNS, mã hoá
- Quản lý timer, socket, tiến trình con
- Các pha của event loop do libuv điều phối', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9ab3ce97-9b32-55b3-986e-8d501463a322', 'spawn và fork trong module child_process của Node.js khác nhau như thế nào?', 'IT', 'Backend Developer', 'HARD', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- spawn chạy một lệnh bất kỳ trong tiến trình mới, dữ liệu trả về qua stream
- fork là trường hợp riêng để chạy một module Node.js mới
- fork tạo kênh giao tiếp IPC để gửi message giữa tiến trình cha và con
- exec chạy lệnh qua shell và trả về toàn bộ output trong buffer
- Dùng để tách tác vụ nặng hoặc chạy chương trình bên ngoài mà không chặn event loop', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('67f8351f-0d49-5e71-b718-5f0f5bd02ef8', 'Vì sao nên tách phần khởi tạo ứng dụng Express (app) và phần khởi động server?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- App chứa định nghĩa route và middleware, server lo lắng nghe port
- Tách ra giúp test API mà không cần mở port thật
- Dễ tái sử dụng app trong nhiều môi trường như serverless, cluster
- Cấu hình khởi động (port, TLS) tách biệt khỏi logic
- Code rõ trách nhiệm hơn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('188c92fe-c63d-566c-ba29-fe964f36243b', 'Node.js chạy đơn luồng, vậy làm sao tận dụng CPU nhiều nhân?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Chạy nhiều tiến trình bằng module cluster hoặc trình quản lý như PM2, mỗi tiến trình một nhân
- Các tiến trình dùng chung port, request được phân phối giữa chúng
- Worker threads cho tác vụ tính toán nặng trong cùng tiến trình
- Trong container thường chạy nhiều instance phía sau load balancer
- Trạng thái chung phải lưu ngoài tiến trình như Redis', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d4fee5a1-c27a-58a4-bcdb-f7bd442f0eb9', 'Node.js phù hợp và không phù hợp với những loại ứng dụng nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Phù hợp với ứng dụng I/O nhiều, nhiều kết nối đồng thời: API, ứng dụng thời gian thực, chat
- Phù hợp với streaming dữ liệu, BFF, công cụ dòng lệnh
- Dùng chung JavaScript với frontend
- Không phù hợp với tác vụ tính toán nặng CPU vì chặn event loop
- Với tác vụ nặng cần worker threads hoặc tách sang service khác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4bea39bb-fda8-5315-8eb5-62e2823bc3a3', 'EventEmitter trong Node.js là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- EventEmitter là lớp cho phép phát và lắng nghe sự kiện theo tên
- Đăng ký listener bằng on hoặc once, phát sự kiện bằng emit
- Nhiều module lõi như stream, HTTP server kế thừa EventEmitter
- Là cách hiện thực Observer pattern
- Cần gỡ listener khi không dùng để tránh rò rỉ bộ nhớ; sự kiện error không có listener sẽ làm sập tiến trình', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8c36ef78-3a1c-59d2-8f8d-4a012c036146', 'Express.js là gì và có những tính năng chính nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Express là framework web tối giản cho Node.js
- Định tuyến theo HTTP method và đường dẫn
- Hệ thống middleware để xử lý request theo chuỗi
- Tiện ích làm việc với request, response, phục vụ file tĩnh
- Linh hoạt, kết hợp được nhiều thư viện bên ngoài', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('17446111-9e67-525e-bf70-7cb252e4d11f', 'Express có những loại middleware nào? Middleware xử lý lỗi hoạt động thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Middleware cấp ứng dụng, đăng ký cho toàn app
- Middleware cấp router, áp dụng cho một nhóm route
- Middleware có sẵn và của bên thứ ba như parse JSON, CORS, cookie
- Middleware xử lý lỗi có bốn tham số (err, req, res, next), đặt sau cùng
- Gọi next kèm lỗi để chuyển tới middleware xử lý lỗi', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d683be2f-839e-5821-ab0e-ff17247a908f', 'Bạn quản lý session trong ứng dụng Express như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng middleware session, lưu id phiên trong cookie, dữ liệu phiên ở server
- Production không dùng bộ nhớ trong tiến trình, mà lưu ở Redis hoặc cơ sở dữ liệu
- Cookie đặt HttpOnly, Secure, SameSite
- Tạo lại id phiên sau khi đăng nhập để chống session fixation
- Đặt thời gian hết hạn và huỷ phiên khi đăng xuất', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e5a79f85-8e34-5b4a-8cbe-22371354200f', 'Bạn cấu hình CORS cho API Express như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Dùng middleware cors hoặc tự đặt các header Access-Control-Allow
- Chỉ cho phép danh sách origin cụ thể, tránh dùng dấu sao với API cần xác thực
- Cấu hình method, header được phép và credentials khi cần
- Xử lý preflight request với method OPTIONS
- CORS chỉ bảo vệ ở trình duyệt, vẫn cần xác thực và phân quyền ở server', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('efe5c7da-fd5a-536d-971f-2483d211aadc', 'MongoDB là gì? Cơ sở dữ liệu NoSQL và SQL khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- MongoDB là cơ sở dữ liệu NoSQL dạng document, lưu dữ liệu dạng JSON (BSON) trong collection
- SQL dùng bảng với schema cố định, quan hệ chặt, hỗ trợ join và transaction mạnh
- NoSQL schema linh hoạt, dễ mở rộng ngang
- SQL phù hợp dữ liệu có quan hệ phức tạp cần nhất quán cao, ví dụ tài chính
- NoSQL phù hợp dữ liệu thay đổi cấu trúc, khối lượng lớn, truy cập theo document', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e1bd31cd-bc44-5997-b20c-894600670c5c', 'Populate trong Mongoose là gì? Khi nào nên nhúng (embed) và khi nào nên tham chiếu (reference) trong MongoDB?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Populate thay id tham chiếu bằng document thật từ collection khác, tương tự join
- Populate tạo thêm truy vấn nên cẩn thận với hiệu năng
- Embed khi dữ liệu con gắn chặt với cha và luôn đọc cùng nhau
- Reference khi dữ liệu dùng chung nhiều nơi, lớn hoặc tăng không giới hạn
- Thiết kế theo cách dữ liệu được truy vấn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('975f72af-1ee9-5103-b75b-ddd11fcc3bf0', 'Bạn lưu mật khẩu người dùng an toàn như thế nào? Salt và pepper là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Không lưu mật khẩu dạng gốc hay mã hoá hai chiều, mà băm bằng hàm chậm như bcrypt, argon2
- Salt là chuỗi ngẫu nhiên riêng cho mỗi mật khẩu, lưu cùng hash, chống rainbow table và làm hash khác nhau dù cùng mật khẩu
- Pepper là giá trị bí mật chung lưu ngoài cơ sở dữ liệu, thêm một lớp bảo vệ khi cơ sở dữ liệu bị lộ
- Hàm băm chậm có cost factor làm việc dò mật khẩu tốn kém
- Không dùng MD5 hay SHA-1 để băm mật khẩu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('40f31291-4b56-50e9-aafe-20c41a995bfa', 'JWT là gì và hoạt động như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- JWT (JSON Web Token) gồm ba phần: header, payload và chữ ký, mã hoá base64url
- Payload chứa claim như id người dùng, vai trò, thời gian hết hạn
- Chữ ký giúp server kiểm tra token không bị sửa mà không cần lưu phiên
- Payload không được mã hoá nên không chứa thông tin nhạy cảm
- Client gửi token trong header Authorization dạng Bearer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2735c45a-89df-5b4b-991b-ea105e9a4764', 'Xác thực dựa trên session và dựa trên JWT có ưu nhược điểm gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Session: server lưu trạng thái phiên, dễ thu hồi ngay, nhưng cần lưu trữ chung khi chạy nhiều instance
- JWT: stateless, dễ mở rộng, phù hợp microservices và mobile
- Nhược điểm JWT: khó thu hồi trước hạn, token lớn hơn, lộ token thì bị dùng tới khi hết hạn
- Khắc phục bằng access token ngắn hạn kèm refresh token, danh sách thu hồi
- Cả hai đều cần chống XSS, CSRF tuỳ nơi lưu token', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f8380f41-4eb2-5c30-a01f-656de5bf5565', 'Go (Golang) là gì? Ưu nhược điểm và loại dự án phù hợp?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Go là ngôn ngữ biên dịch, kiểu tĩnh do Google phát triển
- Ưu điểm: cú pháp đơn giản, biên dịch nhanh ra một file chạy, hiệu năng tốt
- Hỗ trợ đồng thời có sẵn với goroutine và channel
- Nhược điểm: ít tính năng trừu tượng, xử lý lỗi dài dòng, generics mới có gần đây
- Phù hợp với dịch vụ mạng, microservices, công cụ hạ tầng như Docker, Kubernetes', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5ff26146-7fa2-5b73-93e4-9d8d0cce298e', 'Go có phải ngôn ngữ hướng đối tượng không? Vì sao Go không có class?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Go không có class và kế thừa theo kiểu truyền thống
- Dùng struct kết hợp method để gắn hành vi với dữ liệu
- Dùng embedding để tái sử dụng (composition thay vì inheritance)
- Interface được thoả mãn ngầm định, không cần khai báo implements
- Thiết kế này nhằm giữ ngôn ngữ đơn giản và khuyến khích composition', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b8c91a72-0c3c-54cb-9b06-a74b3055000a', 'Goroutine là gì? Goroutine khác thread như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Goroutine là luồng thực thi nhẹ do runtime của Go quản lý
- Khởi tạo rất rẻ với stack nhỏ (vài KB) có thể tự giãn
- Runtime ánh xạ nhiều goroutine lên ít luồng hệ điều hành (mô hình M:N)
- Chuyển ngữ cảnh do runtime thực hiện nên nhanh hơn thread hệ điều hành
- Có thể chạy hàng trăm nghìn goroutine cùng lúc', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('59fe1373-e314-5878-9626-977ae49e10fd', 'Array và slice trong Go khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Array có độ dài cố định là một phần của kiểu, truyền đi bằng cách sao chép
- Slice là view động trên một array bên dưới, gồm con trỏ, độ dài và capacity
- Slice có thể tăng kích thước bằng append, khi vượt capacity sẽ cấp phát array mới
- Nhiều slice có thể dùng chung array bên dưới nên sửa một slice có thể ảnh hưởng slice khác
- Thực tế slice được dùng phổ biến hơn array', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('064587db-9100-55be-8959-b3c8f5a74087', 'Interface trong Go là gì và vì sao dùng nó?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Interface là tập các method mà một kiểu cần có
- Một kiểu thoả mãn interface ngầm định khi có đủ method, không cần khai báo
- Giúp tách phụ thuộc và viết code đa hình
- Dễ thay thế triển khai và mock khi test
- Nên định nghĩa interface nhỏ, tại nơi sử dụng, ví dụ io.Reader, io.Writer', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1f2a85c2-e405-53ab-8992-c2dc80784b0b', 'Concurrency và parallelism khác nhau như thế nào?', 'IT', 'Backend Developer', 'EASY', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Concurrency là cấu trúc chương trình xử lý nhiều việc xen kẽ, đan xen theo thời gian
- Parallelism là thực sự chạy nhiều việc cùng lúc trên nhiều nhân CPU
- Chương trình concurrent có thể chạy trên một nhân
- Parallelism cần phần cứng nhiều nhân
- Concurrency giúp phản hồi tốt với I/O, parallelism giúp tăng tốc tính toán', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c29dce0a-ef62-5cfd-9eb2-949e1bf2c7f7', 'Channel trong Go dùng để làm gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Channel là kênh để các goroutine gửi và nhận dữ liệu, đồng bộ với nhau
- Theo triết lý chia sẻ bộ nhớ bằng cách giao tiếp thay vì giao tiếp bằng chia sẻ bộ nhớ
- Channel không buffer chặn cho tới khi cả bên gửi và nhận sẵn sàng
- Channel có buffer cho phép gửi tới khi đầy
- select dùng để chờ trên nhiều channel; đóng channel để báo hết dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('615545ff-ed35-59c0-9b66-8fede84f9bfe', 'Eventual consistency (nhất quán cuối cùng) là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu khái niệm -> giải thích cách hoạt động hoặc nguyên nhân -> lấy ví dụ thực tế khi vận hành hệ thống.', '- Là mô hình nhất quán trong đó các bản sao có thể tạm thời khác nhau
- Nếu không có cập nhật mới, cuối cùng mọi bản sao sẽ hội tụ về cùng giá trị
- Đánh đổi nhất quán tức thời lấy tính sẵn sàng và hiệu năng (theo định lý CAP)
- Thường gặp trong hệ thống phân tán, NoSQL, giao tiếp hướng sự kiện giữa microservices
- Ứng dụng cần xử lý việc đọc dữ liệu cũ và xung đột', 'ACTIVE', '00000000-0000-0000-0000-000000000001');
