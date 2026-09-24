# Load required packages
library(tidyverse)

# Import cleaned school data and ACS data
schools_clean <- read_csv(
  "data/processed/schools_clean.csv",
  show_col_types = FALSE
)

acs <- read_csv(
  "data/raw/nys_acs.csv",
  show_col_types = FALSE
)

# Create low, medium, and high poverty groups
acs_transform <- acs |>
  mutate(
    poverty_group = ntile(county_per_poverty, 3)
  )

table(acs_transform$poverty_group)

# Label poverty groups
acs_transform <- acs_transform |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c(1, 2, 3),
      labels = c("Low", "Medium", "High")
    )
  )
table(acs_transform$poverty_group)

acs_transform |>
  group_by(poverty_group) |>
  summarise(
    mean_poverty = mean(county_per_poverty)
  )

# Standardize test scores within each year
schools_transform <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = (mean_math_score - mean(mean_math_score, na.rm = TRUE)) /
      sd(mean_math_score, na.rm = TRUE),
    
    ela_z = (mean_ela_score - mean(mean_ela_score, na.rm = TRUE)) /
      sd(mean_ela_score, na.rm = TRUE)
  ) |>
  ungroup()

# Check standardized scores
schools_transform |>
  group_by(year) |>
  summarise(
    mean_math_z = mean(math_z, na.rm = TRUE),
    sd_math_z = sd(math_z, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    sd_ela_z = sd(ela_z, na.rm = TRUE)
  )

# Merge school data with ACS county data
merged_data <- schools_transform |>
  left_join(
    acs_transform,
    by = c("county_name", "year")
  )

glimpse(merged_data)

merged_data |>
  filter(is.na(county_per_poverty)) |>
  count(year)

# Inspect unexpected unmatched records
merged_data |>
  filter(
    is.na(county_per_poverty),
    year %in% c(2014, 2015)
  ) |>
  distinct(
    year,
    county_name,
    school_name
  )
# Save transformed and merged data
write_csv(
  schools_transform,
  "data/processed/schools_transform.csv"
)

write_csv(
  acs_transform,
  "data/processed/acs_transform.csv"
)

write_csv(
  merged_data,
  "data/processed/merged_data.csv"
)
