library(tidyverse)
library(readr)
library(dplyr)

acs_clean <- read_csv("data/processed/acs_clean.csv")
schools_clean <- read_csv("data/processed/schools_clean.csv")

acs_clean <- acs_clean |>
  group_by(year) |>
  mutate(poverty_group_number = ntile(county_per_poverty, 3),
         poverty_group = case_when(
           is.na(county_per_poverty) ~ NA_character_,
           poverty_group_number == 1 ~ "low",
           poverty_group_number == 2 ~ "medium",
           poverty_group_number == 3 ~ "high"
         ),
         poverty_group = factor(
           poverty_group,
           levels = c("low", "medium", "high"),
           ordered = TRUE
         )
  ) |>
    select(-poverty_group_number)

schools_clean <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

nys_merged <- schools_clean |>
  left_join(
    acs_clean,
    by = c("county_name", "year"),
    relationship = "many-to-one"
  )

write_csv(nys_merged, "data/processed/nys_merged.csv")
