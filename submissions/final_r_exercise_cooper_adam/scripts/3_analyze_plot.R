library(tidyverse)

schools <- read_csv("data/processed/transformed_schools.csv")

plot_data <- schools |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high"),
      ordered = TRUE
    )
  ) |>
  pivot_longer(
    cols = c(math_z, ela_z),
    names_to = "subject",
    values_to = "score_z"
  ) |>
  mutate(
    subject = recode(
      subject,
      math_z = "Math",
      ela_z = "ELA"
    )
  )

poverty_score_plot <- ggplot(
  plot_data,
  aes(
    x = poverty_group,
    y = score_z,
    fill = poverty_group
  )
) +
  geom_boxplot(
    alpha = 0.8,
    outlier.alpha = 0.15
  ) +
  facet_wrap(~subject) +
  labs(
    title = "Test performance differs across county poverty groups",
    subtitle = "School scores are standardized within each testing year",
    x = "County poverty group",
    y = "Standardized test score",
    fill = "Poverty group"
  ) +
  scale_fill_manual(
    values = c(
      "low" = "#2E86AB",
      "medium" = "#F6AE2D",
      "high" = "#D1495B"
    )
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

poverty_score_plot