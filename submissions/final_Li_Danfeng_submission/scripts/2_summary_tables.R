### Task 5: Summary tables
# Question: what does the data tell us about the relationship between
# poverty and test performance in NY public schools? Sub-questions:
#   - How different is performance across low / medium / high poverty areas?
#   - Has that relationship changed over time?
#   - Is it moderated by access to free / reduced price lunch?

library(tidyverse)

nys <- read_csv(
  "data/processed/nys_schools_acs_cleaned.csv",
  show_col_types = FALSE
)

out_dir <- "data/processed/tables"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

## ---------------------------------------------------------------------
## Table 1: county profile - enrollment, lunch access, poverty
## ---------------------------------------------------------------------
# Enrollment and lunch % are reported per school-year, so we first collapse
# to one row per county-year (summing enrollment across schools, and
# enrollment-weighting the lunch percentages so bigger schools count more),
# then average across years to get a typical annual profile per county.
county_year <- nys %>%
  group_by(county_name, year) %>%
  summarise(
    # keep the weight column (total_enroll) under its original name until
    # after it's used as weights below - naming the output the same thing
    # would silently shadow the raw column mid-summarise() and break the
    # weighted.mean() call (w would become a length-1 scalar).
    pct_free_reduced_lunch = weighted.mean(
      per_free_lunch + per_reduced_lunch, w = total_enroll, na.rm = TRUE
    ),
    pct_poverty = mean(county_per_poverty, na.rm = TRUE),
    total_enroll = sum(total_enroll, na.rm = TRUE),
    .groups = "drop"
  )

county_summary <- county_year %>%
  group_by(county_name) %>%
  summarise(
    avg_total_enroll = round(mean(total_enroll, na.rm = TRUE)),
    pct_free_reduced_lunch = mean(pct_free_reduced_lunch, na.rm = TRUE),
    pct_poverty = mean(pct_poverty, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(pct_poverty))

write_csv(county_summary, file.path(out_dir, "1_county_profile.csv"))

## ---------------------------------------------------------------------
## Table 2: top 5 / bottom 5 counties by poverty rate
## ---------------------------------------------------------------------
# Uses the same county-level poverty average as Table 1 to rank counties,
# then reports both raw mean scores (as asked) and the year-standardized
# z-scores (more defensible across years, since raw scale scores aren't
# comparable year to year - see Task 1-4).
poverty_ranked <- county_summary %>% filter(!is.na(pct_poverty))

top5 <- poverty_ranked %>% slice_max(pct_poverty, n = 5) %>% mutate(poverty_rank = "Top 5 (highest poverty)")
bottom5 <- poverty_ranked %>% slice_min(pct_poverty, n = 5) %>% mutate(poverty_rank = "Bottom 5 (lowest poverty)")

county_scores <- nys %>%
  group_by(county_name) %>%
  summarise(
    mean_ela_score = mean(mean_ela_score, na.rm = TRUE),
    mean_math_score = mean(mean_math_score, na.rm = TRUE),
    mean_z_ela = mean(z_ela, na.rm = TRUE),
    mean_z_math = mean(z_math, na.rm = TRUE),
    .groups = "drop"
  )

top_bottom_poverty <- bind_rows(top5, bottom5) %>%
  left_join(county_scores, by = "county_name") %>%
  select(
    poverty_rank, county_name, pct_poverty, pct_free_reduced_lunch,
    mean_ela_score, mean_math_score, mean_z_ela, mean_z_math
  )

write_csv(top_bottom_poverty, file.path(out_dir, "2_top_bottom_poverty_counties.csv"))

## ---------------------------------------------------------------------
## Table 3: test performance by poverty group (low / medium / high)
## ---------------------------------------------------------------------
performance_by_poverty_group <- nys %>%
  filter(!is.na(poverty_group)) %>%
  group_by(poverty_group) %>%
  summarise(
    n_school_years = n(),
    pct_free_reduced_lunch = mean(per_free_lunch + per_reduced_lunch, na.rm = TRUE),
    mean_ela_score = mean(mean_ela_score, na.rm = TRUE),
    mean_math_score = mean(mean_math_score, na.rm = TRUE),
    mean_z_ela = mean(z_ela, na.rm = TRUE),
    mean_z_math = mean(z_math, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(performance_by_poverty_group, file.path(out_dir, "3_performance_by_poverty_group.csv"))

## ---------------------------------------------------------------------
## Table 4: has the poverty gap changed over time?
## ---------------------------------------------------------------------
# z-scores by poverty group and year, plus the high-minus-low poverty gap
# for each year so the trend is readable at a glance.
performance_by_group_year <- nys %>%
  filter(!is.na(poverty_group)) %>%
  group_by(year, poverty_group) %>%
  summarise(
    mean_z_ela = mean(z_ela, na.rm = TRUE),
    mean_z_math = mean(z_math, na.rm = TRUE),
    .groups = "drop"
  )

poverty_gap_by_year <- performance_by_group_year %>%
  filter(poverty_group %in% c("low", "high")) %>%
  select(year, poverty_group, mean_z_math, mean_z_ela) %>%
  pivot_wider(names_from = poverty_group, values_from = c(mean_z_math, mean_z_ela)) %>%
  mutate(
    math_gap_low_minus_high = mean_z_math_low - mean_z_math_high,
    ela_gap_low_minus_high = mean_z_ela_low - mean_z_ela_high
  ) %>%
  arrange(year)

write_csv(performance_by_group_year, file.path(out_dir, "4a_performance_by_group_and_year.csv"))
write_csv(poverty_gap_by_year, file.path(out_dir, "4b_poverty_gap_by_year.csv"))

## ---------------------------------------------------------------------
## Table 5: is the relationship moderated by free/reduced lunch access?
## ---------------------------------------------------------------------
# Split schools into above/below the median combined free+reduced lunch
# rate, then cross with poverty_group. If the poverty-performance gap
# looks similar in both lunch tiers, lunch access isn't doing much
# moderating; if the gap widens/narrows in one tier, it is.
median_lunch <- median(nys$per_free_lunch + nys$per_reduced_lunch, na.rm = TRUE)

moderation_by_lunch <- nys %>%
  filter(!is.na(poverty_group)) %>%
  mutate(
    lunch_tier = if_else(
      (per_free_lunch + per_reduced_lunch) >= median_lunch,
      "high free/reduced lunch access", "low free/reduced lunch access"
    )
  ) %>%
  group_by(poverty_group, lunch_tier) %>%
  summarise(
    n_school_years = n(),
    mean_z_ela = mean(z_ela, na.rm = TRUE),
    mean_z_math = mean(z_math, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(poverty_group, lunch_tier)

write_csv(moderation_by_lunch, file.path(out_dir, "5_moderation_by_lunch_access.csv"))

## ---------------------------------------------------------------------
print(county_summary, n = 10)
print(top_bottom_poverty)
print(performance_by_poverty_group)
print(poverty_gap_by_year)
print(moderation_by_lunch)
