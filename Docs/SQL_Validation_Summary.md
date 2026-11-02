
# SQL Data Validation Summary

## Project
Australian Hospital Emergency Department Analytics

## Validation Overview

The project uses MySQL to validate emergency department
data sourced from the Australian Institute of Health and
Welfare (AIHW).

Validation checks include:
- Record counts and missing values
- Suppressed and unavailable measurements
- Percentage and duration consistency
- Duplicate business keys
- Data-quality caution indicators
- Staging-table uniqueness and record matching

## Validated Results

| Dataset | Total Records | Quality-Caution Records |
|---|---:|---:|
| ED Waiting Times | 21,972 | 385 |
| Four-Hour Performance | 36,289 | 306 |
| ED Duration | 13,611 | 94 |

For ED Duration, 94 records have both median and P90
quality-caution indicators set to True.

## Caution Staging Validation

| Staging Table | Flagged Records | Duplicate Key Groups |
|---|---:|---:|
| Waiting-Time Staging | 385 | 0 |
| Four-Hour Staging | 306 | 0 |
| ED Duration Staging | 94 | 0 |

All staging records were matched to their corresponding
analytical records using reporting identifiers.

## Data Handling

- Original source values were retained alongside cleaned
  numeric measurements.
- Suppressed and unavailable numeric values were not
  automatically converted to zero.
- Published percentages, medians and percentiles were
  handled at their appropriate reporting levels.
- The caution staging tables use an exception-only design:
  matched flagged records receive True, while unmatched
  records are assigned False.

## Limitations

These checks establish consistency within the imported
datasets. They do not independently verify the completeness
or correctness of the original AIHW source data.

The interpretation of quality-caution indicators follows
the project's exception-only staging convention.
