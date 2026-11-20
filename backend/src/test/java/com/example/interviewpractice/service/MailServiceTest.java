package com.example.interviewpractice.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.timeout;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Duration;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.mail.MailSendException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import com.example.interviewpractice.config.PasswordResetProperties;

class MailServiceTest {

    private static final PasswordResetProperties PROPERTIES = new PasswordResetProperties("http://app.test",
            "no-reply@app.test", Duration.ofMinutes(30), Duration.ofSeconds(60));

    private final JavaMailSender sender = mock(JavaMailSender.class);

    @SuppressWarnings("unchecked")
    private MailService service(JavaMailSender available) {
        ObjectProvider<JavaMailSender> provider = mock(ObjectProvider.class);
        when(provider.getIfAvailable()).thenReturn(available);
        return new MailService(provider, PROPERTIES);
    }

    @Test
    void sendsResetMailWithLinkAndExpiryThroughSmtp() {
        service(sender).sendPasswordReset("user@example.com", "Người Dùng", "http://app.test/reset-password?token=x");

        ArgumentCaptor<SimpleMailMessage> message = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(sender, timeout(2000)).send(message.capture());
        assertEquals("no-reply@app.test", message.getValue().getFrom());
        assertEquals("user@example.com", message.getValue().getTo()[0]);
        assertTrue(message.getValue().getText().contains("http://app.test/reset-password?token=x"));
        assertTrue(message.getValue().getText().contains("30 phút"));
    }

    @Test
    void smtpFailureIsSwallowedSoTheRequestStillSucceeds() {
        doThrow(new MailSendException("smtp down")).when(sender).send(org.mockito.ArgumentMatchers.any(SimpleMailMessage.class));

        service(sender).sendPasswordReset("user@example.com", "Người Dùng", "http://app.test/x");

        verify(sender, timeout(2000)).send(org.mockito.ArgumentMatchers.any(SimpleMailMessage.class));
    }

    @Test
    void masksEmailForLogs() {
        assertEquals("u***@example.com", MailService.mask("user@example.com"));
        assertEquals("***", MailService.mask("khong-co-a-cong"));
    }
}
