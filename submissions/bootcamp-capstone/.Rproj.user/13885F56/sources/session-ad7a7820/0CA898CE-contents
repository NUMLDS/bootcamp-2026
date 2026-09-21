library(tidyverse)

nys_schools = read_csv("data/raw/nys_schools.csv")
nys_acs = read_csv("data/raw/nys_acs.csv")

# clean nys schools
nys_schools_clean = nys_schools |>
  
  # remove duplicates
  distinct() |>
  
  # fix NAs, over 100%
  mutate(
    across(where(is.character), str_trim),
    across(where(is.character), str_squish),
    across(where(is.character), ~ na_if(.x, "")),
    across(where(is.character), ~ na_if(.x, "-99")),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(
      per_free_lunch > 1, NA_real_, per_free_lunch
      ),
    per_reduced_lunch = if_else(
      per_reduced_lunch > 1, NA_real_, per_reduced_lunch
      )
    )

# clean nys schools
nys_acs_clean = nys_acs |>
  
  # remove duplicates
  distinct() |>
  
  # fix NAs, over 100%
  mutate(
    across(where(is.character), str_trim),
    across(where(is.character), str_squish),
    across(where(is.character), ~ na_if(.x, "")),
    across(where(is.character), ~ na_if(.x, "-99")),
    across(where(is.numeric), ~ na_if(.x, -99)),
    county_per_poverty = if_else(
      county_per_poverty > 1, NA_real_, county_per_poverty
    ),
    county_per_bach = if_else(
      county_per_bach > 1, NA_real_, county_per_bach
    )
  )

write_csv(nys_schools_clean, "data/processed/nys_schools_clean.csv")
write_csv(nys_acs_clean, "data/processed/nys_acs_clean.csv")