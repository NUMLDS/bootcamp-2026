library(tidyverse)

#Import data
df <- read_csv("data/processed/nys_acs_school_final.csv")

#Reshape: one row per school-year-subject
df_long <- df |>
  mutate(poverty_grp = factor(poverty_grp, levels = c("Low", "Medium", "High"))) |>
  pivot_longer(c(math_z, ela_z), names_to = "subject", values_to = "z") |>
  mutate(subject = recode(subject, math_z = "Math", ela_z = "ELA")) |>
  drop_na(z)

#Slopes: change in z-score per +10 percentage points of county poverty
slope_by <- function(data, ...) {
  data |>
    group_by(...) |>
    summarise(slope = coef(lm(z ~ county_per_poverty))[2] * 0.1, .groups = "drop") |>
    mutate(label = sprintf("%+.2f", slope))
}

slopes_overall <- slope_by(df_long, subject)
slopes_year    <- slope_by(df_long, year, subject)

#Plots
##1. Poverty vs. z-scores (overall, slope labeled)
p1 <- ggplot(df_long, aes(county_per_poverty, z)) +
  geom_point(alpha = 0.05) +
  geom_smooth(method = "lm", formula = y ~ x) +
  geom_text(data = slopes_overall,
            aes(x = Inf, y = Inf, label = paste("Slope:", label)),
            hjust = 1.1, vjust = 1.5, inherit.aes = FALSE) +
  facet_wrap(~subject) +
  labs(x = "County poverty rate", y = "Z-score",
       caption = "Slope = change in z-score per +10 pts of poverty")
p1

##2. Poverty group vs. z-scores
p2 <- ggplot(df_long, aes(poverty_grp, z, fill = subject)) +
  geom_boxplot(outlier.alpha = 0.1) +
  labs(x = "Poverty group", y = "Z-score", fill = NULL)
p2

##3. Poverty vs. z-scores by year (slope labeled in each panel)
p3 <- ggplot(df_long, aes(county_per_poverty, z, color = subject)) +
  geom_point(alpha = 0.05, size = 0.4) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  geom_text(data = slopes_year,
            aes(x = Inf, y = Inf, label = paste0(subject, ": ", label),
                vjust = if_else(subject == "Math", 1.5, 3)),
            hjust = 1.1, size = 3, show.legend = FALSE) +
  facet_wrap(~year, nrow = 2) +
  labs(x = "County poverty rate", y = "Z-score", color = NULL,
       caption = "Slope = change in z-score per +10 pts of poverty") +
  theme_minimal() +
  theme(legend.position = "top")
p3

##4. Slope over time
p4 <- ggplot(slopes_year, aes(year, slope, color = subject)) +
  geom_line() +
  geom_point() +
  geom_text(aes(label = label), vjust = -0.9, size = 3, show.legend = FALSE) +
  labs(x = "Year", y = "Slope (z-score per +10 pts poverty)", color = NULL) +
  theme_minimal()
p4

#Save plots
dir.create("plots", showWarnings = FALSE)

ggsave("plots/1_poverty_vs_z.png",       p1, width = 9,  height = 5, dpi = 300)
ggsave("plots/2_poverty_group_vs_z.png", p2, width = 7,  height = 5, dpi = 300)
ggsave("plots/3_poverty_vs_z_by_year.png", p3, width = 14, height = 7, dpi = 300)
ggsave("plots/4_slope_over_time.png",    p4, width = 7,  height = 5, dpi = 300)