# New York school poverty and performance

This R project analyzes the supplied NYS school and ACS county files. It covers
New York State, not only NYC. The matched analysis covers 2009–2016, with 2016
used for the latest-year comparisons.

## Run

Open `Capstone.Rproj`, start a fresh R session, and run:

```r
source("run_all.R")
```

Dependencies: R 4.1 or newer (for `|>`), `tidyverse`, `rmarkdown`, `knitr`, and
`scales`. Rendering also needs Pandoc, normally included with RStudio. Install
missing packages with `install.packages(c("tidyverse", "rmarkdown", "knitr", "scales"))`.
The runner also detects the bundled Pandoc in common RStudio paths on this Mac.
All paths are relative to the project root. Open `report.html` in a browser;
the HTML contains its figures and does not need an internet connection.

## Contents

- `data/raw/`: unchanged CSV inputs and the supplied codebook.
- `data/processed/`: cleaned, transformed, and merged datasets.
- `scripts/1_clean.R`: inspect data, handle missing codes, remove exact duplicates
  and invalid lunch-proportion records.
- `scripts/2_transform.R`: annual poverty thirds, annual score z-scores, and a
  left join on county and year; unmatched school records remain in this file.
- `scripts/3_analyze.R`: matched county-year and school-level summary tables.
- `scripts/4_plot.R`: three ggplot2 figures.
- `outputs/tables/`: county-year summaries, top/bottom five counties, poverty-group
  trends and gaps, school lunch correlations, and matching coverage.
- `outputs/figures/`: PNG figures used by the report.
- `report.Rmd` / `report.html`: source notebook / rendered report.
- `run_all.R`: execute the scripts in order and render the report.

## Decisions and interpretation

The cleaning step removes 24 duplicate rows and 86 invalid lunch-proportion
records, leaving 35,553 school-year records. Other missing values are retained.
The county-poverty analyses exclude unmatched records, including 2008 and 2017.

Poverty groups are redefined each year using `ntile(..., 3)`, so thresholds and
membership can change and ties can be split. Enrollment is summed per county
and year. County lunch eligibility uses enrollment weights with complete inputs;
the CSV reports the enrollment coverage. County score averages weight schools
equally; poverty-group comparisons weight counties equally. Test-participation
counts are unavailable, so these are not student-weighted test-score means.

Annual z-scores express relative standing, not absolute learning gains. Lunch
eligibility is not participation or a causal treatment. The report describes
associations and does not formally establish moderation or program effects.

## Data source

The supplied course files are described as originating from the New York State
Department of Education and the US Census Bureau's American Community Survey.
See `data/raw/nys_codebook.md`. No external data were added.
