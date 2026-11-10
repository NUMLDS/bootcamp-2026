library(tidyverse)

# 从项目根目录运行；学校编号按文本读取，保留开头的 0。
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
schools <- read_csv("data/raw/nys_schools.csv",
                    col_types = cols(school_cd = col_character()))
acs <- read_csv("data/raw/nys_acs.csv")

# 探索变量类型、范围、年份分布和缺失编码。
glimpse(schools)
glimpse(acs)


dim(schools)
dim(acs)

summary(schools)
summary(acs)

schools |> count(year)
acs |> count(year)

schools |>
  summarise(across(where(is.numeric), ~ sum(.x == -99, na.rm = TRUE)))

acs |>
  summarise(across(where(is.numeric), ~ sum(.x == -99, na.rm = TRUE)))

# 将数值列的 -99 缺失编码转换为 NA。
schools <- schools |>
  mutate(across(where(is.numeric), ~ na_if(.x, -99)))

acs <- acs |>
  mutate(across(where(is.numeric), ~na_if(.x, -99)))

schools |> summarize(across(everything(), ~sum(is.na(.x))))

acs |> summarize(across(everything(), ~sum(is.na(.x))))

# 文本列也可能包含 -99 或空白。
schools <- schools |>
  mutate(across(
    where(is.character),
    ~ na_if(na_if(trimws(.x), "-99"), "")
  ))


# 只删除所有列完全相同的重复行。
schools <- schools |>
  distinct()

lunch_issues <- schools |>
  filter(
    per_free_lunch < 0 | per_free_lunch > 1 |
      per_reduced_lunch < 0 | per_reduced_lunch > 1 |
      per_free_lunch + per_reduced_lunch > 1
  ) |>
  select(
    school_cd, school_name, year, total_enroll,
    per_free_lunch, per_reduced_lunch
  )

# 自动运行时不打开图形窗口。
if (interactive()) View(lunch_issues)

lunch_issues |>
  arrange(desc(per_free_lunch)) |>
  print(n = 30)


schools <- schools |>
  filter(
    !coalesce(
      per_free_lunch < 0 | per_free_lunch > 1 |
        per_reduced_lunch < 0 | per_reduced_lunch > 1 |
        per_free_lunch + per_reduced_lunch > 1 + 1e-8,
      FALSE
    )
  )

schools |>
  count(school_cd, year) |>
  filter(n > 1)


# 保存本阶段结果；下一个脚本独立读取这些文件。
write_csv(schools, "data/processed/schools_clean.csv")
write_csv(acs, "data/processed/acs_clean.csv")
