package com.example.interviewpractice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.PracticeSessionRepository;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.security.JwtService;

import tools.jackson.databind.json.JsonMapper;

/**
 * Cần Postgres như BackendApplicationTests; chạy toàn bộ chuỗi security, controller, service, CSDL thật.
 * Dữ liệu seed V2 (ngành IT) được đọc nhưng không sửa; câu hỏi tạo thêm nằm ở Marketing / Chuyên viên SEO
 * với nội dung có UUID và được dọn sau mỗi test.
 */
@SpringBootTest
@AutoConfigureMockMvc
class QuestionApiIntegrationTest {

    private static final String INDUSTRY = "Marketing";
    private static final String POSITION = "Chuyên viên SEO";

    @Autowired
    private MockMvc mvc;

    @Autowired
    private JdbcTemplate jdbc;

    @Autowired
    private JsonMapper json;

    @Autowired
    private UserRepository users;

    @Autowired
    private QuestionRepository questions;

    @Autowired
    private PracticeSessionRepository sessions;

    @Autowired
    private JwtService jwtService;

    private User admin;
    private User candidate;
    private String adminToken;
    private String candidateToken;

    @BeforeEach
    void createUsers() {
        admin = newUser(User.Role.ADMIN);
        candidate = newUser(User.Role.CANDIDATE);
        adminToken = "Bearer " + jwtService.generate(admin);
        candidateToken = "Bearer " + jwtService.generate(candidate);
    }

    @AfterEach
    void cleanUp() {
        // Thứ tự theo khóa ngoại: phiên, audit, câu hỏi, người dùng
        jdbc.update("delete from practice_sessions where user_id in (?, ?)", admin.getId(), candidate.getId());
        jdbc.update("delete from practice_sessions where question_id in "
                + "(select id from questions where created_by = ?)", admin.getId());
        jdbc.update("delete from audit_logs where admin_id = ?", admin.getId());
        jdbc.update("delete from questions where created_by = ?", admin.getId());
        jdbc.update("delete from users where id in (?, ?)", admin.getId(), candidate.getId());
    }

    private User newUser(User.Role role) {
        User user = new User();
        user.setFullName("Người dùng kiểm thử");
        user.setEmail("q-api-" + UUID.randomUUID() + "@example.com");
        user.setPasswordHash("!khong-dang-nhap-bang-mat-khau");
        user.setRole(role);
        return users.save(user);
    }

    private String body(String content, String industry, String position, String referenceAnswer)
            throws Exception {
        return json.writeValueAsString(java.util.Map.of("content", content, "industry", industry,
                "position", position, "level", "MEDIUM", "questionType", "TECHNICAL",
                "answerHint", "gợi ý", "referenceAnswer", referenceAnswer));
    }

    private ResultActions create(String content, String industry, String position) throws Exception {
        return mvc.perform(post("/admin/questions").header("Authorization", adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body(content, industry, position, "ý chính 1; ý chính 2").getBytes(StandardCharsets.UTF_8)));
    }

    private UUID createAndGetId(String content) throws Exception {
        MvcResult result = create(content, INDUSTRY, POSITION).andExpect(status().isCreated()).andReturn();
        return UUID.fromString(json.readTree(result.getResponse().getContentAsString(StandardCharsets.UTF_8))
                .get("id").asString());
    }

    private static String uniqueContent(String prefix) {
        return prefix + " " + UUID.randomUUID();
    }

    private long count(String where, Object... args) {
        Long n = jdbc.queryForObject("select count(*) from questions where " + where, Long.class, args);
        return n == null ? 0 : n;
    }

    // ---- xác thực và phân quyền

    @Test
    void requestsWithoutTokenGet401() throws Exception {
        mvc.perform(get("/questions")).andExpect(status().isUnauthorized());
        mvc.perform(get("/questions/random")).andExpect(status().isUnauthorized());
        mvc.perform(get("/admin/questions")).andExpect(status().isUnauthorized());
        mvc.perform(post("/admin/questions").contentType(MediaType.APPLICATION_JSON).content("{}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void candidateCannotUseAdminEndpoints() throws Exception {
        UUID id = createAndGetId(uniqueContent("Câu hỏi quyền"));

        mvc.perform(get("/admin/questions").header("Authorization", candidateToken))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.code").value("FORBIDDEN"));
        mvc.perform(post("/admin/questions").header("Authorization", candidateToken)
                        .contentType(MediaType.APPLICATION_JSON).content("{}"))
                .andExpect(status().isForbidden());
        mvc.perform(put("/admin/questions/" + id).header("Authorization", candidateToken)
                        .contentType(MediaType.APPLICATION_JSON).content("{}"))
                .andExpect(status().isForbidden());
        mvc.perform(delete("/admin/questions/" + id).header("Authorization", candidateToken))
                .andExpect(status().isForbidden());
        assertEquals(1, count("id = ?", id));
    }

    // ---- tra cứu cho người luyện tập

    @Test
    void positionFilterIncludesCommonQuestionsOfTheSameIndustryOnly() throws Exception {
        String position = "Backend Developer";
        long withCommon = count("status = 'ACTIVE' and industry = 'IT' and position in (?, 'Chung')", position);
        long exactOnly = count("status = 'ACTIVE' and position = ?", position);
        long commonOnly = count("status = 'ACTIVE' and industry = 'IT' and position = 'Chung'");
        assumeTrue(exactOnly > 0 && commonOnly > 0, "cần dữ liệu seed V2");

        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("industry", "IT").param("position", position).param("size", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(withCommon));
        // Không có industry thì chỉ khớp đúng vị trí, không thêm Chung
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("position", position).param("size", "1"))
                .andExpect(jsonPath("$.totalElements").value(exactOnly));
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("industry", "IT").param("position", "Chung").param("size", "1"))
                .andExpect(jsonPath("$.totalElements").value(commonOnly));
        // Chung của ngành khác không lẫn vào
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("industry", "Marketing").param("position", position).param("size", "1"))
                .andExpect(jsonPath("$.totalElements").value(
                        count("status = 'ACTIVE' and industry = 'Marketing' and position in (?, 'Chung')",
                                position)));
    }

    @Test
    void listPaginatesWithCorrectTotalsAndNeverExposesReferenceAnswer() throws Exception {
        long active = count("status = 'ACTIVE'");
        assumeTrue(active > 0, "cần dữ liệu seed V2");

        mvc.perform(get("/questions").header("Authorization", candidateToken).param("size", "5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content.length()").value(5))
                .andExpect(jsonPath("$.totalElements").value(active))
                .andExpect(jsonPath("$.totalPages").value((active + 4) / 5))
                .andExpect(jsonPath("$.content[0].referenceAnswer").doesNotExist())
                .andExpect(jsonPath("$.content[0].createdBy").exists());

        // Hai trang liên tiếp không trùng phần tử
        String first = mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("size", "5").param("page", "0")).andReturn().getResponse()
                .getContentAsString(StandardCharsets.UTF_8);
        String second = mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("size", "5").param("page", "1")).andReturn().getResponse()
                .getContentAsString(StandardCharsets.UTF_8);
        List<String> ids = new ArrayList<>();
        json.readTree(first).get("content").forEach(n -> ids.add(n.get("id").asString()));
        json.readTree(second).get("content").forEach(n -> ids.add(n.get("id").asString()));
        assertEquals(10, ids.stream().distinct().count());
    }

    @Test
    void randomReturnsAQuestionMatchingTheFilterAnd404WhenNoneMatch() throws Exception {
        assumeTrue(count("status = 'ACTIVE' and industry = 'IT' and position = 'Backend Developer'") > 0,
                "cần dữ liệu seed V2");

        for (int i = 0; i < 5; i++) {
            mvc.perform(get("/questions/random").header("Authorization", candidateToken)
                            .param("industry", "IT").param("position", "Backend Developer"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.industry").value("IT"))
                    .andExpect(jsonPath("$.status").value("ACTIVE"))
                    .andExpect(jsonPath("$.referenceAnswer").doesNotExist());
        }

        assumeTrue(count("industry = 'Nhân sự'") == 0);
        mvc.perform(get("/questions/random").header("Authorization", candidateToken)
                        .param("industry", "Nhân sự"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.code").value("NOT_FOUND"));
    }

    @Test
    void keywordIsCaseInsensitiveAndTreatsPercentAndUnderscoreAsPlainText() throws Exception {
        String token = UUID.randomUUID().toString();
        UUID id = createAndGetId("Tỷ lệ 100% hoàn thành " + token);

        // Không phân biệt hoa thường
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("industry", INDUSTRY).param("position", POSITION)
                        .param("keyword", token.toUpperCase()))
                .andExpect(jsonPath("$.totalElements").value(1))
                .andExpect(jsonPath("$.content[0].id").value(id.toString()));
        // '%' là ký tự thường: "100%" khớp, "10%" không khớp "100%"
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("keyword", "100% hoàn thành " + token))
                .andExpect(jsonPath("$.totalElements").value(1));
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("keyword", "1%0 hoàn thành " + token))
                .andExpect(jsonPath("$.totalElements").value(0));
        // '_' không phải ký tự đại diện
        mvc.perform(get("/questions").header("Authorization", candidateToken)
                        .param("keyword", "T_ lệ 100% hoàn thành " + token))
                .andExpect(jsonPath("$.totalElements").value(0));
    }

    // ---- quản trị

    @Test
    void createReturnsAdminViewRecordsCreatorAndAudit() throws Exception {
        String content = uniqueContent("Giải thích SEO on-page");

        MvcResult result = create(content, INDUSTRY, POSITION)
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.createdBy").value(admin.getId().toString()))
                .andExpect(jsonPath("$.referenceAnswer").value("ý chính 1; ý chính 2"))
                .andExpect(jsonPath("$.status").value("ACTIVE"))
                .andReturn();
        UUID id = UUID.fromString(json.readTree(result.getResponse().getContentAsString(StandardCharsets.UTF_8))
                .get("id").asString());

        assertEquals(1, jdbc.queryForObject(
                "select count(*) from audit_logs where entity_id = ? and action = 'CREATE' "
                        + "and entity_type = 'QUESTION' and admin_id = ?", Long.class, id, admin.getId()));
        // Người luyện tập xem được nhưng không thấy đáp án tham chiếu
        mvc.perform(get("/questions/" + id).header("Authorization", candidateToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").value(content))
                .andExpect(jsonPath("$.referenceAnswer").doesNotExist());
    }

    @Test
    void duplicateContentInSamePositionIs409ButAllowedInAnotherPosition() throws Exception {
        String content = uniqueContent("Câu hỏi trùng");
        createAndGetId(content);

        create(content, INDUSTRY, POSITION)
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("DUPLICATE_QUESTION"));
        // Khoảng trắng đầu cuối được bỏ trước khi so trùng
        create("  " + content + "  ", INDUSTRY, POSITION)
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("DUPLICATE_QUESTION"));
        create(content, INDUSTRY, "Digital Marketing").andExpect(status().isCreated());
        assertEquals(2, count("content = ?", content));
    }

    @Test
    void updateChangesFieldsAndRejectsDuplicateOfAnotherQuestion() throws Exception {
        String first = uniqueContent("Câu hỏi thứ nhất");
        String second = uniqueContent("Câu hỏi thứ hai");
        createAndGetId(first);
        UUID secondId = createAndGetId(second);

        mvc.perform(put("/admin/questions/" + secondId).header("Authorization", adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body(first, INDUSTRY, POSITION, "x").getBytes(StandardCharsets.UTF_8)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("DUPLICATE_QUESTION"));

        String edited = uniqueContent("Câu hỏi đã sửa");
        mvc.perform(put("/admin/questions/" + secondId).header("Authorization", adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body(edited, INDUSTRY, POSITION, "đáp án mới").getBytes(StandardCharsets.UTF_8)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").value(edited))
                .andExpect(jsonPath("$.referenceAnswer").value("đáp án mới"))
                .andExpect(jsonPath("$.createdBy").value(admin.getId().toString()));
        assertEquals(1, jdbc.queryForObject(
                "select count(*) from audit_logs where entity_id = ? and action = 'UPDATE'", Long.class, secondId));

        mvc.perform(put("/admin/questions/" + UUID.randomUUID()).header("Authorization", adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body(edited, INDUSTRY, POSITION, "x").getBytes(StandardCharsets.UTF_8)))
                .andExpect(status().isNotFound());
    }

    @Test
    void invalidBodiesAre400WithFieldErrors() throws Exception {
        create(uniqueContent("Sai vị trí"), INDUSTRY, "Backend Developer")
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[0].field").value("position"));
        create(uniqueContent("Sai ngành"), "Y tế", "Chung")
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("industry"));
        create("   ", INDUSTRY, POSITION)
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("content"));
        mvc.perform(post("/admin/questions").header("Authorization", adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"content\":\"x\",\"industry\":\"Marketing\",\"position\":\"Chung\","
                                + "\"level\":\"IMPOSSIBLE\",\"questionType\":\"TECHNICAL\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
        assertEquals(0, count("created_by = ?", admin.getId()));
    }

    @Test
    void deletingUnusedQuestionRemovesItForGood() throws Exception {
        UUID id = createAndGetId(uniqueContent("Câu hỏi chưa dùng"));

        mvc.perform(delete("/admin/questions/" + id).header("Authorization", adminToken))
                .andExpect(status().isNoContent());

        assertEquals(0, count("id = ?", id));
        assertEquals(1, jdbc.queryForObject(
                "select count(*) from audit_logs where entity_id = ? and action = 'DELETE'", Long.class, id));
        mvc.perform(delete("/admin/questions/" + id).header("Authorization", adminToken))
                .andExpect(status().isNotFound());
    }

    @Test
    void deletingQuestionUsedInASessionHidesItInstead() throws Exception {
        String token = UUID.randomUUID().toString();
        UUID id = createAndGetId("Câu hỏi đã luyện tập " + token);
        PracticeSession session = new PracticeSession();
        session.setUser(candidate);
        session.setQuestion(questions.getReferenceById(id));
        sessions.save(session);

        mvc.perform(delete("/admin/questions/" + id).header("Authorization", adminToken))
                .andExpect(status().isNoContent());

        assertEquals("HIDDEN", jdbc.queryForObject("select status from questions where id = ?", String.class, id));
        assertEquals(1, jdbc.queryForObject(
                "select count(*) from audit_logs where entity_id = ? and action = 'DELETE'", Long.class, id));
        // Biến mất với người luyện tập ở cả ba endpoint
        mvc.perform(get("/questions/" + id).header("Authorization", candidateToken))
                .andExpect(status().isNotFound());
        mvc.perform(get("/questions").header("Authorization", candidateToken).param("keyword", token))
                .andExpect(jsonPath("$.totalElements").value(0));
        // Admin vẫn thấy khi lọc HIDDEN
        mvc.perform(get("/admin/questions").header("Authorization", adminToken)
                        .param("status", "HIDDEN").param("keyword", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalElements").value(1))
                .andExpect(jsonPath("$.content[0].id").value(id.toString()))
                .andExpect(jsonPath("$.content[0].referenceAnswer").value("ý chính 1; ý chính 2"));
        mvc.perform(get("/admin/questions").header("Authorization", adminToken)
                        .param("status", "ACTIVE").param("keyword", token))
                .andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    void parallelCreatesOfTheSameQuestionYieldExactlyOneWinner() throws Exception {
        String content = uniqueContent("Câu hỏi tạo song song");
        int attempts = 6;
        ExecutorService pool = Executors.newFixedThreadPool(attempts);
        CountDownLatch start = new CountDownLatch(1);
        List<Future<Integer>> futures = new ArrayList<>();
        try {
            for (int i = 0; i < attempts; i++) {
                futures.add(pool.submit(() -> {
                    start.await();
                    return create(content, INDUSTRY, POSITION).andReturn().getResponse().getStatus();
                }));
            }
            start.countDown();
            List<Integer> statuses = new ArrayList<>();
            for (Future<Integer> future : futures) {
                statuses.add(future.get());
            }
            assertEquals(1, statuses.stream().filter(s -> s == 201).count(), statuses.toString());
            assertEquals(attempts - 1, statuses.stream().filter(s -> s == 409).count(), statuses.toString());
        } finally {
            pool.shutdownNow();
        }
        assertEquals(1, count("content = ?", content));
        assertEquals(1, count("created_by = ?", admin.getId()));
    }

    @Test
    void adminListSupportsStatusFilterAndRejectsBadParameters() throws Exception {
        mvc.perform(get("/admin/questions").header("Authorization", adminToken).param("status", "DELETED"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("status"));
        mvc.perform(get("/admin/questions").header("Authorization", adminToken).param("size", "101"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[0].field").value("size"));
        mvc.perform(get("/questions").header("Authorization", candidateToken).param("level", "FOO"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
        mvc.perform(get("/questions/khong-phai-uuid").header("Authorization", candidateToken))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/questions/" + UUID.randomUUID()).header("Authorization", candidateToken))
                .andExpect(status().isNotFound());
    }
}
