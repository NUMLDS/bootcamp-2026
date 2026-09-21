# ---------------------------------------------------------------------------
# 1_clean.R
# Task 3: Missing values, poverty groups, standardized test scores
#
# Expects `nys_schools` / `nys_acs` from scripts/0_import.R (source that
# script, or run_all.R, before this one).
# Writes the cleaned school-level and county-level tables to data/processed/.
# ---------------------------------------------------------------------------

library(tidyverse)

# ===========================================================================
# Task 3.1: drop exact duplicate rows, recode -99 as NA
# ===========================================================================
# distinct() first: the raw nys_schools file has 24 fully duplicated rows
# (same value in every column) -- dropped before anything else so they don't
# get double-counted in later group_by()/summarise() steps.
#
# -99 is the missing-value sentinel in both raw files. It shows up in the
# obvious numeric columns (total_enroll, mean_math_score, ...), but Task 2
# exploration found it *also* appears as the literal string "-99" in three
# character columns of nys_schools (county_name, district_name, region) --
# the same 19 rows in each case -- so those three are recoded explicitly
# with na_if(), and every numeric column is recoded in one pass with
# across(where(is.numeric), ~ na_if(.x, -99)).
nys_schools_clean <- nys_schools %>%
  distinct() %>%
  mutate(
    county_name   = na_if(county_name, "-99"),
    district_name = na_if(district_name, "-99"),
    region        = na_if(region, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99))
  )

nys_acs_clean <- nys_acs %>%
  distinct() %>%
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))

# ===========================================================================
# Extra data-quality fix: lunch percentages above 1 set to NA
# ===========================================================================
# per_free_lunch and per_reduced_lunch are proportions and should never
# exceed 1 (100%), but Task 2 exploration found 44 / 2 rows respectively
# above 1 -- ranging from mild overshoots (1.01-1.87, likely rounding or
# double-counting) up to clear data-entry errors (22.06, 257, 53). These are
# treated as invalid and set to NA (rather than capped at 1) -- there's no
# way to tell which of the out-of-range values might still be "roughly
# right" and which are typos, so all of them are dropped as unreliable
# rather than guessing where to cap them.
nys_schools_clean <- nys_schools_clean %>%
  mutate(
    per_free_lunch    = if_else(per_free_lunch    > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

# ===========================================================================
# Task 3.2: low / medium / high poverty groups (county level)
# ===========================================================================
# Decision: split into tertiles (roughly equal-sized groups) using
# dplyr::ntile(), computed *within each year* rather than pooling all
# years together. county_per_poverty shifts slightly year to year, and
# grouping within year keeps "high poverty" meaning "relatively poor
# compared to other counties that same year" rather than mixing years with
# different overall economic conditions -- which matters later when we look
# at whether the poverty/performance relationship changes over time.
#
# ntile(x, 3) ranks counties and splits them into 3 equal-sized buckets, so
# group size is balanced by construction (as opposed to picking fixed
# percentage cutoffs by hand, which can leave lopsided groups).
nys_acs_clean <- nys_acs_clean %>%
  group_by(year) %>%
  mutate(
    poverty_group = case_when(
      ntile(county_per_poverty, 3) == 1 ~ "low",
      ntile(county_per_poverty, 3) == 2 ~ "medium",
      ntile(county_per_poverty, 3) == 3 ~ "high"
    ),
    poverty_group = factor(poverty_group, levels = c("low", "medium", "high"))
  ) %>%
  ungroup()

# ===========================================================================
# Task 3.3: standardized (z-score) test scores, computed within year
# ===========================================================================
# The test itself changes from year to year, so a raw scale score of, say,
# 650 does not mean the same thing in 2010 as in 2015. Converting to a
# z-score within each year -- "how many SDs above/below that year's mean" --
# makes scores comparable across years. group_by(year) + scale() computes
# the mean/SD separately per year rather than pooling everything into one
# mean/SD (which would just re-introduce the year-to-year comparability
# problem this step is meant to fix).
# scale() returns a 1-column matrix; as.numeric() flattens it to a plain
# vector so it stores as a normal tibble column.
nys_schools_clean <- nys_schools_clean %>%
  group_by(year) %>%
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) %>%
  ungroup()

# ===========================================================================
# Save the cleaned tables
# ===========================================================================
dir.create(file.path("data", "processed"), showWarnings = FALSE, recursive = TRUE)

write_csv(nys_schools_clean, file.path("data", "processed", "nys_schools_clean.csv"))
write_csv(nys_acs_clean,     file.path("data", "processed", "nys_acs_clean.csv"))

message("Saved data/processed/nys_schools_clean.csv (", nrow(nys_schools_clean), " rows)")
message("Saved data/processed/nys_acs_clean.csv (",     nrow(nys_acs_clean),     " rows)")
