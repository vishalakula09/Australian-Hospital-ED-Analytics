
# Australian Hospital Emergency Department Analytics
## SQL Analysis Findings

### 1. Project Overview

This project analyses Australian emergency department (ED) performance using publicly available data from the Australian Institute of Health and Welfare (AIHW).

The objective is to understand changes in ED demand, treatment timeliness, patient length of stay, and hospital performance relative to peer-group benchmarks.

Python was used for data cleaning and preparation, MySQL for data validation and analysis, and Power BI will be used to develop an interactive dashboard.

### 2. Data Sources

Four datasets were cleaned, imported and validated in MySQL.

| Dataset | Records |
|---|---:|
| ED Presentations | 22,678 |
| Patients Seen on Time | 21,972 |
| Four-Hour Performance | 36,289 |
| Time in ED | 13,611 |
| **Total** | **94,550** |

The datasets cover 14 financial years, from 2011–12 to 2024–25.

The total represents records across four reporting datasets, not unique ED visits.

Data preparation included handling suppressed values, converting numerical fields, standardising financial years, preserving data-quality caution indicators and checking for duplicate reporting combinations.

All four analytical tables passed the final row-count and duplicate business-key checks.

### 3. Key SQL Analysis Findings

#### 3.1 National Emergency Department Demand

National ED presentations increased from approximately 6.54 million in 2011–12 to 9.09 million in 2024–25.

This represents an increase of approximately 39% over the reporting period.

The highest annual presentation volume was recorded in 2024–25.

**Business insight:** The long-term increase in ED demand highlights the importance of monitoring patient volumes and planning for changing service requirements.

#### 3.2 Year-on-Year ED Demand Growth

Annual ED presentation growth varied considerably.

Key observations:

- Largest annual increase: 7.12% in 2013–14.
- Second-largest increase: 6.95% in 2020–21.
- Largest annual decline: 1.38% in 2019–20.
- Most recent annual growth: 0.84% in 2024–25.

**Business insight:** ED demand has generally increased, but annual fluctuations indicate that historical growth should not be assumed to remain constant.

#### 3.3 State-Level Presentation Volumes

In 2024–25, New South Wales recorded approximately 3.16 million ED presentations, followed by Victoria with 1.98 million and Queensland with 1.77 million.

Together, these three states accounted for approximately 75.9% of national ED presentations.

**Business insight:** High-volume states account for a substantial share of total ED activity. However, absolute presentation counts should not be interpreted as per-capita demand.

#### 3.4 On-Time Treatment by Triage Category

National on-time treatment performance in 2024–25 varied across triage categories.

| Triage category | Seen on time |
|---|---:|
| Resuscitation | 100% |
| Non-Urgent | 89% |
| Semi-Urgent | 70% |
| Emergency | 68% |
| Urgent | 61% |

Urgent patients had the lowest on-time treatment rate and represented the largest reported triage category, with approximately 3.62 million presentations.

**Business insight:** Urgent and Emergency categories warrant further investigation to understand the operational circumstances associated with missed treatment-time targets.

Each triage category has a different recommended treatment timeframe, so these percentages should not be interpreted as direct comparisons of absolute waiting times.

#### 3.5 Four-Hour ED Departure Performance

The percentage of patients departing ED within four hours reached 73% between 2013–14 and 2015–16.

By 2024–25, this had declined to 53%, representing a 20 percentage-point reduction from the peak.

Between 2011–12 and 2024–25, four-hour departure performance decreased from 64% to 53%.

**Business insight:** Timely ED departures have become less common over the reporting period, suggesting a need to investigate patient flow and operational constraints.

#### 3.6 Median and P90 ED Stay Durations

National ED stay durations increased between 2011–12 and 2024–25.

| Measure | 2011–12 | 2024–25 |
|---|---:|---:|
| Median ED duration | 178 minutes | 228 minutes |
| P90 ED duration | 508 minutes | 676 minutes |

Median duration increased by approximately 28.1%, while P90 duration increased by approximately 33.1%.

The longer P90 duration indicates that extended ED stays are an important part of the overall performance picture.

**Business insight:** Monitoring both median and P90 durations provides a more complete view of patient experience than relying on a single measure.

These are reported distribution statistics, not average durations per patient.

#### 3.7 ED Stay Duration by Patient Cohort

In 2024–25, subsequently admitted patients experienced longer ED stays than patients who were not subsequently admitted.

| Patient cohort | Median stay | P90 stay |
|---|---:|---:|
| Subsequently admitted | 373 minutes | 1,137 minutes |
| Not subsequently admitted | 190 minutes | 464 minutes |
| All patients | 228 minutes | 676 minutes |

The median stay for admitted patients was 183 minutes longer than for non-admitted patients.

The P90 difference was 673 minutes.

**Business insight:** Admission-related patient flow is an important area for further analysis, including potential investigation of inpatient bed availability and transfer processes.

These results do not establish the causes of prolonged stays.

#### 3.8 Four-Hour Performance by Patient Cohort

In 2024–25, four-hour departure rates differed substantially between admitted and non-admitted patients.

| Patient cohort | Within four hours |
|---|---:|
| Subsequently admitted | 30% |
| Not subsequently admitted | 64% |
| All patients | 53% |

The difference between admitted and non-admitted patients was 34 percentage points.

**Business insight:** Subsequently admitted patients experienced significantly lower timely departure performance, consistent with their longer reported ED stay durations.

#### 3.9 Four-Hour Performance by State

Four-hour departure performance varied across Australian jurisdictions in 2024–25.

| State or territory | Within four hours |
|---|---:|
| ACT | 61% |
| NSW | 56% |
| WA | 54% |
| NT | 54% |
| Victoria | 53% |
| Queensland | 50% |
| South Australia | 50% |
| Tasmania | 47% |

The ACT recorded the highest rate, while Tasmania recorded the lowest.

The difference between these jurisdictions was 14 percentage points.

**Business insight:** Jurisdiction-level comparisons reveal variation in performance, but differences in patient mix, geography and healthcare systems must be considered.

#### 3.10 Hospital Performance Against Peer Benchmarks

Hospital-level analysis compared reported four-hour departure percentages with AIHW peer-group averages.

The analysis focused on 2024–25 hospital records with at least 1,000 presentations, available benchmarks and performance values, and no data-quality caution flag.

Hospitals with the largest negative gaps included:

| Hospital | State | Gap vs peer average |
|---|---|---:|
| Palmerston Regional Hospital | NT | -23 pp |
| Maitland Hospital | NSW | -21 pp |
| Werribee Mercy Hospital | VIC | -19 pp |
| Caboolture Hospital | QLD | -18 pp |
| Bass Coast Health | VIC | -16 pp |

**Business insight:** Peer benchmarking can help identify hospitals for further investigation and provide context beyond raw performance rankings.

A negative benchmark gap does not independently establish poor hospital quality.

#### 3.11 Distribution of Hospital Benchmark Performance

Among 207 eligible hospital records in 2024–25:

| Performance category | Hospitals | Percentage |
|---|---:|---:|
| Above benchmark | 104 | 50.24% |
| Below benchmark | 93 | 44.93% |
| Equal to benchmark | 10 | 4.83% |

**Business insight:** Approximately 45% of eligible hospitals were below their peer-group average, indicating that negative benchmark gaps were not limited to a small number of hospitals.

#### 3.12 Below-Benchmark Performance by Peer Group

The proportion of eligible hospitals below their peer benchmark varied by hospital group.

| Peer group | Hospitals below benchmark |
|---|---:|
| Major hospitals | 58.06% |
| Large metropolitan hospitals | 56.67% |
| Children's hospitals | 50.00% |
| Medium regional hospitals | 47.83% |
| Large regional hospitals | 46.67% |
| Medium metropolitan hospitals | 40.91% |
| Small hospitals | 32.31% |

Major hospitals had the highest proportion below benchmark, followed by large metropolitan hospitals.

**Business insight:** These patterns suggest opportunities for further investigation into challenges experienced by major and metropolitan hospitals.

However, peer-group benchmarks differ, and sample sizes vary across groups.

### 4. Overall Business Implications

The analysis identifies several important patterns:

1. National ED demand increased substantially over the reporting period.
2. Four-hour departure performance declined while reported ED stay durations increased.
3. Subsequently admitted patients experienced considerably longer stays and lower four-hour departure rates.
4. State-level and hospital-level performance varied.
5. Peer-group benchmarking revealed potential improvement areas across multiple hospital types.

Together, these findings indicate the value of monitoring emergency department demand, patient flow and performance indicators through a consolidated analytical dashboard.

### 5. Data Quality and Limitations

Several considerations are important when interpreting the results.

- Suppressed presentation counts such as "<5" were preserved rather than treated as zero.
- Unavailable indicators were retained as missing values.
- AIHW data-quality caution flags were preserved in MySQL.
- The datasets contain different reporting levels and patient cohorts, which can overlap.
- National, state and hospital records were analysed separately to avoid double-counting.
- Reported percentages may be rounded.
- Peer benchmarks are intended to support contextual comparison, not definitive hospital rankings.
- Hospital and jurisdictional comparisons do not fully control for patient complexity, operational capacity or population differences.
- The analysis is descriptive and does not establish causal relationships.

### 6. Business Recommendations

Based on the findings, the following actions could be considered:

**Recommendation 1: Monitor ED demand trends**

Use historical presentations and annual growth rates to support demand monitoring and capacity planning.

**Recommendation 2: Investigate prolonged ED stays**

Review hospitals and patient cohorts with high median and P90 durations to identify potential patient-flow issues.

**Recommendation 3: Examine admission pathways**

Investigate factors associated with extended ED stays among subsequently admitted patients, including transfer processes and inpatient capacity.

**Recommendation 4: Use peer benchmarking responsibly**

Identify hospitals with substantial negative benchmark gaps for further review while considering differences in hospital characteristics and case mix.

**Recommendation 5: Develop a consolidated performance dashboard**

Use Power BI to monitor presentation volumes, treatment timeliness, four-hour departure performance, ED durations and peer-group comparisons.

### 7. Next Steps

The next stage is to build an interactive Power BI dashboard.

Planned features include:

- National ED demand trends
- Year-on-year presentation growth
- State-level comparisons
- Treatment performance by triage category
- Four-hour departure trends
- Median and P90 ED duration analysis
- Patient cohort comparisons
- Hospital peer-benchmark performance
- Filters for financial year, state, patient cohort and hospital group where applicable

The final dashboard will support clearer communication of the analytical findings and demonstrate an end-to-end workflow from raw data preparation to business insights.

### 8. Tools and Technologies

- Python and Pandas — data cleaning and preparation
- MySQL — relational storage, data validation and SQL analysis
- MySQL Workbench — database management and query execution
- Power BI — planned dashboard development
- VS Code and Jupyter Notebook — development and documentation
- Git and GitHub — project version control and portfolio presentation

### 9. Conclusion

The analysis highlights a long-term increase in Australian emergency department presentations alongside declining four-hour departure performance and increasing ED stay durations.

Subsequently admitted patients experienced particularly long stays, while hospital benchmarking identified variation across states and peer groups.

The findings provide a foundation for an interactive Power BI dashboard and demonstrate how cleaned healthcare reporting data can support evidence-based operational analysis.
