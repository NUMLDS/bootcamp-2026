library(tidyverse)

# Import raw datasets
nys_schools <- read_csv("data/raw/nys_schools.csv")
nys_acs <- read_csv("data/raw/nys_acs.csv")

# ---------------------------------------------------------
# Clean school data
# ---------------------------------------------------------

nys_schools_clean <- nys_schools |>
  mutate(
    # Replace -99 missing-value codes with NA
    across(where(is.numeric), ~ na_if(.x, -99)),
    
    # Percent variables should be between 0 and 1
    per_free_lunch = if_else(
      per_free_lunch >= 0 & per_free_lunch <= 1,
      per_free_lunch,
      NA_real_
    ),
    
    per_reduced_lunch = if_else(
      per_reduced_lunch >= 0 & per_reduced_lunch <= 1,
      per_reduced_lunch,
      NA_real_
    )
  )

# ---------------------------------------------------------
# Clean ACS data
# ---------------------------------------------------------

nys_acs_clean <- nys_acs |>
  mutate(
    across(where(is.numeric), ~ na_if(.x, -99))
  )

# ---------------------------------------------------------
# Save cleaned datasets
# ---------------------------------------------------------

write_csv(
  nys_schools_clean,
  "data/processed/nys_schools_clean.csv"
)

write_csv(
  nys_acs_clean,
  "data/processed/nys_acs_clean.csv"
)