# Final R Exercise: Poverty and Test Performance in NY Schools

Shihyun Park, MLDS Boot Camp

## Question
How is poverty related to test performance in New York public schools, how has this changed over time, and does free/reduced price lunch share play a role?

## Folder structure
- `final_r_exercise_park_shihyun.Rproj`: R project file
- `data/raw/`: original data (`nys_schools.csv`, `nys_acs.csv`)
- `data/processed/`: cleaned and merged data created by the scripts
- `scripts/1_clean.R`: import data, recode missing values, remove duplicates, fix invalid percentages
- `scripts/2_transform.R`: create poverty groups, standardize scores by year, merge datasets
- `scripts/3_analyze.R`: summary tables
- `scripts/4_plot.R`: visualizations
- `final_report.Rmd`: notebook with process, tables, plots, and takeaways
- `final_report.html`: rendered report (open this to read the findings)
- `run_all.R`: runs all scripts in order and renders the report

## How to run
Open the `.Rproj` file in RStudio, then run `run_all.R`.