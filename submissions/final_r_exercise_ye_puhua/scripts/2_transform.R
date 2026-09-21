# Purpose: Create analysis variables and merge the two datasets.
# Input: Cleaned datasets from data/processed/
# Output: Transformed and merged datasets saved in data/processed/

library(tidyverse)

# Read cleaned data
schools_clean <- read_csv("data/processed/nys_schools_clean.csv")
acs_clean <- read_csv("data/processed/nys_acs_clean.csv")

# Create school-level variables
schools_transformed <- schools_clean |>
  group_by(year) |>
  mutate(
    # Standardize test scores within each year
    ela_z = as.numeric(scale(mean_ela_score)),
    math_z = as.numeric(scale(mean_math_score))
  ) |>
  ungroup()

# Divide counties into three equally sized poverty groups within each year
acs_transformed <- acs_clean |>
  group_by(year) |>
  mutate(
    poverty_third = ntile(county_per_poverty, 3),
    poverty_group = case_when(
      poverty_third == 1 ~ "low",
      poverty_third == 2 ~ "medium",
      poverty_third == 3 ~ "high"
    )
  ) |>
  ungroup() |>
  select(-poverty_third)

# Merge school data with county data for matching counties and years
merged <- schools_transformed |>
  inner_join(acs_transformed, by = c("county_name", "year"))

# Save transformed and merged data
write_csv(schools_transformed, "data/processed/nys_schools_transformed.csv")
write_csv(acs_transformed, "data/processed/nys_acs_transformed.csv")
write_csv(merged, "data/processed/nys_merged.csv")
