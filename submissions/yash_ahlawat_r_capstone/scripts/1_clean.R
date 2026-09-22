library(tidyverse)

#Import the raw data
nys_acs <- read_csv("data/raw/nys_acs.csv")
nys_schools <- read_csv("data/raw/nys_schools.csv")

#Exploring the data 
glimpse(nys_acs)
glimpse(nys_schools)

dim(nys_acs)
dim(nys_schools)

colSums(is.na(nys_acs))
colSums(is.na(nys_schools))

summary(nys_acs)
summary(nys_schools)

#Cleaning the data 

nys_acs_clean <- nys_acs |>
  distinct() |>
  mutate(
    across(where(is.numeric), ~ na_if(.x, -99))
  )

nys_schools_clean <- nys_schools |>
  distinct() |>
  mutate(
    country_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

#Saving cleaned data
write_csv(nys_acs_clean, "data/processed/nys_acs_clean.csv")
write_csv(nys_schools_clean, "data/processed/nys_schools_clean.csv")