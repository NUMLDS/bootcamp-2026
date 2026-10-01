# 3_analyze.R
# Purpose: generate summary tables to answer the department's questions.
# Input: data/processed/merged_data.csv
# Output: printed/saved summary tables used in findings.Rmd

library(tidyverse)

merged <- read_csv("data/processed/merged_data.csv")

names(merged)
# --- Table 1: county-level summary ------------------------------------------
# total enrollment, % free/reduced lunch, % poverty, per county
county_summary <- merged %>%
  group_by(county_name) %>%
  summarize(
    total_enrollment = sum(total_enroll, na.rm = TRUE),
    pct_free_lunch    = mean(per_free_lunch, na.rm = TRUE),
    pct_poverty       = mean(county_per_poverty, na.rm = TRUE)
  ) %>%
  arrange(desc(pct_poverty))

county_summary

# --- Table 2: top 5 / bottom 5 poverty counties -----------------------------
top5 <- county_summary %>% slice_max(pct_poverty, n = 5)
bottom5 <- county_summary %>% slice_min(pct_poverty, n = 5)

top_bottom <- bind_rows(
  top5 %>% mutate(group = "top 5 poverty"),
  bottom5 %>% mutate(group = "bottom 5 poverty")
)

# add mean reading/math scores for these counties
top_bottom_scores <- merged %>%
  filter(county_name %in% top_bottom$county_name) %>%
  group_by(county_name) %>%
  summarize(
    mean_math = mean(math_score, na.rm = TRUE),
    mean_ela  = mean(ela_score, na.rm = TRUE)
  ) %>%
  left_join(top_bottom, by = "county_name")

top_bottom_scores

# --- Table 3: test performance by poverty group -----------------------------
# this is the table that most directly answers Q1: does performance differ
# across low/medium/high poverty areas?
poverty_group_summary <- merged %>%
  group_by(poverty_group) %>%
  summarize(
    mean_math_z = mean(math_z, na.rm = TRUE),
    mean_ela_z  = mean(ela_z, na.rm = TRUE),
    n_schools   = n_distinct(school_name)
  )

poverty_group_summary

# --- Table 4: has the relationship changed over time? -----------------------
# this answers Q2 — trend of the poverty gap across years
poverty_by_year <- merged %>%
  group_by(year, poverty_group) %>%
  summarize(
    mean_math_z = mean(math_z, na.rm = TRUE),
    mean_ela_z  = mean(ela_z, na.rm = TRUE)
  ) %>%
  ungroup()

poverty_by_year

# save tables for use in findings.Rmd
write_csv(county_summary, "data/processed/county_summary.csv")
write_csv(poverty_group_summary, "data/processed/poverty_group_summary.csv")
write_csv(poverty_by_year, "data/processed/poverty_by_year.csv")