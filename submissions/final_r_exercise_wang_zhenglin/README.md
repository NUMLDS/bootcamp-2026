# New York school and county poverty analysis

This R project examines how school lunch eligibility and county poverty relate to 2016 math and English Language Arts (ELA) performance. Open `r6_capstone.Rproj` in RStudio, then open `report.html` to read the finished report.

## Folder contents

- `data/raw/nys_schools.csv`: original school enrollment, lunch, and test-score data.
- `data/raw/nys_acs.csv`: original county poverty and demographic data.
- `data/processed/`: cleaned school and county files plus `final_school_data.csv`, the joined analysis file.
- `scripts/1_clean.R`: removes duplicates and converts missing-value codes.
- `scripts/2_transform.R`: creates poverty groups, yearly test-score z-scores, and the joined data.
- `scripts/3_analyze.R`: builds county summary tables.
- `scripts/4_plot.R`: reserved for additional plots.
- `report.Rmd`: self-contained analysis notebook with tables, charts, and written findings.
- `report.html`: rendered report for viewing in a browser.
- `run_all.R`: currently empty.

## Reproduce the report

The report reads `data/processed/final_school_data.csv`. From the project folder, install the R packages `dplyr`, `tidyr`, `ggplot2`, `readr`, `knitr`, and `rmarkdown` if needed. Then render with:

```r
rmarkdown::render("report.Rmd")
```

To rebuild the processed data from the raw files first, run these scripts in order in one R session:

```r
source("scripts/1_clean.R")
source("scripts/2_transform.R")
```

The report focuses on 2016, the latest year common to the school and county poverty data. The analysis is descriptive: differences between groups are associations, not evidence of causation.
