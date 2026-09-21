library(tidyverse)

schools_raw <- read_csv("~/Desktop/Capstone/data/raw/nys_schools.csv")
acs_raw <- read_csv("~/Desktop/Capstone/data/raw/nys_acs.csv")

schools_clean <- schools_raw |>
  distinct() |>
  mutate(
    county_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

acs_clean <- acs_raw |>
  distinct() |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))

write_csv(schools_clean, "~/Desktop/Capstone/data/processed/schools_clean.csv")
write_csv(acs_clean, "~/Desktop/Capstone/data/processed/acs_clean.csv")