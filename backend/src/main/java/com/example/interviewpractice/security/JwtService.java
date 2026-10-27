package com.example.interviewpractice.security;

import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.example.interviewpractice.config.JwtProperties;
import com.example.interviewpractice.entity.User;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;

/** Phát hành và kiểm tra JWT HS256; hạn token lấy từ jwt.expiration-hours. */
@Service
public class JwtService {

    // HS256 yêu cầu khóa tối thiểu 256 bit
    private static final int MIN_SECRET_BYTES = 32;

    private final byte[] secret;
    private final Duration lifetime;
    private final Clock clock;

    public JwtService(JwtProperties properties, Clock clock) {
        this.secret = properties.secret().getBytes(StandardCharsets.UTF_8);
        if (secret.length < MIN_SECRET_BYTES) {
            throw new IllegalStateException("jwt.secret phải có ít nhất " + MIN_SECRET_BYTES + " byte");
        }
        this.lifetime = Duration.ofHours(properties.expirationHours());
        this.clock = clock;
    }

    public String generate(User user) {
        Instant now = clock.instant();
        JWTClaimsSet claims = new JWTClaimsSet.Builder()
                .subject(user.getId().toString())
                .claim("email", user.getEmail())
                .claim("role", user.getRole().name())
                .issueTime(Date.from(now))
                .expirationTime(Date.from(now.plus(lifetime)))
                .build();
        try {
            SignedJWT jwt = new SignedJWT(new JWSHeader(JWSAlgorithm.HS256), claims);
            jwt.sign(new MACSigner(secret));
            return jwt.serialize();
        } catch (JOSEException e) {
            throw new IllegalStateException("Không ký được JWT", e);
        }
    }

    /** Trả rỗng khi token sai định dạng, sai chữ ký hoặc hết hạn. */
    public Optional<AuthUser> parse(String token) {
        try {
            SignedJWT jwt = SignedJWT.parse(token);
            if (!jwt.verify(new MACVerifier(secret))) {
                return Optional.empty();
            }
            JWTClaimsSet claims = jwt.getJWTClaimsSet();
            Date expiration = claims.getExpirationTime();
            if (expiration == null || !expiration.toInstant().isAfter(clock.instant())) {
                return Optional.empty();
            }
            return Optional.of(new AuthUser(
                    UUID.fromString(claims.getSubject()),
                    claims.getStringClaim("email"),
                    User.Role.valueOf(claims.getStringClaim("role"))));
        } catch (ParseException | JOSEException | IllegalArgumentException | NullPointerException e) {
            return Optional.empty();
        }
    }
}
