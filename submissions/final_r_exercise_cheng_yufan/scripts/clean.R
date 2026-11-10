library(tidyverse)

# Read raw data
schools <- read_csv("data/raw/nys_schools.csv")
acs <- read_csv("data/raw/nys_acs.csv")

# Recode missing values coded as -99
schools_clean <- schools %>%
  mutate(
    total_enroll = na_if(total_enroll, -99),
    per_free_lunch = na_if(per_free_lunch, -99),
    per_reduced_lunch = na_if(per_reduced_lunch, -99),
    per_lep = na_if(per_lep, -99),
    mean_ela_score = na_if(mean_ela_score, -99),
    mean_math_score = na_if(mean_math_score, -99)
  )

acs_clean <- acs %>%
  mutate(
    county_per_poverty = na_if(county_per_poverty, -99),
    median_household_income = na_if(median_household_income, -99),
    county_per_bach = na_if(county_per_bach, -99)
  )

# Save cleaned data
write_csv(schools_clean, "data/processed/nys_schools_clean.csv")
write_csv(acs_clean, "data/processed/nys_acs_clean.csv")

