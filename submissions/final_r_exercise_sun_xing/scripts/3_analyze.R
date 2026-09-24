# Load required packages
library(tidyverse)

# Import merged data
merged_data <- read_csv(
  "data/processed/merged_data.csv",
  show_col_types = FALSE
)

# Compare test performance across poverty groups
poverty_summary <- merged_data |>
  filter(!is.na(poverty_group)) |>
  group_by(poverty_group) |>
  summarise(
    n = n(),
    mean_math_z = mean(math_z, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE)
  )

poverty_summary

# Create county-level summary table
county_summary <- merged_data |>
  filter(!is.na(county_per_poverty)) |>
  group_by(county_name) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    mean_free_lunch = mean(per_free_lunch, na.rm = TRUE),
    mean_reduced_lunch = mean(per_reduced_lunch, na.rm = TRUE),
    mean_poverty = mean(county_per_poverty, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE)
  )
county_summary

# Identify counties with the lowest and highest poverty rates
lowest_poverty <- county_summary |>
  slice_min(mean_poverty, n = 5)

highest_poverty <- county_summary |>
  slice_max(mean_poverty, n = 5)

lowest_poverty
highest_poverty

# Combine lowest and highest poverty counties
poverty_extremes <- bind_rows(
  lowest_poverty |>
    mutate(poverty_level = "Lowest poverty"),
  
  highest_poverty |>
    mutate(poverty_level = "Highest poverty")
) |>
  select(
    poverty_level,
    county_name,
    mean_poverty,
    mean_free_lunch,
    mean_math_z,
    mean_ela_z
  )

poverty_extremes

# Create county-year summary table
county_year_summary <- merged_data |>
  filter(!is.na(county_per_poverty)) |>
  group_by(county_name, year) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    mean_free_lunch = weighted.mean(
      per_free_lunch,
      total_enroll,
      na.rm = TRUE
    ),
    mean_reduced_lunch = weighted.mean(
      per_reduced_lunch,
      total_enroll,
      na.rm = TRUE
    ),
    poverty_rate = first(county_per_poverty),
    mean_math_z = weighted.mean(
      math_z,
      total_enroll,
      na.rm = TRUE
    ),
    mean_ela_z = weighted.mean(
      ela_z,
      total_enroll,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

# Summarize across years for each county
county_summary_final <- county_year_summary |>
  group_by(county_name) |>
  summarise(
    mean_poverty = mean(poverty_rate, na.rm = TRUE),
    
    mean_free_lunch = weighted.mean(
      mean_free_lunch,
      total_enrollment,
      na.rm = TRUE
    ),
    
    mean_math_z = weighted.mean(
      mean_math_z,
      total_enrollment,
      na.rm = TRUE
    ),
    
    mean_ela_z = weighted.mean(
      mean_ela_z,
      total_enrollment,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

county_summary_final

lowest_poverty_final <- county_summary_final |>
  slice_min(mean_poverty, n = 5)

highest_poverty_final <- county_summary_final |>
  slice_max(mean_poverty, n = 5)

lowest_poverty_final
highest_poverty_final