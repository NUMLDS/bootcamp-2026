# Poverty and Test Performance in New York Public Schools

MLDS Boot Camp final R exercise. Read **[`reports/report.html`](reports/report.html)**.

## Findings

- High-poverty counties trail low-poverty counties by **0.67 SDs** in ELA and math.
- That gap **halved between 2009 and 2016** (0.97 → 0.43 SDs), driven by high-poverty counties improving.
- Free/reduced lunch share does **not** moderate the relationship — it predicts scores equally well in every poverty tier and explains 46% of variance on its own, making it the better targeting variable.

## Contents

```
├── final_r_exercise_ma_charlie.Rproj
├── run_all.R          runs scripts 1-4, then knits the report
├── data/
│   ├── raw/           nys_schools.csv, nys_acs.csv (untouched)
│   └── processed/     cleaned and merged outputs
├── scripts/
│   ├── 1_clean.R      -99 -> NA, dedupe, poverty terciles, within-year z-scores
│   ├── 2_transform.R  join schools to ACS on county_name + year
│   ├── 3_analyze.R    summary tables -> output/tables/
│   └── 4_plot.R       figures        -> output/figures/
├── output/            tables/ and figures/
└── reports/           report.Rmd and knitted report.html
```

Scripts are numbered because each reads the previous one's output from
`data/processed/`. The `.Rmd` reads those outputs rather than recomputing them.

## Reproduce

`nys_schools.csv` is not in this repo (the class `.gitignore` excludes it for
size). Download it into `data/raw/`, then from a fresh session with the
`.Rproj` open:

```r
source("run_all.R")
```

Needs tidyverse, rmarkdown, knitr, here. Everything in `data/processed/` and
`output/` is generated, so those folders can be empty on a fresh clone.

## Data sources

- `nys_schools.csv` — [NYS Department of Education](http://data.nysed.gov/downloads.php)
- `nys_acs.csv` — American Community Survey, US Census Bureau
