county_avg <- merged_data |>
  group_by(county_name, income_group) |>
  summarise(
    avg_math = mean(math_z, na.rm = TRUE),
    avg_ela  = mean(ela_z, na.rm = TRUE),
    .groups = "drop"
  )

county_avg_high <- county_avg |>
  filter(income_group == "high")
