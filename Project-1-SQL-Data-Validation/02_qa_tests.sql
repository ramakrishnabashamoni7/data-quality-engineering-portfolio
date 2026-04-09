-- ================================================
-- PROJECT 1: Lloyd's Market Insurance Data Validation
-- Script: 02_qa_tests.sql
-- Author: Rama Krishna Bashamoni
-- Date: April 2026
-- Description: All 10 Data QA test scripts
-- ================================================


-- ================================================
-- TEST 1: NULL CHECK
-- Purpose: Find records where critical fields are missing
-- Expected: 2 dirty records
-- ================================================
SELECT
    policyholder_id,
    full_name,
    email,
    phone,
    country,
    'FAIL - Critical fields are NULL' AS qa_result
FROM policyholders
WHERE full_name IS NULL
   OR email     IS NULL
   OR phone     IS NULL
   OR country   IS NULL;


-- ================================================
-- TEST 2: DUPLICATE CHECK
-- Purpose: Find records that appear more than once
-- Expected: 2 duplicate records
-- ================================================
SELECT
    full_name,
    date_of_birth,
    email,
    phone,
    COUNT(*)                        AS duplicate_count,
    'FAIL - Duplicate record found' AS qa_result
FROM policyholders
WHERE full_name IS NOT NULL
GROUP BY full_name, date_of_birth, email, phone
HAVING COUNT(*) > 1;


-- ================================================
-- TEST 3: FUTURE DATE CHECK
-- Purpose: Find records where date of birth is in the future
-- Expected: 1 dirty record
-- ================================================
SELECT
    policyholder_id,
    full_name,
    date_of_birth,
    CURRENT_DATE                        AS todays_date,
    AGE(date_of_birth)                  AS age_calculated,
    'FAIL - Date of birth is in future' AS qa_result
FROM policyholders
WHERE date_of_birth > CURRENT_DATE;


-- ================================================
-- TEST 4 & 5: PREMIUM VALIDATION CHECK
-- Purpose: Find NULL and negative premium amounts
-- Expected: 2 dirty records
-- ================================================
SELECT
    policy_id,
    premium_amount,
    CASE
        WHEN premium_amount IS NULL THEN 'FAIL - Premium is NULL'
        WHEN premium_amount < 0     THEN 'FAIL - Premium is negative'
        WHEN premium_amount = 0     THEN 'WARN - Premium is zero'
        ELSE                             'PASS'
    END AS qa_result
FROM policies
WHERE premium_amount IS NULL
   OR premium_amount <= 0;


-- ================================================
-- TEST 6: INVALID STATUS CHECK
-- Purpose: Find policies with invalid status values
-- Expected: 1 dirty record
-- ================================================
SELECT
    policy_id,
    policy_type,
    status,
    CASE
        WHEN status NOT IN ('Active', 'Expired', 'Cancelled')
            THEN 'FAIL - Invalid status: ' || status
        WHEN policy_type NOT IN ('Marine Cargo','Property','Liability','Aviation')
            THEN 'FAIL - Invalid policy type: ' || policy_type
        ELSE 'PASS'
    END AS qa_result
FROM policies
WHERE status NOT IN ('Active', 'Expired', 'Cancelled')
   OR policy_type NOT IN ('Marine Cargo','Property','Liability','Aviation');


-- ================================================
-- TEST 7: DATE LOGIC CHECK
-- Purpose: Find policies where end_date is before start_date
-- Expected: 1 dirty record
-- ================================================
SELECT
    policy_id,
    policy_type,
    start_date,
    end_date,
    end_date - start_date                  AS duration_days,
    CASE
        WHEN end_date < start_date  THEN 'FAIL - End before start'
        WHEN end_date = start_date  THEN 'WARN - Same day policy'
        ELSE                             'PASS'
    END                                    AS qa_result
FROM policies
ORDER BY duration_days;


-- ================================================
-- TEST 8: ORPHAN RECORD CHECK
-- Purpose: Find policies with no matching policyholder
-- Expected: 1 orphan record
-- ================================================
SELECT
    p.policy_id,
    p.policyholder_id,
    p.policy_type,
    p.premium_amount,
    p.status,
    'FAIL - policyholder_id does not exist in policyholders table' AS qa_result
FROM policies p
LEFT JOIN policyholders ph
       ON p.policyholder_id = ph.policyholder_id
WHERE ph.policyholder_id IS NULL;


-- ================================================
-- TEST 9: SETTLEMENT EXCEEDS CLAIM CHECK
-- Purpose: Find claims where settlement exceeds claim amount
-- Expected: 2 dirty records
-- ================================================
SELECT
    claim_id,
    policy_id,
    claim_amount,
    settlement_amount,
    CASE
        WHEN claim_amount IS NULL
            THEN 'FAIL - Claim amount is NULL'
        WHEN settlement_amount > claim_amount
            THEN 'FAIL - Settlement exceeds claim: overpayment of £'
                  || (settlement_amount - claim_amount)::TEXT
        WHEN claim_amount <= 0
            THEN 'FAIL - Claim amount must be positive'
        ELSE 'PASS'
    END AS qa_result
FROM claims
WHERE claim_amount IS NULL
   OR settlement_amount > claim_amount
   OR claim_amount <= 0;


-- ================================================
-- TEST 10: BORDEREAU RECONCILIATION
-- Purpose: Find bordereau records mismatching policies
-- Expected: 4 dirty records
-- ================================================
SELECT
    b.bordereau_id,
    b.policy_id,
    b.syndicate_code,
    b.coverholder_name,
    b.reporting_period,
    p.premium_amount                AS actual_premium,
    b.reported_premium              AS bordereau_premium,
    b.reported_premium
        - p.premium_amount          AS variance_amount,
    CASE
        WHEN b.syndicate_code IS NULL
            THEN 'FAIL - NULL syndicate code'
        WHEN b.coverholder_name IS NULL
            THEN 'FAIL - NULL coverholder name'
        WHEN b.reporting_period IS NULL
            THEN 'FAIL - NULL reporting period'
        WHEN b.reported_premium <> p.premium_amount
            THEN 'FAIL - Premium mismatch. Variance: £'
                  || (b.reported_premium - p.premium_amount)::TEXT
        ELSE 'PASS'
    END                             AS qa_result
FROM bordereau b
INNER JOIN policies p
        ON b.policy_id = p.policy_id
WHERE b.syndicate_code IS NULL
   OR b.coverholder_name IS NULL
   OR b.reporting_period IS NULL
   OR b.reported_premium <> p.premium_amount
ORDER BY b.policy_id;


-- ================================================
-- MASTER QA SUMMARY REPORT
-- Purpose: Single view of all test results
-- ================================================
SELECT '1. NULL CHECK'                  AS test_name,
       COUNT(*)                         AS issues_found,
       'policyholders'                  AS table_name,
       'Critical'                       AS severity
FROM policyholders
WHERE full_name IS NULL OR email IS NULL
   OR phone IS NULL OR country IS NULL

UNION ALL

SELECT '2. DUPLICATE CHECK',
       COUNT(*),
       'policyholders',
       'Critical'
FROM (
    SELECT full_name, date_of_birth, email, phone
    FROM policyholders
    WHERE full_name IS NOT NULL
    GROUP BY full_name, date_of_birth, email, phone
    HAVING COUNT(*) > 1
) duplicates

UNION ALL

SELECT '3. FUTURE DATE CHECK',
       COUNT(*),
       'policyholders',
       'High'
FROM policyholders
WHERE date_of_birth > CURRENT_DATE

UNION ALL

SELECT '4. NULL PREMIUM CHECK',
       COUNT(*),
       'policies',
       'Critical'
FROM policies
WHERE premium_amount IS NULL

UNION ALL

SELECT '5. NEGATIVE PREMIUM CHECK',
       COUNT(*),
       'policies',
       'Critical'
FROM policies
WHERE premium_amount < 0

UNION ALL

SELECT '6. INVALID STATUS CHECK',
       COUNT(*),
       'policies',
       'High'
FROM policies
WHERE status NOT IN ('Active', 'Expired', 'Cancelled')

UNION ALL

SELECT '7. DATE LOGIC CHECK',
       COUNT(*),
       'policies',
       'Critical'
FROM policies
WHERE end_date < start_date

UNION ALL

SELECT '8. ORPHAN RECORD CHECK',
       COUNT(*),
       'policies',
       'Critical'
FROM policies p
LEFT JOIN policyholders ph
       ON p.policyholder_id = ph.policyholder_id
WHERE ph.policyholder_id IS NULL

UNION ALL

SELECT '9. SETTLEMENT EXCEEDS CLAIM',
       COUNT(*),
       'claims',
       'Critical'
FROM claims
WHERE settlement_amount > claim_amount
   OR claim_amount IS NULL

UNION ALL

SELECT '10. BORDEREAU RECONCILIATION',
       COUNT(*),
       'bordereau',
       'Critical'
FROM bordereau b
INNER JOIN policies p ON b.policy_id = p.policy_id
WHERE b.syndicate_code IS NULL
   OR b.coverholder_name IS NULL
   OR b.reporting_period IS NULL
   OR b.reported_premium <> p.premium_amount

ORDER BY test_name;