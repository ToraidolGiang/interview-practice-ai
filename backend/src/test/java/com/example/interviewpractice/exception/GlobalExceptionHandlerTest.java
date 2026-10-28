package com.example.interviewpractice.exception;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;

class GlobalExceptionHandlerTest {

    record Body(@NotBlank(message = "Tên không được để trống") String name) {
    }

    @RestController
    static class StubController {
        @PostMapping("/stub")
        String create(@Valid @RequestBody Body body) {
            return body.name();
        }

        @GetMapping("/boom")
        String boom() {
            throw new IllegalStateException("chi tiết nội bộ không được lộ ra");
        }

        @GetMapping("/conflict")
        String conflict() {
            throw new ApiException(HttpStatus.CONFLICT, "EMAIL_EXISTS", "Email đã được đăng ký");
        }

        @GetMapping("/denied")
        String denied() {
            throw new AccessDeniedException("nope");
        }
    }

    private MockMvc mvc;

    @BeforeEach
    void setUp() {
        mvc = MockMvcBuilders.standaloneSetup(new StubController())
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    @Test
    void unexpectedExceptionReturnsErrorResponseWithoutInternalDetails() throws Exception {
        mvc.perform(get("/boom"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.code").value("INTERNAL_ERROR"))
                .andExpect(jsonPath("$.message").value("Hệ thống gặp lỗi, vui lòng thử lại sau"))
                .andExpect(jsonPath("$.timestamp").exists());
    }

    @Test
    void apiExceptionKeepsItsStatusAndCode() throws Exception {
        mvc.perform(get("/conflict"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("EMAIL_EXISTS"));
    }

    @Test
    void accessDeniedInsideControllerIs403NotServerError() throws Exception {
        mvc.perform(get("/denied"))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.code").value("FORBIDDEN"));
    }

    @Test
    void wrongHttpMethodKeepsStatus405AndAllowHeader() throws Exception {
        mvc.perform(post("/boom"))
                .andExpect(status().isMethodNotAllowed())
                .andExpect(header().exists("Allow"))
                .andExpect(jsonPath("$.code").value("METHOD_NOT_ALLOWED"));
    }

    @Test
    void unsupportedContentTypeKeepsStatus415() throws Exception {
        mvc.perform(post("/stub").contentType(MediaType.TEXT_PLAIN).content("x"))
                .andExpect(status().isUnsupportedMediaType())
                .andExpect(jsonPath("$.code").value("UNSUPPORTED_MEDIA_TYPE"));
    }

    @Test
    void malformedJsonIs400WithErrorResponse() throws Exception {
        mvc.perform(post("/stub").contentType(MediaType.APPLICATION_JSON).content("{khong phai json"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"));
    }

    @Test
    void beanValidationFailureListsFieldErrors() throws Exception {
        mvc.perform(post("/stub").contentType(MediaType.APPLICATION_JSON).content("{\"name\":\"\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.fieldErrors[0].field").value("name"))
                .andExpect(jsonPath("$.fieldErrors[0].message").value("Tên không được để trống"));
    }
}
