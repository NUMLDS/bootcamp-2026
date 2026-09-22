# NYS Schools & Poverty

Final R exercise. An analysis of how community poverty relates to standardized
test performance in New York State public schools, using school-level data from
the NYS Department of Education and county-level data from the US Census Bureau's
American Community Survey (ACS).

## The question

The NYC Department of Education asked:

1. How does access to free/reduced price lunch relate to test performance?
2. How does performance differ across low-, medium-, and high-poverty counties?
3. Has that relationship changed over time?
4. Is the relationship moderated by lunch access?

Findings are in `nys_schools_poverty_analysis.html` — open that file first.

## Folder contents

```
final_r_exercise_lastname_firstname/
├── final_r_exercise_lastname_firstname.Rproj
├── README.md
├── run_all.R
├── nys_schools_poverty_analysis.Rmd
├── nys_schools_poverty_analysis.html
├── data/
│   ├── raw/
│   │   ├── nys_schools.csv
│   │   └── nys_acs.csv
│   └── processed/
│       ├── schools_clean.csv
│       ├── acs_clean.csv
│       ├── merged.csv
│       ├── county_summary.csv
│       ├── top_bottom_summary.csv
│       └── poverty_group_summary.csv
├── scripts/
│   ├── 1_clean.R
│   ├── 2_transform.R
│   ├── 3_analyze.R
│   └── 4_plot.R
└── figures/
    ├── lunch_vs_performance.png
    ├── poverty_group_performance.png
    ├── gap_over_time.png
    └── collinearity.png
```

### Scripts

Each script does one job and writes its output to `data/processed/`, so any step
can be re-run without re-running the ones before it.

| Script | What it does |
|---|---|
| `1_clean.R` | Reads both raw CSVs. Removes duplicate rows, recodes `-99` sentinel values to `NA`, and flags lunch shares recorded above 1 as invalid. |
| `2_transform.R` | Builds the analysis variables: tertile-based poverty groups, within-year z-scores for math and ELA. Joins the school and ACS data on `county_name + year`. |
| `3_analyze.R` | Produces the summary tables (county profiles, top/bottom 5 counties by poverty, performance by poverty group). |
| `4_plot.R` | Produces the four figures in `figures/`, styled with a Wall Street Journal theme. |

### Data

`data/raw/` holds the two source files, unmodified. Nothing in the pipeline writes
to this folder.

`data/processed/` holds everything the scripts generate. All of it is
reproducible from `data/raw/` by running `run_all.R`, so these files can be
deleted and regenerated at any time.

**Note on the raw data:** if `data/raw/` is empty, download `nys_schools.csv` and
`nys_acs.csv` from the course Google Drive folder and place them there before
running anything.

## How to reproduce

1. Open `final_r_exercise_lastname_firstname.Rproj` in RStudio. This sets the
   working directory, so every file path in the scripts is relative to the
   project root and nothing needs editing.
2. Confirm both CSVs are in `data/raw/`.
3. Run `source("run_all.R")` from a fresh R session. This runs the four scripts
   in order and regenerates everything in `data/processed/` and `figures/`.
4. Knit `nys_schools_poverty_analysis.Rmd` to produce the HTML report.

### Required packages

```r
install.packages(c("tidyverse", "ggthemes", "scales", "knitr",
                   "broom", "rmarkdown"))
```

## Analytical decisions

Two choices in the pipeline were judgment calls rather than defaults, and both
affect how the results should be read.

**Poverty groups use tertiles**, not fixed policy thresholds. Tertiles keep the
three groups at comparable sizes, which keeps the group means stable. The
trade-off is that the cut points are specific to this dataset — they are not
comparable to a study that used, say, a 20% poverty threshold.

**Scores are standardized within each year.** The state changes its tests
periodically, so a raw scale score of 300 does not mean the same thing in two
different years. Converting to within-year z-scores makes every score a position
in that year's statewide distribution, which is what allows the over-time
comparison in the report to mean anything.

## Limitations

The analysis reports associations, not causal effects. Poverty is measured at the
county level while performance is measured at the school level, so a county-level
association cannot establish that the low-income students within those schools are
the ones scoring lower. The report discusses this and the other limitations in
more detail.

## Author

Yinuo Zhu