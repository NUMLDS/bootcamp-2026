# 2_transform.R
# Purpose: create poverty groups, standardize test scores by year, merge datasets.

library(tidyverse)

schools <- read_csv("data/processed/schools_clean.csv")
acs <- read_csv("data/processed/acs_clean.csv")

# --- OPTION A: equal-sized terciles (data-driven, ignores real-world meaning) --
acs <- acs %>%
  mutate(poverty_group = ntile(county_per_poverty, 3),
         poverty_group = case_when(
           poverty_group == 1 ~ "low",
           poverty_group == 2 ~ "medium",
           poverty_group == 3 ~ "high"
         ))

acs %>%
  group_by(poverty_group) %>%
  summarize(
    n = n(),
    min_poverty = min(county_per_poverty, na.rm = TRUE),
    max_poverty = max(county_per_poverty, na.rm = TRUE)
  )

schools <- schools %>%
  group_by(year) %>%
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) %>%
  ungroup()

merged <- schools %>%
  left_join(acs, by = c("county_name", "year"))

# sanity checks — do this before trusting the merge:
nrow(schools)          # rows before
nrow(merged)            # should match nrow(schools) if join key is clean
sum(is.na(merged$poverty_group))  # rows that didn't find a county match

# find any county names that failed to match (spelling mismatches are common)
anti_join(schools, acs, by = c("county_name", "year")) %>% distinct(county_name)

write_csv(merged, "data/processed/merged_data.csv")