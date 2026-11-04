package com.example.interviewpractice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.JwtService;
import com.example.interviewpractice.service.storage.AudioStorage;

/**
 * Xác minh (R4) lỗi multipart qua Tomcat thật, không phải MockMvc: giới hạn kích thước chỉ do Tomcat/Spring
 * multipart resolver áp dụng, MockMvc không kích hoạt nên không chứng minh được advice có bắt lỗi này.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class MultipartErrorHandlingTest {

    private static final String BOUNDARY = "----test-boundary";

    @LocalServerPort
    private int port;

    @Autowired
    private JdbcTemplate jdbc;
    @Autowired
    private UserRepository users;
    @Autowired
    private QuestionRepository questions;
    @Autowired
    private PracticeSessionRepository sessions;
    @Autowired
    private JwtService jwtService;

    @MockitoBean
    private AudioStorage storage;

    private User user;
    private PracticeSession session;
    private String token;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setFullName("Người dùng kiểm thử");
        user.setEmail("multipart-" + UUID.randomUUID() + "@example.com");
        user.setPasswordHash("!khong-dang-nhap-bang-mat-khau");
        user.setRole(User.Role.CANDIDATE);
        user = users.save(user);
        Question q = new Question();
        q.setContent("Câu hỏi multipart " + UUID.randomUUID());
        q.setIndustry("Marketing");
        q.setPosition("Chuyên viên SEO");
        q.setLevel(Question.Level.MEDIUM);
        q.setQuestionType(Question.Type.BEHAVIORAL);
        q.setCreatedBy(user);
        q = questions.save(q);
        session = new PracticeSession();
        session.setUser(user);
        session.setQuestion(q);
        session = sessions.save(session);
        token = "Bearer " + jwtService.generate(user);
    }

    @AfterEach
    void cleanUp() {
        jdbc.update("delete from practice_sessions where user_id = ?", user.getId());
        jdbc.update("delete from questions where created_by = ?", user.getId());
        jdbc.update("delete from users where id = ?", user.getId());
    }

    // Socket thô vì Tomcat đóng kết nối khi body quá lớn còn đang được gửi: HttpClient của JDK ném lỗi giải mã
    // chunked dù server đã trả phản hồi. Đọc những gì server gửi về và kiểm tra dòng trạng thái + body.
    private String post(byte[] body) throws Exception {
        String head = "POST /api/practice-sessions/" + session.getId() + "/answer HTTP/1.1\r\nHost: localhost:" + port
                + "\r\nAuthorization: " + token + "\r\nContent-Type: multipart/form-data; boundary=" + BOUNDARY
                + "\r\nContent-Length: " + body.length + "\r\nConnection: close\r\n\r\n";
        try (Socket socket = new Socket("localhost", port)) {
            socket.setSoTimeout(15000);
            Thread writer = new Thread(() -> {
                try {
                    OutputStream out = socket.getOutputStream();
                    out.write(head.getBytes(StandardCharsets.UTF_8));
                    out.write(body);
                    out.flush();
                } catch (IOException ignored) {
                    // Server có thể đóng kết nối sớm; phần đọc phản hồi bên dưới quyết định kết quả
                }
            });
            writer.start();
            ByteArrayOutputStream response = new ByteArrayOutputStream();
            byte[] buffer = new byte[4096];
            try {
                int n;
                while ((n = socket.getInputStream().read(buffer)) != -1) {
                    response.write(buffer, 0, n);
                }
            } catch (IOException ignored) {
                // Kết nối bị reset sau khi server đã trả phản hồi: giữ phần đã nhận
            }
            writer.join();
            return response.toString(StandardCharsets.UTF_8);
        }
    }

    private static byte[] multipart(String part, int fileBytes) throws Exception {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        if (part != null) {
            out.write(("--" + BOUNDARY + "\r\nContent-Disposition: form-data; name=\"" + part
                    + "\"; filename=\"a.webm\"\r\nContent-Type: audio/webm\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            out.write(new byte[fileBytes]);
            out.write("\r\n".getBytes(StandardCharsets.UTF_8));
        }
        out.write(("--" + BOUNDARY + "\r\nContent-Disposition: form-data; name=\"durationSeconds\"\r\n\r\n30\r\n--"
                + BOUNDARY + "--\r\n").getBytes(StandardCharsets.UTF_8));
        return out.toByteArray();
    }

    @Test
    void oversizedUploadReturnsStandardValidationError() throws Exception {
        String response = post(multipart("audio", 12 * 1024 * 1024));

        assertTrue(response.startsWith("HTTP/1.1 400"), response);
        assertTrue(response.contains("\"code\":\"VALIDATION_ERROR\""), response);
        assertEquals("CREATED", jdbc.queryForObject("select status from practice_sessions where id = ?",
                String.class, session.getId()));
    }

    @Test
    void missingAudioPartReturnsStandardValidationError() throws Exception {
        String response = post(multipart(null, 0));

        assertTrue(response.startsWith("HTTP/1.1 400"), response);
        assertTrue(response.contains("\"code\":\"VALIDATION_ERROR\""), response);
        assertTrue(response.contains("audio"), response);
    }
}
