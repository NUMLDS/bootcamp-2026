
joined |>
  group_by(county_name) |>
  summarise(
    n_schools          = n(),
    total_enroll       = sum(total_enroll, na.rm = TRUE),
    per_free_lunch     = mean(per_free_lunch, na.rm = TRUE),
    county_per_poverty = mean(county_per_poverty, na.rm = TRUE),
    .groups = "drop"
  )

joined|>
  group_by(county_name, poverty_group)|>
  filter(
    row_number(desc(total_enroll)) <= 5 |
      row_number(total_enroll) <= 5
  ) |>
  arrange(poverty_group, desc(total_enroll)) |>
  summarise(
    n_schools          = n(),
    total_enroll       = sum(total_enroll, na.rm = TRUE),
    per_free_lunch     = mean(per_free_lunch, na.rm = TRUE),
    county_per_poverty = mean(county_per_poverty, na.rm = TRUE),
    mean_reading_score = mean(mean_ela_score),
    mean_math_score = mean(mean_math_score),
    .groups = "drop"
  )

library(ggplot2)

joined |>
  filter(if_all(c(per_free_lunch, mean_math_score),
                ~ !is.na(.x))) |>
  ggplot(aes(x = per_free_lunch, y = mean_math_score)) +
  geom_point()

joined |>
  filter(if_all(c(per_free_lunch, mean_ela_score),
                ~ !is.na(.x))) |>
  ggplot(aes(x = per_free_lunch, y = mean_ela_score)) +
  geom_point()

joined |>
  filter(if_all(c(per_reduced_lunch, mean_ela_score),
                ~ !is.na(.x))) |>
  ggplot(aes(x = per_reduce_lunch, y = mean_ela_score)) +
  geom_point()

joined |>
  filter(if_all(c(per_reduced_lunch, mean_math_score),
                ~ !is.na(.x))) |>
  ggplot(aes(x = per_reduce_lunch, y = mean_math_score)) +
  geom_point()



