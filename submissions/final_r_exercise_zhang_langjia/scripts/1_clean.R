library(tidyverse)
schools <- read_csv("data/raw/nys_schools.csv")
acs <- read_csv("data/raw/nys_acs.csv")
#glimpse(schools)
#glimpse(acs)
schools_cleaned <- schools |>
  distinct() |>
  mutate(
    across(
      where(is.numeric),
      ~ na_if(.x, -99)
    )
  ) |>
  drop_na()

acs_cleaned <- acs |>
  distinct() |>
  mutate(
    across(
      where(is.numeric),
      ~ na_if(.x, -99)
    )
  ) |>
  drop_na()

write_csv(schools_cleaned, "data/processed/schools_cleaned")
write_csv(acs_cleaned, "data/processed/acs_cleaned")