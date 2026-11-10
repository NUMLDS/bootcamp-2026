library('tidyverse')

# weighting larger schools more heavily
weighted_avg = function(x, enrollment) {
  valid = !is.na(x) & !is.na(enrollment) & enrollment > 0

  if (!any(valid)) return(NA_real_)
  weighted.mean(x[valid], enrollment[valid])
}

county_summary = school_data |>
  filter(year == 2016, !is.na(county_name), !is.na(county_per_poverty)) |>
  mutate(per_free_or_reduced = per_free_lunch + per_reduced_lunch) |>
  group_by(county_name) |>
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    pct_free_or_reduced = 100 * weighted_avg(
      per_free_or_reduced, total_enroll
    ),
    pct_poverty = 100 * first(county_per_poverty),
    mean_reading_score = weighted_avg(mean_ela_score, total_enroll),
    mean_math_score = weighted_avg(mean_math_score, total_enroll)
  )

# Task 5.1: all counties
county_summary |>
  select(county_name, total_enrollment, pct_free_or_reduced, pct_poverty) |>
  arrange(desc(pct_poverty))

# Task 5.2: five highest and five lowest poverty rates
top_bottom_poverty = bind_rows(
  county_summary |>
    slice_max(pct_poverty, n = 5) |>
    mutate(group = "Top 5"),
  county_summary |>
    slice_min(pct_poverty, n = 5) |>
    mutate(group = "Bottom 5")
  ) |>
  select(group, county_name, pct_poverty, pct_free_or_reduced,
         mean_reading_score, mean_math_score)

top_bottom_poverty
