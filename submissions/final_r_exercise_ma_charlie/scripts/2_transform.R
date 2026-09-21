# 2_transform.R
# Merge the cleaned school-level data with the county-level ACS data.
library(tidyverse)

schools_clean <- read_csv("data/processed/nys_schools_clean.csv", show_col_types = FALSE)

# This is a hint from Claude: CSV has no factor type, so poverty_group reads back as character and would
# plot alphabetically (high, low, medium). Restore the meaningful order.
acs_clean <- read_csv("data/processed/nys_acs_clean.csv", show_col_types = FALSE) |>
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high")))

# Task 4
# Keys: county_name AND year. ACS is one row per county-year
# Joining method: left_join. It keeps the school as the unit of analysis. 
# For some years, we would get NA county data because ACS only covers 2009-2016
merged <- schools_clean |>
  left_join(acs_clean, by = c("county_name", "year"))

write_csv(merged, "data/processed/nys_merged.csv")