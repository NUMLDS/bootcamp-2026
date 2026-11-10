library(tidyverse)

# Run from the project root. Analyze matched county-years only.
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
schools <- read_csv("data/processed/schools_merged.csv",
                    col_types = cols(school_cd = col_character()),
                    show_col_types = FALSE)
analysis_schools <- schools |>
  filter(!is.na(county_per_poverty), !is.na(county_name)) |>
  mutate(lunch_share = per_free_lunch + per_reduced_lunch)

# Return NA, rather than NaN, when a group has no observed scores.
mean_observed <- function(x) {
  if (all(is.na(x))) return(NA_real_)
  mean(x, na.rm = TRUE)
}

# Estimate the county student eligibility share using enrollment weights.
# Only schools with observed eligibility and positive enrollment enter BOTH
# numerator and denominator. Enrollment is not a test-participation weight.
enrollment_weighted_share <- function(share, enrollment) {
  valid <- !is.na(share) & !is.na(enrollment) & enrollment > 0
  if (!any(valid)) return(NA_real_)
  weighted.mean(share[valid], enrollment[valid])
}

# County-year is the unit: never add enrollment across different years.
# Score means give each observed school equal weight within its county.
county_summary <- analysis_schools |>
  group_by(county_name, year) |>
  summarise(
    n_schools = n(),
    total_enrollment = if (all(is.na(total_enroll))) NA_real_ else
      sum(total_enroll, na.rm = TRUE),
    n_enrollment_observed = sum(!is.na(total_enroll)),
    lunch_covered_enrollment = sum(
      total_enroll[!is.na(lunch_share) & !is.na(total_enroll) & total_enroll > 0]
    ),
    lunch_share = enrollment_weighted_share(lunch_share, total_enroll),
    poverty_rate = first(county_per_poverty),
    poverty_group = first(poverty_group),
    n_ela_schools = sum(!is.na(mean_ela_score)),
    n_math_schools = sum(!is.na(mean_math_score)),
    mean_ela = mean_observed(mean_ela_score),
    mean_math = mean_observed(mean_math_score),
    ela_z = mean_observed(ela_z),
    math_z = mean_observed(math_z),
    .groups = "drop"
  ) |>
  mutate(lunch_enrollment_coverage = lunch_covered_enrollment / total_enrollment)

# Use the latest shared year for a single-year comparison of extremes.
# County name provides a reproducible tie-breaker if poverty rates tie.
latest_year <- max(county_summary$year)
latest_counties <- county_summary |> filter(year == latest_year)
bottom5 <- latest_counties |>
  arrange(poverty_rate, county_name) |>
  slice_head(n = 5) |>
  mutate(poverty_rank_group = "Lowest 5")
top5 <- latest_counties |>
  arrange(desc(poverty_rate), county_name) |>
  slice_head(n = 5) |>
  mutate(poverty_rank_group = "Highest 5")
poverty_extremes <- bind_rows(bottom5, top5)

# Average county score means within each poverty group: each county has
# equal weight. This differs from pooling all schools in a group.
group_trends <- county_summary |>
  mutate(poverty_group = factor(poverty_group, c("low", "medium", "high"))) |>
  group_by(year, poverty_group) |>
  summarise(
    n_counties = n(),
    n_ela_counties = sum(!is.na(ela_z)),
    n_math_counties = sum(!is.na(math_z)),
    ela_z = mean_observed(ela_z),
    math_z = mean_observed(math_z),
    .groups = "drop"
  )

# Quantify the descriptive high-minus-low gap over time.
group_gaps <- group_trends |>
  select(year, poverty_group, ela_z, math_z) |>
  pivot_longer(c(ela_z, math_z), names_to = "subject", values_to = "score") |>
  pivot_wider(names_from = poverty_group, values_from = score) |>
  mutate(high_minus_low = high - low)

# School-level correlations describe association, not lunch-program effects.
# Use complete pairs for each subject; keep sample counts visible.
school_lunch_association <- analysis_schools |>
  filter(year == latest_year) |>
  pivot_longer(c(ela_z, math_z), names_to = "subject", values_to = "score_z") |>
  filter(!is.na(lunch_share), !is.na(score_z)) |>
  group_by(poverty_group, subject) |>
  summarise(n_schools = n(),
            correlation = cor(lunch_share, score_z), .groups = "drop")

# Save a coverage audit to make the join exclusions explicit.
coverage <- schools |>
  group_by(year) |>
  summarise(n_school_records = n(),
            n_matched = sum(!is.na(county_per_poverty)),
            n_unmatched = sum(is.na(county_per_poverty)), .groups = "drop")

write_csv(county_summary, "outputs/tables/county_year_summary.csv")
write_csv(poverty_extremes, "outputs/tables/poverty_top_bottom_5.csv")
write_csv(group_trends, "outputs/tables/poverty_group_trends.csv")
write_csv(group_gaps, "outputs/tables/high_low_gaps.csv")
write_csv(school_lunch_association, "outputs/tables/school_lunch_association.csv")
write_csv(coverage, "outputs/tables/analysis_coverage.csv")
