
-- ============================================================
-- PROJECT: Australian Hospital Emergency Department Analytics
-- FILE: 05_data_transformations.sql
-- PURPOSE: Convert imported values into analytical measures
--          and restore AIHW data-quality caution indicators.
-- SOURCE: Australian Institute of Health and Welfare (AIHW)
-- ============================================================

-- IMPORTANT:
-- Run this script only after importing cleaned CSV data
-- into the main tables and importing the caution staging data.
--
-- Do not run the entire script on the validated production
-- dataset without first verifying the staging tables.
--
-- NULL represents suppressed, unavailable or
-- non-applicable numeric values.
-- ============================================================

USE australian_hospital_ed;


-- ============================================================
-- SECTION 1: ED PRESENTATIONS
-- ============================================================

-- The cleaned presentations CSV already contains
-- presentations_numeric.
--
-- Validate the values without modifying the table.

SELECT
    COUNT(*) AS total_records,
    COUNT(presentations_numeric) AS valid_counts,
    SUM(presentations_numeric IS NULL) AS missing_counts,
    SUM(presentations_original = '<5') AS suppressed_counts
FROM ed_presentations;


-- ============================================================
-- SECTION 2: PATIENTS SEEN ON TIME
-- Convert presentation counts and on-time proportions.
-- ============================================================

UPDATE ed_waiting_times
SET
    presentations_numeric = CASE
        WHEN TRIM(presentations_original)
             REGEXP '^[0-9]+$'
        THEN CAST(
            TRIM(presentations_original) AS UNSIGNED
        )
        ELSE NULL
    END,

    seen_on_time_numeric = CASE
        WHEN TRIM(seen_on_time_original)
             REGEXP '^[0-9]+([.][0-9]+)?$'
        THEN CAST(
            TRIM(seen_on_time_original) AS DECIMAL(5,4)
        )
        ELSE NULL
    END
WHERE id > 0;


-- Convert waiting-time peer-group averages

UPDATE ed_waiting_times
SET peer_group_average_numeric = CASE
    WHEN TRIM(peer_group_average_original)
         REGEXP '^[0-9]+([.][0-9]+)?$'
    THEN CAST(
        TRIM(peer_group_average_original) AS DECIMAL(5,4)
    )
    ELSE NULL
END
WHERE id > 0;


-- ============================================================
-- SECTION 3: RESTORE WAITING-TIME CAUTION FLAGS
-- Match staging records using reporting identifiers.
--
-- <=> performs NULL-safe equality in MySQL.
-- It allows matching records with missing identifier values.
-- ============================================================

UPDATE ed_waiting_times AS w
LEFT JOIN waiting_time_caution_staging AS s
    ON w.reporting_unit <=> s.reporting_unit
    AND w.reporting_unit_type <=> s.reporting_unit_type
    AND w.state <=> s.state
    AND w.financial_year <=> s.financial_year
    AND w.triage_category <=> s.triage_category
SET w.data_quality_caution =
    COALESCE(s.data_quality_caution, 0)
WHERE w.id > 0;


-- ============================================================
-- SECTION 4: FOUR-HOUR ED PERFORMANCE
-- Convert presentation counts and four-hour proportions.
-- ============================================================

UPDATE ed_four_hour_performance
SET
    presentations_numeric = CASE
        WHEN TRIM(presentations_original)
             REGEXP '^[0-9]+$'
        THEN CAST(
            TRIM(presentations_original) AS UNSIGNED
        )
        ELSE NULL
    END,

    within_4hrs_numeric = CASE
        WHEN TRIM(within_4hrs_original)
             REGEXP '^[0-9]+([.][0-9]+)?$'
        THEN CAST(
            TRIM(within_4hrs_original) AS DECIMAL(5,4)
        )
        ELSE NULL
    END
WHERE id > 0;


-- Convert four-hour peer-group averages

UPDATE ed_four_hour_performance
SET peer_group_average_numeric = CASE
    WHEN TRIM(peer_group_average_original)
         REGEXP '^[0-9]+([.][0-9]+)?$'
    THEN CAST(
        TRIM(peer_group_average_original) AS DECIMAL(5,4)
    )
    ELSE NULL
END
WHERE id > 0;


-- ============================================================
-- SECTION 5: RESTORE FOUR-HOUR CAUTION FLAGS
-- ============================================================

UPDATE ed_four_hour_performance AS f
LEFT JOIN four_hour_caution_staging AS s
    ON f.reporting_unit <=> s.reporting_unit
    AND f.reporting_unit_type <=> s.reporting_unit_type
    AND f.state <=> s.state
    AND f.financial_year <=> s.financial_year
    AND f.patient_cohort <=> s.patient_cohort
SET f.data_quality_caution =
    COALESCE(s.data_quality_caution, 0)
WHERE f.id > 0;


-- ============================================================
-- SECTION 6: TIME IN ED
-- Convert presentation counts and duration measurements.
-- ============================================================

-- Convert presentation counts

UPDATE ed_duration
SET presentations_numeric = CASE
    WHEN TRIM(presentations_original)
         REGEXP '^[0-9]+$'
    THEN CAST(
        TRIM(presentations_original) AS UNSIGNED
    )
    ELSE NULL
END
WHERE id > 0;


-- Convert median ED duration from text into minutes

UPDATE ed_duration
SET median_minutes = CASE
    WHEN TRIM(median_time_original)
         REGEXP '^[0-9]+ hrs? [0-9]+ mins?$'
    THEN
        CAST(
            SUBSTRING_INDEX(
                TRIM(median_time_original), ' ', 1
            ) AS UNSIGNED
        ) * 60
        +
        CAST(
            SUBSTRING_INDEX(
                SUBSTRING_INDEX(
                    TRIM(median_time_original), ' ', 3
                ),
                ' ', -1
            ) AS UNSIGNED
        )
    ELSE NULL
END
WHERE id > 0;


-- Convert P90 ED duration from text into minutes

UPDATE ed_duration
SET p90_minutes = CASE
    WHEN TRIM(p90_time_original)
         REGEXP '^[0-9]+ hrs? [0-9]+ mins?$'
    THEN
        CAST(
            SUBSTRING_INDEX(
                TRIM(p90_time_original), ' ', 1
            ) AS UNSIGNED
        ) * 60
        +
        CAST(
            SUBSTRING_INDEX(
                SUBSTRING_INDEX(
                    TRIM(p90_time_original), ' ', 3
                ),
                ' ', -1
            ) AS UNSIGNED
        )
    ELSE NULL
END
WHERE id > 0;


-- ============================================================
-- SECTION 7: PEER-GROUP P90 BENCHMARKS
-- Preserve the original numeric conversion before cleaning.
-- ============================================================

UPDATE ed_duration
SET peer_p90_minutes_raw = CASE
    WHEN TRIM(peer_p90_original)
         REGEXP '^[0-9]+ hrs? [0-9]+ mins?$'
    THEN
        CAST(
            SUBSTRING_INDEX(
                TRIM(peer_p90_original), ' ', 1
            ) AS UNSIGNED
        ) * 60
        +
        CAST(
            SUBSTRING_INDEX(
                SUBSTRING_INDEX(
                    TRIM(peer_p90_original), ' ', 3
                ),
                ' ', -1
            ) AS UNSIGNED
        )
    ELSE NULL
END
WHERE id > 0;


-- Exclude artificial zero-minute benchmarks
-- for hospitals classified as Unpeered.

UPDATE ed_duration
SET peer_p90_minutes = CASE
    WHEN peer_group = 'Unpeered'
         AND peer_p90_minutes_raw = 0
    THEN NULL
    ELSE peer_p90_minutes_raw
END
WHERE id > 0;


-- ============================================================
-- SECTION 8: RESTORE ED DURATION CAUTION FLAGS
-- Preserve separate median and P90 caution indicators.
-- ============================================================

UPDATE ed_duration AS d
LEFT JOIN time_in_ed_caution_staging AS s
    ON d.reporting_unit <=> s.reporting_unit
    AND d.reporting_unit_type <=> s.reporting_unit_type
    AND d.state <=> s.state
    AND d.financial_year <=> s.financial_year
    AND d.patient_cohort <=> s.patient_cohort
SET
    d.median_quality_caution =
        COALESCE(s.median_quality_caution, 0),

    d.p90_quality_caution =
        COALESCE(s.p90_quality_caution, 0)
WHERE d.id > 0;


-- ============================================================
-- SECTION 9: FINAL RECORD COUNT VALIDATION
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
-- SECTION 10: FINAL DATA-QUALITY VALIDATION
-- ============================================================

SELECT
    'Waiting Times' AS dataset,
    SUM(data_quality_caution = 1) AS caution_records,
    SUM(data_quality_caution IS NULL) AS missing_flags
FROM ed_waiting_times

UNION ALL

SELECT
    'Four-Hour Performance',
    SUM(data_quality_caution = 1),
    SUM(data_quality_caution IS NULL)
FROM ed_four_hour_performance

UNION ALL

SELECT
    'ED Duration - Median',
    SUM(median_quality_caution = 1),
    SUM(median_quality_caution IS NULL)
FROM ed_duration

UNION ALL

SELECT
    'ED Duration - P90',
    SUM(p90_quality_caution = 1),
    SUM(p90_quality_caution IS NULL)
FROM ed_duration;


-- ============================================================
-- SECTION 11: VALIDATE ED DURATION CONSISTENCY
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
    ) AS inconsistent_durations,

    SUM(
        peer_group = 'Unpeered'
        AND peer_p90_minutes_raw = 0
        AND peer_p90_minutes IS NULL
    ) AS reclassified_zero_benchmarks

FROM ed_duration;


-- ============================================================
-- END OF DATA TRANSFORMATIONS
-- ============================================================


