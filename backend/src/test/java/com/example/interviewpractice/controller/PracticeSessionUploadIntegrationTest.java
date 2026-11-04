package com.example.interviewpractice.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.ResultActions;

import com.example.interviewpractice.entity.PracticeSession;
import com.example.interviewpractice.service.storage.AudioStorageException;

class PracticeSessionUploadIntegrationTest extends AbstractSessionApiTest {

    private static final String KEY = "audio/u/s/k.webm";

    private ResultActions upload(UUID sessionId, MockMultipartFile file, String duration) throws Exception {
        var request = multipart("/practice-sessions/" + sessionId + "/answer").header("Authorization", ownerToken);
        if (file != null) {
            request.file(file);
        }
        if (duration != null) {
            request.param("durationSeconds", duration);
        }
        return mvc.perform(request);
    }

    private static MockMultipartFile webm() {
        return new MockMultipartFile("audio", "answer.webm", "audio/webm", new byte[] {1, 2, 3, 4});
    }

    @Test
    void validUploadMovesToUploadedAndStoresKeyAndDuration() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        when(storage.put(eq(owner.getId()), eq(session.getId()), any(), eq("audio/webm"))).thenReturn(KEY);

        upload(session.getId(), webm(), "30").andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UPLOADED"))
                .andExpect(jsonPath("$.audioUrl").value(KEY))
                .andExpect(jsonPath("$.duration").value(30));
        verify(storage).put(eq(owner.getId()), eq(session.getId()), any(), eq("audio/webm"));
        assertEquals("UPLOADED", statusOf(session.getId()));
    }

    @Test
    void codecParameterInContentTypeIsAccepted() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        when(storage.put(any(), any(), any(), anyString())).thenReturn(KEY);
        upload(session.getId(), new MockMultipartFile("audio", "a.webm", "audio/webm;codecs=opus", new byte[] {1}),
                "30").andExpect(status().isOk());
        verify(storage).put(any(), any(), any(), eq("audio/webm"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"9", "181", "0", "-1", "abc"})
    void durationOutsideRangeGets400AndKeepsStatus(String duration) throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        upload(session.getId(), webm(), duration).andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
        verify(storage, never()).put(any(), any(), any(), any());
        assertEquals("CREATED", statusOf(session.getId()));
    }

    @ParameterizedTest
    @ValueSource(strings = {"10", "180"})
    void durationBoundariesAreAccepted(String duration) throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        when(storage.put(any(), any(), any(), anyString())).thenReturn(KEY);
        upload(session.getId(), webm(), duration).andExpect(status().isOk());
    }

    @Test
    void missingDurationGets400() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        upload(session.getId(), webm(), null).andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    void unsupportedMimeOrExtensionOrEmptyFileGets400() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        upload(session.getId(), new MockMultipartFile("audio", "a.webm", "video/mp4", new byte[] {1}), "30")
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
        upload(session.getId(), new MockMultipartFile("audio", "a.exe", "audio/webm", new byte[] {1}), "30")
                .andExpect(status().isBadRequest());
        upload(session.getId(), new MockMultipartFile("audio", "a.webm", "audio/webm", new byte[0]), "30")
                .andExpect(status().isBadRequest());
        verify(storage, never()).put(any(), any(), any(), any());
        assertEquals("CREATED", statusOf(session.getId()));
    }

    @Test
    void fileLargerThanLimitGets400() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        byte[] big = new byte[10 * 1024 * 1024 + 1];
        upload(session.getId(), new MockMultipartFile("audio", "a.webm", "audio/webm", big), "30")
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
        assertEquals("CREATED", statusOf(session.getId()));
    }

    @Test
    void missingAudioPartGets400ValidationError() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        upload(session.getId(), null, "30").andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[0].field").value("audio"));
    }

    @Test
    void unknownSessionGets404() throws Exception {
        upload(UUID.randomUUID(), webm(), "30").andExpect(status().isNotFound());
    }

    @ParameterizedTest
    @ValueSource(strings = {"UPLOADED", "FAILED"})
    void reUploadIsAllowedWhenUploadedOrFailed(String from) throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.valueOf(from));
        jdbc.update("update practice_sessions set error_code = 'STT_ERROR' where id = ?", session.getId());
        when(storage.put(any(), any(), any(), anyString())).thenReturn(KEY);
        upload(session.getId(), webm(), "30").andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UPLOADED")).andExpect(jsonPath("$.errorCode").doesNotExist());
    }

    @Test
    void processingSessionGets409AndStorageIsNotCalled() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.PROCESSING);
        upload(session.getId(), webm(), "30").andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("SESSION_PROCESSING"));
        verify(storage, never()).put(any(), any(), any(), any());
        assertEquals("PROCESSING", statusOf(session.getId()));
    }

    @Test
    void scoredSessionGets409() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.SCORED);
        upload(session.getId(), webm(), "30").andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("SESSION_ALREADY_SCORED"));
    }

    @Test
    void storageFailureGets503AndKeepsStatus() throws Exception {
        PracticeSession session = newSession(owner, PracticeSession.Status.CREATED);
        when(storage.put(any(), any(), any(), anyString())).thenThrow(new AudioStorageException("s3", null));
        upload(session.getId(), webm(), "30").andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.code").value("SERVICE_UNAVAILABLE"));
        assertEquals("CREATED", statusOf(session.getId()));
    }
}
