library(tidyverse)

dat <- read_csv("data/processed/nys_schools_acs.csv")

# Prepare data for plot 1
dat_plot <- dat |>
  pivot_longer(
    cols = c(ela_z, math_z),
    names_to = "subject",
    values_to = "z_score"
  ) |>
  mutate(
    subject = recode(
      subject,
      ela_z = "ELA",
      math_z = "Math"
    )
  )
# Plot 1
p1 <- ggplot(
  dat_plot,
  aes(x = per_free_reduced, y = z_score)
) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ subject) +
  scale_x_continuous(
    labels = scales::label_percent()
  ) +
  labs(
    title = "Higher Lunch Assistance Is Associated with Lower Test Performance",
    x = "Students Receiving Free or Reduced-Price Lunch",
    y = "Standardized Test Score"
  ) +
  theme_minimal()

p1

print(p1)


library(tidyverse)

# Import merged dataset
dat <- read_csv(
  "data/processed/nys_schools_acs.csv",
  show_col_types = FALSE
)

# ---------------------------------------------------------
# Average test performance at the county level
# ---------------------------------------------------------

county_performance <- dat |>
  group_by(county_name, year, poverty_group) |>
  summarize(
    avg_ela_z = weighted.mean(
      ela_z,
      w = total_enroll,
      na.rm = TRUE
    ),
    avg_math_z = weighted.mean(
      math_z,
      w = total_enroll,
      na.rm = TRUE
    ),
    .groups = "drop"
  )

# ---------------------------------------------------------
# Average performance across poverty groups
# ---------------------------------------------------------

poverty_performance <- county_performance |>
  group_by(poverty_group) |>
  summarize(
    avg_ela_z = mean(avg_ela_z, na.rm = TRUE),
    avg_math_z = mean(avg_math_z, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    poverty_group = factor(
      poverty_group,
      levels = c("low", "medium", "high")
    )
  )

print(poverty_performance)