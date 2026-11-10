library(tidyverse)

school_df <- read_csv("data/raw/nys_schools.csv")
acs_df <- read_csv("data/raw/nys_acs.csv")

clean_schools <- school_df |>
  distinct() |>
  mutate(
    county_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

clean_acs <- acs_df |>
  distinct() |>
  mutate(
    across(where(is.numeric), ~ na_if(.x, -99))
  )

# Save the processed dataset
write_csv(clean_schools, "data/processed/clean_schools.csv")
write_csv(clean_acs, "data/processed/clean_acs.csv")