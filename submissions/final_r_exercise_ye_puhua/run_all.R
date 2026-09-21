# Run every project script in the required order.
# Start R from the capstone project before running this file.

source("scripts/1_clean.R")
source("scripts/2_transform.R")
source("scripts/3_analyze.R")
source("scripts/4_plot.R")

rmarkdown::render("capstone_report.Rmd")