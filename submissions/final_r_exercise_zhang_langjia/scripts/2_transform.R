library(tidyverse)
schools_cleaned <- read_csv("data/processed/schools_cleaned")
acs_cleaned <- read_csv("data/processed/acs_cleaned")

schools_transformed <- schools_cleaned |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

acs_transformed <- acs_cleaned |>
  mutate(
    poverty_group = case_when(
      percent_rank(county_per_poverty) < 1 / 3 ~ "low",
      percent_rank(county_per_poverty) < 2 / 3 ~ "medium",
      !is.na(county_per_poverty)              ~ "high",
      TRUE                         ~ NA_character_
    ),
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high"),
      ordered = TRUE
    )
  )

write_csv(schools_transformed, "data/processed/schools_transformed.csv")
write_csv(acs_transformed, "data/processed/acs_transformed.csv")

merged <- schools_transformed |>
  left_join(acs_transformed, by = c('county_name', 'year')) |>
  drop_na() |>
  select(c(county_name, school_name, year, total_enroll, per_free_lunch, per_reduced_lunch, per_lep, math_z, ela_z, county_per_poverty, poverty_group)) |>
  arrange(county_name, desc(year), desc(county_per_poverty)) 

write_csv(merged, "data/processed/merged.csv")