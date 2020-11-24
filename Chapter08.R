# Chapter08.R - all the exercises and examples from chapter 8 of R4DS.

# 8.2 ---------------------------------------------------------------------
getwd()


# 8.4 ---------------------------------------------------------------------
library(tidyverse)

ggplot(diamonds, aes(carat, price)) +
  geom_hex()
ggsave("diamonds.pdf")

write.csv(diamonds, "diamonds.csv")