package com.example.interviewpractice.security;

import java.io.IOException;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.UserRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Đọc header Authorization: Bearer. Token hợp lệ chỉ chứng minh danh tính; trạng thái và quyền được nạp
 * lại từ CSDL mỗi request (tra khóa chính), nên tài khoản bị khóa, bị xóa hoặc đổi role có hiệu lực
 * ngay thay vì chờ token cũ hết hạn sau 24 giờ.
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtService jwtService;
    private final UserRepository users;

    public JwtAuthenticationFilter(JwtService jwtService, UserRepository users) {
        this.jwtService = jwtService;
        this.users = users;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith(BEARER_PREFIX)) {
            jwtService.parse(header.substring(BEARER_PREFIX.length()))
                    .flatMap(claims -> users.findById(claims.id()))
                    // LOCKED do quản trị khóa; khóa tạm vì đăng nhập sai (lockedUntil) không ảnh hưởng token đang dùng
                    .filter(user -> user.getStatus() == User.Status.ACTIVE)
                    .ifPresent(user -> {
                        // Quyền lấy từ CSDL, không lấy từ claim trong token
                        var principal = new AuthUser(user.getId(), user.getEmail(), user.getRole());
                        var authentication = new UsernamePasswordAuthenticationToken(principal, null,
                                List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name())));
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                    });
        }
        chain.doFilter(request, response);
    }
}
