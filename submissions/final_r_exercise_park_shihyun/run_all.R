# run_all.R
# Purpose: Run the full project from raw data to final report, in order

source("scripts/1_clean.R")
source("scripts/2_transform.R")
source("scripts/3_analyze.R")
source("scripts/4_plot.R")

# Render the notebook to HTML
rmarkdown::render("final_report.Rmd")