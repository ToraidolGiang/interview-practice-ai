package com.example.interviewpractice.config;

import java.io.IOException;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtFilter,
            JsonMapper mapper) throws Exception {
        // Chưa bật CORS: frontend gọi qua proxy /api cùng origin. Nếu deploy tách origin (#132) thì thêm
        // CorsConfigurationSource ở đây.
        http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/register", "/auth/login", "/auth/forgot-password",
                                "/auth/reset-password").permitAll()
                        // Lỗi 404/500 được chuyển sang /error; không mở thì bị che thành 401
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .anyRequest().authenticated())
                .exceptionHandling(e -> e
                        .authenticationEntryPoint((req, res, ex) -> writeError(mapper, res, HttpStatus.UNAUTHORIZED,
                                "UNAUTHORIZED", "Cần đăng nhập để thực hiện thao tác này"))
                        .accessDeniedHandler((req, res, ex) -> writeError(mapper, res, HttpStatus.FORBIDDEN,
                                "FORBIDDEN", "Không có quyền thực hiện thao tác này")))
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    // Lỗi sinh ra trong filter chain không qua GlobalExceptionHandler nên tự ghi ErrorResponse,
    // dùng JsonMapper của Spring để cùng cấu hình (định dạng thời gian...) với các response khác
    private static void writeError(JsonMapper mapper, HttpServletResponse res, HttpStatus status, String code,
            String message) throws IOException {
        res.setStatus(status.value());
        res.setContentType(MediaType.APPLICATION_JSON_VALUE);
        res.setCharacterEncoding("UTF-8");
        res.getWriter().write(mapper.writeValueAsString(ErrorResponse.of(code, message)));
    }
}
