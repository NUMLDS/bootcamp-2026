# run_all.R
# Runs the whole project from a fresh session, in order. Paths are relative to
# the project root, so open the .Rproj first (or run: Rscript run_all.R).

pdf(NULL)  # suppress the default Rplots.pdf device when run via Rscript

source("scripts/1_clean.R")      # import, -99 -> NA, poverty groups, z-scores
source("scripts/2_transform.R")  # join schools to county ACS data
source("scripts/3_analyze.R")    # summary tables  -> output/tables/
source("scripts/4_plot.R")       # figures         -> output/figures/

rmarkdown::render("reports/report.Rmd")   # -> reports/report.html
