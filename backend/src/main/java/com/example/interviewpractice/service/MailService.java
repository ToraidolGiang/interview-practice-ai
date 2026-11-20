package com.example.interviewpractice.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.example.interviewpractice.config.PasswordResetProperties;

import jakarta.annotation.PreDestroy;

/**
 * Gửi email (#157). Gửi ở luồng riêng để thời gian phản hồi của /auth/forgot-password không phụ thuộc SMTP,
 * tránh lộ email nào đã đăng ký qua độ trễ. Chưa cấu hình SMTP (spring.mail.host) thì chỉ ghi link ra log, dùng khi dev.
 */
@Service
public class MailService {

    private static final Logger log = LoggerFactory.getLogger(MailService.class);

    private final ObjectProvider<JavaMailSender> mailSender;
    private final PasswordResetProperties properties;
    private final ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();

    public MailService(ObjectProvider<JavaMailSender> mailSender, PasswordResetProperties properties) {
        this.mailSender = mailSender;
        this.properties = properties;
    }

    public void sendPasswordReset(String to, String fullName, String link) {
        executor.execute(() -> send(to, fullName, link));
    }

    private void send(String to, String fullName, String link) {
        JavaMailSender sender = mailSender.getIfAvailable();
        if (sender == null) {
            log.warn("Chưa cấu hình SMTP (SPRING_MAIL_HOST), không gửi email. Link đặt lại mật khẩu cho {}: {}",
                    mask(to), link);
            return;
        }
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(properties.mailFrom());
        message.setTo(to);
        message.setSubject("Đặt lại mật khẩu InterviewAI");
        message.setText("""
                Chào %s,

                Bạn (hoặc ai đó) vừa yêu cầu đặt lại mật khẩu cho tài khoản InterviewAI.
                Mở liên kết sau để đặt mật khẩu mới (hết hạn sau %d phút, chỉ dùng được một lần):

                %s

                Nếu bạn không yêu cầu, hãy bỏ qua email này; mật khẩu hiện tại vẫn giữ nguyên.
                """.formatted(fullName, properties.tokenTtl().toMinutes(), link));
        try {
            sender.send(message);
        } catch (MailException e) {
            // Không ghi link vào log khi đã có SMTP: link là bí mật, ai đọc được log sẽ đặt lại được mật khẩu
            log.error("Gửi email đặt lại mật khẩu tới {} thất bại", mask(to), e);
        }
    }

    // a***@example.com: đủ để truy vết mà không ghi nguyên địa chỉ vào log
    static String mask(String email) {
        int at = email.indexOf('@');
        return at <= 0 ? "***" : email.charAt(0) + "***" + email.substring(at);
    }

    @PreDestroy
    void shutdown() {
        executor.close();
    }
}
