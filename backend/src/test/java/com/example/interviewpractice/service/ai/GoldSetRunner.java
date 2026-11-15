package com.example.interviewpractice.service.ai;

import static org.mockito.Mockito.mock;

import java.io.BufferedWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;

import com.example.interviewpractice.config.AiProperties;
import com.example.interviewpractice.config.GeminiHttpConfig;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.service.scoring.CriterionScore;
import com.example.interviewpractice.service.scoring.QuoteValidator;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/**
 * Chạy bộ chấm thật (PromptBuilder, Gemini, LlmScorer kèm kiểm trích dẫn) trên bộ dữ liệu chuẩn #159 và ghi kết quả
 * theo định dạng file nhãn để đo bằng scripts/gold/metrics.py. Gọi Gemini thật nên chỉ chạy khi đặt GOLD_FILE.
 *
 * Biến môi trường: GOLD_FILE (đường dẫn gold_v1.jsonl), GOLD_OUT_DIR (thư mục ghi kết quả), GEMINI_API_KEY,
 * GOLD_SPLIT (mặc định calibration; chỉ dùng holdout cho lần đo chốt), GOLD_RUNS (mặc định 1),
 * GEMINI_LLM_MODEL (mặc định gemini-2.5-flash).
 *
 * Chạy: ./mvnw test -Dtest=GoldSetRunner -Dsurefire.failIfNoSpecifiedTests=false
 */
@EnabledIfEnvironmentVariable(named = "GOLD_FILE", matches = ".+")
class GoldSetRunner {

    private static final int MAX_ATTEMPTS = 4;
    private static final long BACKOFF_MS = 20_000;

    @Test
    void chamBoDuLieuChuan() throws Exception {
        String split = env("GOLD_SPLIT", "calibration");
        int runs = Integer.parseInt(env("GOLD_RUNS", "1"));
        String model = env("GEMINI_LLM_MODEL", "gemini-2.5-flash");
        Path outDir = Path.of(env("GOLD_OUT_DIR", "."));
        Files.createDirectories(outDir);

        AiProperties ai = new AiProperties(
                new AiProperties.Gemini(System.getenv("GEMINI_API_KEY"), "https://generativelanguage.googleapis.com",
                        model, model),
                new AiProperties.Fpt("unused"), new AiProperties.Stt(Duration.ofSeconds(15)),
                new AiProperties.Llm(Duration.ofSeconds(60), 0.2));
        JsonMapper json = new JsonMapper();
        // Không có CSDL nên bỏ ghi api_usages
        GeminiLlmClient client = new GeminiLlmClient(new GeminiHttpConfig().geminiLlmRestClient(ai), json, ai,
                mock(ApiUsageRecorder.class));
        QuoteValidator quotes = new QuoteValidator();
        LlmScorer scorer = new LlmScorer(client, new LlmResultValidator(json), quotes);
        PromptBuilder prompts = new PromptBuilder();

        List<JsonNode> items = Files.readAllLines(Path.of(System.getenv("GOLD_FILE")), StandardCharsets.UTF_8)
                .stream().filter(line -> !line.isBlank()).map(json::readTree)
                .filter(node -> split.equals("all") || split.equals(node.path("split").asString()))
                .toList();

        for (int run = 1; run <= runs; run++) {
            Path out = outDir.resolve(model + "_" + split + "_lan" + run + ".jsonl");
            int failed = 0;
            try (BufferedWriter writer = Files.newBufferedWriter(out, StandardCharsets.UTF_8)) {
                for (JsonNode item : items) {
                    Map<String, Object> row = scoreOne(item, scorer, prompts);
                    if (row == null) {
                        failed++;
                        // Hỏng ngay từ đầu thường là sai khóa API hoặc sai model: dừng thay vì chờ hết 96 câu
                        if (failed == 3 && failed == items.indexOf(item) + 1) {
                            throw new IllegalStateException("3 câu đầu đều lỗi, kiểm tra GEMINI_API_KEY và model");
                        }
                        continue;
                    }
                    writer.write(json.writeValueAsString(row));
                    writer.newLine();
                    // Ghi ngay để xem được tiến độ khi đang chạy
                    writer.flush();
                }
            }
            System.out.printf("Lần %d: %d câu, %d lỗi -> %s%n", run, items.size(), failed, out);
        }
    }

    private static Map<String, Object> scoreOne(JsonNode item, LlmScorer scorer, PromptBuilder prompts)
            throws InterruptedException {
        String id = item.path("id").asString();
        Question.Type type = Question.Type.valueOf(item.path("question_type").asString());
        String transcript = item.path("transcript").asString();
        JsonNode reference = item.path("reference_answer");
        LlmRequest request = prompts.build(UUID.randomUUID(), type, item.path("question").asString(),
                reference.isString() ? reference.asString() : null, transcript);

        for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
            try {
                LlmResult result = scorer.score(request, transcript);
                Map<String, Integer> scores = new LinkedHashMap<>();
                int quoteInvalid = 0;
                for (CriterionScore c : result.criteria()) {
                    scores.put(c.code().name(), c.score());
                    quoteInvalid += c.quoteInvalid() ? 1 : 0;
                }
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("id", id);
                row.put("scores", scores);
                row.put("off_topic", result.offTopic());
                row.put("quote_invalid", quoteInvalid);
                row.put("word_count", transcript.trim().split("\\s+").length);
                return row;
            } catch (LlmException e) {
                // Thường do giới hạn tần suất của Gemini: chờ rồi thử lại
                System.out.printf("%s lần thử %d lỗi: %s%n", id, attempt, e.getMessage());
                if (attempt < MAX_ATTEMPTS) {
                    Thread.sleep(BACKOFF_MS * attempt);
                }
            }
        }
        return null;
    }

    private static String env(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? fallback : value;
    }
}
