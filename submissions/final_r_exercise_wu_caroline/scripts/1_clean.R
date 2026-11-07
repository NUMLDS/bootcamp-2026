library(tidyverse)
raw_acs <- read_csv("data/raw/nys_acs.csv")
head(raw_acs)
raw_schools <- read_csv("data/raw/nys_schools.csv")
head(raw_schools)
glimpse(raw_acs)
glimpse(raw_schools)
acs_clean <- raw_acs |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))

schools_clean <- raw_schools |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))
