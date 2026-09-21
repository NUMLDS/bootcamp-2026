library(tidyverse)
schools <- read.csv('data/raw/nys_schools.csv')
counties <- read.csv('data/raw/nys_acs.csv')
schools <- schools |> distinct()
counties <- counties |> distinct()

schools <- schools |>
  mutate(
    county_name = na_if(county_name, '-99'),
    across(where(is.numeric), ~ na_if(.x,-99)),
    per_free_lunch  = if_else(per_free_lunch>1, NA_real_, per_free_lunch),
    per_reduced_lunch  = if_else(per_reduced_lunch>1, NA_real_, per_reduced_lunch)
  )|>
  drop_na()

counties <- counties |>
  mutate(across(where(is.numeric), ~ na_if(.x,-99))) |>
  drop_na() |> 
  mutate(poverty_level = case_when(
  county_per_poverty < quantile(counties$county_per_poverty,1/3) ~ 'Low',
  county_per_poverty < quantile(counties$county_per_poverty,2/3) ~ 'Medium',
  TRUE ~ 'High'
))



schools <- schools %>%
  group_by(year) %>%
  mutate(std_math = as.numeric(scale(mean_math_score))) %>%
  mutate(std_ela = as.numeric(scale(mean_ela_score))) %>%
  ungroup()

joined <- schools |>
  left_join(counties, by = c('county_name','year') ) |>
  drop_na()

write_csv(joined, 'data/processed/schools.csv')

# glimpse(schools)
# glimpse(counties)