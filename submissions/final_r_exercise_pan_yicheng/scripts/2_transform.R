library(tidyverse)

schools <- read_csv(
  "data/processed/schools_clean.csv",
  col_types = cols(school_cd = col_character())
)

acs <- read_csv("data/processed/acs_clean.csv")

acs<-acs |>
  group_by(year) |>
  mutate(
    poverty_group=ntile(county_per_poverty, 3),
    poverty_group=factor(
      poverty_group,
      levels = c(1,2,3),
      labels = c("low", "medium", "high")
    )
  ) |>
  ungroup()
  

  

schools <- schools |>
  group_by(year) |>
  mutate(
    ela_z = as.numeric(scale(mean_ela_score)),
    math_z = as.numeric(scale(mean_math_score))
  ) |>
  ungroup()

schools |>
  group_by(year) |>
  summarise(
    ela_mean = mean(ela_z, na.rm = TRUE),
    ela_sd = sd(ela_z, na.rm = TRUE),
    math_mean = mean(math_z, na.rm = TRUE),
    math_sd = sd(math_z, na.rm = TRUE),
    .groups = "drop"
  )


write_csv(schools, "data/processed/schools_transformed.csv")
write_csv(acs, "data/processed/acs_transformed.csv")


acs_duplicate_keys <- acs |>
  count(county_name, year) |>
  filter(n > 1)
stopifnot(nrow(acs_duplicate_keys) == 0)

schools_merged <- schools |>
  left_join(acs, by = c("county_name", "year"), na_matches = "never")

stopifnot(nrow(schools_merged) == nrow(schools))

unmatched_schools <- schools |>
  anti_join(acs, by = c("county_name", "year"), na_matches = "never")

unmatched_schools |>
  count(year)

write_csv(schools_merged, "data/processed/schools_merged.csv")
