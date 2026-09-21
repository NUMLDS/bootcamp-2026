summary_data <- merged_data |>
  group_by(county_name) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    free_reduced_lunch_percent =
      mean(per_free_lunch + per_reduced_lunch, na.rm = TRUE) * 100,
    poverty_percent =
      mean(county_per_poverty, na.rm = TRUE) * 100
  )
summary_data
