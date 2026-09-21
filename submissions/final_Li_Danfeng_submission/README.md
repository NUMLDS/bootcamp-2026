# Poverty and Test Performance in New York Public Schools

Capstone analysis for a data-analyst scenario at the NYC Department of
Education: what does the data say about the relationship between poverty and
test performance in New York public schools, whether it differs across
poverty tiers, whether it has changed over time, and whether it's moderated
by access to free/reduced-price lunch.

**Start here:** [`poverty_and_test_performance.html`](poverty_and_test_performance.html)
— the rendered notebook with the full walkthrough, tables, charts, and
written answers to each question.

## Folder contents

```
data/
  data_raw/                      Original, untouched source files
    nys_schools.csv              School-level enrollment, lunch %, ELA/math scores (2008-2017)
    nys_acs.csv                  County-level poverty rate, income, education (2009-2016)
    nys_codebook.md              Column definitions for both raw files
  processed/
    nys_schools_acs_cleaned.csv  Cleaned + joined dataset (missing values recoded,
                                  poverty_group tier, z_math/z_ela added)
    tables/                      Summary tables (Task 5), one CSV each
    figures/                     Chart PNGs (Task 6)

scripts/
  1_cleaned.R                    Reads raw data, recodes -99 to NA, joins the two
                                  sources, builds poverty tiers and year-standardized
                                  z-scores, writes nys_schools_acs_cleaned.csv
  2_summary_tables.R             Builds the five summary tables from the cleaned data
  3_visualizations.R             Builds the three ggplot2 charts

poverty_and_test_performance.Rmd   Notebook: full narrative, code, tables, and charts
poverty_and_test_performance.html  Rendered notebook (open this to read the analysis)
run_all.R                          Reproduces everything above from a fresh R session
```

## Reproducing the analysis

Every script uses paths relative to the project root, so open
`Bootcamp_capstone.Rproj` in RStudio first (this sets the working directory
correctly), or run from a terminal in this folder:

```r
Rscript run_all.R
```

This re-runs the three scripts in `scripts/` in order and re-knits the
notebook to HTML. Verified from a clean `Rscript` process with `data/processed/`
deleted beforehand, so it doesn't depend on anything left over in memory or
on disk from a previous run. Requires `tidyverse`, `scales`, `knitr`, and
`rmarkdown`.

## Key finding

High-poverty counties score about 0.6 SD below low-poverty counties on
combined math/ELA performance, and school-level free/reduced-lunch access
predicts performance about as strongly as county poverty does — but that gap
has been narrowing since 2009, driven by high-poverty counties improving.
See the notebook for the full breakdown and caveats.
