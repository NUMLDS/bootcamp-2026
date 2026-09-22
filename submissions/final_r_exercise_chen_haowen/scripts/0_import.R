# ---------------------------------------------------------------------------
# 0_import.R
# Task 1: Import the raw data
#
# Purpose : Read the two raw CSV files into R and nothing else.
#           No cleaning, recoding or merging happens here -- those jobs live
#           in their own numbered scripts so each step can be re-run alone.
#
# Inputs  : data/raw/nys_schools.csv   (NY State Dept. of Education, school level)
#           data/raw/nys_acs.csv       (US Census ACS, county level)
# Outputs : two objects in the global environment: `nys_schools`, `nys_acs`
#
# Note    : paths are relative to the project root, which is where the
#           .Rproj file lives -- open the project first, never setwd().
# ---------------------------------------------------------------------------

library(tidyverse)   # readr::read_csv() comes from here

# --- where the raw files are expected to live ------------------------------
raw_dir       <- file.path("data", "raw")
schools_path  <- file.path(raw_dir, "nys_schools.csv")
acs_path      <- file.path(raw_dir, "nys_acs.csv")

# --- fail early with a readable message if the download is missing ---------
# (the CSVs are not tracked here; download them from the Drive link in the
#  README and drop them into data/raw/ before sourcing this script)
missing <- c(schools_path, acs_path)[!file.exists(c(schools_path, acs_path))]
if (length(missing) > 0) {
  stop(
    "Missing raw data file(s):\n  ",
    paste(missing, collapse = "\n  "),
    "\nDownload nys_schools.csv and nys_acs.csv into data/raw/ first ",
    "(see README.md for the link)."
  )
}

# --- read the data ---------------------------------------------------------
# read_csv() (readr) rather than read.csv(): returns a tibble, does not
# convert strings to factors, and prints the column types it guessed.
# -99 is the raw missing-value code in these files; it is handled in
# 1_clean.R (Task 3) rather than here, so that the import stays a faithful
# copy of what is on disk.
nys_schools <- read_csv(schools_path, show_col_types = TRUE)
nys_acs     <- read_csv(acs_path,     show_col_types = TRUE)

# --- minimal confirmation that the import worked ---------------------------
message("Imported nys_schools: ", nrow(nys_schools), " rows x ", ncol(nys_schools), " cols")
message("Imported nys_acs:     ", nrow(nys_acs),     " rows x ", ncol(nys_acs),     " cols")
