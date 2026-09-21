# 3_analyze.R
# Summary tables answering the department's questions.
library(tidyverse)

dir.create("output/tables", showWarnings = FALSE, recursive = TRUE)

merged <- read_csv("data/processed/nys_merged.csv", show_col_types = FALSE) |>
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high")))

analysis <- merged |> filter(!is.na(county_per_poverty))

# Task 5.1 ------------------------------------------------------------------
# For each county: total enrollment, 
# percent of students qualifying for free or reduced price lunch, and percent of population in poverty.
county_summary <- analysis |>
  group_by(county_name) |>
  summarise(
    per_free_reduced = weighted.mean(per_free_reduced, replace_na(total_enroll, 0), na.rm = TRUE),
    total_enroll     = sum(total_enroll, na.rm = TRUE),
    per_poverty      = mean(county_per_poverty),
    .groups = "drop"
  ) |>
  relocate(county_name, total_enroll) |>
  arrange(desc(per_poverty))

# Task 5.2 ------------------------------------------------------------------
# The 5 highest- and 5 lowest-poverty counties, side by side.
county_scores <- analysis |>
  group_by(county_name) |>
  summarise(
    per_poverty      = mean(county_per_poverty),
    per_free_reduced = weighted.mean(per_free_reduced, replace_na(total_enroll, 0), na.rm = TRUE),
    mean_ela_z       = mean(mean_ela_score_z,  na.rm = TRUE),
    mean_math_z      = mean(mean_math_score_z, na.rm = TRUE),
    .groups = "drop"
  )

extremes <- bind_rows(
  slice_max(county_scores, per_poverty, n = 5) |> mutate(group = "top 5 poverty"),
  slice_min(county_scores, per_poverty, n = 5) |> mutate(group = "bottom 5 poverty")
) |>
  relocate(group)

# Task 5.3: Summary tables that would answer department questions
# What's the difference in test performance between low, medium and high poverty areas?
by_poverty <- analysis |>
  group_by(poverty_group) |>
  summarise(
    n_school_years   = n(),   # not distinct schools: 38 of 62 counties
                              # change tier across years, so a school can
                              # appear under two tiers
    per_free_reduced = weighted.mean(per_free_reduced, replace_na(total_enroll, 0), na.rm = TRUE),
    mean_ela_z       = mean(mean_ela_score_z,  na.rm = TRUE),
    mean_math_z      = mean(mean_math_score_z, na.rm = TRUE),
    .groups = "drop"
  )

# Has this relationship changed over time?
by_year <- analysis |>
  group_by(year, poverty_group) |>
  summarise(mean_ela_z = mean(mean_ela_score_z, na.rm = TRUE), .groups = "drop")

gap_by_year <- by_year |>
  pivot_wider(names_from = poverty_group, values_from = mean_ela_z) |>
  # low - high, so the gap reads as a positive number.
  mutate(gap = low - high)

# Is this relationship at all moderated by access to free / reduced price lunch?
by_lunch <- analysis |>
  filter(!is.na(per_free_reduced)) |>
  group_by(poverty_group) |>
  mutate(lunch_tercile = cut(per_free_reduced,
                             breaks = quantile(per_free_reduced, probs = c(0, 1/3, 2/3, 1)),
                             labels = c("low", "medium", "high"),
                             include.lowest = TRUE)) |>
  group_by(poverty_group, lunch_tercile) |>
  summarise(mean_ela_z = mean(mean_ela_score_z, na.rm = TRUE), n = n(), .groups = "drop")

walk2(
  list(county_summary, extremes, by_poverty, gap_by_year, by_lunch),
  c("county_summary", "extremes", "by_poverty", "gap_by_year", "by_lunch"),
  ~ write_csv(.x, paste0("output/tables/", .y, ".csv"))
)
