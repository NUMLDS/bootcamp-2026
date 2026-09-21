library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)

county_summary <- nys_merged |>
  mutate(
    per_free_or_reduced_lunch = 
      per_free_lunch + per_reduced_lunch
  ) |>
  group_by(county_name) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    per_free_or_reduced_lunch = weighted.mean(per_free_or_reduced_lunch,
                                              w = total_enroll,
                                              na.rm = TRUE),
    poverty_rate = mean(county_per_poverty, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )

top_5 <- county_summary |>
  filter(!is.na(poverty_rate)) |>
  slice_max(
    order_by = poverty_rate,
    n = 5,
    with_ties = FALSE
  ) |>
  mutate(poverty_rank = "Top 5 poverty rate")

bottom_5 <- county_summary |>
  filter(!is.na(poverty_rate)) |>
  slice_min(
    order_by = poverty_rate,
    n = 5,
    with_ties = FALSE
  ) |>
  mutate(poverty_rank = "Bottom 5 poverty rate")
  
poverty_top_bottom <- bind_rows(top_5, bottom_5) |>
  select(
    poverty_rank,
    county_name,
    poverty_rate,
    per_free_or_reduced_lunch,
    mean_ela_z,
    mean_math_z
  ) |>
  arrange(desc(poverty_rate))

latest_year <- max()

