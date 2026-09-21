pdf(NULL) 

source("scripts/1_clean.R")
source("scripts/2_transform.R")
source("scripts/3_analyze_plot.R")
rmarkdown::render("report.Rmd")
