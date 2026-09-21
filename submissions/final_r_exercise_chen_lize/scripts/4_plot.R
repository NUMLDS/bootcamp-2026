library(tidyverse)

# Import data
data <- read_csv(
  "data/processed/nys_schools_acs_merged.csv",
  show_col_types = FALSE
)

poverty_year_summary <- read_csv(
  "data/processed/poverty_year_summary.csv",
  show_col_types = FALSE
)


# Plot 1: FRPL and ELA performance ----------------------------------------

ggplot(data, aes(x = per_frpl, y = ela_z)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Schools with Higher FRPL Rates Tend to Have Lower ELA Performance",
    x = "Proportion Eligible for Free or Reduced-Price Lunch",
    y = "Standardized ELA Score"
  ) +
  theme_minimal()


# Plot 2: FRPL and math performance ---------------------------------------

ggplot(data, aes(x = per_frpl, y = math_z)) +
  geom_point(alpha = 0.15) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Schools with Higher FRPL Rates Tend to Have Lower Math Performance",
    x = "Proportion Eligible for Free or Reduced-Price Lunch",
    y = "Standardized Math Score"
  ) +
  theme_minimal()


# Plot 3: ELA performance by poverty group --------------------------------

ggplot(data, aes(x = poverty_group, y = ela_z)) +
  stat_summary(
    fun = mean,
    geom = "col"
  ) +
  labs(
    title = "ELA Performance Is Lower in Higher-Poverty Counties",
    x = "County Poverty Group",
    y = "Mean Standardized ELA Score"
  ) +
  theme_minimal()


# Plot 4: Math performance by poverty group -------------------------------

ggplot(data, aes(x = poverty_group, y = math_z)) +
  stat_summary(
    fun = mean,
    geom = "col"
  ) +
  labs(
    title = "Math Performance Is Lower in Higher-Poverty Counties",
    x = "County Poverty Group",
    y = "Mean Standardized Math Score"
  ) +
  theme_minimal()


# Plot 5: ELA performance over time ---------------------------------------

ggplot(
  poverty_year_summary,
  aes(
    x = year,
    y = mean_ela_z,
    group = poverty_group,
    linetype = poverty_group
  )
) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    title = "ELA Performance Gaps by Poverty Group Persist Over Time",
    x = "Year",
    y = "Mean Standardized ELA Score",
    linetype = "Poverty Group"
  ) +
  theme_minimal()


# Plot 6: Math performance over time --------------------------------------

ggplot(
  poverty_year_summary,
  aes(
    x = year,
    y = mean_math_z,
    group = poverty_group,
    linetype = poverty_group
  )
) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    title = "Math Performance Gaps by Poverty Group Persist Over Time",
    x = "Year",
    y = "Mean Standardized Math Score",
    linetype = "Poverty Group"
  ) +
  theme_minimal()

# Histogram of county poverty rates
ggplot(data, aes(x = county_per_poverty)) +
  geom_histogram(
    binwidth = 0.01,
    boundary = 0
  ) +
  scale_x_continuous(
    labels = scales::label_percent()
  ) +
  labs(
    title = "Distribution of County Poverty Rates",
    x = "County Poverty Rate",
    y = "Number of School-Year Observations"
  ) +
  theme_minimal()

acs <- read_csv(
  "data/processed/nys_acs_clean.csv",
  show_col_types = FALSE
)

ggplot(acs, aes(x = county_per_poverty)) +
  geom_histogram(
    binwidth = 0.01,
    boundary = 0
  ) +
  scale_x_continuous(
    labels = scales::label_percent()
  ) +
  labs(
    title = "Distribution of Poverty Rates Across New York Counties",
    x = "County Poverty Rate",
    y = "Number of County-Year Observations"
  ) +
  theme_minimal()

