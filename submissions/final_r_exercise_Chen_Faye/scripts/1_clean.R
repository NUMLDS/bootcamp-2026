library(tidyverse)
library(readr)
library(dplyr)

nys_acs <- read_csv("data/raw/nys_acs.csv")
nys_schools <- read_csv("data/raw/nys_schools.csv")

# Explore data
head(nys_acs)
view(nys_acs)
summary(nys_acs)
glimpse(nys_acs)

colSums(is.na(nys_acs))
sum(duplicated(nys_acs))

acs_clean <- nys_acs |> 
  distinct() |>
  mutate(across(where(is.numeric),~na_if(.x, -99)))

head(nys_schools)
view(nys_schools)
summary(nys_schools)
glimpse(nys_schools)

colSums(is.na(nys_schools))
sum(duplicated(nys_schools))

schools_clean <- nys_schools |>
  distinct() |>
  mutate(
    county_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

write_csv(schools_clean, "data/processed/schools_clean.csv")
write_csv(acs_clean, "data/processed/acs_clean.csv")

