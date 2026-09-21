library(tidyverse)
acs <- read.csv("data/raw/nys_acs.csv")
school <- read.csv("data/raw/nys_schools.csv")

acs %>%
  glimpse()

duplicated(acs)

n_distinct(acs)

school %>%
  glimpse()

duplicated(school)

n_distinct(school)

#deal with na
library(dplyr)

school_cleaned <- school |>
  mutate(
    across(where(is.numeric),   ~ na_if(.x, -99)),
    across(where(is.character), ~ na_if(.x, "-99")),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )


#decide poverty boundary
acs$county_per_poverty

acs |> 
  group_by(county_name)|>
  summarise(avf = mean(county_per_poverty, na.rm = TRUE))

#duplicated
school_cleaned <- distinct(school_cleaned)
acs_cleaned <- distinct(acs)

acs_cleaned <- acs_cleaned |>
  mutate(
    across(where(is.numeric),   ~ na_if(.x, -99))
  )

write_csv(school_cleaned, "data/processed/school_cleand.csv")
write_csv(acs_cleaned, "data/processed/acs_cleand.csv")

