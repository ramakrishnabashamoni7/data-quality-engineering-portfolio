-- ================================================
-- PROJECT 1: Lloyd's Market Insurance Data Validation
-- Script: 01_create_tables.sql
-- Author: Rama Krishna Bashamoni
-- Date: April 2026
-- Description: Creates all 4 insurance tables
-- ================================================

CREATE TABLE policyholders (
    policyholder_id   SERIAL PRIMARY KEY,
    full_name         VARCHAR(100),
    date_of_birth     DATE,
    email             VARCHAR(150),
    phone             VARCHAR(20),
    country           VARCHAR(50),
    created_date      DATE
);

CREATE TABLE policies (
    policy_id         SERIAL PRIMARY KEY,
    policyholder_id   INT,
    policy_type       VARCHAR(50),
    start_date        DATE,
    end_date          DATE,
    premium_amount    NUMERIC(10,2),
    status            VARCHAR(20),
    created_date      DATE
);

CREATE TABLE claims (
    claim_id          SERIAL PRIMARY KEY,
    policy_id         INT,
    claim_date        DATE,
    claim_amount      NUMERIC(10,2),
    claim_status      VARCHAR(20),
    settlement_amount NUMERIC(10,2),
    created_date      DATE
);

CREATE TABLE bordereau (
    bordereau_id      SERIAL PRIMARY KEY,
    policy_id         INT,
    syndicate_code    VARCHAR(20),
    coverholder_name  VARCHAR(100),
    reported_premium  NUMERIC(10,2),
    reporting_period  VARCHAR(10),
    submission_date   DATE
);