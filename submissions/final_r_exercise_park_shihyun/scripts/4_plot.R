# 4_plot.R
# Purpose: Visualizations to share with the department

library(tidyverse)

# ---- Load merged data ----
merged <- read_csv("data/processed/merged.csv") |>
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high")),
         per_lunch = per_free_lunch + per_reduced_lunch)

# ---- Plot 1: Avg test performance by poverty group (Q2) ----
plot_group <- merged |>
  group_by(poverty_group) |>
  summarise(ELA = mean(ela_z, na.rm = TRUE),
            Math = mean(math_z, na.rm = TRUE)) |>
  pivot_longer(c(ELA, Math), names_to = "subject", values_to = "z") |>
  ggplot(aes(x = poverty_group, y = z, fill = subject)) +
  geom_col(position = "dodge") +
  geom_hline(yintercept = 0) +
  labs(title = "Schools in high-poverty counties score well below average",
       subtitle = "Average standardized test score by county poverty group, 2009-2016",
       x = "County poverty group", y = "Average z-score (0 = state average)",
       fill = "Subject") +
  theme_minimal()
plot_group

# ---- Plot 2: Poverty gap over time (Q3) ----
plot_trend <- merged |>
  group_by(year, poverty_group) |>
  summarise(math_z = mean(math_z, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(x = year, y = math_z, color = poverty_group)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(title = "The poverty gap in math scores narrowed from 2009 to 2016",
       subtitle = "Average standardized math score by county poverty group",
       x = "Year", y = "Average math z-score", color = "Poverty group") +
  theme_minimal()
plot_trend

# ---- Plot 3: Free/reduced lunch vs test performance, school level (Q4) ----
# Each point = one school-year; lines = linear trend within each poverty group
plot_lunch <- merged |>
  filter(!is.na(per_lunch), !is.na(math_z), per_lunch <= 1) |>
  ggplot(aes(x = per_lunch, y = math_z, color = poverty_group)) +
  geom_point(alpha = 0.05) +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_continuous(labels = scales::percent) +
  labs(title = "More free/reduced lunch, lower scores, in every poverty group",
       subtitle = "School-level share of students on free/reduced lunch vs. math score",
       x = "Students on free/reduced price lunch", y = "Math z-score",
       color = "County poverty group") +
  theme_minimal()
plot_lunch