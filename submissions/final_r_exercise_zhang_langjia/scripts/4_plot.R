library(tidyverse)

ggplot(county) +
  geom_point(mapping = aes(x = poverty, y = math)) +
  labs(
    title = "Strong Negative Relationship Between Poverty and Math scores",
    y = "Math Score",
    x = "Poverty Rate"
  )

ggplot(county) +
  geom_point(mapping = aes(x = poverty, y = ela)) +
  labs(
    title = "Strong Negative Relationship Between Poverty and ELA scores",
    y = "ELA Score",
    x = "Poverty Rate"
  )

ggplot(county) +
  geom_point(mapping = aes(x = math, y = ela)) +
  labs(
    title = "Strong Positive Relationship Between Math and ELA scores",
    y = "Math Score",
    x = "ELA Rate"
  )