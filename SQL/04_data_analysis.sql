
-- ============================================================
-- PROJECT: Australian Hospital Emergency Department Analytics
-- FILE: 04_data_analysis.sql
-- PURPOSE: Analyse ED demand, timeliness, duration and
--          hospital performance using AIHW reporting data.
-- DATABASE: MySQL 8.0+
-- ============================================================

USE australian_hospital_ed;


-- ============================================================
-- PRE-FLIGHT: VERIFY PUBLISHED AGGREGATE RECORDS
-- Check that national and state published performance
-- records are unique at their intended reporting grain.
--
-- Expected result: 0 rows.
--
-- If duplicates are found, investigate them before
-- interpreting Q4, Q5, Q8 and Q9.
-- ============================================================

SELECT
    'Waiting Times - National' AS dataset,
    financial_year,
    triage_category AS reporting_category,
    NULL AS state,
    COUNT(*) AS record_count
FROM ed_waiting_times
WHERE reporting_unit_type = 'National'
GROUP BY financial_year, triage_category
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'Four-Hour - National',
    financial_year,
    patient_cohort,
    NULL,
    COUNT(*)
FROM ed_four_hour_performance
WHERE reporting_unit_type = 'National'
GROUP BY financial_year, patient_cohort
HAVING COUNT(*) > 1

UNION ALL

SELECT
    'Four-Hour - State',
    financial_year,
    patient_cohort,
    state,
    COUNT(*)
FROM ed_four_hour_performance
WHERE reporting_unit_type = 'State'
GROUP BY financial_year, patient_cohort, state
HAVING COUNT(*) > 1;


-- ============================================================
-- QUESTION 1: NATIONAL ED PRESENTATION TRENDS
-- How has emergency department demand changed over time?
--
-- National records are used to avoid double-counting
-- state-level and hospital-level presentations.
-- ============================================================

SELECT
    financial_year,
    SUM(presentations_numeric) AS total_presentations
FROM ed_presentations
WHERE reporting_unit_type = 'National'
    AND presentations_numeric IS NOT NULL
GROUP BY financial_year
ORDER BY financial_year;


-- ============================================================
-- QUESTION 2: YEAR-ON-YEAR ED PRESENTATION GROWTH
-- How much did national ED demand change each year?
--
-- LAG() retrieves the previous financial year's total.
-- The first year has no previous-year comparison.
-- ============================================================

WITH yearly_presentations AS (
    SELECT
        financial_year,
        SUM(presentations_numeric) AS total_presentations
    FROM ed_presentations
    WHERE reporting_unit_type = 'National'
        AND presentations_numeric IS NOT NULL
    GROUP BY financial_year
),
yearly_growth AS (
    SELECT
        financial_year,
        total_presentations,
        LAG(total_presentations) OVER (
            ORDER BY financial_year
        ) AS previous_year_presentations
    FROM yearly_presentations
)

SELECT
    financial_year,
    total_presentations,
    previous_year_presentations,
    ROUND(
        100.0 *
        (total_presentations - previous_year_presentations)
        / NULLIF(previous_year_presentations, 0),
        2
    ) AS yoy_growth_pct
FROM yearly_growth
ORDER BY financial_year;


-- ============================================================
-- QUESTION 3: ED PRESENTATIONS BY STATE (2024-25)
-- Which states recorded the highest ED demand?
--
-- State-level records are used exclusively.
-- Counts are absolute volumes, not per-capita rates.
-- ============================================================

SELECT
    state,
    SUM(presentations_numeric) AS total_presentations
FROM ed_presentations
WHERE reporting_unit_type = 'State'
    AND financial_year = '2024-25'
    AND presentations_numeric IS NOT NULL
GROUP BY state
ORDER BY total_presentations DESC;


-- ============================================================
-- QUESTION 4: ON-TIME TREATMENT BY TRIAGE CATEGORY
-- How does treatment timeliness vary by triage category?
--
-- Use the published national performance proportion.
-- Do not average percentages across reporting units.
--
-- Assumes one national record per year and triage
-- category, as checked by the pre-flight query.
-- ============================================================

SELECT
    triage_category,
    presentations_numeric AS total_presentations,
    ROUND(
        seen_on_time_numeric * 100,
        2
    ) AS on_time_percentage
FROM ed_waiting_times
WHERE reporting_unit_type = 'National'
    AND financial_year = '2024-25'
    AND seen_on_time_numeric IS NOT NULL
ORDER BY on_time_percentage ASC;


-- ============================================================
-- QUESTION 5: NATIONAL FOUR-HOUR ED PERFORMANCE TREND
-- How has timely ED departure performance changed?
--
-- Use published national All patients percentages.
-- Do not calculate averages of published percentages.
--
-- Assumes one national All patients record per year.
-- ============================================================

SELECT
    financial_year,
    presentations_numeric AS total_presentations,
    ROUND(
        within_4hrs_numeric * 100,
        2
    ) AS within_4hrs_percentage
FROM ed_four_hour_performance
WHERE reporting_unit_type = 'National'
    AND patient_cohort = 'All patients'
    AND within_4hrs_numeric IS NOT NULL
ORDER BY financial_year;


-- ============================================================
-- QUESTION 6: NATIONAL ED DURATION TRENDS
-- How have median and P90 ED stay durations changed?
--
-- Median and P90 are non-additive statistical measures.
-- Retrieve published national values directly.
--
-- Expected grain: one national All patients row per year.
-- ============================================================

SELECT
    financial_year,
    presentations_numeric AS total_presentations,
    median_minutes,
    p90_minutes
FROM ed_duration
WHERE reporting_unit_type = 'National'
    AND patient_cohort = 'All patients'
    AND median_minutes IS NOT NULL
    AND p90_minutes IS NOT NULL
ORDER BY financial_year;


-- ============================================================
-- QUESTION 7: ED DURATION BY PATIENT COHORT (2024-25)
-- How do ED stays differ by admission outcome?
--
-- Use published national duration values directly.
-- All patients overlaps with the other cohorts.
-- Do not sum overlapping cohort totals.
-- ============================================================

SELECT
    patient_cohort,
    presentations_numeric AS total_presentations,
    median_minutes,
    p90_minutes
FROM ed_duration
WHERE reporting_unit_type = 'National'
    AND financial_year = '2024-25'
    AND patient_cohort IN (
        'All patients',
        'Subsequently admitted patients',
        'Not subsequently admitted patients'
    )
    AND median_minutes IS NOT NULL
    AND p90_minutes IS NOT NULL
ORDER BY p90_minutes DESC;


-- ============================================================
-- QUESTION 8: FOUR-HOUR PERFORMANCE BY PATIENT COHORT
-- How does timely ED departure differ by admission outcome?
--
-- Use published national cohort-specific percentages.
-- Do not aggregate overlapping patient cohorts.
--
-- Assumes one national record per cohort and year.
-- ============================================================

SELECT
    patient_cohort,
    presentations_numeric AS total_presentations,
    ROUND(
        within_4hrs_numeric * 100,
        2
    ) AS within_4hrs_percentage
FROM ed_four_hour_performance
WHERE reporting_unit_type = 'National'
    AND financial_year = '2024-25'
    AND patient_cohort IN (
        'All patients',
        'Subsequently admitted patients',
        'Not subsequently admitted patients'
    )
    AND within_4hrs_numeric IS NOT NULL
ORDER BY within_4hrs_percentage ASC;


-- ============================================================
-- QUESTION 9: FOUR-HOUR PERFORMANCE BY STATE (2024-25)
-- Which states had the highest and lowest departure rates?
--
-- Use published state-level All patients percentages.
-- Do not average individual hospital performance rates.
--
-- Assumes one state record per year and cohort.
-- ============================================================

SELECT
    state,
    presentations_numeric AS total_presentations,
    ROUND(
        within_4hrs_numeric * 100,
        2
    ) AS within_4hrs_percentage
FROM ed_four_hour_performance
WHERE reporting_unit_type = 'State'
    AND financial_year = '2024-25'
    AND patient_cohort = 'All patients'
    AND within_4hrs_numeric IS NOT NULL
ORDER BY within_4hrs_percentage DESC;


-- ============================================================
-- QUESTION 10: HOSPITAL PERFORMANCE VS PEER BENCHMARK
-- Which hospitals have the largest negative performance gaps?
--
-- Eligibility:
-- Hospital records only
-- Financial year 2024-25
-- All patients cohort
-- Valid hospital and peer benchmark percentages
-- At least 1,000 presentations
-- No data-quality caution flag
--
-- Gap is expressed in percentage points.
-- Negative gaps indicate below-benchmark performance.
-- The 1,000-presentation threshold is an analytical choice.
-- ============================================================

SELECT
    reporting_unit AS hospital,
    state,
    peer_group,
    presentations_numeric AS total_presentations,

    ROUND(
        within_4hrs_numeric * 100,
        2
    ) AS hospital_performance_pct,

    ROUND(
        peer_group_average_numeric * 100,
        2
    ) AS peer_average_pct,

    ROUND(
        (within_4hrs_numeric - peer_group_average_numeric) * 100,
        2
    ) AS performance_gap_pp

FROM ed_four_hour_performance

WHERE reporting_unit_type = 'Hospital'
    AND financial_year = '2024-25'
    AND patient_cohort = 'All patients'
    AND within_4hrs_numeric IS NOT NULL
    AND peer_group_average_numeric IS NOT NULL
    AND presentations_numeric >= 1000
    AND data_quality_caution = 0

ORDER BY
    performance_gap_pp ASC,
    total_presentations DESC
LIMIT 10;


-- ============================================================
-- QUESTION 11: HOSPITAL PERFORMANCE DISTRIBUTION
-- How many eligible hospitals perform above, below or
-- equal to their peer-group benchmarks?
--
-- Uses the same eligibility criteria as Question 10.
-- Classification uses published numeric precision.
-- ============================================================

WITH hospital_performance AS (
    SELECT
        reporting_unit AS hospital,
        state,
        peer_group,
        presentations_numeric,
        within_4hrs_numeric,
        peer_group_average_numeric,

        CASE
            WHEN within_4hrs_numeric < peer_group_average_numeric
                THEN 'Below benchmark'

            WHEN within_4hrs_numeric > peer_group_average_numeric
                THEN 'Above benchmark'

            ELSE 'Equal to benchmark'
        END AS performance_status

    FROM ed_four_hour_performance

    WHERE reporting_unit_type = 'Hospital'
        AND financial_year = '2024-25'
        AND patient_cohort = 'All patients'
        AND within_4hrs_numeric IS NOT NULL
        AND peer_group_average_numeric IS NOT NULL
        AND presentations_numeric >= 1000
        AND data_quality_caution = 0
)

SELECT
    performance_status,
    COUNT(*) AS hospital_count,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_hospitals

FROM hospital_performance
GROUP BY performance_status
ORDER BY hospital_count DESC;


-- ============================================================
-- QUESTION 12: BELOW-BENCHMARK PERFORMANCE BY PEER GROUP
-- Which peer groups have the largest proportion of
-- eligible hospitals below their own peer benchmarks?
--
-- This compares the share of hospitals below benchmark,
-- not the absolute performance of peer groups.
--
-- Uses the same eligibility criteria as Questions 10-11.
-- ============================================================

WITH hospital_performance AS (
    SELECT
        reporting_unit,
        peer_group,
        presentations_numeric,
        within_4hrs_numeric,
        peer_group_average_numeric,

        CASE
            WHEN within_4hrs_numeric < peer_group_average_numeric
                THEN 1
            ELSE 0
        END AS below_benchmark

    FROM ed_four_hour_performance

    WHERE reporting_unit_type = 'Hospital'
        AND financial_year = '2024-25'
        AND patient_cohort = 'All patients'
        AND within_4hrs_numeric IS NOT NULL
        AND peer_group_average_numeric IS NOT NULL
        AND presentations_numeric >= 1000
        AND data_quality_caution = 0
)

SELECT
    peer_group,
    COUNT(*) AS total_hospitals,
    SUM(below_benchmark) AS hospitals_below_benchmark,

    ROUND(
        SUM(below_benchmark) * 100.0 / COUNT(*),
        2
    ) AS percentage_below_benchmark

FROM hospital_performance
GROUP BY peer_group
ORDER BY
    percentage_below_benchmark DESC,
    total_hospitals DESC;


-- ============================================================
-- END OF SQL DATA ANALYSIS
-- ============================================================
