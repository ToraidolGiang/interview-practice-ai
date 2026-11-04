package com.example.interviewpractice.service.ai;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import com.example.interviewpractice.entity.ApiUsage;
import com.example.interviewpractice.entity.ApiUsage.Provider;
import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.repository.ApiUsageRepository;
import com.example.interviewpractice.repository.PracticeSessionRepository;

class ApiUsageRecorderTest {

    private final ApiUsageRepository usages = mock(ApiUsageRepository.class);
    private final PracticeSessionRepository sessions = mock(PracticeSessionRepository.class);
    private final ApiUsageRecorder recorder = new ApiUsageRecorder(usages, sessions);

    @Test
    void recordSavesProviderLatencyAndUsageUnit() {
        UUID sessionId = UUID.randomUUID();
        PracticeSession ref = new PracticeSession();
        when(sessions.getReferenceById(sessionId)).thenReturn(ref);

        recorder.record(sessionId, Provider.STT, 1234, BigDecimal.TEN);

        ArgumentCaptor<ApiUsage> captor = ArgumentCaptor.forClass(ApiUsage.class);
        verify(usages).save(captor.capture());
        assertEquals(Provider.STT, captor.getValue().getProvider());
        assertEquals(1234, captor.getValue().getLatencyMs());
        assertEquals(BigDecimal.TEN, captor.getValue().getUsageUnit());
        assertEquals(ref, captor.getValue().getSession());
    }

    @Test
    void recordFailureDoesNotPropagate() {
        when(usages.save(any())).thenThrow(new IllegalStateException("db down"));
        when(sessions.getReferenceById(any(UUID.class))).thenReturn(new PracticeSession());

        assertDoesNotThrow(() -> recorder.record(UUID.randomUUID(), Provider.STT, 5, null));
    }
}
