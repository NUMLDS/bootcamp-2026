library(tidyverse)

# Read merged data
merged_data <- read_csv("data/processed/nys_merged.csv")

county_summary <- merged_data %>%
  mutate(
    per_free_reduced_lunch = per_free_lunch + per_reduced_lunch
  ) %>%
  group_by(county_name) %>%
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    avg_free_reduced_lunch = mean(per_free_reduced_lunch, na.rm = TRUE),
    avg_poverty = mean(county_per_poverty, na.rm = TRUE)
  )

county_summary

top5_poverty <- county_summary %>%
  arrange(desc(avg_poverty)) %>%
  slice_head(n = 5)

bottom5_poverty <- county_summary %>%
  arrange(avg_poverty) %>%
  slice_head(n = 5)

top5_poverty
bottom5_poverty

county_performance <- merged_data %>%
  mutate(
    per_free_reduced_lunch = per_free_lunch + per_reduced_lunch
  ) %>%
  group_by(county_name) %>%
  summarise(
    poverty_rate = mean(county_per_poverty, na.rm = TRUE),
    free_reduced_lunch = mean(per_free_reduced_lunch, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE)
  )

top5_table <- county_performance %>%
  arrange(desc(poverty_rate)) %>%
  slice_head(n = 5)

bottom5_table <- county_performance %>%
  arrange(poverty_rate) %>%
  slice_head(n = 5)

top5_table
bottom5_table
