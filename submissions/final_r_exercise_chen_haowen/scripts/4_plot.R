# ---------------------------------------------------------------------------
# 4_plot.R
# Task 6: Visualizations
#
# Expects `nys_merged` from scripts/2_transform.R.
# Saves figures to output/.
# ---------------------------------------------------------------------------

library(tidyverse)

dir.create("output", showWarnings = FALSE, recursive = TRUE)

# ===========================================================================
# Shared setup
# ===========================================================================
# overall_z: math_z and ela_z averaged into one performance measure. Test
# performance and lunch access are each reported as two separate numbers
# (math/ela; free/reduced) -- averaging math_z + ela_z keeps each chart to a
# single y-axis ("test performance") instead of forcing two lines/panels
# onto one plot, which is the simpler, more readable choice for a
# department-facing chart.
plot_data <- nys_merged %>%
  mutate(
    overall_z        = (math_z + ela_z) / 2,
    pct_free_reduced = per_free_lunch + per_reduced_lunch
  )

# A small shared theme: light hairline gridlines, muted axis text, no
# vertical gridlines (categorical x-axes don't need them), title left-
# aligned and bold so the takeaway reads first.
theme_dept <- theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_text(face = "bold", size = 14, color = "#0b0b0b"),
    plot.subtitle    = element_text(color = "#52514e", margin = margin(b = 10)),
    axis.title       = element_text(color = "#52514e"),
    axis.text        = element_text(color = "#898781"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#e1e0d9"),
    legend.title      = element_text(color = "#52514e"),
    legend.position   = "top"
  )

# Ordinal 3-step blue ramp (light -> dark = low -> high poverty): poverty
# group is an *ordered* category, not an unordered one, so a single-hue
# sequential ramp is used rather than 3 unrelated categorical colors --
# darker reads naturally as "more poverty".
poverty_ramp <- c(low = "#86b6ef", medium = "#2a78d6", high = "#104281")

# ===========================================================================
# Plot 1 (Task 6.1): free/reduced lunch access vs. test performance,
# at the school level
# ===========================================================================
# cor(pct_free_reduced, overall_z) ~ -0.65 across all school-years -- a
# fairly strong negative relationship, so the headline below states that
# directly rather than hedging.
# 42 rows have per_free_lunch + per_reduced_lunch > 1 even though each
# individual column is <= 1 (up to 186% combined) -- a data-quality issue
# distinct from the single-column one handled in 1_clean.R. These are
# excluded from this plot only (not from the saved processed data) so the
# x-axis doesn't run past 100%.
p1_lunch_vs_performance <- plot_data %>%
  filter(!is.na(pct_free_reduced), !is.na(overall_z), pct_free_reduced <= 1) %>%
  ggplot(aes(x = pct_free_reduced, y = overall_z)) +
  geom_point(alpha = 0.05, color = "#2a78d6", size = 0.6) +
  geom_smooth(method = "lm", color = "#eb6834", se = TRUE, linewidth = 1) +
  scale_x_continuous(labels = scales::percent) +
  labs(
    title    = "Schools with more students on free/reduced lunch score lower",
    subtitle = "Each point is one school-year; line is a linear fit (r ≈ -0.65)",
    x        = "% of students on free or reduced-price lunch",
    y        = "Test performance (avg. of math/ELA z-scores)"
  ) +
  theme_dept

ggsave(file.path("output", "lunch_vs_performance.png"), p1_lunch_vs_performance,
       width = 8, height = 5, dpi = 150)

# ===========================================================================
# Plot 2 (Task 6.2): average test performance by county poverty group
# ===========================================================================
# Bar heights below (low 0.36 / medium -0.02 / high -0.25) step down
# monotonically from low to high poverty, so "step down" in the title is a
# direct read of the numbers, not a rhetorical flourish.
p2_performance_by_poverty <- plot_data %>%
  filter(!is.na(poverty_group)) %>%
  group_by(poverty_group) %>%
  summarise(avg_z = mean(overall_z, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = poverty_group, y = avg_z, fill = poverty_group)) +
  geom_col(width = 0.6) +
  geom_hline(yintercept = 0, color = "#c3c2b7") +
  scale_fill_manual(values = poverty_ramp, guide = "none") +
  labs(
    title    = "Test performance steps down from low- to high-poverty counties",
    subtitle = "Average school performance by county poverty tertile (all years pooled)",
    x        = "County poverty group",
    y        = "Test performance (avg. of math/ELA z-scores)"
  ) +
  theme_dept

ggsave(file.path("output", "performance_by_poverty_group.png"), p2_performance_by_poverty,
       width = 7, height = 5, dpi = 150)

# ===========================================================================
# Plot 3 (bonus): has the poverty/performance gap changed over time?
# ===========================================================================
# Directly answers the department's second follow-up question. The low- and
# high-poverty lines move slightly closer together over 2009-2016 (low group
# drifts down from ~0.43 to ~0.27; high group drifts up from ~-0.40 to
# ~-0.20), so the gap narrows somewhat rather than staying flat or widening.
p3_trend_by_poverty <- plot_data %>%
  filter(!is.na(poverty_group)) %>%
  group_by(year, poverty_group) %>%
  summarise(avg_z = mean(overall_z, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = year, y = avg_z, color = poverty_group)) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.8) +
  scale_color_manual(values = poverty_ramp, name = "Poverty group") +
  labs(
    title    = "The poverty/performance gap narrows slightly, but doesn't close",
    subtitle = "Average test performance by county poverty group, 2009–2016",
    x        = NULL,
    y        = "Test performance (avg. of math/ELA z-scores)"
  ) +
  theme_dept

ggsave(file.path("output", "performance_trend_by_poverty.png"), p3_trend_by_poverty,
       width = 8, height = 5, dpi = 150)

message("Saved 3 figures to output/")
