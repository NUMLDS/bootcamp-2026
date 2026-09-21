library(tidyverse)

schools_raw <- read_csv("data/raw/nys_schools.csv")
acs_raw <- read_csv("data/raw/nys_acs.csv")

head(schools_raw)
head(acs_raw)

clean_schools <- schools_raw |>
  mutate(
    county_name = str_trim(county_name),
    county_name = str_to_upper(county_name)
  ) |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99))) |>
  group_by(year) |>
  mutate(
    z_math = as.numeric(scale(mean_math_score)),
    z_ela  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup() |>
  distinct()

clean_acs <- acs_raw |>
  mutate( 
    county_name = str_trim(county_name),
    county_name = str_to_upper(county_name)
  ) |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99))) |>
  distinct()




write_csv(clean_acs, "data/processed/acs_clean.csv")
write_csv(clean_schools, "data/processed/schools_clean.csv")