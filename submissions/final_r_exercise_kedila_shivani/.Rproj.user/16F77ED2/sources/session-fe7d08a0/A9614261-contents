library(dplyr)

county_summary <- schools_joined |>
  group_by(county_name) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    pct_free_reduced_lunch = mean(per_free_lunch + per_reduced_lunch, na.rm = TRUE),
    pct_poverty = mean(county_per_poverty, na.rm = TRUE)
  ) |>
  mutate(
    pct_free_reduced_lunch = if_else(pct_free_reduced_lunch > 1, NA_real_, pct_free_reduced_lunch)
  )
  arrange(desc(pct_poverty))

county_summary

# First, get one poverty value per county (averaged across years) to rank on
county_poverty_rank <- schools_joined |>
  group_by(county_name) |>
  summarise(pct_poverty = mean(county_per_poverty, na.rm = TRUE)) |>
  filter(!is.na(pct_poverty)) |>
  arrange(desc(pct_poverty))

top5_counties <- head(county_poverty_rank, 5)$county_name
bottom5_counties <- tail(county_poverty_rank, 5)$county_name

top_bottom_summary <- schools_joined |>
  filter(county_name %in% c(top5_counties, bottom5_counties)) |>
  group_by(county_name) |>
  summarise(
    pct_poverty = mean(county_per_poverty, na.rm = TRUE),
    pct_free_reduced_lunch = mean(per_free_lunch + per_reduced_lunch, na.rm = TRUE),
    mean_reading_score = mean(mean_ela_score, na.rm = TRUE),
    mean_math_score = mean(mean_math_score, na.rm = TRUE)
  ) |>
  mutate(poverty_rank = if_else(county_name %in% top5_counties, "Top 5", "Bottom 5")) |>
  arrange(desc(pct_poverty))

top_bottom_summary


# 1.Free/reduced lunch access vs. test performance (school level)
library(ggplot2)
library(dplyr)
library(ggthemes)

school_level <- schools_joined |>
  mutate(
    pct_free_reduced = per_free_lunch + per_reduced_lunch,
    pct_free_reduced = if_else(pct_free_reduced > 1, NA_real_, pct_free_reduced)
  )

ggplot(school_level, aes(x = pct_free_reduced, y = math_z)) +
  geom_point(alpha = 0.3, color = "#2c5f8a") +
  geom_smooth(method = "lm", color = "firebrick", se = FALSE, linewidth = 1) +
  labs(
    title = "Schools With Low-Income Students Score Lower on Math",
    subtitle = "Each point is one school; math score standardized by year",
    x = "% Students Qualifying for Free/Reduced Lunch",
    y = "Math Score (Standardized, by Year)"
  ) +
  theme_wsj(base_size = 10) +
  theme(
    axis.title = element_text(size = 11, face = "bold"),
    plot.title = element_text(size = 15)
  )


library(ggplot2)
library(dplyr)
library(tidyr)
library(ggthemes)

school_level_long <- schools_joined |>
  mutate(
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  ) |>
  select(school_cd, year, math_z, per_free_lunch, per_reduced_lunch) |>
  pivot_longer(
    cols = c(per_free_lunch, per_reduced_lunch),
    names_to = "lunch_type",
    values_to = "pct"
  ) |>
  mutate(
    lunch_type = recode(lunch_type,
                        per_free_lunch = "Free Lunch",
                        per_reduced_lunch = "Reduced Lunch"
    )
  )

ggplot(school_level_long, aes(x = pct, y = math_z, color = lunch_type)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.2) +
  scale_color_manual(values = c("Free Lunch" = "#2c5f8a", "Reduced Lunch" = "#e07b39")) +
  labs(
    title = "Free Lunch Has a Stronger Link to Lower Math Scores Than Reduced Lunch",
    subtitle = "Each point is one school-year; math score standardized by year",
    x = "% Students Qualifying", y = "Math Score (Standardized, by Year)",
    color = NULL
  ) +
  theme_wsj(base_size = 10) +
  theme(
    axis.title = element_text(size = 11, face = "bold"),
    plot.title = element_text(size = 14),
    legend.position = "bottom"
  )

