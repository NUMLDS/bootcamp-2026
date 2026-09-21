# ============================================================
# MLDS Final R Exercise
# Script 4: Data visualization
# ============================================================

library(tidyverse)


# ------------------------------------------------------------
# 1. LOAD MERGED DATA
# ------------------------------------------------------------

data <- read_csv("Data/processed/nys_merged.csv") |>
  mutate(
    # Combine free and reduced-price lunch
    per_free_reduced_lunch = per_free_lunch + per_reduced_lunch,
    
    # Order poverty groups logically
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high")
    )
  )


# ------------------------------------------------------------
# 2. MATH PERFORMANCE BY POVERTY GROUP
# ------------------------------------------------------------

poverty_plot_data <- data |>
  group_by(poverty_group) |>
  summarise(
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )


poverty_plot <- ggplot(
  poverty_plot_data,
  aes(x = poverty_group, y = mean_math_z)
) +
  geom_col() +
  labs(
    title = "Math performance declines as county poverty increases",
    subtitle = "Average standardized math score by county poverty group",
    x = "County poverty group",
    y = "Average math z-score"
  ) +
  theme_minimal()

poverty_plot


# ------------------------------------------------------------
# 3. FREE / REDUCED LUNCH VS MATH PERFORMANCE
# ------------------------------------------------------------

lunch_plot <- ggplot(
  data,
  aes(
    x = per_free_reduced_lunch,
    y = math_z
  )
) +
  geom_point(alpha = 0.2) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  labs(
    title = "Lunch assistance is associated with lower math performance",
    subtitle = "School-level standardized math scores",
    x = "Proportion receiving free/reduced-price lunch",
    y = "Math z-score"
  ) +
  theme_minimal()

lunch_plot


# ------------------------------------------------------------
# 4. POVERTY AND TEST PERFORMANCE OVER TIME
# ------------------------------------------------------------

time_plot_data <- data |>
  group_by(year, poverty_group) |>
  summarise(
    mean_math_z = mean(math_z, na.rm = TRUE),
    .groups = "drop"
  )


time_plot <- ggplot(
  time_plot_data,
  aes(
    x = year,
    y = mean_math_z,
    color = poverty_group
  )
) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    title = "Math performance gaps by poverty group persist over time",
    subtitle = "Average standardized math score by year",
    x = "Year",
    y = "Average math z-score",
    color = "Poverty group"
  ) +
  theme_minimal()

time_plot


# ------------------------------------------------------------
# 5. ELA PERFORMANCE BY POVERTY GROUP
# ------------------------------------------------------------

ela_plot_data <- data |>
  group_by(poverty_group) |>
  summarise(
    mean_ela_z = mean(ela_z, na.rm = TRUE),
    .groups = "drop"
  )


ela_plot <- ggplot(
  ela_plot_data,
  aes(
    x = poverty_group,
    y = mean_ela_z
  )
) +
  geom_col() +
  labs(
    title = "ELA performance declines as county poverty increases",
    subtitle = "Average standardized ELA score by county poverty group",
    x = "County poverty group",
    y = "Average ELA z-score"
  ) +
  theme_minimal()

ela_plot


# ------------------------------------------------------------
# 6. SAVE PLOTS
# ------------------------------------------------------------

ggsave(
  "Data/processed/poverty_math.png",
  poverty_plot,
  width = 8,
  height = 5
)

ggsave(
  "Data/processed/lunch_math.png",
  lunch_plot,
  width = 8,
  height = 5
)

ggsave(
  "Data/processed/poverty_over_time.png",
  time_plot,
  width = 8,
  height = 5
)

ggsave(
  "Data/processed/poverty_ela.png",
  ela_plot,
  width = 8,
  height = 5
)