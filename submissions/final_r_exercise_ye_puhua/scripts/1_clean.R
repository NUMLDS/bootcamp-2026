# Purpose: Import the raw datasets and clean missing values.
# Input: data/raw/nys_schools.csv and data/raw/nys_acs.csv
# Output: Cleaned datasets saved in data/processed/

library(tidyverse)

# Read in data
nys_schools <- read_csv("data/raw/nys_schools.csv")
nys_acs <- read_csv("data/raw/nys_acs.csv")

# Process data using the instructor's code
schools_clean <- nys_schools |>
  distinct() |>
  mutate(
    county_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

acs_clean <- nys_acs |>
  distinct() |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))

# Alternative processing code originally considered
# This version deletes invalid rows instead of converting values to NA.
#
# schools_clean <- nys_schools |>
#   distinct() |>
#   filter(
#     county_name != "-99",
#     total_enroll > 0,
#     between(per_free_lunch, 0, 1),
#     between(per_reduced_lunch, 0, 1),
#     between(per_lep, 0, 1),
#     per_free_lunch + per_reduced_lunch <= 1,
#     mean_ela_score != -99,
#     mean_math_score != -99
#   )
#
# acs_clean <- nys_acs |>
#   distinct()

# Save cleaned data
write_csv(schools_clean, "data/processed/nys_schools_clean.csv")
write_csv(acs_clean, "data/processed/nys_acs_clean.csv")
