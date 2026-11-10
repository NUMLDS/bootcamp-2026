library('tidyverse')

acs_transform = acs_clean |>
  mutate(poverty_group = case_when(
    county_per_poverty < 0.10 ~ "low",
    county_per_poverty < 0.20 ~ "medium",
    TRUE                      ~ "high")
  )

schools_transform = schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  )

school_data <- schools_transform |>
  left_join(acs_transform, by = c("county_name", "year"))

write_csv(school_data, 'data/processed/final_school_data.csv')
