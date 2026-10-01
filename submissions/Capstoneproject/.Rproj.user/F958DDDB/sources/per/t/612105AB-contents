# 1_clean.R
# Purpose: import raw data, inspect structure, handle missing values.
# Output: cleaned schools and acs dataframes -> data/processed/

library(tidyverse)

# --- Import ---------------------------------------------------------------
schools <- read_csv("data/raw/nys_schools.csv")
acs <- read_csv("data/raw/nys_acs.csv")

# --- Explore ---------------------------------------------------------------
glimpse(schools)
glimpse(acs)
dim(schools)
dim(acs)
summary(schools)
summary(acs)

# --- Recode missing values --------------------------------------------------
# -99 is a placeholder for missing data in this dataset.
schools <- schools %>%
  mutate(across(where(is.numeric), ~na_if(.x, -99)))

acs <- acs %>%
  mutate(across(where(is.numeric), ~na_if(.x, -99)))

# confirm no -99 remains
sum(schools == -99, na.rm = TRUE)
sum(acs == -99, na.rm = TRUE)

# --- Save cleaned data -------------------------------------------------------
write_csv(schools, "data/processed/schools_clean.csv")
write_csv(acs, "data/processed/acs_clean.csv")

