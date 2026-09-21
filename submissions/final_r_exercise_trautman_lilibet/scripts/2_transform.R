library(tidyverse)

schools_clean <- read_csv("data/processed/schools_clean.csv")
acs_clean <- read_csv("data/processed/acs_clean.csv")

acs_grouped <- acs_clean |>
  mutate(
    poverty_group = ntile(county_per_poverty, 3),
    poverty_group = factor(poverty_group, levels = c(1, 2, 3),
                           labels = c("low", "medium", "high"))
)

merged <- schools_clean |>
  left_join(acs_clean, by = c("county_name", "year"))

write_csv(merged,"data/processed/schools_acs_merged.csv")