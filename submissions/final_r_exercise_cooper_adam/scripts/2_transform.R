library(tidyverse)

# Load the cleaned datasets
clean_schools <- read_csv("data/processed/clean_schools.csv")
clean_acs <- read_csv("data/processed/clean_acs.csv")

# Divide counties into three approximately equal-sized poverty groups.
acs_transformed <- clean_acs |>
  mutate(
    poverty_group = ntile(median_household_income, 3),
    poverty_group = recode(
      poverty_group,
      `1` = "low",
      `2` = "medium",
      `3` = "high"
    ),
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high"),
      ordered = TRUE
    )
  )

# Merge county-level ACS information onto each school.
merged_data <- clean_schools |>
  left_join(
    acs_transformed,
    by = c("county_name", "year")
  )

# Standardize test scores separately within each year.
# The resulting z-scores describe each school's performance relative
# to other schools tested during the same year.
transformed_data <- merged_data |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

# Save the final transformed and merged dataset
write_csv(
  transformed_data,
  "data/processed/transformed_schools.csv"
)