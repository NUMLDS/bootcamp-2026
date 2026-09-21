# 4_plot.R
# Task 6: create two figures outlined in the project instruction.
library(tidyverse)

dir.create("output/figures", showWarnings = FALSE, recursive = TRUE)

merged <- read_csv("data/processed/nys_merged.csv", show_col_types = FALSE) |>
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high")))

theme_set(theme_minimal(base_size = 12))

# Plot 1: lunch access vs performance, at the school level
p1 <- merged |>
  filter(!is.na(per_free_reduced), !is.na(mean_ela_score_z)) |>
  ggplot(aes(per_free_reduced, mean_ela_score_z)) +
  # 33k points, so small + transparent keeps the dense middle readable
  # instead of collapsing into one black mass.
  geom_point(alpha = 0.06, size = 0.4) +
  geom_smooth(method = "lm", se = FALSE, colour = "#b2182b") +
  scale_x_continuous(labels = scales::percent) +
  # A few schools sit beyond +/-4 SDs and stretch the axis until the real
  # pattern flattens. coord_cartesian clips the VIEW without dropping rows,
  # so the fitted line still uses every school.
  coord_cartesian(ylim = c(-4, 4)) +
  labs(
    title    = "Schools where more students need lunch assistance score lower",
    subtitle = "Each point is one school in one year, 2008-2017. Scores standardized within year.",
    x        = "Students qualifying for free or reduced-price lunch",
    y        = "Mean ELA score (SDs from that year's state average)",
    caption  = "Source: NYS Education Department. 48 schools beyond +/-4 SDs (0.1%) fall outside the view."
  )

# Plot 2: average performance by county poverty group ------------------------
# Both subjects side by side, since the department asked about test performance
# generally and the two tell the same story.
p2 <- merged |>
  filter(!is.na(poverty_group)) |>
  group_by(poverty_group) |>
  summarise(ELA = mean(mean_ela_score_z,  na.rm = TRUE),
            Math = mean(mean_math_score_z, na.rm = TRUE),
            .groups = "drop") |>
  pivot_longer(c(ELA, Math), names_to = "subject", values_to = "mean_z") |>
  ggplot(aes(poverty_group, mean_z, fill = subject)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  # Label the bars so a non-technical reader doesn't have to measure them.
  # vjust flips by sign, or labels on the negative bars land inside them.
  geom_text(aes(label = sprintf("%+.2f", mean_z),
                vjust = if_else(mean_z >= 0, -0.4, 1.3)),
            position = position_dodge(width = 0.8), size = 3.2) +
  geom_hline(yintercept = 0, colour = "grey30") +
  scale_fill_manual(values = c(ELA = "#2166ac", Math = "#67a9cf")) +
  scale_x_discrete(labels = c(low = "Low poverty", medium = "Medium", high = "High poverty")) +
  labs(
    title    = "Schools in high-poverty counties trail low-poverty counties by two thirds of an SD",
    subtitle = "Mean standardized score by county poverty tier, 2009-2016. Zero is the state average.",
    x        = NULL,
    y        = "Mean score (SDs from state average)",
    fill     = NULL,
    caption  = "Sources: NYS Education Department, American Community Survey.
Counties split into terciles of poverty rate."
  )

walk2(list(p1, p2), c("1_lunch_vs_score", "2_performance_by_poverty"),
      ~ ggsave(paste0("output/figures/", .y, ".png"), .x, width = 8, height = 5, dpi = 150))
