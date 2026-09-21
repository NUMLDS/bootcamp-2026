### Task 6: Data visualizations
# Three charts for the department, each built around one takeaway rather
# than a neutral description of the axes (per Session 5).

library(tidyverse)
library(scales)

nys <- read_csv(
  "data/processed/nys_schools_acs_cleaned.csv",
  show_col_types = FALSE
)

fig_dir <- "data/processed/figures"
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

## ---------------------------------------------------------------------
## Shared theme + palette (one hue per role, not decorative color)
## ---------------------------------------------------------------------
ink_secondary <- "#52514e"
ink_muted <- "#898781"
grid_line <- "#e1e0d9"
blue <- "#2a78d6"     # single relationship / "low poverty" pole
orange <- "#eb6834"   # trend line / contrast series
red <- "#e34948"      # "high poverty" pole (blue<->red diverging pair)
seq_low <- "#86b6ef"  # ordinal ramp, light -> dark blue
seq_med <- "#2a78d6"
seq_high <- "#104281"

theme_capstone <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", size = rel(1.2), margin = margin(b = 4), lineheight = 1.1),
      plot.subtitle = element_text(color = ink_secondary, size = rel(0.95), margin = margin(b = 12)),
      plot.caption = element_text(color = ink_muted, size = rel(0.75), hjust = 0, margin = margin(t = 10)),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = grid_line, linewidth = 0.3),
      axis.title = element_text(color = ink_secondary, size = rel(0.9)),
      axis.text = element_text(color = ink_secondary),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text = element_text(color = ink_secondary)
    )
}

## ---------------------------------------------------------------------
## Chart 1: school-level lunch access vs. test performance
## ---------------------------------------------------------------------
school_level <- nys %>%
  mutate(pct_free_reduced_lunch = per_free_lunch + per_reduced_lunch) %>%
  filter(!is.na(pct_free_reduced_lunch), !is.na(z_math))

lunch_cor <- cor(school_level$pct_free_reduced_lunch, school_level$z_math, use = "complete.obs")

p1 <- ggplot(school_level, aes(x = pct_free_reduced_lunch, y = z_math)) +
  geom_point(color = blue, alpha = 0.12, size = 1) +
  geom_smooth(method = "lm", color = orange, se = FALSE, linewidth = 1.1) +
  annotate(
    "text", x = 0.05, y = max(school_level$z_math, na.rm = TRUE) - 0.3,
    label = paste0("r = ", round(lunch_cor, 2)),
    hjust = 0, color = ink_secondary, fontface = "italic", size = 3.6
  ) +
  scale_x_continuous(labels = label_percent()) +
  labs(
    title = "Schools with more low-income students score lower on state tests",
    subtitle = "Each dot is one school-year; math score is standardized within year (z-score)",
    x = "Students qualifying for free or reduced-price lunch",
    y = "Math z-score (standardized within year)",
    caption = "Source: NYS Department of Education school data, 2008–2017. n = 33,439 school-years."
  ) +
  theme_capstone()

ggsave(file.path(fig_dir, "1_lunch_access_vs_performance.png"), p1, width = 8, height = 5.5, dpi = 300)

## ---------------------------------------------------------------------
## Chart 2: average test performance by county poverty level
## ---------------------------------------------------------------------
poverty_perf <- nys %>%
  filter(!is.na(poverty_group)) %>%
  mutate(avg_z = (z_math + z_ela) / 2) %>%
  group_by(poverty_group) %>%
  summarise(avg_z = mean(avg_z, na.rm = TRUE), .groups = "drop") %>%
  mutate(poverty_group = factor(poverty_group, levels = c("low", "medium", "high")))

p2 <- ggplot(poverty_perf, aes(x = poverty_group, y = avg_z, fill = poverty_group)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = number(avg_z, accuracy = 0.01)), vjust = -0.6, color = ink_secondary, size = 4) +
  scale_fill_manual(values = c(low = seq_low, medium = seq_med, high = seq_high), guide = "none") +
  scale_x_discrete(labels = c(low = "Low poverty", medium = "Medium poverty", high = "High poverty")) +
  scale_y_continuous(limits = c(min(poverty_perf$avg_z) - 0.15, max(poverty_perf$avg_z) + 0.15)) +
  labs(
    title = str_wrap("The test-score gap between low- and high-poverty counties is about half a standard deviation", 55),
    subtitle = "Average of standardized math and ELA scores, by county poverty tier (2009–2016)",
    x = NULL,
    y = "Average z-score (math + ELA)",
    caption = "Source: NYS Department of Education and American Community Survey.\nCounties grouped into terciles of percent of population in poverty."
  ) +
  theme_capstone()

ggsave(file.path(fig_dir, "2_performance_by_poverty_group.png"), p2, width = 7, height = 5.5, dpi = 300)

## ---------------------------------------------------------------------
## Chart 3: has the poverty gap changed over time?
## ---------------------------------------------------------------------
gap_over_time <- nys %>%
  filter(poverty_group %in% c("low", "high")) %>%
  mutate(avg_z = (z_math + z_ela) / 2) %>%
  group_by(year, poverty_group) %>%
  summarise(avg_z = mean(avg_z, na.rm = TRUE), .groups = "drop")

label_points <- gap_over_time %>% filter(year == max(year))

p3 <- ggplot(gap_over_time, aes(x = year, y = avg_z, color = poverty_group, group = poverty_group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_text(
    data = label_points,
    aes(label = str_to_title(poverty_group)),
    hjust = 0, nudge_x = 0.15, fontface = "bold", size = 4, show.legend = FALSE
  ) +
  scale_color_manual(values = c(low = blue, high = red), guide = "none") +
  scale_x_continuous(breaks = pretty_breaks(), limits = c(min(gap_over_time$year), max(gap_over_time$year) + 1.2)) +
  labs(
    title = "The poverty gap in test scores has narrowed since 2009",
    subtitle = "Average of standardized math and ELA scores, low- vs. high-poverty counties",
    x = "Year",
    y = "Average z-score (math + ELA)",
    caption = "Source: NYS Department of Education and American Community Survey, 2009–2016."
  ) +
  theme_capstone()

ggsave(file.path(fig_dir, "3_poverty_gap_over_time.png"), p3, width = 8, height = 5.5, dpi = 300)

print(paste("Correlation (lunch % vs math z-score):", round(lunch_cor, 3)))
print(poverty_perf)
print(gap_over_time)
