# ============================================================
# MLDS Final R Exercise
# Script 3: Analyze data and create summary tables
# ============================================================

library(tidyverse)


# ------------------------------------------------------------
# 1. LOAD MERGED DATA
# ------------------------------------------------------------

data <- read_csv("Data/processed/nys_merged.csv")


# ------------------------------------------------------------
# 2. CREATE FREE / REDUCED LUNCH VARIABLE
# ------------------------------------------------------------

# Total proportion of students qualifying for either
# free or reduced-price lunch.

data <- data |>
  mutate(
    per_free_reduced_lunch = per_free_lunch + per_reduced_lunch
  )


# ------------------------------------------------------------
# 3. SUMMARY BY POVERTY GROUP
# ------------------------------------------------------------

# Compare test performance across low, medium and high
# poverty county groups.

poverty_summary <- data |>
  group_by(poverty_group) |>
  summarise(
    schools = n(),
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    mean_poverty = mean(county_per_poverty, na.rm = TRUE),
    mean_free_reduced_lunch = mean(per_free_reduced_lunch, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )

poverty_summary


# ------------------------------------------------------------
# 4. SUMMARY BY COUNTY
# ------------------------------------------------------------

# Summarize enrollment, lunch eligibility, poverty,
# and test performance for each county.

county_summary <- data |>
  group_by(county_name) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    per_free_reduced_lunch = mean(per_free_reduced_lunch, na.rm = TRUE),
    poverty_rate = mean(county_per_poverty, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )

county_summary

# ------------------------------------------------------------
# 5. TOP 5 AND BOTTOM 5 POVERTY COUNTIES
# ------------------------------------------------------------

# Five counties with highest poverty rates
highest_poverty <- county_summary |>
  arrange(desc(poverty_rate)) |>
  slice_head(n = 5)

# Five counties with lowest poverty rates
lowest_poverty <- county_summary |>
  arrange(poverty_rate) |>
  slice_head(n = 5)

# Display results
highest_poverty
lowest_poverty