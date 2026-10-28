package com.example.interviewpractice.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.example.interviewpractice.config.JwtProperties;
import com.example.interviewpractice.entity.User;
import com.example.interviewpractice.repository.UserRepository;

class JwtAuthenticationFilterTest {

    private final UserRepository users = mock(UserRepository.class);
    private JwtService jwtService;
    private JwtAuthenticationFilter filter;
    private User user;
    private String token;

    @BeforeEach
    void setUp() {
        Clock clock = Clock.fixed(Instant.parse("2026-10-27T03:00:00Z"), ZoneOffset.UTC);
        jwtService = new JwtService(new JwtProperties("test-secret-test-secret-test-secret-123456", 24), clock);
        filter = new JwtAuthenticationFilter(jwtService, users);

        user = new User();
        user.setId(UUID.randomUUID());
        user.setEmail("cand@example.com");
        user.setRole(User.Role.CANDIDATE);
        user.setStatus(User.Status.ACTIVE);
        token = jwtService.generate(user);
        when(users.findById(user.getId())).thenReturn(Optional.of(user));
    }

    @AfterEach
    void clearContext() {
        SecurityContextHolder.clearContext();
    }

    private Authentication run(String authorizationHeader) throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        if (authorizationHeader != null) {
            request.addHeader("Authorization", authorizationHeader);
        }
        filter.doFilter(request, new MockHttpServletResponse(), new MockFilterChain());
        return SecurityContextHolder.getContext().getAuthentication();
    }

    @Test
    void activeUserIsAuthenticated() throws Exception {
        Authentication auth = run("Bearer " + token);

        AuthUser principal = (AuthUser) auth.getPrincipal();
        assertEquals(user.getId(), principal.id());
        assertEquals("ROLE_CANDIDATE", auth.getAuthorities().iterator().next().getAuthority());
    }

    @Test
    void roleChangedInDatabaseTakesEffectWithOldToken() throws Exception {
        // Token được cấp khi còn là CANDIDATE
        user.setRole(User.Role.ADMIN);

        Authentication auth = run("Bearer " + token);

        assertEquals("ROLE_ADMIN", auth.getAuthorities().iterator().next().getAuthority());
        assertEquals(User.Role.ADMIN, ((AuthUser) auth.getPrincipal()).role());
    }

    @Test
    void roleDemotedInDatabaseTakesEffectWithOldToken() throws Exception {
        user.setRole(User.Role.ADMIN);
        String adminToken = jwtService.generate(user);
        user.setRole(User.Role.CANDIDATE);

        Authentication auth = run("Bearer " + adminToken);

        assertEquals("ROLE_CANDIDATE", auth.getAuthorities().iterator().next().getAuthority());
    }

    @Test
    void userLockedByAdminIsNotAuthenticatedEvenWithValidToken() throws Exception {
        user.setStatus(User.Status.LOCKED);

        assertNull(run("Bearer " + token));
    }

    @Test
    void deletedUserIsNotAuthenticated() throws Exception {
        when(users.findById(user.getId())).thenReturn(Optional.empty());

        assertNull(run("Bearer " + token));
    }

    @Test
    void temporaryLoginLockDoesNotInvalidateExistingToken() throws Exception {
        user.setLockedUntil(Instant.parse("2026-10-27T03:10:00Z"));

        assertEquals(user.getId(), ((AuthUser) run("Bearer " + token).getPrincipal()).id());
    }

    @Test
    void invalidTokenNeverHitsDatabase() throws Exception {
        assertNull(run("Bearer abc.def.ghi"));

        verify(users, never()).findById(any());
    }

    @Test
    void missingOrNonBearerHeaderIsAnonymous() throws Exception {
        assertNull(run(null));
        assertNull(run("Basic dXNlcjpwYXNz"));

        verify(users, never()).findById(any());
    }
}
