library(tidyverse)

# Import cleaned datasets
nys_schools_clean <- read_csv(
  "data/processed/nys_schools_clean.csv"
)

nys_acs_clean <- read_csv(
  "data/processed/nys_acs_clean.csv"
)

# ---------------------------------------------------------
# Create county poverty groups
# ---------------------------------------------------------

# Divide counties into three approximately equal-sized
# poverty groups within each year
nys_acs_processed <- nys_acs_clean |>
  group_by(year) |>
  mutate(
    poverty_rank = ntile(county_per_poverty, 3),
    
    poverty_group = case_when(
      poverty_rank == 1 ~ "low",
      poverty_rank == 2 ~ "medium",
      poverty_rank == 3 ~ "high",
      TRUE ~ NA_character_
    )
  ) |>
  ungroup() |>
  select(-poverty_rank) |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high")
    )
  )

# ---------------------------------------------------------
# Standardize test scores within each year
# ---------------------------------------------------------

# Standardize ELA and math scores separately within each year
# because raw test score scales changed over time
nys_schools_processed <- nys_schools_clean |>
  group_by(year) |>
  mutate(
    ela_z = as.numeric(scale(mean_ela_score)),
    math_z = as.numeric(scale(mean_math_score))
  ) |>
  ungroup() |>
  mutate(
    per_free_reduced = per_free_lunch + per_reduced_lunch,
    per_free_reduced = if_else(
      per_free_reduced <= 1,
      per_free_reduced,
      NA_real_
    )
  )
# ---------------------------------------------------------
# Save transformed datasets
# ---------------------------------------------------------

write_csv(
  nys_acs_processed,
  "data/processed/nys_acs_processed.csv"
)

write_csv(
  nys_schools_processed,
  "data/processed/nys_schools_processed.csv"
)

# ---------------------------------------------------------
# Merge school and ACS datasets
# ---------------------------------------------------------

# Each school-year should match one county-year ACS record
merged_data <- nys_schools_processed |>
  inner_join(
    nys_acs_processed,
    by = c("county_name", "year"),
    relationship = "many-to-one"
  )

# Save merged dataset
write_csv(
  merged_data,
  "data/processed/nys_schools_acs.csv"
)