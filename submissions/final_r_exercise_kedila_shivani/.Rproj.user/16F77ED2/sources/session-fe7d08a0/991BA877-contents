library(dplyr)
library(ggplot2)

# Step 1: Look at the distribution first
ggplot(acs_clean, aes(x = county_per_poverty)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "white") +
  labs(
    title = "Distribution of County Poverty Rates",
    x = "Poverty Rate", y = "Count"
  ) +
  theme_minimal()

# Step 2: Create the categorical variable
acs_clean <- acs_clean |>
  mutate(
    poverty_group = case_when(
      county_per_poverty < 0.2 ~ "low",
      county_per_poverty < 0.25 ~ "medium",
      TRUE ~ "high"
    ),
    poverty_group = factor(poverty_group, levels = c("low", "medium", "high"))
  )

schools_clean <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

schools_joined <- schools_clean |>
  left_join(acs_clean, by = c("county_name", "year"))
  
# Save Cleaned DFs
write_csv(schools_joined, "data/processed/schools_joined.csv")
