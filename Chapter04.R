# Chapter04.R - all the exercises and examples from chapter 4 of R4DS.

# 4.1 ---------------------------------------------------------------------
print(1 / 200 * 30)
print((59 + 73 + 2) / 3)
sin(pi / 2)
      
x <- 3 * 4

object_name <- value

# 4.2 ---------------------------------------------------------------------
x

this_is_a_really_long_name <- 2.5

r_rocks <- 2 ^ 3

# 4.3 ---------------------------------------------------------------------
seq(1, 10)

x <- "hello world"

y <- seq(1, 10, length.out = 5)

(y <- seq(1, 10, length.out = 5))


# 4.4 ---------------------------------------------------------------------
# 1
# You should assign print() or parentheses, otherwise it doesn't show.

# 2
library(tidyverse)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

# 3
# Keyboard shortcuts!