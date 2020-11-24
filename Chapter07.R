# Chapter07.R - all the exercises and examples from chapter 7 of R4DS.

# Packages ----------------------------------------------------------------
library(tidyverse)
library(nycflights13)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(hexbin)
library(modelr)


# 7.3.1 -------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)


# 7.3.2 -------------------------------------------------------------------
ggplot(data = smaller, mapping = aes(x = carat, color = cut)) + 
  geom_freqpoly(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)


# 7.3.3 -------------------------------------------------------------------
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>% 
  arrange(y)
unusual


# 7.3.4 -------------------------------------------------------------------
# 1
ggplot(diamonds) +
  geom_histogram(aes(x = x))

ggplot(diamonds) +
  geom_histogram(aes(x = y))

ggplot(diamonds) +
  geom_histogram(aes(x = z))
# x is length, y = width, and z = depth.

# 2
cheapDiamonds <- diamonds %>% 
  filter(price <= 2500)
  
ggplot(data = cheapDiamonds) +
  geom_histogram(aes(price), binwidth = 100)

ggplot(data = diamonds) +
  geom_histogram(aes(price), binwidth = 100)

expensiveDiamonds <- diamonds %>% 
  filter(price >= 10000)

ggplot(data = expensiveDiamonds) +
  geom_histogram(aes(price), binwidth = 100)
# For some reason there is no entry at 1500.

# 3
ninetynine <- diamonds %>% 
  filter(carat == 0.99) %>% 
  count(carat)
ninetynine

hundred <- diamonds %>% 
  filter(carat == 1) %>% 
  count(carat)
hundred

# 4
# coord_cartesian calculates the bins before zooming, whereas xlim en ylim do
# the opposite.

# 7.4 ---------------------------------------------------------------------
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

diamonds3 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(data = diamonds3, mapping = aes(x = x, y = y)) +
  geom_point()

ggplot(data = diamonds3, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
    ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)


# 7.4.1 -------------------------------------------------------------------
# 1
# The histogram removes the NA's when calculatin the bins. The barchart sees
# them as another category.

# 2
# It removes (rm) the NA's (na).


# 7.5.1 -------------------------------------------------------------------
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()


# 7.5.1.1 -----------------------------------------------------------------
# 1
cancelledFlights <- flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    dep_hour = sched_dep_time %/% 100,
    dep_min = sched_dep_time %% 100 / 60, # convert to hours
    dep_time_num = dep_hour + dep_min
  ) 

ggplot(data = cancelledFlights)  +
  geom_boxplot(mapping = aes(x = cancelled, y = dep_time_num))
  
# 2
# Let's start with the obvious, carat...
ggplot(data = diamonds, aes(x = carat, y = price)) +
  geom_point()
  
# If we look at cut, we don't see any major correlations.
ggplot(data = diamonds, aes(x = cut, y = price)) +
  geom_boxplot()

# The color, however, seems a good predictor.
ggplot(data = diamonds, aes(x = color, y = price)) +
  geom_boxplot()

# The clarity   has a negative relation with price.
ggplot(data = diamonds, aes(x = clarity, y = price)) +
  geom_boxplot()

# I would say that carat and color are the best predictors for price.

# 3
ggplot(data = mpg) +
  geom_boxploth(aes(x = hwy, y = class))

# 4
ggplot(data = diamonds, aes(x = cut, y = price)) +
  geom_lv()
# This seems to be mix of boxplots and barcharts. We can see that for example
# Ideal has a smaller standard deviation than, Fair.

# 5
ggplot(data = diamonds) +
  geom_violin(mapping = aes(x = price, y = cut))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price)) +
  facet_wrap( ~ cut)
# Pro: easier to see distritbution.
# Con: hard to read specific values.

# 6
# cex: scaling for adjusting point spacing.
# groupOnX: if TRUE then jitter is added.


# 7.5.2 -------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>% 
  count(color, cut)

diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))


# 7.5.2.1 -----------------------------------------------------------------
# 1
diamonds %>% 
  count(color, cut) %>% 
  group_by(color) %>% 
  mutate(proportion = n / sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = proportion))

diamonds %>% 
  count(color, cut) %>% 
  group_by(cut) %>% 
  mutate(proportion = n / sum(n)) %>% 
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = proportion))

# 2
flights %>% 
  group_by(month, dest) %>% 
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = month, y = dest, fill = dep_delay)) +
  geom_tile()
# For one, I can't read anything on the y-axis.

# 3
# The dependent variable should be on the x-asis, since the cut quality is a
# determant for the color, aes(x = cut, y = color) suits the question better. 


# 7.5.3 -------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_hex(mapping = aes(x = carat, y = price))

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0,1)))

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))


# 7.5.3.1 -----------------------------------------------------------------
# 1
ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = price, color = cut_number(carat, 5)))
# With cut_number you choose the width of the bins, based on count.

# 2
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(price, 2500)))

# 3
# Smaller diamonds vary more in price. It think attributes like color and cut,
# contribute relatively more to the price compared to larger diamonds. 

# 4
ggplot(data = diamonds, aes(x = cut_number(price, 5), y = carat, color = cut)) +
  geom_boxplot()

# 5
# You can see the values that are not within the expected range. In this case
# there seems to be a relation between x and y, and some of the points are 
# really off.


# 7.6 ---------------------------------------------------------------------
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid)) 

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))