library(tidyverse)
data <- read_csv('data/processed/schools.csv')

data |>
  mutate(poverty_level = factor(poverty_level,
                                   levels = c('Low','Medium','High'))) |>
  ggplot(aes(x = poverty_level, y = std_math)) +
  geom_boxplot()+
  theme_minimal()


data |>
  mutate(poverty_level = factor(poverty_level,
                                levels = c('Low','Medium','High'))) |>
  ggplot(aes(x = poverty_level, y = std_ela)) +
  geom_boxplot()+
  theme_minimal()