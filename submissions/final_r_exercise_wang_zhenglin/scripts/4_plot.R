library('tidyverse')

data_2016 = school_data |>
  filter(year == 2016) |>
  mutate(lunch_pct = 100 * (per_free_lunch + per_reduced_lunch))

# 1. Each point is a school
ggplot(data_2016) +
  geom_point(aes(x = lunch_pct, y = math_z), 
             alpha = 0.8, cex = 0.5) +
  labs(
    title = "Math scores and lunch eligibility in 2016",
    x = "Students eligible for free or reduced lunch (%)",
    y = "Math score (z-score)"
  ) +
  theme_minimal()

# 2. Average schools within counties, then counties within poverty groups
group_scores = data_2016 |>
  group_by(county_name, poverty_group) |>
  summarize(math_z = mean(math_z, na.rm = TRUE)) |>
  group_by(poverty_group) |>
  summarize(math_z = mean(math_z, na.rm = TRUE))

ggplot(group_scores) +
  geom_col(aes(x = poverty_group, y = math_z), 
           fill = "steelblue") +
  labs(
    title = "Average math scores by county poverty group",
    x = "County poverty group",
    y = "Average math score (z-score)"
  ) +
  theme_minimal()
