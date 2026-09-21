# NY Schools & Poverty Analysis

This project explores the relationship between county-level poverty/income data (American Community Survey) and school-level performance and demographic data (NYS Department of Education) across New York State.

## Project Structure

```
bootcamp_capstone/
├── README.md
├── data/
│   ├── raw/
│   │   ├── nys_schools.csv      # Raw school-level data from NYS DOE
│   │   └── nys_acs.csv          # Raw county-level ACS data
│   └── processed/
│       ├── schools_clean.csv    # Cleaned school-level data
│       ├── acs_clean.csv        # Cleaned county-level ACS data
│       └── schools_joined.csv   # Joined + derived-variable dataset used for analysis
└── scripts/
    ├── 1_clean.R                # Reads raw data, cleans it, writes to data/processed/
    ├── 2_transform.R            # Reads cleaned data, creates derived variables, joins, writes schools_joined.csv
    └── 3_analyze_and_plot.R     # Reads schools_joined.csv, builds summary tables and visualizations
```

## Data Sources

| File | Location | Level | Description |
|---|---|---|---|
| `nys_schools.csv` | `data/raw/` | School-year | Raw, unprocessed school-level data as provided by NYS DOE |
| `nys_acs.csv` | `data/raw/` | County-year | Raw, unprocessed county-level ACS data |
| `acs_clean.csv` | `data/processed/` | County-year | Poverty rate, median household income, % bachelor's degree, by county and year (2009–2016) |
| `schools_clean.csv` | `data/processed/` | School-year | Enrollment, free/reduced lunch %, LEP %, mean ELA/math scores, by school and year (2008–2017) |
| `schools_joined.csv` | `data/processed/` | School-year | `schools_clean` left-joined with `acs_clean` on `county_name` + `year`, plus derived variables (see below) |

## Scripts (Pipeline)

Run in order from the project root:

### `scripts/1_clean.R`
Reads `data/raw/nys_schools.csv` and `data/raw/nys_acs.csv`, cleans each independently, and writes results to `data/processed/`.

- Removes exact duplicate rows (`distinct()`).
- Converts sentinel/placeholder values (`-99`, `"-99"`) to proper `NA`s across relevant columns.
- Corrects invalid percentages: `per_free_lunch` and `per_reduced_lunch` values greater than 1 (impossible for a proportion) are set to `NA`.
- Outputs: `data/processed/schools_clean.csv`, `data/processed/acs_clean.csv`.

### `scripts/2_transform.R`
Reads the two cleaned files from `data/processed/`, creates derived variables, and joins them.

- **`poverty_group`** — categorical (`low` / `medium` / `high`), based on tertile splits of `county_per_poverty`, informed by a histogram of the distribution.
- **`math_z`, `ela_z`** — standardized z-scores for math and ELA scores, computed **within each year** (`group_by(year)`) using `scale()`. This accounts for the fact that NYS changes its standardized tests periodically, making raw scale scores non-comparable across years.
- **Join**: `schools_clean` (school-year grain) is `left_join()`ed with `acs_clean` (county-year grain) on `county_name` and `year`. A left join is used to preserve every school-year observation (even where no matching ACS data exists — 2008 and 2017 fall outside ACS coverage and will show `NA` for ACS-derived columns) and to correctly broadcast county-level ACS values to every school within that county-year (many-to-one relationship).
- Output: `data/processed/schools_joined.csv`.

**Known data quality note:** `schools_clean` contains 63 unique counties vs. 62 in `acs_clean` — one county does not find a match in the ACS data. This may be a genuine gap or a naming inconsistency (e.g. whitespace, abbreviation) and is worth verifying before drawing county-level conclusions.

### `scripts/3_analyze_and_plot.R`
Reads `data/processed/schools_joined.csv` and produces summary tables and visualizations.

**Summary tables:**
- **County-level summary** — total enrollment, average % free/reduced lunch, and average poverty rate per county.
- **Top 5 / bottom 5 poverty counties** — poverty rate, free/reduced lunch %, and mean reading/math performance, to compare the highest- and lowest-poverty counties directly.

**Visualizations** — built with `ggplot2` + `ggthemes::theme_wsj()`, following a takeaway-driven title convention (stating the finding, not just the axes):
1. **Free/reduced lunch access vs. math performance (school level)** — scatterplot with a linear trend line, using standardized `math_z` scores. A follow-up version splits free lunch and reduced lunch into separate colored trend lines to compare their relationships to performance independently.
2. **Average test performance by poverty group (county level)** — bar chart with standard error bars, comparing standardized math scores across `low` / `medium` / `high` poverty counties.

## Requirements

```r
install.packages(c("tidyverse", "ggthemes"))
```

Core packages used: `dplyr`, `tidyr`, `ggplot2`, `ggthemes`, `scales`.

## Usage

From the `bootcamp_capstone/` project root:

```r
source("scripts/1_clean.R")
source("scripts/2_transform.R")
source("scripts/3_analyze_and_plot.R")
```

Each script reads its inputs from and writes its outputs to the `data/processed` subfolders described above, so they must be run in order the first time.

## Notes / Next Steps

- Confirm the source of the county count mismatch between `schools_clean` and `acs_clean`.
- Consider an ELA-score version of each visualization alongside the math-score versions shown here.
- Poverty groups are currently assigned per county **per year** (since poverty rate can shift over time) — an alternative approach fixing each county to a single group based on its multi-year average poverty rate may be preferable depending on the analysis goal.