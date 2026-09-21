library(dplyr)
library(ggplot2)
library(tidyr)

income_avg <- merged_data |>
  group_by(income_group) |>
  summarise(
    median_math = median(math_z, na.rm = TRUE),
    median_ela  = median(ela_z, na.rm = TRUE),
    .groups = "drop"
  ) |>
  pivot_longer(cols = c(median_math, median_ela), names_to = "subject", values_to = "median_score")

ggplot(income_avg, aes(x = income_group, y = median_score, fill = subject)) +
  geom_col(position = "dodge") +
  labs(
    title = "Income Group Affects Math and ELA Test Scores",
    x = "Income Group",
    y = "Median Z-Score",
    fill = "Subject"
  ) +
  scale_fill_discrete(labels = c("ELA", "Math")) +
  theme_minimal()

lunch_long <- merged_data |>
  select(income_group, per_free_lunch, per_reduced_lunch) |>
  pivot_longer(cols = c(per_free_lunch, per_reduced_lunch), 
               names_to = "lunch_type", values_to = "percent")

ggplot(lunch_long, aes(x = income_group, y = percent, fill = lunch_type)) +
  geom_boxplot() +
  labs(
    title = "Free and Reduced Lunch Percentages by Income Group",
    x = "Income Group",
    y = "Percent of Students",
    fill = "Lunch Type"
  ) +
  scale_fill_discrete(labels = c("Free Lunch", "Reduced Lunch")) +
  theme_minimal()
