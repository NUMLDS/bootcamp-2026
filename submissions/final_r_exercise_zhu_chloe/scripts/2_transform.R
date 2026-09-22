library(tidyverse)

# Read cleaned data
schools_clean <- read_csv("data/processed/nys_schools_clean.csv")
nys_acs <- read_csv("data/raw/nys_acs.csv")

# Create a categorical variable
summary(nys_acs$county_per_poverty)
quantile(
  nys_acs$county_per_poverty,
  probs = c(0, 1/3, 2/3, 1)
)

# Explore the distribution of county poverty rates
ggplot(nys_acs, aes(x = county_per_poverty)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Distribution of County Poverty Rates",
    x = "County Poverty Rate",
    y = "Count"
  ) +
  theme_minimal()

# Define poverty cutoffs using tertiles
poverty_cutoffs <- quantile(
  nys_acs$county_per_poverty,
  probs = c(1/3, 2/3)
)
#前 33.33% 的分界点cutoff= 11.66%，前 66.67% 的分界点cutoff= 14.39%
poverty_cutoffs

acs_transformed <- nys_acs |>
  mutate(
    poverty_group = case_when(
      county_per_poverty <= poverty_cutoffs[1] ~ "Low",
      county_per_poverty <= poverty_cutoffs[2] ~ "Medium",
      TRUE ~ "High"
    )
  )
count(acs_transformed, poverty_group)
glimpse(acs_transformed)

# Standardize test scores within each year
schools_transformed <- schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()# Remove grouping after calculating z-scores

# Save processed datasets
write_csv(
  schools_transformed,
  "data/processed/nys_schools_processed.csv"
)

write_csv(
  acs_transformed,
  "data/processed/nys_acs_processed.csv"
)

# Check processed data
head(schools_transformed)
head(acs_transformed)