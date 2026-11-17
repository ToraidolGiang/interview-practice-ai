package com.example.interviewpractice.controller;

import static org.hamcrest.Matchers.contains;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.web.util.UriComponentsBuilder;

import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.UserRepository;
import com.example.interviewpractice.service.MailService;

/** Cần Postgres như BackendApplicationTests: quên và đặt lại mật khẩu (#157) qua HTTP, tầng bảo mật và CSDL thật. */
@SpringBootTest
@AutoConfigureMockMvc
class PasswordResetIntegrationTest {

    private static final String OLD_PASSWORD = "MatkhauCu123";
    private static final String NEW_PASSWORD = "MatkhauMoi123";

    @Autowired
    private MockMvc mvc;

    @Autowired
    private UserRepository users;

    @Autowired
    private PasswordEncoder encoder;

    @MockitoBean
    private MailService mail;

    private final String email = "reset-" + UUID.randomUUID() + "@example.com";

    @BeforeEach
    void createUser() {
        User user = new User();
        user.setFullName("Người Quên Mật Khẩu");
        user.setEmail(email);
        user.setPasswordHash(encoder.encode(OLD_PASSWORD));
        user.setFailedLoginCount(4);
        users.save(user);
    }

    @AfterEach
    void cleanUp() {
        // password_reset_tokens xóa theo ON DELETE CASCADE
        users.findByEmail(email).ifPresent(users::delete);
    }

    @Test
    void fullFlowChangesPasswordAndTokenWorksOnlyOnce() throws Exception {
        forgot(email.toUpperCase()).andExpect(status().isOk()).andExpect(content().string(""));
        String token = tokenFromMail();

        reset(token, NEW_PASSWORD, NEW_PASSWORD).andExpect(status().isOk());
        assertEquals(0, users.findByEmail(email).orElseThrow().getFailedLoginCount());

        login(NEW_PASSWORD).andExpect(status().isOk());
        login(OLD_PASSWORD).andExpect(status().isUnauthorized());
        reset(token, "MatkhauKhac123", "MatkhauKhac123")
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("INVALID_TOKEN"));
    }

    @Test
    void unknownEmailStillReturns200WithoutSendingMail() throws Exception {
        forgot("khong-ton-tai-" + UUID.randomUUID() + "@example.com").andExpect(status().isOk());

        verify(mail, never()).sendPasswordReset(anyString(), anyString(), anyString());
    }

    @Test
    void repeatedRequestWithinCooldownSendsOnlyOneMail() throws Exception {
        forgot(email).andExpect(status().isOk());
        forgot(email).andExpect(status().isOk());

        verify(mail).sendPasswordReset(eq(email), anyString(), anyString());
    }

    @Test
    void resetSucceedsEvenForAccountTemporarilyLockedByWrongPasswords() throws Exception {
        login("SaiMatKhau123").andExpect(status().isUnauthorized()); // lần sai thứ 5: khóa tạm 15 phút
        login(OLD_PASSWORD).andExpect(status().isTooManyRequests());
        forgot(email).andExpect(status().isOk());

        reset(tokenFromMail(), NEW_PASSWORD, NEW_PASSWORD).andExpect(status().isOk());

        login(NEW_PASSWORD).andExpect(status().isOk());
    }

    @Test
    void invalidInputsAreValidationErrorsOnTheRightFields() throws Exception {
        forgot("khong-phai-email")
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[*].field").value(contains("email")));
        reset("bat-ky", "ngan", "ngan")
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[*].field").value(contains("newPassword")));
        reset("bat-ky", NEW_PASSWORD, "KhacNhau123")
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fieldErrors[*].field").value(contains("confirmPassword")));
        reset("token-khong-ton-tai", NEW_PASSWORD, NEW_PASSWORD)
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("INVALID_TOKEN"));
    }

    private String tokenFromMail() {
        ArgumentCaptor<String> link = ArgumentCaptor.forClass(String.class);
        verify(mail).sendPasswordReset(eq(email), eq("Người Quên Mật Khẩu"), link.capture());
        var params = UriComponentsBuilder.fromUriString(link.getValue()).build(true).getQueryParams();
        assertEquals(email, java.net.URLDecoder.decode(params.getFirst("email"), java.nio.charset.StandardCharsets.UTF_8));
        return params.getFirst("token");
    }

    private ResultActions forgot(String address) throws Exception {
        return mvc.perform(post("/auth/forgot-password").contentType(MediaType.APPLICATION_JSON)
                .content("{\"email\":\"" + address + "\"}"));
    }

    private ResultActions reset(String token, String password, String confirm) throws Exception {
        return mvc.perform(post("/auth/reset-password").contentType(MediaType.APPLICATION_JSON)
                .content("{\"token\":\"" + token + "\",\"newPassword\":\"" + password + "\",\"confirmPassword\":\""
                        + confirm + "\"}"));
    }

    private ResultActions login(String password) throws Exception {
        return mvc.perform(post("/auth/login").contentType(MediaType.APPLICATION_JSON)
                .content("{\"email\":\"" + email + "\",\"password\":\"" + password + "\"}"));
    }
}
