# Load required packages
library(tidyverse)

# Import merged data
merged_data <- read_csv(
  "data/processed/merged_data.csv",
  show_col_types = FALSE
)
# Restore poverty group order
merged_data <- merged_data |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("Low", "Medium", "High")
    )
  )
# Plot math performance across poverty groups
ggplot(
  merged_data |>
    filter(
      !is.na(poverty_group),
      !is.na(math_z)
    ),
  aes(x = poverty_group, y = math_z)
) +
  geom_boxplot() +
  labs(
    title = "Math Performance Tends to Be Lower in Higher-Poverty Counties",
    x = "County Poverty Group",
    y = "Standardized Math Score (z-score)"
  ) +
  theme_minimal()

# Create combined free/reduced-price lunch rate
merged_data <- merged_data |>
  mutate(
    frpl_rate = per_free_lunch + per_reduced_lunch
  )
summary(merged_data$frpl_rate)

# Inspect invalid combined lunch rates
merged_data |>
  filter(frpl_rate > 1) |>
  select(
    school_name,
    year,
    per_free_lunch,
    per_reduced_lunch,
    frpl_rate
  )

# Treat invalid combined lunch rates as missing
merged_data <- merged_data |>
  mutate(
    frpl_rate = if_else(
      between(frpl_rate, 0, 1),
      frpl_rate,
      NA_real_
    )
  )
summary(merged_data$frpl_rate)

# Plot free/reduced-price lunch rate versus math performance
ggplot(
  merged_data |>
    filter(
      !is.na(frpl_rate),
      !is.na(math_z)
    ),
  aes(x = frpl_rate, y = math_z)
) +
  geom_point(alpha = 0.2) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  labs(
    title = "Math Performance Tends to Decline as Lunch Assistance Increases",
    x = "Free/Reduced-Price Lunch Rate",
    y = "Standardized Math Score (z-score)"
  ) +
  theme_minimal()