library(tidyverse)
library(dplyr)
school <- read.csv("data/processed/school_cleand.csv")
acs <- read.csv("data/processed/acs_cleand.csv")

cuts <- acs |>
  distinct(county_name, county_per_poverty) |>
  pull(county_per_poverty) |>
  quantile(probs = c(0, 1/3, 2/3, 1), na.rm = TRUE)

acs <- acs |>
  mutate(
    poverty_group = cut(
      county_per_poverty,
      breaks = cuts,
      labels = c("low", "medium", "high"),
      include.lowest = TRUE
    )
  )

library(dplyr)

school <- school |>
  group_by(year) |>
  mutate(
    math_z_score = as.numeric(scale(mean_math_score)),
    ela_z_score  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()


joined <- left_join(school,acs, by = c("county_name", "year"))
write.csv(joined, "data/processed/joined.csv")



