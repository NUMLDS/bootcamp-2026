# 4_plot.R
# Purpose: visualize the relationship between poverty, lunch access, and test scores.
# Input: data/processed/merged_data.csv
# Output: ggplot objects, saved as .png for use in findings.Rmd

library(tidyverse)

merged <- read_csv("data/processed/merged_data.csv")

# --- Plot 1: free/reduced lunch access vs test performance, school level ----
plot_lunch_scores <- merged %>%
  ggplot(aes(x = per_free_lunch, y = math_z)) +
  geom_point(alpha = 0.3, color = "steelblue") +
  geom_smooth(method = "lm", color = "darkred") +
  labs(
    title = "Schools with more free-lunch-eligible students score lower in math",
    x = "% of students eligible for free/reduced lunch",
    y = "Standardized math score (z-score)"
  ) +
  theme_minimal()

plot_lunch_scores
ggsave("plot_lunch_scores.png", plot_lunch_scores, width = 7, height = 5)

# --- Plot 2: average performance by poverty group ---------------------------
plot_poverty_group <- merged %>%
  group_by(poverty_group) %>%
  summarize(
    math = mean(math_z, na.rm = TRUE),
    ela  = mean(ela_z, na.rm = TRUE)
  ) %>%
  pivot_longer(cols = c(math, ela), names_to = "subject", values_to = "score") %>%
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high"))) %>%
  ggplot(aes(x = poverty_group, y = score, fill = subject)) +
  geom_col(position = "dodge") +
  labs(
    title = "Test scores decline as county poverty increases",
    x = "County poverty group",
    y = "Average standardized score",
    fill = "Subject"
  ) +
  theme_minimal()

plot_poverty_group
ggsave("plot_poverty_group.png", plot_poverty_group, width = 7, height = 5)

# --- Plot 3: has the poverty gap changed over time? --------------------------
plot_trend <- merged %>%
  group_by(year, poverty_group) %>%
  summarize(mean_math_z = mean(math_z, na.rm = TRUE)) %>%
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high"))) %>%
  ggplot(aes(x = year, y = mean_math_z, color = poverty_group)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    title = "The poverty gap in math scores over time",
    x = "Year",
    y = "Average standardized math score",
    color = "Poverty group"
  ) +
  theme_minimal()

plot_trend
ggsave("plot_trend.png", plot_trend, width = 7, height = 5)