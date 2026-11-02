# Australian Hospital Emergency Department Analytics

### Python | SQL | Power BI | Healthcare Data Analytics

## Project Overview

This project analyses Australian hospital emergency department (ED) performance across financial years **2011–12 to 2024–25**.

The objective is to examine emergency department demand, patient flow, treatment timeliness and differences in performance between Australian states and territories.

The project combines Python-based data exploration, SQL data management and validation, and interactive Power BI dashboards to transform published healthcare statistics into actionable insights.

## Project Objectives

- Analyse historical trends in emergency department presentations.
- Examine changes in the percentage of patients departing emergency departments within four hours.
- Investigate median and 90th-percentile emergency department durations.
- Compare emergency department performance across Australian states and territories.
- Evaluate treatment timeliness across clinical triage categories.
- Develop interactive dashboards that communicate findings clearly to stakeholders.

## Data Sources

This project uses publicly available Australian hospital emergency department statistics published by the **Australian Institute of Health and Welfare (AIHW)**, covering financial years **2011–12 to 2024–25**.

The analysis includes four main datasets:

| Dataset | Description |
|---|---|
| ED Presentations | Emergency department presentation volumes across reporting years and jurisdictions |
| Four-Hour Performance | Percentage of patients departing the emergency department within four hours |
| ED Waiting Times | Percentage of patients receiving treatment within the recommended time for their triage category |
| ED Duration | Median and 90th-percentile emergency department length of stay |

The datasets include different reporting levels, including national, state/territory and individual hospital records.

**Source:** [Australian Institute of Health and Welfare](https://www.aihw.gov.au/)


### Data Attribution and Licensing

**Data Provider:** Australian Institute of Health and Welfare (AIHW)

**Reporting Period:** 2011–12 to 2024–25

**Licence:** AIHW material is generally available under the Creative Commons Attribution 4.0 International (CC BY 4.0) licence, unless otherwise specified.

The original datasets were obtained from publicly available AIHW emergency department reporting resources.

The datasets were explored, cleaned, validated and analysed using Python, MySQL and Power BI for educational and portfolio purposes.

This project is an independent analytical study and is not affiliated with or endorsed by AIHW.

**Source:** https://www.aihw.gov.au/

**Copyright and Licensing:** https://www.aihw.gov.au/copyright


## Project Methodology

### 1. Data Exploration — Python

- Explored the source datasets using Python and Jupyter Notebook.
- Reviewed dataset structure, reporting categories and available financial years.
- Investigated missing values and non-numeric entries.
- Examined historical patterns and data consistency.

### 2. Data Preparation and Validation — SQL

- Organised the datasets in a MySQL database.
- Retained original source fields alongside cleaned numeric measurements.
- Validated reporting levels, financial years and analytical records.
- Preserved missing measurements and data-quality indicators.
- Developed SQL queries to support national and jurisdictional comparisons.

### 3. Data Modelling — Power BI

- Imported four emergency department reporting tables.
- Created a shared financial-year dimension.
- Established active one-to-many relationships with single-direction filtering.
- Developed DAX measures for presentation volumes, year-on-year growth, four-hour performance and ED duration.

### 4. Dashboard Development — Power BI

Developed three interactive report pages:

1. **ED Overview:** Emergency department demand, year-on-year growth and historical performance trends.
2. **Patient Flow & Timeliness:** Patient duration, admission cohorts and treatment timeliness by triage category.
3. **State & Territory Performance:** Jurisdictional comparisons, performance differences and key business insights.

Financial-year slicers support historical comparisons, while selected trend charts display the complete reporting period.

## Key Analytical Findings

The following findings are based on the Australian Institute of Health and Welfare (AIHW) emergency department datasets, covering financial years 2011–12 to 2024–25.

### 1. Emergency Department Demand Increased

- National emergency department presentations increased from **6.54 million in 2011–12** to **9.09 million in 2024–25**.
- Presentations increased by approximately **39%** across the reporting period.
- In 2024–25, presentations increased by **0.84%** compared with the previous financial year.

### 2. Four-Hour Departure Performance Declined

- National four-hour departure performance was **64% in 2011–12** and **53% in 2024–25**.
- Performance peaked at approximately **73% during 2013–14 to 2015–16**.
- The rate declined from **55% in 2023–24** to **53% in 2024–25**, a decrease of 2 percentage points.

### 3. Emergency Department Durations Increased

- National median ED duration increased from **178 minutes in 2011–12** to **228 minutes in 2024–25**.
- The 90th-percentile duration increased from **508 minutes** to **676 minutes** over the same period.
- In 2024–25, subsequently admitted patients recorded a median ED duration of **373 minutes**, compared with **190 minutes** for patients who were not subsequently admitted.

### 4. Performance Varied Between Jurisdictions

For FY 2024–25:

- The **Australian Capital Territory (ACT)** recorded the highest four-hour departure rate at **61%**.
- **Tasmania** recorded the lowest four-hour departure rate at **47%**.
- The difference between the highest and lowest jurisdictions was **14 percentage points**.
- Tasmania recorded the longest median ED duration at **253 minutes**, while the ACT recorded the shortest at **208 minutes**.

### 5. Treatment Timeliness Differed by Triage Category

For FY 2024–25:

| Triage category | Patients seen on time |
|---|---:|
| Resuscitation | 100% |
| Non-Urgent | 89% |
| Semi-Urgent | 70% |
| Emergency | 68% |
| Urgent | 61% |

Each triage category has a different recommended treatment-time target, so these percentages should be interpreted within their respective clinical thresholds.

### Overall Interpretation

The analysis shows increasing emergency department demand alongside declining four-hour departure performance and longer patient durations over the reporting period.

Differences between jurisdictions and patient cohorts highlight variations in emergency department performance. However, these descriptive findings do not establish causation or account for differences in patient complexity, hospital capacity, admission patterns and other operational factors.


## Power BI Dashboards

Three interactive Power BI dashboard pages were developed to analyse Australian emergency department performance.

### 1. ED Overview

Displays national emergency department presentations, year-on-year growth, four-hour departure performance, historical trends and state-level presentation volumes.

![ED Overview Dashboard](../Screenshots/01_ED_Overview.png)

### 2. Patient Flow & Timeliness

Analyses median and 90th-percentile ED durations, patient-cohort differences, historical duration trends and treatment timeliness by triage category.

![Patient Flow and Timeliness Dashboard](../Screenshots/02_Patient_Flow_Timeliness.png)

### 3. State & Territory Performance

Compares four-hour departure rates and median ED durations across eight Australian states and territories. Includes highest- and lowest-performing jurisdictions, the percentage-point performance gap and a fixed FY 2024–25 insights summary.

![State and Territory Performance Dashboard](../Screenshots/03_State_Territory_Performance.png)

**Dashboard features:**
- Interactive financial-year selection
- Custom DAX measures and KPI cards
- Historical trend analysis
- State and territory comparisons
- Patient-cohort and triage-category analysis

## Data Quality and Limitations

- **Missing values:** Unavailable measurements and non-numeric source entries, including `NP` and `-`, were preserved rather than incorrectly converted to zero.
- **Quality indicators:** Median and 90th-percentile duration quality-caution flags were retained. Both flagged and unflagged records occur in the data.
- **Reporting levels:** National, state/territory and hospital-level records were distinguished to prevent double-counting.
- **Published statistics:** Four-hour percentages, medians and percentiles were retrieved from the published aggregate values instead of being calculated by averaging hospital statistics.
- **Comparability:** Jurisdictional differences are descriptive and do not account for patient complexity, hospital capacity or admission patterns.
- **Dashboard behaviour:** The historical trend charts display the full 2011–12 to 2024–25 period, while other visuals respond to financial-year selection. The fixed insights on the State & Territory Performance page describe FY 2024–25 only.

## Important Notes

This project is intended for educational and portfolio purposes. Findings should not be interpreted as causal evidence or as an assessment of individual hospital quality.

The source data and associated definitions should be consulted when interpreting reporting limitations and quality-caution indicators.

## Technologies Used

| Technology | Purpose |
|---|---|
| Python and Jupyter Notebook | Exploratory data analysis |
| SQL / MySQL | Database creation, data validation and analytical queries |
| Power BI | Interactive dashboards and visual analytics |
| DAX | Custom measures, year-on-year comparisons and performance indicators |
| Visual Studio Code | Project development and file organisation |
| GitHub | Version control and project presentation |


## How to Run the Project

### Prerequisites

- Python 3
- Jupyter Notebook or Visual Studio Code
- MySQL 8.0+
- Power BI Desktop (Windows)

### Python Analysis

1. Clone or download this repository.
2. Install the Python dependencies used by the notebook.
3. Open `Notebook/01_data_exploration.ipynb`.
4. Run the notebook with `Notebook/` as the working directory.

The notebook uses relative paths to locate the original AIHW workbook in `Data/` and saves cleaned datasets to `Data_Cleaned/`.

### SQL Analysis

1. Create the database using `SQL/01_database_setup.sql`.
2. Create the tables using `SQL/02_create_tables.sql`.
3. Import the relevant cleaned CSV files and caution staging datasets.
4. Run `SQL/05_data_transformations.sql` after verifying the imported staging data.
5. Validate the data using `SQL/03_data_validation.sql`.
6. Execute analytical queries in `SQL/04_data_analysis.sql`.

**Important:** The transformation script contains UPDATE statements and should not be rerun on an existing validated database without reviewing the staging data.

### Power BI Dashboard

Open `PowerBI/Australian_Hospital_ED_Analytics.pbix` in Power BI Desktop.

The report contains three dashboard pages with financial-year slicers, historical trends and jurisdictional comparisons.

The Power BI report was developed using imported MySQL data. Refreshing the report may require configuring a compatible local MySQL connection.
