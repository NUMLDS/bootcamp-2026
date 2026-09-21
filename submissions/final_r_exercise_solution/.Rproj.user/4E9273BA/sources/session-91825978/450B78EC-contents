# scripts/4_plot.R
# Builds p1, p2, p3; sourced by report.Rmd rather than saved as image files.

library(tidyverse)

merged <- read_csv("data/processed/merged.csv")
poverty_group_trend <- read_csv("data/processed/poverty_group_trend.csv") |>
  mutate(poverty_group = factor(poverty_group, levels = c("Low", "Medium", "High")))

# FRL access vs. test performance (school level)
p1 <- merged |>
  mutate(pct_frl_school = per_free_lunch + per_reduced_lunch) |>
  filter(!is.na(pct_frl_school), !is.na(mean_math_score)) |>
  ggplot(aes(x = pct_frl_school, y = mean_math_score)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE, col = "steelblue") +
  labs(
    title = "Schools with More Free/Reduced Lunch Students Score Lower in Math",
    x = "% Students on Free/Reduced Lunch", y = "Mean Math Score"
  ) +
  theme_minimal()

# Test performance across poverty groups
p2 <- merged |>
  filter(!is.na(poverty_group)) |>
  mutate(poverty_group = factor(poverty_group, levels = c("Low", "Medium", "High"))) |>
  group_by(poverty_group) |>
  summarize(
    mean_math = mean(mean_math_score, na.rm = TRUE),
    mean_ela = mean(mean_ela_score, na.rm = TRUE),
    .groups = "drop"
  ) |>
  pivot_longer(cols = c(mean_math, mean_ela), names_to = "subject", values_to = "score") |>
  ggplot(aes(x = poverty_group, y = score, fill = subject)) +
  geom_col(position = "dodge") +
  labs(
    title = "Test Scores Decline as County Poverty Increases",
    x = "County Poverty Group", y = "Mean Score", fill = "Subject"
  ) +
  theme_minimal()

# Has the poverty gap changed over time?
p3 <- poverty_group_trend |>
  filter(!is.na(poverty_group)) |>
  ggplot(aes(x = year, y = mean_math_z, col = poverty_group)) +
  geom_line(linewidth = 1) +
  labs(
    title = "The Poverty Gap in Math Performance Has Persisted Over Time",
    x = "Year", y = "Mean Standardized Math Score (z-score)", col = "Poverty Group"
  ) +
  theme_minimal()
