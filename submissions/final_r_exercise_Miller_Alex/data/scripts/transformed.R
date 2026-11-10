# scripts/2_transform.R
# Adds poverty group, standardizes math/ELA scores within each year,
# and merges the schools and ACS data. Saves to data/processed/.

library(tidyverse)

# Classifies poverty_rate into Low / Medium / High using tertiles.
classify_poverty <- function(poverty_rate) {
  cuts <- quantile(poverty_rate, probs = c(1 / 3, 2 / 3), na.rm = TRUE)
  
  group <- dplyr::case_when(
    poverty_rate <= cuts[1] ~ "Low",
    poverty_rate <= cuts[2] ~ "Medium",
    TRUE ~ "High"
  )
  
  factor(group, levels = c("Low", "Medium", "High"))
}

schools_clean <- read_csv("~/Desktop/Capstone/data/processed/schools_clean.csv")
acs_clean <- read_csv("~/Desktop/Capstone/data/processed/acs_clean.csv")

acs_grouped <- acs_clean |>
  mutate(poverty_group = classify_poverty(county_per_poverty))

schools_z <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

# Keyed on county_name + year (ACS column is "county_name" despite the
# codebook calling it "name")
merged <- schools_z |>
  left_join(acs_grouped, by = c("county_name", "year"))

write_csv(merged, "~/Desktop/Capstone/data/processed/merged.csv")
