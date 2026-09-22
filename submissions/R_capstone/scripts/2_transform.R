# Task3.2 group counties
# # 汇总每个 county 的贫困率
# county_poverty <- acs_clean |>
#   group_by(county_name) |>
#   summarize(county_per_poverty = mean(county_per_poverty, na.rm = TRUE))

# 用三分位数切成三组
county_poverty <- acs_clean |>
  mutate(
    poverty_group = cut(
      county_per_poverty,
      breaks = quantile(county_per_poverty, c(0, 1/3, 2/3, 1), na.rm = TRUE),
      labels = c("low", "medium", "high"),
      include.lowest = TRUE
    )
  )

# county_poverty <- county_poverty |>
#   mutate(
#     poverty_group = case_when(
#       per_poverty < 0.15 ~ "low",      # < 15%
#       per_poverty < 0.25 ~ "medium",   # 15% - 25%
#       TRUE               ~ "high"      # > 25%
#     )
#   )

# use plot
# acs_clean |>
#   ggplot(aes(x = county_per_poverty)) +
#   geom_histogram(binwidth = 0.05, fill = "#4C72B0", color = "white") +
#   geom_vline(xintercept = c(0.25, 0.6), linetype = "dashed", color = "red") +
#   labs(
#     x = "Poverty rate", y = "Number of county-year records",
#     title = "Distribution of poverty rates — choosing cutoffs"
#   )

# 标准化
schools_z <- school_clean |>
  group_by(year) |>
  mutate(
    math_z = as.numeric(scale(mean_math_score)),
    ela_z  = as.numeric(scale(mean_ela_score))
  ) |>
  ungroup()

# Task4
# merge
merged <- schools_z |>
  left_join(county_poverty, by = c("county_name", "year"))

write_csv(merged, "data/processed/merged.csv")