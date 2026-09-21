library(tidyverse)

schools_clean <- read_csv(
  "data/processed/nys_schools_clean.csv"
)

acs_clean <- read_csv(
  "data/processed/nys_acs_clean.csv"
)

# Create poverty groups
acs_processed <- acs_clean %>%
  group_by(year) %>%
  mutate(
    poverty_group = case_when(
      ntile(county_per_poverty, 3) == 1 ~ "low",
      ntile(county_per_poverty, 3) == 2 ~ "medium",
      ntile(county_per_poverty, 3) == 3 ~ "high"
    )
  ) %>%
  ungroup()

# Create yearly standardized test scores
schools_processed <- schools_clean %>%
  group_by(year) %>%
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z = as.numeric(scale(mean_ela_score))
  ) %>%
  ungroup()

# Save Task 3 results
write_csv(
  schools_processed,
  "data/processed/nys_schools_processed.csv"
)

write_csv(
  acs_processed,
  "data/processed/nys_acs_processed.csv"
)

merged_data <- schools_processed %>%
  inner_join(
    acs_processed,
    by = c("county_name", "year")
  )

write_csv(
  merged_data,
  "data/processed/nys_merged.csv"
)