library(tidyverse)

merged <- read_csv("data/processed/merged.csv")

county <- merged |>
  group_by(county_name) |>
  summarize(
    total_enroll = sum(total_enroll),
    math = mean(math_z),
    ela = mean(ela_z),
    poverty = mean(county_per_poverty),
    free_lunch = mean(per_free_lunch)
  ) |>
  arrange(desc(poverty))

write_csv(county, "data/processed/county.csv")