package com.example.interviewpractice.config;

import java.io.IOException;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.example.interviewpractice.dto.ErrorResponse;
import com.example.interviewpractice.security.JwtAuthenticationFilter;

import jakarta.servlet.http.HttpServletResponse;
import tools.jackson.databind.json.JsonMapper;

/** Cấu hình bảo mật: API không trạng thái dùng JWT, /auth/** công khai, /admin/** chỉ ADMIN. */
@Configuration
@EnableConfigurationProperties(JwtProperties.class)
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtFilter)
            throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/register", "/auth/login", "/auth/forgot-password",
                                "/auth/reset-password").permitAll()
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .anyRequest().authenticated())
                .exceptionHandling(e -> e
                        .authenticationEntryPoint((req, res, ex) -> writeError(res, HttpStatus.UNAUTHORIZED,
                                "UNAUTHORIZED", "Cần đăng nhập để thực hiện thao tác này"))
                        .accessDeniedHandler((req, res, ex) -> writeError(res, HttpStatus.FORBIDDEN,
                                "FORBIDDEN", "Không có quyền thực hiện thao tác này")))
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    private static final JsonMapper MAPPER = JsonMapper.builder().build();

    // Lỗi sinh ra trong filter chain không qua GlobalExceptionHandler nên tự ghi ErrorResponse
    private static void writeError(HttpServletResponse res, HttpStatus status, String code, String message)
            throws IOException {
        res.setStatus(status.value());
        res.setContentType(MediaType.APPLICATION_JSON_VALUE);
        res.setCharacterEncoding("UTF-8");
        res.getWriter().write(MAPPER.writeValueAsString(ErrorResponse.of(code, message)));
    }
}
