
-- ============================================================
-- PROJECT: Australian Hospital Emergency Department Analytics
-- FILE: 03_data_validation.sql
-- PURPOSE: Validate imported and cleaned MySQL datasets
-- SOURCE: Australian Institute of Health and Welfare (AIHW)
-- ============================================================

USE australian_hospital_ed;


-- ============================================================
-- 1. VALIDATE RECORD COUNTS
-- Confirm the number of records in each analytical table.
-- ============================================================

SELECT
    'ED Presentations' AS dataset,
    COUNT(*) AS total_records
FROM ed_presentations

UNION ALL

SELECT
    'Patients Seen on Time',
    COUNT(*)
FROM ed_waiting_times

UNION ALL

SELECT
    'Four-Hour Performance',
    COUNT(*)
FROM ed_four_hour_performance

UNION ALL

SELECT
    'Time in ED',
    COUNT(*)
FROM ed_duration;


-- ============================================================
-- 2. VALIDATE ED PRESENTATIONS
-- Check available counts, suppressed values and coverage.
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(presentations_numeric)
        AS valid_presentation_counts,

    SUM(presentations_numeric IS NULL)
        AS missing_presentation_counts,

    SUM(presentations_original = '<5')
        AS suppressed_presentation_counts,

    COUNT(DISTINCT financial_year)
        AS reporting_years,

    COUNT(DISTINCT triage_category)
        AS triage_categories,

    SUM(presentations_numeric < 0)
        AS negative_presentation_counts

FROM ed_presentations;


-- ============================================================
-- 3. VALIDATE PATIENTS SEEN ON TIME
-- Check missing values, suppression and caution indicators.
-- Performance values are stored as proportions (0 to 1).
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(presentations_numeric)
        AS valid_presentation_counts,

    SUM(presentations_numeric IS NULL)
        AS missing_presentation_counts,

    SUM(presentations_original = '<5')
        AS suppressed_presentation_counts,

    COUNT(seen_on_time_numeric)
        AS valid_performance_values,

    SUM(seen_on_time_numeric IS NULL)
        AS unavailable_performance_values,

    SUM(
        seen_on_time_numeric < 0
        OR seen_on_time_numeric > 1
    ) AS invalid_performance_values,

    COUNT(peer_group_average_numeric)
        AS valid_peer_averages,

    SUM(peer_group_average_numeric IS NULL)
        AS unavailable_peer_averages,

    SUM(
        peer_group_average_numeric < 0
        OR peer_group_average_numeric > 1
    ) AS invalid_peer_averages,

    SUM(data_quality_caution = 1)
        AS caution_records,

    SUM(data_quality_caution IS NULL)
        AS missing_caution_flags

FROM ed_waiting_times;


-- ============================================================
-- 4. VALIDATE FOUR-HOUR ED PERFORMANCE
-- Check numerical values, suppression and quality flags.
-- Performance values are stored as proportions (0 to 1).
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(presentations_numeric)
        AS valid_presentation_counts,

    SUM(presentations_numeric IS NULL)
        AS missing_presentation_counts,

    SUM(presentations_original = '<5')
        AS suppressed_presentation_counts,

    COUNT(within_4hrs_numeric)
        AS valid_performance_values,

    SUM(within_4hrs_numeric IS NULL)
        AS unavailable_performance_values,

    SUM(
        within_4hrs_numeric < 0
        OR within_4hrs_numeric > 1
    ) AS invalid_performance_values,

    COUNT(peer_group_average_numeric)
        AS valid_peer_averages,

    SUM(peer_group_average_numeric IS NULL)
        AS unavailable_peer_averages,

    SUM(
        peer_group_average_numeric < 0
        OR peer_group_average_numeric > 1
    ) AS invalid_peer_averages,

    SUM(data_quality_caution = 1)
        AS caution_records,

    SUM(data_quality_caution IS NULL)
        AS missing_caution_flags

FROM ed_four_hour_performance;


-- ============================================================
-- 5. VALIDATE TIME IN ED
-- Check presentation counts, duration measures,
-- peer benchmarks and separate data-quality indicators.
-- All duration measures are expressed in minutes.
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    COUNT(presentations_numeric)
        AS valid_presentation_counts,

    SUM(presentations_numeric IS NULL)
        AS missing_presentation_counts,

    SUM(presentations_original = '<5')
        AS suppressed_presentation_counts,

    COUNT(median_minutes)
        AS valid_median_durations,

    SUM(median_minutes IS NULL)
        AS unavailable_median_durations,

    COUNT(p90_minutes)
        AS valid_p90_durations,

    SUM(p90_minutes IS NULL)
        AS unavailable_p90_durations,

    COUNT(peer_p90_minutes)
        AS valid_peer_benchmarks,

    SUM(peer_p90_minutes IS NULL)
        AS unavailable_peer_benchmarks,

    SUM(
        peer_group = 'Unpeered'
        AND peer_p90_minutes_raw = 0
        AND peer_p90_minutes IS NULL
    ) AS reclassified_zero_benchmarks,

    SUM(
        median_minutes < 0
        OR p90_minutes < 0
        OR peer_p90_minutes < 0
    ) AS negative_duration_records,

    SUM(median_quality_caution = 1)
        AS median_caution_records,

    SUM(p90_quality_caution = 1)
        AS p90_caution_records

FROM ed_duration;


-- ============================================================
-- 6. VALIDATE DURATION CONSISTENCY
-- A P90 duration should not be lower than its median.
-- ============================================================

SELECT
    COUNT(*) AS total_records,

    SUM(
        median_minutes IS NOT NULL
        AND p90_minutes IS NOT NULL
    ) AS records_with_both_durations,

    SUM(
        median_minutes IS NOT NULL
        AND p90_minutes IS NOT NULL
        AND p90_minutes < median_minutes
    ) AS inconsistent_durations

FROM ed_duration;


-- ============================================================
-- 7. VALIDATE DATA-QUALITY FLAGS
-- Compare caution counts and missing caution indicators.
-- ============================================================

SELECT
    'Patients Seen on Time' AS dataset,

    SUM(data_quality_caution = 1)
        AS caution_records,

    SUM(data_quality_caution IS NULL)
        AS missing_flags

FROM ed_waiting_times

UNION ALL

SELECT
    'Four-Hour Performance',

    SUM(data_quality_caution = 1),

    SUM(data_quality_caution IS NULL)

FROM ed_four_hour_performance

UNION ALL

SELECT
    'Time in ED - Median',

    SUM(median_quality_caution = 1),

    SUM(median_quality_caution IS NULL)

FROM ed_duration

UNION ALL

SELECT
    'Time in ED - P90',

    SUM(p90_quality_caution = 1),

    SUM(p90_quality_caution IS NULL)

FROM ed_duration;


-- ============================================================
-- 8. CHECK DUPLICATE BUSINESS KEYS
-- Check duplicate reporting combinations without
-- relying on the auto-generated primary key.
-- Expected result: 0 duplicate groups in each table.
-- ============================================================

SELECT
    'ED Presentations' AS dataset,
    COUNT(*) AS duplicate_groups
FROM (
    SELECT 1
    FROM ed_presentations
    GROUP BY
        reporting_unit_type,
        reporting_unit,
        state,
        financial_year,
        triage_category
    HAVING COUNT(*) > 1
) AS p

UNION ALL

SELECT
    'Patients Seen on Time',
    COUNT(*)
FROM (
    SELECT 1
    FROM ed_waiting_times
    GROUP BY
        reporting_unit_type,
        reporting_unit,
        state,
        financial_year,
        triage_category
    HAVING COUNT(*) > 1
) AS w

UNION ALL

SELECT
    'Four-Hour Performance',
    COUNT(*)
FROM (
    SELECT 1
    FROM ed_four_hour_performance
    GROUP BY
        reporting_unit_type,
        reporting_unit,
        state,
        financial_year,
        patient_cohort
    HAVING COUNT(*) > 1
) AS f

UNION ALL

SELECT
    'Time in ED',
    COUNT(*)
FROM (
    SELECT 1
    FROM ed_duration
    GROUP BY
        reporting_unit_type,
        reporting_unit,
        state,
        financial_year,
        patient_cohort
    HAVING COUNT(*) > 1
) AS d;


-- ============================================================
-- END OF DATA VALIDATION
-- ============================================================
