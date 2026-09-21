# school level
school_plot <- nys_merged |>
  group_by(school_cd, school_name) |>
  summarise(
    free_reduced_lunch = mean(
      per_free_lunch + per_reduced_lunch,
      na.rm = TRUE
    ),
    
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    
    mean_math_z = mean(math_z, na.rm = TRUE),
    
    .groups = "drop"
  )

school_plot <- school_plot |>
  filter(
    is.finite(free_reduced_lunch),
    is.finite(mean_ela_z),
    is.finite(mean_math_z)
  )

# plot ela
ggplot(
  school_plot,
  aes(x = free_reduced_lunch, y = mean_ela_z)
) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "The ELA Performance Decreased As Free/Reduced Price Lunch Access Increased",
    x = "Average Percent Receiving Free/Reduced Price Lunch",
    y = "Average Standardized ELA Score"
  ) +
  theme_minimal()

# plot math
ggplot(
  school_plot,
  aes(x = free_reduced_lunch, y = mean_math_z)
) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "The Math Performance Decreased As Free/Reduced Price Lunch Access Increased",
    x = "Average Percent Receiving Free/Reduced Price Lunch",
    y = "Average Standardized Math Score"
  ) +
  theme_minimal()

# county level
county_plot <- nys_merged |>
  group_by(county_name, year) |>
  summarise(
    poverty_group = first(poverty_group),
    
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

county_plot <- county_plot |>
  group_by(county_name) |>
  summarise(
    poverty_group = first(poverty_group),
    mean_ela_z = mean(mean_ela_z, na.rm = TRUE),
    mean_math_z = mean(mean_math_z, na.rm = TRUE),
    .groups = "drop"
  ) |>
  filter(
    is.finite(mean_ela_z),
    is.finite(mean_math_z)
  )

county_plot <- county_plot |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("Low", "Medium", "High")
    )
  )

ggplot(
  county_plot,
  aes(x = poverty_group, y = mean_ela_z)
) +
  geom_boxplot() +
  geom_jitter(width = 0.15, alpha = 0.5) +
  labs(
    title = "The ELA Performance Decreased as the Poverty Rate Increased",
    x = "County Poverty Level",
    y = "Average Standardized ELA Score"
  ) +
  theme_minimal()

ggplot(
  county_plot,
  aes(x = poverty_group, y = mean_math_z)
) +
  geom_boxplot() +
  geom_jitter(width = 0.15, alpha = 0.5) +
  labs(
    title = "The Math Performance Decreased As the Poverty Rate Increased",
    x = "County Poverty Level",
    y = "Average Standardized Math Score"
  ) +
  theme_minimal()
