# Poverty and Test Performance in NYS Schools

## Setup

`nys_schools.csv` is not included in this repo (see `.gitignore`). Download it
and place it in `data/raw/` before running the pipeline:

```r
download.file(
  "https://drive.google.com/uc?export=download&id=1mSiER1YzRND4lSuRbj2LNBylApxSkBQ7",
  destfile = "data/raw/nys_schools.csv"
)
```

Or download it manually from the link above and move it into `data/raw/`.

Then:
1. Open `final_r_exercise_solution.Rproj` in RStudio.
2. Run `Rscript run_all.R` in the Terminal to run the full pipeline and
   render the report.

## Pipeline order
1. `scripts/1_clean.R` — cleans the raw data
2. `scripts/2_transform.R` — adds poverty groups, standardizes scores, merges data
3. `scripts/3_analyze.R` — builds summary tables
4. `scripts/4_plot.R` — builds the plots (also sourced by `report.Rmd`)
5. `report.Rmd` — renders the final report
