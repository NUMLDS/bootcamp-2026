library(tidyverse)

# Read the merged school and ACS dataset
merged_data <- read_csv(
  "data/processed/nys_merged.csv"
)


# --------------------------------------------------
# Plot 1: Lunch assistance and math performance
# --------------------------------------------------

# Combine free and reduced-price lunch rates
# Values above 1 (100%) are treated as invalid
plot_data <- merged_data |>
  mutate(
    lunch_rate = per_free_lunch + per_reduced_lunch,
    lunch_rate = if_else(
      lunch_rate <= 1,
      lunch_rate,
      NA_real_
    )
  )

# Check the distribution of the calculated lunch rate
summary(plot_data$lunch_rate)


# Create a school-level scatter plot
ggplot(
  plot_data,
  aes(x = lunch_rate, y = math_z)
) +
  geom_point(alpha = 0.2) +  # Make overlapping points more visible
  geom_smooth(method = "lm", se = FALSE) +  # Add a linear trend line
  scale_x_continuous(
    labels = scales::label_percent()
  ) +  # Display lunch rate as percentages
  labs(
    title = "Schools with Higher Lunch Assistance Rates Tend to Have Lower Math Performance",
    x = "Students Qualifying for Free/Reduced-Price Lunch",
    y = "Standardized Math Score"
  ) +
  theme_minimal()


# --------------------------------------------------
# Plot 2: Poverty level and test performance
# --------------------------------------------------

# Calculate average Math and ELA performance
# for each poverty group
poverty_performance <- merged_data |>
  filter(!is.na(poverty_group)) |>  # Remove observations without poverty information
  group_by(poverty_group) |>
  summarize(
    avg_math_z = mean(math_z, na.rm = TRUE),
    avg_ela_z = mean(ela_z, na.rm = TRUE),
    .groups = "drop"
  )

# Check the summarized results
poverty_performance


# Reshape the data from wide to long format
# so Math and ELA can be plotted as separate bars
poverty_plot_data <- poverty_performance |>
  pivot_longer(
    cols = c(avg_math_z, avg_ela_z),
    names_to = "subject",
    values_to = "score"
  )


# Rename subjects and order poverty groups
poverty_plot_data <- poverty_plot_data |>
  mutate(
    subject = case_when(
      subject == "avg_math_z" ~ "Math",
      subject == "avg_ela_z" ~ "ELA"
    ),
    poverty_group = factor(
      poverty_group,
      levels = c("Low", "Medium", "High")
    )
  )


# Create a grouped bar chart comparing test performance
# across low-, medium-, and high-poverty counties
ggplot(
  poverty_plot_data,
  aes(
    x = poverty_group,
    y = score,
    fill = subject
  )
) +
  geom_col(position = "dodge") +  # Place Math and ELA bars side by side
  labs(
    title = "Test Performance Declines as County Poverty Increases",
    x = "County Poverty Group",
    y = "Average Standardized Test Score",
    fill = "Subject"
  ) +
  theme_minimal()
