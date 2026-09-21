county_summary = joined |>
  filter(year == 2016) |>
  group_by(county_name) |>
  summarise(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    pct_frl = weighted.mean(per_free_lunch + per_reduced_lunch, w = total_enroll, na.rm = TRUE) * 100,
    pct_poverty = mean(county_per_poverty, na.rm = TRUE) * 100
  ) |>
  arrange(desc(pct_poverty))

county_summary

###

top5    = county_summary |> 
  slice_max(pct_poverty, n = 5)
bottom5 = county_summary |> 
  slice_min(pct_poverty, n = 5)

extremes = bind_rows(
  top5    |> 
    mutate(group = "Top 5 poverty"),
  bottom5 |> 
    mutate(group = "Bottom 5 poverty")
)

extremes_detail = joined |>
  filter(year == 2016, county_name %in% extremes$county_name) |>
  group_by(county_name) |>
  summarise(
    pct_poverty   = mean(county_per_poverty, na.rm = TRUE) * 100,
    pct_frl       = weighted.mean(per_free_lunch + per_reduced_lunch, w = total_enroll, na.rm = TRUE) * 100,
    mean_reading  = weighted.mean(mean_ela_score, w = total_enroll, na.rm = TRUE),
    mean_math     = weighted.mean(mean_math_score, w = total_enroll, na.rm = TRUE)
  ) |>
  left_join(extremes |> select(county_name, group), by = "county_name") |>
  arrange(group, desc(pct_poverty))

extremes_detail

###

joined16 <- joined |>
  filter(year == 2016) |>
  mutate(
    pct_frl       = (per_free_lunch + per_reduced_lunch) * 100,
    poverty_group = factor(poverty_group, levels = c("low", "medium", "high"),
                           labels = c("Low", "Medium", "High"))
  )

plot_dat <- joined16 |>
  select(school_name, pct_frl, mean_ela_score, mean_math_score) |>
  pivot_longer(c(mean_ela_score, mean_math_score),
               names_to = "subject", values_to = "score") |>
  mutate(subject = recode(subject,
                          mean_ela_score  = "English Language Arts",
                          mean_math_score = "Math"))

ggplot(plot_dat, aes(x = pct_frl, y = score)) +
  geom_point(alpha = 0.2, size = 1, color = "#2c7fb8") +
  geom_smooth(method = "lm", se = TRUE, color = "#d95f02") +
  facet_wrap(~ subject) +
  labs(
    title    = "joined serving more low-income students score lower on state tests",
    subtitle = "New York State joined, 2016",
    x        = "Students qualifying for free or reduced-price lunch (%)",
    y        = "Mean scale score",
    caption  = "Source: NYS school report cards merged with ACS county estimates"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold", size = 14),
    panel.grid.minor = element_blank(),
    strip.text      = element_text(face = "bold")
  )