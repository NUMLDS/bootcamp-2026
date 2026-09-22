library(tidyverse)

# Import and Read data
nys_schools <- read_csv("data/raw/nys_schools.csv")
nys_acs <- read_csv("data/raw/nys_acs.csv")

# Explore data
glimpse(nys_schools)
glimpse(nys_acs)

# View first few rows
head(nys_schools)
head(nys_acs)

# Check dimensions
dim(nys_schools)
dim(nys_acs)

# Check missing values
colSums(is.na(nys_schools))
colSums(is.na(nys_acs))

# Check values coded as -99
nys_schools |>
  summarize(across(where(is.numeric),
                   ~ sum(.x == -99, na.rm = TRUE)))

nys_acs |>
  summarize(across(where(is.numeric),
                   ~ sum(.x == -99, na.rm = TRUE)))

# Replace -99 with NA
schools_clean <- nys_schools |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))
schools_clean |>
  summarize(across(where(is.numeric), ~ sum(.x == -99, na.rm = TRUE)))
# Replace "-99" with NA in character columns
schools_clean <- schools_clean |>
  mutate(across(where(is.character), ~ na_if(.x, "-99")))

# Replace invalid lunch percentages with NA
schools_clean <- schools_clean |>
  mutate(
    per_free_lunch = if_else(
      per_free_lunch >= 0 & per_free_lunch <= 1,
      per_free_lunch,
      NA_real_
    ),
    per_reduced_lunch = if_else(
      per_reduced_lunch >= 0 & per_reduced_lunch <= 1,
      per_reduced_lunch,
      NA_real_
    )
  )

# Save cleaned data
write_csv(schools_clean, "data/processed/nys_schools_clean.csv")