library(tidyverse)

# Import cleaned data
schools <- read_csv(
  "data/processed/nys_schools_clean.csv",
  show_col_types = FALSE
)

acs <- read_csv(
  "data/processed/nys_acs_clean.csv",
  show_col_types = FALSE
)

# Create total free/reduced-price lunch measure
schools <- schools %>%
  mutate(
    per_frpl = per_free_lunch + per_reduced_lunch,
    per_frpl = if_else(per_frpl > 1, NA_real_, per_frpl)
  )

# Standardize ELA and math scores within each year
schools <- schools %>%
  group_by(year) %>%
  mutate(
    ela_z = as.numeric(scale(mean_ela_score)),
    math_z = as.numeric(scale(mean_math_score))
  ) %>%
  ungroup()

# Create low, medium, and high poverty groups within each year
acs <- acs %>%
  group_by(year) %>%
  mutate(
    poverty_group = ntile(county_per_poverty, 3),
    poverty_group = case_when(
      poverty_group == 1 ~ "Low",
      poverty_group == 2 ~ "Medium",
      poverty_group == 3 ~ "High"
    ),
    poverty_group = factor(
      poverty_group,
      levels = c("Low", "Medium", "High")
    )
  ) %>%
  ungroup()

# Merge school and county data
merged_data <- schools %>%
  inner_join(
    acs,
    by = c("county_name", "year")
  )

# Save merged dataset
write_csv(
  merged_data,
  "data/processed/nys_schools_acs_merged.csv"
)

# Check results
glimpse(merged_data)

dim(merged_data)
table(merged_data$year)
table(merged_data$poverty_group)

summary(merged_data$per_frpl)
summary(merged_data$ela_z)
summary(merged_data$math_z)

