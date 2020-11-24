# Chapter10.R - all the exercises and examples from chapter 10 of R4DS.

# 10.1.1 ------------------------------------------------------------------
library(tidyverse)


# 10.2 --------------------------------------------------------------------
as_tibble(iris)

tibble(x = 1:5, y = 1, z = x ^ 2 + y)

tb <- tibble(`:-)` = "smile", ` ` = "space", `2000` = "number")

tribble(
  ~x, ~y, ~z,
  #--|--|--
  "a", 2, 3.6,
  "b", 1, 8.5
)


# 10.3.1 ------------------------------------------------------------------
tibble(
  a = lubridate::now() + runif(1e3) * 84600,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>% 
  print(n = 10, width = Inf)

nycflights13::flights %>% 
  View()


# 10.3.2 ------------------------------------------------------------------
df <- tibble(x = runif(5), y = rnorm(5))

df$x

df[["x"]]

df[[1]]

df %>% .$x

df %>% .[["x"]]


# 10.4 --------------------------------------------------------------------
class(data.frame(tb))


# 10.5 --------------------------------------------------------------------
# 1
# A tibble only shows the first 10 rows. With mtcars my console if full of rows
# of data, which is something a tibble tries to fix.

# 2
df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]
# This yields some irregular results. It seems to do partial matches, which can
# be confusing.

tibbleDF <- tibble(df)
tibbleDF$x
tibbleDF[, "xyz"]
tibbleDF[, c("abc", "xyz")]
# Whereas a tibble doesn't give any results, which is to be expected.

# 3
var <- "mpg"

mtcars[[var]]

# 4
annoying <- tibble(`1` = 1:10, `2` = `1` + 2 + rnorm(length(`1`)))

# 4.1
annoying[["1"]]

# 4.2
ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()

# 4.3
annoying2 <- annoying %>% 
  mutate(`3` = `2` / `1`)

# 4.4
annoying2 %>% 
  rename(
    one = `1`,
    two = `2`,
    three = `3`
  )

# 5
# It converts list and vectors to data frames. When, for example, you want to do
# some calculations but the input has to be a data frame.

# 6
# This is width. If you state that there should be printed 3, the rest is moved
# to the footer.