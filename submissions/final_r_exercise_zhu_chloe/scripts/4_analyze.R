library(tidyverse)

# Read merged dataset
merged_data <- read_csv(
  "data/processed/nys_merged.csv"
)

# Create county-year summary
county_summary <- merged_data |>
  filter(!is.na(county_per_poverty)) |>
  
  # Calculate lunch assistance rate and remove invalid values above 100%
  mutate(
    lunch_rate_school = per_free_lunch + per_reduced_lunch,
    lunch_rate_school = if_else(
      lunch_rate_school <= 1,
      lunch_rate_school,
      NA_real_
    )
  ) |>
  
  group_by(county_name, year) |>
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    
    lunch_rate = weighted.mean(
      lunch_rate_school,
      w = total_enroll,
      na.rm = TRUE
    ),
    
    poverty_rate = first(county_per_poverty),
    
    .groups = "drop"
  )

head(county_summary)
summary(county_summary$lunch_rate)#check if Max.≤ 1

# Create an overall summary for each county
county_overall <- county_summary |>
  group_by(county_name) |>
  summarize(
    avg_poverty_rate = mean(poverty_rate, na.rm = TRUE),
    avg_lunch_rate = mean(lunch_rate, na.rm = TRUE),
    .groups = "drop"
  )

head(county_overall)

# Calculate average test performance for each county
county_scores <- merged_data |>
  filter(!is.na(county_per_poverty)) |>
  group_by(county_name) |>
  summarize(
    avg_math_z = mean(math_z, na.rm = TRUE),
    avg_ela_z = mean(ela_z, na.rm = TRUE),
    .groups = "drop"
  )

head(county_scores)

# Combine county characteristics and test performance
county_analysis <- county_overall |>
  left_join(
    county_scores,
    by = "county_name"
  )

head(county_analysis)

# Top 5 counties with the highest poverty rates
top5_poverty <- county_analysis |>
  slice_max(avg_poverty_rate, n = 5)

top5_poverty
# Bottom 5 counties with the lowest poverty rates
bottom5_poverty <- county_analysis |>
  slice_min(avg_poverty_rate, n = 5)

bottom5_poverty