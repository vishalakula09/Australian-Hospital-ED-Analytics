
-- ============================================================
-- PROJECT: Australian Hospital Emergency Department Analytics
-- FILE: 02_create_tables.sql
-- PURPOSE: Define the analytical and data-quality staging tables
-- SOURCE: Australian Institute of Health and Welfare (AIHW)
-- ============================================================

-- Select the project database
USE australian_hospital_ed;

-- ============================================================
-- TABLE 1: ED PRESENTATIONS
-- Stores emergency department presentation counts
-- by reporting unit, financial year and triage category.
-- ============================================================

CREATE TABLE IF NOT EXISTS ed_presentations (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    financial_year VARCHAR(10),
    triage_category VARCHAR(50),

    -- Preserve the original reported value, including codes
    presentations_original VARCHAR(50),

    -- Cleaned numeric value; NULL for unavailable values
    presentations_numeric BIGINT NULL
);


-- ============================================================
-- TABLE 2: ED WAITING TIMES
-- Stores treatment timeliness by triage category,
-- including reported peer-group benchmarks.
-- ============================================================

CREATE TABLE IF NOT EXISTS ed_waiting_times (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    peer_group VARCHAR(150),
    financial_year VARCHAR(10),
    triage_category VARCHAR(50),

    -- Original reported values
    presentations_original VARCHAR(50),
    seen_on_time_original VARCHAR(50),
    peer_group_average_original VARCHAR(50),

    -- Cleaned numeric measures
    seen_on_time_numeric DECIMAL(5,4) NULL,
    presentations_numeric BIGINT NULL,

    -- Data-quality caution indicator
    data_quality_caution BOOLEAN,

    -- Cleaned peer-group benchmark
    peer_group_average_numeric DECIMAL(5,4) NULL
);


-- ============================================================
-- TABLE 3: WAITING-TIME CAUTION STAGING
-- Temporarily stores caution indicators during data import.
-- ============================================================

CREATE TABLE IF NOT EXISTS waiting_time_caution_staging (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    financial_year VARCHAR(10),
    triage_category VARCHAR(50),

    data_quality_caution BOOLEAN
);


-- ============================================================
-- TABLE 4: FOUR-HOUR ED PERFORMANCE
-- Stores the proportion of ED presentations departing
-- within four hours, by patient cohort.
-- ============================================================

CREATE TABLE IF NOT EXISTS ed_four_hour_performance (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    peer_group VARCHAR(150),
    financial_year VARCHAR(10),
    patient_cohort VARCHAR(100),

    -- Original reported values
    presentations_original VARCHAR(50),
    within_4hrs_original VARCHAR(50),
    peer_group_average_original VARCHAR(50),

    -- Cleaned numeric measures
    within_4hrs_numeric DECIMAL(5,4) NULL,
    presentations_numeric BIGINT NULL,

    -- Data-quality caution indicator
    data_quality_caution BOOLEAN,

    -- Cleaned peer-group benchmark
    peer_group_average_numeric DECIMAL(5,4) NULL
);


-- ============================================================
-- TABLE 5: FOUR-HOUR CAUTION STAGING
-- Temporarily stores four-hour performance caution flags.
-- ============================================================

CREATE TABLE IF NOT EXISTS four_hour_caution_staging (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    financial_year VARCHAR(10),
    patient_cohort VARCHAR(100),

    data_quality_caution BOOLEAN
);


-- ============================================================
-- TABLE 6: ED DURATION
-- Stores median and 90th percentile ED stay durations
-- for different patient cohorts.
-- Duration measures are expressed in minutes.
-- ============================================================

CREATE TABLE IF NOT EXISTS ed_duration (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    peer_group VARCHAR(150),
    financial_year VARCHAR(10),
    patient_cohort VARCHAR(100),

    -- Original reported values
    presentations_original VARCHAR(50),
    median_time_original VARCHAR(100),
    p90_time_original VARCHAR(100),
    peer_p90_original VARCHAR(100),

    -- Cleaned duration and presentation measures
    median_minutes DECIMAL(10,2) NULL,
    p90_minutes DECIMAL(10,2) NULL,
    presentations_numeric BIGINT NULL,

    -- Cleaned peer benchmark used for analysis
    peer_p90_minutes DECIMAL(10,2) NULL,

    -- Raw numeric peer benchmark retained for validation
    peer_p90_minutes_raw DECIMAL(10,2) NULL,

    -- Separate caution indicators for duration measures
    median_quality_caution BOOLEAN,
    p90_quality_caution BOOLEAN
);


-- ============================================================
-- TABLE 7: ED DURATION CAUTION STAGING
-- Temporarily stores median and P90 caution indicators.
-- ============================================================

CREATE TABLE IF NOT EXISTS time_in_ed_caution_staging (
    id INT AUTO_INCREMENT PRIMARY KEY,

    reporting_unit VARCHAR(255),
    reporting_unit_type VARCHAR(100),
    state VARCHAR(10),
    financial_year VARCHAR(10),
    patient_cohort VARCHAR(100),

    median_quality_caution BOOLEAN,
    p90_quality_caution BOOLEAN
);


-- ============================================================
-- VERIFICATION
-- Confirm that all seven required tables exist.
-- ============================================================

SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'australian_hospital_ed'
    AND table_name IN (
        'ed_presentations',
        'ed_waiting_times',
        'waiting_time_caution_staging',
        'ed_four_hour_performance',
        'four_hour_caution_staging',
        'ed_duration',
        'time_in_ed_caution_staging'
    )
ORDER BY table_name;
