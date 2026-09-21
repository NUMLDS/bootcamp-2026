# Purpose: Create publication-ready plots for the final report.
# Input: The merged analysis dataset from data/processed/
# Output: Plots used in the final report.

library(tidyverse)

# Read merged data and order the poverty groups
merged <- read_csv("data/processed/nys_merged.csv") |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high")
    )
  )

# Plot 1: average test performance by poverty group
poverty_plot_data <- merged |>
  group_by(poverty_group) |>
  summarize(
    ELA = mean(ela_z, na.rm = TRUE),
    Math = mean(math_z, na.rm = TRUE)
  ) |>
  pivot_longer(
    cols = c(ELA, Math),
    names_to = "subject",
    values_to = "mean_score"
  )

poverty_plot <- ggplot(
  poverty_plot_data,
  aes(x = poverty_group, y = mean_score, fill = subject)
) +
  geom_col(position = "dodge") +
  labs(
    title = "Test performance declines as county poverty increases",
    x = "County poverty group",
    y = "Mean standardized score",
    fill = "Subject"
  ) +
  theme_minimal()

# Plot 2: test performance over time by poverty group
year_plot_data <- merged |>
  group_by(year, poverty_group) |>
  summarize(
    ELA = mean(ela_z, na.rm = TRUE),
    Math = mean(math_z, na.rm = TRUE)
  ) |>
  ungroup() |>
  pivot_longer(
    cols = c(ELA, Math),
    names_to = "subject",
    values_to = "mean_score"
  )

year_plot <- ggplot(
  year_plot_data,
  aes(x = year, y = mean_score, color = poverty_group)
) +
  geom_line() +
  geom_point() +
  facet_wrap(~subject) +
  labs(
    title = "Test-score gaps between poverty groups persist over time",
    x = "Year",
    y = "Mean standardized score",
    color = "County poverty group"
  ) +
  theme_minimal()

poverty_plot
year_plot
