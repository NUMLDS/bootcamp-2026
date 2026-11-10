# Run this file from the capstone project root in a fresh R session.
# Each script reads the previous stage's saved output.
if (!file.exists("data/raw/nys_schools.csv")) {
  stop("Open Capstone.Rproj or set the working directory to the project root.")
}
source("scripts/1_clean.R")
source("scripts/2_transform.R")
source("scripts/3_analyze.R")
source("scripts/4_plot.R")

# RStudio normally exposes Pandoc automatically. These locations also support
# command-line rendering on this Mac; other systems can use Pandoc on PATH.
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("Install the rmarkdown package before rendering the report.")
}
if (!rmarkdown::pandoc_available()) {
  arch <- if (grepl("aarch64|arm64", R.version$arch)) "aarch64" else "x86_64"
  candidates <- c(
    file.path("/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools", arch),
    file.path(path.expand("~/Desktop/RStudio.app/Contents/Resources/app/quarto/bin/tools"), arch)
  )
  available <- candidates[file.exists(file.path(candidates, "pandoc"))]
  if (length(available)) Sys.setenv(RSTUDIO_PANDOC = available[[1]])
  rmarkdown::find_pandoc(cache = FALSE)
}
if (!rmarkdown::pandoc_available()) {
  stop("Pandoc was not found. Run in RStudio or install Pandoc and rerun.")
}
# A separate environment makes the notebook read its own saved inputs.
rmarkdown::render("report.Rmd", envir = new.env(parent = globalenv()),
                  encoding = "UTF-8", quiet = TRUE)
message("Complete: open report.html to view the results.")
