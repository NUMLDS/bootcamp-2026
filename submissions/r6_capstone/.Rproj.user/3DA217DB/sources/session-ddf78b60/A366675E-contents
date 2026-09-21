library(tidyverse)
raw_counties <- read.csv('data/raw/nys_acs.csv')
raw_schools <- read.csv('data/raw/nys_schools.csv')



schools_clean <- raw_schools |>
  distinct() |>
  mutate(
    county_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

acs_clean <- raw_counties |>
  distinct() |>
  mutate(across(where(is.numeric), ~na_if(.x, -99)))


write_csv(schools_clean, "data/processed/schools_clean.csv")
write_csv(acs_clean, "data/processed/acs_clean.csv")
