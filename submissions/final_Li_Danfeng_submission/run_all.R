### Reproduce the full analysis from a fresh R session.
#
# Run from the project root, e.g. from a terminal:
#   Rscript run_all.R
# or open Bootcamp_capstone.Rproj in RStudio (which sets the working
# directory to the project root) and source() this file.
#
# This regenerates everything in data/processed/ (cleaned data, tables,
# figures) and re-knits the notebook to HTML.

source("scripts/1_cleaned.R")
source("scripts/2_summary_tables.R")
source("scripts/3_visualizations.R")

rmarkdown::render("poverty_and_test_performance.Rmd", output_format = "html_document")
