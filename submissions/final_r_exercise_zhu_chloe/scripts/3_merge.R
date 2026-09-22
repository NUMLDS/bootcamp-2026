library(tidyverse)

# Read processed datasets
schools_processed <- read_csv(
  "data/processed/nys_schools_processed.csv"
)

acs_processed <- read_csv(
  "data/processed/nys_acs_processed.csv"
)

# Merge school data with ACS data by matching county and year
merged_data <- schools_processed |>
  left_join(
    acs_processed,
    by = c("county_name", "year")
  )#left_join() keeps all rows from the left dataset (schools_processed) and adds matching variables from acs_processed based on county_name and year

# Check merged data
glimpse(merged_data)
head(merged_data)

# Save merged dataset
write_csv(
  merged_data,
  "data/processed/nys_merged.csv"
)