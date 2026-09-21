# scripts/3_analyze.R
# Summary tables answering the department's questions.

library(tidyverse)

merged <- read_csv("data/processed/merged.csv")

# County-level summary
county_summary <- merged |>
  group_by(county_name) |>
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    pct_frl = mean(per_free_lunch + per_reduced_lunch, na.rm = TRUE),
    pct_poverty = mean(county_per_poverty, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(pct_poverty))

# Top 5 / bottom 5 poverty counties, with test scores
top5 <- county_summary |> slice_max(pct_poverty, n = 5)
bottom5 <- county_summary |> slice_min(pct_poverty, n = 5)

top_bottom_counties <- bind_rows(
  top5 |> mutate(poverty_rank = "Top 5 Poverty"),
  bottom5 |> mutate(poverty_rank = "Bottom 5 Poverty")
)

top_bottom_scores <- merged |>
  filter(county_name %in% top_bottom_counties$county_name) |>
  group_by(county_name) |>
  summarize(
    mean_math = mean(mean_math_score, na.rm = TRUE),
    mean_ela = mean(mean_ela_score, na.rm = TRUE),
    .groups = "drop"
  ) |>
  left_join(top_bottom_counties, by = "county_name") |>
  arrange(desc(pct_poverty))

# Has the poverty/performance relationship changed over time?
poverty_group_trend <- merged |>
  filter(!is.na(poverty_group)) |>
  group_by(year, poverty_group) |>
  summarize(
    mean_math_z = mean(math_z, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    .groups = "drop"
  )

# Math/ELA raw score range by year -- flags that the score scale isn't
# consistent across years (context for Visualization 1, which uses the
# raw score rather than the standardized math_z/ela_z)
score_range_by_year <- merged |>
  group_by(year) |>
  summarize(
    min_math = min(mean_math_score, na.rm = TRUE),
    max_math = max(mean_math_score, na.rm = TRUE),
    min_ela = min(mean_ela_score, na.rm = TRUE),
    max_ela = max(mean_ela_score, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(county_summary, "data/processed/county_summary.csv")
write_csv(top_bottom_scores, "data/processed/top_bottom_poverty_scores.csv")
write_csv(poverty_group_trend, "data/processed/poverty_group_trend.csv")
write_csv(score_range_by_year, "data/processed/score_range_by_year.csv")
