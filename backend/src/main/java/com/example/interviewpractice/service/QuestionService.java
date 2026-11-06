package com.example.interviewpractice.service;

import java.util.UUID;
import java.util.random.RandomGenerator;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.dto.PageResponse;
import com.example.interviewpractice.dto.QuestionDto;
import com.example.interviewpractice.entity.Question;
import com.example.interviewpractice.exception.ApiException;
import com.example.interviewpractice.repository.QuestionRepository;
import com.example.interviewpractice.repository.QuestionSpecifications;

/** Tra cứu câu hỏi cho người luyện tập (UC3): chỉ câu ACTIVE, kèm câu vị trí Chung của ngành. */
@Service
@Transactional(readOnly = true)
public class QuestionService {

    private final QuestionRepository questions;
    private final RandomGenerator random;

    public QuestionService(QuestionRepository questions, RandomGenerator random) {
        this.questions = questions;
        this.random = random;
    }

    public PageResponse<QuestionDto> search(String industry, String position, Question.Level level,
            Question.Type type, String keyword, int page, int size) {
        Specification<Question> spec = filter(industry, position, level);
        spec = QuestionSpecifications.andIf(spec, type != null ? QuestionSpecifications.hasType(type) : null);
        spec = QuestionSpecifications.andIf(spec, keywordSpec(keyword));
        return PageResponse.from(
                questions.findAll(spec, PageRequest.of(page, size, QuestionSpecifications.NEWEST_FIRST)),
                QuestionDto::from);
    }

    public QuestionDto random(String industry, String position, Question.Level level) {
        Specification<Question> spec = filter(industry, position, level);
        long total = questions.count(spec);
        if (total == 0) {
            throw notFound();
        }
        // Chọn một vị trí ngẫu nhiên trong tập đã lọc; số dòng thay đổi giữa hai truy vấn thì có thể rỗng
        int offset = random.nextInt((int) Math.min(total, Integer.MAX_VALUE));
        return questions.findAll(spec, PageRequest.of(offset, 1, QuestionSpecifications.NEWEST_FIRST))
                .stream().findFirst()
                // Có dòng bị ẩn giữa lúc đếm và lúc lấy: lấy dòng đầu thay vì trả 404 khi bộ lọc vẫn còn câu
                .or(() -> questions.findAll(spec, PageRequest.of(0, 1, QuestionSpecifications.NEWEST_FIRST))
                        .stream().findFirst())
                .map(QuestionDto::from).orElseThrow(QuestionService::notFound);
    }

    public QuestionDto get(UUID id) {
        return questions.findById(id)
                .filter(q -> q.getStatus() == Question.Status.ACTIVE)
                .map(QuestionDto::from)
                .orElseThrow(QuestionService::notFound);
    }

    /** ACTIVE, rồi ngành/vị trí (kèm Chung khi có ngành) và mức độ. */
    private static Specification<Question> filter(String industry, String position, Question.Level level) {
        Specification<Question> spec = QuestionSpecifications.hasStatus(Question.Status.ACTIVE);
        if (industry != null) {
            spec = spec.and(QuestionSpecifications.hasIndustry(industry));
        }
        if (position != null) {
            spec = spec.and(QuestionSpecifications.hasPosition(position, industry != null));
        }
        if (level != null) {
            spec = spec.and(QuestionSpecifications.hasLevel(level));
        }
        return spec;
    }

    static Specification<Question> keywordSpec(String keyword) {
        return keyword == null || keyword.isBlank() ? null : QuestionSpecifications.contentContains(keyword.trim());
    }

    private static ApiException notFound() {
        return new ApiException(HttpStatus.NOT_FOUND, "NOT_FOUND", "Không tìm thấy câu hỏi phù hợp");
    }
}
