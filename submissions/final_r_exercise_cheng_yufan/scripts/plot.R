library(tidyverse)

merged_data <- read_csv("data/processed/nys_merged.csv")

merged_data <- merged_data %>%
  mutate(
    per_free_reduced_lunch = per_free_lunch + per_reduced_lunch
  )

ggplot(
  merged_data,
  aes(x = per_free_reduced_lunch, y = math_z)
) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Math Performance and Free/Reduced Lunch Access",
    x = "Proportion of Students Receiving Free/Reduced Lunch",
    y = "Math Z-Score"
  ) +
  theme_minimal()

ggplot(
  merged_data,
  aes(x = poverty_group, y = math_z)
) +
  geom_boxplot() +
  labs(
    title = "Math Performance Across County Poverty Groups",
    x = "County Poverty Group",
    y = "Math Z-Score"
  ) +
  theme_minimal()

