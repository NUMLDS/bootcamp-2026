# Final R Exercise - Poverty and Test Performance in NY Public Schools

MLDS Boot Camp capstone. Analysis of the relationship between county poverty
and public school test performance in New York State.

**Status:** complete (Tasks 0-7). The pipeline runs end to end via
`run_all.R`, and the final findings are written up in
`analysis_notebook.Rmd` / `analysis_notebook.html`.

## Contents

| Path | What it is |
| --- | --- |
| `final_r_exercise.Rproj` | RStudio project file - open this first, so the working directory is the project root |
| `run_all.R` | Sources every script in order; the reproducibility check |
| `analysis_notebook.Rmd` | Write-up of the workflow, tables, plots and findings |
| `analysis_notebook.html` | Knitted version of the notebook - open this to read the results without running any code |
| `data/raw/` | Included: `nys_acs.csv` and `nys_codebook.md`; download `nys_schools.csv` as described below |
| `data/processed/` | Cleaned and merged datasets generated locally by the scripts; intentionally not tracked |
| `scripts/0_import.R` | Task 1 - reads `nys_schools.csv` and `nys_acs.csv` with `read_csv()` |
| `scripts/1_clean.R` | Task 3 - duplicates, missing values (`-99`), poverty groups, per-year z-scores |
| `scripts/2_transform.R` | Task 4 - joins the school and county datasets |
| `scripts/3_analyze.R` | Task 5 - summary tables |
| `scripts/4_plot.R` | Task 6 - ggplot2 figures |
| `output/` | Saved figures (`.png`) |

## The data

The source files come from the class Drive folder:

https://drive.google.com/drive/folders/1DcWIvLj2motQ5Nkfvjo6GFLcetfvssVq?usp=share_link

* `nys_schools.csv` - school-level data, NY State Department of Education
  (35,663 rows x 12 columns, 2008-2017). The class repository's `.gitignore`
  intentionally excludes this large file, so download it from the link above
  and place it in `data/raw/` before running the project.
* `nys_acs.csv` - county-level data, American Community Survey, US Census
  Bureau (496 rows x 5 columns, 2009-2016); included in this submission.
* `nys_codebook.md` - variable definitions for both files; included in this
  submission.

The class repository also ignores `data/processed/`. Running `run_all.R`
recreates that directory and all three processed CSV files.

Missing values in the raw files are coded as `-99`; they are recoded in
`scripts/1_clean.R`, not at import. `nys_acs.csv` covers a shorter year
range than `nys_schools.csv` -- see the notebook's Task 4 section for how
that's handled in the join.

## Key findings

See `analysis_notebook.html` (Task 7) for the full write-up. In short:
higher county poverty is associated with lower test performance
(`r = -0.33`), while school free/reduced-lunch share has a stronger negative
association with performance (`r = -0.66`). Average performance is `+0.36`,
`-0.02`, and `-0.25` z in low-, medium-, and high-poverty counties. The
low/high gap falls from `0.83` z in 2009 to `0.46` z in 2016 (about 44%
narrower), but does not close. An exploratory poverty-by-lunch interaction
has `p = 0.061`, so evidence that lunch eligibility moderates the
poverty-performance relationship is inconclusive rather than absent.

## Running it

1. Download `nys_schools.csv` from the class Drive link above and save it as
   `data/raw/nys_schools.csv`.
2. Open `final_r_exercise.Rproj` in RStudio.
3. Make sure the tidyverse is installed: `install.packages("tidyverse")`.
4. `source("run_all.R")` from a fresh session -- runs Tasks 1-6
   (import, clean, merge, summary tables, plots).
5. To reproduce the knitted write-up: open `analysis_notebook.Rmd` and
   Knit, or run `rmarkdown::render("analysis_notebook.Rmd")`.

`scripts/0_import.R` stops with an explicit message if either CSV is
missing from `data/raw/`.
