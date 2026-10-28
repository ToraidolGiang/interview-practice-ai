package com.example.interviewpractice.exception;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.sql.SQLException;

import org.hibernate.exception.ConstraintViolationException;
import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;

class DbConstraintsTest {

    private static DataIntegrityViolationException withName(String name) {
        return new DataIntegrityViolationException("lỗi", new ConstraintViolationException("lỗi", new SQLException(), name));
    }

    @Test
    void matchesConstraintNameIgnoringCase() {
        assertTrue(DbConstraints.violates(withName("UQ_USERS_EMAIL"), "uq_users_email"));
    }

    @Test
    void differentConstraintNameDoesNotMatch() {
        assertFalse(DbConstraints.violates(withName("ck_questions_level"), "uq_users_email"));
    }

    @Test
    void fallsBackToTheDriverMessageWhenHibernateGivesNoName() {
        DataIntegrityViolationException e = new DataIntegrityViolationException("lỗi",
                new ConstraintViolationException("lỗi",
                        new SQLException("duplicate key value violates unique constraint \"uq_users_email\""), null));

        assertTrue(DbConstraints.violates(e, "uq_users_email"));
    }

    @Test
    void messageFallbackStillWorksWhenHibernateReportsAnotherFormOfTheName() {
        DataIntegrityViolationException e = new DataIntegrityViolationException("lỗi",
                new ConstraintViolationException("lỗi",
                        new SQLException("duplicate key value violates unique constraint \"uq_users_email\""),
                        "public.uq_users_email"));

        assertTrue(DbConstraints.violates(e, "uq_users_email"));
    }

    @Test
    void unrelatedMessageDoesNotMatch() {
        assertFalse(DbConstraints.violates(new DataIntegrityViolationException("null value in column \"full_name\""),
                "uq_users_email"));
    }
}
