# the following two groups by both county and year

county_summary <- nys_merged |>
  group_by(county_name, year) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    
    per_free_lunch = weighted.mean(
      per_free_lunch, 
      total_enroll, 
      na.rm = TRUE
    ),
    
    per_reduced_lunch = weighted.mean(
      per_reduced_lunch, 
      total_enroll, 
      na.rm = TRUE
    ),
    
    per_poverty = first(county_per_poverty),
    
    .groups = "drop"
  )

county_summary2 <- nys_merged |>
  group_by(county_name, year) |>
  summarise(
    poverty_rate = first(county_per_poverty),
    
    free_reduced_lunch = weighted.mean(
      per_free_lunch + per_reduced_lunch,
      total_enroll,
      na.rm = TRUE
    ),
    
    mean_ela = weighted.mean(
      mean_ela_score,
      total_enroll,
      na.rm = TRUE
    ),
    
    mean_math = weighted.mean(
      mean_math_score,
      total_enroll,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

top_5 <- county_summary2 |>
  slice_max(poverty_rate, n = 5)

bottom_5 <- county_summary2 |>
  slice_min(poverty_rate, n = 5)

# the following group by only county, not including the year
# the mean ela and math are calculated with weighted mean of the z scores

county_overall <- nys_merged |>
  group_by(county_name, year) |>
  summarise(
    poverty_rate = first(county_per_poverty),
    
    free_reduced_lunch = weighted.mean(
      per_free_lunch + per_reduced_lunch,
      total_enroll,
      na.rm = TRUE
    ),
    
    mean_ela_z = weighted.mean(
      ela_z,
      total_enroll,
      na.rm = TRUE
    ),
    
    mean_math_z = weighted.mean(
      math_z,
      total_enroll,
      na.rm = TRUE
    ),
    
    .groups = "drop"
  )

top_5_overall <- county_overall |>
  slice_max(poverty_rate, n = 5)

bottom_5_overall <- county_overall |>
  slice_min(poverty_rate, n = 5)
