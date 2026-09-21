### Read Data
# All paths are relative to the project root, so this only works when the
# working directory is the project root (open the .Rproj, or run via
# run_all.R / Rscript from that folder).
library(tidyverse)
raw_1 <- read_csv("data/data_raw/nys_acs.csv")
head(raw_1)
raw_2 <- read_csv("data/data_raw/nys_schools.csv")
head(raw_2)

### Inspect the raw data
glimpse(raw_1)
sum(duplicated(raw_1))
n_distinct(raw_1$county_name)

glimpse(raw_2)
sum(duplicated(raw_2))
n_distinct(raw_2$county_name)

### Recoding and variable manipulation+ joined the dataset

## 1. Missing values coded as -99 -> recode to NA
# -99 shows up as a sentinel in both numeric columns (enrollment, test
# scores, etc.) and character columns (county_name, district_name, region),
# so we sweep both types instead of hardcoding column names.
recode_missing <- function(df) {
  df %>%
    mutate(across(where(is.character), ~ na_if(.x, "-99")),
           across(where(is.numeric), ~ na_if(.x, -99)))
}

acs_clean <- recode_missing(raw_1)
schools_clean <- recode_missing(raw_2)

# sanity check: no -99 sentinels left in either data set
stopifnot(sum(schools_clean == -99, na.rm = TRUE) == 0)
stopifnot(sum(acs_clean == -99, na.rm = TRUE) == 0)

## 2. Join school-level data to county-level ACS data (by county + year)
nys_joined <- schools_clean %>%
  left_join(acs_clean, by = c("county_name", "year"))

## 3. Poverty categorical variable (high / medium / low)
# We split county_per_poverty into terciles (33rd / 67th percentile),
# computed across all county-year observations in the ACS data. Terciles
# give three roughly equal-sized groups and let the data set its own cutoffs,
# rather than picking an arbitrary poverty-rate threshold (e.g. "20%") that
# isn't grounded in how poverty actually varies across NY counties and years.
poverty_cuts <- quantile(acs_clean$county_per_poverty, probs = c(1 / 3, 2 / 3), na.rm = TRUE)

nys_joined <- nys_joined %>%
  mutate(
    poverty_group = case_when(
      is.na(county_per_poverty) ~ NA_character_,
      county_per_poverty <= poverty_cuts[1] ~ "low",
      county_per_poverty <= poverty_cuts[2] ~ "medium",
      TRUE ~ "high"
    ),
    poverty_group = factor(poverty_group, levels = c("low", "medium", "high"))
  )

## 4. Standardized z-scores for math and ELA, within each year
# NYS changes the underlying tests over time, so raw scale scores aren't
# comparable across years. Standardizing within each year (mean 0, sd 1)
# puts every year on the same footing.
nys_joined <- nys_joined %>%
  group_by(year) %>%
  mutate(
    z_math = as.numeric(scale(mean_math_score)),
    z_ela = as.numeric(scale(mean_ela_score))
  ) %>%
  ungroup()

### Save cleaned data
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(nys_joined, "data/processed/nys_schools_acs_cleaned.csv")

