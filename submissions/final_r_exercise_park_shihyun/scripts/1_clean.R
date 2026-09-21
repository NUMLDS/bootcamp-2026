# 1_clean.R
# Purpose: Import raw data, explore structure, recode missing values (-99 -> NA),
#          and save cleaned data to data/processed/

library(tidyverse)

# ---- 1. Import raw data ----
# schools: NYS Dept. of Education school-level data
# acs: US Census American Community Survey county-level data
schools <- read_csv("data/raw/nys_schools.csv")
acs <- read_csv("data/raw/nys_acs.csv")

# ---- 2. Explore structure ----
glimpse(schools)
glimpse(acs)
summary(schools)
summary(acs)

# Count -99 (missing value code) in each column
# Numeric: mostly in test scores (~2,200 each); a few in enrollment/lunch/LEP
schools |> summarise(across(where(is.numeric), ~ sum(.x == -99, na.rm = TRUE)))
# Character: 19 each in district_name, county_name, region
schools |> summarise(across(where(is.character), ~ sum(.x == "-99", na.rm = TRUE)))
# Note: scale score mean >> median because test scales differ by year

# ---- 3. Recode missing values ----
# Replace -99 with NA in both numeric and character columns
schools_clean <- schools |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)),
         across(where(is.character), ~ na_if(.x, "-99")))

# Check: all counts should be 0
schools_clean |> summarise(across(where(is.numeric), ~ sum(.x == -99, na.rm = TRUE)))
schools_clean |> summarise(across(where(is.character), ~ sum(.x == "-99", na.rm = TRUE)))


# ---- Check duplicates ----
# Fully identical rows
sum(duplicated(schools_clean))
# Same school + same year appearing more than once
schools_clean |> count(school_cd, year) |> filter(n > 1)

# ---- Check percentages over 100% ----
# Percent variables are proportions (0-1), so > 1 is invalid
schools_clean |>
  summarise(free_over1 = sum(per_free_lunch > 1, na.rm = TRUE),
            reduced_over1 = sum(per_reduced_lunch > 1, na.rm = TRUE),
            lep_over1 = sum(per_lep > 1, na.rm = TRUE))
# ---- Remove duplicates ----
# Some school-year combinations appear 4 times; drop fully identical rows
schools_clean <- schools_clean |> distinct()

# Re-check: if rows remain, same school-year has DIFFERENT values
schools_clean |> count(school_cd, year) |> filter(n > 1)

# ---- Fix percentages over 100% ----
# Proportions > 1 are impossible (likely entry errors), so set to NA
schools_clean <- schools_clean |>
  mutate(per_free_lunch = if_else(per_free_lunch > 1, NA, per_free_lunch),
         per_reduced_lunch = if_else(per_reduced_lunch > 1, NA, per_reduced_lunch))

# Re-check: should be 0
schools_clean |>
  summarise(free_over1 = sum(per_free_lunch > 1, na.rm = TRUE),
            reduced_over1 = sum(per_reduced_lunch > 1, na.rm = TRUE))
# ---- 4. Save cleaned data ----
write_csv(schools_clean, "data/processed/schools_clean.csv")
write_csv(acs, "data/processed/acs_clean.csv")