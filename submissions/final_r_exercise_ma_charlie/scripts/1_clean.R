# 1_clean.R

library(tidyverse)

# data/processed/ is gitignored by the class repo, so it won't exist in a fresh
# clone. Create it rather than letting write_csv() fail.
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

# Task 1: Import data
# Import the school-level data
schools_raw <- read_csv("data/raw/nys_schools.csv")
# Import the county-level ACS data
acs_raw <- read_csv("data/raw/nys_acs.csv")

# head(schools_raw)
# head(acs_raw)

# Task 2: Explore the imported data
# glimpse(schools_raw)
# glimpse(acs_raw)

# Task 3: Re-coding and variable manipulation
# 3.1 Recode missing values
# Other data issues noted by the class:
# Duplicate rows
nrow(schools_raw) - nrow(distinct(schools_raw))
# Percentages > 1.00 for percentage columns. Also we should not have per_free_lunch + per_reduced_lunch > 1.
# NA values
# Below is the cleaning code that resolve all these data issues:
schools <- schools_raw |>
  distinct() |>
  mutate(across(where(is.numeric),   ~ na_if(., -99)), 
         across(where(is.character), ~ na_if(., "-99"))) |>
  mutate(across(c(per_free_lunch, per_reduced_lunch, per_lep), 
                ~ if_else(. > 1, NA_real_, .))) |>
  mutate(per_free_reduced = per_free_lunch + per_reduced_lunch,
         per_free_reduced = if_else(per_free_reduced > 1, NA_real_, per_free_reduced)) |>
  filter(!is.na(county_name))

# 3.2 Create a categorical variable that groups counties into "high", "medium", and "low" poverty groups. 
summary(acs_raw$county_per_poverty)

# Decide how you want to split up the groups and briefly explain your decision.
#  * Terciles rather than round cutoffs (e.g. <10% / 10-20% / >20%): NY county
#    poverty ranges only 4.7% to 29.9% and most counties bunch between 11% and
#    15%, so round cutoffs would leave the middle group nearly empty. Terciles
#    guarantee comparable group sizes, which keeps the group means stable.
#  * Terciles computed over ALL county-years pooled, not recalculated per year.
#    A fixed standard means "high poverty" denotes the same thing in 2009 and
#    2016 -- necessary for the "has this changed over time?" question. Re-ranking
#    each year would force a third of counties into each bin annually and hide
#    any real shift in poverty levels.

acs_clean <- acs_raw |>
  mutate(
    poverty_group = cut(
      county_per_poverty,
      breaks = quantile(county_per_poverty, probs = c(0, 1/3, 2/3, 1)),
      labels = c("low", "medium", "high"),
      include.lowest = TRUE
    )
  )

# 3.3: Within-year z-scores
schools_clean <- schools |>
  group_by(year) |>
  mutate(across(c(mean_ela_score, mean_math_score),
                ~ as.numeric(scale(.)), .names = "{.col}_z")) |>
  ungroup()

# Save the cleaned datasets
write_csv(schools_clean, "data/processed/nys_schools_clean.csv")
write_csv(acs_clean,     "data/processed/nys_acs_clean.csv")
