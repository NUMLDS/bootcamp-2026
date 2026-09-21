nys_acs_transform = nys_acs_clean |>
  mutate(
    poverty_group = ntile(county_per_poverty, 3),
    poverty_group = factor(poverty_group,
                           levels = c(1, 2, 3),
                           labels = c("low", "medium", "high"))
  )

nys_schools_transform = nys_schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

write_csv(nys_schools_transform, "data/processed/nys_schools_transform.csv")
write_csv(nys_acs_transform, "data/processed/nys_acs_transform.csv")

###

joined = nys_schools_transform |>
  left_join(nys_acs_transform, by=c("county_name", "year"))

write_csv(joined, "data/processed/schools_acs_merged.csv")