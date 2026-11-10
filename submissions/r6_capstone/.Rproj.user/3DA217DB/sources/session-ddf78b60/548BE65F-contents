library(tidyverse)

schools <- read_csv("data/processed/schools_clean.csv")
acs <- read_csv("data/processed/acs_clean.csv")

acs_transformed <- acs |>
  mutate(
    income_group = case_when(
      median_household_income <= quantile(median_household_income, 1/3, na.rm = TRUE) ~ "low",
      median_household_income <= quantile(median_household_income, 2/3, na.rm = TRUE) ~ "medium",
      TRUE ~ "high"
    ),
    income_group = factor(income_group, levels = c("low", "medium", "high"))
  )

schools_transformed <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  )|>
  ungroup()


merged_data <- schools_transformed |>
  left_join(acs_transformed, by = c("county_name", "year"))

write_csv(merged_data, "data/processed/merged.csv")
