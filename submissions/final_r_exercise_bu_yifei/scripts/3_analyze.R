library(tidyverse)

# Import merged school and county dataset
dat <- read_csv("data/processed/nys_schools_acs.csv")

# Create combined free/reduced-price lunch percentage
dat <- dat |>
  mutate(
    per_free_reduced = per_free_lunch + per_reduced_lunch
  )

county_year_summary <- dat |>
  group_by(county_name, year) |>
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    
    per_free_reduced = weighted.mean(
      per_free_reduced,
      w = total_enroll,
      na.rm = TRUE
    ),
    
    county_per_poverty = first(county_per_poverty),
    
    mean_ela_z = weighted.mean(
      ela_z,
      w = total_enroll,
      na.rm = TRUE
    ),
    
    mean_math_z = weighted.mean(
      math_z,
      w = total_enroll,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

View(county_year_summary)


county_summary <- county_year_summary |>
  group_by(county_name) |>
  summarize(
    avg_poverty = mean(county_per_poverty, na.rm = TRUE),
    
    avg_free_reduced = weighted.mean(
      per_free_reduced,
      w = total_enrollment,
      na.rm = TRUE
    ),
    
    avg_ela_z = weighted.mean(
      mean_ela_z,
      w = total_enrollment,
      na.rm = TRUE
    ),
    
    avg_math_z = weighted.mean(
      mean_math_z,
      w = total_enrollment,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )


lowest_poverty <- county_summary |>
  slice_min(avg_poverty, n = 5) |>
  mutate(poverty_level = "Lowest 5")

highest_poverty <- county_summary |>
  slice_max(avg_poverty, n = 5) |>
  mutate(poverty_level = "Highest 5")

poverty_extremes <- bind_rows(
  lowest_poverty,
  highest_poverty
)

View(poverty_extremes)

poverty_group_summary <- dat |>
  group_by(poverty_group) |>
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    
    avg_ela_z = weighted.mean(
      ela_z,
      w = total_enroll,
      na.rm = TRUE
    ),
    
    avg_math_z = weighted.mean(
      math_z,
      w = total_enroll,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

poverty_group_summary <- poverty_group_summary |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high")
    )
  )

write_csv(
  county_year_summary,
  "data/processed/county_year_summary.csv"
)

write_csv(
  poverty_extremes,
  "data/processed/poverty_extremes.csv"
)

write_csv(
  poverty_group_summary,
  "data/processed/poverty_group_summary.csv"
)

