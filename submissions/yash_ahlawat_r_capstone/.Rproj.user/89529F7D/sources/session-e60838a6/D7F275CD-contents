library(tidyverse)

#import data
nys_acs_clean <- read_csv("data/processed/nys_acs_clean.csv")
nys_schools_clean <- read_csv("data/processed/nys_schools_clean.csv")

#Creating poverty group
summary(nys_acs_clean$county_per_poverty)
quantile(nys_acs_clean$county_per_poverty, probs = c(.33, .67), na.rm = TRUE)
ggplot(nys_acs_clean, aes(county_per_poverty)) + geom_histogram(bins = 30)

nys_acs_clean <- nys_acs_clean |>
  mutate(
    poverty_grp = case_when(
      county_per_poverty < 0.2 ~ "Low",
      county_per_poverty < 0.25 ~ "Medium",
      county_per_poverty >= 0.25 ~ "High",
      .default = NA_character_
    )
  )

nys_schools_clean <- nys_schools_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

#Merge datasets
merged <- left_join(nys_acs_clean, nys_schools_clean, by = c("county_name", "year"))

#Saving merged data
write_csv(merged, "data/processed/nys_acs_school_final.csv")

