# Load required packages
library(tidyverse)

# Import raw data
schools <- read_csv("data/raw/nys_schools.csv")
acs <- read_csv("data/raw/nys_acs.csv")

# Explore school data
glimpse(schools)
glimpse(acs)

# Check data summaries and possible missing values
summary(schools)
summary(acs)

# Replace -99 missing-value codes with NA
schools_clean <- schools |>
  mutate(
    across(where(is.numeric), ~ na_if(.x, -99)),
    across(where(is.character), ~ na_if(.x, "-99"))
  )
summary(schools_clean)

# Inspect unusual lunch values
schools_clean |>
  filter(per_free_lunch > 1 | per_reduced_lunch > 1) |>
  select(
    school_name,
    county_name,
    year,
    per_free_lunch,
    per_reduced_lunch
  )

# Replace invalid lunch proportions with NA
schools_clean <- schools_clean |>
  mutate(
    per_free_lunch = if_else(
      between(per_free_lunch, 0, 1),
      per_free_lunch,
      NA_real_
    ),
    per_reduced_lunch = if_else(
      between(per_reduced_lunch, 0, 1),
      per_reduced_lunch,
      NA_real_
    )
  )

summary(schools_clean)

# Save cleaned school data
write_csv(
  schools_clean,
  "data/processed/schools_clean.csv"
)