# Task 5: Create summary tables
library(tidyverse)

merged <- read_csv("data/processed/merged.csv")

## ------------------------------------------------------------------
## Step 0: 删除关键分析变量缺失的记录
## 只针对分析用到的变量做删除，避免误删过多数据
## ------------------------------------------------------------------
n_before <- nrow(merged)

merged_complete <- merged |>
  drop_na(
    county_name, year, total_enroll,
    per_free_lunch, per_reduced_lunch,
    county_per_poverty, poverty_group,
    math_z, ela_z
  )

n_after <- nrow(merged_complete)

# 打印删除情况，写进 Rmd 报告里说明
cat("删除前:", n_before, "行 | 删除后:", n_after, "行 |",
    "删除了", n_before - n_after, "行 (",
    round((n_before - n_after) / n_before * 100, 1), "% )\n")

## ------------------------------------------------------------------
## Table 1: County profile
## ------------------------------------------------------------------
county_summary <- merged_complete |>
  group_by(county_name) |>
  summarise(
    years_covered          = n_distinct(year),
    total_enrollment       = sum(total_enroll),
    per_free_lunch_mean    = mean(per_free_lunch),
    per_reduced_lunch_mean = mean(per_reduced_lunch),
    per_poverty_mean       = mean(county_per_poverty),
    .groups                = "drop"
  ) |>
  arrange(desc(per_poverty_mean))

county_summary
write_csv(county_summary, "data/processed/county_summary.csv")

## ------------------------------------------------------------------
## Table 2: Top 5 / Bottom 5 counties by poverty rate
## ------------------------------------------------------------------
extreme <- bind_rows(
  county_summary |>
    slice_max(per_poverty_mean, n = 5) |>
    mutate(extreme_group = "Top 5 (highest poverty)"),
  county_summary |>
    slice_min(per_poverty_mean, n = 5) |>
    mutate(extreme_group = "Bottom 5 (lowest poverty)")
)

top_bottom_summary <- merged_complete |>
  filter(county_name %in% extreme$county_name) |>
  # 先逐行算出合计免费+减价比例，再求均值（比两个均值相加更准确）
  mutate(free_reduced = per_free_lunch + per_reduced_lunch) |>
  group_by(county_name) |>
  summarise(
    per_poverty      = mean(county_per_poverty),
    per_free_reduced = mean(free_reduced),
    mean_reading     = mean(mean_ela_score, na.rm = TRUE),
    mean_math        = mean(mean_math_score, na.rm = TRUE),
    .groups          = "drop"
  ) |>
  left_join(select(extreme, county_name, extreme_group), by = "county_name") |>
  arrange(desc(per_poverty))

top_bottom_summary
write_csv(top_bottom_summary, "data/processed/top_bottom_summary.csv")

## ------------------------------------------------------------------
## Table 3: Performance by poverty group
## ------------------------------------------------------------------
poverty_group_summary <- merged_complete |>
  group_by(poverty_group) |>
  summarise(
    n_school_years = n(),                    # 改名：这是学校-年记录数
    n_counties     = n_distinct(county_name),
    mean_math_z    = mean(math_z),
    mean_ela_z     = mean(ela_z),
    .groups        = "drop"
  )

poverty_group_summary
write_csv(poverty_group_summary, "data/processed/poverty_group_summary.csv")

# 保存清洗后的完整数据，供 4_plot.R 使用，避免重复做 drop_na
write_csv(merged_complete, "data/processed/merged_complete.csv")