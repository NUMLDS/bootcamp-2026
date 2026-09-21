# ============================================================
# MLDS Final R Exercise
# Script 2: Transform and merge data
# ============================================================

library(tidyverse)


# ------------------------------------------------------------
# 1. LOAD CLEAN DATA
# ------------------------------------------------------------

schools_clean <- read_csv(
  "Data/processed/nys_schools_clean.csv"
)

acs_clean <- read_csv(
  "Data/processed/nys_acs_clean.csv"
)


# ------------------------------------------------------------
# 2. CREATE POVERTY GROUPS
# ------------------------------------------------------------

# Divide county-year observations into three approximately
# equally sized groups based on county poverty rate.
#
# 1 = low poverty
# 2 = medium poverty
# 3 = high poverty

acs_transformed <- acs_clean |>
  mutate(
    poverty_group_number = ntile(county_per_poverty, 3),
    
    poverty_group = case_when(
      poverty_group_number == 1 ~ "low",
      poverty_group_number == 2 ~ "medium",
      poverty_group_number == 3 ~ "high",
      TRUE ~ NA_character_
    )
  )


# Check poverty group distribution
table(
  acs_transformed$poverty_group,
  useNA = "ifany"
)


# ------------------------------------------------------------
# 3. STANDARDIZE TEST SCORES BY YEAR
# ------------------------------------------------------------

# Test score scales changed over time, so raw scores cannot
# be compared directly across years.
#
# Calculate standardized z-scores separately within each year.
#
# z = 0  -> average performance for that year
# z > 0  -> above average
# z < 0  -> below average

schools_transformed <- schools_clean |>
  group_by(year) |>
  mutate(
    ela_z = as.numeric(scale(mean_ela_score)),
    math_z = as.numeric(scale(mean_math_score))
  ) |>
  ungroup()


# Inspect standardized scores
schools_transformed |>
  select(
    year,
    school_name,
    mean_ela_score,
    ela_z,
    mean_math_score,
    math_z
  ) |>
  head()


# ------------------------------------------------------------
# 4. MERGE SCHOOL AND ACS DATA
# ------------------------------------------------------------

# Match school observations to county-level ACS information
# using county name AND year.
#
# left_join keeps all school observations initially.

merged_data <- schools_transformed |>
  left_join(
    acs_transformed,
    by = c("county_name", "year")
  )


# ------------------------------------------------------------
# 5. REMOVE OBSERVATIONS WITHOUT POVERTY DATA
# ------------------------------------------------------------

# Some school-year observations do not have a matching
# county-year observation in the ACS data.
#
# These observations cannot be used to compare poverty groups,
# so remove them from the final analysis dataset.

merged_data <- merged_data |>
  filter(!is.na(poverty_group))


# ------------------------------------------------------------
# 6. INSPECT MERGED DATA
# ------------------------------------------------------------

glimpse(merged_data)

dim(merged_data)

# Check poverty groups
table(
  merged_data$poverty_group,
  useNA = "ifany"
)

# Check missing values in important analysis variables
merged_data |>
  summarise(
    missing_poverty = sum(is.na(county_per_poverty)),
    missing_poverty_group = sum(is.na(poverty_group)),
    missing_ela_z = sum(is.na(ela_z)),
    missing_math_z = sum(is.na(math_z))
  )


# ------------------------------------------------------------
# 7. SAVE FINAL MERGED DATA
# ------------------------------------------------------------

write_csv(
  merged_data,
  "Data/processed/nys_merged.csv"
)