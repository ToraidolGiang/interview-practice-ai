package com.example.interviewpractice.service.ai;

import java.math.BigDecimal;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.example.interviewpractice.entity.ApiUsage;
import com.example.interviewpractice.entity.ApiUsage.Provider;
import com.example.interviewpractice.repository.ApiUsageRepository;
import com.example.interviewpractice.repository.PracticeSessionRepository;

/** Ghi nhật ký mỗi lần gọi dịch vụ AI (kể cả lần lỗi); việc ghi lỗi không được làm hỏng luồng chấm điểm. */
@Component
public class ApiUsageRecorder {

    private static final Logger log = LoggerFactory.getLogger(ApiUsageRecorder.class);

    private final ApiUsageRepository usages;
    private final PracticeSessionRepository sessions;

    public ApiUsageRecorder(ApiUsageRepository usages, PracticeSessionRepository sessions) {
        this.usages = usages;
        this.sessions = sessions;
    }

    /** Ghi một dòng api_usages; usageUnit có thể null khi nhà cung cấp không trả số liệu. */
    @Transactional
    public void record(UUID sessionId, Provider provider, long latencyMs, BigDecimal usageUnit) {
        try {
            ApiUsage usage = new ApiUsage();
            usage.setSession(sessions.getReferenceById(sessionId));
            usage.setProvider(provider);
            usage.setLatencyMs((int) Math.min(latencyMs, Integer.MAX_VALUE));
            usage.setUsageUnit(usageUnit);
            usages.save(usage);
        } catch (RuntimeException e) {
            // Nhật ký chỉ phục vụ thống kê: lỗi ghi chỉ cảnh báo, không chặn việc chấm điểm
            log.warn("Không ghi được api_usages cho phiên {} ({})", sessionId, provider, e);
        }
    }
}
