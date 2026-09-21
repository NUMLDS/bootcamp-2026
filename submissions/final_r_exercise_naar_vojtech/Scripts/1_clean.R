# ============================================================
# MLDS Final R Exercise
# Script 1: Import, inspect, and clean data
# ============================================================

library(tidyverse)


# ------------------------------------------------------------
# 1. IMPORT DATA
# ------------------------------------------------------------

schools_raw <- read_csv("Data/raw/nys_schools.csv")
acs_raw <- read_csv("Data/raw/nys_acs.csv")


# ------------------------------------------------------------
# 2. INSPECT DATA
# ------------------------------------------------------------

glimpse(schools_raw)
glimpse(acs_raw)

head(schools_raw)
head(acs_raw)

dim(schools_raw)
dim(acs_raw)

names(schools_raw)
names(acs_raw)

summary(schools_raw)
summary(acs_raw)


# ------------------------------------------------------------
# 3. CHECK DUPLICATES
# ------------------------------------------------------------

sum(duplicated(schools_raw))
sum(duplicated(acs_raw))


# ------------------------------------------------------------
# 4. CLEAN SCHOOL DATA
# ------------------------------------------------------------

schools_clean <- schools_raw |>
  
  # Remove exact duplicate rows
  distinct() |>
  
  # Replace invalid/missing values
  mutate(
    county_name = na_if(county_name, "-99"),
    
    across(
      where(is.numeric),
      ~ na_if(.x, -99)
    ),
    
    # Lunch variables are proportions and must be <= 1
    per_free_lunch = if_else(
      per_free_lunch > 1,
      NA_real_,
      per_free_lunch
    ),
    
    per_reduced_lunch = if_else(
      per_reduced_lunch > 1,
      NA_real_,
      per_reduced_lunch
    )
  ) |>
  
  # Remove observations without a county
  filter(!is.na(county_name))


# ------------------------------------------------------------
# 5. CLEAN ACS DATA
# ------------------------------------------------------------

acs_clean <- acs_raw |>
  
  distinct() |>
  
  mutate(
    across(
      where(is.numeric),
      ~ na_if(.x, -99)
    )
  ) |>
  
  # County/year are required for the later join
  filter(
    !is.na(county_name),
    !is.na(year)
  )


# ------------------------------------------------------------
# 6. VERIFY CLEANING
# ------------------------------------------------------------

sum(duplicated(schools_clean))
sum(duplicated(acs_clean))

schools_clean |>
  summarise(
    across(everything(), ~ sum(is.na(.x)))
  )

acs_clean |>
  summarise(
    across(everything(), ~ sum(is.na(.x)))
  )

summary(schools_clean$per_free_lunch)
summary(schools_clean$per_reduced_lunch)

glimpse(schools_clean)
glimpse(acs_clean)


# ------------------------------------------------------------
# 7. SAVE CLEAN DATA
# ------------------------------------------------------------

write_csv(
  schools_clean,
  "Data/processed/nys_schools_clean.csv"
)

write_csv(
  acs_clean,
  "Data/processed/nys_acs_clean.csv"
)