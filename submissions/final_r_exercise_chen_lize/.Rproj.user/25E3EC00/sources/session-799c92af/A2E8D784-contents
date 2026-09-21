library(tidyverse)


schools <- read_csv("data/raw/nys_schools.csv")
acs <- read_csv("data/raw/nys_acs.csv")



glimpse(schools)
glimpse(acs)

head(schools)
head(acs)

dim(schools)
dim(acs)

summary(schools)
summary(acs)

# Check years
sort(unique(schools$year))
sort(unique(acs$year))

# Check counties
sort(unique(schools$county_name))
sort(unique(acs$county_name))

# Check -99 missing values
schools %>%
  summarise(across(where(is.numeric), ~ sum(. == -99, na.rm = TRUE)))

acs %>%
  summarise(across(where(is.numeric), ~ sum(. == -99, na.rm = TRUE)))

# Check existing NA values
schools %>%
  summarise(across(everything(), ~ sum(is.na(.))))

acs %>%
  summarise(across(everything(), ~ sum(is.na(.))))



#clean

schools_clean <- schools %>%
  mutate(
    across(where(is.numeric), ~ na_if(., -99)),
    county_name = na_if(county_name, "-99"),
    per_free_lunch = if_else(
      per_free_lunch < 0 | per_free_lunch > 1,
      NA_real_,
      per_free_lunch
    ),
    per_reduced_lunch = if_else(
      per_reduced_lunch < 0 | per_reduced_lunch > 1,
      NA_real_,
      per_reduced_lunch
    ),
    per_lep = if_else(
      per_lep < 0 | per_lep > 1,
      NA_real_,
      per_lep
    )
  )

acs_clean <- acs

# Verify cleaning
summary(schools_clean)
summary(acs_clean)

# Save cleaned datasets
write_csv(schools_clean, "data/processed/nys_schools_clean.csv")
write_csv(acs_clean, "data/processed/nys_acs_clean.csv")

