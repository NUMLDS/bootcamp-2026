# Task 6: Visualizations for the department (WSJ style)

library(tidyverse)
library(ggthemes)   # theme_wsj(), scale_fill_wsj()
library(scales)     # percent_format()

# 读取 Task 5 已经处理好缺失值的数据
merged_complete <- read_csv("data/processed/merged_complete.csv")

dir.create("figures", showWarnings = FALSE)

# WSJ 主题的统一微调：把被隐藏的坐标轴标题加回来，缩小字号
wsj_tweak <- theme_wsj(base_size = 10, color = "brown") +
  theme(
    plot.title      = element_text(size = 15, face = "bold"),
    plot.subtitle   = element_text(size = 10, color = "grey30"),
    axis.title      = element_text(size = 10, face = "plain"),  # 覆盖掉 blank
    axis.title.x    = element_text(margin = margin(t = 8)),
    axis.title.y    = element_text(margin = margin(r = 8)),
    axis.text       = element_text(size = 9),
    strip.text      = element_text(size = 11, face = "bold"),
    legend.position = "bottom",
    legend.title    = element_blank()
  )

## ------------------------------------------------------------------
## Plot 1: Free lunch vs test performance (school level)
## ------------------------------------------------------------------
plot1 <- merged_complete |>
  pivot_longer(
    cols      = c(math_z, ela_z),
    names_to  = "subject",
    values_to = "z_score"
  ) |>
  mutate(subject = recode(subject, math_z = "Math", ela_z = "ELA")) |>
  ggplot(aes(x = per_free_lunch, y = z_score)) +
  geom_point(alpha = 0.20, color = "grey45", size = 1) +
  geom_smooth(method = "lm", formula = y ~ x,
              color = "#C72E29", fill = "#C72E29", alpha = 0.2, linewidth = 1.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey55") +
  facet_wrap(~ subject) +
  scale_x_continuous(labels = percent_format(accuracy = 1)) +
  labs(
    title    = "Schools with more free-lunch students score lower",
    subtitle = "Each point is one school-year; scores standardized within year (z-score)",
    x        = "Share of students qualifying for free lunch",
    y        = "Test performance (z-score)"
  ) +
  wsj_tweak

plot1
ggsave("figures/lunch_vs_performance.png", plot1,
       width = 9, height = 5, dpi = 300, bg = "#f8f2e4")

## ------------------------------------------------------------------
## Plot 2: Performance across low / medium / high poverty counties
## 提示：跑完后看实际差距，把标题里的数字改成真实值
## ------------------------------------------------------------------
plot2_data <- merged_complete |>
  group_by(poverty_group) |>
  summarise(
    mean_math_z = mean(math_z),
    mean_ela_z  = mean(ela_z),
    .groups     = "drop"
  ) |>
  pivot_longer(-poverty_group, names_to = "subject", values_to = "mean_z") |>
  mutate(
    subject = recode(subject, mean_math_z = "Math", mean_ela_z = "ELA"),
    # 确保排序是 low < medium < high
    poverty_group = factor(poverty_group, levels = c("low", "medium", "high"))
  )

# 先看一眼实际差距，再据此改标题
plot2_data

plot2 <- plot2_data |>
  ggplot(aes(x = poverty_group, y = mean_z, fill = subject)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.65) +
  geom_hline(yintercept = 0, color = "grey30", linewidth = 0.6) +
  scale_fill_wsj(palette = "colors6") +
  labs(
    title    = "High-poverty counties trail by about half a standard deviation",
    subtitle = "Mean standardized (z) test scores by county poverty group, all years combined",
    x        = "County poverty group",
    y        = "Mean test performance (z-score)"
  ) +
  wsj_tweak

plot2
ggsave("figures/poverty_group_performance.png", plot2,
       width = 8, height = 5, dpi = 300, bg = "#f8f2e4")