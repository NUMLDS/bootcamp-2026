# 3_analyze.R
# Purpose: Summary tables to answer the department's questions

library(tidyverse)

# ---- Load merged data ----
merged <- read_csv("data/processed/merged.csv") |>
  # CSV loses factor order, so set low -> medium -> high again
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high")),
         # Free OR reduced price lunch combined
         per_lunch = per_free_lunch + per_reduced_lunch)

# ---- Table 1: County summary ----
# Enrollment averaged per year (summing all years would count students 8 times)
# Lunch % weighted by enrollment so big schools count more
county_table <- merged |>
  filter(!is.na(total_enroll), !is.na(per_lunch)) |>
  group_by(county_name, poverty_group) |>
  summarise(avg_enroll_per_year = sum(total_enroll) / n_distinct(year),
            pct_lunch = weighted.mean(per_lunch, total_enroll),
            pct_poverty = mean(county_per_poverty),
            ela_z = mean(ela_z, na.rm = TRUE),
            math_z = mean(math_z, na.rm = TRUE),
            .groups = "drop")
county_table

# ---- Table 2: Top 5 and bottom 5 poverty counties ----
top_bottom <- bind_rows(
  county_table |> slice_max(pct_poverty, n = 5) |> mutate(rank = "Top 5 poverty"),
  county_table |> slice_min(pct_poverty, n = 5) |> mutate(rank = "Bottom 5 poverty")
) |>
  select(rank, county_name, pct_poverty, pct_lunch, ela_z, math_z)
top_bottom

# ---- Table 3: Test performance by poverty group (Q2) ----
group_table <- merged |>
  group_by(poverty_group) |>
  summarise(n_school_years = n(),
            ela_z = mean(ela_z, na.rm = TRUE),
            math_z = mean(math_z, na.rm = TRUE))
group_table

# ---- Table 4: Poverty group x year (Q3: change over time) ----
trend_table <- merged |>
  group_by(year, poverty_group) |>
  summarise(math_z = mean(math_z, na.rm = TRUE), .groups = "drop") |>
  pivot_wider(names_from = poverty_group, values_from = math_z)
trend_table