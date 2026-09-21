library(tidyverse)

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
trends <- read_csv("outputs/tables/poverty_group_trends.csv", show_col_types = FALSE) |>
  mutate(poverty_group = factor(poverty_group, c("low", "medium", "high")))
schools <- read_csv("data/processed/schools_merged.csv",
                    col_types = cols(school_cd = col_character()),
                    show_col_types = FALSE) |>
  filter(!is.na(county_per_poverty)) |>
  mutate(lunch_share = per_free_lunch + per_reduced_lunch,
         poverty_group = factor(poverty_group, c("low", "medium", "high")))
latest_year <- max(trends$year)
colors <- c(low = "blue", medium = "yellow", high = "red")
theme_set(theme_minimal(base_size = 12))

# Keep the same score definition in the snapshot and time-series plots.
long_trends <- trends |>
  pivot_longer(c(ela_z, math_z), names_to = "subject", values_to = "score_z") |>
  mutate(subject = recode(subject, ela_z = "ELA", math_z = "Math"))

p_groups <- long_trends |>
  filter(year == latest_year) |>
  ggplot(aes(poverty_group, score_z, fill = poverty_group)) +
  geom_hline(yintercept = 0, color = "grey60") +
  geom_col(width = 0.6) +
  facet_wrap(~subject) +
  scale_fill_manual(values = colors, guide = "none") +
  labs(title = "High-poverty counties have lower average relative scores",
       subtitle = paste(latest_year, "| Equal weight per county; school means within counties"),
       x = "County poverty group", y = "Mean annual score (z-score)",
       caption = "Zero is the statewide school mean used in annual standardization.\nSource: supplied NYS school and ACS files.")

p_trend <- long_trends |>
  ggplot(aes(year, score_z, color = poverty_group)) +
  geom_hline(yintercept = 0, color = "grey80") +
  geom_line(linewidth = 0.9) + geom_point(size = 1.7) +
  facet_wrap(~subject) +
  scale_color_manual(values = colors, name = "County poverty") +
  scale_x_continuous(breaks = sort(unique(trends$year))) +
  labs(title = "Relative achievement gaps persist across the observed years",
       subtitle = "Equal weight per county; poverty groups are reassigned each year",
       x = NULL, y = "Mean annual score (z-score)",
       caption = "Year-specific z-scores measure relative standing, not absolute learning gains.") +
  theme(legend.position = "bottom")

# Plot complete school-level pairs. Straight lines summarize associations;
# they are not a causal estimate or a formal test of moderation.
lunch_long <- schools |>
  filter(year == latest_year) |>
  pivot_longer(c(ela_z, math_z), names_to = "subject", values_to = "score_z") |>
  filter(!is.na(lunch_share), !is.na(score_z)) |>
  mutate(subject = recode(subject, ela_z = "ELA", math_z = "Math"))
p_lunch <- lunch_long |>
  ggplot(aes(lunch_share, score_z, color = poverty_group)) +
  geom_point(alpha = 0.12, size = 0.8) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 0.9) +
  facet_grid(subject ~ poverty_group) +
  scale_color_manual(values = colors, guide = "none") +
  scale_x_continuous(labels = scales::label_percent(), breaks = c(0, 0.5, 1)) +
  labs(title = "Higher lunch eligibility generally accompanies lower scores",
       subtitle = paste(latest_year, "| Each point is a school; lines show descriptive linear fits"),
       x = "Students eligible for free or reduced-price lunch", y = "Annual score (z-score)",
       caption = "Eligibility is not meal participation. These associations do not measure program effects.")

ggsave("outputs/figures/poverty_groups.png", p_groups, width = 10, height = 5.5, dpi = 160)
ggsave("outputs/figures/poverty_trends.png", p_trend, width = 10, height = 5.5, dpi = 160)
ggsave("outputs/figures/lunch_scores.png", p_lunch, width = 11, height = 7, dpi = 160)
