# Backend Spring Boot (Java 21). Build ngữ cảnh: thư mục backend/.
# Bước 1: build jar bằng Maven wrapper, tách bước tải dependency để tận dụng cache layer.
FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN chmod +x mvnw && ./mvnw -q -B dependency:go-offline
COPY src src
# Bỏ qua test: test chạy ở CI (cần Postgres); image chỉ đóng gói
RUN ./mvnw -q -B package -DskipTests

# Bước 2: image chạy chỉ gồm JRE và jar, chạy bằng user không phải root.
FROM eclipse-temurin:21-jre
RUN useradd --system --no-create-home app
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar
USER app
EXPOSE 8080
# Render đặt PORT; chạy đúng 1 instance vì hàng đợi chấm nằm trong bộ nhớ (ADR-001)
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75 -Duser.timezone=UTC"
ENTRYPOINT ["sh", "-c", "exec java -Dserver.port=${PORT:-8080} -jar app.jar"]
