-- Flyway migration V2: seed ngân hàng câu hỏi (sinh bởi scripts/dataset/build_seed_sql.py, không sửa tay).
-- Câu hỏi được chuyển thể sang tiếng Việt bằng Gemini từ các nguồn mở sau (giữ ghi nguồn theo license):
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
('e96bfeee-bb4c-5096-ae2f-7d45d5e6f64b', 'Học có giám sát (supervised machine learning) là gì? Bạn hãy cho ví dụ về một số thuật toán phổ biến.', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa dựa trên dữ liệu có nhãn (labeled data) -> mục tiêu học hàm ánh xạ từ input sang output -> phân loại thành hai bài toán chính (classification và regression) kèm ví dụ thuật toán.', '- Là phương pháp học máy trong đó mô hình được huấn luyện trên tập dữ liệu đã được gán nhãn (labeled data), gồm các cặp đặc trưng đầu vào (X) và nhãn đầu ra mong muốn (y)
- Mục tiêu là học được hàm ánh xạ f(X) xấp xỉ y để dự đoán chính xác nhãn cho dữ liệu mới chưa từng thấy
- Chia làm hai dạng bài toán chính: Hồi quy (Regression) dự đoán giá trị liên tục và Phân loại (Classification) dự đoán nhãn rời rạc
- Các thuật toán tiêu biểu: Linear Regression, Logistic Regression, Decision Tree, Random Forest, Support Vector Machine (SVM), K-Nearest Neighbors (KNN)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('02691895-ee60-51a5-bc84-6affa341ebde', 'Bài toán hồi quy (regression) là gì? Bạn có thể sử dụng những mô hình nào để giải quyết bài toán này?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa bài toán hồi quy (dự đoán biến liên tục) -> liệt kê các nhóm mô hình từ đơn giản (Linear, Ridge/Lasso) đến phức tạp hơn (Tree-based, Ensemble, Neural Networks) -> tiêu chí chọn lựa mô hình.', '- Bài toán hồi quy (regression) là dạng bài toán học có giám sát nhằm dự đoán giá trị đầu ra dạng liên tục (numeric/continuous) dựa trên các biến đầu vào
- Linear Regression: mô hình hóa quan hệ tuyến tính giữa biến giải thích và biến mục tiêu
- Ridge và Lasso Regression: các biến thể của hồi quy tuyến tính áp dụng chuẩn hóa L2 hoặc L1 để giảm overfitting và xử lý đa cộng tuyến
- Decision Tree và các mô hình Ensemble (Random Forest, Gradient Boosting như XGBoost, LightGBM): xử lý tốt các quan hệ phi tuyến và tương tác phức tạp giữa các đặc trưng
- Support Vector Regression (SVR) và Mạng nơ-ron (Neural Networks): dùng cho các bài toán phức tạp với lượng dữ liệu lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ee883a3b-4449-5d82-b48b-3a79af0ebc1b', 'Hồi quy tuyến tính (Linear Regression) là gì và chúng ta thường áp dụng nó trong những trường hợp nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Giải thích bản chất mô hình (quan hệ tuyến tính giữa X và y) -> phân biệt đơn biến và đa biến -> nêu các trường hợp phù hợp để áp dụng (cần tính diễn giải cao, dữ liệu quan hệ tuyến tính, baseline model).', '- Là mô hình dự đoán biến mục tiêu liên tục dựa trên giả định có mối quan hệ tuyến tính giữa các biến đầu vào (X) và biến đầu ra (y)
- Dạng phương trình tổng quát: y = beta_0 + beta_1*x_1 + ... + beta_n*x_n + epsilon, trong đó các hệ số beta thể hiện mức độ tác động của từng đặc trưng
- Phân loại: Simple Linear Regression (một biến độc lập) và Multiple Linear Regression (nhiều biến độc lập)
- Thường dùng khi: Cần mô hình có khả năng giải thích rõ ràng (interpretability) tác động của từng biến, khi quan hệ giữa các biến thực sự xấp xỉ tuyến tính, hoặc dùng làm mô hình chuẩn (baseline model) đơn giản ban đầu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('128cf028-1405-5eee-b2a9-531694f018ee', 'Các giả định cơ bản của mô hình hồi quy tuyến tính (Linear Regression) là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các giả định thống kê cốt lõi (LINE: Linearity, Independence, Normality, Equal variance) -> giải thích ngắn gọn ý nghĩa từng giả định và hệ quả nếu bị vi phạm.', '- Mối quan hệ tuyến tính (Linearity): Giữa các biến độc lập và biến phụ thuộc có quan hệ tuyến tính
- Tính độc lập của phần dư (Independence): Các sai số (residuals/errors) không tương quan với nhau, đặc biệt quan trọng với dữ liệu chuỗi thời gian (tránh autocorrelation)
- Phương sai sai số đồng nhất (Homoscedasticity): Phương sai của các sai số phải là hằng số trên toàn bộ miền giá trị dự đoán
- Phân phối chuẩn của sai số (Normality): Các sai số tuân theo phân phối chuẩn với trung bình bằng 0, quan trọng cho việc kiểm định giả thuyết và khoảng tin cậy
- Không có hiện tượng đa cộng tuyến hoàn hảo (No Multicollinearity): Các biến độc lập không được có tương quan quá cao với nhau', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d6a02936-6161-5434-917d-1a1100965d1e', 'Phân phối chuẩn (Normal distribution) là gì và tại sao nó lại quan trọng trong Data Science?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa hình dạng và đặc tính đối xứng của phân phối chuẩn -> liên hệ tới Định lý giới hạn trung tâm (Central Limit Theorem) -> lý do quan trọng trong mô hình hóa và kiểm định thống kê.', '- Là phân phối xác suất liên tục có đồ thị hình chuông đối xứng qua giá trị trung bình (mean), với mean = median = mode
- Được xác định hoàn toàn bởi hai tham số: giá trị trung bình (mu) và độ lệch chuẩn (sigma), tuân theo quy tắc thực nghiệm 68-95-99.7
- Tầm quan trọng bắt nguồn từ Định lý giới hạn trung tâm (CLT): Trung bình của một số lượng mẫu đủ lớn sẽ tiệm cận phân phối chuẩn bất kể phân phối gốc của tổng thể
- Là nền tảng cho nhiều phép kiểm định thống kê suy diễn (t-test, ANOVA, z-test) và giả định của nhiều thuật toán học máy (Linear Regression, LDA, Gaussian Naive Bayes)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('30e7d54f-f1ba-5dbc-a546-21802d4fd6d9', 'Bạn làm thế nào để kiểm tra xem một biến có tuân theo phân phối chuẩn hay không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Chia câu trả lời thành hai nhóm phương pháp: trực quan hóa (visual methods) và kiểm định thống kê (statistical tests) -> nêu tên các biểu đồ và phép kiểm định thông dụng.', '- Phương pháp trực quan: Vẽ biểu đồ Histogram kết hợp đường cong KDE để nhìn dạng hình chuông, hoặc dùng Q-Q Plot (Quantile-Quantile plot) để kiểm tra xem các điểm dữ liệu có nằm sát đường thẳng 45 độ hay không
- Đánh giá thông số hình học: Kiểm tra độ lệch (Skewness xấp xỉ 0) và độ nhọn (Kurtosis xấp xỉ 3 hoặc Excess Kurtosis xấp xỉ 0)
- Kiểm định thống kê (Statistical Normality Tests): Sử dụng kiểm định Shapiro-Wilk (hiệu quả cho mẫu nhỏ/vừa) hoặc Kolmogorov-Smirnov / Anderson-Darling
- Lưu ý thực tế: Với kích thước mẫu rất lớn (large sample size), các bài kiểm định thống kê thường quá nhạy và dễ bác bỏ giả thuyết H0, nên thường ưu tiên trực quan hóa bằng Q-Q plot', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fb647b79-d36c-5411-ab79-79b83cee6acd', 'Trong bài toán dự đoán giá cả (ví dụ giá nhà), biến giá thường có phân phối gì? Chúng ta có cần tiền xử lý biến này trước khi đưa vào mô hình không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Xác định dạng phân phối thực tế của biến giá (lệch phải / right-skewed) -> lý do xuất hiện -> các kỹ thuật tiền xử lý và biến đổi dữ liệu (Log transform, Box-Cox) -> tác dụng khi đưa vào mô hình.', '- Biến giá cả trong thực tế hầu như không có phân phối chuẩn mà thường có phân phối lệch phải (right-skewed / positive skew), do giá không thể âm và có một số ít mặt hàng/bất động sản có giá cực kỳ cao (outliers)
- Cần thực hiện tiền xử lý biến mục tiêu, đặc biệt khi sử dụng các mô hình tuyến tính đòi hỏi giả định về phân phối chuẩn của sai số hoặc nhạy cảm với scale
- Kỹ thuật biến đổi phổ biến nhất là Log Transformation (log(y) hoặc log1p(y)) giúp thu hẹp đuôi dài, đưa phân phối về gần chuẩn hơn và ổn định phương sai
- Có thể sử dụng biến đổi Box-Cox hoặc Yeo-Johnson nếu cần tự động tìm tham số tối ưu
- Khi đánh giá hoặc đưa kết quả dự đoán vào thực tế, cần nhớ đảo ngược phép biến đổi (exponential) để lấy lại đơn vị tiền tệ ban đầu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cce0c40c-2277-5581-93a5-f201ce575753', 'Bạn biết những phương pháp nào để tìm nghiệm tối ưu cho bài toán hồi quy tuyến tính?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu hai hướng tiếp cận chính: giải tích (Analytical / Closed-form solution) và số học lặp (Iterative / Numerical optimization) -> so sánh ưu nhược điểm và ngữ cảnh sử dụng.', '- Phương pháp giải tích (Closed-form solution / Normal Equation): Sử dụng công thức beta = (X^T * X)^(-1) * X^T * y để tìm nghiệm trực tiếp
- Ưu/nhược điểm Normal Equation: Cho nghiệm chính xác tuyệt đối trong một bước tính toán, nhưng chi phí tính ma trận nghịch đảo rất lớn O(n^3) nên không khả thi khi số lượng đặc trưng lớn
- Kỹ thuật phân rã ma trận: Trong thực tế thư viện như scikit-learn dùng Singular Value Decomposition (SVD) hoặc QR Decomposition để giải bình phương tối thiểu (OLS) ổn định hơn về mặt số học
- Phương pháp lặp (Gradient Descent): Cập nhật trọng số theo hướng ngược chiều đạo hàm của hàm mất mát (MSE)
- Ưu điểm Gradient Descent: Hoạt động rất tốt khi số lượng chiều (features) và số lượng mẫu dữ liệu lớn, có các biến thể như Mini-batch SGD', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bcd4f279-cd40-5e8d-b05a-65df4d9d0760', 'Gradient Descent là gì và thuật toán này hoạt động như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu bản chất thuật toán (tối ưu hóa hàm số) -> cơ chế hoạt động (đạo hàm/gradient, learning rate, cập nhật trọng số) -> điều kiện dừng.', '- Gradient Descent là thuật toán tối ưu hóa lặp (iterative optimization) dùng để tìm các tham số mô hình nhằm cực tiểu hóa hàm mất mát (loss function)
- Cơ chế hoạt động: Tính gradient (đạo hàm riêng) của hàm mất mát theo từng tham số tại điểm hiện tại; gradient chỉ hướng dốc tăng nhanh nhất
- Bước cập nhật: Di chuyển các tham số ngược hướng với gradient theo công thức: theta = theta - alpha * gradient, trong đó alpha là tốc độ học (learning rate)
- Tốc độ học (learning rate): Nếu quá nhỏ sẽ hội tụ rất chậm; nếu quá lớn có thể dao động hoặc phân kỳ không đạt được nghiệm tối ưu
- Điều kiện dừng: Thuật toán dừng lại khi gradient xấp xỉ bằng 0 (đạt cực tiểu địa phương hoặc toàn cục), hoặc giá trị loss thay đổi không đáng kể, hoặc đạt số vòng lặp tối đa', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0483b9fa-25d0-56ba-a03e-ee70b8dae588', 'Phương trình chuẩn (Normal Equation) trong hồi quy tuyến tính là gì và ưu nhược điểm của nó ra sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa và công thức ma trận của Normal Equation -> giải thích cách suy biến từ việc đạo hàm hàm mất mát bằng 0 -> nêu ưu nhược điểm so với Gradient Descent.', '- Normal Equation là phương pháp giải tích (analytical approach) để tìm trực tiếp các hệ số beta tối ưu của bài toán hồi quy tuyến tính bằng cách giải hệ phương trình đạo hàm riêng của hàm mất mát OLS bằng 0
- Công thức nghiệm dạng ma trận: beta = (X^T * X)^(-1) * X^T * y
- Ưu điểm: Không cần chọn tham số tốc độ học (learning rate), không cần lặp nhiều vòng, không cần chuẩn hóa thang đo dữ liệu (feature scaling)
- Nhược điểm: Phép nghịch đảo ma trận (X^T * X) có độ phức tạp tính toán xấp xỉ O(n^3), rất chậm hoặc không chạy nổi khi số đặc trưng (n) lớn
- Rủi ro ma trận không khả nghịch (non-invertible/singular) khi các đặc trưng bị đa cộng tuyến hoặc số đặc trưng lớn hơn số mẫu (n > m)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dea9192f-92f6-52e4-a6e8-4aa50c9e459f', 'Stochastic Gradient Descent (SGD) là gì? Điểm khác biệt cơ bản giữa SGD và Gradient Descent truyền thống là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa SGD -> so sánh số lượng dữ liệu dùng trong mỗi lần cập nhật trọng số giữa Batch GD, SGD và Mini-batch GD -> so sánh về tốc độ và tính ổn định khi hội tụ.', '- Điểm khác biệt cốt lõi nằm ở số lượng mẫu dữ liệu được sử dụng để tính gradient trong mỗi bước cập nhật tham số
- Batch Gradient Descent (truyền thống): Sử dụng toàn bộ tập dữ liệu huấn luyện để tính gradient cho một lần cập nhật; gradient rất chính xác và mượt mà nhưng cực kỳ chậm và tốn bộ nhớ với dữ liệu lớn
- Stochastic Gradient Descent (SGD): Chỉ sử dụng ngẫu nhiên một mẫu dữ liệu duy nhất tại mỗi bước cập nhật; tốc độ tính toán mỗi bước cực nhanh và cập nhật thường xuyên
- Tính chất hội tụ: Quỹ đạo của SGD dao động mạnh (noisy), có thể giúp nhảy ra khỏi các điểm cực tiểu cục bộ (local minima) nông, nhưng khó ổn định tại điểm cực tiểu toàn cục nếu không giảm dần learning rate
- Mini-batch SGD: Giải pháp dung hòa thực tế, sử dụng một batch nhỏ (ví dụ 32, 64, 128 mẫu) để tận dụng khả năng tính toán ma trận song song của GPU/CPU', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ca6e5d22-3a4e-5e1c-b355-20b4b10113c3', 'Bạn thường sử dụng những chỉ số (metrics) nào để đánh giá hiệu năng của một mô hình hồi quy?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Liệt kê các chỉ số đo sai số (MAE, MSE, RMSE, MAPE) -> chỉ số đo mức độ giải thích (R-squared, Adjusted R-squared) -> ngữ cảnh chọn chỉ số phù hợp.', '- Mean Absolute Error (MAE): Trung bình độ lệch tuyệt đối giữa thực tế và dự đoán; trực quan, cùng đơn vị với biến mục tiêu và ít nhạy cảm với outlier
- Mean Squared Error (MSE) và Root Mean Squared Error (RMSE): Trung bình bình phương sai số; phạt rất nặng các sai số lớn do có lũy thừa bậc hai, RMSE cùng đơn vị với biến mục tiêu
- Mean Absolute Percentage Error (MAPE): Đo sai số theo tỷ lệ phần trăm, dễ hiểu cho các bên nghiệp vụ (business) nhưng không tính được khi giá trị thực tế bằng 0
- R-squared (R²): Hệ số xác định, thể hiện tỷ lệ phần trăm phương sai của biến phụ thuộc được giải thích bởi các biến độc lập trong mô hình (từ 0 đến 1)
- Adjusted R-squared: Hiệu chỉnh R² dựa trên số lượng biến độc lập trong mô hình để tránh việc thêm biến vô nghĩa làm tăng ảo R²', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('31d51b3e-43ba-52f5-860f-ea7145081a21', 'Chỉ số MSE và RMSE trong bài toán hồi quy là gì? Chúng khác nhau như thế nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa và công thức tính của MSE và RMSE -> so sánh về đơn vị đo lường và khả năng diễn giải thực tế -> điểm chung về độ nhạy với outlier.', '- MSE (Mean Squared Error) là trung bình cộng của bình phương các sai số giữa giá trị dự đoán và giá trị thực tế
- RMSE (Root Mean Squared Error) là căn bậc hai của MSE
- Khác biệt về đơn vị đo: Đơn vị của MSE là bình phương đơn vị của biến mục tiêu (ví dụ: mét vuông bình phương, USD bình phương), gây khó diễn giải; trong khi RMSE đưa đơn vị về lại cùng thang đo với biến mục tiêu
- Điểm chung: Cả hai chỉ số đều khuếch đại các sai số lớn do có phép bình phương, khiến chúng rất nhạy cảm với các điểm dữ liệu dị biệt (outliers)
- Thường dùng RMSE khi muốn diễn giải sai số trực tiếp trên cùng thước đo với dữ liệu thực tế nhưng vẫn muốn phạt nặng các lỗi dự đoán sai lệch lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61127aa6-6ba5-587c-9512-45059e7f348d', 'Bạn hiểu thế nào về sự đánh đổi giữa Bias và Variance (Bias-Variance Tradeoff)?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa Bias và Variance -> phân tích mối quan hệ nghịch biến khi độ phức tạp của mô hình thay đổi -> liên hệ tới Underfitting và Overfitting -> mục tiêu tối ưu tổng sai số.', '- Bias (Độ lệch): Sai số do mô hình quá đơn giản hóa mối quan hệ thực tế trong dữ liệu, dẫn đến không học được mẫu quy luật (gây Underfitting)
- Variance (Phương sai): Độ nhạy cảm của mô hình với những biến động ngẫu nhiên hoặc nhiễu trong tập dữ liệu huấn luyện, khiến mô hình học thuộc lòng dữ liệu train nhưng dự đoán kém trên test (gây Overfitting)
- Quan hệ đánh đổi (Tradeoff): Khi độ phức tạp của mô hình tăng lên, Bias giảm đi nhưng Variance tăng lên; ngược lại khi mô hình đơn giản hơn, Variance giảm nhưng Bias tăng
- Tổng sai số kỳ vọng: Expected Error = Bias² + Variance + Irreducible Error (nhiễu không thể giảm)
- Mục tiêu trong Machine Learning: Tìm điểm cân bằng tối ưu giữa Bias và Variance để cực tiểu hóa tổng sai số trên tập dữ liệu kiểm thử (test data)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('22aebe4f-a65c-5eb1-844e-7031f83dadd6', 'Hiện tượng Overfitting trong Machine Learning là gì và làm thế nào để nhận biết nó?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa Overfitting -> dấu hiệu nhận biết thông qua kết quả train/validation -> nguyên nhân cơ bản -> các biện pháp xử lý chính.', '- Khái niệm: Overfitting (quá khớp) là hiện tượng mô hình học quá kỹ các chi tiết cụ thể và cả nhiễu trong tập dữ liệu huấn luyện (training set), làm mất đi khả năng tổng quát hóa (generalization) trên dữ liệu mới chưa từng thấy
- Dấu hiệu nhận biết: Độ chính xác hoặc sai số trên tập huấn luyện rất tốt (training error rất thấp), nhưng hiệu năng trên tập validation/test lại kém hơn rõ rệt (validation error cao)
- Nguyên nhân chính: Mô hình quá phức tạp so với lượng dữ liệu, dữ liệu huấn luyện có nhiều nhiễu hoặc số lượng mẫu quá ít
- Phương pháp khắc phục: Bổ sung thêm dữ liệu huấn luyện, giảm độ phức tạp mô hình, áp dụng kỹ thuật chuẩn hóa (Regularization L1/L2), dùng Cross-Validation, áp dụng Dropout (trong Deep Learning) hoặc Early Stopping', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3f4ea6ec-aa5e-5963-aebf-f0df2efccd59', 'Bạn thường thực hiện validation cho các mô hình Machine Learning như thế nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày các phương pháp phổ biến như train/val/test split và K-fold cross-validation, giải thích mục đích của từng bước và cách kết hợp chúng trong thực tế.', '- Chia tập dữ liệu thành ba phần độc lập: Train (huấn luyện tham số mô hình), Validation (tinh chỉnh hyperparameter, chọn mô hình), và Test (đánh giá hiệu năng cuối cùng).
- Sử dụng K-fold Cross-Validation: chia tập train thành K phần, luân phiên huấn luyện trên K-1 phần và đánh giá trên 1 phần để giảm bias từ việc chia ngẫu nhiên.
- Kết hợp cả hai phương pháp: giữ lại một tập Test độc lập (holdout test set), thực hiện Cross-Validation trên phần dữ liệu còn lại để chọn mô hình và tinh chỉnh hyperparameter trước khi đo lường lần cuối trên test set.
- Áp dụng các kỹ thuật phù hợp với đặc thù dữ liệu, ví dụ Stratified K-fold cho dữ liệu imbalanced hoặc Time Series Split cho dữ liệu chuỗi thời gian.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e918086c-e260-52e2-b4f0-1bbfde56e5eb', 'Tại sao chúng ta cần chia dữ liệu thành ba tập riêng biệt: train, validation và test?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Đi từ vai trò của từng tập dữ liệu, sau đó giải thích nguy cơ rò rỉ dữ liệu (data leakage) hoặc overfitting nếu chỉ dùng train và test mà không có validation.', '- Tập Train dùng để học các tham số nội tại (weights/parameters) của mô hình từ dữ liệu huấn luyện.
- Tập Validation dùng để tinh chỉnh siêu tham số (tuning hyperparameters) và lựa chọn mô hình tốt nhất, giúp tối ưu khả năng tổng quát hóa mà không làm rò rỉ thông tin của tập test.
- Tập Test đóng vai trò là dữ liệu hoàn toàn chưa từng thấy (unseen data) để đánh giá khách quan hiệu năng thực tế của mô hình trước khi triển khai.
- Nếu chỉ chia train/test và dùng test để chỉnh hyperparameter, mô hình sẽ bị overfit gián tiếp vào tập test và không còn phản ánh trung thực khả năng chạy thực tế.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bac2caf3-362b-512a-8ba8-36523b3531ff', 'Bạn hãy giải thích cơ chế hoạt động của kỹ thuật Cross-Validation?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa và mục đích chính của Cross-Validation, các bước thực hiện lặp (iterations), và ưu điểm so với việc chỉ chia tập dữ liệu một lần (train-test split thông thường).', '- Cross-validation là kỹ thuật đánh giá mô hình bằng cách chia dữ liệu thành nhiều phần và thực hiện huấn luyện - kiểm tra lặp lại nhiều vòng.
- Trong mỗi vòng, một phần dữ liệu được giữ lại làm validation set, các phần còn lại gộp lại làm training set để huấn luyện mô hình.
- Quá trình này được lặp lại sao cho mỗi phần dữ liệu đều được đóng vai trò làm validation set đúng một lần.
- Kết quả cuối cùng là trung bình cộng của các chỉ số đánh giá qua các vòng, giúp giảm thiểu phương sai (variance) và hạn chế bias do việc chia ngẫu nhiên một lần duy nhất gây ra.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8bb6eca5-d38d-52c4-93e8-2c45d92dd648', 'K-fold Cross-Validation là gì và quy trình thực hiện cụ thể ra sao?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa K-fold, mô tả từng bước chia K phần và vòng lặp huấn luyện, sau đó nêu lưu ý về các trường hợp không nên dùng K-fold thông thường.', '- K-fold Cross-Validation là kỹ thuật chia toàn bộ tập dữ liệu thành K phần (folds) có kích thước xấp xỉ bằng nhau.
- Quy trình gồm K vòng lặp: ở mỗi vòng, 1 fold được chọn làm validation set và K-1 folds còn lại làm training set để huấn luyện mô hình.
- Sau K vòng, tính giá trị trung bình và độ lệch chuẩn của các metric đo lường để đánh giá độ ổn định và hiệu năng tổng thể của mô hình.
- Lưu ý không sử dụng K-fold chuẩn cho dữ liệu chuỗi thời gian (time series) để tránh data leakage từ tương lai vào quá khứ, và nên dùng Stratified K-fold khi dữ liệu mất cân bằng nhãn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c83c251e-2d8d-5adc-8f2c-af6482a08fb4', 'Làm thế nào để chọn giá trị K phù hợp trong K-fold Cross-Validation, và bạn thường chọn K bằng bao nhiêu trong thực tế?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Giải thích sự đánh đổi giữa bias, variance và chi phí tính toán (computational cost) khi tăng/giảm K, sau đó chia sẻ giá trị K phổ biến kèm lý do thực tiễn.', '- Việc chọn K dựa trên sự đánh đổi giữa bias, variance và chi phí tài nguyên tính toán (computational cost).
- K nhỏ (ví dụ K=2, 3): thời gian huấn luyện nhanh nhưng validation set lớn hơn, training set nhỏ hơn dẫn đến bias cao hơn và ước lượng kém chính xác.
- K lớn (ví dụ K=10 hoặc Leave-One-Out): bias thấp, tận dụng tối đa dữ liệu để train nhưng chi phí tính toán tăng mạnh và variance giữa các fold có thể cao hơn do các tập train quá giống nhau.
- Trong thực tế, K=5 hoặc K=10 thường là lựa chọn tiêu chuẩn và cân bằng tốt nhất giữa độ chính xác ước lượng và thời gian thực thi.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7058e2a9-d07c-559f-b6ee-4b03a416083e', 'Tại sao bạn lại muốn làm việc tại công ty chúng tôi?', 'IT', 'Chung', 'EASY', 'INTRO', 'Bắt đầu từ sự hiểu biết của bạn về sản phẩm/văn hóa công ty, kết nối với thế mạnh và giá trị bạn theo đuổi, sau đó nêu rõ mục tiêu muốn đóng góp và phát triển tại đây.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce260428-37e3-5fbd-a82f-9c3fd339b9fa', 'Tại sao bạn lại quyết định rời khỏi công ty hiện tại (hoặc công ty gần nhất)?', 'IT', 'Chung', 'EASY', 'INTRO', 'Tập trung vào khía cạnh tích cực hướng tới tương lai như tìm kiếm thử thách mới, cơ hội phát triển hoặc mở rộng chuyên môn; tránh nói xấu đồng nghiệp hay công ty cũ.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7eb84664-d80e-5984-ad39-62ba897bb957', 'Bạn kỳ vọng tìm kiếm điều gì ở vai trò và công việc tiếp theo của mình?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu rõ định hướng nghề nghiệp, loại thử thách kỹ thuật hoặc môi trường làm việc bạn muốn trải nghiệm, và cách công việc này khớp với kế hoạch phát triển bản thân.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce4f20c4-d487-5a17-b531-21abab6734f0', 'Hãy kể về một lần bạn xảy ra mâu thuẫn hoặc bất đồng quan điểm với đồng nghiệp.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Sử dụng mô hình STAR: Nêu bối cảnh và nguyên nhân bất đồng (tập trung vào công việc), cách bạn chủ động lắng nghe, đối thoại giải quyết, và kết quả tích cực đạt được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8a8f933c-6a9b-5df9-85fa-fce5dbfd60bf', 'Hãy kể về một lần bạn có bất đồng quan điểm và cần phải thuyết phục người khác đồng thuận với giải pháp của mình.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng phương pháp STAR: Trình bày sự khác biệt quan điểm, cách bạn sử dụng số liệu, lý lẽ hoặc bản demo kỹ thuật để thuyết phục một cách tôn trọng, và kết quả chung cho dự án.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ce13a5ab-9cfd-5851-bff1-31dd433cce2f', 'Bạn có thể chia sẻ về dự án mà bạn đang tham gia gần đây không?', 'IT', 'Backend Developer', 'EASY', 'INTRO', 'Mô tả ngắn gọn mục tiêu của dự án, công nghệ sử dụng, vai trò cụ thể và những đóng góp chính của bạn trong đội ngũ.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('50cf13cb-55b2-56cb-9a29-933b748c3418', 'Thách thức lớn nhất mà bạn gặp phải trong dự án hiện tại là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng STAR: Nêu rõ bài toán hóc búa (về mặt kỹ thuật, kiến trúc, timeline hoặc nhân sự), giải pháp bạn đã đề xuất thực hiện và kết quả thu được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('49bacf96-13c6-53f8-a7fa-e2b8c4127549', 'Bug phức tạp nhất mà bạn đã từng sửa trong vòng 6 tháng qua là gì?', 'IT', 'Backend Developer', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng STAR: Mô tả triệu chứng của lỗi, quá trình bạn khoanh vùng và debug (công cụ/phương pháp), nguyên nhân gốc rễ (root cause), cách xử lý và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('820f5c17-485f-5c52-8a6f-3e62f9b93b61', 'Bạn thường tiếp cận và giải quyết các bài toán khó như thế nào? Hãy chia sẻ một thách thức cụ thể trong dự án, cách bạn vượt qua và bài học rút ra.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Tóm tắt ngắn gọn tư duy tiếp cận vấn đề của bạn, sau đó dùng cấu trúc STAR kể một ví dụ cụ thể và kết lại bằng bài học giá trị bạn đã tích lũy.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('39a0580f-c660-53e6-8ec4-5eee0f38f766', 'Điều gì trong công việc hoặc công nghệ khiến bạn cảm thấy hào hứng và đam mê nhất hiện nay?', 'IT', 'Chung', 'EASY', 'INTRO', 'Chia sẻ về một công nghệ mới, một loại bài toán hoặc sản phẩm bạn quan tâm, lý do bạn thấy nó hấp dẫn và cách bạn đang tự học hoặc áp dụng nó.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e01f20cb-12d5-51fa-9060-16ded4f21857', 'Điều gì thường khiến bạn cảm thấy thất vọng hoặc nản lòng trong công việc, và bạn xử lý cảm xúc đó như thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Chọn một tình huống thực tế mang tính xây dựng (ví dụ: quy trình thiếu rõ ràng, tech debt kéo dài), tập trung vào cách bạn chủ động tìm giải pháp và giữ thái độ chuyên nghiệp.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5d636db2-e97a-57af-98ea-b4e45674f25f', 'Giả sử hôm nay là ngày đầu tiên bạn làm việc tại công ty chúng tôi, bạn mong muốn được bắt tay vào phần việc gì, hoặc cải thiện tính năng nào của sản phẩm?', 'IT', 'Backend Developer', 'MEDIUM', 'SITUATIONAL', 'Thể hiện hiểu biết về sản phẩm của công ty: Nêu phân tích nhanh về điểm có thể tối ưu → Đề xuất ý tưởng/tính năng muốn làm → Giải thích lý do vì sao điều đó mang lại giá trị cho người dùng hoặc hệ thống.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('54dbe57b-c184-5334-88e6-2e950991fc8d', 'Dự án thú vị nhất bạn từng tham gia là gì và những kinh nghiệm từ dự án đó có thể áp dụng vào môi trường của công ty chúng tôi như thế nào?', 'IT', 'Backend Developer', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng STAR để tóm tắt điểm nổi bật của dự án thú vị đó, sau đó kết nối những kỹ năng hoặc kiến thức thực tiễn đó với sản phẩm, bài toán công nghệ của công ty.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d9b940cf-b077-5a67-b8d9-2241187937ee', 'Hãy kể về một lần bạn có quan điểm bất đồng với quản lý trực tiếp của mình và cách bạn giải quyết tình huống đó.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Dùng mô hình STAR: Trình bày bối cảnh bất đồng (chuyên môn/tiến độ), cách bạn trao đổi thẳng thắn trên tinh thần xây dựng và tôn trọng, cùng kết quả đạt được sau khi thống nhất.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('69c9b93f-2730-5374-8a97-c34e47f658a9', 'Hãy chia sẻ về một dự án mà bạn cảm thấy tâm đắc nhất hoặc thể hiện tốt nhất năng lực chuyên môn của mình.', 'IT', 'Backend Developer', 'MEDIUM', 'BEHAVIORAL', 'Dùng mô hình STAR: Mô tả mục tiêu dự án, lý do bạn tâm đắc, những hành động và giải pháp chuyên môn bạn đã triển khai, cùng kết quả hoặc tác động tích cực dự án mang lại.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0de2852a-17e3-5842-af3d-5c876229dabb', 'Một ngày làm việc lý tưởng hoặc hiệu quả nhất của bạn diễn ra như thế nào?', 'IT', 'Chung', 'EASY', 'INTRO', 'Mô tả nhịp độ làm việc lý tưởng từ đầu ngày đến cuối ngày, tập trung vào sự cân bằng giữa tập trung cá nhân (deep work), cộng tác với đồng đội và cảm giác hoàn thành công việc có giá trị.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c6280b9a-f45c-57f9-9d58-cb95d9699ef5', 'Hãy kể về một ý tưởng hoặc giải pháp mà bạn đã phải kiên quyết đấu tranh, thuyết phục mọi người chấp thuận trong dự án trước đây.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng cấu trúc STAR: Nêu rõ bối cảnh và ý tưởng bạn đề xuất, lý do ban đầu gặp phản đối, cách bạn thu thập số liệu hay dẫn chứng để thuyết phục mọi người, và kết quả mang lại cho dự án.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3f3dcef-8b3b-5105-98cf-78876c4bf685', 'Đâu là lời nhận xét, góp ý mang tính xây dựng sâu sắc nhất mà bạn từng nhận được trong sự nghiệp?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Chia sẻ bối cảnh và nội dung phản hồi bạn nhận được, cách bạn lắng nghe một cách cởi mở và những hành động cụ thể bạn đã thực hiện để thay đổi và phát triển bản thân.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4bd464a2-2e12-55d2-b27c-15d3ea7e538d', 'Hãy kể về một mục tiêu hoặc thử thách đòi hỏi bạn phải kiên trì nỗ lực trong nhiều tháng liên tục.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Sử dụng mô hình STAR: Giới thiệu mục tiêu dài hạn, các khó khăn và trở ngại gặp phải theo thời gian, cách bạn duy trì động lực, điều chỉnh chiến lược và kết quả cuối cùng đạt được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1ddb1545-286f-5de6-bdf6-8c8572be59f4', 'Hãy kể về một lần bạn phải hoàn thành công việc dưới áp lực thời gian vô cùng gấp rút.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng cấu trúc STAR: Làm rõ lý do deadline gấp, cách bạn ưu tiên công việc quan trọng, cắt giảm phạm vi (scope) nếu cần, phối hợp cùng nhóm và kết quả bàn giao.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('15363f91-7dc1-592a-b19b-f3412fe8f3d5', 'Nếu hôm nay là buổi đánh giá hiệu quả công việc sau một năm bạn làm việc tại công ty chúng tôi, bạn kỳ vọng tôi sẽ nhận xét gì về bạn?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Thể hiện kỳ vọng thực tế về những đóng góp của bạn: từ việc nắm bắt hệ thống, giải quyết các bài toán quan trọng, hòa nhập văn hóa cho đến giá trị cụ thể mà bạn đem lại cho team.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('122f12fa-6efa-5097-aa34-ffab15a027a0', 'Quản lý thời gian là yếu tố then chốt cho năng suất làm việc. Bạn hãy chia sẻ một kỹ năng quản lý thời gian mà mình đã học được và áp dụng hiệu quả vào công việc.', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Nêu phương pháp quản lý thời gian bạn sử dụng (ví dụ: Pomodoro, Time-blocking, Ma trận Eisenhower), tình huống cụ thể bạn áp dụng và sự cải thiện rõ rệt về hiệu suất.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f1a4733e-c687-5352-b760-c7f4e511cbab', 'Hãy chia sẻ về một lần bạn gặp khó khăn trong việc phối hợp hoặc hòa hợp với đồng nghiệp, và bạn đã giải quyết việc đó ra sao.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Dùng mô hình STAR: Mô tả nguyên nhân bất đồng một cách khách quan (không đổ lỗi), cách bạn chủ động đối thoại trực tiếp để thấu hiểu quan điểm đối phương, và kết quả hòa hợp công việc sau đó.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ef92c230-ee71-569a-a91b-623783d142dd', 'Trong công việc, khía cạnh nào của bạn là điểm thường nhận được nhiều góp ý hoặc phê bình nhất từ người khác?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Thành thật nhìn nhận một điểm yếu thực sự trong công việc, giải thích lý do tại sao nó xảy ra và nêu các giải pháp, thói quen cụ thể bạn đang rèn luyện để khắc phục.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4212dbb6-719d-5b35-ab4f-348842773372', 'Bạn thường tiếp nhận và xử lý những ý kiến phê bình hoặc phản hồi trái chiều về công việc của mình như thế nào?', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Nhấn mạnh thái độ cầu thị, tách bạch cảm xúc cá nhân khỏi công việc, cách bạn lắng nghe, đặt câu hỏi làm rõ và đưa ra hành động cải thiện cụ thể.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('907e492e-28a9-5ab7-8497-fc52d5309aab', 'Theo bạn, những thế mạnh nào là quan trọng nhất để làm tốt vị trí Software Engineer?', 'IT', 'Backend Developer', 'EASY', 'INTRO', 'Kết hợp giữa kỹ năng chuyên môn (tư duy logic, giải quyết vấn đề, viết code sạch) và kỹ năng mềm (giao tiếp, làm việc nhóm, tinh thần tự học); sau đó liên hệ ngắn gọn với thế mạnh của bản thân.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('20f4effc-2d4e-5c7a-8b48-d7f3a5642edf', 'Nếu được hỏi, các đồng nghiệp cũ thường dùng những từ ngữ nào để miêu tả về bạn và cách bạn làm việc?', 'IT', 'Chung', 'EASY', 'INTRO', 'Chọn 2-3 tính từ hoặc cụm từ phản ánh đúng phẩm chất nghề nghiệp nổi bật nhất của bạn (ví dụ: đáng tin cậy, tỉ mỉ, hỗ trợ nhiệt tình) và kèm theo một minh chứng ngắn gọn.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b501452f-889d-5223-9456-e6cfc1ba91a7', 'Bạn đặt ra mục tiêu sẽ đạt được những thành tựu gì trong 6 tháng đầu tiên sau khi gia nhập công ty?', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Chia nhỏ lộ trình theo các giai đoạn: 30-60 ngày đầu để làm quen hệ thống và văn hóa, 90 ngày để hoàn thành độc lập các nhiệm vụ, và 6 tháng để tạo ra tác động rõ rệt vào dự án của team.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('13bfd435-bda7-5cd5-9496-23f0f7a5cf06', 'Theo bạn, điều gì khiến bạn trở thành một ứng viên phù hợp với vị trí này?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu 2-3 điểm mạnh cốt lõi có sự trùng khớp cao với yêu cầu tuyển dụng: kinh nghiệm thực chiến với tech stack liên quan, khả năng thích ứng nhanh và tinh thần trách nhiệm trong công việc.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('92550192-ed7f-5712-b010-21b6c67135c5', 'Tuần này bạn vừa học được điều gì mới hoặc tìm hiểu thêm công nghệ nào?', 'IT', 'Chung', 'EASY', 'INTRO', 'Chia sẻ ngắn gọn về một công nghệ, kỹ thuật hoặc lỗi thú vị bạn vừa tìm hiểu gần đây, lý do bạn tò mò và bạn áp dụng nó vào công việc ra sao.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c4afc902-93d3-54a4-8bec-c83c2f2e5453', 'Điều gì khiến bạn cảm thấy hứng thú hoặc say mê nhất với công việc quản trị hệ thống (sysadmin)?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'INTRO', 'Bày tỏ động lực cá nhân: có thể là việc giải quyết các sự cố hóc búa, tự động hóa các tác vụ lặp đi lặp lại hoặc cảm giác duy trì hệ thống chạy mượt mà 24/7.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5afc4933-29ef-5918-b470-3f8387bdc539', 'Hãy kể về dự án lớn gần đây nhất mà bạn đã hoàn thành.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Trình bày theo mô hình STAR: bối cảnh dự án, trách nhiệm và vai trò cụ thể của bạn, các giải pháp kỹ thuật đã triển khai và kết quả đạt được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3cc7e082-0929-560c-806a-ac82f361c11f', 'Bạn có từng tham gia đóng góp cho dự án mã nguồn mở nào chưa? Hãy chia sẻ về trải nghiệm đó.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Nếu có, nêu tên dự án, cách bạn đóng góp (code, tài liệu, issue) và bài học rút ra. Nếu chưa, có thể chia sẻ các dự án cá nhân hoặc cách bạn tận dụng mã nguồn mở.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0675061b-36d6-529c-99a6-7a54963aaa97', 'Bạn có thể mô tả hệ thống homelab hoặc môi trường tự thực hành thử nghiệm tại nhà của bạn không?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày kiến trúc phần cứng/ảo hóa bạn đang dùng, các dịch vụ đang chạy thử nghiệm và mục đích bạn dựng homelab đó để học hỏi điều gì.', '- Phần cứng và nền tảng ảo hóa sử dụng (ví dụ: PC cũ, Raspberry Pi, Proxmox, VMware ESXi, KVM).
- Các dịch vụ chính đang tự host hoặc thử nghiệm (ví dụ: Pi-hole, Nextcloud, TrueNAS, reverse proxy Nginx/Traefik).
- Cách tổ chức mạng nội bộ (mạng LAN, VLAN, VPN kết nối từ xa như WireGuard/Tailscale).
- Hạ tầng container hóa hoặc tự động hóa (Docker, k3s, Ansible script để triển khai).
- Mục tiêu học tập và ứng dụng thực tế từ homelab (test lab, thử nghiệm update trước khi áp dụng vào công việc).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5ea88f82-dab5-524e-a572-1c322ecf488e', 'Thành tựu cá nhân nào trong sự nghiệp khiến bạn cảm thấy tự hào nhất?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Chọn một thành tích tiêu biểu theo mô hình STAR: tình huống khó khăn ban đầu, hành động đột phá của bạn và tác động tích cực mà thành tựu đó mang lại.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('71afce3a-8fb9-5d85-8214-ce2a021c7c0a', 'Hãy kể về sai lầm lớn nhất bạn từng mắc phải trong công việc. Nếu gặp lại tình huống đó hôm nay, bạn sẽ xử lý thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Thành thật nhận trách nhiệm về sự cố theo STAR, giải thích cách khắc phục hậu quả lúc đó và những biện pháp phòng ngừa/bài học bạn áp dụng hiện tại.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c3c06c73-010a-5ec5-a0ad-5dd9f6cd42ce', 'Trong ngày đầu tiên nhận việc tại công ty mới, bạn thường cài đặt những phần mềm, công cụ làm việc nào trên máy của mình?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Liệt kê các nhóm công cụ thiết yếu phục vụ công việc hàng ngày: terminal/shell, code/text editor, bảo mật/kết nối mạng và công cụ giao tiếp/quản lý tác vụ.', '- Terminal và Shell nâng cao: iTerm2, Windows Terminal, Zsh/Bash cấu hình kèm Oh My Zsh hoặc tmux.
- Trình biên tập mã nguồn và cấu hình: VS Code, Vim/Neovim cùng các extension cần thiết (Git, Docker, YAML, Terraform).
- Công cụ kết nối và truyền file: SSH client, OpenVPN, WireGuard, FileZilla, PuTTY hoặc MobaXterm.
- Công cụ quản lý mã nguồn và API/container: Git, Docker CLI, Postman hoặc curl/httpie.
- Ứng dụng bảo mật và giao tiếp: Password manager (Bitwarden, 1Password), Slack, Microsoft Teams, Jira.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('02758af3-b0e0-598e-819c-2ae78e79fa30', 'Bạn thường quản lý và lưu trữ tài liệu, cơ sở tri thức công việc của mình như thế nào (ví dụ wiki, ghi chú, portal)?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'TECHNICAL', 'Trình bày về công cụ bạn chọn, cách bạn phân loại và cập nhật tài liệu thường xuyên, cũng như văn hóa chia sẻ kiến thức với đồng nghiệp trong đội ngũ.', '- Nền tảng và công cụ sử dụng: Confluence, Notion, Obsidian, GitHub Wiki, hoặc tài liệu Markdown theo mô hình Docs-as-Code.
- Cấu trúc tổ chức thông tin: chia theo hệ thống, Runbook/Playbook xử lý sự cố, sơ đồ kiến trúc hạ tầng và hướng dẫn onboarding.
- Quy trình cập nhật: gắn việc cập nhật tài liệu vào quy trình bàn giao task (Definition of Done) hoặc sau mỗi buổi post-mortem sự cố.
- Khả năng tìm kiếm và bảo mật: phân quyền truy cập thông tin nhạy cảm (không lưu plain-text secret) và đảm bảo thông tin dễ tra cứu cho đồng nghiệp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('920c2308-3f9e-546f-aea5-26a619902a05', 'Bạn thường theo dõi những nguồn tin tức công nghệ hoặc bảo mật nào hàng ngày để cập nhật kiến thức?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'INTRO', 'Nêu 2-3 nguồn uy tín bạn thường xuyên đọc (ví dụ: Reddit r/sysadmin, Hacker News, The Hacker News, CVE feeds, blogs) và thói quen cập nhật của bạn.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1fbffb5-a631-52be-bd69-13814d31d72a', 'Nếu đội ngũ của bạn được cấp ngân sách để thi chứng chỉ quản trị hệ thống, bạn sẽ chọn chứng chỉ nào và vì sao?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'INTRO', 'Nêu tên chứng chỉ cụ thể (ví dụ: RHCSA/RHCE, CKA, AWS Solutions Architect), giải thích lý do lựa chọn gắn với định hướng nghề nghiệp và giá trị mang lại cho đội ngũ.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('109183b9-da6f-5c8e-b58f-6353900bb9c1', 'Bạn thường phối hợp với đội ngũ lập trình viên như thế nào để đảm bảo mục tiêu chung thay vì tạo ra rào cản giữa hai bên?', 'IT', 'DevOps / Quản trị hệ thống', 'MEDIUM', 'BEHAVIORAL', 'Chia sẻ tư duy văn hóa DevOps: xây dựng sự tin tưởng, thấu hiểu khó khăn của nhau, thiết lập quy trình tự động hóa (CI/CD) và kênh giao tiếp cởi mở để tránh tư duy ''us vs them''.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('14111296-f373-5ce4-85a0-e9d0cd9353c7', 'Hãy kể tên một số bản phân phối Linux phổ biến. Bản phân phối nào bạn yêu thích nhất và lý do vì sao?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Liệt kê các nhánh phân phối chính (Debian/Ubuntu, RHEL/CentOS, Arch...), sau đó nêu bản phân phối bạn thích nhất dựa trên trình quản lý gói, độ ổn định hoặc mục đích sử dụng.', '- Các bản phân phối Linux phổ biến: Debian, Ubuntu, CentOS/RHEL, Fedora, Arch Linux, openSUSE, Alpine Linux, Kali Linux.
- Nhánh phân phối chính: Nhánh Debian sử dụng APT/dpkg (Ubuntu, Mint); nhánh Red Hat sử dụng RPM/DNF (RHEL, CentOS, Fedora); nhánh Arch sử dụng Pacman rolling release.
- Bản phân phối yêu thích và lý do kỹ thuật (ví dụ: Ubuntu/Debian vì cộng đồng lớn và thư viện phần mềm phong phú; RHEL/CentOS/Rocky Linux vì tính ổn định cao trong môi trường enterprise; Arch Linux vì triết lý tối giản và kho AUR phong phú).
- Đánh giá theo mục đích sử dụng: server production thường ưu tiên tính ổn định lâu dài (LTS), trong khi workstation/desktop có thể ưu tiên phần mềm phiên bản mới.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('97d5404f-f495-5fd5-8860-1fc547357e3c', 'Bạn hãy phân biệt sự khác nhau giữa Unix, Linux, BSD và GNU.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Đi từ nguồn gốc lịch sử và bản chất kỹ thuật: Unix là hệ điều hành gốc có bản quyền; GNU cung cấp bộ công cụ người dùng; Linux là kernel; BSD là nhánh phát triển tự do từ Unix.', '- Unix: Hệ điều hành gốc phát triển từ Bell Labs (AT&T) vào thập niên 1970, là hệ điều hành thương mại, có bản quyền và tuân theo tiêu chuẩn POSIX.
- GNU: Dự án do Richard Stallman khởi xướng nhằm tạo ra hệ điều hành tự do hoàn chỉnh; cung cấp các công cụ cốt lõi (coreutils, GCC, Bash...) nhưng thiếu một kernel hoàn chỉnh phổ biến.
- Linux: Về bản chất là một kernel (nhân hệ điều hành) mã nguồn mở do Linus Torvalds tạo ra năm 1991; khi kết hợp với bộ công cụ GNU tạo thành hệ điều hành hoàn chỉnh GNU/Linux.
- BSD (Berkeley Software Distribution): Nhánh phái sinh mã nguồn mở trực tiếp từ Unix của Đại học UC Berkeley, là một hệ điều hành trọn gói hoàn chỉnh (kernel + userland) với giấy phép BSD mở hơn GPL (cho phép đóng mã nguồn thương mại).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('48875e18-586f-5647-93a6-345c0beeb93d', 'Bạn hiểu thế nào về CLI? Hãy chia sẻ về một số công cụ dòng lệnh (CLI tools) hoặc mẹo sử dụng CLI mà bạn yêu thích và hay dùng nhất trong công việc.', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa CLI ngắn gọn, sau đó nêu tên 2-3 công cụ quen thuộc (ví dụ tmux, vim, ssh) và giải thích lý do/tình huống sử dụng giúp tăng hiệu suất làm việc.', '- CLI (Command Line Interface) là giao diện dòng lệnh cho phép người dùng tương tác trực tiếp với hệ điều hành thông qua các câu lệnh văn bản thay vì giao diện đồ họa (GUI).
- Lợi thế của CLI là linh hoạt, tự động hóa tốt thông qua script, tiêu tốn ít tài nguyên và thường là cách duy nhất để quản trị máy chủ từ xa.
- Nêu một số công cụ yêu thích như tmux/screen (quản lý session terminal), vim/nano (chỉnh sửa file), grep/awk/sed (xử lý dữ liệu văn bản), htop (giám sát tài nguyên).
- Chia sẻ mẹo hữu ích như tìm kiếm lịch sử lệnh (Ctrl + R), điều hướng nhanh (pushd/popd), hoặc viết alias để rút ngắn các lệnh dài.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('23b3883b-9116-525d-826f-3dcc8d5c1233', 'Shell yêu thích của bạn trong Linux/Unix là gì và tại sao bạn lại chọn nó?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu tên shell bạn thường dùng (Bash, Zsh, Fish...), so sánh ngắn gọn về tính năng nổi bật hoặc hệ sinh thái, và đưa ra lý do phù hợp với công việc hàng ngày.', '- Bash là shell phổ biến nhất, mặc định trên hầu hết các bản phân phối Linux, rất phù hợp và ổn định cho việc viết shell script dùng chung.
- Zsh được nhiều kỹ sư ưa chuộng trên môi trường tương tác nhờ khả năng tùy biến cao, hỗ trợ plugin/theme phong phú (như Oh-My-Zsh), auto-completion thông minh và tính năng globbing mạnh mẽ.
- Fish cũng là một lựa chọn nổi bật với cấu hình sẵn tiện lợi (out-of-the-box autosuggestions và syntax highlighting), dù cú pháp script có khác biệt so với chuẩn POSIX.
- Lựa chọn thực tế thường kết hợp: dùng Zsh/Fish khi làm việc tương tác trên máy trạm và dùng Bash cho kịch bản tự động hóa trên server.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5a72e807-5557-5830-814c-95148c717832', 'Khi đăng nhập vào một máy chủ Linux để kiểm tra sức khỏe hệ thống hoặc khắc phục sự cố, bạn thường chạy những lệnh đầu tiên nào và mục đích là gì?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Liệt kê các lệnh kiểm tra tổng quan theo nhóm: tải hệ thống (CPU, RAM), dung lượng ổ đĩa, tiến trình, và kết nối mạng; giải thích ngắn gọn thông tin cần tìm từ mỗi lệnh.', '- `uptime` hoặc `w`: kiểm tra thời gian hoạt động của máy chủ, số lượng user đang đăng nhập và thông số load average.
- `top` hoặc `htop`: xem tổng quan mức chiếm dụng CPU, RAM và xác định các tiến trình đang tiêu tốn nhiều tài nguyên nhất.
- `free -m` (hoặc -h): kiểm tra chi tiết dung lượng RAM vật lý và Swap đang sử dụng/còn trống.
- `df -h`: rà soát dung lượng các phân vùng ổ đĩa để đảm bảo không bị đầy disk (đặc biệt là phân vùng root hoặc /var/log).
- `ss` hoặc `netstat`: kiểm tra các cổng đang lắng nghe (listening ports) và trạng thái các kết nối mạng bất thường.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('46a3a4fb-1c17-53e2-9d38-28ac6367e0c3', 'Việc chạy một tiến trình ở chế độ background trong Linux mang lại lợi ích gì? Bạn quản lý các tiến trình này như thế nào khi đang ở terminal?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Trình bày lợi ích về việc giải phóng terminal và xử lý tác vụ dài; sau đó giải thích cách đưa tác vụ ra background/foreground và cách theo dõi chúng.', '- Lợi ích: giải phóng terminal để tiếp tục thực hiện các tác vụ khác mà không phải chờ tiến trình dài hoàn thành, tránh bị gián đoạn công việc tương tác.
- Cách đưa ra background ngay khi khởi chạy: thêm ký tự `&` vào cuối câu lệnh (ví dụ: `wget url &`).
- Tạm dừng và chuyển tác vụ đang chạy ra background: dùng tổ hợp phím `Ctrl + Z` để dừng tạm thời (SIGTSTP), sau đó gõ lệnh `bg` để tiếp tục chạy ngầm.
- Quản lý các tiến trình ngầm trong phiên làm việc: dùng lệnh `jobs` để liệt kê, đưa lại foreground bằng lệnh `fg %[job_id]`.
- Để tiến trình không bị tắt khi ngắt phiên SSH: kết hợp sử dụng `nohup`, lệnh `disown`, hoặc chạy trong terminal multiplexer như `tmux`/`screen`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac428dc5-39dd-5e34-9978-2950fc5474b8', 'Trong Linux, bạn thường dùng những công cụ hoặc phương pháp nào để xác định và theo dõi thông tin của các tiến trình trước khi can thiệp vào chúng?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu các công cụ phổ biến từ cơ bản đến trực quan (ps, top/htop, pgrep), giải thích thông tin cốt lõi cần quan sát (PID, mức tài nguyên, user sở hữu) trước khi thao tác.', '- Dùng lệnh `ps` (ví dụ `ps aux` hoặc `ps -ef`) kết hợp với `grep` để tìm thông tin chi tiết của tiến trình cụ thể theo tên hoặc đường dẫn thực thi.
- Sử dụng `pgrep` để tìm nhanh Process ID (PID) hoặc `pidof` nếu biết chính xác tên chương trình.
- Sử dụng các công cụ tương tác thời gian thực như `top` hoặc `htop` để sắp xếp và phát hiện tiến trình đang chiếm dụng tài nguyên cao.
- Kiểm tra thư mục `/proc/[PID]` để tra cứu thông tin chuyên sâu của tiến trình (file descriptor, biến môi trường, trạng thái I/O).
- Dùng lệnh `pstree` để xem quan hệ cha - con giữa các tiến trình trước khi quyết định can thiệp (kill/restart).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4515bfc2-2301-57a6-bb1d-e249667a98de', 'Thường xuyên đăng nhập và chạy các lệnh dưới quyền người dùng root trên Linux là thói quen tốt hay xấu? Tại sao?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Khẳng định đây là thói quen xấu/bad practice; phân tích lý do dựa trên các góc độ: an toàn vận hành (tránh nhầm lẫn), bảo mật hệ thống và khả năng audit/truy vết.', '- Đây là một bad practice (thói quen không tốt) trong quản trị hệ thống Linux.
- Rủi ro thao tác nhầm: root có toàn quyền trên hệ điều hành, một câu lệnh sai cú pháp (như `rm -rf /`) có thể phá hủy toàn bộ hệ thống mà không có cảnh báo hay rào cản ngăn chặn.
- Vấn đề bảo mật (Principle of Least Privilege): nếu ứng dụng hoặc phiên làm việc của root bị xâm nhập, kẻ tấn công sẽ có quyền kiểm soát toàn diện ngay lập tức.
- Khả năng kiểm toán (Auditability): khi nhiều người cùng dùng tài khoản root chung, việc truy vết người chịu trách nhiệm cho từng câu lệnh qua log trở nên rất khó khăn.
- Best practice khuyến nghị: đăng nhập bằng tài khoản người dùng thông thường và chỉ nâng quyền có kiểm soát bằng `sudo` khi cần thiết để lưu lại lịch sử lệnh.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('676b5360-8fe8-534b-91e1-717c344340a2', 'Chỉ số load average trên Linux thể hiện điều gì? Ba con số hiển thị trong load average có ý nghĩa như thế nào khi đánh giá tải hệ thống?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Nêu bản chất của load average (số tiến trình đang chạy và chờ tài nguyên), ý nghĩa của 3 mốc thời gian (1, 5, 15 phút), và cách so sánh con số này với số lượng CPU core.', '- Load average trên Linux đo lường nhu cầu tài nguyên hệ thống, đại diện cho số lượng tiến trình trung bình đang ở trạng thái chạy (running) hoặc đang chờ CPU, cũng như chờ Disk I/O (uninterruptible sleep/D-state).
- Ba con số hiển thị lần lượt là giá trị trung bình có trọng số theo thời gian của 1 phút, 5 phút và 15 phút vừa qua.
- Để đánh giá mức tải, cần so sánh load average với tổng số CPU core khả dụng: nếu load average nhỏ hơn số core, hệ thống vẫn đáp ứng tốt; nếu lớn hơn số core, có tiến trình đang phải xếp hàng chờ đợi.
- Phân tích xu hướng: nếu mốc 1 phút lớn hơn 5 và 15 phút thì tải hệ thống đang tăng dần; ngược lại là tải đang hạ nhiệt.
- Lưu ý điểm đặc thù của Linux: load average cao có thể do nghẽn CPU hoặc do nghẽn I/O (Disk/NFS), cần kết hợp thêm iostat/vmstat để xác định nguyên nhân.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a4af6675-fd6a-5cc2-8122-3718f18e7d7b', 'Mật khẩu của người dùng được lưu trữ như thế nào và ở đâu trong hệ điều hành Linux?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'TECHNICAL', 'Làm rõ việc hệ thống không lưu mật khẩu dạng plain-text mà lưu hash; nêu tên các file liên quan (/etc/passwd, /etc/shadow) và lý do phân chia quyền đọc giữa hai file này.', '- Mật khẩu người dùng không được lưu trữ dưới dạng plain-text ở bất kỳ đâu trên hệ thống Linux; hệ thống chỉ lưu chuỗi băm (hash) kèm theo salt (thường dùng thuật toán SHA-512 hoặc yescrypt).
- Chuỗi hash của mật khẩu được lưu trữ an toàn trong file `/etc/shadow`, chỉ người dùng có quyền root mới có thể đọc file này (quyền 000 hoặc 640 tùy distro).
- Trong file `/etc/passwd`, trường mật khẩu thường được ký hiệu bằng ký tự `x` để chỉ định rằng hash thực tế được lưu tại `/etc/shadow`.
- Trước đây mật khẩu mã hóa từng được lưu trực tiếp trong `/etc/passwd`, nhưng do file này cần quyền đọc công khai cho mọi tiến trình để phân giải username/UID, nó đã được tách sang `/etc/shadow` để ngăn chặn các cuộc tấn công offline brute-force.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7bc63ff7-c65c-5641-aab3-76ca74ff4f3a', 'Nếu mọi lệnh gõ trên terminal đều trả về lỗi ''command not found'', bạn sẽ phán đoán nguyên nhân từ đâu và cách cô lập, khắc phục sự cố này như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'SITUATIONAL', 'Bắt đầu bằng nhận định nguyên nhân phổ biến (biến môi trường PATH bị ghi đè); trình bày các bước chẩn đoán bằng đường dẫn tuyệt đối, và cách khôi phục PATH trong file cấu hình shell.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2370c99c-568c-531b-9855-fd85b7498a3f', 'Khi bạn nhấn Ctrl + C nhưng một script hoặc tiến trình trên terminal vẫn không chịu dừng lại, bạn sẽ xử lý tình huống này như thế nào?', 'IT', 'DevOps / Quản trị hệ thống', 'EASY', 'SITUATIONAL', 'Giải thích nguyên nhân script bỏ qua SIGINT; sau đó nêu các bước xử lý leo thang từ gửi tín hiệu trực tiếp trên terminal (Ctrl + \) đến mở session khác để kiểm tra PID và kill tiến trình.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3eae03f-cfd2-5831-a78f-84933c068ccd', 'Bài toán phân loại (classification) trong học máy là gì? Bạn thường sử dụng những mô hình nào để giải quyết bài toán này?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Bắt đầu bằng việc định nghĩa bài toán phân loại (biến mục tiêu rời rạc, có nhãn), sau đó liệt kê các thuật toán phổ biến từ đơn giản đến nâng cao và nêu ví dụ ứng dụng thực tế.', '- Phân loại (Classification) là bài toán học có giám sát (supervised learning) trong đó biến mục tiêu là rời rạc (categorical/discrete).
- Mục tiêu của mô hình là gán các điểm dữ liệu đầu vào vào một hoặc nhiều nhãn lớp (classes).
- Phân loại thường chia làm: phân loại nhị phân (binary classification) và phân loại đa lớp (multiclass / multilabel classification).
- Các mô hình phổ biến bao gồm: Logistic Regression, Decision Tree, Random Forest, Support Vector Machine (SVM), Naive Bayes, k-Nearest Neighbors (KNN), Gradient Boosting (XGBoost, LightGBM) và mạng nơ-ron (Multi-Layer Perceptron).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c3c5eb05-d995-595f-bc55-85527130540a', 'Logistic Regression là gì và bạn sẽ sử dụng nó trong những trường hợp nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa và bản chất xác suất của Logistic Regression, giải thích bài toán phân loại nhị phân điển hình và lý do chọn thuật toán này (tính giải thích cao, nhanh, làm baseline).', '- Logistic Regression là thuật toán học máy có giám sát dùng để ước lượng xác suất một quan sát thuộc về một lớp cụ thể, thường dùng nhất cho bài toán phân loại nhị phân (binary classification).
- Mô hình sử dụng hàm Sigmoid (hoặc Logit link function) để ánh xạ tổ hợp tuyến tính của các biến đầu vào thành giá trị xác suất trong khoảng (0, 1).
- Ứng dụng khi: biến phụ thuộc có dạng nhị phân (như gian lận/hợp lệ, rời bỏ/ở lại, đậu/rớt).
- Thường được ưu tiên dùng làm mô hình baseline hoặc trong các hệ thống đòi hỏi khả năng giải thích (interpretability) cao, suy diễn trọng số rõ ràng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9a815135-f998-5333-a0af-d8653280aa98', 'Logistic Regression có phải là một mô hình tuyến tính (linear model) không? Tại sao?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Khẳng định có và giải thích dựa trên ranh giới quyết định (decision boundary) cũng như quan hệ tuyến tính giữa log-odds và các đặc trưng đầu vào.', '- Có, Logistic Regression được coi là một mô hình tuyến tính (thuộc họ Generalized Linear Models - GLM).
- Lý do là vì hàm log-odds (logit của xác suất: ln(p / (1 - p))) là một hàm tuyến tính theo các biến và tham số đầu vào: w^T * x + b.
- Ranh giới quyết định (decision boundary) phân tách giữa các lớp trong không gian đặc trưng là một siêu phẳng tuyến tính (linear hyperplane).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('064a2bee-87fc-52df-955c-65c5dd95eee2', 'Hàm Sigmoid là gì và nó có vai trò như thế nào trong mô hình Machine Learning?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Đưa ra định nghĩa, công thức toán học dạng lời nói, giải thích khoảng giá trị đầu ra và ứng dụng của nó trong phân loại cũng như mạng nơ-ron.', '- Hàm Sigmoid (hay Logistic function) là hàm toán học có dạng đường cong chữ S, công thức là f(x) = 1 / (1 + e^(-x)).
- Vai trò chính là ánh xạ bất kỳ giá trị thực nào từ (-vô cùng, +vô cùng) về khoảng (0, 1).
- Giá trị đầu ra trong khoảng (0, 1) cho phép diễn giải kết quả đầu ra như một xác suất dự đoán trong các mô hình phân loại nhị phân.
- Ngoài ra, hàm Sigmoid từng được sử dụng phổ biến làm hàm kích hoạt (activation function) trong các mạng nơ-ron truyền thống.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2b998e30-c8d2-5c4e-b7e3-95dcc490f3f6', 'Bạn thường đánh giá hiệu năng của một mô hình phân loại (classification) bằng những chỉ số và phương pháp nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Liệt kê các chỉ số cốt lõi từ cơ bản đến phức tạp, nhấn mạnh việc lựa chọn chỉ số phụ thuộc vào độ mất cân bằng dữ liệu và bài toán kinh doanh cụ thể.', '- Sử dụng Confusion Matrix để theo dõi trực tiếp các giá trị TP, TN, FP, FN.
- Các chỉ số cơ bản: Accuracy (Độ chính xác tổng thể), Precision (Độ chuẩn xác), Recall / Sensitivity (Độ nhạy), Specificity.
- Chỉ số tổng hợp cân bằng: F1-score (trung bình điều hòa giữa Precision và Recall) hoặc F-beta score.
- Các chỉ số dựa trên ngưỡng xác suất: ROC-AUC và PR-AUC (Precision-Recall AUC).
- Hàm mất mát định lượng xác suất: Log Loss (Cross-Entropy Loss).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('230f11c1-f7b3-5ce6-af22-99272ef46eb4', 'Chỉ số Accuracy trong bài toán phân loại là gì và được tính toán như thế nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa đơn giản, công thức tính dựa trên ma trận nhầm lẫn (Confusion Matrix) và ý nghĩa trực giác của nó.', '- Accuracy (độ chính xác tổng thể) là tỷ lệ giữa số lượng dự đoán đúng trên tổng số lượng mẫu dự đoán của mô hình.
- Công thức tính theo Confusion Matrix: Accuracy = (TP + TN) / (TP + TN + FP + FN).
- Đây là chỉ số trực quan và dễ hiểu nhất để đánh giá xem mô hình đoán đúng được bao nhiêu phần trăm tổng thể.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c7e1b863-eeba-5082-89ac-482d5762db5f', 'Accuracy có phải luôn là thước đo tốt để đánh giá mô hình phân loại không? Tại sao?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Khẳng định không, phân tích trường hợp dữ liệu mất cân bằng (imbalanced dataset) với ví dụ cụ thể (phát hiện ung thư, gian lận thẻ tín dụng) và đề xuất chỉ số thay thế.', '- Không, Accuracy không phải lúc nào cũng là thước đo tốt, đặc biệt là khi tập dữ liệu bị mất cân bằng nghiêm trọng (imbalanced data).
- Ví dụ: Trong bài toán phát hiện gian lận với 99% giao dịch hợp lệ và 1% gian lận, một mô hình dự đoán toàn bộ là hợp lệ sẽ đạt Accuracy 99% nhưng hoàn toàn vô dụng vì bỏ sót toàn bộ gian lận.
- Accuracy đối xử bình đẳng với mọi loại lỗi (FP và FN), trong khi thực tế chi phí thiệt hại của các loại lỗi thường rất khác nhau.
- Thay vào đó, với dữ liệu mất cân bằng, nên ưu tiên dùng Precision, Recall, F1-Score hoặc ROC-AUC / PR-AUC.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4ba85b1c-860c-5b3a-9d74-8188282b598f', 'Confusion Matrix (ma trận nhầm lẫn) là gì? Bạn hãy giải thích ý nghĩa của 4 ô trong ma trận này.', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa mục đích của Confusion Matrix, sau đó giải thích ngắn gọn, rõ ràng từng thuật ngữ: TP, TN, FP, FN kèm theo bối cảnh thực tế.', '- Confusion Matrix là một bảng thống kê so sánh kết quả dự đoán của mô hình với nhãn thực tế của dữ liệu trong bài toán phân loại.
- True Positive (TP): Thực tế là Dương tính (1) và mô hình dự đoán đúng là Dương tính (1).
- True Negative (TN): Thực tế là Âm tính (0) và mô hình dự đoán đúng là Âm tính (0).
- False Positive (FP - Lỗi loại I): Thực tế là Âm tính (0) nhưng mô hình dự đoán nhầm thành Dương tính (1).
- False Negative (FN - Lỗi loại II): Thực tế là Dương tính (1) nhưng mô hình dự đoán nhầm thành Âm tính (0).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dbe550fc-8c74-5b38-9177-b3f0644e9587', 'Bạn hãy phân biệt Precision, Recall và F1-score trong đánh giá mô hình phân loại.', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa và công thức của Precision, Recall, sau đó giải thích F1-score là trung bình điều hòa và khi nào cần tối ưu từng chỉ số.', '- Precision = TP / (TP + FP): Đo lường trong số các mẫu mô hình dự đoán là Dương tính, có bao nhiêu phần trăm thực sự là Dương tính (tránh báo động giả).
- Recall (Sensitivity) = TP / (TP + FN): Đo lường trong số tất cả các mẫu thực sự là Dương tính, mô hình bắt trúng được bao nhiêu phần trăm (tránh bỏ sót).
- F1-score: Là trung bình điều hòa (harmonic mean) giữa Precision và Recall, công thức F1 = 2 * (Precision * Recall) / (Precision + Recall).
- F1-score hữu ích khi cần một chỉ số cân bằng giữa Precision và Recall trên tập dữ liệu mất cân bằng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9eb36fde-613a-5aea-8935-d3371604b83b', 'Hiện tượng đánh đổi giữa Precision và Recall (Precision-Recall Trade-off) là gì và tại sao nó lại xảy ra?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích khái niệm trade-off thông qua việc dịch chuyển ngưỡng phân loại (classification threshold) và liên hệ với các bài toán thực tế cần ưu tiên một trong hai.', '- Precision-Recall Trade-off là hiện tượng khi cố gắng tăng chỉ số này thì chỉ số kia thường sẽ giảm, và ngược lại, khi giữ nguyên mô hình.
- Nguyên nhân xuất phát từ việc điều chỉnh ngưỡng xác suất quyết định (decision threshold): Khi tăng ngưỡng, mô hình khắt khe hơn chỉ dự đoán Positive khi rất chắc chắn, giúp tăng Precision nhưng dễ bỏ sót mẫu thực tế, làm giảm Recall.
- Ngược lại, khi hạ ngưỡng để bắt trúng nhiều mẫu Positive hơn (tăng Recall), mô hình sẽ kéo theo nhiều dự đoán sai (FP), làm giảm Precision.
- Tuỳ bài toán cụ thể mà kỹ sư chọn ngưỡng phù hợp (ví dụ: phát hiện ung thư cần Recall cao; lọc spam cần Precision cao để tránh đưa email quan trọng vào hòm spam).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1a178329-378b-5da6-b6fc-4c75d16eb2c2', 'Đường cong ROC (Receiver Operating Characteristic) là gì và khi nào nên sử dụng nó?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa hai trục của đường cong ROC (TPR vs FPR), giải thích cách nó biến thiên theo các ngưỡng phân loại khác nhau và các tình huống ứng dụng.', '- Đường cong ROC là đồ thị biểu diễn mối quan hệ giữa True Positive Rate (TPR / Recall) trên trục tung và False Positive Rate (FPR = 1 - Specificity) trên trục hoành.
- Đường cong này được vẽ bằng cách tính TPR và FPR tại mọi ngưỡng phân loại (threshold) có thể từ 0 đến 1.
- Ứng dụng: Dùng để đánh giá khả năng phân tách giữa hai lớp của mô hình phân loại nhị phân độc lập với một ngưỡng cụ thể nào.
- Hỗ trợ người làm mô hình trực quan hoá và chọn ngưỡng tối ưu phù hợp với bài toán nghiệp vụ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('68e8833a-0d28-5e3d-8816-33a667a97e61', 'Chỉ số AUC-ROC là gì và nó được dùng để làm gì trong việc đánh giá mô hình?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích AUC là diện tích dưới đường ROC, ý nghĩa xác suất của nó (xác suất mô hình xếp hạng mẫu Positive cao hơn Negative) và các mốc giá trị từ 0.5 đến 1.', '- AUC-ROC (Area Under the ROC Curve) là chỉ số đo lường toàn bộ diện tích nằm dưới đường cong ROC, có giá trị trong khoảng từ 0 đến 1.
- Về mặt ý nghĩa thống kê, AUC biểu thị xác suất mà mô hình xếp hạng điểm số (predicted probability) của một mẫu Positive ngẫu nhiên cao hơn một mẫu Negative ngẫu nhiên.
- Được dùng để so sánh hiệu năng tổng thể của nhiều mô hình phân loại nhị phân mà không bị ảnh hưởng bởi việc chọn ngưỡng cutoff.
- Giá trị AUC = 0.5 tương đương đoán ngẫu nhiên, AUC càng gần 1 chứng tỏ khả năng phân biệt giữa hai lớp của mô hình càng tốt.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6454c60c-c191-5d8f-968b-4c540d94740b', 'Làm thế nào để diễn giải ý nghĩa của điểm số AUC-ROC khi đánh giá mô hình?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích ý nghĩa của các mức giá trị AUC (1.0, 0.8-0.9, 0.5, < 0.5) và ý nghĩa xác suất xếp hạng thứ bậc giữa các mẫu dương và âm tính.', '- AUC = 1.0: Mô hình phân loại hoàn hảo, phân tách tuyệt đối giữa hai lớp mà không có bất kỳ nhầm lẫn nào.
- AUC trong khoảng 0.8 - 0.9: Mô hình có độ phân tách rất tốt, độ tin cậy cao trong thực tế.
- AUC = 0.5: Mô hình hoàn toàn không có khả năng phân biệt giữa lớp dương và âm tính, tương đương với việc tung đồng xu ngẫu nhiên.
- AUC < 0.5: Mô hình dự đoán ngược so với thực tế; nếu đảo ngược nhãn dự đoán thì mô hình sẽ có AUC > 0.5.
- Ý nghĩa thực tế: Nếu AUC = 0.85, nghĩa là có 85% khả năng mô hình sẽ cho một mẫu dương tính ngẫu nhiên số điểm xác suất cao hơn một mẫu âm tính ngẫu nhiên.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c0e1c68d-75d7-5d10-89aa-cf47885b47fa', 'Đường cong Precision-Recall (PR Curve) là gì và trong trường hợp nào thì nên ưu tiên sử dụng nó thay vì ROC Curve?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa hai trục của đồ thị PR (Precision vs Recall) và phân tích lý do tại sao PR Curve phản ánh trung thực hơn ROC Curve trên dữ liệu cực kỳ mất cân bằng.', '- Đường cong Precision-Recall (PR Curve) là đồ thị biểu diễn Precision (trục Y) theo Recall (trục X) tại các ngưỡng xác suất khác nhau.
- Điểm khác biệt chính: ROC sử dụng FPR (có chứa số lượng lớn True Negatives ở mẫu số), do đó khi số lượng mẫu Negative áp đảo hoàn toàn, FPR vẫn rất nhỏ dù FP cao, làm đường ROC trông quá lạc quan.
- PR curve tập trung trực tiếp vào lớp thiểu số (Positive class) thông qua TP, FP và FN, hoàn toàn không phụ thuộc vào TN.
- Nên ưu tiên dùng PR curve khi bài toán có dữ liệu cực kỳ mất cân bằng (như phát hiện gian lận tài chính, phát hiện bệnh hiếm, lọc tin rác).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2a12684b-925f-5c2b-99f7-1b06832c4de7', 'Chỉ số diện tích dưới đường cong Precision-Recall (PR AUC) là gì và tại sao nó lại hữu ích?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa PR AUC (hay Average Precision), giải thích cách nó tổng hợp hiệu năng trên toàn bộ ngưỡng và ứng dụng trong các bài toán dữ liệu mất cân bằng nặng.', '- PR AUC (hoặc Average Precision - AP) là chỉ số đo lường diện tích nằm dưới đường cong Precision-Recall, tổng hợp hiệu năng mô hình qua mọi ngưỡng phân loại thành một con số duy nhất.
- Giá trị PR AUC nằm trong khoảng từ baseline (tỷ lệ lớp Positive / tổng mẫu) đến 1.0; PR AUC càng cao thể hiện mô hình vừa có Precision cao vừa có Recall cao.
- Hữu ích vượt trội so với ROC AUC trong các bài toán dữ liệu mất cân bằng nặng (heavy class imbalance), vì nó phạt nặng các trường hợp dự đoán sai False Positive trên lớp thiểu số.
- Giúp so sánh nhanh và khách quan giữa các mô hình phân loại khi mục tiêu kinh doanh chỉ tập trung tối ưu hóa lớp dương tính hiếm gặp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1e452829-c563-5bb4-b130-45da155b3739', 'Trong những trường hợp nào thì chỉ số AU PR (PR-AUC) tốt hơn hoặc phù hợp hơn AU ROC (ROC-AUC)?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Bắt đầu bằng việc so sánh thành phần của hai metric (TPR/FPR so với Precision/Recall), sau đó giải thích tình huống dữ liệu mất cân bằng (imbalanced data) và sự ảnh hưởng của True Negative.', '- AU ROC phụ thuộc vào TPR và FPR, trong khi AU PR phụ thuộc vào Precision (PPV) và Recall (TPR).
- Khi tập dữ liệu mất cân bằng nghiêm trọng (tỷ lệ lớp positive rất nhỏ), số lượng True Negative quá lớn làm cho FPR luôn rất nhỏ, khiến ROC-AUC cho cảm giác mô hình tốt hơn thực tế (quá lạc quan).
- PR-AUC không phụ thuộc vào True Negative, tập trung chủ yếu vào lớp positive nên phản ánh hiệu quả mô hình chính xác hơn khi bài toán coi trọng việc tìm kiếm lớp positive (ví dụ: phát hiện gian lận, chẩn đoán bệnh hiếm).
- Khi dữ liệu cân bằng hoặc cả hai lớp quan trọng như nhau, AU ROC thường được ưu tiên sử dụng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26630bbf-7463-5895-9f06-21b2ce12afff', 'Khi xử lý các biến phân loại (categorical variables) trong mô hình học máy, bạn thường áp dụng những phương pháp nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu mục đích của việc tiền xử lý biến categorical, liệt kê các kỹ thuật mã hóa phổ biến cùng ưu/nhược điểm ngắn gọn của từng phương pháp.', '- Đa số mô hình học máy đòi hỏi đầu vào dạng số, do đó biến categorical cần được mã hóa (encoding).
- One-Hot Encoding: Tạo cột nhị phân cho từng category, phù hợp với biến nominal có số lượng giá trị phân biệt (cardinality) thấp.
- Ordinal Encoding / Label Encoding: Gán số nguyên cho từng category, phù hợp khi các giá trị có quan hệ thứ bậc (ordinal).
- Target Encoding: Thay thế category bằng giá trị trung bình của biến mục tiêu, hữu ích khi cardinality cao nhưng cần tránh rò rỉ dữ liệu (data leakage) và overfitting.
- Các kỹ thuật khác: Frequency/Count Encoding, Binary Encoding, hoặc Embedding đối với deep learning.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7f53d2ba-d12f-52d6-9432-1bec543d443b', 'Tại sao chúng ta lại cần sử dụng One-Hot Encoding thay vì chỉ dùng Label Encoding cho các biến phân loại?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích vấn đề phát sinh khi gán nhãn số tùy tiện cho các biến không có thứ bậc, ảnh hưởng của nó đến các mô hình tuyến tính/khoảng cách, và lưu ý khi nào không nên dùng One-Hot Encoding.', '- Label Encoding gán các số nguyên ngẫu nhiên (ví dụ 0, 1, 2) cho các danh mục, vô tình tạo ra quan hệ thứ tự và khoảng cách nhân tạo.
- Các thuật toán tuyến tính hoặc dựa trên khoảng cách (Linear/Logistic Regression, KNN, SVM) sẽ hiểu nhầm các giá trị lớn hơn có trọng số cao hơn hoặc khác biệt lớn hơn.
- One-Hot Encoding biến mỗi danh mục thành một vector nhị phân độc lập, đảm bảo khoảng cách giữa các cặp danh mục luôn bằng nhau trong không gian đặc trưng.
- Tuy nhiên, One-Hot Encoding có nhược điểm là làm tăng chiều dữ liệu (curse of dimensionality) và tạo ma trận thưa nếu biến có quá nhiều giá trị (high cardinality).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2a1480b5-0f05-5441-aab2-268bbba50133', 'Bạn hiểu thế nào về hiện tượng "lời nguyền số chiều" (curse of dimensionality) trong Machine Learning?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa ngắn gọn, giải thích điều gì xảy ra với dữ liệu và khoảng cách trong không gian nhiều chiều, và ảnh hưởng của nó tới mô hình học máy.', '- Lời nguyền số chiều chỉ các vấn đề phát sinh khi số lượng đặc trưng (chiều không gian) tăng lên đáng kể so với số lượng mẫu dữ liệu.
- Thể tích của không gian tăng theo hàm mũ, khiến dữ liệu trở nên cực kỳ thưa thớt (sparsity) và các điểm dữ liệu nằm rất xa nhau.
- Khoảng cách giữa các cặp điểm có xu hướng tiệm cận bằng nhau, làm giảm hiệu quả của các thuật toán dựa trên khoảng cách như KNN, K-Means.
- Tăng nguy cơ overfitting vì mô hình dễ học các quan hệ ngẫu nhiên do có quá nhiều tham số cần ước lượng so với kích thước mẫu.
- Cách khắc phục: Giảm chiều dữ liệu (PCA, t-SNE), chọn lọc đặc trưng (Feature Selection) hoặc áp dụng Regularization.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dc179445-2e63-51d9-89d3-968581150d6d', 'Điều gì sẽ xảy ra với mô hình hồi quy tuyến tính nếu trong dữ liệu có 3 cột x, y, z và z chính là tổng của x và y?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân tích bản chất đại số tuyến tính của bài toán hồi quy (ma trận X^T X) khi có sự phụ thuộc tuyến tính hoàn hảo (perfect multicollinearity).', '- Xảy ra hiện tượng đa cộng tuyến hoàn hảo (perfect multicollinearity) vì z là tổ hợp tuyến tính của x và y (z = x + y).
- Ma trận đặc trưng không có rank đầy đủ (không full rank), dẫn đến ma trận hiệp phương sai mẫu X^T * X bị suy biến (singular matrix).
- Không thể tính được ma trận nghịch đảo (X^T * X)^(-1) để tìm nghiệm giải tích (Closed-form OLS solution).
- Hệ số hồi quy trở nên không xác định (có vô số nghiệm thỏa mãn) hoặc có phương sai vô hạn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb1bdcc9-707d-5ad1-b1e5-8b687739c122', 'Trong mô hình hồi quy tuyến tính, nếu cột z là tổng của cột x và y cộng thêm một lượng nhiễu ngẫu nhiên nhỏ thì điều gì sẽ xảy ra?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích hiện tượng đa cộng tuyến cao (high multicollinearity), tác động của nó tới độ ổn định của trọng số và cách khắc phục.', '- Gây ra hiện tượng đa cộng tuyến mạnh (multicollinearity) vì z có tương quan tuyến tính rất cao với x và y.
- Ma trận X^T * X gần như suy biến (ill-conditioned matrix), khiến việc tính nghịch đảo rất nhạy cảm với các biến động nhỏ trong dữ liệu.
- Phương sai của các hệ số hồi quy tăng rất cao, dẫn đến ước lượng hệ số không ổn định và p-value không còn tin cậy.
- Khó diễn giải mức độ đóng góp độc lập của từng biến x, y, z vào biến mục tiêu.
- Cách xử lý: Loại bỏ bớt một đặc trưng tương quan, dùng kỹ thuật giảm chiều (PCA), hoặc áp dụng Ridge Regression (L2 regularization).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('47db2fbb-8237-5678-bf68-f58c7510105b', 'Regularization trong Machine Learning là gì và tại sao chúng ta lại cần sử dụng nó?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa kỹ thuật Regularization, giải thích cơ chế phạt độ phức tạp của mô hình và liên hệ với bài toán Bias-Variance Tradeoff hay Overfitting.', '- Regularization là kỹ thuật bổ sung thêm thành phần phạt (penalty term) vào hàm mất mát (loss function) để hạn chế độ phức tạp của mô hình.
- Giúp kiểm soát và thu nhỏ độ lớn của các trọng số (weights), ngăn mô hình học các mẫu nhiễu trong tập huấn luyện.
- Mục đích chính là giảm thiểu hiện tượng quá khớp (overfitting) và cải thiện khả năng tổng quát hóa (generalization) trên dữ liệu mới.
- Đóng vai trò cân bằng giữa bias và variance (chấp nhận tăng một chút bias để giảm mạnh variance).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('162e4b22-a13c-5586-b420-13b0f8f0cd44', 'Bạn biết những kỹ thuật Regularization phổ biến nào trong học máy?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các kỹ thuật chuẩn cho mô hình tuyến tính (L1, L2, Elastic Net), đồng thời có thể mở rộng sang cây quyết định hoặc mạng nơ-ron nếu phù hợp.', '- L1 Regularization (Lasso): Cộng thêm tổng giá trị tuyệt đối của các trọng số vào hàm loss, có khả năng triệt tiêu trọng số về 0 để chọn lọc đặc trưng.
- L2 Regularization (Ridge): Cộng thêm tổng bình phương của các trọng số vào hàm loss, thu nhỏ trọng số về gần 0 để xử lý đa cộng tuyến.
- Elastic Net: Kết hợp cả phạt L1 và L2 nhằm tận dụng ưu điểm của cả hai.
- Trong Neural Networks: Kỹ thuật Dropout, Early Stopping, Weight Decay.
- Trong Tree-based models: Giới hạn độ sâu (max_depth), số mẫu tối thiểu ở lá (min_samples_leaf), hoặc cắt tỉa cây (pruning).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f97c3c6d-c779-5441-a3e5-93bdea1175bc', 'Làm thế nào để bạn chọn được tham số Regularization (chẳng hạn như alpha hay lambda) phù hợp nhất cho mô hình?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày về quy trình kiểm định chéo (Cross-Validation) kết hợp các phương pháp tìm kiếm siêu tham số như Grid Search hoặc Random Search.', '- Sử dụng kỹ thuật kiểm định chéo (K-fold Cross-Validation) trên tập huấn luyện để đánh giá hiệu quả mà không làm rò rỉ dữ liệu tập test.
- Áp dụng các chiến lược tìm kiếm siêu tham số như Grid Search (thử trên một lưới giá trị định trước, thường là thang logarit như 0.001, 0.01, 0.1, 1, 10...) hoặc Random Search.
- Có thể dùng Bayesian Optimization để tìm kiếm nhanh và tối ưu hơn khi không gian tham số lớn.
- Chọn giá trị tham số tối thiểu hóa sai số kiểm định trung bình (hoặc tối ưu hóa metric mục tiêu), đồng thời đảm bảo độ phức tạp của mô hình không quá cao.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2d0c3f8f-e0cc-527f-804d-83f2e1d26077', 'L2 regularization có tác động như thế nào đến các trọng số trong mô hình tuyến tính?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích cách L2 phạt các trọng số lớn thông qua hàm bình phương, dẫn đến việc co các trọng số về gần 0 nhưng không triệt tiêu hẳn.', '- Do phạt dựa trên bình phương của trọng số (w^2), L2 phạt rất nặng các trọng số có giá trị tuyệt đối lớn.
- Tác động ép (shrink) các trọng số về gần 0 nhưng hiếm khi triệt tiêu hoàn toàn về đúng 0 (không tạo ra ma trận thưa như L1).
- Phân bổ ảnh hưởng tương đối đều giữa các đặc trưng có độ tương quan cao thay vì chỉ giữ lại một biến ngẫu nhiên.
- Giúp mô hình giảm phương sai (variance), ổn định hơn trước các biến động nhiễu của dữ liệu huấn luyện.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9fe803bb-9818-5bdc-8cef-66ad45167bf5', 'Bạn hãy phân biệt sự khác nhau giữa L1 Regularization (Lasso) và L2 Regularization (Ridge)?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'So sánh về thành phần phạt trong hàm mất mát, tính năng chọn lọc đặc trưng (sparsity), nghiệm giải tích và cách xử lý đa cộng tuyến.', '- Thành phần phạt: L1 phạt theo tổng giá trị tuyệt đối (|w|), còn L2 phạt theo tổng bình phương (w^2).
- Tính thưa (Sparsity) & Chọn đặc trưng: L1 có thể ép hệ số về đúng 0 nên đóng vai trò như Feature Selection; L2 chỉ ép hệ số về gần 0 chứ không loại bỏ đặc trưng.
- Nghiệm toán học: L2 có nghiệm giải tích dạng ma trận đóng (closed-form solution), còn L1 không có nghiệm đóng và phải tối ưu bằng gradient suy rộng hoặc coordinate descent.
- Đa cộng tuyến: Khi các biến tương quan mạnh, L1 thường chọn ngẫu nhiên một biến và bỏ qua các biến còn lại; L2 giữ lại tất cả nhưng thu nhỏ đồng đều các hệ số.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0f9f6f71-5f28-5f74-b6aa-816204428824', 'Liệu chúng ta có thể kết hợp cả hai kỹ thuật L1 và L2 Regularization trong cùng một mô hình tuyến tính không, và khi nào nên làm vậy?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Khẳng định có (Elastic Net), nêu cấu trúc hàm loss kết hợp và giải thích ưu điểm khi gặp trường hợp số lượng feature lớn hơn số mẫu hoặc có nhóm feature tương quan cao.', '- Hoàn toàn có thể, phương pháp kết hợp cả L1 và L2 được gọi là Elastic Net.
- Hàm loss của Elastic Net bổ sung cả hai số hạng: phạt L1 (tạo sparsity) và phạt L2 (kiểm soát đa cộng tuyến), điều khiển bằng hai siêu tham số (alpha và l1_ratio).
- Rất hữu ích khi số lượng đặc trưng p lớn hơn nhiều so với số lượng mẫu n (p >> n).
- Giải quyết hạn chế của Lasso: Khi có một nhóm biến tương quan cao, Lasso có xu hướng chọn bừa một biến, trong khi Elastic Net giúp giữ lại cả nhóm đặc trưng tương quan đó.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8a7e7a4d-f3c9-519d-a57f-72cc4538d454', 'Bạn hãy giải thích thuật toán Random Forest là gì và nguyên lý hoạt động cơ bản của nó?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa Random Forest, bản chất là ensemble method (bagging) kết hợp nhiều Decision Tree, và cách nó tổng hợp kết quả (voting hoặc averaging).', '- Random Forest là một thuật toán học máy có giám sát (supervised learning) thuộc nhóm ensemble learning, kết hợp nhiều Decision Tree lại với nhau.
- Hoạt động dựa trên kỹ thuật Bagging (Bootstrap Aggregation): tạo các mẫu dữ liệu con ngẫu nhiên có lặp lại để huấn luyện từng cây riêng lẻ.
- Kết hợp ngẫu nhiên hoá đặc trưng (feature bagging): tại mỗi điểm chia (split), chỉ một tập con các features được chọn ngẫu nhiên để đánh giá điểm chia tốt nhất.
- Kết quả dự đoán cuối cùng được tổng hợp bằng biểu quyết đa số (majority voting) cho bài toán classification hoặc lấy trung bình cộng (averaging) cho regression.
- Giúp giảm thiểu đáng kể hiện tượng overfitting và giảm variance so với một cây quyết định đơn lẻ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d1c7c319-40fc-5c3d-bb12-6fb3aee43a7d', 'Tại sao chúng ta lại cần yếu tố ngẫu nhiên (randomization) trong thuật toán Random Forest?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu hai khía cạnh ngẫu nhiên chính trong Random Forest (lấy mẫu dữ liệu và lấy mẫu thuộc tính) rồi phân tích tác động của chúng đến variance và tương quan giữa các cây.', '- Random Forest áp dụng ngẫu nhiên hoá ở hai cấp độ: Bootstrap sampling (lấy mẫu ngẫu nhiên có hoàn lại các bản ghi dữ liệu) và Feature sampling (chọn ngẫu nhiên một tập con các thuộc tính tại mỗi node split).
- Bootstrap sampling giúp mỗi cây học trên một góc nhìn dữ liệu hơi khác nhau, từ đó khi tổng hợp lại sẽ làm giảm phương sai (variance) của mô hình.
- Feature sampling giúp giải tương quan (decorrelate) giữa các cây, ngăn chặn các đặc trưng quá mạnh thống trị mọi cây quyết định.
- Khi các cây không bị tương quan cao, việc lấy trung bình kết quả sẽ tạo ra một ensemble model ổn định, chống overfitting và có khả năng tổng quát hoá tốt hơn nhiều so với từng cây riêng lẻ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('64d2bc28-6847-5818-a109-385a38273267', 'Bạn hãy nêu các siêu tham số (hyperparameters) chính trong mô hình Random Forest và ý nghĩa của chúng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các tham số ở cấp độ ensemble (số lượng cây, sampling ratio) và ở cấp độ từng cây riêng lẻ (độ sâu tối đa, số mẫu tối thiểu ở node), giải thích tác dụng của chúng đối với overfitting và underfitting.', '- n_estimators: Số lượng cây trong rừng; số cây càng nhiều mô hình càng ổn định nhưng tốn chi phí tính toán hơn.
- max_depth: Chiều sâu tối đa của mỗi cây quyết định; kiểm soát độ phức tạp và tránh overfitting cho từng cây.
- min_samples_split và min_samples_leaf: Số lượng mẫu tối thiểu cần để phân chia một node và số mẫu tối thiểu ở node lá; giá trị lớn giúp làm mượt và giảm overfitting.
- max_features: Số lượng đặc trưng tối đa được xem xét ngẫu nhiên tại mỗi điểm split (ví dụ: sqrt(n) cho classification, n/3 cho regression).
- bootstrap / max_samples: Tuỳ chọn có lấy mẫu bootstrap hay không và tỷ lệ kích thước mẫu dùng để train mỗi cây.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2030c933-3fdb-59e2-9599-ef315483894f', 'Làm thế nào để xác định hoặc tinh chỉnh độ sâu (depth) của các cây trong Random Forest?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích ảnh hưởng của độ sâu cây đến bias-variance trade-off, sau đó nêu các kỹ thuật tinh chỉnh như cross-validation, OOB score hoặc các điều kiện dừng sớm.', '- Về mặt lý thuyết, Random Forest có thể để các cây phát triển sâu mà không bị overfit nghiêm trọng như một cây đơn lẻ do cơ chế averaging; tuy nhiên cây quá sâu vẫn có thể học nhiễu và làm tăng dung lượng bộ nhớ cũng như thời gian inference.
- Sử dụng kỹ thuật Hyperparameter Tuning như Grid Search, Random Search hoặc Bayesian Optimization kết hợp với K-Fold Cross-Validation để tìm max_depth tối ưu trên tập validation.
- Đánh giá Out-Of-Bag (OOB) score để kiểm tra hiệu năng theo các mức max_depth khác nhau mà không cần chia thêm tập validation riêng biệt.
- Kết hợp tinh chỉnh max_depth song song với các tham số điều hòa khác như min_samples_split hoặc min_samples_leaf để dừng sự phát triển của cây khi không còn mang lại sự cải thiện ý nghĩa.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('08880788-2f9b-5113-81f8-d5e8388ffa43', 'Làm thế nào để xác định số lượng cây (n_estimators) cần thiết khi xây dựng mô hình Random Forest?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân tích mối quan hệ giữa số lượng cây và độ chính xác/overfitting, sau đó trình bày phương pháp theo dõi đường cong lỗi (OOB error curve hoặc validation error) để chọn điểm bão hòa.', '- Việc tăng số lượng cây (n_estimators) trong Random Forest về nguyên tắc không gây overfitting mà giúp phương sai (variance) giảm dần và ổn định hơn.
- Tuy nhiên, sau một ngưỡng nhất định, hiệu năng mô hình sẽ bão hòa trong khi chi phí tính toán và thời gian inference tiếp tục tăng tuyến tính.
- Cách xác định: Vẽ đường cong lỗi (error curve) theo số lượng cây bằng cách sử dụng Out-of-Bag (OOB) error hoặc validation error.
- Chọn số cây tại điểm mà đường cong lỗi bắt đầu đi ngang (bão hòa), cân đối giữa hiệu quả mô hình và chi phí phần cứng/thời gian chạy.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bcc2c205-2d78-5011-ab39-a8c5097a4451', 'Việc huấn luyện mô hình Random Forest có dễ song song hóa không, và cơ chế thực hiện như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Khẳng định tính chất embarrassingly parallel của Random Forest và giải thích tại sao các cây có thể được huấn luyện độc lập hoàn toàn với nhau trên nhiều CPU/GPU cores.', '- Việc song song hóa Random Forest rất dễ dàng (thuộc dạng embarrassingly parallel) vì mỗi cây quyết định được xây dựng hoàn toàn độc lập với các cây khác, không phụ thuộc vào kết quả của cây trước.
- Cơ chế: Phân chia tập n_estimators cho các CPU core hoặc node máy tính khác nhau, mỗi core tự thực hiện bootstrap sampling và huấn luyện một số cây độc lập.
- Sau khi tất cả các cây được huấn luyện xong, chỉ cần gộp (combine) các cây lại vào một ensemble chung.
- Trong thực tế (ví dụ thư viện Scikit-learn), có thể thiết lập tham số n_jobs=-1 để tận dụng toàn bộ số nhân CPU khả dụng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61837749-2f6f-588e-beaf-57e025d956d0', 'Những vấn đề hoặc hạn chế tiềm ẩn khi xây dựng một mô hình Random Forest có quá nhiều cây và các cây quá sâu là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu các khía cạnh về tài nguyên tính toán (thời gian train/inference, bộ nhớ), khả năng giải thích (interpretability), và nguy cơ overfit nhẹ nếu dữ liệu quá nhiều nhiễu.', '- Tốn bộ nhớ RAM và dung lượng lưu trữ: Mô hình chứa hàng trăm hoặc hàng nghìn cây sâu có kích thước rất lớn khi lưu trên đĩa hoặc nạp vào memory.
- Thời gian dự đoán (inference latency) chậm: Khi dự đoán mẫu mới, dữ liệu phải duyệt qua tất cả các cây sâu, không phù hợp cho các hệ thống real-time đòi hỏi độ trễ thấp.
- Tốn thời gian huấn luyện và tinh chỉnh: Quá trình hyperparameter tuning tốn kém rất nhiều tài nguyên tính toán.
- Giảm tính diễn giải (interpretability): Càng nhiều cây lớn thì việc theo dõi đường đi quyết định và giải thích dự đoán càng trở nên phức tạp.
- Nguy cơ học nhiễu: Dù Random Forest chống overfit tốt, việc các cây quá sâu vẫn có thể khiến từng cây ghi nhớ các mẫu nhiễu cục bộ và làm giảm khả năng tổng quát hóa nếu dữ liệu chứa nhiều outlier.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('635e9337-504e-51e1-9207-e817bdb25232', 'Nếu thay vì tìm ngưỡng phân chia tối ưu nhất (best split), chúng ta chỉ lấy ngẫu nhiên một vài ngưỡng phân chia rồi chọn ngưỡng tốt nhất trong số đó thì mô hình có hoạt động hiệu quả không? Ý tưởng này liên quan đến thuật toán nào?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Khẳng định ý tưởng này hoàn toàn hoạt động và chính là nguyên lý của Extremely Randomized Trees (Extra-Trees); so sánh ưu nhược điểm về tốc độ và variance so với Random Forest truyền thống.', '- Ý tưởng này hoàn toàn khả thi và hiệu quả; đây chính là nguyên lý hoạt động cốt lõi của thuật toán Extremely Randomized Trees (Extra-Trees).
- Khác biệt với Random Forest chuẩn: Thay vì quét qua tất cả các ngưỡng phân chia (split thresholds) khả dĩ để tìm điểm cắt tối ưu cho mỗi feature, Extra-Trees chọn ngẫu nhiên các ngưỡng cắt và chọn ra ngưỡng tốt nhất trong số ngẫu nhiên đó.
- Ưu điểm: Tốc độ huấn luyện nhanh hơn đáng kể vì bỏ qua bước sắp xếp và tính toán tối ưu tại từng ngưỡng.
- Về mặt thống kê: Tăng tính ngẫu nhiên làm phương sai (variance) của mô hình giảm thêm một chút, dù bias có thể tăng nhẹ nhưng thường đem lại hiệu năng tổng quát rất tốt.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fd8cc599-404d-55b6-a3fc-eec2d1d0f190', 'Hiện tượng các đặc trưng tương quan mạnh với nhau (correlated features) ảnh hưởng như thế nào đến mô hình Random Forest?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân tích tác động lên độ chính xác dự đoán (thường ít bị ảnh hưởng) so với tác động lên độ quan trọng của đặc trưng (feature importance) và khả năng diễn giải mô hình.', '- Về khả năng dự đoán: Random Forest khá kiên cường (robust) trước hiện tượng đa cộng tuyến, hiệu năng dự đoán chung thường không bị suy giảm đáng kể.
- Về Feature Importance (độ quan trọng của đặc trưng): Bị sai lệch nghiêm trọng. Hai đặc trưng tương quan mạnh sẽ chia sẻ mức độ quan trọng cho nhau, làm điểm quan trọng của từng đặc trưng bị phân tán và thấp hơn thực tế.
- Nguy cơ chọn ngẫu nhiên: Nhóm đặc trưng tương quan có xác suất được chọn tổng thể cao hơn các nhóm thông tin khác trong quá trình feature subsampling, gây mất cân bằng thông tin.
- Tính ổn định khi huấn luyện lại: Giữa các lần chạy với random seed khác nhau, thứ hạng quan trọng của các biến tương quan có thể hoán đổi ngẫu nhiên, gây khó khăn cho việc diễn giải (interpretability).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6e12dc1a-8a81-531d-9707-8492f984b547', 'Bạn hãy giải thích thuật toán Gradient Boosting Decision Trees (GBDT) là gì và nguyên lý hoạt động của nó?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày khái niệm boosting, cách các cây được xây dựng tuần tự để học phần dư sai số (residual/gradient của loss function) từ các cây trước.', '- Gradient Boosting Decision Trees (GBDT) là một thuật toán ensemble learning kết hợp nhiều mô hình yếu (thường là các decision tree nông - stumps) theo chuỗi tuần tự (boosting).
- Nguyên lý cốt lõi: Mỗi cây mới được thêm vào nhằm mục đích sửa chữa sai số (residual) của tập hợp các cây đứng trước nó.
- Thuật toán tối ưu hóa bằng cách cho cây mới học theo hướng dốc ngược (negative gradient) của hàm mất mát (loss function) tương tự như Gradient Descent.
- Dự đoán cuối cùng là tổng có trọng số của tất cả các cây trong ensemble, nhân với một hệ số co (learning rate / shrinkage).
- Ưu điểm: Đạt độ chính xác rất cao trên dữ liệu bảng (tabular data), nhưng nhạy cảm hơn với nhiễu và dễ overfit hơn Random Forest nếu không tinh chỉnh tham số kỹ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fac4f01b-a09a-5eec-bf69-cf171284f757', 'Bạn hãy so sánh sự khác nhau cơ bản giữa Random Forest và Gradient Boosting?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'So sánh dựa trên các tiêu chí: phương pháp ensemble (bagging vs boosting), cách xây dựng cây (độc lập vs tuần tự), độ sâu cây (sâu vs nông), mục tiêu giảm lỗi (variance vs bias), và khả năng song song hóa.', '- Cơ chế Ensemble: Random Forest dùng kỹ thuật Bagging (kết hợp các cây độc lập); Gradient Boosting dùng kỹ thuật Boosting (xây dựng các cây tuần tự sửa lỗi cho cây trước).
- Cấu trúc cây: Random Forest thường dùng các cây phát triển đầy đủ (deep trees) có bias thấp và variance cao; Gradient Boosting thường dùng các cây nông (shallow trees/weak learners) có bias cao và variance thấp.
- Mục tiêu tối ưu: Random Forest tập trung làm giảm phương sai (variance); Gradient Boosting tập trung làm giảm độ chệch (bias).
- Khả năng song song hoá: Random Forest rất dễ song song hóa vì các cây độc lập; Gradient Boosting khó song song hóa ở cấp độ cây do tính tuần tự (chỉ song song hóa ở cấp độ node split).
- Nguy cơ Overfitting: Random Forest ít bị overfit hơn khi tăng số cây; Gradient Boosting dễ bị overfit nếu tăng số cây quá nhiều mà không kiểm soát learning rate.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ba78177a-00ef-5039-98e4-dc735b09cd3c', 'Có thể song song hóa quá trình huấn luyện của mô hình Gradient Boosting không? Nếu có thì thực hiện như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Chỉ ra rằng không thể song song ở cấp độ cây vì tính tuần tự, nhưng có thể song song ở cấp độ tìm điểm chia (feature split) hoặc cấp độ dữ liệu (histogram construction, GPU).', '- Không thể song song hóa ở cấp độ cây (tree-level) như Random Forest vì bản chất Gradient Boosting là tuần tự: cây sau cần tính gradient từ sai số của cây trước.
- Tuy nhiên, có thể song song hóa ở cấp độ bên trong mỗi cây (intra-tree level):
  + Song song hóa tính toán điểm chia tối ưu (feature-level parallelism): quét và tính gradient gain cho các features khác nhau trên các core khác nhau.
  + Song song hóa xây dựng histogram (data-level parallelism): chia dữ liệu thành các batch để tính histogram cục bộ rồi gộp lại (như trong LightGBM, XGBoost).
- Tận dụng phần cứng GPU (ví dụ XGBoost `tree_method=''gpu_hist''`) để tính toán song song hàng triệu phép tính ma trận và tìm split nhanh chóng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('97b8de0e-d5f9-5b45-a9e6-55efad3b1467', 'Có những phương pháp hoặc độ đo nào để đánh giá độ quan trọng của đặc trưng (feature importance) trong mô hình Gradient Boosting?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày các phương pháp built-in dựa trên cây (Gain, Weight/Frequency, Coverage) và các phương pháp nâng cao mang tính tổng quát như Permutation Importance hoặc SHAP values.', '- Độ đo dựa trên cấu trúc cây (Tree-based / Impurity-based):
  + Weight (hoặc Frequency): Số lần đặc trưng được chọn để chia node trong tất cả các cây.
  + Gain: Tổng mức giảm hàm mất mát hoặc độ giảm impurity (Gini/MSE) do đặc trưng đó đem lại tại các điểm chia.
  + Coverage: Số lượng quan sát trung bình đi qua các node chia bởi đặc trưng đó.
- Permutation Feature Importance: Xáo trộn ngẫu nhiên giá trị của một đặc trưng trên tập validation và đo lường sự sụt giảm độ chính xác của mô hình.
- SHAP (SHapley Additive exPlanations): Phương pháp dựa trên lý thuyết trò chơi hợp tác, tính toán đóng góp biên của từng đặc trưng cho từng mẫu cụ thể, đảm bảo tính nhất quán và công bằng nhất hiện nay.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6934538d-b956-5e1b-9c66-ff5919c5247d', 'Trong mô hình Gradient Boosting, có sự khác biệt hoặc thiên kiến (bias) nào đối với biến liên tục so với biến rời rạc khi đánh giá feature importance không?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Phân tích hiện tượng biến liên tục hoặc biến phân loại có cardinality cao (nhiều giá trị riêng biệt) có xu hướng bị thiên vị (overestimated) trong các độ đo impurity-based gain/frequency, và giải pháp khắc phục.', '- Các độ đo Feature Importance truyền thống (dựa trên Gain hoặc Frequency) có xu hướng thiên vị (bias) nặng đối với các biến liên tục và biến phân loại có lực lượng lớn (high cardinality).
- Lý do: Biến liên tục hoặc biến có nhiều giá trị duy nhất cung cấp nhiều ngưỡng chia (split points) tiềm năng hơn, làm tăng xác suất tìm được điểm chia giảm impurity tình cờ trên tập train.
- Ngược lại, biến rời rạc với số danh mục ít (low cardinality, ví dụ binary variable) chỉ có rất ít lựa chọn điểm chia, do đó dễ bị đánh giá thấp tầm quan trọng.
- Giải pháp: Sử dụng Permutation Feature Importance trên tập validation độc lập hoặc sử dụng TreeSHAP để loại bỏ thiên kiến này và đánh giá chính xác giá trị thực tế của đặc trưng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('80d537fb-5401-5f64-90bf-0614e4871988', 'Bạn hãy nêu các siêu tham số (hyperparameters) quan trọng nhất trong mô hình Gradient Boosting và cách tinh chỉnh chúng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân loại các tham số thành 3 nhóm: tham số boosting (learning rate, n_estimators), tham số điều khiển cây (max_depth, min_child_weight), và tham số điều hòa/ngẫu nhiên (subsample, colsample_bytree, regularization).', '- learning_rate (shrinkage): Tỷ lệ học kiểm soát mức độ đóng góp của mỗi cây mới; thường đi kèm với việc điều chỉnh n_estimators (learning_rate nhỏ cần n_estimators lớn hơn).
- n_estimators: Tổng số cây được xây dựng; cần dùng Early Stopping để dừng khi lỗi trên tập validation không còn giảm.
- max_depth hoặc max_leaves: Chiều sâu tối đa hoặc số lá tối đa của mỗi cây; thường để giá trị nhỏ (3-8) để tránh overfitting.
- subsample: Tỷ lệ mẫu dữ liệu ngẫu nhiên được dùng để huấn luyện mỗi cây (Stochastic Gradient Boosting), giúp chống overfit.
- colsample_bytree (hoặc feature_fraction): Tỷ lệ đặc trưng ngẫu nhiên được chọn tại mỗi cây hoặc mỗi lần split.
- min_child_weight / min_samples_leaf: Ngưỡng tổng trọng số tối thiểu của các mẫu ở node con, giúp ngăn việc chia các node quá nhỏ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ea90e3fa-9bec-5a28-9c01-1331c1bf9a42', 'Bạn thường tiếp cận việc tinh chỉnh siêu tham số (hyperparameter tuning) cho XGBoost hoặc LightGBM như thế nào?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Trình bày quy trình theo từng bước: xác định baseline, nhóm tham số cần ưu tiên (learning rate, số cây, cấu trúc cây, regularization), và công cụ/chiến lược tìm kiếm.', '- Thiết lập learning rate tương đối cao cùng early stopping để tìm số cây (n_estimators) ban đầu một cách nhanh chóng.
- Tinh chỉnh các tham số cấu trúc cây để kiểm soát độ phức tạp (max_depth, min_child_weight đối với XGBoost; num_leaves, min_data_in_leaf đối với LightGBM).
- Tinh chỉnh các tham số lấy mẫu để chống overfitting và tăng tốc độ (subsample, colsample_bytree).
- Tinh chỉnh các tham số điều chuẩn (reg_alpha, reg_lambda).
- Giảm learning rate và tăng số cây kết hợp early stopping để đạt hiệu năng tối ưu.
- Sử dụng các framework Bayesian Optimization (như Optuna, Hyperopt) thay vì Grid Search thủ công để tiết kiệm thời gian và tài nguyên tính toán.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd352141-64aa-551d-89f3-2b84c8bf32eb', 'Bạn xác định số lượng cây (number of trees / n_estimators) tối ưu trong mô hình Gradient Boosting bằng cách nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Tập trung giải thích mối quan hệ giữa learning rate và số cây, vai trò của early stopping trên tập validation và việc dùng cross-validation.', '- Mối quan hệ đánh đổi: Số lượng cây có mối quan hệ nghịch đảo với learning rate; learning rate càng nhỏ thì thường cần số cây càng lớn để hội tụ và cho kết quả tổng quát hóa tốt hơn.
- Kỹ thuật Early Stopping: Phương pháp thực tế và hiệu quả nhất là đặt số cây lớn và dừng lại khi validation loss không còn cải thiện sau một số vòng (patience) nhất định.
- Cross-validation: Dùng K-fold CV kết hợp early stopping để tìm số vòng lặp tối ưu trung bình trên các fold nhằm tránh overfit vào một tập validation đơn lẻ.
- Giám sát Overfitting: Không nên tăng số cây vô hạn vì gradient boosting vẫn có thể bị overfit nếu số cây quá lớn so với dung lượng dữ liệu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f4741f54-511f-5e0c-bd49-404b3acc9839', 'Bạn biết những chiến lược tinh chỉnh siêu tham số (hyperparameter tuning) phổ biến nào trong Machine Learning?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các chiến lược từ cơ bản đến nâng cao (Grid Search, Random Search, Bayesian Optimization, Halving/Bandit), nêu ưu nhược điểm ngắn gọn của từng loại.', '- Grid Search: Thử vét cạn mọi tổ hợp tham số trong danh sách định trước; đảm bảo tìm ra tổ hợp tốt nhất trong lưới nhưng tốn kém tài nguyên tính toán khi không gian tham số lớn.
- Random Search: Chọn ngẫu nhiên các giá trị tham số trong khoảng xác định; thường tìm ra nghiệm tốt nhanh hơn nhiều so với Grid Search vì không bị lãng phí tính toán ở các tham số ít ảnh hưởng.
- Bayesian Optimization (như Optuna, Hyperopt): Dùng mô hình xác suất (surrogate model) để học từ các lần thử trước và hướng tìm kiếm vào các vùng triển vọng, cân bằng giữa exploration và exploitation.
- Early stopping / Successive Halving (như Hyperband): Bỏ qua sớm các cấu hình kém hiệu quả sau một số epoch/vòng huấn luyện nhỏ để dồn tài nguyên cho các cấu hình hứa hẹn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('45668843-75e4-5f5e-a924-25b201d6ef82', 'Sự khác biệt giữa Grid Search và Random Search trong tinh chỉnh siêu tham số là gì? Khi nào bạn nên chọn phương pháp này thay vì phương pháp kia?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'So sánh cơ chế hoạt động, độ phủ không gian tham số, chi phí tính toán và trường hợp sử dụng tối ưu của từng phương pháp.', '- Cơ chế: Grid Search duyệt qua toàn bộ các điểm giao nhau được định nghĩa sẵn trên lưới; Random Search chọn ngẫu nhiên các điểm trong toàn bộ phân phối giá trị của siêu tham số.
- Hiệu quả khám phá: Trong thực tế, chỉ một vài siêu tham số thực sự quan trọng; Random Search khảo sát được nhiều giá trị phân biệt hơn của các tham số quan trọng đó so với Grid Search với cùng số lần thử.
- Chi phí tính toán: Grid Search tăng theo cấp số nhân (curse of dimensionality) khi thêm tham số mới; Random Search kiểm soát được ngân sách tính toán bằng cách cố định số lần thử nghiệm.
- Khi nào dùng: Dùng Grid Search khi không gian tham số rất nhỏ hoặc muốn tinh chỉnh mịn trong một vùng hẹp; dùng Random Search khi không gian tìm kiếm rộng, nhiều tham số liên tục, hoặc tài nguyên tính toán bị giới hạn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2f13241e-9878-5b8c-9f3c-7a7af48085f3', 'Mạng nơ-ron (Neural Networks) thường giải quyết tốt những loại bài toán nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu bản chất toán học (xấp xỉ hàm phi tuyến phức tạp), sau đó đưa ra các bài toán ứng dụng thực tế trên dữ liệu phi cấu trúc và có cấu trúc.', '- Các bài toán phi tuyến tính phức tạp mà các thuật toán học máy tuyến tính truyền thống khó nắm bắt được mối quan hệ giữa các biến.
- Thị giác máy tính (Computer Vision): Phân loại ảnh, phát hiện vật thể, phân đoạn ảnh (dùng CNN).
- Xử lý ngôn ngữ tự nhiên (NLP) và âm thanh: Dịch máy, tóm tắt văn bản, nhận diện giọng nói, mô hình ngôn ngữ lớn (dùng Transformer, RNN).
- Dữ liệu dạng chuỗi và thời gian: Dự báo chuỗi thời gian, phát hiện bất thường trong giao dịch.
- Hệ thống gợi ý (Recommender Systems) và các bài toán học tăng cường (Reinforcement Learning).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5e6988df-4f36-5915-a372-3298c5c460cc', 'Bạn hãy giải thích nguyên lý hoạt động cơ bản của một mạng nơ-ron truyền thẳng kết nối đầy đủ (fully-connected feed-forward neural network)?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày cấu trúc lớp, luồng dữ liệu tiến (forward propagation) gồm tổ hợp tuyến tính và hàm kích hoạt, sau đó nhắc ngắn gọn đến quá trình học qua hàm mất mát và lan truyền ngược.', '- Cấu trúc gồm ba phần chính: lớp đầu vào (input layer), một hoặc nhiều lớp ẩn (hidden layers) và lớp đầu ra (output layer); mỗi nơ-ron kết nối với tất cả nơ-ron ở lớp liền trước.
- Lan truyền tiến (Forward pass): Tại mỗi nơ-ron, tính tổng có trọng số của các đầu vào cộng với bias: z = W*x + b.
- Áp dụng hàm kích hoạt phi tuyến: Giá trị z được truyền qua hàm kích hoạt phi tuyến a = g(z) để tạo đầu ra trước khi truyền tiếp tới lớp tiếp theo.
- Tính toán hàm mất mát (Loss function): So sánh kết quả tại output layer với nhãn thực tế để đo lường độ sai lệch.
- Lan truyền ngược (Backpropagation) và cập nhật: Tính đạo hàm của hàm mất mát theo từng trọng số (dựa vào quy tắc chuỗi) và dùng thuật toán tối ưu (như SGD, Adam) để cập nhật trọng số.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3a172cbf-b748-5ae5-817f-7d22049715b2', 'Tại sao chúng ta cần sử dụng hàm kích hoạt (activation function) trong mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Bắt đầu từ việc giải thích điều gì xảy ra nếu chỉ dùng các biến đổi tuyến tính, sau đó khẳng định tính phi tuyến mà hàm kích hoạt mang lại.', '- Đưa tính phi tuyến (non-linearity) vào mạng nơ-ron, cho phép mạng học và xấp xỉ các hàm phi tuyến phức tạp trong dữ liệu thực tế.
- Nếu không có hàm kích hoạt, việc xếp chồng bao nhiêu lớp nơ-ron cũng chỉ tương đương với một biến đổi tuyến tính đơn lẻ (tổ hợp của các hàm tuyến tính vẫn là hàm tuyến tính).
- Giới hạn miền giá trị đầu ra của nơ-ron hoặc chuẩn hóa đầu ra thành phân phối xác suất (ví dụ Softmax ở lớp output).
- Điều khiển việc nơ-ron có được kích hoạt hay không, hỗ trợ quá trình lan truyền gradient hiệu quả trong quá trình huấn luyện.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('359aab20-54b2-5b6b-b7bc-bee685105f86', 'Hàm kích hoạt Sigmoid có những hạn chế hoặc vấn đề gì khi huấn luyện mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Tập trung vào vấn đề triệt tiêu gradient (vanishing gradient), đặc tính không có tâm đối xứng quanh 0 (not zero-centered), và chi phí tính toán hàm mũ.', '- Triệt tiêu gradient (Vanishing Gradient): Khi giá trị đầu vào rất lớn hoặc rất nhỏ, đạo hàm của Sigmoid xấp xỉ 0; qua nhiều lớp truyền ngược, gradient bị thu nhỏ dần khiến các lớp đầu mạng không thể học được.
- Đầu ra không đối xứng quanh 0 (Not zero-centered): Đầu ra của Sigmoid luôn nằm trong khoảng (0, 1), làm cho gradient của trọng số ở lớp tiếp theo luôn cùng dấu (tất cả dương hoặc tất cả âm), gây hiện tượng zigzag khi tối ưu hóa.
- Chi phí tính toán cao: Phép tính hàm mũ e^(-x) tốn nhiều tài nguyên tính toán hơn so với các hàm đơn giản như ReLU.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac9c3bda-12d3-5361-afaa-af02ddff6b5b', 'ReLU là gì và tại sao nó thường được ưu tiên sử dụng hơn Sigmoid hoặc Tanh trong các mạng nơ-ron sâu?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa công thức của ReLU, sau đó giải thích 2-3 ưu thế chính liên quan đến gradient, tốc độ tính toán và tính thưa.', '- Định nghĩa: ReLU (Rectified Linear Unit) có công thức f(x) = max(0, x), giữ nguyên giá trị khi x > 0 và bằng 0 khi x <= 0.
- Giải quyết triệt tiêu gradient ở miền dương: Với x > 0, đạo hàm của ReLU luôn bằng 1, giúp gradient lan truyền ngược tốt qua nhiều lớp sâu mà không bị suy giảm như Sigmoid hay Tanh.
- Tốc độ tính toán vượt trội: ReLU chỉ cần phép so sánh ngưỡng (thresholding), nhanh hơn nhiều so với việc tính lũy thừa của Sigmoid hay Tanh.
- Tạo tính thưa (Sparsity): Khi x <= 0 nơ-ron bị tắt (đầu ra bằng 0), giúp mạng học được các biểu diễn thưa, tăng tính tổng quát hóa.
- Nhược điểm cần lưu ý: Vấn đề "Dying ReLU" khi nơ-ron rơi vào vùng âm và không bao giờ được kích hoạt lại (có thể khắc phục bằng Leaky ReLU, PReLU).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d182dae4-4671-5b70-b943-dece917364af', 'Trong mạng nơ-ron, có những kỹ thuật khởi tạo trọng số (weight initialization) phổ biến nào và tại sao việc này lại quan trọng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích rủi ro nếu khởi tạo sai (triệt tiêu hoặc bùng nổ gradient, phá vỡ tính đối xứng) rồi liệt kê các phương pháp chuẩn như Xavier/Glorot và He/Kaiming.', '- Tầm quan trọng: Khởi tạo trọng số phù hợp giúp duy trì phương sai của activations và gradients ổn định qua các lớp, tránh hiện tượng Vanishing hoặc Exploding Gradient và giúp mô hình hội tụ nhanh hơn.
- Xavier/Glorot Initialization: Lấy mẫu từ phân phối chuẩn hoặc đều với phương sai tỷ lệ với 1 / (fan_in + fan_out); tối ưu cho các hàm kích hoạt đối xứng quanh 0 như Tanh và Sigmoid.
- He/Kaiming Initialization: Phương sai tỷ lệ với 2 / fan_in; được thiết kế đặc thù cho các hàm kích hoạt dạng ReLU và các biến thể của nó.
- Random Normal/Uniform nhỏ: Khởi tạo ngẫu nhiên từ phân phối chuẩn với độ lệch chuẩn nhỏ để phá vỡ tính đối xứng (symmetry breaking).
- Tránh khởi tạo toàn bộ bằng 0: Khiến tất cả nơ-ron trong cùng một lớp học các đặc trưng giống hệt nhau.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6ceb7669-c59c-545f-a383-54509cdbbc22', 'Điều gì sẽ xảy ra nếu chúng ta khởi tạo tất cả trọng số của mạng nơ-ron bằng 0?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân tích theo hai bước: quá trình lan truyền tiến (forward pass) và quá trình lan truyền ngược (backward pass), nhấn mạnh hiện tượng đối xứng đối xứng (symmetry problem).', '- Vấn đề đối xứng (Symmetry Problem): Mọi nơ-ron trong cùng một lớp ẩn sẽ nhận đầu vào giống nhau, tính ra cùng một giá trị kích hoạt trong pha forward pass.
- Gradient đồng nhất: Trong pha backpropagation, gradient tính theo hàm mất mát đối với mọi trọng số trong cùng một lớp sẽ hoàn toàn giống nhau.
- Không học được các đặc trưng phân biệt: Các trọng số sẽ được cập nhật cùng một lượng như nhau, khiến mọi nơ-ron trong lớp luôn hành xử hệt nhau; mạng dù có nhiều nơ-ron ẩn cũng chỉ tương đương với một nơ-ron duy nhất.
- Lưu ý về bias: Khác với trọng số (weights), vector độ lệch (bias) có thể khởi tạo an toàn bằng 0 nếu weights đã được khởi tạo ngẫu nhiên.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8f6c16bf-d0ad-5f5a-811f-e196cd295ffc', 'Bạn biết những kỹ thuật điều chuẩn (regularization) phổ biến nào để tránh overfitting trong mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân nhóm các kỹ thuật: phạt trọng số (L1/L2), thay đổi kiến trúc/huấn luyện (Dropout, Batch Normalization), can thiệp dữ liệu (Data Augmentation) và chiến lược dừng (Early Stopping).', '- L1 và L2 Regularization (Weight Decay): Thêm mức phạt tổng độ lớn trọng số vào loss function; L1 tạo tính thưa (sparse weights), L2 ép các trọng số có giá trị nhỏ đều.
- Dropout: Ngắt ngẫu nhiên một tỷ lệ nơ-ron ở mỗi bước huấn luyện, buộc mạng không được phụ thuộc quá mức vào bất kỳ tập nơ-ron cụ thể nào.
- Early Stopping: Giám sát loss trên tập validation trong quá trình huấn luyện và dừng lại khi loss bắt đầu tăng trở lại.
- Data Augmentation: Tăng cường dữ liệu bằng các phép biến đổi (xoay, lật, cắt ảnh hoặc thêm nhiễu) để tăng tính đa dạng cho tập huấn luyện.
- Batch Normalization: Mặc dù chủ yếu giúp ổn định huấn luyện, hiệu ứng nhiễu mini-batch cũng đóng vai trò như một kỹ thuật điều chuẩn nhẹ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cdbd93b0-ed11-5ff6-b17c-5795cbb06955', 'Dropout là gì, hoạt động như thế nào và tại sao nó lại giúp hạn chế hiện tượng overfitting?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa và cơ chế hoạt động khi train vs khi test, sau đó giải thích trực giác tại sao phương pháp này chống overfitting hiệu quả.', '- Định nghĩa & Cơ chế khi train: Trong mỗi lượt truyền tiến (forward pass), mỗi nơ-ron ở lớp áp dụng Dropout có xác suất p bị tạm thời tắt (giá trị kích hoạt bằng 0 và không tham gia tính gradient).
- Cơ chế khi inference (test): Tất cả nơ-ron đều được kích hoạt đầy đủ, nhưng đầu ra của chúng được nhân với tỷ lệ (1 - p) để duy trì cùng kỳ vọng đầu ra (hoặc dùng Inverted Dropout scale ngay lúc train).
- Trực giác chống co-adaptation: Ngăn chặn các nơ-ron phụ thuộc lẫn nhau để sửa lỗi cho nhau, buộc mỗi nơ-ron phải học các đặc trưng mạnh mẽ và độc lập.
- Hiệu ứng Ensemble: Có thể xem Dropout như việc huấn luyện trung bình một tổ hợp (ensemble) gồm rất nhiều mạng con với trọng số chia sẻ lẫn nhau.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7678aaf7-c56f-591d-ac54-9a6c84a67e0b', 'Lan truyền ngược (Backpropagation) là gì, nguyên lý hoạt động của nó như thế nào và tại sao nó lại đóng vai trò cốt lõi trong huấn luyện mạng nơ-ron?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa mục đích của lan truyền ngược, giải thích nguyên lý toán học dựa trên quy tắc chuỗi (chain rule), và nêu vai trò của nó đối với các thuật toán tối ưu.', '- Định nghĩa: Backpropagation là thuật toán tính đạo hàm riêng (gradient) của hàm mất mát đối với từng trọng số và bias trong mạng nơ-ron một cách hiệu quả.
- Nguyên lý hoạt động: Sử dụng quy tắc chuỗi (Chain Rule) trong giải tích, bắt đầu tính toán gradient từ lớp đầu ra (output layer) rồi truyền ngược dần về các lớp trước đó.
- Tối ưu tính toán: Tái sử dụng các kết quả trung gian đã tính ở lớp sau (dynamic programming), giúp độ phức tạp tính toán chỉ là tuyến tính theo số lượng tham số thay vì tính đạo hàm độc lập từng tham số.
- Vai trò cốt lõi: Cung cấp thông tin hướng và độ dốc (gradient) chính xác để các thuật toán tối ưu như SGD, Adam cập nhật trọng số nhằm giảm thiểu hàm mất mát.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb051263-faeb-500b-a8f2-9fae01f55799', 'Bạn biết những thuật toán tối ưu hóa (optimizers) nào thường được sử dụng khi huấn luyện mạng nơ-ron? Hãy so sánh sơ lược ưu nhược điểm của chúng.', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày theo dòng phát triển: GD cơ bản (SGD, Mini-batch SGD) -> thuật toán có Momentum -> thuật toán điều chỉnh learning rate thích nghi (RMSprop, Adam, AdamW).', '- SGD và Mini-batch SGD: Đơn giản, tính toán nhẹ trên từng batch nhưng dễ bị mắc kẹt ở saddle points hoặc dao động mạnh quanh cực tiểu.
- Momentum & Nesterov Accelerated Gradient: Bổ sung quán tính từ các bước đi trước, giúp vượt qua các điểm dốc thoai thoải và giảm dao động ngang.
- Adagrad & RMSprop: Adagrad tự động giảm learning rate cho các đặc trưng xuất hiện thường xuyên; RMSprop khắc phục nhược điểm giảm learning rate quá nhanh của Adagrad bằng cách dùng trung bình trượt bình phương gradient.
- Adam (Adaptive Moment Estimation): Kết hợp ưu điểm của cả Momentum (moment bậc 1) và RMSprop (moment bậc 2), hội tụ nhanh và là lựa chọn mặc định rất phổ biến.
- AdamW: Phiên bản cải tiến của Adam tách rời weight decay khỏi cập nhật gradient, mang lại khả năng tổng quát hóa tốt hơn cho các mô hình hiện đại như Transformer.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac387eb0-d406-56b5-bf97-c07f60f753aa', 'Khi thực hiện phân loại văn bản với mô hình Bag of Words, bạn sẽ ưu tiên chọn Logistic Regression hay Gradient Boosting Trees? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'So sánh đặc điểm không gian vector của Bag of Words (chiều cao, rất thưa) với cơ chế hoạt động và chi phí tính toán của hai mô hình để đưa ra lựa chọn.', '- Bag of Words tạo ra ma trận đặc trưng có số chiều rất lớn và cực kỳ thưa (sparse, high-dimensional).
- Logistic Regression xử lý dữ liệu thưa và số chiều lớn rất hiệu quả, tốc độ huấn luyện nhanh và ít tốn tài nguyên tính toán.
- Gradient Boosting Trees (như XGBoost, LightGBM) gặp khó khăn và tính toán rất chậm khi số lượng đặc trưng quá lớn và thưa; chi phí tìm điểm phân chia (split) rất cao.
- Vì vậy, Logistic Regression (hoặc Linear SVM) thường được ưu tiên hơn hẳn GBDT trong bài toán Bag of Words.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dc6bf5e3-328b-551b-a286-ecbbf0f7b330', 'Word embedding là gì và tại sao chúng lại hữu ích trong xử lý ngôn ngữ tự nhiên? Bạn có thể giải thích nguyên lý của Word2Vec không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày khái niệm word embedding và so sánh với one-hot encoding, sau đó giải thích cách tiếp cận của Word2Vec gồm hai kiến trúc CBOW và Skip-gram.', '- Word embedding là phương pháp biểu diễn từ dưới dạng vector số thực dày đặc (dense vector) trong không gian nhiều chiều (ví dụ 100-300 chiều).
- Hữu ích vì bảo toàn được ngữ nghĩa và quan hệ giữa các từ (từ có ngữ nghĩa tương đồng sẽ nằm gần nhau trong không gian vector), giải quyết vấn đề số chiều lớn và thưa thớt của One-hot encoding.
- Word2Vec là mô hình học embedding từ tập ngữ liệu lớn dựa trên ngữ cảnh xung quanh từ.
- Word2Vec gồm 2 kiến trúc chính: CBOW (Continuous Bag of Words - đoán từ đích từ ngữ cảnh) và Skip-gram (đoán ngữ cảnh từ từ đích).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9b0e6594-96bc-532b-8e9f-26ab5430954d', 'Ngoài Word2Vec, bạn còn biết những phương pháp nào khác để tạo hoặc thu được word embeddings?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Liệt kê các họ phương pháp khác nhau từ thống kê ma trận (GloVe, FastText) đến mô hình ngôn ngữ ngữ cảnh hóa (contextual embeddings như BERT, RoBERTa).', '- GloVe (Global Vectors): kết hợp ma trận đồng xuất hiện toàn cục (co-occurrence matrix) với tối ưu hóa vector cục bộ.
- FastText: mở rộng Word2Vec bằng cách học embedding ở cấp độ subword (n-gram ký tự), xử lý tốt từ ngoài từ điển (OOV).
- TF-IDF kết hợp SVD/LSA: giảm chiều ma trận từ - tài liệu.
- Contextual embeddings từ Pretrained Language Models: ELMo, BERT, RoBERTa biểu diễn từ phụ thuộc vào ngữ cảnh cụ thể trong câu thay vì vector cố định.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('839dce12-430a-5ad7-b32f-dbd31f53258f', 'Khi cần kết hợp embedding của các từ trong một câu thành một vector duy nhất đại diện cho cả câu, bạn sẽ làm như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày từ các phương pháp thống kê đơn giản (pooling) đến phương pháp có trọng số và các kiến trúc mô hình học sâu.', '- Lấy trung bình cộng (Mean pooling) hoặc Max pooling trên tất cả các word vector trong câu.
- Lấy trung bình có trọng số (Weighted average), ví dụ trọng số TF-IDF để giảm ảnh hưởng của các từ phổ biến, hoặc thuật toán SIF (Smooth Inverse Frequency).
- Sử dụng mô hình chuỗi như RNN, LSTM, BiLSTM hoặc CNN 1D để nắm bắt thứ tự từ và lấy hidden state cuối cùng hoặc pooled vector.
- Dùng kiến trúc Transformer (như BERT, Sentence-BERT) để lấy CLS token embedding hoặc mean pooling trên các output token.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('40470e69-3f5f-546e-936e-5246c3522b02', 'Khi phân loại văn bản sử dụng các vector embedding (dense vectors), bạn sẽ ưu tiên dùng Gradient Boosting Trees hay Logistic Regression? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân tích đặc tính của vector embedding (số chiều thấp, dày đặc, phi tuyến) và so sánh khả năng nắm bắt tương tác phi tuyến của GBDT so với mô hình tuyến tính.', '- Khác với Bag of Words, vector embedding là vector dày đặc (dense) với số chiều vừa phải (thường từ 100 đến 1024 chiều).
- GBDT (XGBoost, LightGBM, CatBoost) thường có ưu thế hơn Logistic Regression vì có khả năng học các mối quan hệ phi tuyến và tương tác phức tạp giữa các chiều embedding.
- GBDT hoạt động tốt hơn khi dữ liệu có nhiễu hoặc mất cân bằng nhãn.
- Tuy nhiên, Logistic Regression vẫn là baseline tốt nhờ tốc độ cực nhanh, dễ giải thích; nếu cần độ chính xác cao hơn thì GBDT hoặc Fine-tuning Neural Net / MLP là lựa chọn tốt hơn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c5a022a-6257-54da-aaef-563d09f0f537', 'Bạn hãy trình bày quy trình và các kiến trúc mạng nơ-ron phổ biến có thể áp dụng cho bài toán phân loại văn bản?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Trình bày pipeline tổng quan (tiền xử lý, embedding, kiến trúc mạng, output layer) và điểm qua một số kiến trúc kinh điển như CNN, RNN/LSTM, Transformer.', '- Quy trình tổng quan: tiền xử lý văn bản (tokenize, clean), biến đổi thành vector thông qua Embedding layer, đưa qua các tầng nơ-ron học đặc trưng, và dùng Softmax/Sigmoid ở tầng output để dự đoán nhãn.
- Mô hình MLP/Feedforward: kết hợp Pooling embedding rồi qua các tầng Dense đơn giản.
- RNN/LSTM/GRU: xử lý tuần tự, nắm bắt phụ thuộc ngữ cảnh trước - sau trong câu.
- CNN cho văn bản: dùng kernel 1D trượt qua các n-gram từ để trích xuất đặc trưng cục bộ, kết hợp Max-pooling.
- Transformer/Pretrained LM: sử dụng Self-attention (như BERT, RoBERTa) để nắm bắt quan hệ toàn cục hai chiều, hiện là phương pháp chuẩn đạt hiệu năng cao nhất.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a4200881-43b9-5a01-a2c9-4b91fd502940', 'Mạng nơ-ron tích chập (CNN) hoạt động như thế nào trong bài toán phân loại văn bản?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Giải thích cách biểu diễn ma trận văn bản đầu vào, cơ chế trượt kernel 1D qua các n-gram từ, pooling và phân loại ở tầng cuối.', '- Đầu vào của câu được biểu diễn thành ma trận kích thước (độ dài câu × số chiều embedding).
- Các bộ lọc tích chập (Convolutional filters/kernels 1D) có chiều rộng bằng kích thước embedding và chiều cao là kích thước window (ví dụ 2, 3, 4 từ) trượt dọc theo câu để phát hiện các mẫu n-gram đặc trưng.
- Tầng Max-over-time pooling chọn ra giá trị lớn nhất từ mỗi feature map, giúp giữ lại đặc trưng quan trọng nhất bất kể vị trí của nó trong câu.
- Nối các đặc trưng từ các pooling layer lại thành một vector cố định và đưa vào tầng Fully Connected (Dense layer) với hàm kích hoạt Softmax/Sigmoid để phân loại.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('20ae2fab-00cb-5a90-a2c1-3db287a44c0a', 'Học không giám sát (Unsupervised Learning) là gì? Bạn hãy nêu một số bài toán và ứng dụng tiêu biểu của phương pháp này.', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa dựa trên tính chất của dữ liệu (không có nhãn), mục tiêu tìm cấu trúc ẩn và nêu các nhóm bài toán chính.', '- Học không giám sát là phương pháp machine learning trong đó mô hình được huấn luyện trên dữ liệu không có nhãn đầu ra (unlabeled data).
- Mục tiêu là tự khám phá các cấu trúc, quy luật, hoặc phân phối tiềm ẩn bên trong dữ liệu.
- Các bài toán phổ biến bao gồm: gom cụm (Clustering), giảm chiều dữ liệu (Dimensionality Reduction), phát hiện bất thường (Anomaly Detection), và khai phá luật kết hợp (Association Rule Mining).
- Ứng dụng thực tế: phân khúc khách hàng, gợi ý sản phẩm, nén dữ liệu, phát hiện gian lận.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('af7bc9b1-857b-53ad-b04d-d1135758bfb2', 'Thuật toán gom cụm (Clustering) là gì và chúng ta thường áp dụng nó trong những bài toán nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa clustering (tính tương đồng trong cụm và khác biệt giữa các cụm) và các tình huống ứng dụng thực tế.', '- Clustering là kỹ thuật học không giám sát nhằm nhóm các điểm dữ liệu thành các cụm sao cho các điểm trong cùng một cụm có độ tương đồng cao, và các điểm khác cụm có sự khác biệt rõ rệt.
- Cần dùng clustering khi dữ liệu chưa có nhãn và muốn khám phá cấu trúc nhóm tự nhiên của dữ liệu.
- Ứng dụng phổ biến: phân khúc người dùng/khách hàng dựa trên hành vi, phân loại tài liệu/chủ đề, phát hiện ngoại lai (các điểm không thuộc cụm nào), tiền xử lý làm đặc trưng cho các mô hình có giám sát.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4679385-9c49-5b81-8f54-18c2614b1c7b', 'Bạn hãy trình bày nguyên lý hoạt động của thuật toán gom cụm K-means?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày theo các bước tuần tự: khởi tạo tâm cụm, gán điểm dữ liệu, cập nhật lại tâm cụm và điều kiện dừng.', '- Bước 1: Khởi tạo k tâm cụm (centroids) ban đầu (ngẫu nhiên hoặc bằng thuật toán K-means++).
- Bước 2 (Assignment): Gán mỗi điểm dữ liệu vào cụm có tâm gần nó nhất (thường đo bằng khoảng cách Euclidean).
- Bước 3 (Update): Tính toán lại vị trí tâm cụm bằng cách lấy trung bình tọa độ của tất cả các điểm được gán vào cụm đó.
- Bước 4: Lặp lại bước 2 và 3 cho đến khi vị trí các tâm cụm hội tụ (thay đổi không đáng kể), việc gán nhãn không đổi, hoặc đạt số vòng lặp tối đa.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9ad89411-9aa3-51b4-98db-9bc11b589237', 'Làm thế nào để xác định số lượng cụm K phù hợp trong thuật toán K-means?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các phương pháp định lượng phổ biến và cách kết hợp với hiểu biết nghiệp vụ.', '- Dựa vào miền nghiệp vụ (Domain knowledge): yêu cầu thực tế bài toán xác định sẵn số cụm (ví dụ phân loại khách hàng thành 3 nhóm Bronze, Silver, Gold).
- Phương pháp Elbow (Elbow Method): vẽ biểu đồ tổng bình phương khoảng cách trong cụm (WCSS/Inertia) theo các giá trị k, chọn điểm uốn gập ''khuỷu tay'' nơi WCSS giảm chậm lại rõ rệt.
- Hệ số Silhouette (Silhouette Score): đo lường độ tương đồng của điểm với cụm của nó so với cụm gần nhất; chọn k có Silhouette Score trung bình cao nhất (dao động từ -1 đến 1).
- Phương pháp Gap Statistic: so sánh tổng biến thiên trong cụm với phân phối chuẩn ngẫu nhiên.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a05f454f-38e1-50db-92dc-1c41a860a90b', 'Ngoài K-means, bạn còn biết những thuật toán gom cụm (clustering) nào khác? Hãy nêu đặc điểm cơ bản của chúng.', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các nhóm thuật toán gom cụm khác nhau (dựa trên mật độ, phân cấp, phân phối...) kèm ưu/nhược điểm chính.', '- Hierarchical Clustering (Gom cụm phân cấp): gom cụm theo cây (Dendrogram), có thể là Agglomerative (tích tụ từ dưới lên) hoặc Divisive (phân tách từ trên xuống), không cần chỉ định trước số cụm k.
- DBSCAN (Density-Based): gom cụm dựa trên mật độ điểm lân cận, phát hiện được cụm có hình dạng bất kỳ và nhận diện được nhiễu/outliers.
- K-Medoids (PAM): tương tự K-means nhưng chọn điểm dữ liệu thực tế làm tâm, chống chịu nhiễu và ngoại lai tốt hơn K-means.
- Gaussian Mixture Models (GMM): gom cụm mềm (soft clustering) dựa trên phân phối xác suất Gaussian, mỗi điểm có xác suất thuộc về từng cụm.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('03cbe15b-d7d6-5dc0-8e39-82412dc076f5', 'Bạn hãy giải thích nguyên lý hoạt động của thuật toán DBSCAN?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu 2 tham số chính (eps, minPts), định nghĩa 3 loại điểm (core, border, noise) và cơ chế lan truyền để hình thành cụm.', '- DBSCAN hoạt động dựa trên 2 tham số chính: epsilon (bán kính vùng lân cận) và minPts (số điểm tối thiểu trong vùng bán kính epsilon).
- Phân loại các điểm dữ liệu thành 3 nhóm: Core point (có ít nhất minPts điểm lân cận trong bán kính eps), Border point (nằm trong vùng lân cận của Core point nhưng không đủ minPts), và Noise/Outlier (không thuộc hai nhóm trên).
- Quy trình tạo cụm: bắt đầu từ một Core point bất kỳ, gom tất cả các điểm có thể tiếp cận mật độ (density-reachable) vào cùng một cụm.
- Mở rộng cụm bằng cách duyệt các Core point liên thông cho đến khi không thể gom thêm, lặp lại cho các điểm chưa gán nhãn, các điểm còn lại xem là nhiễu (noise).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a3854dd5-09b5-554f-b156-8d1c0d814a11', 'Trong những trường hợp nào bạn sẽ chọn K-means và khi nào thì nên dùng DBSCAN?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'So sánh dựa trên hình dạng cụm, số chiều dữ liệu, sự hiện diện của nhiễu/ngoại lai và chi phí tính toán trên quy mô lớn.', '- Chọn K-means khi: tập dữ liệu lớn cần tốc độ tính toán nhanh, các cụm có xu hướng hình cầu (spherical) và kích thước/mật độ tương đương nhau, hoặc bài toán đã biết trước số cụm k.
- Chọn DBSCAN khi: các cụm có hình dạng phức tạp/phi tuyến (non-convex, hình dải uốn lượn), dữ liệu có nhiều nhiễu/outlier cần loại trừ, và không biết trước số lượng cụm.
- Nhược điểm cần lưu ý: DBSCAN xử lý kém khi dữ liệu có mật độ giữa các cụm biến thiên lớn hoặc dữ liệu có số chiều cao; trong khi K-means nhạy cảm với ngoại lai và khởi tạo tâm cụm ban đầu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8d6eac4f-ce7b-5fb1-8720-7f26f8ae3188', 'Lời nguyền số chiều (Curse of Dimensionality) là gì và tại sao chúng ta cần đặc biệt lưu tâm đến nó trong Machine Learning?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích hiện tượng không gian trở nên thưa thớt khi tăng chiều, hệ quả đối với các phép đo khoảng cách và cách khắc phục.', '- Lời nguyền số chiều là hiện tượng phát sinh khi số lượng đặc trưng (số chiều) tăng cao, khiến thể tích không gian dữ liệu tăng theo hàm mũ và dữ liệu trở nên cực kỳ thưa thớt (sparse).
- Khoảng cách giữa các điểm trong không gian nhiều chiều bị đồng hóa (khoảng cách giữa điểm gần nhất và xa nhất gần như bằng nhau), khiến các thuật toán dựa trên khoảng cách (KNN, K-means, SVM kernel RBF) mất tính hiệu quả.
- Số chiều lớn đòi hỏi lượng dữ liệu cấp số nhân để mô hình không bị overfitting, đồng thời làm tăng chi phí tính toán và bộ nhớ.
- Khắc phục bằng cách chọn lọc đặc trưng (Feature Selection) hoặc giảm chiều dữ liệu (PCA, t-SNE, UMAP, Autoencoders).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('894bf5ac-ec16-54f9-9eeb-13e9e97dcbf9', 'Bạn có thể kể tên và phân loại một số kỹ thuật giảm chiều dữ liệu (dimensionality reduction) phổ biến không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân loại các phương pháp thành tuyến tính (linear) và phi tuyến tính (non-linear) hoặc có giám sát (supervised) và không giám sát (unsupervised), sau đó nêu ví dụ và trường hợp ứng dụng thực tế.', '- Kỹ thuật tuyến tính: PCA (Principal Component Analysis), SVD (Singular Value Decomposition), LDA (Linear Discriminant Analysis - có giám sát).
- Kỹ thuật phi tuyến tính phục vụ trực quan hóa hoặc khám phá dữ liệu: t-SNE, UMAP, Kernel PCA.
- Kỹ thuật dựa trên Deep Learning: Autoencoders (mô hình nén biểu diễn qua bottleneck layer).
- Phân tích tín hiệu/chuỗi thời gian: Fourier transform, Wavelet transform.
- Ứng dụng chính: giảm hiện tượng curse of dimensionality, tối ưu chi phí tính toán mô hình, trực quan hóa dữ liệu nhiều chiều và khử nhiễu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('38b1f1e1-934b-53bf-9d0f-5cd7f83228db', 'SVD (Singular Value Decomposition) là gì và kỹ thuật này thường được ứng dụng như thế nào trong Machine Learning?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày định nghĩa toán học cơ bản (phân tích ma trận thành 3 ma trận con), mối liên hệ giữa SVD với PCA, và ứng dụng trong giảm chiều dữ liệu hoặc hệ thống gợi ý.', '- Định nghĩa: SVD là phương pháp phân tích ma trận X (kích thước m x n) thành tích của 3 ma trận: U (left singular vectors), Sigma (ma trận đường chéo chứa các singular values), và V^T (right singular vectors).
- Liên hệ với PCA: PCA thực chất có thể giải trực tiếp thông qua SVD trên ma trận dữ liệu đã chuẩn hóa (zero-centered) mà không cần tính ma trận hiệp phương sai trực tiếp, giúp tối ưu hiệu năng tính toán.
- Giảm chiều dữ liệu: Truncated SVD giữ lại k singular values lớn nhất để xấp xỉ ma trận ban đầu với số chiều thấp hơn mà vẫn bảo toàn phần lớn variance.
- Ứng dụng thực tế: Phân tích văn bản LSA/LSI (Latent Semantic Analysis), Collaborative Filtering trong Recommender Systems (ma trận User-Item), và nén ảnh/khử nhiễu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('47e7c519-5b9c-55bd-830a-f1fbba4430d4', 'Bài toán ranking (xếp hạng) là gì và bạn thường dùng những mô hình nào để giải quyết bài toán này?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa mục tiêu bài toán ranking, phân biệt 3 hướng tiếp cận Learning to Rank (Pointwise, Pairwise, Listwise) và nêu tên các thuật toán tiêu biểu.', '- Khái niệm: Ranking là bài toán sắp xếp danh sách các item (tài liệu, sản phẩm, bài viết) theo thứ tự mức độ liên quan hoặc độ ưu tiên giảm dần đối với một truy vấn (query) hoặc người dùng (user) cụ thể.
- Ba hướng tiếp cận chính trong Learning to Rank (LTR):
- Pointwise: Biến đổi thành bài toán hồi quy (regression) hoặc phân loại (classification) dự đoán điểm relevance của từng item độc lập (ví dụ: Logistic Regression, GBDT).
- Pairwise: Tối ưu hóa thứ tự tương đối giữa từng cặp item (ví dụ: RankNet, LambdaMART, RankSVM).
- Listwise: Tối ưu hóa trực tiếp trên toàn bộ danh sách kết quả dựa trên các metric xếp hạng như NDCG, MAP (ví dụ: LambdaMART, ListNet).
- Các mô hình phổ biến trong thực tế: XGBoost/LightGBM/CatBoost với objective ranking (LambdaMART), hoặc mô hình Deep Learning (Two-Tower models, Transformer-based rankers).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('33eeaa43-0c52-5578-a013-5cb30f7f7297', 'Trong Information Retrieval dạng văn bản, những mô hình baseline không giám sát (unsupervised baselines) nào thường được sử dụng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu tên các phương pháp từ đơn giản (lexical matching) đến embedding không giám sát, giải thích ngắn gọn nguyên lý của thuật toán tiêu chuẩn (BM25) và tại sao chúng là baseline quan trọng.', '- TF-IDF: Phương pháp tính trọng số từ dựa trên tần suất xuất hiện trong văn bản và độ hiếm trong toàn bộ kho tài liệu.
- BM25 (Okapi BM25): Baseline mạnh nhất và phổ biến nhất trong lexical search, cải tiến từ TF-IDF bằng cách thêm cơ chế bão hòa tần suất từ (term frequency saturation) và chuẩn hóa độ dài văn bản (document length normalization).
- Mô hình không gian Vector (Vector Space Model) sử dụng Cosine Similarity trên biểu diễn Bag-of-Words.
- Pretrained dense embeddings không cần fine-tune: Sử dụng trung bình cộng Word2Vec/GloVe hoặc pretrained Sentence-BERT/MiniLM tính cosine similarity để semantic search.
- Tầm quan trọng: Dễ triển khai, chi phí tính toán thấp, không cần nhãn và thường được dùng ở giai đoạn First-stage Retrieval (Candidate Generation).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('edacdbcc-19cf-5187-8cbe-7533a63e108b', 'Bạn đánh giá một thuật toán ranking như thế nào? Những offline metrics nào thường được sử dụng?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân chia các nhóm metrics theo loại nhãn (binary relevance vs graded relevance), nêu tên các chỉ số phổ biến (Precision@K, MAP, NDCG, MRR) và ý nghĩa của chúng.', '- Precision@K và Recall@K: Đánh giá tỷ lệ item liên quan trong top K kết quả (phù hợp cho binary relevance: liên quan hoặc không liên quan).
- MAP (Mean Average Precision): Trung bình của Average Precision trên nhiều queries, tính đến vị trí của các kết quả đúng trong danh sách.
- MRR (Mean Reciprocal Rank): Đánh giá vị trí xuất hiện của item liên quan đầu tiên (1/rank), thích hợp cho bài toán tìm kiếm định hướng (factoid search, navigation search).
- NDCG@K (Normalized Discounted Cumulative Gain): Metric chuẩn mực nhất khi có graded relevance (mức độ liên quan nhiều mức: 0, 1, 2, 3), phạt nặng nếu các item điểm cao bị xếp ở vị trí thấp.
- Diversity/Novelty metrics: Đánh giá độ đa dạng của danh sách gợi ý để tránh hiện tượng chỉ hiển thị các kết quả quá tương tự nhau.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('501ad722-898d-5782-98a5-a258e814eb7b', 'Precision@K và Recall@K trong bài toán ranking được định nghĩa như thế nào và có ý nghĩa gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa công thức của Precision@K và Recall@K, giải thích sự khác biệt giữa mẫu số của hai chỉ số và đưa ví dụ minh họa ngắn gọn.', '- Precision@K: Tỷ lệ giữa số lượng item liên quan nằm trong top K kết quả trên tổng số K kết quả được trả về (Precision@K = Relevant items in top K / K).
- Recall@K: Tỷ lệ giữa số lượng item liên quan nằm trong top K kết quả trên tổng số tất cả các item liên quan thực tế trong hệ thống đối với truy vấn đó (Recall@K = Relevant items in top K / Total relevant items).
- Ý nghĩa: Precision@K đo lường độ chính xác và trải nghiệm trực tiếp của người dùng ở màn hình hiển thị đầu tiên, trong khi Recall@K đo mức độ bao phủ và khả năng tìm sót item liên quan của mô hình.
- Đánh đổi (Trade-off): Tăng K thường làm Recall@K tăng nhưng có thể làm Precision@K giảm do kết quả xếp sau có xu hướng ít liên quan hơn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('330b0a87-f450-58d8-af84-5071b6f29d21', 'Mean Average Precision at K (MAP@K) là gì và chỉ số này được tính toán như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Bắt đầu từ Precision@i, giải thích cách tính Average Precision at K (AP@K) cho một query, sau đó lấy trung bình trên toàn bộ queries để ra MAP@K.', '- Khái niệm: MAP@K là chỉ số offline đánh giá chất lượng xếp hạng với nhãn nhị phân (relevant/non-relevant), có tính đến vị trí xếp hạng của các item liên quan trong top K.
- Cách tính AP@K cho một query: Tính Precision@i tại mỗi vị trí i (từ 1 đến K) có item liên quan, sau đó tính trung bình các giá trị Precision này chia cho tổng số item liên quan (hoặc min(K, tổng item liên quan)).
- Cách tính MAP@K: Lấy trung bình cộng AP@K của tất cả các query trong tập kiểm thử (MAP@K = (1 / |Q|) * sum(AP@K)).
- Điểm mạnh: Phạt nặng mô hình nếu đưa các kết quả liên quan xuống các vị trí sâu hơn trong top K, phản ánh tốt hành vi người dùng thường chú ý các vị trí đầu tiên.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('94cd2be8-5fd1-5692-a1bf-e154d0ce45a3', 'Machine Learning có thể được ứng dụng vào hệ thống tìm kiếm (Search) như thế nào theo kiến trúc nhiều tầng (multi-stage architecture)?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Mô tả pipeline tìm kiếm hiện đại từ tiền xử lý truy vấn, retrieval (thu hồi ứng viên), ranking (xếp hạng), đến re-ranking và cá nhân hóa.', '- Xử lý Query (Query Understanding): Nhận diện thực thể (NER), sửa lỗi chính tả (spell check), phân loại intent (intent classification) và mở rộng truy vấn (query expansion/rewriting).
- Giai đoạn Retrieval (Candidate Generation): Sử dụng mô hình tìm kiếm ngữ nghĩa Dense Retrieval (Two-Tower/Bi-Encoder) hoặc Hybrid Search (kết hợp BM25 và Vector Search) để lọc ra top hàng trăm/nghìn tài liệu ứng viên từ hàng triệu tài liệu.
- Giai đoạn Ranking (Scoring): Sử dụng các mô hình Learning to Rank phức tạp (GBDT như LightGBM hoặc Cross-Encoder) với hàng trăm đặc trưng (query-doc relevance, user profile, context) để chấm điểm chi tiết.
- Giai đoạn Re-ranking / Business Logic: Áp dụng mô hình đa dạng hóa kết quả (diversity), khử trùng lặp (deduplication), cá nhân hóa theo ngữ cảnh thời gian thực và áp dụng các luật kinh doanh (promotions, sponsored items).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34ff0490-8a45-5c27-af80-9255dce4216f', 'Làm thế nào để thu thập dữ liệu huấn luyện (training data) cho các thuật toán ranking?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày hai nguồn dữ liệu chính: nhãn thủ công (explicit/human judgment) và nhãn ngầm định từ hành vi người dùng (implicit user feedback/logs), cùng với ưu nhược điểm của từng loại.', '- Đánh giá thủ công (Explicit labeling / Human assessors): Thuê chuyên gia hoặc annotator chấm điểm mức độ liên quan của từng cặp query-document theo thang điểm (ví dụ: 0 đến 4). Ưu điểm: chất lượng cao, chuẩn xác; Nhược điểm: tốn kém, khó scale và thiếu tính cá nhân hóa.
- Dữ liệu tương tác ngầm định (Implicit feedback / Click logs): Thu thập từ log hành vi người dùng như clicks, add-to-cart, purchase, dwell time (thời gian đọc/xem). Ưu điểm: quy mô dữ liệu khổng lồ, chi phí thu thập rẻ, phản ánh nhu cầu người dùng thực tế.
- Tạo dữ liệu bán tự động/tổng hợp (Synthetic / LLM-generated data): Dùng LLM đóng vai trò tạo truy vấn giả lập hoặc gán nhãn sơ bộ cho các cặp tài liệu.
- Thách thức cần xử lý với implicit data: Cần xử lý các loại thiên vị (bias) như position bias (người dùng click vì vị trí cao chứ chưa chắc liên quan nhất) và selection bias.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7ca27243-cd20-5cd9-b4a3-2eebb0d2d3ce', 'Chúng ta có thể mô hình hóa bài toán tìm kiếm thành bài toán phân loại (classification) được không, và triển khai như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Khẳng định có thể làm được qua cách tiếp cận Pointwise hoặc Pairwise, giải thích định nghĩa feature vector (query, doc, user) và cách chọn nhãn/hàm mất mát.', '- Cách tiếp cận Pointwise: Mô hình hóa thành bài toán phân loại nhị phân (Binary Classification). Mỗi mẫu là một cặp (Query, Document), nhãn Y = 1 nếu document liên quan (hoặc được click/mua) và Y = 0 nếu không liên quan.
- Sử dụng mô hình: Logistic Regression, GBDT hoặc Neural Network dự đoán xác suất P(Relevant = 1 | Query, Document).
- Sắp xếp kết quả: Khi inference, tính xác suất cho tất cả các tài liệu ứng viên và sắp xếp theo xác suất giảm dần.
- Cách tiếp cận Pairwise: Mô hình hóa thành phân loại cặp (Document A tốt hơn Document B với Query Q). Mô hình học cách phân loại nhãn nhị phân thể hiện thứ tự ưu tiên giữa hai tài liệu.
- Hạn chế của hướng classification pointwise: Không xét đến thứ tự tương đối và sự phụ thuộc giữa các tài liệu trong cùng một danh sách kết quả, dễ bị mất cân bằng dữ liệu (class imbalance) do tỷ lệ click thấp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('232e1c5e-1ee1-5a32-aaf4-e6448cda004b', 'Làm thế nào để sử dụng dữ liệu click chuột (click data) làm dữ liệu huấn luyện cho thuật toán ranking mà không bị ảnh hưởng bởi position bias?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Nêu vấn đề position bias (người dùng click vì item ở trên đầu), sau đó giải thích các giải pháp: Inverse Propensity Scoring (IPS), Click Models, hoặc tạo nhãn Pairwise (Joachims heuristic).', '- Thách thức chính: Position bias (vị trí hiển thị cao tự nhiên có tỷ lệ click cao hơn dù relevance có thể thấp hơn) và Presentation bias (chỉ item được hiển thị mới có cơ hội nhận click).
- Inverse Propensity Scoring (IPS): Ước lượng xác suất người dùng quan sát một vị trí P(Examined | Position k), sau đó gán trọng số nghịch đảo (1 / P(Examined)) cho mỗi click trong loss function để bù đắp thiên vị vị trí.
- Dùng Click Models (ví dụ: Position-Based Model, Cascade Model, DBN): Tách riêng xác suất tương tác thành hai biến độc lập: xác suất xem qua (Examination) và xác suất liên quan thực sự (Relevance).
- Heuristic Pairwise Preferences (Joachims): Nếu item ở vị trí k được click nhưng item ở vị trí j (với j < k) không được click, ta suy ra item k được ưu tiên hơn item j (Item_k > Item_j), tạo thành các cặp huấn luyện pairwise.
- Huấn luyện trực tiếp với Position làm feature: Đưa vị trí hiển thị vào mô hình lúc train để mô hình học riêng effect của vị trí, khi inference (predict) gán vị trí cố định bằng 1 (hoặc 0) cho tất cả items.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('39c204e9-1471-57d9-be86-999be31bb7c1', 'Bạn có thể giải thích cách ứng dụng Gradient Boosting Trees (GBDT) để giải quyết bài toán ranking, cụ thể như mô hình LambdaMART không?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Trình bày vấn đề hàm mục tiêu của ranking (NDCG) không khả vi, cách LambdaMART định nghĩa gradient ảo (lambda-gradient) dựa trên RankNet và NDCG, và cách boosting trees fit các gradient này.', '- Thách thức cốt lõi: Các metric ranking chính như NDCG hay MAP là hàm bậc thang/rời rạc (step functions), không liên tục và không có đạo hàm, nên không thể tối ưu trực tiếp bằng Gradient Descent thông thường.
- Nguồn gốc LambdaMART: Là sự kết hợp giữa MART (Multiple Additive Regression Trees - GBDT) và LambdaRank.
- Khái niệm Lambda Gradient: LambdaRank giải quyết việc thiếu đạo hàm bằng cách định nghĩa một ''gradient ảo'' (lambda) cho từng cặp item. Độ lớn của lambda tỷ lệ thuận với mức thay đổi của metric (ví dụ Delta NDCG) khi hoán đổi vị trí của hai item đó trong danh sách.
- Quy trình huấn luyện: Ở mỗi iteration của boosting, thuật toán sắp xếp các item theo điểm dự đoán hiện tại, tính toán lambda-gradient và hessian cho từng item dựa trên Delta NDCG, sau đó fit một Decision Tree mới để dự đoán các giá trị gradient này.
- Ưu điểm: Hiệu quả thực nghiệm rất cao trên dữ liệu bảng/features dạng số, xử lý tốt tương tác phi tuyến và hiện vẫn là chuẩn mực công nghiệp trong giai đoạn reranking.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd150046-c1fe-505c-87a5-3d640362f893', 'Bạn thực hiện đánh giá online (online evaluation) cho một thuật toán ranking mới như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu phương pháp A/B testing và Interleaving, giải thích các nhóm chỉ số online (CTR, conversion rate, revenue, dwell time) và quy trình kiểm soát rủi ro khi rollout.', '- Thử nghiệm A/B Testing truyền thống: Chia người dùng hoặc truy vấn ngẫu nhiên thành nhóm Control (thuật toán cũ) và Treatment (thuật toán mới), chạy song song để so sánh các chỉ số hành vi thực tế.
- Phương pháp Interleaving: Trộn kết quả từ cả hai mô hình (mô hình A và B) vào cùng một danh sách kết quả trả về cho người dùng (đảm bảo không bị bias vị trí). Đo xem người dùng click vào kết quả của mô hình nào nhiều hơn; phương pháp này cần lượng traffic ít hơn nhiều so với A/B test để đạt ý nghĩa thống kê.
- Các chỉ số Online chính: CTR (Click-Through Rate), Conversion Rate (tỷ lệ mua hàng/đăng ký), Average Session Duration / Dwell Time, Search Abandonment Rate (tỷ lệ tìm kiếm xong thoát không click gì), và doanh thu (GMV/Revenue).
- Kiểm soát an toàn và tính tin cậy: Kiểm tra Sample Ratio Mismatch (SRM), tính toán Statistical Significance (p-value, confidence interval), và triển khai canary release (5% -> 20% -> 50% -> 100%) để kịp thời rollback nếu có lỗi.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('df61fecd-9611-5afa-8322-94e36a1c8d5f', 'Hệ thống gợi ý (Recommender System) là gì và có những trường phái tiếp cận cơ bản nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa mục tiêu cốt lõi của recommender system, sau đó phân biệt 3 hướng tiếp cận chính: Collaborative Filtering, Content-Based, và Hybrid.', '- Định nghĩa: Hệ thống gợi ý là hệ thống phần mềm dự đoán sở thích, mức độ quan tâm của người dùng đối với các mục (sản phẩm, phim ảnh, bài viết) nhằm đề xuất các mục phù hợp nhất cho từng cá nhân.
- Content-Based Filtering: Gợi ý các item có đặc trưng tương đồng với những item mà người dùng đã từng thích trong quá khứ (dựa trên mô tả sản phẩm, thể loại, từ khóa).
- Collaborative Filtering (Lọc cộng tác): Gợi ý dựa trên sự tương đồng về hành vi giữa các người dùng (User-based) hoặc sự tương đồng về tập người dùng tương tác giữa các item (Item-based), phổ biến với kỹ thuật Matrix Factorization (SVD).
- Hybrid Filtering: Kết hợp cả Collaborative Filtering và Content-Based nhằm tận dụng ưu điểm của cả hai và giảm thiểu nhược điểm (như Cold-Start problem).
- Giá trị kinh doanh: Tăng mức độ gắn kết của người dùng (retention), tăng doanh thu bán chéo/bán thêm (cross-sell/upsell) và cá nhân hóa trải nghiệm người dùng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2bf9b958-63b9-56d1-8038-44679064404c', 'Khi bắt đầu xây dựng một hệ thống gợi ý, những mô hình baseline đơn giản nào nên được áp dụng trước tiên?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Liệt kê các baseline không cá nhân hóa (non-personalized) và baseline cá nhân hóa đơn giản (simple heuristic), giải thích lý do tại sao cần các baseline này trước khi xây mô hình phức tạp.', '- Most Popular / Top Trending: Gợi ý các item có lượt xem, lượt mua hoặc tương tác nhiều nhất trong toàn hệ thống (hoặc trong một khoảng thời gian gần nhất). Baseline này rất mạnh trong việc thu hút click ban đầu.
- Rule-based / Co-occurrence: ''Người mua sản phẩm này cũng mua sản phẩm kia'' dựa trên tần suất xuất hiện cùng nhau trong giỏ hàng hoặc phiên truy cập (Association Rules / Apriori).
- Category / Demographic Best Sellers: Gợi ý các sản phẩm phổ biến nhất trong từng ngành hàng hoặc theo nhóm nhân khẩu học của người dùng (vị trí địa lý, độ tuổi, giới tính).
- Item-to-Item Heuristic: Dựa trên độ tương đồng đơn giản của metadata (cùng thương hiệu, cùng danh mục, cùng tác giả).
- Lý do cần baseline: Cung cấp mốc chuẩn để đánh giá xem các mô hình ML/Deep Learning phức tạp có thực sự mang lại hiệu quả vượt trội hơn so với chi phí vận hành hay không, đồng thời dùng làm giải pháp dự phòng hiệu quả cho bài toán Cold Start.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c39e281-4620-5c5c-996c-f151c388ccce', 'Bạn hiểu thế nào về Collaborative Filtering trong hệ thống gợi ý (Recommender System)?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày khái niệm cơ bản (dựa vào hành vi cộng đồng) -> Phân loại (user-based, item-based, matrix factorization) -> Nêu ưu và nhược điểm chính (cold start, sparsity).', '- Collaborative Filtering (lọc cộng tác) là phương pháp gợi ý dựa trên lịch sử tương tác/đánh giá của nhóm người dùng có hành vi hoặc sở thích tương tự nhau.
- Gồm hai hướng tiếp cận chính: Memory-based (User-based và Item-based) và Model-based (như Matrix Factorization, SVD).
- Nguyên lý: Dự đoán mức độ yêu thích của user đối với item dựa trên điểm đánh giá của các user/item tương đồng, thường có chuẩn hóa điểm số để triệt tiêu bias.
- Ưu điểm: Không phụ thuộc vào metadata hoặc nội dung chi tiết của item.
- Nhược điểm: Gặp vấn đề cold start (user/item mới), ma trận tương tác thưa thớt (sparsity) và tốn tài nguyên tính toán khi quy mô lớn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('254de265-de8e-5718-9a6e-01f2315977fd', 'Làm thế nào để tích hợp phản hồi ngầm định (implicit feedback như click, thời gian xem, lượt mua) vào hệ thống gợi ý?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân biệt implicit vs explicit feedback -> Đưa ra thách thức lớn nhất (không có negative feedback rõ ràng) -> Nêu các giải pháp/mô hình phổ biến (wALS, BPR).', '- Khác biệt cốt lõi: Implicit feedback (click, view, purchase) không có nhãn tiêu cực rõ ràng; việc không click có thể do không thích hoặc do chưa bao giờ nhìn thấy.
- Chuyển đổi dữ liệu: Chuyển tần suất/thời lượng tương tác thành độ tin cậy (confidence level) thay vì điểm rating tuyệt đối.
- Giải thuật Weighted Alternating Least Squares (wALS): Xem mọi tương tác chưa quan sát là nhãn 0 nhưng gán trọng số độ tin cậy thấp, còn tương tác thực tế có trọng số cao hơn dựa trên tần suất.
- Mô hình Ranking theo cặp (Bayesian Personalized Ranking - BPR): Tối ưu hóa thứ tự ưu tiên (item đã tương tác phải có điểm cao hơn item chưa tương tác).
- Tận dụng làm feature bổ trợ cho các mô hình deep learning hoặc mô hình kết hợp (hybrid models).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fa5bc309-b889-582a-8bdf-1395819ba725', 'Trong hệ thống gợi ý, vấn đề Cold Start là gì và nó thường xảy ra ở những trường hợp nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa ngắn gọn bản chất -> Phân biệt hai trường hợp chính (New User và New Item) -> Ảnh hưởng của nó tới hệ thống.', '- Cold Start là hiện tượng hệ thống gợi ý không thể đưa ra đề xuất chính xác do thiếu hụt dữ liệu tương tác ban đầu.
- New User Cold Start: Người dùng mới tham gia hệ thống chưa có lịch sử click/rating, khiến mô hình lọc cộng tác không thể tính độ tương đồng với người dùng khác.
- New Item Cold Start: Sản phẩm mới được đưa lên hệ thống chưa nhận được lượt tương tác nào, dẫn đến việc sản phẩm khó được hiển thị cho người dùng phù hợp.
- Hệ quả: Giảm trải nghiệm người dùng mới và khó tiếp cận thị trường cho sản phẩm mới.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cf97168b-c8b0-510b-90f7-53a28380c360', 'Bạn có thể đề xuất những hướng tiếp cận nào để giải quyết vấn đề Cold Start trong hệ thống gợi ý?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Phân chia giải pháp theo đối tượng (cho user mới, cho item mới) -> Nêu các kỹ thuật cụ thể (Content-based, Demographic, Hybrid, Active Learning, Multi-Armed Bandit).', '- Dùng Content-based Filtering: Tận dụng metadata (thể loại, mô tả, hình ảnh) của item để gợi ý cho user có sở thích tương tự, giải quyết New Item Cold Start.
- Dùng Demographic / Onboarding: Thu thập thông tin nhân khẩu học (tuổi, giới tính, vị trí) hoặc khảo sát sở thích ban đầu khi user mới đăng ký để gợi ý New User.
- Hệ thống Hybrid: Kết hợp Collaborative Filtering với Content-based hoặc Knowledge-based nhằm bổ trợ dữ liệu khi thiếu tương tác.
- Gợi ý phổ biến (Popularity-based): Hiển thị các item trending, bán chạy nhất cho user mới cho đến khi thu thập đủ dữ liệu hành vi cá nhân.
- Multi-Armed Bandit / Active Learning: Cân bằng giữa khai thác (gợi ý cái chắc chắn thích) và khám phá (thử nghiệm item mới để thu thập phản hồi nhanh chóng).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ae79fa9a-ebc7-5828-8486-d6a2a3197d07', 'Bạn hiểu thế nào là dữ liệu chuỗi thời gian (Time Series)?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Nêu định nghĩa cơ bản -> Chỉ ra các thành phần cấu thành (Trend, Seasonality, Noise) -> Đưa ra 1-2 ví dụ thực tế.', '- Time Series là một chuỗi các điểm dữ liệu được ghi nhận theo thứ tự thời gian liên tục, thường ở các khoảng thời gian đều đặn (như theo giây, giờ, ngày, tháng).
- Khác với dữ liệu bảng độc lập, các quan sát trong time series có sự phụ thuộc lẫn nhau theo thời gian (autocorrelation).
- Thường bao gồm 4 thành phần chính: Xu hướng (Trend), Tính mùa vụ (Seasonality), Tính chu kỳ (Cyclical) và Nhiễu ngẫu nhiên (Noise/Residuals).
- Ví dụ thực tế: Giá cổ phiếu hàng ngày, lượng truy cập website theo giờ, hoặc doanh số bán hàng hàng tháng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('c73f3428-4d5d-5a57-bfe5-f319cb52d021', 'Bài toán dự báo chuỗi thời gian khác biệt như thế nào so với bài toán hồi quy (regression) thông thường?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'So sánh về giả định dữ liệu (IID vs autocorrelation) -> Thứ tự thời gian và cách chia tập train/test -> Bản chất của biến mục tiêu phụ thuộc vào cái gì.', '- Giả định dữ liệu: Hồi quy thông thường giả định các mẫu độc lập và đồng phân phối (IID); Time series vi phạm giả định này vì dữ liệu có tính tự tương quan (autocorrelation) theo thời gian.
- Yếu tố thứ tự: Thứ tự thời gian trong time series mang thông tin cốt lõi và không thể xáo trộn ngẫu nhiên; bài toán hồi quy thông thường có thể shuffle dữ liệu.
- Chia tập Train/Test: Time series bắt buộc phải chia theo mốc thời gian (cross-validation dạng rolling/expanding window) để tránh rò rỉ dữ liệu (data leakage), không thể dùng K-Fold ngẫu nhiên.
- Bản chất dự báo: Hồi quy thông thường dựa vào mối quan hệ nguyên nhân - kết quả giữa feature và target; Time series thường dự đoán giá trị tương lai dựa trên chính lịch sử quá khứ của nó (lags).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5b01fa2c-e414-5c62-ba69-54846a7dae46', 'Bạn biết những mô hình hoặc phương pháp nào thường được dùng để giải quyết bài toán chuỗi thời gian?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân nhóm các mô hình từ cổ điển đến hiện đại: Thống kê cổ điển -> Machine Learning dạng tabular -> Deep Learning.', '- Phương pháp làm mịn và thống kê cổ điển: Exponential Smoothing (SES, Holt, Holt-Winters), phân rã chuỗi thời gian (Decomposition).
- Mô hình chuỗi thời gian kinh điển: Nhóm ARIMA, SARIMA, SARIMAX, VAR (dành cho multivariate).
- Mô hình Machine Learning dạng Tabular: Sử dụng lag features, rolling statistics kết hợp với LightGBM, XGBoost, CatBoost.
- Mô hình mã nguồn mở chuyên dụng: Prophet, NeuralProphet.
- Mô hình Deep Learning: RNN, LSTM, GRU, Temporal Convolutional Networks (TCN) và các kiến trúc dựa trên Transformer (như PatchTST, TimeGPT).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c718eeb-0b58-5c87-9ce8-df3d0ac32459', 'Nếu một chuỗi thời gian có xu hướng (trend), làm thế nào để loại bỏ nó và tại sao chúng ta lại cần làm điều đó?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích lý do trước (đạt tính dừng/stationarity để áp dụng mô hình) -> Trình bày các kỹ thuật khử trend cụ thể (differencing, log transform, decomposition).', '- Lý do cần loại bỏ trend: Để chuỗi đạt tính dừng (stationarity - trung bình và phương sai không đổi theo thời gian). Nhiều mô hình thống kê (như ARIMA) chỉ hoạt động tin cậy và cho kết quả ổn định trên chuỗi dừng.
- Phương pháp sai phân (Differencing): Lấy giá trị hiện tại trừ đi giá trị thời điểm trước đó (y_t - y_{t-1}), có thể lấy sai phân bậc 1 hoặc bậc cao hơn.
- Phương pháp chuyển đổi toán học: Áp dụng log transform, Box-Cox để ổn định phương sai trước khi lấy sai phân.
- Phương pháp phân rã (Decomposition): Tách chuỗi thành Trend, Seasonality và Residual bằng STL hoặc Classical Decomposition, sau đó chỉ giữ lại phần dư (residual).
- Hồi quy xu hướng (Model Detrending): Khớp một đường xu hướng (tuyến tính hoặc phi tuyến tính) rồi lấy phần dư (residuals) để phân tích tiếp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7f79af4a-b2a7-505e-8ee8-6630b2d56672', 'Giả sử bạn có một chuỗi thời gian đơn biến ''y'' được đo ở thời điểm t. Bạn sẽ sử dụng những hướng tiếp cận nào để dự đoán giá trị ''y'' tại t+1?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu phương pháp baseline -> Các mô hình thống kê tự hồi quy -> Kỹ thuật feature engineering cho ML -> Mô hình Deep Learning.', '- Phương pháp Baseline: Naive forecast (dùng chính giá trị tại t), Moving Average đơn giản hoặc Exponential Smoothing.
- Mô hình thống kê tự hồi quy (Autoregressive): Sử dụng mô hình AR, ARMA hoặc ARIMA để mô hình hóa mối quan hệ tự tương quan giữa giá trị quá khứ (lags) và hiện tại.
- Tiếp cận Machine Learning: Tạo các đặc trưng độ trễ (lag features như y_{t-1}, y_{t-2}), thống kê cửa sổ trượt (rolling mean, rolling std) rồi huấn luyện các mô hình như Linear Regression, Random Forest hoặc Gradient Boosting (XGBoost/LightGBM).
- Deep Learning: Sử dụng LSTM hoặc GRU để học chuỗi phụ thuộc tuần tự từ các điểm dữ liệu lịch sử.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ac325c6e-2314-5c17-ad52-b7f2b13dd9b0', 'Bạn có một chuỗi thời gian biến ''y'' cùng với một tập các biến đặc trưng (features) bên ngoài. Bạn sẽ tiếp cận việc dự đoán ''y'' tại t+1 như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân biệt bài toán đa biến (multivariate) -> Nêu hướng tiếp cận thống kê (SARIMAX/VAR) -> Hướng Machine Learning dạng tabular -> Mô hình Deep Learning.', '- Mô hình thống kê mở rộng: Sử dụng ARIMAX / SARIMAX (ARIMA có biến ngoại sinh - exogenous variables) hoặc Vector Autoregression (VAR) nếu các biến ngoại sinh cũng biến đổi theo chuỗi thời gian.
- Machine Learning dạng Tabular: Kết hợp lag features của biến ''y'', rolling statistics với các features ngoại sinh (và lag của features đó), sau đó huấn luyện bằng GBDT (XGBoost, LightGBM, CatBoost) - phương pháp rất mạnh và phổ biến trong thực tế.
- Lưu ý về Data Leakage: Đảm bảo các feature ngoại sinh tại t+1 phải thực sự đã biết trước tại thời điểm t (như ngày trong tuần, ngày lễ, kế hoạch khuyến mãi) để tránh rò rỉ dữ liệu.
- Deep Learning: Sử dụng Temporal Fusion Transformer (TFT) hoặc LSTM đa biến, rất phù hợp khi có lượng dữ liệu lớn và nhiều tín hiệu ngoại sinh phức tạp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('24f5c880-d4a7-5b45-a169-b5356840164e', 'Những nhược điểm hoặc khó khăn chính khi sử dụng các mô hình dạng cây (như Random Forest, GBDT) cho bài toán chuỗi thời gian là gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Tập trung vào hạn chế lớn nhất: không thể ngoại suy (extrapolation) -> Nêu tiếp vấn đề mất thứ tự thời gian -> Đưa ra giải pháp khắc phục.', '- Không có khả năng ngoại suy (Lack of Extrapolation): Mô hình cây phân chia không gian thành các vùng hằng số (step functions), nên không thể dự đoán giá trị nằm ngoài khoảng min-max của tập huấn luyện khi dữ liệu có xu hướng tăng/giảm mạnh.
- Bỏ qua cấu trúc thời gian tự nhiên: Mô hình coi các hàng dữ liệu là độc lập, không tự động nắm bắt thứ tự thời gian nếu kỹ sư không tự tạo các đặc trưng lag, rolling window hoặc time encoding.
- Nhạy cảm với rò rỉ dữ liệu (Data Leakage): Dễ bị overfit nếu quy trình cross-validation không được thiết lập nghiêm ngặt theo thời gian (Time-series Split thay vì K-Fold).
- Cách khắc phục: Khử xu hướng (detrending) hoặc lấy sai phân biến mục tiêu trước khi đưa vào cây, hoặc kết hợp mô hình tuyến tính (để học trend) với mô hình cây (để học phần dư).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b21d5a75-4de9-5c23-873f-56e37d0e6542', 'Gần đây hoặc trong tuần qua, bạn đã học được điều gì mới?', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Chia sẻ ngắn gọn về một kiến thức kỹ thuật hoặc kỹ năng mới bạn vừa tìm hiểu, lý do bạn học nó và bạn đã áp dụng hoặc dự định áp dụng như thế nào.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4a43dcad-55f2-585b-8cfb-784d4e1da387', 'Điều gì trong lập trình khiến bạn cảm thấy hào hứng và đam mê nhất?', 'IT', 'Chung', 'EASY', 'INTRO', 'Bày tỏ niềm đam mê cá nhân qua các khía cạnh như giải quyết vấn đề phức tạp, tạo ra sản phẩm người dùng yêu thích, hoặc cảm giác học hỏi công nghệ mới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('01818968-9c0c-521f-9bf2-fc3d803e85b0', 'Bạn có thể kể về một thách thức kỹ thuật gần đây mà bạn gặp phải và cách bạn đã giải quyết nó không?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng mô hình STAR: bối cảnh xảy ra vấn đề, tính chất phức tạp của thử thách kỹ thuật, các bước cụ thể bạn đã làm để giải quyết và kết quả đạt được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cb091d18-cc5b-5d70-872f-4c1fe5dce30d', 'Khi xây dựng hoặc bảo trì một website, bạn thường áp dụng những kỹ thuật nào để tối ưu hiệu năng (performance)?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày theo các nhóm tối ưu: tối ưu tài nguyên (hình ảnh, nén dữ liệu), tối ưu mã nguồn (lazy loading, code splitting), và cải thiện quá trình render hoặc caching.', '- Tối ưu tài nguyên tĩnh: nén và định dạng lại hình ảnh (WebP, AVIF), nén file với Gzip/Brotli, minify CSS/JS.
- Phân tách và trì hoãn tải mã: áp dụng Code Splitting, Lazy Loading cho hình ảnh và component không quan trọng.
- Tối ưu mạng và cache: sử dụng CDN, cấu hình HTTP Cache-Control hợp lý, tận dụng HTTP/2 hoặc HTTP/3.
- Tối ưu rendering: hạn chế reflow/repaint, sử dụng Debounce/Throttle cho các sự kiện liên tục như scroll/resize.
- Tối ưu chỉ số Core Web Vitals (LCP, FID/INP, CLS) thông qua việc load trước (preload) các critical assets.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f71d064d-a809-5f1a-a7e8-4ae99f1243db', 'Bạn có thể chia sẻ một số phương pháp hoặc kỹ thuật tối ưu SEO tốt nhất mà bạn thường áp dụng gần đây không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Đi từ cấu trúc HTML ngữ nghĩa (semantic tags), thẻ meta/Open Graph, đến giải pháp render phù hợp (SSR/SSG) và hiệu năng tải trang.', '- Sử dụng HTML ngữ nghĩa (semantic HTML: header, nav, main, article, footer, h1-h6) giúp bot tìm kiếm hiểu rõ cấu trúc nội dung.
- Thiết lập đầy đủ các thẻ meta quan trọng: title, meta description, thẻ canonical, meta viewport, và Open Graph/Twitter Cards cho chia sẻ mạng xã hội.
- Tận dụng Server-Side Rendering (SSR) hoặc Static Site Generation (SSG) với các framework hiện đại (Next.js, Nuxt.js) thay vì pure SPA để bot dễ crawl nội dung.
- Tạo và cấu hình sitemap.xml, robots.txt hợp lý, cùng với cấu trúc dữ liệu schema (Structured Data / JSON-LD).
- Tối ưu tốc độ tải trang và trải nghiệm trên thiết bị di động (Mobile-friendly, Core Web Vitals).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('edba0faf-87a4-53c9-b57e-33eeeb2d9b0f', 'Bạn có thể chia sẻ các kỹ thuật phổ biến hoặc những vấn đề bạn từng xử lý liên quan đến bảo mật ở phía Frontend không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu tên các lỗ hổng bảo mật quen thuộc (XSS, CSRF, Clickjacking) kèm theo giải pháp xử lý tương ứng trên Frontend.', '- Chống Cross-Site Scripting (XSS): escape/sanitize dữ liệu người dùng nhập trước khi render, hạn chế dùng dangerouslySetInnerHTML/innerHTML, sử dụng CSP (Content Security Policy).
- Phòng chống CSRF: phối hợp với backend dùng Anti-CSRF Token hoặc cấu hình cookie với cờ SameSite (Strict/Lax).
- Quản lý dữ liệu nhạy cảm: tránh lưu token hoặc thông tin nhạy cảm trong LocalStorage (ưu tiên HttpOnly Cookie), không để lộ API secret keys ở client-side.
- Phòng ngừa Clickjacking và Open Redirect: cấu hình CSP frame-ancestors, xác thực URL chuyển hướng.
- Thường xuyên audit dependencies để phát hiện và vá các thư viện có lỗ hổng bảo mật (ví dụ npm audit).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa316420-0140-5c29-9b4c-130c52a3f8e5', 'Trong các dự án gần đây, bạn đã thực hiện những hành động cụ thể nào để nâng cao khả năng bảo trì (maintainability) của mã nguồn?', 'IT', 'Frontend Developer', 'MEDIUM', 'BEHAVIORAL', 'Chia sẻ trải nghiệm theo mô hình STAR: tình trạng code ban đầu, hành động bạn đề xuất/áp dụng (chuẩn hoá code style, refactor, viết test, tài liệu hoá), và kết quả cho team.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9d936dcb-38bf-5c2f-a3a5-2de97efc513e', 'Bạn có thể chia sẻ về môi trường phát triển (development environment) mà bạn yêu thích và cảm thấy làm việc hiệu quả nhất không?', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Trình bày về editor (VS Code, WebStorm...), các extension hoặc tool hỗ trợ yêu thích, hệ điều hành và cách bạn cấu hình môi trường để tăng năng suất làm việc.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1adc92ae-ddf1-5167-9808-efae41378bdf', 'Bạn có kinh nghiệm làm việc với những hệ thống quản lý phiên bản (VCS) nào và workflow thường dùng là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu tên hệ thống bạn sử dụng thành thạo (Git), các nền tảng (GitHub, GitLab), và giải thích ngắn gọn workflow bạn quen dùng như Git Flow hay GitHub Flow.', '- Hệ thống quản lý phiên bản phổ biến nhất là Git (phân tán), cùng các nền tảng như GitHub, GitLab, Bitbucket.
- Hiểu và áp dụng các workflow phổ biến như Git Flow (feature, develop, release, hotfix, main) hoặc GitHub Flow/Trunk-based development.
- Thành thạo các thao tác cơ bản và nâng cao: commit, branch, merge, rebase, cherry-pick, giải quyết conflict, và tạo Pull Request/Merge Request chất lượng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('262aeee1-d991-5964-9d63-68c1c4d6eca8', 'Bạn có thể mô tả quy trình làm việc (workflow) thông thường của bạn từ lúc nhận yêu cầu/thiết kế đến khi hoàn thiện một trang web không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày theo trình tự logic: phân tích yêu cầu/Figma -> chia nhỏ component -> xây dựng cấu trúc HTML/CSS -> gắn logic/state/API -> test và tối ưu hiệu năng.', '- Phân tích yêu cầu và thiết kế: đọc tài liệu specs, xem thiết kế trên Figma/UI tool, xác định các reusable components và luồng người dùng (user flow).
- Thiết lập cấu trúc: tạo layout cơ bản, tổ chức thư mục, định nghĩa state management và routing nếu cần.
- Phát triển giao diện và logic: code HTML/CSS đáp ứng chuẩn Responsive, tích hợp API, xử lý các trạng thái loading/error/empty state.
- Kiểm thử và tối ưu: test cross-browser, responsive trên nhiều màn hình, kiểm tra hiệu năng và khả năng truy cập (accessibility).
- Review và bàn giao: tự review code, tạo Pull Request và phối hợp với QA/tester kiểm thử.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0a367027-323d-570a-b273-89bc29bfc896', 'Nếu có 5 file stylesheet khác nhau trong dự án, bạn sẽ tích hợp chúng vào website như thế nào để tối ưu nhất?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh cách truyền thống (nhiều thẻ link hoặc @import) với cách tiếp cận hiện đại (bundler như Webpack/Vite gộp và minify, hoặc chia theo critical CSS và non-critical).', '- Sử dụng build tools (Vite, Webpack) để gộp (bundle) và nén (minify) các stylesheet thành một file CSS duy nhất hoặc chia theo trang (code splitting), tránh việc gửi quá nhiều HTTP requests.
- Tránh dùng @import bên trong CSS vì nó chặn quá trình tải song song (render-blocking) của trình duyệt.
- Tách Critical CSS (CSS cần thiết cho phần màn hình đầu tiên) để inline vào thẻ <head>, các stylesheet còn lại có thể tải bất đồng bộ (defer/preload).
- Nếu sử dụng HTTP/2 hoặc HTTP/3, việc tải nhiều file nhỏ đã được cải thiện nhưng bundling và nén vẫn là best practice để tối ưu caching và payload size.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('791256e4-ba7c-5364-a3b7-6a1a1b48dccc', 'Bạn hãy phân biệt sự khác nhau giữa Progressive Enhancement và Graceful Degradation trong phát triển web?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa Progressive Enhancement (từ cốt lõi cơ bản nâng cấp dần lên hiện đại) và Graceful Degradation (từ phiên bản đầy đủ hạ cấp dần cho máy/trình duyệt cũ), kèm ví dụ minh họa.', '- Progressive Enhancement: bắt đầu xây dựng từ nền tảng cơ bản nhất (HTML cốt lõi, chạy được trên mọi trình duyệt cũ/yếu), sau đó bổ sung thêm các tính năng nâng cao (CSS hiện đại, JavaScript tương tác) cho các trình duyệt hỗ trợ tốt hơn.
- Graceful Degradation: xây dựng trải nghiệm hoàn chỉnh, hiện đại nhất cho các trình duyệt mới trước, sau đó bổ sung giải pháp dự phòng (fallback) để trang web vẫn sử dụng được (dù giao diện giảm bớt) trên trình duyệt cũ.
- Điểm khác biệt cốt lõi: Progressive Enhancement đi từ dưới lên (bottom-up), tập trung vào nội dung và độ tương thích rộng; Graceful Degradation đi từ trên xuống (top-down), tập trung vào trải nghiệm tối đa trước rồi sửa chữa cho phần còn lại.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1c0abc44-4995-5ad4-99c1-6709246718a7', 'Bạn sẽ tối ưu hóa các tài nguyên tĩnh (assets/resources) của một website như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Phân loại các loại asset (hình ảnh, font, JS/CSS, media) và nêu các phương pháp tối ưu tương ứng cho từng loại.', '- Tối ưu hình ảnh: chuyển đổi sang định dạng hiện đại (WebP, AVIF), nén kích thước phù hợp với viewport (responsive images với srcset), áp dụng lazy loading.
- Tối ưu Font chữ: dùng định dạng WOFF2, chỉ tải các ký tự cần thiết (font subsetting), dùng font-display: swap để tránh FOIT (chớp trắng chữ).
- Tối ưu JS và CSS: minification, loại bỏ unused CSS/JS (Tree-shaking, PurgeCSS), chia nhỏ bundle (Code Splitting).
- Tối ưu phân phối: sử dụng CDN (Content Delivery Network), bật nén Gzip/Brotli trên server, cấu hình HTTP Cache-Control lâu dài với content hash.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f4ece30a-1b96-5cc5-9d1b-f59afad3303c', 'Một trình duyệt thường tải đồng thời bao nhiêu tài nguyên từ một domain tại cùng một thời điểm? Có những trường hợp ngoại lệ nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nêu giới hạn kết nối của giao thức HTTP/1.1 (thường khoảng 6 kết nối trên một domain), sau đó giải thích sự thay đổi khi dùng HTTP/2 (Multiplexing) hoặc kỹ thuật Domain Sharding.', '- Với HTTP/1.1: hầu hết các trình duyệt hiện đại (Chrome, Firefox, Safari) giới hạn khoảng 6 kết nối TCP đồng thời (simultaneous connections) cho mỗi host/domain.
- Trường hợp ngoại lệ với HTTP/2 và HTTP/3: nhờ tính năng Multiplexing, trình duyệt chỉ mở 1 kết nối TCP duy nhất và có thể tải hàng chục đến hàng trăm tài nguyên đồng thời qua các stream độc lập, không còn bị giới hạn 6 kết nối.
- Kỹ thuật Domain Sharding: chia tài nguyên sang nhiều subdomain khác nhau (như static1.domain.com, static2.domain.com) để vượt qua giới hạn của HTTP/1.1.
- Giới hạn tổng thể của trình duyệt: ngoài giới hạn theo domain, trình duyệt cũng có giới hạn trần tổng số kết nối TCP mở cùng lúc trên toàn hệ thống (thường khoảng vài chục kết nối).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1396690-7390-5d1e-8659-46d5574ef903', 'Bạn hãy nêu 3 cách để giảm thời gian tải trang web, xét trên cả thời gian tải thực tế và cảm nhận của người dùng (perceived load time)?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Chọn 3 kỹ thuật tiêu biểu, kết hợp giữa việc giảm dung lượng thực tế (nén, lazy load) và việc cải thiện trải nghiệm tâm lý người dùng (skeleton screen, progressive rendering).', '- Áp dụng Lazy Loading và Code Splitting: chỉ tải tài nguyên cần thiết cho màn hình hiện tại, giảm dung lượng tải ban đầu và rút ngắn thời gian tải thực tế.
- Tối ưu hoá tài nguyên tĩnh và nén: nén hình ảnh (WebP/AVIF), nén file với Brotli/Gzip và tận dụng CDN/Browser Caching để tải nhanh hơn trong các lần truy cập tiếp theo.
- Sử dụng Skeleton Screens hoặc UI Placeholder: thay vì để màn hình trắng khi chờ dữ liệu, hiển thị khung placeholder để tạo cảm giác trang web đang hoạt động tích cực, giảm thời gian chờ trong cảm nhận của người dùng.
- Tận dụng Preload/Prefetch: tải trước các tài nguyên quan trọng (font, CSS chính) hoặc trang tiếp theo mà người dùng có khả năng click vào.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('75312e48-d442-5121-83c7-9b41352c7b42', 'Nếu bạn tham gia vào một dự án đang dùng tab để thụt dòng trong khi bạn quen dùng space, bạn sẽ xử lý thế nào?', 'IT', 'Chung', 'EASY', 'SITUATIONAL', 'Nêu rõ thái độ ưu tiên tính nhất quán của dự án và tinh thần đồng đội thay vì sở thích cá nhân; đề xuất dùng linter/formatter (như Prettier, EditorConfig) để tự động hóa.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c2ab1e8-1253-5f51-8a5a-3d734e2e2f2b', 'Bạn hãy mô tả cách bạn thiết kế và triển khai một trang trình chiếu hình ảnh (slideshow/carousel) đơn giản.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày cấu trúc HTML cơ bản, cách dùng CSS để ẩn/hiện hoặc căn chỉnh slide, và logic JavaScript để chuyển slide (tự động, bấm nút, xử lý chỉ số index).', '- Xây dựng cấu trúc HTML gồm container bao ngoài, danh sách các slide (ảnh/nội dung), các nút điều hướng (Next/Prev) và indicator chỉ số slide.
- Dùng CSS để ẩn/hiện slide (opacity, display) hoặc xếp hàng ngang với overflow: hidden kết hợp CSS transform/transition để tạo hiệu ứng trượt mượt mà.
- Dùng JavaScript quản lý trạng thái slide hiện tại (current index), lắng nghe sự kiện click nút để tăng/giảm index và cập nhật giao diện.
- Xử lý các trường hợp biên như quay vòng slide (infinite loop) và hỗ trợ tự động chạy (setInterval) cùng tính năng tạm dừng khi hover.
- Tối ưu hiệu năng và trợ năng: lazy load ảnh cho các slide chưa hiển thị, thêm aria attributes và hỗ trợ điều khiển bằng bàn phím/touch swipe.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('dbb72106-0aa1-5801-bfc5-93feda9d5c13', 'Nếu có cơ hội làm chủ hoàn toàn một công nghệ mới trong năm nay, bạn sẽ chọn công nghệ nào và tại sao?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu tên công nghệ cụ thể, lý do chọn dựa trên xu hướng thị trường hoặc bài toán thực tế bạn muốn giải quyết, và kế hoạch học tập của bạn.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('401e8134-b8f6-51e9-9c19-ff7e21be4a54', 'Bạn hãy giải thích tầm quan trọng của các tiêu chuẩn web và các tổ chức tiêu chuẩn như W3C, WHATWG.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày vai trò đảm bảo tính tương thích đa nền tảng, trải nghiệm người dùng nhất quán, giảm chi phí bảo trì và tránh việc một trình duyệt độc quyền kiểm soát web.', '- Đảm bảo tính tương thích chéo (cross-browser compatibility) giúp website hiển thị và hoạt động đồng nhất trên nhiều trình duyệt và thiết bị khác nhau.
- Giúp mã nguồn có tính kế thừa, dễ bảo trì và hạn chế tối đa việc phải viết code riêng rẽ cho từng loại trình duyệt (vendor prefixes, browser hacks).
- Nâng cao khả năng truy cập (Accessibility - a11y) và tối ưu hóa công cụ tìm kiếm (SEO) thông qua các chuẩn ngữ nghĩa (semantic web).
- Ngăn chặn sự độc quyền công nghệ từ các tập đoàn lớn, giữ cho nền tảng web luôn mở và có thể phát triển bền vững lâu dài.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1592d3d6-00fe-56d9-a3e1-ee9d2f4b357b', 'Hiện tượng FOUC (Flash of Unstyled Content) là gì và làm thế nào để tránh hiện tượng này?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa hiện tượng nội dung hiển thị khi chưa kịp nạp CSS, nguyên nhân do thứ tự tải tài nguyên và các kỹ thuật phòng tránh phổ biến.', '- FOUC (Flash of Unstyled Content) là hiện tượng trang web hiển thị nội dung HTML thô không có định dạng trong tích tắc trước khi CSS được tải và áp dụng xong.
- Nguyên nhân chính do CSS được tải chậm, đặt sai vị trí (ví dụ đặt ở cuối body), hoặc do nạp động style bằng JavaScript trễ.
- Cách khắc phục cơ bản là đặt các thẻ link stylesheet vào trong thẻ <head> để trình duyệt tải và parse CSS trước khi render DOM.
- Trích xuất và inline Critical CSS trực tiếp vào thẻ <style> trong <head> đối với phần nội dung hiển thị đầu tiên (above the fold).
- Dùng kỹ thuật preload cho các file CSS quan trọng (rel="preload" as="style") và tránh import CSS lồng nhau bằng @import.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e623b586-90db-59d6-92aa-c79cddbf0b9c', 'Bạn hãy giải thích ARIA và screen reader là gì, đồng thời nêu các cách để xây dựng một website có khả năng tiếp cận tốt (accessibility).', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa screen reader và vai trò của ARIA; sau đó nêu các nguyên tắc xây dựng web accessible như dùng HTML ngữ nghĩa, hỗ trợ bàn phím, tương phản màu sắc.', '- Screen reader là phần mềm hỗ trợ người khiếm thị bằng cách đọc to nội dung hoặc chuyển đổi thành chữ nổi Braille từ màn hình.
- WAI-ARIA (Accessible Rich Internet Applications) là bộ thuộc tính mở rộng (roles, states, properties) bổ sung vào HTML để giúp screen reader hiểu các widget phức tạp.
- Ưu tiên sử dụng thẻ HTML ngữ nghĩa (semantic HTML: <button>, <nav>, <header>) trước khi cần dùng đến ARIA (nguyên tắc: không có ARIA tốt hơn là ARIA sai).
- Đảm bảo website có thể điều hướng hoàn toàn bằng bàn phím (Tab, Enter, Space) với focus indicator rõ ràng.
- Cung cấp alt text đầy đủ cho hình ảnh, đảm bảo độ tương phản màu sắc đạt chuẩn WCAG và hỗ trợ label cho tất cả form input.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4c3038b-d1f8-57ce-a07a-5c3b03edb9a1', 'Bạn hãy so sánh ưu và nhược điểm giữa việc tạo hiệu ứng bằng CSS animation và JavaScript animation.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh dựa trên các tiêu chí: hiệu năng (GPU, compositor thread), độ phức tạp của hiệu ứng, khả năng kiểm soát/tương tác và mức độ hỗ trợ từ trình duyệt.', '- CSS Animation có ưu điểm là nhẹ, tối ưu hiệu năng tốt vì trình duyệt có thể xử lý trên GPU (Compositor thread), cú pháp đơn giản cho hiệu ứng chuyển động cơ bản.
- CSS Animation có nhược điểm là khó kiểm soát trạng thái phức tạp, khó xử lý tương tác vật lý (physics), khó tạm dừng/đảo ngược hoặc chuỗi hiệu ứng (sequencing) phức tạp.
- JS Animation có ưu điểm là khả năng kiểm soát cao (pause, reverse, dynamic values theo chuột/cuộn trang), xử lý tốt các hiệu ứng phức tạp qua thư viện như GSAP.
- JS Animation có nhược điểm là chạy trên main thread nên dễ gây giật/lag (jank) nếu main thread bị nghẽn, dung lượng bundle tăng thêm do thư viện.
- Lựa chọn thực tế: dùng CSS cho UI transitions/hover đơn giản, dùng JavaScript khi cần animation phức tạp theo tương tác người dùng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a5fcdaf6-234a-5449-8dbf-c68f4b23e392', 'CORS viết tắt của từ gì và nó giải quyết vấn đề gì trong phát triển web?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu tên đầy đủ của CORS, giải thích chính sách Same-Origin Policy và cách CORS cho phép chia sẻ tài nguyên an toàn giữa các domain khác nhau.', '- CORS viết tắt của Cross-Origin Resource Sharing (Chia sẻ tài nguyên liên nguồn).
- Mặc định, trình duyệt áp dụng Same-Origin Policy (SOP) để ngăn các script từ một origin (protocol, domain, port) truy cập tài nguyên từ origin khác nhằm bảo vệ dữ liệu người dùng.
- CORS giải quyết vấn đề cho phép frontend truy cập API ở một domain khác một cách an toàn và có kiểm soát.
- Hoạt động thông qua việc máy chủ trả về các HTTP headers (như Access-Control-Allow-Origin, Access-Control-Allow-Methods) để báo cho trình duyệt biết request nào được phép.
- Đối với các request phức tạp (không phải Simple Request), trình duyệt sẽ gửi trước một preflight request (OPTIONS) để kiểm tra quyền hạn trước khi gửi request thật.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e87b0303-fb88-5926-9291-4ccaa207137b', 'Hãy kể về một lần bạn có bất đồng ý kiến với cấp trên hoặc đồng nghiệp. Bạn đã xử lý tình huống đó như thế nào?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Áp dụng cấu trúc STAR: mô tả bối cảnh bất đồng, cách bạn lắng nghe và trao đổi dựa trên dữ liệu/lợi ích chung, và kết quả đạt được.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0618e8e2-d6b6-5a42-ba28-78504a977873', 'Bạn thường theo dõi những nguồn thông tin hay cộng đồng nào để cập nhật kiến thức mới nhất về frontend và thiết kế?', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Liệt kê các nguồn cụ thể bạn thường theo dõi (blog, newsletter, Twitter/X, GitHub, diễn đàn) và chia sẻ cách bạn áp dụng kiến thức mới vào công việc.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6497b0ec-c9ff-5065-841e-d13ada58dbe2', 'Theo bạn, những kỹ năng quan trọng nhất để trở thành một Frontend Developer giỏi là gì?', 'IT', 'Frontend Developer', 'EASY', 'INTRO', 'Kết hợp giữa kỹ năng cứng (HTML/CSS/JS nền tảng, framework, performance, a11y) và kỹ năng mềm (tư duy sản phẩm, thẩm mỹ, giao tiếp, khả năng tự học).', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd0fabc0-1d39-58a1-90e3-3714716160a8', 'Bạn định hướng phát triển bản thân theo vai trò nào trong vòng 3 đến 5 năm tới?', 'IT', 'Chung', 'EASY', 'INTRO', 'Trình bày theo hướng: vị trí hiện tại → mục tiêu 3-5 năm (ví dụ Tech Lead, Senior Frontend, Fullstack) → các hành động bạn đang thực hiện để đạt mục tiêu đó.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e3743c9f-6574-51dd-9678-66e346d5a109', 'Bạn hãy giải thích chi tiết điều gì xảy ra từ lúc người dùng nhập một URL vào trình duyệt và nhấn Enter cho đến khi trang web hiển thị?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày tuần tự qua các giai đoạn: phân giải DNS → thiết lập kết nối TCP/TLS → gửi HTTP Request/Response → quá trình render của trình duyệt (DOM, CSSOM, Render Tree, Paint).', '- Phân giải DNS: Trình duyệt kiểm tra cache (trình duyệt, OS, router) hoặc truy vấn DNS server để chuyển domain thành IP address.
- Thiết lập kết nối: Thực hiện bắt tay 3 bước TCP (TCP 3-way handshake) và bắt tay TLS nếu dùng HTTPS để mã hóa dữ liệu.
- Gửi và nhận HTTP: Trình duyệt gửi HTTP GET request, máy chủ xử lý và trả về HTTP response kèm theo mã trạng thái và mã nguồn HTML.
- Xây dựng cây render: Trình duyệt parse HTML tạo DOM tree, parse CSS tạo CSSOM tree, sau đó kết hợp thành Render Tree.
- Layout và Paint: Trình duyệt tính toán kích thước và vị trí từng phần tử (Layout/Reflow), vẽ các pixel lên màn hình (Paint) và gom các lớp lại (Composite) để hiển thị trang web hoàn chỉnh.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ef6095b7-a0cf-55d1-b331-4a0125ca63f1', 'Bạn hãy phân biệt SSR và CSR về ưu nhược điểm, đồng thời giải thích khái niệm Static Rendering và Rehydration.', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'So sánh SSR và CSR về SEO, TTFB, FCP; sau đó định nghĩa Static Rendering (SSG) và cơ chế Rehydration (gắn event listener vào HTML tĩnh từ server).', '- CSR (Client-Side Rendering): Server trả về file HTML rỗng và bundle JS lớn; trình duyệt tải JS để render UI. Ưu điểm là chuyển trang mượt mà sau khi nạp; nhược điểm là initial load chậm và SEO kém nếu không cấu hình thêm.
- SSR (Server-Side Rendering): Server render HTML hoàn chỉnh cho từng request gửi về client. Ưu điểm là tối ưu SEO và First Contentful Paint (FCP) tốt; nhược điểm là tốn tài nguyên server và Time to First Byte (TTFB) cao hơn.
- Static Rendering (SSG): Trang web được render sẵn thành HTML tĩnh ngay từ lúc build time (build time generation), cho tốc độ tải cực nhanh qua CDN, phù hợp nội dung ít thay đổi.
- Rehydration: Quá trình phía client tải JavaScript và gắn các event listener, khôi phục state vào cây DOM tĩnh đã được SSR/SSG tạo sẵn, biến trang web tĩnh thành ứng dụng tương tác hoàn chỉnh.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('75b6201b-b2de-51e8-9184-020ee3ce2e21', 'Khai báo `<!DOCTYPE html>` ở đầu trang có tác dụng gì và điều gì xảy ra nếu thiếu nó?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu mục đích khai báo phiên bản HTML cho trình duyệt hiểu và giải thích chế độ hiển thị Quirks Mode so với Standards Mode khi không có doctype.', '- `<!DOCTYPE html>` là một chỉ thị (declaration) báo cho trình duyệt biết phiên bản tiêu chuẩn HTML mà trang web đang sử dụng (trong HTML5 là `<!DOCTYPE html>`).
- Giúp trình duyệt kích hoạt chế độ hiển thị chuẩn (Standards Mode), tuân theo các quy chuẩn của W3C.
- Nếu thiếu doctype, trình duyệt sẽ rơi vào chế độ Quirks Mode (chế độ tương thích ngược), mô phỏng lại các lỗi hiển thị của các trình duyệt cũ như Internet Explorer 5/6, dẫn đến layout và CSS hiển thị không đồng nhất trên các trình duyệt hiện đại.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('85954413-9cb9-546f-9eba-240ff62a5995', 'Bạn sẽ triển khai việc phân phối nội dung đa ngôn ngữ (i18n) cho một trang web như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày từ cấp độ cấu trúc URL/routing, thẻ HTML/HTTP headers đến giải pháp quản lý bản dịch ở frontend hoặc backend.', '- Sử dụng cấu trúc URL phù hợp: subpath (example.com/vi/), subdomain (vi.example.com) hoặc query parameter (?lang=vi).
- Đặt thuộc tính lang trên thẻ <html> (ví dụ lang="vi") và khai báo thẻ link rel="alternate" hreflang cho SEO.
- Tận dụng HTTP header Accept-Language để tự động phát hiện ngôn ngữ người dùng hoặc lưu tùy chọn vào cookie/localStorage.
- Sử dụng các thư viện i18n (như i18next, react-intl) để tải động các file từ điển JSON theo ngôn ngữ.
- Lưu ý định dạng ngày tháng, tiền tệ và số theo chuẩn Intl API của trình duyệt.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6aa1e8b2-2287-52f6-b832-f83cb385e240', 'Khi thiết kế hoặc phát triển website hỗ trợ đa ngôn ngữ, bạn cần lưu ý những vấn đề kỹ thuật và giao diện gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Phân tích theo các khía cạnh: UI/UX (độ dài chữ, hướng đọc RTL/LTR), font chữ, định dạng dữ liệu (ngày, số, tiền tệ) và tối ưu SEO/hiệu năng.', '- Độ dài văn bản thay đổi giữa các ngôn ngữ (như tiếng Đức thường dài hơn tiếng Anh), cần thiết kế UI linh hoạt tránh vỡ layout hoặc tràn chữ.
- Hỗ trợ ngôn ngữ viết từ phải sang trái (RTL như tiếng Ả Rập, Do Thái) bằng thuộc tính dir="rtl" và CSS Logical Properties.
- Lựa chọn font chữ hỗ trợ đầy đủ ký tự/bảng chữ cái của các ngôn ngữ mục tiêu (bao gồm dấu tiếng Việt, ký tự CJK).
- Định dạng văn hóa địa phương (l10n): ngày tháng, múi giờ, định dạng số, tiền tệ bằng API Intl.
- Vấn đề SEO: thẻ hreflang, canonical URLs và tránh tự động redirect cứng làm bot tìm kiếm không crawl được.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('251715fe-c1ba-54c6-9820-f5d066293416', 'Các thuộc tính `data-*` (data attributes) trong HTML dùng để làm gì và khi nào nên sử dụng chúng?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu định nghĩa và mục đích ra đời của data-*, cách truy xuất qua JavaScript/CSS, cùng những lưu ý về mặt hiệu năng hoặc bảo mật.', '- Cho phép lưu trữ dữ liệu tùy chỉnh riêng biệt ngay trên các thẻ HTML mà không ảnh hưởng đến giao diện hay vi phạm chuẩn HTML.
- Dễ dàng đọc và ghi thông qua JavaScript bằng thuộc tính dataset (ví dụ element.dataset.id) hoặc hàm getAttribute/setAttribute.
- Có thể dùng trong CSS selector để tạo kiểu dáng hoặc hiển thị nội dung thông qua hàm attr() trong pseudo-elements.
- Thích hợp lưu trữ thông tin trạng thái nhỏ lẻ, ID thực thể phục vụ việc tương tác UI mà không cần gọi API lại.
- Lưu ý: Không nên lưu thông tin nhạy cảm vì người dùng có thể inspect HTML và thấy trực tiếp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fda4e038-e0c7-52d2-a763-fe25728444f1', 'Nếu xem HTML5 như một nền tảng web mở (open web platform), bạn hãy cho biết những thành phần cốt lõi tạo nên nền tảng này?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Khái quát các nhóm tính năng mới do HTML5 đem lại: ngữ nghĩa (semantics), đa phương tiện (multimedia), đồ họa, lưu trữ offline và các web API nâng cao.', '- Cấu trúc ngữ nghĩa (Semantics): Bổ sung các thẻ ngữ nghĩa mới như header, nav, section, article, footer giúp cấu trúc tài liệu rõ ràng và cải thiện SEO/Accessibility.
- Đa phương tiện (Multimedia): Tích hợp trực tiếp thẻ audio, video mà không cần plugin bên thứ ba như Flash.
- Đồ họa và hiệu ứng (Graphics): Giới thiệu Canvas 2D và WebGL/SVG hỗ trợ vẽ đồ họa, xử lý hoạt ảnh phức tạp trực tiếp trên trình duyệt.
- Lưu trữ và tính năng Offline (Storage & Connectivity): LocalStorage, SessionStorage, IndexedDB và Service Workers hỗ trợ PWA và offline mode.
- Các Device & Web APIs hiện đại: Geolocation, WebSockets, Web Workers, Drag and Drop API giúp web chạy mượt mà như native app.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('27119408-0cfd-5c38-bd98-f617d227ee6d', 'Bạn hãy phân biệt sự khác nhau giữa `cookie`, `sessionStorage` và `localStorage`.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'So sánh dựa trên các tiêu chí: dung lượng lưu trữ, thời gian tồn tại (vòng đời), phạm vi truy cập và việc truyền dữ liệu lên server.', '- Dung lượng: Cookie có dung lượng nhỏ (khoảng 4KB); localStorage và sessionStorage có dung lượng lớn hơn nhiều (thường khoảng 5MB-10MB).
- Vòng đời: Cookie tồn tại theo thời gian hết hạn (Expires/Max-Age); localStorage tồn tại vĩnh viễn đến khi bị xóa chủ động; sessionStorage chỉ tồn tại trong phiên duyệt của tab hiện tại.
- Tương tác với Server: Cookie tự động được gửi kèm theo mỗi HTTP request lên server; localStorage và sessionStorage chỉ lưu trữ ở client và không gửi lên server.
- Bảo mật: Cookie có thể bảo vệ bằng cờ HttpOnly, Secure, SameSite; Storage API dễ bị truy cập qua JavaScript nên có nguy cơ bị khai thác bởi XSS.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('343f3b60-263b-5251-b8fe-79b5c7452863', 'Vì sao thông thường thẻ CSS `<link>` được đặt trong `<head>` còn thẻ JS `<script>` lại đặt ngay trước thẻ đóng `</body>`? Có trường hợp ngoại lệ nào không?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích theo cơ chế parse HTML, render tree và render-blocking của CSS/JS, sau đó nêu các giải pháp hiện đại như async, defer.', '- CSS đặt trong <head> để trình duyệt tải và parse kiểu dáng sớm nhất có thể, tránh hiện tượng giật màn hình hoặc trang bị hiển thị không có style (FOUC - Flash of Unstyled Content).
- JS đặt trước </body> vì thẻ script mặc định gây chặn việc phân tích cú pháp HTML (parser-blocking); đặt ở cuối giúp nội dung HTML/DOM được hiển thị cho người dùng trước khi JS thực thi.
- Ngoại lệ đối với CSS: Critical CSS có thể inline trực tiếp trong <head>, các file CSS không quan trọng có thể tải bất đồng bộ (preload/media query).
- Ngoại lệ đối với JS: Khi sử dụng các thuộc tính `async` hoặc `defer`, script có thể an toàn đặt trong <head> mà không làm block quá trình parse HTML; hoặc các script analytics/feature detection cần chạy trước khi render UI.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ee425d44-d5e4-5b5d-af0c-33f265ef5620', 'Khái niệm progressive rendering trong frontend là gì và có những kỹ thuật nào để thực hiện?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Bắt đầu từ định nghĩa và mục đích (cải thiện Perceived Performance), sau đó liệt kê các kỹ thuật cụ thể từ HTML, CSS đến JavaScript/Streaming.', '- Progressive rendering là kỹ thuật render từng phần của trang web càng sớm càng tốt nhằm nâng cao trải nghiệm tải trang (perceived performance) cho người dùng.
- Lazy loading hình ảnh và video: Chỉ tải các tài nguyên đa phương tiện khi chúng chuẩn bị xuất hiện trong viewport (sử dụng loading="lazy" hoặc IntersectionObserver).
- Critical CSS: Tách và inline phần CSS tối thiểu cần thiết để hiển thị phần nội dung trên nếp gấp màn hình (above-the-fold), tải phần CSS còn lại bất đồng bộ.
- Tách nhỏ bundle và code splitting: Chỉ tải mã JavaScript cần thiết cho view hiện tại thay vì tải toàn bộ ứng dụng cùng lúc.
- Streaming SSR: Server render và stream từng phần HTML về client (như React Server Components/Suspense), cho phép hiển thị skeleton/fallback trong khi chờ dữ liệu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34111d16-4782-5b45-8e8c-224ae8bd083b', 'Tại sao bạn lại sử dụng thuộc tính `srcset` trên thẻ `<img>`? Trình duyệt xử lý và lựa chọn ảnh từ thuộc tính này như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu mục đích của responsive images, sau đó giải thích cách trình duyệt phối hợp giữa srcset, sizes, độ phân giải màn hình (DPR) và kích thước viewport.', '- Mục đích của `srcset` là cung cấp danh sách nhiều phiên bản ảnh với kích thước hoặc độ phân giải khác nhau, giúp responsive images tối ưu hóa dung lượng tải trên từng thiết bị.
- Cú pháp gồm URL ảnh kèm theo descriptor: độ phân giải điểm ảnh (1x, 2x) hoặc chiều rộng thực của ảnh (ví dụ: 400w, 800w).
- Khi kết hợp với thuộc tính `sizes`, trình duyệt sẽ biết trước kích thước hiển thị dự kiến của thẻ ảnh trên layout ở từng breakpoint.
- Quá trình chọn: Trình duyệt lấy chiều rộng hiển thị từ `sizes`, nhân với Device Pixel Ratio (DPR), rồi so sánh với các giá trị ''w'' trong `srcset` để chọn ra ảnh nhỏ nhất nhưng vẫn đủ sắc nét.
- Việc này được trình duyệt tính toán trước khi tải CSS và layout, giúp tăng tốc độ tải ảnh so với xử lý bằng JavaScript.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6848659d-5117-560b-aca2-2dea1653127d', 'Bạn đã từng sử dụng các HTML templating engine nào chưa và đánh giá ưu, nhược điểm của chúng so với viết HTML thuần?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu tên các template engine từng làm việc (Pug/Jade, EJS, Handlebars, Mustache...), sau đó phân tích tính tiện lợi về cú pháp, khả năng tái sử dụng và nhược điểm compile.', '- Kể tên một số template engine phổ biến (ví dụ: EJS, Pug/Jade, Handlebars, Nunjucks, Blade, Jinja).
- Ưu điểm: Cho phép tái sử dụng code thông qua partials, layouts; nhúng logic (vòng lặp, điều kiện) vào HTML dễ dàng; cú pháp ngắn gọn hơn (như Pug).
- Giúp tự động escape dữ liệu để phòng tránh lỗi bảo mật XSS khi render từ server.
- Nhược điểm: Cần bước biên dịch (compilation step), phát sinh thời gian build hoặc chi phí CPU ở server; tạo rào cản học tập cú pháp riêng và khó debug khi lỗi render.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('24e1e541-a723-53cb-bd04-a3e472ac24b4', 'Bạn hãy phân biệt sự khác nhau giữa HTML5 `canvas` và `svg`? Khi nào nên chọn công nghệ nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh dựa trên bản chất đồ họa (raster vs vector), DOM, khả năng tương tác/bắt sự kiện, hiệu năng và trường hợp sử dụng tối ưu của từng loại.', '- Bản chất đồ họa: Canvas dựa trên raster/bitmap (vẽ từng pixel qua JavaScript); SVG dựa trên vector (mô tả hình học bằng XML).
- Tương tác DOM: SVG là các phần tử DOM độc lập, có thể gắn CSS và event listener cho từng hình; Canvas là một bề mặt phẳng duy nhất, không có DOM con cho từng đối tượng.
- Khả năng scale: SVG giữ nguyên độ sắc nét khi phóng to thu nhỏ ở mọi độ phân giải; Canvas có thể bị vỡ pixel nếu phóng to mà không vẽ lại theo tỷ lệ.
- Hiệu năng: Canvas tối ưu hơn khi vẽ số lượng rất lớn đối tượng (hàng ngàn object), game 2D, chỉnh sửa ảnh; SVG hiệu năng giảm khi có quá nhiều phần tử DOM nhưng rất nhẹ cho icon, biểu đồ tương tác ít điểm.
- Trường hợp sử dụng: Dùng SVG cho logo, icon, chart tương tác; dùng Canvas cho game, data visualization phức tạp, xử lý ảnh/video thời gian thực.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d570f458-d03c-5a14-8dd7-1ea85fa2dfbb', 'Trong HTML, "empty elements" (hoặc void elements) là gì và bạn có thể kể tên một số thẻ thuộc loại này?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu định nghĩa void element (không có thẻ đóng, không có nội dung con), quy tắc viết trong HTML5 và liệt kê các ví dụ thường gặp.', '- Empty elements (còn gọi là void elements) là các thẻ HTML không thể chứa nội dung văn bản hay các thẻ con bên trong, và không có thẻ đóng riêng biệt (closing tag).
- Trong chuẩn HTML5, dấu gạch chéo tự đóng (/>) là không bắt buộc, có thể viết đơn giản là <img> hoặc <br>.
- Một số ví dụ phổ biến bao gồm: <img>, <br>, <hr>, <input>, <meta>, <link>, <source>, <area>.
- Chúng truyền tải thông tin thông qua các thuộc tính (attributes) thay vì nội dung bên trong cặp thẻ mở-đóng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8c868cc9-7926-501c-af28-5986e3fa70b6', 'Độ ưu tiên (CSS selector specificity) là gì và quy tắc tính điểm ưu tiên hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày định nghĩa specificity, thang điểm 4 cấp (Inline, ID, Class/Attribute/Pseudo-class, Element/Pseudo-element) và cách xử lý trường hợp bằng điểm hoặc !important.', '- Specificity là trọng số (độ ưu tiên) mà trình duyệt sử dụng để quyết định thuộc tính CSS nào sẽ được áp dụng cho một phần tử khi có xung đột style.
- Hệ thống tính điểm thường được biểu diễn theo bộ 3 hoặc 4 cấp (a, b, c, d):
  + a: Inline style (viết trực tiếp trên thẻ style="...") - trọng số cao nhất.
  + b: ID selector (ví dụ #header).
  + c: Class selector, attribute selector và pseudo-class (ví dụ .btn, [type="text"], :hover).
  + d: Type/Element selector và pseudo-element (ví dụ div, h1, ::before).
- Phép so sánh diễn ra từ trái qua phải; cấp cao hơn luôn ghi đè cấp thấp hơn bất kể số lượng selector ở cấp thấp có nhiều đến đâu.
- Từ khóa `!important` sẽ bỏ qua specificity thông thường và luôn chiếm quyền ưu tiên cao nhất, chỉ bị ghi đè bởi một `!important` khác có specificity cao hơn hoặc xuất hiện sau.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1dd8745-a97b-5d9c-aa68-ca49440230aa', 'Bạn hãy phân biệt sự khác nhau giữa "resetting CSS" và "normalizing CSS"? Trong dự án thực tế, bạn thường ưu tiên lựa chọn phương pháp nào và vì sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh triết lý của CSS Reset (xóa sạch style mặc định) và Normalize CSS (chuẩn hóa đồng nhất giữa các trình duyệt), sau đó chia sẻ góc nhìn lựa chọn cá nhân.', '- Reset CSS: Triệt tiêu hoàn toàn tất cả các kiểu mặc định của trình duyệt (user-agent stylesheet), đưa margin, padding, border về 0 và font-size về đồng nhất, buộc lập trình viên phải tự định dạng lại từ đầu mọi thẻ.
- Normalize CSS: Bảo tồn các kiểu mặc định hữu ích (như in đậm cho strong, lùi đầu dòng cho list), khắc phục các lỗi hiển thị không nhất quán giữa các trình duyệt khác nhau mà không làm mất tính ngữ nghĩa mặc định.
- Khác biệt: Reset xóa trắng mọi thứ dẫn đến mã CSS styling phải viết lại nhiều hơn; Normalize nhẹ nhàng, giữ lại các style hữu ích và dễ debug hơn trong DevTools.
- Lựa chọn thực tế: Normalize CSS (hoặc các phiên bản hiện đại như Modern-Normalize / Tailwind Preflight) thường được ưa chuộng hơn vì tiết kiệm thời gian phát triển, thân thiện với accessibility và giữ tính nhất quán đa nền tảng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eccf3b24-1bec-54af-a232-27a744df7ae3', 'Thuộc tính Float trong CSS là gì và cơ chế hoạt động của nó như thế nào? Cách khắc phục hiện tượng sụp đổ chiều cao (clearfix) ra sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày mục đích ban đầu của float (bọc văn bản quanh ảnh), cách nó đưa phần tử ra khỏi normal flow và kỹ thuật xử lý clearfix/BFC.', '- Thuộc tính float (float: left | right) đưa một phần tử ra khỏi luồng bố cục thông thường (normal flow) và đẩy nó về bên trái hoặc bên phải của container chứa nó, cho phép văn bản và các phần tử inline khác bao bọc quanh nó.
- Các phần tử float không chiếm chiều cao trong block container cha, dẫn đến hiện tượng cha bị sụp đổ chiều cao (collapsing parent).
- Cách khắc phục hiện tượng này bằng clearfix:
  + Kỹ thuật Micro Clearfix sử dụng pseudo-element: `.clearfix::after { content: ""; display: table; clear: both; }`.
  + Kích hoạt Block Formatting Context (BFC) trên phần tử cha bằng `overflow: auto` hoặc `overflow: hidden` hoặc `display: flow-root`.
- Ngày nay, float chủ yếu chỉ dùng đúng mục đích căn ảnh trong đoạn văn, việc dựng layout toàn trang đã được thay thế bằng Flexbox và CSS Grid.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('78832ddf-7f64-5999-8b28-5a00a14228e4', 'Bạn hãy giải thích thuộc tính z-index và cơ chế hình thành stacking context trong CSS.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Bắt đầu bằng khái niệm cơ bản về z-index trên trục Z, sau đó giải thích stacking context là gì và các điều kiện phổ biến kích hoạt nó (position kèm z-index, opacity, transform...), cuối cùng nêu cách các context lồng nhau ảnh hưởng thứ tự hiển thị.', '- z-index kiểm soát thứ tự hiển thị của các phần tử trên trục Z (trục vuông góc với màn hình), chỉ hoạt động trên positioned elements (relative, absolute, fixed, sticky) hoặc flex/grid items.
- Stacking context là một môi trường phân lớp ba chiều cục bộ, trong đó các phần tử con được xếp chồng theo thứ tự nhất định và bị giới hạn phạm vi hiển thị bên trong context của phần tử cha.
- Stacking context được hình thành khi: phần tử gốc (<html>), phần tử có position khác static và z-index khác auto, hoặc có các thuộc tính CSS3 như opacity < 1, transform khác none, filter, will-change, mix-blend-mode...
- Các stacking context có tính phân cấp: thứ tự hiển thị của phần tử con bị giới hạn bởi context của cha, một phần tử có z-index cực lớn bên trong một context thấp hơn vẫn sẽ nằm dưới một context cao hơn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('505ec29a-9c64-540b-bfc2-791cbdf88830', 'Bạn hãy giải thích BFC (Block Formatting Context) trong CSS là gì và nó hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày định nghĩa BFC, các cách kích hoạt BFC phổ biến (overflow, float, display: flow-root...), và các vấn đề BFC giải quyết trong thực tế (ngăn margin collapsing, clear float, tránh bọc quanh float).', '- BFC (Block Formatting Context) là một vùng layout độc lập, nơi các phần tử dạng block tự sắp xếp theo chiều dọc mà không làm ảnh hưởng hay bị ảnh hưởng bởi các phần tử bên ngoài.
- Các cách kích hoạt BFC: phần tử gốc <html>, float khác none, position: absolute/fixed, display: inline-block, table-cell, flow-root, flex/grid con, hoặc overflow khác visible.
- Đặc điểm hoạt động: các margin theo chiều dọc của phần tử con nằm trong cùng BFC sẽ bị gộp (margin collapse), nhưng không bị gộp với phần tử ngoài BFC.
- Ứng dụng thực tế: tự bao bọc các phần tử con bị float (clear float mà không cần clearfix hack), và ngăn các khối văn bản tràn vào ôm quanh phần tử float bên cạnh.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26e8fed1-82c8-5e4b-8043-736a70573191', 'Bạn hãy nêu các kỹ thuật clear float trong CSS và phân tích trường hợp nào nên áp dụng kỹ thuật nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Liệt kê các kỹ thuật clear float từ cổ điển đến hiện đại (thẻ trống có clear: both, pseudo-element clearfix, overflow: hidden/auto, display: flow-root) và so sánh ưu nhược điểm của từng cách.', '- Thẻ HTML trống với thuộc tính clear: both: cách cổ điển nhưng làm rác mã HTML, hiện tại không khuyến khích dùng.
- Kỹ thuật Clearfix dùng pseudo-element (:after với display: table hoặc block và clear: both): rất phổ biến, tách biệt cấu trúc HTML và CSS, phù hợp cho hầu hết layout legacy.
- Sử dụng overflow: hidden hoặc overflow: auto trên phần tử cha để kích hoạt BFC: nhanh gọn nhưng có nguy cơ làm cắt mất nội dung tràn ra ngoài (dropdown, tooltip) hoặc xuất hiện thanh scroll không mong muốn.
- Sử dụng display: flow-root: giải pháp chuẩn hiện đại để tạo BFC mà không gây tác dụng phụ về overflow, rất nên ưu tiên khi cần clear float trên trình duyệt hiện đại.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3a601fb2-d0f1-523f-83c2-662f28b67815', 'Khi gặp lỗi hiển thị giao diện chỉ xảy ra trên một trình duyệt cụ thể, bạn thường xử lý như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'SITUATIONAL', 'Trình bày quy trình từ xác định nguyên nhân (kiểm tra DevTools, tra cứu Can I Use, vendor prefix), đến giải pháp (polyfill, Autoprefixer, CSS @supports, fallback), và kiểm thử đa nền tảng.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f2d0d99d-af3e-56ab-b4fd-56dcbc867a09', 'Bạn sử dụng những kỹ thuật hay quy trình nào để đảm bảo trang web vẫn hoạt động tốt trên các trình duyệt cũ hoặc bị giới hạn tính năng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Đề cập đến triết lý thiết kế (Graceful Degradation vs Progressive Enhancement), việc kiểm tra hỗ trợ tính năng (feature detection via CSS @supports / Modernizr), polyfills, và các công cụ build tool (PostCSS, Babel/Browserslist).', '- Áp dụng chiến lược Progressive Enhancement (xây dựng tính năng cốt lõi trước, nâng cấp trải nghiệm cho trình duyệt hiện đại) hoặc Graceful Degradation.
- Sử dụng CSS Feature Queries (@supports) để áp dụng các style nâng cao chỉ khi trình duyệt hỗ trợ, kèm CSS fallback cơ bản bên ngoài.
- Thiết lập cấu hình Browserslist kết hợp Autoprefixer, PostCSS Preset Env để tự động thêm vendor prefixes và transpile cú pháp CSS tương thích.
- Sử dụng Polyfill (như qua Polyfill.io hoặc core-js) đối với các API JavaScript/Web API mà trình duyệt cũ thiếu hụt.
- Thiết kế fallback layout: ví dụ dùng Flexbox hoặc Float làm phương án dự phòng khi CSS Grid không được hỗ trợ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa55c991-075b-5b77-8565-2fac3c475dff', 'Có những cách nào để ẩn một phần tử trên giao diện nhưng vẫn giữ cho screen reader (trình đọc màn hình) đọc được?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu rõ tại sao các thuộc tính như display: none hay visibility: hidden không dùng được, sau đó trình bày kỹ thuật phổ biến (class sr-only / visually-hidden) với position, clip-path hoặc width/height 1px.', '- Không nên dùng: display: none, visibility: hidden hoặc thuộc tính hidden trong HTML vì chúng ẩn hoàn toàn phần tử khỏi cây Accessibility Tree, screen reader sẽ bỏ qua.
- Không nên dùng: opacity: 0 hoặc dời vị trí ra xa (-9999px) bằng cách sơ sài vì có thể gây lỗi cuộn trang hoặc nhận focus bàn phím không mong muốn.
- Phương pháp chuẩn (class sr-only / visually-hidden): đặt kích thước 1px x 1px, overflow: hidden, position: absolute, clip hoặc clip-path: inset(50%), và margin: -1px.
- Đảm bảo xử lý trạng thái focus: nếu phần tử có thể tương tác (như skip-link), cần hiển thị lại bình thường khi người dùng focus bằng bàn phím (:focus).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f6af827e-7ef8-5214-adbe-9fe37576f214', 'Bạn đã từng sử dụng hệ thống grid nào trong CSS chưa, và hiện tại bạn ưu tiên giải pháp nào hơn khi xây dựng layout?', 'IT', 'Frontend Developer', 'EASY', 'BEHAVIORAL', 'Chia sẻ trải nghiệm với các hệ thống grid từng dùng (Bootstrap 12-column grid, CSS Grid bản địa, Flexbox layout...) và giải thích lý do tại sao bạn lựa chọn công nghệ ở thời điểm hiện tại.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3889e352-7eb4-5bcf-b1d3-50d7027dac89', 'Bạn có kinh nghiệm tùy biến giao diện (style) cho SVG bằng CSS không? Bạn thường xử lý việc này như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày cách nhúng SVG để có thể style được (inline SVG vs img/object), các thuộc tính CSS riêng của SVG (fill, stroke, stroke-width), và cách kết hợp CSS animation/pseudo-classes.', '- Phương thức nhúng: SVG cần được nhúng inline trực tiếp trong HTML (hoặc qua Web Component / SVG sprite inline) thì CSS bên ngoài mới can thiệp và style được các phần tử bên trong (nếu nhúng qua thẻ <img> thì không can thiệp được CSS bên ngoài).
- Các thuộc tính CSS chuyên dụng: sử dụng fill thay vì background-color/color, stroke thay vì border, stroke-width, stroke-dasharray, stroke-dashoffset...
- Khả năng tương tác: có thể áp dụng các pseudo-classes như :hover, :focus lên từng thẻ <path>, <rect>, <circle> bên trong SVG.
- Kế thừa màu sắc: thường dùng fill: currentColor để icon SVG tự động đổi màu đồng bộ với thuộc tính color của phần tử cha.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('83f8a11b-b036-5337-b8d2-498c035f6dd6', 'Ngoài thuộc tính screen, bạn có thể nêu thêm ví dụ về các media type hoặc media feature khác trong @media query không?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Kể tên các media type khác (print, all, speech) và các media feature phổ biến ngoài màn hình thông thường (prefers-color-scheme, orientation, hover...).', '- Media types khác ngoài screen: ''print'' (dành cho chế độ in ấn hoặc xem trước khi in), ''all'' (áp dụng cho mọi thiết bị), và ''speech'' (dành cho trình tổng hợp giọng nói).
- Các media features về thiết bị/màn hình: orientation (portrait/landscape), resolution (dpi/dppx), aspect-ratio.
- Các user preference media features hiện đại: prefers-color-scheme (dark/light mode), prefers-reduced-motion (giảm hiệu ứng chuyển động), hover / pointer (kiểm tra thiết bị có con trỏ chuột hay màn hình cảm ứng).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e7c9f1d7-ce4c-5d51-95a0-7b39bccde7f4', 'Khi viết CSS để tối ưu hiệu năng render của trình duyệt, bạn cần lưu ý những cạm bẫy hoặc nguyên tắc quan trọng nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Tập trung vào cách trình duyệt render (Critical Rendering Path: Reflow/Layout, Repaint, Composite), độ phức tạp của CSS selector (right-to-left matching), và việc tối ưu animation.', '- Tránh selector quá sâu hoặc quá tổng quát: Trình duyệt đọc selector từ phải sang trái (right-to-left), nên các selector như ''div div *'' hay universal selector lồng sâu sẽ tốn nhiều tài nguyên khớp cây DOM.
- Tránh kích hoạt Reflow (Layout) liên tục: Hạn chế thay đổi các thuộc tính hình học như width, height, margin, top, left... trong animation; ưu tiên sử dụng transform và opacity vì chúng chạy trên GPU (Composite stage).
- Sử dụng will-change một cách chừng mực: Chỉ khai báo will-change khi phần tử thực sự sắp chuyển động và gỡ bỏ khi xong, tránh lạm dụng gây tốn bộ nhớ GPU.
- Giảm kích thước và độ phức tạp file CSS: Loại bỏ CSS dư thừa (Unused CSS) bằng công cụ như PurgeCSS để giảm thời gian parse CSSOM.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('53333af2-59c4-5d0b-add2-60f2b174194e', 'Theo bạn, ưu và nhược điểm của việc sử dụng CSS Preprocessor là gì? Hãy chia sẻ trải nghiệm thực tế của bạn với công cụ tiền xử lý mà bạn từng dùng.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày các ưu điểm (biến, nesting, mixin, module) và nhược điểm (bước build, nguy cơ phình to CSS do lồng sâu), đồng thời so sánh ngắn gọn với CSS Native hiện nay (CSS Variables, native nesting).', '- Ưu điểm: Hỗ trợ cấu trúc mã sạch và tái sử dụng tốt hơn nhờ variables, nesting, mixins, functions; dễ dàng chia nhỏ file qua @import/@use và compile lại thành một file duy nhất.
- Nhược điểm: Cần bước build (compilation step) làm chậm build time; nguy cơ lạm dụng nesting quá sâu dẫn đến CSS selector có độ đặc hiệu (specificity) quá cao và phình to dung lượng file đầu ra.
- Trải nghiệm thực tế (ví dụ với SASS/SCSS): Rất tiện lợi cho việc quản lý theme màu sắc và hàm tính toán logic, nhưng hiện nay nhiều tính năng đã có sẵn trong CSS thuần (CSS Custom Properties, Native Nesting) khiến vai trò của preprocessor dần thu hẹp.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('398c80ff-2f64-57d1-802a-27f51081c229', 'Khi triển khai một bản thiết kế giao diện sử dụng các font chữ không tiêu chuẩn (custom font), bạn sẽ thực hiện như thế nào để tối ưu trải nghiệm và hiệu năng?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Đề cập đến cú pháp @font-face, định dạng font hiện đại (WOFF2), các thuộc tính tối ưu như font-display (swap), preloading font, và font fallback.', '- Sử dụng quy tắc @font-face trong CSS để khai báo font chữ tùy chỉnh, cung cấp đường dẫn đến file font cục bộ hoặc dùng dịch vụ bên thứ ba như Google Fonts.
- Ưu tiên định dạng font hiện đại và nén tốt nhất là WOFF2 (kèm fallback WOFF cho trình duyệt cũ nếu cần), lược bỏ các ký tự không dùng (subsetting) để giảm dung lượng file.
- Sử dụng thuộc tính ''font-display: swap'' để tránh hiện tượng màn hình trắng không hiển thị chữ (FOIT - Flash of Invisible Text), cho phép hiện font hệ thống trước khi custom font tải xong.
- Thêm thẻ `<link rel="preload" as="font" type="font/woff2" crossorigin>` trong HTML cho các font quan trọng nhằm ưu tiên tải sớm.
- Cấu hình font fallback hợp lý trong thuộc tính font-family để giao diện không bị giật layout (CLS - Cumulative Layout Shift) khi font được chuyển đổi.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e28f6ee3-8941-5d12-9bc1-cefa5a7c0fa9', 'Bạn hãy giải thích cơ chế trình duyệt so khớp (match) các phần tử trong DOM với một CSS selector diễn ra như thế nào?', 'IT', 'Frontend Developer', 'HARD', 'TECHNICAL', 'Nhấn mạnh nguyên tắc duyệt từ phải sang trái (right-to-left) của trình duyệt, khái niệm key selector, và giải thích tại sao cơ chế này lại hiệu quả hơn duyệt từ trái sang phải.', '- Trình duyệt duyệt và so khớp CSS selector theo chiều từ phải sang trái (Right-to-Left - RTL).
- Phần tử ngoài cùng bên phải được gọi là Key Selector (bộ chọn khóa), trình duyệt bắt đầu bằng cách tìm các phần tử khớp với key selector này trước.
- Sau khi tìm thấy phần tử khớp với key selector, trình duyệt mới đi ngược lên cây DOM (kiểm tra cha, ông...) để xác minh xem có thỏa mãn các bộ chọn trước đó hay không.
- Lý do duyệt từ phải sang trái: Giúp loại bỏ nhanh chóng phần lớn các phần tử trong DOM không khớp ngay từ bước đầu tiên, tối ưu hiệu năng hơn nhiều so với duyệt từ trái sang phải rồi phải duyệt xuống tất cả các nhánh con.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3fa755ef-c1d1-54b5-aace-b7b699f96dc3', 'Bạn hãy giải thích khái niệm pseudo-element trong CSS và các ứng dụng thực tế của chúng.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa pseudo-element (tạo phần tử ảo không có trong DOM), phân biệt với pseudo-class, cú pháp hai dấu hai chấm (::), và kể tên các pseudo-element phổ biến (::before, ::after, ::placeholder, ::selection).', '- Khái niệm: Pseudo-element (phần tử giả) được dùng để định kiểu cho một phần cụ thể của phần tử được chọn hoặc chèn thêm nội dung ảo vào trang mà không cần thêm thẻ HTML vào cây DOM.
- Cú pháp chuẩn trong CSS3 sử dụng hai dấu hai chấm (::), ví dụ: ::before, ::after, nhằm phân biệt với pseudo-class dùng một dấu hai chấm (:hover, :focus).
- Các pseudo-element phổ biến: ::before và ::after (thường đi kèm thuộc tính content để thêm icon, đường viền trang trí, hiệu ứng), ::first-letter, ::first-line (định kiểu chữ cái/dòng đầu tiên), ::placeholder (tùy biến chữ gợi ý trong input), ::selection (định kiểu vùng văn bản được người dùng bôi đen).
- Lợi ích: Giúp giữ mã HTML ngữ nghĩa, gọn gàng, tách biệt phần trang trí giao diện sang hoàn toàn phía CSS.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('20b2ebf8-74b6-5578-8f63-5449f3cbf5e2', 'Bạn hiểu thế nào về Box Model trong CSS và làm cách nào để thiết lập cho trình duyệt render layout theo các box model khác nhau?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày 4 thành phần của CSS Box Model, sau đó giải thích thuộc tính box-sizing và sự khác nhau giữa content-box và border-box.', '- CSS Box Model là mô hình bao bọc mọi phần tử HTML, gồm 4 lớp từ trong ra ngoài: content, padding, border và margin.
- Để thay đổi cách tính kích thước phần tử, ta dùng thuộc tính ''box-sizing''.
- Giá trị mặc định là ''content-box'': width và height chỉ áp dụng cho phần content; padding và border sẽ cộng thêm vào kích thước tổng của phần tử.
- Giá trị ''border-box'': width và height đã bao gồm cả content, padding và border, giúp việc tính toán layout và kích thước trực quan, dễ quản lý hơn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f818b538-ecd3-5eb2-be8d-a7456f099ed9', 'Đoạn CSS `* { box-sizing: border-box; }` có tác dụng gì và đem lại những lợi ích nào trong phát triển giao diện?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích tác dụng của selector toàn cục và thuộc tính border-box, sau đó nêu bật lợi ích về kiểm soát kích thước layout và tránh lỗi vỡ khung.', '- Tác dụng: Áp dụng quy tắc tính kích thước ''border-box'' cho tất cả phần tử trên trang web.
- Với ''border-box'', thuộc tính width và height đã bao gồm cả padding và border (chỉ margin là nằm ngoài).
- Lợi ích: Giúp việc tính toán kích thước trực quan hơn nhiều; khi thêm padding hoặc border thì kích thước tổng của phần tử không bị phình to ra, tránh tình trạng vỡ layout hoặc tràn màn hình ngoài ý muốn.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e01a64bc-7c65-5770-a67d-3dd7baadbae4', 'Thuộc tính `display` trong CSS dùng để làm gì và bạn có thể nêu một vài giá trị phổ biến cùng trường hợp sử dụng của chúng không?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa vai trò của display trong việc xác định cách phần tử hiển thị và tương tác với các phần tử khác; nêu các giá trị như block, inline, inline-block, flex, grid, none kèm ví dụ ngắn gọn.', '- Thuộc tính ''display'' xác định kiểu hiển thị của phần tử trên trang web và cơ chế layout con bên trong nó.
- ''block'': chiếm trọn toàn bộ chiều rộng hàng (ví dụ: div, p), có thể đặt width và height.
- ''inline'': chỉ chiếm không gian vừa đủ với nội dung (ví dụ: span, a), không chỉnh được width, height hay margin top/bottom.
- ''inline-block'': hiển thị trên cùng một dòng như inline nhưng vẫn cho phép chỉnh width, height, padding, margin.
- ''flex'' và ''grid'': kích hoạt mô hình layout hiện đại 1 chiều (Flexbox) hoặc 2 chiều (Grid) cho các phần tử con bên trong.
- ''none'': ẩn hoàn toàn phần tử khỏi luồng render của DOM.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('df384f17-0682-55f4-9401-037de3e5f1d9', 'Điểm khác biệt cơ bản giữa `inline` và `inline-block` trong CSS là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'So sánh dựa trên khả năng đứng cùng dòng và khả năng can thiệp kích thước (width, height, vertical margin/padding).', '- Giống nhau: Cả hai đều cho phép các phần tử nằm trên cùng một hàng ngang với các phần tử khác cạnh nó (không tự xuống dòng).
- Khác nhau về kích thước: Phần tử ''inline'' không nhận thuộc tính width và height (kích thước phụ thuộc hoàn toàn vào nội dung), trong khi ''inline-block'' cho phép thiết lập width và height tùy ý.
- Khác nhau về margin/padding: ''inline'' chỉ tôn trọng margin và padding theo chiều ngang (trái, phải); còn ''inline-block'' hỗ trợ đầy đủ margin và padding cho cả 4 phía (trên, dưới, trái, phải).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26171cbc-fc24-5033-820e-6de52d51cb0c', 'Bạn hãy phân biệt sự khác nhau giữa hai bộ chọn `:nth-of-type()` và `:nth-child()` trong CSS.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích cơ chế đếm của từng selector: nth-child đếm tất cả anh em không phân biệt thẻ, nth-of-type chỉ đếm các anh em cùng loại thẻ.', '- '':nth-child(n)'' tìm phần tử con thứ n của thẻ cha mà không phân biệt loại thẻ; sau đó mới kiểm tra xem phần tử đó có khớp với selector chỉ định hay không. Nếu vị trí thứ n không khớp selector, rule sẽ không được áp dụng.
- '':nth-of-type(n)'' lọc theo đúng loại thẻ (tag name) được chỉ định trước, sau đó mới đếm thứ tự n trong số các thẻ cùng loại đó.
- Ví dụ: ''p:nth-child(2)'' chỉ áp dụng nếu con thứ 2 của cha là thẻ p. Còn ''p:nth-of-type(2)'' sẽ tìm thẻ p thứ hai trong số tất cả các thẻ p của thẻ cha đó.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('383e41f2-b679-5220-97d8-7c7cc8965bf2', 'Bạn hãy phân biệt các giá trị định vị `static`, `relative`, `absolute` và `fixed` trong thuộc tính `position` của CSS.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày theo thứ tự từng giá trị: vị trí mặc định (static), dịch chuyển so với chính nó (relative), so với phần tử cha gần nhất có position (absolute), và cố định theo viewport (fixed).', '- ''static'': Giá trị mặc định của mọi phần tử, tuân theo luồng tài liệu thông thường (normal flow), không bị ảnh hưởng bởi top, right, bottom, left, z-index.
- ''relative'': Vẫn nằm trong normal flow nhưng có thể dịch chuyển vị trí tương đối so với vị trí ban đầu của chính nó bằng top/bottom/left/right mà không ảnh hưởng vị trí các phần tử xung quanh.
- ''absolute'': Bị tách khỏi normal flow, được định vị tương đối so với phần tử cha/tổ tiên gần nhất có position khác ''static'' (hoặc body nếu không có).
- ''fixed'': Bị tách khỏi normal flow, được định vị cố định tương đối so với khung nhìn trình duyệt (viewport), không bị cuộn theo nội dung trang.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('26a6cc0e-7f88-55a4-99fb-caeb7bd4fa33', 'Bạn đã từng sử dụng CSS framework nào trong các dự án thực tế? Nếu có cơ hội, bạn muốn cải tiến hoặc thay đổi điểm gì ở framework đó?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu tên framework cụ thể (Bootstrap, Tailwind CSS, Ant Design...), phân tích ưu điểm và chỉ ra nhược điểm trong thực tế kèm giải pháp bạn đề xuất cải thiện.', '- Kể tên các framework đã dùng (ví dụ: Tailwind CSS, Bootstrap, Material-UI).
- Đánh giá ưu điểm: Giúp xây dựng UI nhanh chóng, có sẵn hệ thống design token hoặc component phong phú.
- Nêu nhược điểm gặp phải trong dự án: Ví dụ Bootstrap khó tùy biến sâu giao diện, CSS bị thừa nếu không cấu hình tree-shaking; hoặc Tailwind CSS làm class HTML quá dài, khó đọc nếu không tách component.
- Đề xuất giải pháp cải tiến: Kết hợp cấu trúc utility classes với module CSS/BEM, tối ưu dung lượng bundle bằng PurgeCSS/PostCSS, hoặc xây dựng thư viện headless component để giữ linh hoạt styling.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('33f455ca-d430-5c67-9a8d-8c3b71a947af', 'Bạn đã từng sử dụng CSS Grid chưa? Bạn thường áp dụng nó trong những bài toán layout nào và so sánh với Flexbox ra sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Xác nhận kinh nghiệm sử dụng, nêu bản chất 2 chiều của CSS Grid so với 1 chiều của Flexbox, và chia sẻ các use case điển hình bạn đã áp dụng.', '- CSS Grid là hệ thống layout 2 chiều (two-dimensional), cho phép điều khiển đồng thời cả hàng (rows) và cột (columns), trong khi Flexbox là hệ thống layout 1 chiều (chỉ theo hàng hoặc theo cột).
- Trường hợp nên dùng Grid: Cấu trúc tổng thể của trang web (header, sidebar, content, footer), lưới ảnh hoặc card sản phẩm dạng dashboard với số hàng và cột cố định/tự co giãn.
- Các tính năng mạnh mẽ của CSS Grid: grid-template-areas giúp trực quan hóa layout, minmax(), hàm repeat() và đơn vị linh hoạt ''fr''.
- Kinh nghiệm phối hợp: Dùng CSS Grid cho khung xương lớn (macro layout) và dùng Flexbox cho các phần tử con chi tiết bên trong (micro layout).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa9abdcf-bf65-59b1-a692-300bff423556', 'Bạn hãy phân biệt giữa việc xây dựng một trang web responsive thông thường và việc áp dụng chiến lược mobile-first.', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích khái niệm responsive design nói chung, sau đó làm rõ tư duy mobile-first (thiết kế và code cho màn hình nhỏ trước bằng min-width, tối ưu hiệu năng).', '- Responsive Web Design (RWD) là khái niệm chung chỉ việc trang web có khả năng thích ứng linh hoạt với nhiều kích cỡ màn hình khác nhau bằng media queries, fluid grids và flexible images.
- Mobile-first là một chiến lược thiết kế và phát triển: Bắt đầu từ trải nghiệm cho màn hình di động trước, sau đó mở rộng dần cho tablet và desktop thông qua các media query ''min-width''.
- Khác với desktop-first (thường dùng ''max-width'' để thu nhỏ hoặc ẩn bớt tính năng), mobile-first tập trung vào nội dung cốt lõi và tối ưu hiệu năng tải trang cho thiết bị yếu hơn trước tiên.
- Mobile-first giúp CSS gọn hơn, hiệu năng tốt hơn vì người dùng di động không phải tải và ghi đè các style nặng nề của bản desktop.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('82a46fdf-0f0b-5237-a656-7df86f41bcf1', 'Bạn đã từng tối ưu hiển thị hình ảnh cho màn hình độ phân giải cao (Retina display) chưa? Bạn sử dụng những kỹ thuật nào để xử lý?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích vấn đề ảnh mờ trên màn hình có pixel ratio cao; liệt kê các giải pháp như dùng vector (SVG), thuộc tính srcset/sizes, thẻ <picture>, hoặc CSS image-set.', '- Vấn đề: Màn hình Retina có mật độ điểm ảnh (pixel density / DPR >= 2) cao hơn bình thường, nếu dùng ảnh raster kích thước 1x sẽ bị vỡ nét hoặc mờ.
- Dùng định dạng Vector (SVG): Ưu tiên dùng SVG cho icon, logo vì SVG phóng to thu nhỏ sắc nét vô hạn và dung lượng nhẹ.
- Thuộc tính ''srcset'' và ''sizes'' trong thẻ <img>: Cung cấp các phiên bản ảnh có độ phân giải khác nhau (@1x, @2x, @3x) để trình duyệt tự chọn ảnh phù hợp theo DPR của thiết bị.
- Dùng thẻ <picture>: Hỗ trợ art direction và chuyển đổi định dạng ảnh hiện đại như WebP/AVIF kèm độ phân giải cao.
- Trong CSS: Dùng media query ''min-resolution'' hoặc ''-webkit-min-device-pixel-ratio'' và hàm ''image-set()'' để load background image chất lượng cao.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4a4f3ea7-6eb4-59c6-9054-5418f7164ce9', 'Khi làm animation hoặc căn chỉnh vị trí phần tử, trong trường hợp nào bạn ưu tiên dùng `transform: translate()` thay vì dùng `absolute positioning` kèm `top/left`, và vì sao?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'So sánh dựa trên luồng rendering của trình duyệt (layout, repaint, composite) và sự hỗ trợ tăng tốc phần cứng (GPU) khi làm chuyển động.', '- Hiệu năng render (Browser Rendering Pipeline): Thay đổi ''top/left'' sẽ kích hoạt lại giai đoạn Layout (Reflow) và Repaint của trình duyệt, tiêu tốn CPU và dễ gây giật khung hình.
- Ưu điểm của ''transform: translate()'': Chỉ kích hoạt giai đoạn Composite, được tăng tốc bằng GPU (Hardware Acceleration), giúp animation mượt mà đạt chuẩn 60fps.
- Căn giữa chính xác: ''translate(-50%, -50%)'' cho phép căn giữa phần tử dựa trên chính kích thước của nó mà không cần biết trước chiều rộng hay chiều cao cố định.
- Khi nào dùng absolute positioning: Khi cần ghim cố định một phần tử ở vị trí xác định trong flow giao diện (như badge trên avatar, nút đóng popup), còn animation hoặc chuyển động thì nên ưu tiên translate.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3521fb94-ec3f-5f5b-9baa-ecd805ad8880', 'Kỹ thuật Clearfix trong CSS được dùng để giải quyết vấn đề gì và cơ chế hoạt động của nó ra sao?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu vấn đề sụp chiều cao (height collapse) của phần tử cha khi các con dùng float, sau đó giải thích cách clearfix khắc phục bằng pseudo-element ::after và thuộc tính clear.', '- Vấn đề: Khi các phần tử con sử dụng thuộc tính ''float'', chúng bị tách một phần ra khỏi normal flow, khiến phần tử cha bị ''sụp chiều cao'' (height collapse về 0 nếu không có phần tử non-float khác).
- Tác dụng của Clearfix: Ép phần tử cha tự động ôm trọn lấy các phần tử con đang có thuộc tính float.
- Cách hoạt động phổ biến (micro clearfix): Sử dụng pseudo-element ''::after'' với ''content: ""'', ''display: table'' (hoặc block) và ''clear: both'' để xóa bỏ ảnh hưởng của float ở cuối container.
- Lưu ý hiện đại: Với sự ra đời của Flexbox, Grid và thuộc tính ''display: flow-root'', kỹ thuật float và clearfix hiện nay ít còn được dùng để dựng layout chính.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b0b02c6b-5c83-5be3-a955-aad28d2ec6e2', 'Bạn hãy giải thích sự khác biệt giữa các đơn vị `px`, `em` và `rem` khi thiết lập kích thước chữ (`font-size`) trong CSS.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Phân loại đơn vị tuyệt đối (px) và tương đối (em, rem); làm rõ em phụ thuộc vào phần tử cha, còn rem phụ thuộc vào thẻ gốc html.', '- ''px'' (Pixel): Là đơn vị tuyệt đối, có kích thước cố định, không thay đổi theo phần tử cha hay thiết lập cỡ chữ của trình duyệt.
- ''em'': Là đơn vị tương đối, tính theo ''font-size'' của phần tử cha trực tiếp (hoặc chính nó). Nếu các thẻ lồng nhau nhiều cấp dùng ''em'', kích thước sẽ bị nhân dồn (compounding effect), khó kiểm soát.
- ''rem'' (Root EM): Là đơn vị tương đối, luôn tính dựa theo ''font-size'' của phần tử gốc (''html'', mặc định thường là 16px).
- Ứng dụng thực tế: Thường ưu tiên dùng ''rem'' cho typography và spacing để đảm bảo tính nhất quán và hỗ trợ accessibility khi người dùng thay đổi kích thước font mặc định của trình duyệt.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ff49020a-f86e-5a75-8858-2220afb97762', 'Pseudo-class trong CSS là gì? Bạn có thể nêu một vài pseudo-class phổ biến và các trường hợp sử dụng thực tế của chúng không?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa pseudo-class dùng để chọn phần tử dựa trên trạng thái hoặc vị trí; nêu các ví dụ như :hover, :focus, :active, :disabled, :nth-child.', '- Khái niệm: Pseudo-class là từ khóa đi kèm với selector (bắt đầu bằng dấu hai chấm '':'') dùng để định nghĩa trạng thái đặc biệt của phần tử hoặc chọn phần tử theo vị trí trong DOM tree.
- Trạng thái tương tác người dùng: '':hover'' (khi rê chuột qua nút), '':focus''/''focus-visible'' (khi ô input được focus hoặc điều hướng bằng bàn phím), '':active'' (khi đang nhấn giữ chuột).
- Trạng thái form: '':disabled'' (input bị vô hiệu hóa), '':checked'' (checkbox/radio được chọn), '':invalid'' (dữ liệu nhập không hợp lệ).
- Cấu trúc DOM: '':first-child'', '':last-child'', '':nth-child(n)'' để tạo kiểu cho các dòng bảng chẵn/lẻ mà không cần thêm class HTML.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c289b4c-ade7-5e68-ad5f-7509aafadeb2', 'Bạn hãy phân biệt sự khác nhau giữa phần tử khối (`block-level`) và phần tử nội dòng (`inline`) trong HTML/CSS? Hãy nêu ví dụ cho từng loại.', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'So sánh về cách chiếm dòng, khả năng can thiệp kích thước (width/height/margin/padding), và đưa ra các thẻ HTML đại diện cho mỗi loại.', '- Phần tử block-level: Luôn bắt đầu trên một dòng mới và chiếm toàn bộ chiều rộng có sẵn của phần tử cha (100% width); cho phép tùy chỉnh đầy đủ width, height, margin và padding. Ví dụ: <div>, <p>, <h1>-<h6>, <section>, <ul>.
- Phần tử inline: Không bắt đầu trên dòng mới mà nằm liền kề trên cùng một dòng với các phần tử khác; kích thước chỉ vừa đủ với nội dung bên trong; không chỉnh được width, height và margin top/bottom. Ví dụ: <span>, <a>, <strong>, <em>, <label>.
- Chuyển đổi: Có thể dễ dàng thay đổi hành vi hiển thị của cả hai loại thông qua thuộc tính CSS ''display''.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a32281ea-ab75-5c56-b6d1-011299885b4b', 'Bạn hãy phân biệt CSS Grid và Flexbox. Trong trường hợp nào bạn sẽ ưu tiên dùng cái này hơn cái kia?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày sự khác biệt về số chiều (1D vs 2D), hướng tiếp cận (content-first vs layout-first) và nêu trường hợp cụ thể nên dùng mỗi loại.', '- Flexbox được thiết kế cho bố cục một chiều (1D), theo hàng ngang hoặc cột dọc, phù hợp với sắp xếp linh hoạt các phần tử theo luồng nội dung (content-first).
- CSS Grid được thiết kế cho bố cục hai chiều (2D), đồng thời quản lý cả hàng và cột, phù hợp với việc định hình khung giao diện tổng thể (layout-first).
- Dùng Flexbox khi cần căn chỉnh các item nhỏ lẻ trong một hàng/cột, ví dụ như navbar, danh sách nút bấm, căn giữa phần tử.
- Dùng CSS Grid khi cần chia layout lớn cho toàn trang, hệ thống lưới dashboard, hoặc các khối giao diện phức tạp đòi hỏi định vị chính xác theo hàng và cột.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('eeae1b5c-4267-55e2-9472-6766bac094fb', 'Bạn hãy phân biệt giữa fixed layout, fluid layout và responsive layout trong thiết kế web?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa ngắn gọn từng loại layout theo đơn vị kích thước sử dụng và cách chúng phản ứng khi thay đổi kích thước màn hình.', '- Fixed layout: Dùng kích thước cố định (thường là px) cho các thành phần và container; không co giãn theo độ phân giải màn hình, dễ xuất hiện thanh cuộn ngang trên màn hình nhỏ.
- Fluid (liquid) layout: Dùng các đơn vị phần trăm (%) hoặc tỉ lệ tương đối; các thành phần sẽ co giãn linh hoạt theo độ rộng viewport nhưng cấu trúc bố cục không thay đổi.
- Responsive layout: Kết hợp đơn vị linh hoạt (fluid) với Media Queries để thay đổi hoàn toàn cấu trúc hoặc vị trí các khối tùy theo kích thước màn hình thiết bị.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0b8345aa-5a3c-5a8a-a374-b2350f50f8a7', 'Bạn hãy giải thích cơ chế event delegation trong JavaScript và lợi ích của nó?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Nêu nguyên lý dựa trên event bubbling, cách triển khai qua phần tử cha và các ưu điểm về hiệu năng và quản lý phần tử động.', '- Event delegation là kỹ thuật lắng nghe sự kiện trên một phần tử cha duy nhất thay vì gắn trực tiếp listener lên từng phần tử con.
- Kỹ thuật này dựa trên cơ chế Event Bubbling: khi sự kiện kích hoạt ở phần tử con, nó sẽ lan truyền dần lên các phần tử tổ tiên trên DOM tree.
- Trong listener ở phần tử cha, ta sử dụng `event.target` kết hợp với `matches()` hoặc kiểm tra selector để xử lý đúng phần tử con mong muốn.
- Lợi ích: Tiết kiệm bộ nhớ vì giảm số lượng listener, và tự động hoạt động với các phần tử con được thêm động vào DOM sau này mà không cần gán lại sự kiện.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d3d4de9e-f6eb-5360-a0f4-12c2a0258d25', 'Bạn hãy giải thích cách từ khóa `this` hoạt động trong JavaScript và sự thay đổi của nó khi ES6 giới thiệu arrow function?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích nguyên tắc binding của `this` dựa trên ngữ cảnh gọi hàm, sau đó chỉ rõ sự khác biệt của `this` trong arrow function ở ES6.', '- Trong JavaScript thông thường, giá trị của `this` được xác định tại thời điểm hàm được gọi (runtime/call-site), không phụ thuộc vào nơi hàm được khai báo.
- Các trường hợp phổ biến: gọi hàm thông thường (`window` hoặc `undefined` trong strict mode), gọi qua object method (`this` là object đó), gọi qua hàm khởi tạo `new` (`this` là instance mới tạo), hoặc can thiệp bằng `call`/`apply`/`bind`.
- Trong ES6, arrow function không có ngữ cảnh `this` riêng mà kế thừa `this` từ phạm vi cha bao bọc nó (lexical `this`).
- Arrow function giúp tránh lỗi mất ngữ cảnh `this` phổ biến trong các hàm callback hoặc event handlers mà không cần `bind` hay tạo biến tạm như `var that = this`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e4e1697f-8477-5e8e-a92f-1721adc5dfda', 'Bạn hãy giải thích cơ chế kế thừa nguyên mẫu (prototypal inheritance) trong JavaScript hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Bắt đầu từ khái niệm prototype chain, cách JavaScript tìm kiếm thuộc tính/phương thức, và liên hệ với cú pháp class trong ES6.', '- Mỗi object trong JavaScript đều có một liên kết nội bộ trỏ tới một object khác gọi là prototype (thường truy cập qua `__proto__` hoặc `Object.getPrototypeOf`).
- Khi truy cập một thuộc tính hoặc phương thức của object, nếu object không có sẵn, JavaScript engine sẽ tìm ngược lên chuỗi prototype (prototype chain) cho đến khi tìm thấy hoặc chạm đỉnh là `null` (thông qua `Object.prototype`).
- Các hàm khởi tạo (constructor functions) có thuộc tính `.prototype`, khi tạo instance bằng `new`, prototype của instance sẽ trỏ tới thuộc tính này.
- Cú pháp `class` và `extends` trong ES6 thực chất là cú pháp đường (syntactic sugar) xây dựng trên nền tảng prototypal inheritance.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('927f172c-3a55-5806-8cbd-aa73c7d2d99e', 'Bạn hãy phân biệt giữa `null`, `undefined` và một biến undeclared trong JavaScript? Cách kiểm tra từng trạng thái này như thế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa ngắn gọn ý nghĩa của từng trạng thái, kiểu dữ liệu trả về của chúng và cách code an toàn để kiểm tra.', '- `undefined`: Biến đã được khai báo nhưng chưa được gán giá trị cụ thể, hoặc một thuộc tính không tồn tại trên object. Kiểm tra bằng `typeof x === ''undefined''` hoặc `x === undefined`.
- `null`: Giá trị nguyên thủy đại diện cho sự vắng mặt có chủ đích của một giá trị hoặc object (đã được gán giá trị ''rỗng''). Kiểm tra bằng `x === null` (chú ý `typeof null` trả về `''object''`).
- Undeclared: Biến chưa từng được khai báo bằng `var`, `let`, hay `const` trong phạm vi hiện tại; nếu truy cập trực tiếp sẽ gây ra lỗi `ReferenceError`. Kiểm tra an toàn bằng `typeof x === ''undefined''`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('89a2a451-c35e-5436-baba-a7e29669a469', 'Closure trong JavaScript là gì? Bạn thường ứng dụng closure trong những trường hợp thực tế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa closure gắn liền với lexical scope, sau đó đưa ra 2-3 ứng dụng thực tế phổ biến như đóng gói dữ liệu hay hàm tạo hàm.', '- Closure là sự kết hợp giữa một hàm và môi trường từ vựng (lexical environment) nơi hàm đó được khai báo, cho phép hàm con ghi nhớ và truy cập các biến từ phạm vi hàm cha ngay cả khi hàm cha đã thực thi xong.
- Ứng dụng phổ biến 1: Đóng gói và tạo dữ liệu riêng tư (data privacy / encapsulation), tạo getter/setter giả lập private state.
- Ứng dụng phổ biến 2: Function factories hoặc kỹ thuật Currying (hàm trả về hàm với tham số được lưu trữ trước).
- Ứng dụng phổ biến 3: Xử lý debounce, throttle hoặc duy trì trạng thái trong các hàm callback không đồng bộ.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e8f1ace0-2965-509d-943f-2baf06dac92e', 'Trong JavaScript, bạn thường dùng những cấu trúc nào để lặp qua các thuộc tính của object và các phần tử của array?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Liệt kê các cấu trúc cú pháp phổ biến cho mảng (vòng lặp, array methods) và cho object (vòng lặp, methods biến đổi keys/values).', '- Duyệt Array: Dùng vòng lặp `for...of`, vòng lặp `for` truyền thống, hoặc các phương thức mảng như `forEach()`, `map()`, `filter()`, `reduce()`.
- Duyệt Object: Dùng vòng lặp `for...in` (cần kiểm tra `hasOwnProperty` để tránh lặp qua prototype chain).
- Duyệt Object tối ưu hơn: Chuyển đổi thành array qua `Object.keys()`, `Object.values()`, hoặc `Object.entries()` rồi kết hợp với `for...of` hoặc `forEach()`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('809f1d41-ba6b-5169-a49f-293771b9d1f5', 'Bạn hãy so sánh sự khác nhau giữa `Array.forEach()` và `Array.map()`? Bạn sẽ chọn phương thức nào trong từng trường hợp và có thể kể thêm một số phương thức duyệt mảng phổ biến khác không?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'So sánh về giá trị trả về và tính biến đổi dữ liệu, nêu tiêu chí chọn lựa và liệt kê thêm 2-3 phương thức khác như filter, reduce, find.', '- `forEach()`: Thực thi hàm callback trên từng phần tử nhưng luôn trả về `undefined`, thường dùng khi muốn gây ra side-effect (ghi log, gọi API, cập nhật DOM).
- `map()`: Thực thi hàm callback và trả về một mảng mới có cùng độ dài chứa các giá trị đã qua biến đổi, không làm thay đổi mảng gốc (hướng lập trình hàm).
- Chọn `map()` khi cần transform dữ liệu từ mảng này sang mảng khác; chọn `forEach()` khi chỉ cần duyệt qua để thực hiện tác vụ bên lề mà không cần mảng kết quả.
- Các phương thức duyệt mảng phổ biến khác: `filter()` (lọc phần tử thỏa mãn điều kiện), `reduce()` (tích lũy thành một giá trị đơn lẻ), `find()`/`findIndex()`, `some()` và `every()`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('800d501b-9c04-5092-81f4-803d42b3a08b', 'Hàm ẩn danh (anonymous function) trong JavaScript thường được sử dụng trong những trường hợp nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu định nghĩa ngắn gọn và chỉ ra các use case điển hình như callback, IIFE, hoặc event handler.', '- Anonymous function là hàm không có tên định danh sau từ khóa `function`.
- Dùng làm callback trong các hàm xử lý bất đồng bộ hoặc hàm xử lý mảng (ví dụ: `setTimeout`, `addEventListener`, `arr.map()`).
- Dùng trong IIFE (Immediately Invoked Function Expression) để tạo scope độc lập, tránh làm ô nhiễm phạm vi toàn cục (global scope).
- Gán hàm vào một biến (function expression) hoặc làm hàm trả về bên trong một hàm khác (closure/currying).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b31cd693-8084-57d5-a668-bbfb78994842', 'Bạn hãy phân biệt giữa host objects và native objects trong môi trường JavaScript?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa nguồn gốc của mỗi loại đối tượng (chuẩn ECMAScript quy định vs môi trường runtime cung cấp) và cho ví dụ cụ thể.', '- Native objects: Là các object được định nghĩa và cung cấp sẵn bởi đặc tả ngôn ngữ ECMAScript, hoạt động độc lập với môi trường chạy (ví dụ: `Object`, `Array`, `Function`, `Date`, `Math`, `Promise`).
- Host objects: Là các object do môi trường runtime (như Browser hoặc Node.js) cung cấp thêm để JavaScript tương tác với môi trường đó.
- Ví dụ Host objects trên Browser: `window`, `document`, `HTMLElement`, `localStorage`, `fetch`.
- Ví dụ Host objects trong Node.js: `process`, `Buffer`, `global`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ca2de1ae-fa00-56c7-a2c5-b72866877c0f', 'Bạn hãy phân biệt ba cách gọi sau: `function Person(){}`, `var person = Person()` và `var person = new Person()`?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích lần lượt ý nghĩa của khai báo hàm, gọi hàm thông thường và gọi hàm như constructor với toán tử `new`.', '- `function Person(){}`: Là khai báo hàm (Function Declaration), định nghĩa ra hàm `Person` trong scope hiện tại và được hoisted lên đầu.
- `var person = Person()`: Gọi hàm `Person` như một hàm thông thường; giá trị của `person` sẽ là kết quả hàm trả về (`undefined` nếu không có return), và `this` bên trong hàm sẽ trỏ tới global object (`window`) hoặc `undefined` nếu ở strict mode.
- `var person = new Person()`: Sử dụng `Person` làm hàm khởi tạo (constructor function). Toán tử `new` tạo ra một object rỗng mới, liên kết prototype của nó với `Person.prototype`, gán `this` cho object đó và tự động trả về object mới tạo.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('3837380e-3bb4-5dc4-8d9a-b53c62422c68', 'Bạn hãy giải thích sự khác biệt khi sử dụng hàm được tạo bằng Function Declaration (`function foo() {}`) và Function Expression (`var foo = function() {}`)?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Tập trung giải thích cơ chế hoisting khác nhau giữa hai cách và thời điểm hàm có thể được gọi trong luồng thực thi.', '- Cả hai cách đều tạo ra một hàm có thể thực thi, nhưng khác nhau căn bản ở cơ chế hoisting và thời điểm gán giá trị.
- `function foo() {}` (Function Declaration): Cả tên hàm và phần thân hàm đều được hoisted lên đầu scope, cho phép gọi hàm `foo()` trước dòng khai báo mà không gặp lỗi.
- `var foo = function() {}` (Function Expression): Chỉ có khai báo biến `var foo` được hoisted với giá trị khởi tạo là `undefined`, phần định nghĩa hàm chỉ được gán khi dòng code chạy tới. Nếu gọi `foo()` trước dòng này sẽ gây lỗi `TypeError: foo is not a function`.
- Function Expression linh hoạt hơn trong việc tạo hàm có điều kiện, gán vào object method hoặc truyền dưới dạng tham số.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('f157c871-e363-5c5c-81f8-c5c018c76d7d', 'Bạn hãy giải thích tác dụng của `Function.call` và `Function.apply`? Điểm khác biệt quan trọng nhất giữa hai phương thức này là gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Nêu mục đích chung (gọi hàm và chỉ định ngữ cảnh `this`) và phân biệt rõ cách truyền tham số giữa `call` và `apply`.', '- Cả `call` và `apply` đều dùng để thực thi hàm ngay lập tức với việc chỉ định rõ ràng giá trị của `this` (explicit binding).
- Điểm khác biệt duy nhất nằm ở cách truyền đối số cho hàm:
- `Function.call(thisArg, arg1, arg2, ...)`: Nhận các đối số tiếp theo dưới dạng danh sách phân tách bằng dấu phẩy.
- `Function.apply(thisArg, [argsArray])`: Nhận các đối số tiếp theo dưới dạng một mảng (hoặc array-like object).
- Mẹo ghi nhớ: ''A'' trong `apply` tương ứng với ''Array'', còn ''C'' trong `call` tương ứng với ''Comma''.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('2c561224-7cf8-55a8-a839-9db0a2767c64', 'Bạn hãy giải thích phương thức `Function.prototype.bind` dùng để làm gì và hoạt động như thế nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Giải thích mục đích gắn cố định `this`, điểm khác với `call`/`apply` (không gọi ngay mà trả về hàm mới), và khả năng truyền trước tham số (partial application).', '- `Function.prototype.bind` tạo và trả về một hàm mới với giá trị `this` được ràng buộc cố định với đối tượng được truyền vào, bất kể hàm mới đó được gọi ở đâu hay như thế nào.
- Khác với `call` và `apply` (thực thi hàm ngay lập tức), `bind` chỉ trả về hàm mới để gọi sau này.
- `bind` còn hỗ trợ kỹ thuật Partial Application: cho phép truyền trước một số đối số cố định, các đối số này sẽ được đưa vào trước các đối số truyền khi gọi hàm mới.
- Thường được dùng để tránh mất context `this` khi truyền method làm callback cho event listeners hoặc các hàm bất đồng bộ trong class/object.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e0e55f33-42d1-5eed-aaca-db7f043e44aa', 'Bạn hãy phân biệt giữa feature detection, feature inference và việc kiểm tra User-Agent string trong JavaScript?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Trình bày định nghĩa từng phương pháp, so sánh mức độ tin cậy và nêu rõ tại sao feature detection thường là phương pháp được khuyến nghị nhất.', '- Feature detection: Kiểm tra trực tiếp xem trình duyệt có hỗ trợ một API hay tính năng cụ thể hay không (ví dụ: `if (''geolocation'' in navigator)`), đây là cách tiếp cận an toàn và được khuyến nghị nhất.
- Feature inference: Phỏng đoán trình duyệt hỗ trợ tính năng B chỉ vì nó hỗ trợ tính năng A, phương pháp này dễ gây lỗi vì các trình duyệt triển khai tính năng độc lập với nhau.
- User-Agent (UA) sniffing: Đọc chuỗi User-Agent để nhận diện tên và phiên bản trình duyệt, sau đó đưa ra giả định về tính năng hỗ trợ; phương pháp này kém tin cậy do UA string dễ bị giả mạo hoặc thay đổi định dạng.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5f726ca6-757c-51f6-a074-b6fc787440e0', 'Bạn hãy giải thích cơ chế hoisting trong JavaScript?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Bắt đầu bằng khái niệm hoisting, giải thích cách engine xử lý trong giai đoạn biên dịch/khởi tạo bộ nhớ, và so sánh sự khác nhau giữa var, let, const cũng như function declaration.', '- Hoisting là cơ chế của JavaScript engine đưa phần khai báo biến và hàm lên đầu phạm vi (scope) tương ứng trong giai đoạn compile trước khi thực thi code.
- Function declaration được hoisted hoàn toàn cả định nghĩa lẫn thân hàm, nên có thể gọi trước khi khai báo.
- Biến khai báo bằng `var` được hoisted và khởi tạo giá trị mặc định là `undefined`.
- Biến khai báo bằng `let` và `const` cũng được hoisted nhưng không được khởi tạo giá trị, rơi vào vùng Temporal Dead Zone (TDZ) và sẽ ném lỗi `ReferenceError` nếu truy cập trước dòng khai báo.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('91b901a7-fb26-539f-82cc-8fb6dcf6343d', 'Type coercion trong JavaScript là gì và việc lạm dụng nó có thể dẫn đến những cạm bẫy nào?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa type coercion (ngầm định và tường minh), sau đó lấy ví dụ về các trường hợp ngầm ép kiểu gây lỗi phổ biến (so sánh lỏng lẻo, cộng chuỗi/số, truthy/falsy).', '- Type coercion là quá trình tự động hoặc ngầm định chuyển đổi giá trị từ kiểu dữ liệu này sang kiểu dữ liệu khác trong JavaScript (khác với type conversion tường minh).
- Thường xảy ra khi dùng các toán tử như `+` (vừa là phép cộng vừa là nối chuỗi), toán tử logic (`!`, `if(...)`), hoặc toán tử so sánh bằng lỏng lẻo `==`.
- Cạm bẫy phổ biến gồm: phép cộng chuỗi bất ngờ (`1 + ''2'' = ''12''`), so sánh kì lạ với `==` (ví dụ `0 == ''''`, `false == []`), và đánh giá sai truthy/falsy khi giá trị là `0` hoặc chuỗi rỗng `""`.
- Giải pháp: Ưu tiên sử dụng toán tử so sánh nghiêm ngặt `===`, chủ động ép kiểu tường minh (explicit conversion) bằng `Number()`, `String()`, `Boolean()`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('73d6f2f9-5221-5167-b1c7-33eb7a64514c', 'Bạn hãy mô tả cơ chế event bubbling trong JavaScript?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa event bubbling trong vòng đời sự kiện của DOM, cách sự kiện lan truyền ngược lên các phần tử cha và cách ngăn chặn nếu cần.', '- Event bubbling là cơ chế lan truyền sự kiện trong DOM, trong đó sự kiện kích hoạt trên phần tử con trong cùng (target) rồi nổi bọt dần lên các phần tử cha, tổ tiên cho đến `document` và `window`.
- Là pha thứ ba trong mô hình Event Flow của DOM (sau capture phase và target phase).
- Mặc định các event listener gắn bằng `addEventListener` không truyền tham số thứ ba (hoặc `{capture: false}`) sẽ kích hoạt ở pha bubbling này.
- Có thể ngăn chặn quá trình nổi bọt bằng `event.stopPropagation()` hoặc `event.stopImmediatePropagation()`; ứng dụng phổ biến nhất là kỹ thuật event delegation.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8e719c1c-bb39-547b-b584-0ff4de4de310', 'Bạn hãy mô tả cơ chế event capturing trong JavaScript?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa capturing phase trong mô hình DOM Event Flow, chỉ ra hướng lan truyền từ trên xuống và cách kích hoạt event listener ở pha này.', '- Event capturing (còn gọi là trickling) là pha đầu tiên trong DOM Event Flow, sự kiện bắt đầu từ gốc cây DOM (`window`/`document`) truyền dần xuống qua các phần tử cha cho đến khi chạm tới phần tử mục tiêu (target).
- Để lắng nghe sự kiện ở pha capturing, cần truyền `{capture: true}` hoặc `true` làm đối số thứ ba trong `addEventListener`.
- Mục đích thường dùng để chặn hoặc xử lý sự kiện ở cấp cao trước khi nó tới phần tử con (ví dụ phân quyền, theo dõi analytics hoặc vô hiệu hóa thao tác).
- Sau khi hoàn thành capture phase và target phase, sự kiện sẽ tiếp tục với bubble phase.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('d46b0749-586a-5e90-8dae-0913d5c90038', 'Trong DOM và JavaScript, sự khác biệt giữa attribute và property là gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Phân biệt theo nguồn gốc (HTML vs DOM object), kiểu dữ liệu (chuỗi vs mọi kiểu), và mối quan hệ đồng bộ giá trị giữa chúng.', '- Attribute được định nghĩa trong mã nguồn HTML (HTML attribute), giá trị luôn là chuỗi (string), đại diện cho trạng thái ban đầu của phần tử và được truy xuất qua `getAttribute()` / `setAttribute()`.
- Property là thuộc tính của DOM object trong JavaScript (DOM property), có thể mang bất kỳ kiểu dữ liệu nào (boolean, object, number...) và được truy xuất qua cú pháp chấm (ví dụ: `input.value`).
- Sự đồng bộ giữa attribute và property không phải lúc nào cũng là 1:1; ví dụ với thẻ `<input value="foo">`: attribute `value` giữ nguyên giá trị khởi tạo ban đầu, trong khi property `value` thay đổi liên tục theo thao tác người dùng nhập vào.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('45d084ea-7ba3-5bb3-b473-bbff35d6beb1', 'Theo bạn, việc mở rộng hoặc can thiệp vào các built-in object trong JavaScript có những ưu và nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Khái quát việc can thiệp vào prototype của built-in object, nêu ưu điểm (tạo polyfill/tiện ích) và nhược điểm lớn (xung đột thư viện, Monkey Patching, ảnh hưởng hiệu năng).', '- Khái niệm: Thường là hành vi thêm phương thức mới vào prototype của các đối tượng gốc như `Array.prototype` hay `Object.prototype` (còn gọi là Monkey Patching).
- Ưu điểm: Cho phép viết polyfill cho các tính năng mới trên trình duyệt cũ; viết code tiện lợi, dễ gọi trực tiếp từ instance (`arr.customMethod()`).
- Nhược điểm: Nguy cơ xung đột tên khi một thư viện khác hoặc chính chuẩn ECMAScript trong tương lai bổ sung phương thức cùng tên nhưng khác hành vi; gây khó khăn cho việc debug và bảo trì; có thể ảnh hưởng đến hiệu năng tối ưu của JavaScript engine.
- Thực tiễn tốt nhất: Tránh can thiệp vào built-in prototype, thay vào đó nên dùng utility function độc lập hoặc kế thừa class.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('93da094b-8c65-5b1e-84a8-057f6fbefcec', 'Bạn hãy phân biệt sự khác nhau giữa toán tử `==` và `===` trong JavaScript?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Trình bày sự khác biệt về ép kiểu ngầm định và so sánh kiểu dữ liệu, đưa ra ví dụ minh họa và quy chuẩn code thực tế.', '- Toán tử `==` (loose equality) thực hiện ép kiểu ngầm định (type coercion) nếu hai toán hạng khác kiểu dữ liệu trước khi so sánh giá trị.
- Toán tử `===` (strict equality) so sánh cả kiểu dữ liệu lẫn giá trị; nếu hai toán hạng khác kiểu thì trả về `false` ngay mà không ép kiểu.
- Ví dụ: `0 == ''0''` là `true`, nhưng `0 === ''0''` là `false`.
- Trong thực tế phát triển, khuyến nghị luôn dùng `===` để tránh các lỗi logic tiềm ẩn do cơ chế tự ép kiểu phức tạp của JavaScript.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('746fe4ae-5b92-5938-bf21-642b8ac8a9b4', 'Bạn hãy giải thích chính sách Same-Origin Policy trong trình duyệt và ảnh hưởng của nó đối với JavaScript?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa khái niệm origin (protocol, host, port), mục đích bảo mật của chính sách này đối với JavaScript, và các giải pháp cho phép chia sẻ tài nguyên hợp lệ (CORS).', '- Same-Origin Policy (SOP) là cơ chế bảo mật cốt lõi của trình duyệt nhằm ngăn chặn mã script từ một origin này truy cập hoặc tương tác trái phép với tài nguyên của một origin khác.
- Một origin được xác định bởi bộ ba: Giao thức (Protocol/Scheme), Tên miền (Domain/Host) và Cổng (Port); cả ba phải giống nhau hoàn toàn mới tính là cùng origin.
- Tác động: JavaScript chạy trên trang không thể đọc dữ liệu response từ `fetch`/`XMLHttpRequest` khác origin, không truy cập được DOM của `iframe` khác origin, và hạn chế truy cập cookie/storage.
- Cách xử lý khi cần tương tác hợp lệ: Cấu hình CORS (Cross-Origin Resource Sharing) từ phía server, sử dụng `postMessage` cho giao tiếp giữa các window/iframe, hoặc dùng reverse proxy.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fdbd943f-f52e-57a5-bf1d-0e64ef274cd0', 'Tại sao lại gọi là Ternary operator (toán tử ba ngôi), và từ "Ternary" ở đây mang ý nghĩa gì?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích nguồn gốc tên gọi dựa trên số lượng toán hạng (ba toán hạng), nêu cú pháp và so sánh ngắn gọn với toán tử một ngôi và hai ngôi.', '- Từ "Ternary" có nguồn gốc từ tiếng Latin biểu thị số 3 hoặc gồm 3 phần; trong lập trình, toán tử ba ngôi là toán tử nhận đúng 3 toán hạng.
- Đây là toán tử duy nhất trong JavaScript nhận 3 toán hạng, với cú pháp: `condition ? exprIfTrue : exprIfFalse`.
- Phân biệt với unary operator (toán tử một ngôi, nhận 1 toán hạng như `++`, `!`) và binary operator (toán tử hai ngôi, nhận 2 toán hạng như `+`, `&&`).
- Công dụng chính là viết biểu thức điều kiện ngắn gọn trả về giá trị, thường dùng để gán biến hoặc lồng trực tiếp trong JSX.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1c396359-4bb2-5286-9610-88fc45e6fa84', 'Strict mode trong JavaScript là gì và việc sử dụng nó mang lại những lợi ích cũng như hạn chế nào?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Định nghĩa strict mode (`''use strict''`), liệt kê các hành vi nó thay đổi hoặc ngăn chặn, và nêu ảnh hưởng khi làm việc với code cũ.', '- Strict mode (`''use strict''`) là chế độ thực thi nghiêm ngặt được giới thiệu từ ECMAScript 5 nhằm hạn chế các lỗi tiềm ẩn và làm sạch cú pháp JavaScript.
- Lợi ích: Biến các lỗi ngầm (silent fail) thành exception (ví dụ gán biến chưa khai báo, ghi đè thuộc tính read-only); ngăn chặn các cú pháp nguy hiểm như `with`; cố định `this` là `undefined` thay vì `window` trong hàm thông thường; giúp engine tối ưu hóa hiệu năng tốt hơn.
- Hạn chế: Có thể làm hỏng các đoạn mã cũ (legacy code) dựa vào hành vi lỏng lẻo của non-strict mode; cần cẩn trọng khi ghép (concatenate) nhiều file JS nếu có file dùng strict mode và file không dùng.
- Lưu ý: Các module ES6 (`import`/`export`) và thân class mặc định đã luôn chạy ở strict mode.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('53a562cd-9a33-53ba-af9a-75f4a097c995', 'Theo bạn, việc phát triển ứng dụng bằng một ngôn ngữ biên dịch ra JavaScript (như TypeScript hay CoffeeScript) có những ưu và nhược điểm gì?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Đưa ra các góc nhìn về an toàn kiểu dữ liệu, trải nghiệm lập trình (IDE), quy trình build (compilation step) và đường cong học tập.', '- Ưu điểm: Bổ sung tính năng mạnh mẽ mà JS thuần chưa có (điển hình là Static Typing trong TypeScript); phát hiện lỗi ngay từ thời điểm compile thay vì runtime; nâng cao trải nghiệm phát triển với autocomplete, refactoring và tài liệu tự động qua IDE; dễ bảo trì dự án lớn.
- Nhược điểm: Tăng độ phức tạp của build pipeline (cần cấu hình transpile/build tools); tốn thời gian compile code; tăng dung lượng dependency và đường cong học tập cho thành viên mới.
- Việc debug đôi khi phức tạp hơn nếu không cấu hình sourcemap chính xác để ánh xạ ngược lại mã nguồn ban đầu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b57546c0-b107-532b-9ca7-4dcd1752bfc5', 'Bạn thường sử dụng những công cụ và kỹ thuật nào để debug mã nguồn JavaScript?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Liệt kê các công cụ (Chrome DevTools, IDE debugger, linter) và các kỹ thuật cụ thể (breakpoints, console methods, network inspection, memory profiling).', '- Công cụ chính: Trình duyệt DevTools (Chrome/Firefox DevTools), debugger tích hợp trong IDE (như VS Code), và các tiện ích mở rộng như React DevTools hay Redux DevTools.
- Kỹ thuật đặt Breakpoint: Dùng conditional breakpoints, DOM change breakpoints, XHR/fetch breakpoints hoặc từ khóa `debugger` trong code thay vì chỉ dựa vào `console.log`.
- Tận dụng các phương thức `console`: `console.table()`, `console.group()`, `console.time()`/`timeEnd()` để kiểm tra dữ liệu và đo hiệu năng có cấu trúc.
- Phân tích luồng và trạng thái: Sử dụng Call Stack để lần vết nguồn gốc lời gọi hàm, tab Network để kiểm tra payload/response API, và tab Performance/Memory để phát hiện memory leak hoặc giật lag giao diện.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('027acb2f-04fe-5b44-bd3c-4a991d956dea', 'Bạn hãy phân biệt mutable và immutable object trong JavaScript, nêu ưu nhược điểm của immutability và cách áp dụng nó trong code thực tế?', 'IT', 'Frontend Developer', 'MEDIUM', 'TECHNICAL', 'Định nghĩa mutable/immutable, ví dụ cụ thể trong JS, phân tích lợi ích (dự đoán luồng dữ liệu, tối ưu render) và chi phí bộ nhớ, cùng các kỹ thuật hiện thực (spread, Object.freeze, Immer).', '- Phân biệt: Mutable object là đối tượng có thể thay đổi trạng thái hoặc thuộc tính sau khi tạo; Immutable object thì không thể thay đổi sau khi khởi tạo.
- Trong JavaScript: Các kiểu dữ liệu nguyên thủy (string, number, boolean) là immutable; object và array mặc định là mutable.
- Ưu điểm của immutability: Giúp trạng thái dễ dự đoán, loại bỏ side effects, hỗ trợ so sánh nhanh (shallow comparison) rất quan trọng trong các UI library như React để tránh re-render thừa.
- Nhược điểm: Tạo ra nhiều object mới liên tục có thể gây áp lực lên bộ nhớ và Garbage Collection nếu không xử lý cẩn thận.
- Cách hiện thực: Dùng cú pháp spread `...`, các hàm mảng trả về mảng mới (`map`, `filter`, `concat`), `Object.freeze()` (chỉ shallow), hoặc dùng thư viện quản lý bất biến như Immer hoặc Immutable.js.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cd965f5b-4f99-53ad-b8bd-9b1e42fe4067', 'Bạn hãy giải thích sự khác biệt giữa hàm đồng bộ (synchronous) và hàm bất đồng bộ (asynchronous) trong JavaScript?', 'IT', 'Frontend Developer', 'EASY', 'TECHNICAL', 'Giải thích dựa trên cơ chế đơn luồng của JavaScript, sự khác biệt về việc chặn luồng thực thi (blocking vs non-blocking) và cách JavaScript xử lý bất đồng bộ qua Event Loop.', '- Hàm đồng bộ (synchronous): Thực thi tuần tự từng dòng lệnh, lệnh tiếp theo chỉ được chạy khi lệnh trước đã hoàn thành; nếu một tác vụ tốn thời gian sẽ làm chặn (blocking) luồng chính (Main Thread) và đơ giao diện.
- Hàm bất đồng bộ (asynchronous): Cho phép khởi tạo một tác vụ (như gọi API, đọc file, hẹn giờ) rồi nhường quyền thực thi cho các dòng lệnh tiếp theo mà không làm nghẽn UI (non-blocking).
- Cơ chế hoạt động: JavaScript là đơn luồng; các tác vụ bất đồng bộ được ủy quyền cho Web APIs (trên browser) hoặc C++ APIs (trên Node.js), sau khi hoàn thành kết quả được đẩy vào Callback Queue / Microtask Queue và chờ Event Loop đưa vào Call Stack khi stack rỗng.
- Trong code, bất đồng bộ thường được xử lý qua Callback, Promise hoặc cú pháp `async/await`.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9778f6ff-4a19-53bb-b9d6-92628f505359', 'Ý nghĩa của hệ số chặn (bias term hoặc intercept) trong các mô hình tuyến tính là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa toán học của bias term (giá trị dự đoán khi tất cả các features bằng 0) và ý nghĩa thực tế của nó trong việc dịch chuyển mặt phẳng phân tách hoặc đường hồi quy.', '- Bias term (hay intercept w0) là giá trị kỳ vọng của biến mục tiêu y khi tất cả các đặc trưng đầu vào x đều bằng 0.
- Về mặt hình học, bias term đại diện cho điểm cắt trục tung (y-intercept) của đường hoặc siêu phẳng hồi quy.
- Nó cho phép mô hình linh hoạt dịch chuyển siêu phẳng lên xuống thay vì bị ép buộc phải đi qua gốc tọa độ (0, 0).
- Lưu ý phân biệt bias term trong công thức hồi quy với khái niệm bias trong đánh đổi bias-variance.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('aa5c3387-51b1-554e-bc35-ebdee41aefbe', 'Bạn giải thích ý nghĩa các trọng số (weights/coefficients) trong mô hình tuyến tính như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu ý nghĩa trong linear regression (sự thay đổi của y khi x tăng 1 đơn vị), logistic regression (thay đổi về log-odds) và nhấn mạnh vai trò của việc chuẩn hóa dữ liệu khi so sánh độ quan trọng.', '- Trong Linear Regression thông thường, trọng số w_i thể hiện sự thay đổi trung bình của biến mục tiêu y khi đặc trưng x_i tăng 1 đơn vị, với điều kiện giữ nguyên tất cả các đặc trưng khác.
- Trong Logistic Regression, w_i thể hiện sự thay đổi của log-odds (tỉ số chênh) khi x_i tăng 1 đơn vị, hoặc exp(w_i) thể hiện sự thay đổi của odds ratio.
- Dấu của trọng số cho biết chiều tác động: dương là tương quan thuận, âm là tương quan nghịch với mục tiêu.
- Khi các đặc trưng đã được chuẩn hóa (scale), độ lớn tuyệt đối của trọng số phản ánh mức độ quan trọng tương đối của đặc trưng đó đối với kết quả dự đoán.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a4915680-1c1a-5679-9d03-d1ef270556e4', 'Trong mô hình tuyến tính, nếu trọng số của một biến lớn hơn trọng số của biến khác thì có thể kết luận biến đó quan trọng hơn không?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Khẳng định điều này phụ thuộc vào việc các biến đã được chuẩn hóa (normalize/standardize) hay chưa, giải thích ảnh hưởng của thang đo (scale) và hiện tượng đa cộng tuyến.', '- Không thể kết luận ngay lập tức nếu dữ liệu chưa qua chuẩn hóa (feature scaling).
- Khi các biến có thang đo khác nhau (ví dụ một biến đo bằng triệu đồng, một biến đo bằng tuổi đời), biến có khoảng giá trị lớn thường sẽ có trọng số rất nhỏ và ngược lại.
- Chỉ khi tất cả các đặc trưng đã được chuẩn hóa về cùng một thang đo (như Standardization hoặc Min-Max scaling), độ lớn tuyệt đối của trọng số mới phản ánh tương đối mức độ quan trọng.
- Ngoài ra, hiện tượng đa cộng tuyến (multicollinearity) cũng có thể làm sai lệch độ lớn và dấu của các trọng số, khiến việc so sánh trở nên kém tin cậy.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ec03f626-99fe-52b3-a9e3-7708b78c1ecb', 'Khi nào chúng ta cần chuẩn hóa đặc trưng (feature normalization) cho các mô hình tuyến tính, và khi nào thì không bắt buộc?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân biệt trường hợp sử dụng giải thuật tối ưu (Gradient Descent), các kỹ thuật Regularization (L1/L2) với trường hợp dùng công thức nghiệm giải tích (OLS normal equation).', '- Cần chuẩn hóa khi áp dụng Regularization (L1 Lasso, L2 Ridge, ElasticNet): các phương pháp này phạt độ lớn của trọng số; nếu không chuẩn hóa, các biến có thang đo lớn sẽ có trọng số nhỏ và ít bị phạt hơn không công bằng.
- Cần chuẩn hóa khi huấn luyện bằng các giải thuật tối ưu theo độ dốc (Gradient Descent): giúp hàm mất mát có dạng đối xứng hơn, thuật toán hội tụ nhanh và ổn định hơn.
- Không bắt buộc chuẩn hóa khi dùng Ordinary Least Squares (OLS) thuần túy giải bằng phương trình giải tích (Normal Equation), vì nghiệm tối ưu về mặt lý thuyết là như nhau bất kể thang đo.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('72c1bc84-0a98-54ec-bc86-4fb72efa713d', 'Lựa chọn đặc trưng (feature selection) là gì và tại sao chúng ta cần thực hiện bước này?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày định nghĩa feature selection, sau đó liệt kê các lợi ích chính như giảm overfitting, tăng tốc độ huấn luyện, cải thiện khả năng giải thích và tiết kiệm tài nguyên lưu trữ.', '- Feature selection là quá trình chọn lọc ra một tập con các đặc trưng phù hợp và có ích nhất từ tập đặc trưng ban đầu để đưa vào mô hình học máy.
- Giảm hiện tượng overfitting: loại bỏ các đặc trưng nhiễu hoặc không liên quan giúp mô hình tổng quát hóa tốt hơn.
- Cải thiện hiệu năng và tốc độ tính toán: ít chiều dữ liệu giúp thời gian huấn luyện và suy luận (inference) nhanh hơn, giảm tài nguyên bộ nhớ.
- Tăng tính giải thích (interpretability): mô hình có ít biến sẽ dễ hiểu và dễ giải trình nghiệp vụ hơn.
- Tránh lời nguyền số chiều (curse of dimensionality) và giảm thiểu hiện tượng đa cộng tuyến.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a5bab229-0fc3-532a-a5f3-efe980bce807', 'Việc lựa chọn đặc trưng (feature selection) có vai trò quan trọng như thế nào đối với các mô hình tuyến tính?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Tập trung vào đặc thù của mô hình tuyến tính: tính nhạy cảm với đa cộng tuyến, nhiễu dữ liệu và nguy cơ overfitting khi số lượng features lớn hơn số lượng mẫu (p > n).', '- Rất quan trọng vì mô hình tuyến tính giả định mối quan hệ tuyến tính độc lập giữa các biến; các đặc trưng dư thừa hoặc nhiễu sẽ làm suy giảm nghiêm trọng độ chính xác của dự đoán.
- Giải quyết hiện tượng đa cộng tuyến (multicollinearity): khi các biến tương quan cao với nhau, ma trận nghịch đảo mất ổn định, dẫn đến phương sai trọng số rất lớn và khó diễn giải.
- Xử lý vấn đề p > n (số chiều nhiều hơn số mẫu): mô hình OLS thuần túy không thể giải được nếu số biến vượt quá số lượng mẫu.
- Tăng tính diễn giải (interpretability): giữ lại các biến quan trọng nhất giúp giải thích rõ ràng tác động của từng yếu tố đến biến mục tiêu.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('bb546949-035e-56e2-9da3-f9bc57574354', 'Bạn biết những phương pháp lựa chọn đặc trưng (feature selection) nào? Hãy phân loại và giải thích ngắn gọn.', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân loại thành 3 nhóm chính: Filter methods, Wrapper methods và Embedded methods, kèm ví dụ cụ thể cho từng nhóm.', '- Filter methods: đánh giá đặc trưng dựa trên tính chất thống kê độc lập với mô hình huấn luyện, ví dụ: Pearson correlation, Chi-square test, ANOVA F-test, Mutual Information.
- Wrapper methods: sử dụng một mô hình để đánh giá nhiều tập con đặc trưng khác nhau dựa trên kết quả dự đoán, ví dụ: Forward Selection, Backward Elimination, Recursive Feature Elimination (RFE).
- Embedded methods: tích hợp việc chọn đặc trưng trực tiếp vào quá trình huấn luyện mô hình, ví dụ: L1 Regularization (Lasso), cây quyết định hoặc Random Forest (dựa trên feature importance).
- Lưu ý: PCA hay NCA là kỹ thuật giảm chiều dữ liệu (feature extraction/reduction), biến đổi tạo ra đặc trưng mới chứ không phải feature selection đơn thuần.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7c43d94b-6457-5d13-ae05-e7070f937238', 'Chúng ta có thể sử dụng L1 regularization (Lasso) để lựa chọn đặc trưng được không? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Khẳng định có, giải thích cơ chế ép trọng số về đúng bằng 0 do hình dạng hình học của hàm phạt L1 (hình thoi/kim cương).', '- Có thể, L1 regularization (Lasso) thường xuyên được sử dụng như một phương pháp embedded feature selection.
- Nguyên nhân là do hàm phạt chuẩn L1 (tổng trị tuyệt đối của các trọng số) có dạng hình học có các góc nhọn nằm trên các trục tọa độ.
- Khi tối ưu hóa hàm mất mát kết hợp với hàm phạt L1, điểm tiếp xúc tối ưu thường xảy ra tại các góc nhọn trên trục tọa độ, khiến một số trọng số bị triệt tiêu về đúng giá trị 0 tuyệt đối.
- Các biến có trọng số bằng 0 sẽ bị loại bỏ, chỉ giữ lại các biến có trọng số khác 0, tạo ra mô hình thưa (sparse model).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('11d46719-74a1-5150-8c87-7eff73dde13f', 'Chúng ta có thể dùng L2 regularization (Ridge) để lựa chọn đặc trưng được không? Vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Khẳng định không hiệu quả cho việc chọn đặc trưng, giải thích cơ chế co cụm trọng số về gần 0 nhưng hiếm khi bằng 0 của hàm phạt L2 (hình tròn/hình cầu).', '- Không, L2 regularization (Ridge) không phù hợp để thực hiện feature selection.
- Nguyên nhân: hàm phạt L2 là tổng bình phương các trọng số, có dạng hình học trơn hình cầu/elip không có góc nhọn trên các trục tọa độ.
- Khi tối ưu, L2 chỉ co các trọng số về giá trị rất nhỏ (tiến gần về 0) chứ hầu như không bao giờ triệt tiêu trọng số về đúng bằng 0 tuyệt đối.
- Tất cả các đặc trưng vẫn được giữ lại trong mô hình, do đó không tạo ra mô hình thưa (sparse model).
- Ứng dụng chính của L2 là ngăn ngừa overfitting và xử lý hiện tượng đa cộng tuyến (multicollinearity) bằng cách phân bổ đều trọng số giữa các biến tương quan.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6c9b879a-82f2-5480-aff1-35c71dca02c6', 'Bạn hiểu thế nào về mô hình cây quyết định (Decision Tree)? Hãy mô tả cấu trúc và nguyên lý hoạt động cơ bản của nó.', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Trình bày khái niệm mô hình học có giám sát, cấu trúc cây (root node, internal nodes, leaves, branches) và cách thức phân tách dữ liệu cho bài toán phân loại/hồi quy.', '- Cây quyết định là thuật toán học máy có giám sát dạng phi tham số (non-parametric), áp dụng được cho cả bài toán phân loại (Classification) và hồi quy (Regression).
- Cấu trúc gồm có: Node gốc (Root node) nhận toàn bộ dữ liệu, các Node nội bộ (Internal nodes) kiểm tra điều kiện trên một đặc trưng, các Nhánh (Branches) biểu diễn kết quả điều kiện, và Node lá (Leaf nodes) chứa nhãn dự đoán hoặc giá trị số.
- Nguyên lý hoạt động dựa trên cơ chế chia để trị (divide and conquer), liên tục phân tách không gian dữ liệu thành các vùng con thuần nhất hơn dựa trên tiêu chí đo lường độ tinh khiết.
- Các tiêu chí phân tách phổ biến gồm có Gini Impurity, Entropy / Information Gain (cho phân loại) và Mean Squared Error / Variance Reduction (cho hồi quy).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4ccf868d-358f-5190-bdf7-0f290f2f38c0', 'Thuật toán huấn luyện một cây quyết định (Decision Tree) diễn ra theo những bước nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Mô tả thuật toán đệ quy tham lam (greedy recursive splitting): bắt đầu từ node gốc, tìm feature và ngưỡng chia tối ưu, tạo các node con, và áp dụng điều kiện dừng.', '- Quá trình huấn luyện sử dụng thuật toán đệ quy tham lam từ trên xuống (top-down greedy splitting, ví dụ CART, ID3, C4.5).
- Bước 1: Bắt đầu từ node gốc với toàn bộ tập dữ liệu huấn luyện.
- Bước 2: Duyệt qua tất cả các đặc trưng và các ngưỡng phân chia khả dĩ để tìm ra cặp (đặc trưng, ngưỡng) giúp tối ưu hóa tiêu chuẩn đánh giá (giảm tối đa Gini impurity, tăng Information Gain hoặc giảm Variance lớn nhất).
- Bước 3: Phân chia tập dữ liệu tại node hiện tại thành hai hoặc nhiều node con theo điều kiện tối ưu vừa tìm được.
- Bước 4: Lặp lại quá trình phân tách đệ quy cho từng node con cho đến khi thỏa mãn điều kiện dừng (đạt độ sâu tối đa, số mẫu tại node quá ít, hoặc độ tinh khiết đạt tối đa).', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('00913266-6466-5f46-94fb-7c648d2c66e0', 'Các siêu tham số (hyperparameters) quan trọng nhất cần tinh chỉnh trong mô hình cây quyết định là gì?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Liệt kê các tham số kiểm soát độ sâu, kích thước node và tiêu chí phân tách dùng để chống overfitting.', '- max_depth: độ sâu tối đa của cây, tham số quan trọng nhất để kiểm soát việc overfitting.
- min_samples_split: số lượng mẫu tối thiểu cần có tại một node để node đó được phép tiếp tục phân chia.
- min_samples_leaf: số lượng mẫu tối thiểu cần có tại một node lá.
- criterion: tiêu chí để đo lường chất lượng phân tách (ví dụ ''gini'' hay ''entropy'' cho phân loại, ''squared_error'' hay ''friedman_mse'' cho hồi quy).
- max_features: số lượng đặc trưng tối đa được xem xét khi tìm kiếm điểm phân chia tốt nhất.
- max_leaf_nodes: số lượng node lá tối đa cho phép trong cây.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('465db769-e1c9-5fae-aecb-16e3fe0ff40c', 'Cây quyết định xử lý các biến phân loại (categorical variables) như thế nào trong thực tế?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân biệt giữa khả năng lý thuyết của các thuật toán (như CART, C4.5, LightGBM/CatBoost) với triển khai thực tế trong Scikit-learn (cần mã hóa One-Hot, Ordinal, Target Encoding).', '- Về mặt lý thuyết và trong các thư viện hiện đại (như LightGBM, CatBoost): thuật toán có thể xử lý trực tiếp biến categorical bằng cách gom các nhóm danh mục hoặc tính toán thống kê mục tiêu (target statistics).
- Trong Scikit-learn: thư viện yêu cầu dữ liệu đầu vào hoàn toàn là số, nên cần tiền xử lý biến categorical trước khi đưa vào cây (sử dụng One-Hot Encoding hoặc Ordinal Encoding).
- Lưu ý với One-Hot Encoding: nếu biến có số lượng categories lớn (high cardinality), cây sẽ dễ bị phân mảnh nhánh, dẫn đến cây rất sâu, thiên lệch và dễ overfit.
- Kỹ thuật thay thế hiệu quả cho biến high-cardinality là Target Encoding hoặc Frequency Encoding.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('5c2a182c-c575-5fae-b871-8106d02ce6cf', 'So với các mô hình phức tạp hơn như Random Forest hay Neural Networks, một cây quyết định đơn lẻ có những ưu điểm gì?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Tập trung vào tính dễ giải thích (interpretability/explainability), tốc độ huấn luyện/suy luận, yêu cầu tiền xử lý dữ liệu ít khắt khe và khả năng trực quan hóa.', '- Khả năng giải thích và trực quan hóa vượt trội (White-box model): cấu trúc cây dạng tập luật IF-THEN giúp các bên liên quan dễ dàng hiểu được lý do đưa ra quyết định.
- Tốc độ huấn luyện và suy luận (inference) rất nhanh, sử dụng ít tài nguyên tính toán.
- Ít yêu cầu tiền xử lý dữ liệu: không cần chuẩn hóa (normalization/scaling) đặc trưng và không bị ảnh hưởng quá nhiều bởi các giá trị ngoại lai (outliers).
- Xử lý tốt cả mối quan hệ phi tuyến và tương tác giữa các đặc trưng (feature interactions) mà không cần tạo biến tương tác thủ công.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('108a2c63-6c4a-599b-9187-95bb462f1bc9', 'Làm thế nào để xác định mức độ quan trọng của các đặc trưng (feature importance) trong mô hình cây quyết định?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích cách tính Gini Importance (MDI - Mean Decrease in Impurity), vị trí xuất hiện của feature trong cây, và nhắc đến phương pháp thay thế như Permutation Importance.', '- Mức độ quan trọng của đặc trưng thường được tính dựa trên độ giảm độ tinh khiết trung bình (Mean Decrease in Impurity - MDI / Gini Importance).
- Cụ thể: mỗi lần một đặc trưng được chọn để chia tại một node, ta tính mức độ giảm độ tinh khiết (Gini hoặc Entropy) nhân với tỷ lệ mẫu đi qua node đó; tổng mức giảm này trên toàn cây phản ánh tầm quan trọng của đặc trưng.
- Đặc trưng được chọn để phân tách ở các node càng gần gốc (root node) thường có tầm ảnh hưởng càng lớn vì nó tác động đến lượng dữ liệu lớn hơn.
- Ngoài MDI, có thể dùng Permutation Feature Importance: xáo trộn ngẫu nhiên giá trị của từng đặc trưng và đo lường mức độ suy giảm hiệu năng của mô hình trên tập validation.', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('9e5838a0-ee64-52b2-a2d5-89d4c63ed109', 'Mạng CNN có tính bất biến với phép xoay (rotation invariance) không? Điều gì sẽ xảy ra với kết quả dự đoán của CNN khi ảnh đầu vào bị xoay?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Bắt đầu bằng việc khẳng định bản chất kiến trúc của CNN đối với phép xoay (translation vs rotation), phân tích hệ quả lên feature map và prediction, sau đó nêu giải pháp khắc phục.', '- Mạng CNN tiêu chuẩn vốn dĩ không có tính bất biến với phép xoay (rotation invariance), mà chủ yếu có tính equivariant đối với phép tịnh tiến (translation equivariance)
- Khi ảnh bị xoay, các đặc trưng cục bộ xuất hiện ở hướng khác khiến các filter kích hoạt khác biệt, dẫn đến vector đặc trưng thay đổi và model có thể dự đoán sai hoàn toàn
- Để cải thiện, giải pháp phổ biến nhất là data augmentation (xoay ngẫu nhiên dữ liệu huấn luyện)
- Ngoài ra có thể sử dụng các kiến trúc chuyên biệt như Spatial Transformer Networks (STN) hoặc Group Equivariant CNNs để mô hình học được tính bất biến với phép xoay', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('1dd0309d-e58c-54a8-a159-97fe399ea5e1', 'Data augmentation là gì và tại sao chúng ta lại cần sử dụng kỹ thuật này khi huấn luyện mô hình?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Định nghĩa khái niệm data augmentation, giải thích các lý do cốt lõi (chống overfitting, tăng tính đa dạng dữ liệu, nâng cao khả năng khái quát hóa) và đưa ra ví dụ ngắn gọn.', '- Data augmentation là kỹ thuật tạo thêm dữ liệu huấn luyện mới bằng cách biến đổi nhân tạo dữ liệu sẵn có mà không làm thay đổi nhãn gốc
- Giúp tăng kích thước và độ phong phú của dataset khi dữ liệu thu thập thực tế bị giới hạn
- Đóng vai trò như một kỹ thuật regularization giúp giảm thiểu hiện tượng overfitting
- Cải thiện khả năng khái quát hóa (generalization) và độ bền vững (robustness) của mô hình đối với dữ liệu thực tế', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('4bbd4bdc-7865-5799-8452-861fd4b063dd', 'Trong Computer Vision, bạn thường sử dụng những phương pháp data augmentation nào?', 'IT', 'Data Scientist / AI', 'EASY', 'TECHNICAL', 'Phân loại các nhóm augmentation cơ bản (hình học, màu sắc/nhiễu, phối hợp nhiều ảnh) và nêu tên các kỹ thuật cụ thể trong từng nhóm.', '- Phép biến đổi hình học (Geometric transformations): lật (horizontal/vertical flip), xoay (rotation), cắt cúp ngẫu nhiên (random crop), co giãn (scaling), nghiêng (shearing)
- Biến đổi màu sắc và ánh sáng (Color space transformations): thay đổi độ sáng (brightness), độ tương phản (contrast), độ bão hòa (saturation), color jittering
- Thêm nhiễu và làm mờ: Gaussian noise, Gaussian blur, motion blur
- Các kỹ thuật hiện đại phối hợp nhiều ảnh: Cutout, Mixup, CutMix để tăng độ khái quát hóa', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('b2617936-1441-57d4-9168-ffda9a474140', 'Làm thế nào để bạn lựa chọn các phương pháp augmentation phù hợp cho một bài toán cụ thể?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày các tiêu chí lựa chọn: tính chất bài toán và dữ liệu thực tế, sự bảo toàn nhãn (label preservation), phân tích lỗi (error analysis) và thực nghiệm.', '- Dựa vào bài toán thực tế và miền dữ liệu (domain knowledge): các biến đổi phải mô phỏng lại những biến thể có thể gặp trong môi trường triển khai thực tế (ví dụ: camera ngoài trời cần chỉnh sáng, rung lắc)
- Đảm bảo tính bảo toàn nhãn (label preservation): phép biến đổi không được làm thay đổi ý nghĩa nhãn (ví dụ: với bài toán nhận diện chữ số, không thể lật ảnh số 6 thành số 9)
- Dựa trên phân tích lỗi (error analysis): nếu mô hình nhận diện kém ở góc nghiêng hoặc thiếu sáng thì bổ sung augmentation tương ứng
- Kiểm chứng bằng thực nghiệm (validation score): dùng các phương pháp như AutoAugment hoặc RandAugment để tìm cấu hình tối ưu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('da6acd11-aec8-5eae-abe5-13a0080a4c8d', 'Bạn biết những kiến trúc CNN phổ biến nào cho bài toán Image Classification? Hãy chia sẻ ưu điểm hoặc ứng dụng nổi bật của một vài kiến trúc trong số đó.', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Liệt kê các kiến trúc tiêu biểu theo dòng lịch sử hoặc mục đích sử dụng (hiệu năng cao vs tối ưu cho thiết bị biên), nêu điểm cốt lõi của 1-2 kiến trúc nổi bật như ResNet, MobileNet.', '- Các kiến trúc nền tảng và cổ điển: AlexNet, VGG (VGG16, VGG19)
- Kiến trúc với kết nối phần dư và đa nhánh: Inception (GoogLeNet), ResNet (giải quyết vanishing gradient với skip connections), DenseNet
- Các kiến trúc tối ưu tài nguyên cho Edge AI/mobile: MobileNet (dùng depthwise separable convolution), ShuffleNet, SqueezeNet
- Các kiến trúc tối ưu hiệu năng hiện đại: EfficientNet (áp dụng compound scaling để cân bằng depth, width, resolution)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('28ba7ff7-1ad6-5f71-b49c-6417324b3ac8', 'Transfer learning là gì và nguyên lý hoạt động của phương pháp này trong Deep Learning như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Nêu định nghĩa chuyển giao tri thức từ pre-trained model sang downstream task, giải thích cơ chế (feature extraction vs fine-tuning) và các chiến lược đóng băng (freeze) layer.', '- Transfer learning là phương pháp tận dụng tri thức (trọng số mạng) đã được huấn luyện từ một bài toán lớn (source task/dataset như ImageNet) để áp dụng vào bài toán mục tiêu (target task)
- Các layer đầu học các đặc trưng cấp thấp (low-level features) mang tính khái quát (cạnh, góc, texture), trong khi các layer cuối học đặc trưng ngữ nghĩa đặc thù của bài toán gốc
- Chiến lược Feature Extraction: đóng băng (freeze) toàn bộ mạng nền và chỉ huấn luyện lại classification head mới cho bài toán đích
- Chiến lược Fine-tuning: mở khóa một số layer trên cùng hoặc toàn bộ mạng để train tiếp với learning rate nhỏ nhằm tinh chỉnh đặc trưng phù hợp với miền dữ liệu mới', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('61cd6fcd-f2c2-5193-a951-43289900133f', 'Object detection là gì và bạn biết những họ kiến trúc nào thường được dùng để giải quyết bài toán này?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Định nghĩa mục tiêu bài toán (phân loại + định vị với bounding box), sau đó phân loại kiến trúc thành two-stage và one-stage cùng các đại diện cụ thể.', '- Object detection là bài toán xác định đồng thời đối tượng là gì (classification) và vị trí của đối tượng nằm ở đâu trong ảnh thông qua bounding box (localization)
- Two-stage detectors: đề xuất vùng ứng viên (region proposals) trước rồi phân loại/tinh chỉnh box, độ chính xác cao nhưng tốc độ chậm hơn (R-CNN, Fast R-CNN, Faster R-CNN)
- One-stage detectors: dự đoán trực tiếp class và bounding box trong một lượt forward pass, tốc độ nhanh, phù hợp real-time (YOLO series, SSD, RetinaNet)
- Anchor-free detectors: xác định đối tượng qua các điểm đặc trưng như tâm hoặc góc (CenterNet, FCOS)
- Transformer-based detectors: kiến trúc hiện đại dựa trên cơ chế self-attention loại bỏ hoàn toàn anchor và NMS (DETR, Deformable DETR)', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('902ed8e4-5f3f-51ca-9b63-78dd1fbd55ce', 'Object segmentation là gì và bạn biết những kiến trúc mạng nào chuyên dùng cho bài toán này?', 'IT', 'Data Scientist / AI', 'HARD', 'TECHNICAL', 'Phân biệt semantic segmentation và instance segmentation, nêu nguyên lý phân loại từng pixel và liệt kê các kiến trúc tiêu biểu như U-Net, Mask R-CNN.', '- Object segmentation là bài toán phân vùng chi tiết đối tượng ở mức độ từng điểm ảnh (pixel-level mask)
- Phân loại chính gồm: Semantic Segmentation (gán nhãn cho từng pixel thuộc class nào mà không phân biệt các thực thể khác nhau) và Instance Segmentation (phân biệt ranh giới của từng cá thể đối tượng cụ thể)
- Kiến trúc cho Semantic Segmentation: U-Net (với kiến trúc encoder-decoder và skip connections), FCN (Fully Convolutional Networks), DeepLab family
- Kiến trúc cho Instance Segmentation: Mask R-CNN (mở rộng từ Faster R-CNN bổ sung thêm nhánh dự đoán mask), YOLACT', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('490386c5-eea0-59f4-b6d2-0deba26a49b5', 'Trong Machine Learning, quy trình tổng quan để thực hiện bài toán Text Classification diễn ra như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Trình bày theo các bước chuẩn: tiền xử lý văn bản, trích xuất đặc trưng/vector hóa, lựa chọn và huấn luyện mô hình, cuối cùng là đánh giá kết quả.', '- Tiền xử lý văn bản (Text Preprocessing): làm sạch, chuyển chữ thường, loại bỏ stop words/ký tự đặc biệt, tokenization, stemming hoặc lemmatization
- Trích xuất đặc trưng / Vector hóa (Feature Extraction): chuyển văn bản thành vector số thông qua Bag of Words, TF-IDF, hoặc Word Embeddings (Word2Vec, GloVe), Transformer embeddings
- Huấn luyện mô hình (Model Training): sử dụng các thuật toán truyền thống (Naive Bayes, SVM, Logistic Regression, Random Forest) hoặc Deep Learning (CNN, LSTM, BERT)
- Đánh giá và tinh chỉnh (Evaluation & Tuning): đo lường bằng Accuracy, Precision, Recall, F1-Score tùy thuộc vào độ cân bằng của dữ liệu', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('015d0a8a-afcd-56cf-862b-66f236918420', 'Mô hình Bag of Words (BoW) là gì và làm thế nào để áp dụng nó vào bài toán phân loại văn bản?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa BoW (tần suất từ, bỏ qua thứ tự ngữ pháp), cách xây dựng từ điển (vocabulary), biểu diễn văn bản thành vector và đưa vào thuật toán phân loại.', '- Bag of Words (BoW) là phương pháp biểu diễn văn bản dựa trên tần suất xuất hiện của các từ mà bỏ qua thứ tự, ngữ pháp hay ngữ cảnh của chúng
- Cách xây dựng: tập hợp tất cả các từ duy nhất trong corpus để tạo thành một bộ từ điển (vocabulary) có kích thước cố định N
- Biểu diễn văn bản: mỗi tài liệu được biểu diễn bằng một vector N chiều, trong đó mỗi phần tử là số lần xuất hiện (word count) hoặc sự hiện diện (binary flag) của từ tương ứng
- Áp dụng vào phân loại: các vector BoW đóng vai trò là input features cho các mô hình phân loại như Naive Bayes, Logistic Regression hay SVM', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34a21154-d9bd-5f91-86ac-1488ec208f84', 'Mô hình Bag of Words có những ưu điểm và hạn chế nào khi áp dụng vào xử lý ngôn ngữ tự nhiên?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Chia rõ hai phần ưu điểm (đơn giản, nhanh, baseline tốt) và nhược điểm (mất ngữ cảnh, vector thưa, kích thước lớn, không bắt được từ đồng nghĩa).', '- Ưu điểm: Đơn giản, trực quan, dễ cài đặt và tốc độ tính toán nhanh; thường đóng vai trò là baseline rất tốt cho nhiều tác vụ phân loại văn bản
- Hạn chế về ngữ cảnh: Bỏ qua hoàn toàn thứ tự từ ngữ, không phân biệt được các câu có cùng từ nhưng khác ý nghĩa (ví dụ: ''not bad'' và ''bad'')
- Vấn đề vector thưa (sparsity) và số chiều lớn: Kích thước từ điển lớn dẫn đến ma trận dữ liệu rất thưa, tốn bộ nhớ và tăng chi phí tính toán
- Thiếu tính ngữ nghĩa (semantic meaning): Xem các từ là độc lập hoàn toàn, không nắm bắt được sự tương đồng giữa các từ đồng nghĩa (như ''xe hơi'' và ''ô tô'')', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6c278150-21d6-5db1-ac8d-12c119bf9566', 'N-gram là gì và kỹ thuật này giúp cải thiện những điểm yếu nào của mô hình Bag of Words truyền thống?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Định nghĩa N-gram (chuỗi N từ liên tiếp: unigram, bigram, trigram) và phân tích việc giữ lại ngữ cảnh cục bộ cũng như giải quyết vấn đề phủ định trong văn bản.', '- N-gram là chuỗi gồm N mục (thường là N từ hoặc N ký tự) liên tiếp nhau được trích xuất từ một đoạn văn bản
- Các loại phổ biến: unigram (N=1), bigram (N=2, ví dụ: ''trí tuệ''), trigram (N=3, ví dụ: ''trí tuệ nhân tạo'')
- Cải thiện hạn chế của BoW: lưu giữ được trật tự và ngữ cảnh cục bộ của các từ đứng cạnh nhau
- Giải quyết vấn đề đảo nghĩa và sắc thái: bắt được các cụm từ phủ định quan trọng như ''không thích'', ''rất tốt'' mà BoW đơn lẻ dễ làm mất thông tin', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('98c26b89-0bf0-5358-bb10-d29d456df6da', 'Khi sử dụng N-gram kết hợp với Bag of Words, bạn sẽ cân nhắc lựa chọn giá trị N như thế nào?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Phân tích bài toán đánh đổi (trade-off) giữa việc nắm bắt ngữ cảnh và sự bùng nổ kích thước từ điển/độ thưa dữ liệu, sau đó đưa ra giá trị N phổ biến trong thực tế.', '- Có sự đánh đổi lớn (trade-off): N càng lớn thì mô hình càng giữ được nhiều ngữ cảnh cụ thể, nhưng kích thước từ điển bùng nổ theo cấp số nhân và dữ liệu cực kỳ thưa (sparse)
- Nguy cơ overfitting: N quá lớn khiến các cụm từ trở nên quá đặc thù, hiếm khi lặp lại trong tập kiểm thử
- Trong thực tế: Thường kết hợp unigram và bigram (N=1 và N=2), đôi khi thêm trigram (N=3) là cấu hình cân bằng tốt nhất giữa hiệu năng và chi phí tính toán
- Cần kết hợp kỹ thuật lọc: Giới hạn max_features, lọc theo min_df (ngưỡng tần suất tối thiểu) để loại bỏ các n-gram rác', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('fc9cf5c7-deac-58eb-9fa5-4cfaa92151ec', 'TF-IDF là gì và tại sao chỉ số này lại hiệu quả hơn việc chỉ đếm tần suất xuất hiện của từ trong phân loại văn bản?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Giải thích công thức/ý nghĩa của hai thành phần TF và IDF, chỉ ra cơ chế phạt các từ phổ biến và làm nổi bật các từ mang tính đặc trưng của văn bản.', '- TF-IDF là chỉ số thống kê phản ánh mức độ quan trọng của một từ đối với một tài liệu cụ thể trong toàn bộ tập tài liệu (corpus)
- Term Frequency (TF): đo lường tần suất xuất hiện của từ trong tài liệu hiện tại
- Inverse Document Frequency (IDF): đo lường độ hiếm của từ trên toàn bộ corpus, gán trọng số thấp cho từ xuất hiện ở hầu hết mọi văn bản và trọng số cao cho từ hiếm
- Khắc phục nhược điểm của BoW đơn thuần: giảm thiểu ảnh hưởng của các từ xuất hiện quá nhiều nhưng ít thông tin phân loại (như ''the'', ''is'', ''và'', ''thì'')
- Làm nổi bật các từ khóa mang đặc thù phân biệt nội dung của văn bản cần phân loại', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('e1565971-d741-517d-90f0-8b621420adec', 'Khi sử dụng vector đặc trưng từ Bag of Words, bạn sẽ ưu tiên chọn những thuật toán Machine Learning nào để phân loại văn bản và vì sao?', 'IT', 'Data Scientist / AI', 'MEDIUM', 'TECHNICAL', 'Đặc điểm của vector BoW là số chiều lớn và rất thưa, từ đó liên hệ tới các thuật toán phù hợp như Naive Bayes, Linear SVM, Logistic Regression.', '- Multinomial Naive Bayes: xử lý rất tốt và nhanh với dữ liệu đếm tần suất dạng rời rạc, tính toán xác suất đơn giản, hiệu quả làm baseline
- Linear SVM (Support Vector Machine): cực kỳ hiệu quả với không gian nhiều chiều và thưa thớt như BoW, tìm được siêu phẳng phân cách tối ưu mà ít bị ảnh hưởng bởi curse of dimensionality
- Logistic Regression: mô hình tuyến tính đơn giản, huấn luyện nhanh, dễ diễn giải trọng số của từng từ đối với mỗi class và có thể dùng L1/L2 regularization để kiểm soát overfitting
- Thường không ưu tiên các mô hình cây phức tạp (như Random Forest, Decision Tree) vì chi phí huấn luyện trên ma trận thưa số chiều cao rất lớn', 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
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
('52323499-06e1-54d3-acff-47ce54adce6c', 'Hãy kể về một thất bại gần đây của bạn và bài học bạn rút ra.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('cc7a697f-fab9-5c97-88e0-9c6e5ac11773', 'Điều gì ở vị trí này khiến bạn hào hứng?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại -> liên hệ trải nghiệm trước đây -> nêu định hướng hoặc mong muốn sắp tới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('8f16d26f-b09d-5375-ab3c-ffc8c4b3e77b', 'Bạn hãy giới thiệu về bản thân.', 'IT', 'Chung', 'EASY', 'INTRO', 'Nói về hiện tại (vai trò, việc đang làm) -> quá khứ (học vấn, kinh nghiệm, thành tựu nổi bật) -> định hướng và lý do ứng tuyển vị trí này.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6a66b23b-d4eb-5f1e-bc23-c4a3f35f937a', 'Điểm mạnh lớn nhất của bạn là gì, và điểm nào bạn đang cần cải thiện?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu điểm mạnh kèm ví dụ chứng minh -> nêu điểm cần cải thiện một cách thật lòng -> nói rõ bạn đang làm gì để cải thiện.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('0590bf35-2ac0-5b8f-aca4-2de54e538e34', 'Mức lương mong muốn của bạn là bao nhiêu?', 'IT', 'Chung', 'EASY', 'INTRO', 'Đưa ra khoảng lương dựa trên tìm hiểu thị trường và kinh nghiệm của bạn -> giải thích căn cứ -> thể hiện sự cởi mở khi trao đổi về tổng đãi ngộ.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('89165f94-0804-5632-a91c-fc3d05b05438', 'Hãy kể về một lần khối lượng công việc trở nên quá tải. Bạn đã làm gì?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a1cf7469-73be-5077-aecd-ccb6de4184d3', 'Hãy kể về một lần bạn cần thông tin từ một người nhưng họ không phản hồi. Bạn đã làm gì?', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('98590e24-0855-509e-ad40-e1bd1bb506f7', 'Có quan điểm nào trong nghề mà bạn nghĩ khác với số đông không? Vì sao?', 'IT', 'Chung', 'HARD', 'INTRO', 'Nêu quan điểm của bạn -> lập luận và dẫn chứng từ trải nghiệm -> thừa nhận góc nhìn của số đông và giới hạn của quan điểm mình.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('ab79d5bc-14e4-55b3-b78a-9d93f98e9e47', 'Trong môi trường làm việc hoặc học tập hiện tại, bạn thấy điều gì đang chưa ổn và bạn sẽ cải thiện nó như thế nào?', 'IT', 'Chung', 'MEDIUM', 'SITUATIONAL', 'Phân tích tình huống -> nêu quyết định của bạn -> giải thích lý do và cách đo lường kết quả.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('34684467-cd20-5d05-a8ab-72cd4ffa2721', 'Hãy kể về một bài toán cần phân tích mà bạn từng giải quyết.', 'IT', 'Chung', 'MEDIUM', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('76bc761d-9d21-5090-b0a8-572c7e97d5c4', 'Theo bạn, điều tốt nhất và điều chưa tốt nhất ở công ty hiện tại (hoặc gần nhất) của bạn là gì?', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Nêu điều tốt cụ thể -> nêu điều chưa tốt một cách khách quan, không chê bai -> liên hệ với điều bạn tìm kiếm ở công việc mới.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('6a798f7e-1da0-50ef-99a1-e424015568cd', 'Nếu được hỏi, quản lý của bạn sẽ nhận xét gì về bạn?', 'IT', 'Chung', 'EASY', 'INTRO', 'Nêu hai, ba nhận xét kèm ví dụ thực tế -> có thể nhắc một góp ý bạn từng nhận -> nói về việc bạn đã cải thiện.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('845c20b5-c7ff-527b-b2e8-567dd04a649c', 'Bạn hãy giải thích công việc hoặc dự án gần nhất của mình cho một người không có nền tảng kỹ thuật.', 'IT', 'Chung', 'MEDIUM', 'INTRO', 'Bắt đầu bằng vấn đề mà dự án giải quyết -> giải thích bằng ví dụ đời thường, tránh thuật ngữ -> nêu giá trị mang lại cho người dùng.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('7d07ddb0-894a-541a-a0be-e18b3d099cba', 'Hãy kể về kỳ thực tập của bạn.', 'IT', 'Chung', 'EASY', 'INTRO', 'Giới thiệu nơi thực tập và vai trò -> những việc bạn đã làm và kết quả -> điều bạn học được và định hướng tiếp theo.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('a7c488fd-07c0-56ea-8ae4-75a243212c44', 'Hãy trình bày dự án khó nhất bạn từng làm và kiến trúc hệ thống của dự án đó.', 'IT', 'Backend Developer', 'HARD', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh và mục tiêu dự án -> vai trò của bạn -> mô tả kiến trúc, các thành phần chính và lý do chọn thiết kế -> kết quả và điều bạn sẽ làm khác.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
('952ee79d-5570-5504-953c-245bd8ee00ba', 'Ngoài kiến thức chuyên môn, bạn học được gì trong kỳ thực tập hoặc công việc đầu tiên?', 'IT', 'Chung', 'EASY', 'BEHAVIORAL', 'Kể theo STAR: bối cảnh -> nhiệm vụ của bạn -> hành động cụ thể bạn đã làm -> kết quả và bài học rút ra.', NULL, 'ACTIVE', '00000000-0000-0000-0000-000000000001'),
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
- Hành vi chi tiết khác nhau giữa các hệ điều hành như BSD và Linux', 'ACTIVE', '00000000-0000-0000-0000-000000000001');
