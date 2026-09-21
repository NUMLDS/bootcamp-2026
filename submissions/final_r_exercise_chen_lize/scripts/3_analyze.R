library(tidyverse)

# Import merged data
data <- read_csv(
  "data/processed/nys_schools_acs_merged.csv",
  show_col_types = FALSE
)

# County-level summary
county_summary <- data %>%
  group_by(county_name) %>%
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    mean_frpl = mean(per_frpl, na.rm = TRUE),
    mean_poverty = mean(county_per_poverty, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )

county_summary

# Test performance by poverty group
poverty_summary <- data %>%
  group_by(poverty_group) %>%
  summarise(
    n = n(),
    mean_poverty = mean(county_per_poverty, na.rm = TRUE),
    mean_frpl = mean(per_frpl, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )

poverty_summary

# Test performance by poverty group over time
poverty_year_summary <- data %>%
  group_by(year, poverty_group) %>%
  summarise(
    n = n(),
    mean_frpl = mean(per_frpl, na.rm = TRUE),
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )

poverty_year_summary

# Five counties with highest average poverty
highest_poverty <- county_summary %>%
  arrange(desc(mean_poverty)) %>%
  slice_head(n = 5)

highest_poverty

# Five counties with lowest average poverty
lowest_poverty <- county_summary %>%
  arrange(mean_poverty) %>%
  slice_head(n = 5)

lowest_poverty

# Correlation between FRPL and test performance
ela_frpl_cor <- cor(
  data$per_frpl,
  data$ela_z,
  use = "complete.obs"
)

math_frpl_cor <- cor(
  data$per_frpl,
  data$math_z,
  use = "complete.obs"
)

ela_frpl_cor
math_frpl_cor

# Save summary tables
write_csv(
  county_summary,
  "data/processed/county_summary.csv"
)

write_csv(
  poverty_summary,
  "data/processed/poverty_summary.csv"
)

write_csv(
  poverty_year_summary,
  "data/processed/poverty_year_summary.csv"
)

