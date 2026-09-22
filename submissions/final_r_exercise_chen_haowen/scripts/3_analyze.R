# ---------------------------------------------------------------------------
# 3_analyze.R
# Task 5: Summary tables
#
# Expects `nys_merged` from scripts/2_transform.R.
# ---------------------------------------------------------------------------

library(tidyverse)

# ===========================================================================
# Helper: one row per county-year first, then average across years
# ===========================================================================
# Each metric is collapsed in two steps: (1) summarise within a single
# county-year (summing enrollment across schools, averaging the rest across
# schools in that county-year), then (2) average those county-year values
# across all years present, to get one representative row per county rather
# than picking a single year arbitrarily. Simple (unweighted) means are used
# across schools -- i.e. every school counts equally regardless of size --
# which keeps the summary easy to read; a version weighted by enrollment
# would be a reasonable alternative but adds real complexity for a table
# whose job is a quick department-facing overview.
#
# 19 rows have county_name == NA (the original literal "-99" location
# records recoded in 1_clean.R) -- filtered out here, otherwise
# group_by(county_name) turns them into a spurious "unknown county" row.
county_year <- nys_merged %>%
  filter(!is.na(county_name)) %>%
  group_by(county_name, year) %>%
  summarise(
    year_total_enroll     = sum(total_enroll, na.rm = TRUE),
    year_pct_free_reduced = mean(per_free_lunch + per_reduced_lunch, na.rm = TRUE),
    year_mean_ela_z       = mean(ela_z, na.rm = TRUE),
    year_mean_math_z      = mean(math_z, na.rm = TRUE),
    year_pct_poverty      = mean(county_per_poverty, na.rm = TRUE),
    .groups = "drop"
  )

county_profile <- county_year %>%
  group_by(county_name) %>%
  summarise(
    total_enrollment       = round(mean(year_total_enroll, na.rm = TRUE)),
    pct_free_reduced_lunch = mean(year_pct_free_reduced, na.rm = TRUE),
    pct_poverty            = mean(year_pct_poverty, na.rm = TRUE),
    mean_ela_z             = mean(year_mean_ela_z, na.rm = TRUE),
    mean_math_z            = mean(year_mean_math_z, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(pct_poverty))

# ===========================================================================
# Table 5.1: one row per county -- enrollment, lunch access, poverty
# ===========================================================================
table_county_summary <- county_profile %>%
  select(county_name, total_enrollment, pct_free_reduced_lunch, pct_poverty)

# ===========================================================================
# Table 5.2: top 5 / bottom 5 counties by poverty rate
# ===========================================================================
top5_poverty <- county_profile %>%
  slice_max(pct_poverty, n = 5) %>%
  mutate(poverty_rank = "Top 5 (highest poverty)")

bottom5_poverty <- county_profile %>%
  slice_min(pct_poverty, n = 5) %>%
  mutate(poverty_rank = "Bottom 5 (lowest poverty)")

table_top_bottom_poverty <- bind_rows(top5_poverty, bottom5_poverty) %>%
  select(poverty_rank, county_name, pct_poverty, pct_free_reduced_lunch,
         mean_ela_z, mean_math_z)

# ===========================================================================
# Print for the reproducibility check (run_all.R); also used directly in
# analysis_notebook.Rmd
# ===========================================================================
message("\n--- Table 5.1: county summary (enrollment / lunch / poverty) ---")
print(table_county_summary)

message("\n--- Table 5.2: top 5 / bottom 5 poverty counties ---")
print(table_top_bottom_poverty)
