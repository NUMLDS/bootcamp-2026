library(tidyverse)

# Task1
school_raw <- read_csv('data/raw/nys_schools.csv')
acs_raw <- read_csv('data/raw/nys_acs.csv')

# Task2
# NDA
dim(school_raw)
dim(acs_raw)

summary(school_raw$per_free_lunch) # find outliers
summary(acs_raw)

# missing values
# 检查缺失值编码为-99的情况在某一列的分布（提前预警）
table(school_raw$per_lep == -99)  # 返回 TRUE/FALSE 各多少个
colSums(is.na(school_raw))
colSums(is.na(acs_raw))
# or use skimr
# install.packages("skimr")
# library(skimr)
# skim(nys_schools)
# 检查每一列有多少个 -99(只对数值列有意义)
school_raw |>
  summarise(across(where(is.numeric), ~sum(. == -99, na.rm = TRUE)))
# 看看哪些列存在-99,给自己提个醒
sapply(school_raw, function(x) if(is.numeric(x)) sum(x == -99, na.rm = TRUE) else NA)

# outlier
# summary(nys_schools$math_score) 

# duplicate
sum(duplicated(school_raw))
sum(duplicated(acs_raw))

# Task3
# missing values & outliers
school_clean <- school_raw |>
  distinct() |>
  mutate(
    county_name = na_if(county_name, "-99"),
    across(where(is.numeric), ~ na_if(.x, -99)),
    per_free_lunch = if_else(per_free_lunch > 1, NA_real_, per_free_lunch),
    per_reduced_lunch = if_else(per_reduced_lunch > 1, NA_real_, per_reduced_lunch)
  )

acs_clean <- acs_raw |>
  distinct() |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))

write_csv(school_clean, "data/processed/schools_clean.csv")
write_csv(acs_clean, "data/processed/acs_clean.csv")
