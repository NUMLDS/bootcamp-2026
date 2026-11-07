acs_process <- acs_clean |>
  mutate(
    poverty_group = cut(
      county_per_poverty,
      breaks = c(-Inf, 0.10, 0.20, Inf),
      labels = c("low", "medium", "high"),
      right = FALSE
    )
  )

school_process <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

merged_data <- school_process |>
  left_join(
    acs_process,
    by = c("county_name", "year")
  )

write_csv(
  merged_data, 
  "data/processed/nys_merged.csv"
)

