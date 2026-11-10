# 2_transform.R
# Purpose: Create poverty groups, standardize test scores by year, merge datasets

library(tidyverse)

# ---- Load cleaned data ----
schools <- read_csv("data/processed/schools_clean.csv")
acs <- read_csv("data/processed/acs_clean.csv")

# ---- Check info needed for decisions ----
# Poverty rate distribution (for grouping)
hist(acs$county_per_poverty)
quantile(acs$county_per_poverty, c(1/3, 2/3))

# Year ranges (for choosing the join)
range(schools$year)
range(acs$year)
# ---- Create poverty groups ----
# Decision: [need a same group size.]
# Each county is assigned ONE group based on its average poverty rate (2009-2016),
# so groups stay fixed over time.

county_poverty <- acs |>
  group_by(county_name) |>
  summarise(avg_poverty = mean(county_per_poverty)) |>
  mutate(poverty_group = case_when(
    ntile(avg_poverty, 3) == 1 ~ "low",
    ntile(avg_poverty, 3) == 2 ~ "medium",
    ntile(avg_poverty, 3) == 3 ~ "high"
  ),
  poverty_group = factor(poverty_group, levels = c("low", "medium", "high")))

# Check: group sizes and cutoffs
county_poverty |>
  group_by(poverty_group) |>
  summarise(n_counties = n(),
            min_poverty = min(avg_poverty),
            max_poverty = max(avg_poverty))

# Add poverty group back to acs
acs <- acs |>
  left_join(county_poverty |> select(county_name, poverty_group), by = "county_name")

# ---- Standardize test scores within each year ----
# Test scales change year to year, so raw scores aren't comparable across years
schools <- schools |>
  group_by(year) |>
  mutate(ela_z = as.numeric(scale(mean_ela_score)),
         math_z = as.numeric(scale(mean_math_score))) |>
  ungroup()

# Check: each year should have mean ~0, sd ~1
schools |>
  group_by(year) |>
  summarise(ela_mean = mean(ela_z, na.rm = TRUE),
            ela_sd = sd(ela_z, na.rm = TRUE))

# Decision: inner_join - all questions need poverty info, so school-years
# without ACS match (2008, 2017, missing county) can't be used
merged <- inner_join(schools, acs, by = c("county_name", "year"))


# Check: row count before/after join, and missing poverty group
nrow(schools)
nrow(merged)
sum(is.na(merged$poverty_group))

# ---- Save merged data ----
write_csv(merged, "data/processed/merged.csv")