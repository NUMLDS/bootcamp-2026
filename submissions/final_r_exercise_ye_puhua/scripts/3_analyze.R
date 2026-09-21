# Purpose: Create summary tables that answer the research questions.
# Input: The merged analysis dataset from data/processed/
# Output: Summary tables used in the final report.

library(tidyverse)

# Read merged data
merged <- read_csv("data/processed/nys_merged.csv") |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high")
    )
  )

# Summarize the requested measures for each county
county_analysis <- merged |>
  group_by(county_name) |>
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    free_reduced_lunch_pct = 100 * mean(
      per_free_lunch + per_reduced_lunch,
      na.rm = TRUE
    ),
    poverty_pct = 100 * mean(county_per_poverty, na.rm = TRUE),
    mean_reading_score = mean(ela_z, na.rm = TRUE),
    mean_math_score = mean(math_z, na.rm = TRUE)
  )

# Table 1: enrollment, lunch eligibility, and poverty for every county
county_summary <- county_analysis |>
  select(
    county_name,
    total_enrollment,
    free_reduced_lunch_pct,
    poverty_pct
  )

# Table 2: counties with the five highest and five lowest poverty rates
highest_5 <- county_analysis |>
  arrange(desc(poverty_pct)) |>
  head(5) |>
  select(
    county_name,
    poverty_pct,
    free_reduced_lunch_pct,
    mean_reading_score,
    mean_math_score
  )

lowest_5 <- county_analysis |>
  arrange(poverty_pct) |>
  head(5) |>
  select(
    county_name,
    poverty_pct,
    free_reduced_lunch_pct,
    mean_reading_score,
    mean_math_score
  )

# Table 3: average test performance by poverty group
poverty_group_summary <- merged |>
  group_by(poverty_group) |>
  summarize(
    number_of_schools = n_distinct(school_cd),
    mean_reading_score = mean(ela_z, na.rm = TRUE),
    mean_math_score = mean(math_z, na.rm = TRUE)
  )

# Table 4: average test performance by year and poverty group
year_poverty_summary <- merged |>
  group_by(year, poverty_group) |>
  summarize(
    mean_reading_score = mean(ela_z, na.rm = TRUE),
    mean_math_score = mean(math_z, na.rm = TRUE)
  ) |>
  ungroup()

# Divide schools into three lunch-access groups within each year
lunch_analysis <- merged |>
  mutate(free_reduced_lunch = per_free_lunch + per_reduced_lunch) |>
  group_by(year) |>
  mutate(
    lunch_third = ntile(free_reduced_lunch, 3),
    lunch_group = case_when(
      lunch_third == 1 ~ "low",
      lunch_third == 2 ~ "medium",
      lunch_third == 3 ~ "high"
    ),
    lunch_group = factor(
      lunch_group,
      levels = c("low", "medium", "high")
    )
  ) |>
  ungroup()

# Table 5: test performance by poverty group and lunch-access group
poverty_lunch_summary <- lunch_analysis |>
  filter(!is.na(lunch_group)) |>
  group_by(poverty_group, lunch_group) |>
  summarize(
    number_of_schools = n_distinct(school_cd),
    mean_reading_score = mean(ela_z, na.rm = TRUE),
    mean_math_score = mean(math_z, na.rm = TRUE)
  ) |>
  ungroup()

county_summary
highest_5
lowest_5
poverty_group_summary
year_poverty_summary
poverty_lunch_summary
