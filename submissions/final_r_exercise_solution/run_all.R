# run_all.R
# Runs the full pipeline from raw data to final report.

source("scripts/1_clean.R")
source("scripts/2_transform.R")
source("scripts/3_analyze.R")
source("scripts/4_plot.R")

rmarkdown::render("report.Rmd")
