nys_acs = read_csv("data/raw/nys_acs.csv")
nys_schools = read_csv("data/raw/nys_schools.csv")

glimpse(nys_acs)
glimpse(nys_schools)

any(nys_acs == -99, na.rm = TRUE)
any(nys_schools == -99, na.rm = TRUE)

nys_schools_clean = nys_schools |> distinct() |>
  mutate(
    county_name = na_if(county_name, '-99'),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lun = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

range(nys_acs$median_household_income, na.rm = TRUE)
nys_acs_clean <- nys_acs |>
  group_by(county_name) |>
  mutate(
    avg_county_poverty = mean(county_per_poverty, na.rm = TRUE)
  ) |>
  ungroup() |>
  mutate(
    poverty_group = cut(
      avg_county_poverty,
      breaks = 3,
      labels = c("Low", "Medium", "High"),
      include.lowest = TRUE
    )
  )

names(nys_schools_clean)
names(nys_acs_clean)
nys_schools_clean = nys_schools_clean |>
  group_by(year) |>
  mutate(
    ela_z = as.numeric(scale(mean_ela_score)),
    math_z = as.numeric(scale(mean_math_score))
  ) |>
  ungroup()

write_csv(nys_schools_clean, "data/processed/nys_schools_processed.csv")
write_csv(nys_acs_clean, "data/processed/nys_acs_processed.csv")

