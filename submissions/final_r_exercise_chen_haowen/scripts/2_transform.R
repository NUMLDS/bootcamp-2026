# ---------------------------------------------------------------------------
# 2_transform.R
# Task 4: Join the school-level and county-level data
#
# Expects `nys_schools_clean` / `nys_acs_clean` from scripts/1_clean.R.
# Writes the merged school-level file to data/processed/.
# ---------------------------------------------------------------------------

library(tidyverse)

# ===========================================================================
# Join decision
# ===========================================================================
# Join key: county_name + year. Checked beforehand that all 62 county names
# match exactly between the two files (no spelling/casing mismatches to
# clean up).
#
# Join type: left_join(nys_schools_clean, nys_acs_clean, ...) -- schools is
# the base table we want to keep intact (it's the level our questions are
# asked at: "test performance"), and the ACS variables are added as extra
# context where available. An inner_join would silently drop every school
# record from years the ACS file doesn't cover.
#
# That matters here: nys_schools_clean spans 2008-2017, but nys_acs_clean
# only spans 2009-2016, so school-years from 2008 and 2017 (about 7,080
# rows, ~20% of the data) will have NA for the ACS columns after the join.
# left_join keeps those rows (with NAs) rather than silently deleting them;
# they simply drop out later whenever an analysis groups by poverty_group or
# uses a county-level variable, since NA %in% na.rm-based summaries.
nys_merged <- nys_schools_clean %>%
  left_join(nys_acs_clean, by = c("county_name", "year"))

# ===========================================================================
# Save the merged dataset
# ===========================================================================
write_csv(nys_merged, file.path("data", "processed", "nys_merged.csv"))

message("Saved data/processed/nys_merged.csv (", nrow(nys_merged), " rows)")
message(
  "Rows with no ACS match (years 2008/2017, expected): ",
  sum(is.na(nys_merged$county_per_poverty))
)
