library(tidyverse)

merged <- read_csv("data/processed/schools_acs_merged.csv")

merged |>
  mutate(per_free_reduced = per_free_lunch + per_reduced_lunch) |>
  ggplot(aes(x = per_free_reduced, y = z_math)) +
  geom_point(alpha = 0.2, color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    x = "Share of students on free/reduced lunch",
    y = "Math score (z-score within year)",
    title = "Schools with More Free/Reduced Lunch Score Lower in Math"
  ) +
  theme_minimal()

ggsave("plot_lunch_vs_math.png", width = 7, height = 5)

merged |>
  filter(!is.na(poverty_group)) |>
  group_by(poverty_group) |>
  summarize(avg_z_math = mean(z_math, na.rm = TRUE)) |>
  ggplot(aes(x = poverty_group, y = avg_z_math)) +
  geom_col(fill = "blue") +
  labs(
    x = "County poverty group",
    y = "Average math score (z-score)",
    title = "Higher-Poverty Counties Have Lower Average Test Scores"
  ) +
  theme_minimal()

ggsave("plot_poverty_group.png", width = 7, height = 5)
