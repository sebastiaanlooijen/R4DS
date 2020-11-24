# Chapter03.R - all the exercises and examples from chapter 3 of R4DS.

# Load packages -----------------------------------------------------------
library(tidyverse)


# 3.2.2 -------------------------------------------------------------------
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


# 3.2.4 -------------------------------------------------------------------
# 1
ggplot(data = mpg)

# 2
nrow(cars)
ncol(cars)

# 3
# If the cars are front-, rear-, or four-wheel drive.

# 4
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

# 5
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))


# 3.3 ---------------------------------------------------------------------
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")


# 3.3.1 -------------------------------------------------------------------
# 1
# The mapping is inside the aes(), which means it's mapped the content of the 
# used variables, thus renaming all the classes "blue".

# 2
# categorical: manufacturer, model, trans, drv, fl, class
# continous: displ, year, cyl, cty, hwy.

# 3
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cyl))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = cty))

# 4
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cyl, size = cyl))

# 5
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, stroke = 4))
# Stroke seems to increase the border size of the geoms.

# 6
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = displ < 5))
# The colour is turned in the a boolean, TRUES and FALSES get a different
# colour.


# 3.5 ---------------------------------------------------------------------
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(drv ~ cyl)


# 3.5.1 -------------------------------------------------------------------
# 1
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cty)
# The continous gets turned into a categorical variables.

# 2
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl)
# There is no car with that particular drv and cyl combo. This is because we
# are plotting every combination, and ggplot draws the complete raster.

# 3
# The . means there is no other variable used in the facet_grid.

# 4
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
# Every combination get its own graph, which makes this more detailed. However,
# it is also a little bit hard to read.

# 5
# This adds the number of rows or columns in facet_wrap. Facet_grid however,
# creates a whole grid everytime.

# 6
# Simply easier to read.


# 3.6 ---------------------------------------------------------------------
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# 3.6.1 -------------------------------------------------------------------
# 1
# geom_smooth, geom_boxplot, geom_histogram, and geom_map.

# 3
# It removes the legend in the charts.

# 4
# This adds the standard error in the line chart.

# 5
# No, they will look the same. The arguments are given as a global variables,
# so it will be used in subsequent geom layers

# 6
#1
#geom_smooth, geom_boxplot, geom_histogram, and geom_map

#3
#It removes the legend in the charts.

#4
#This adds the standard error in the line chart.

#5
# No, the will look the same. The arguments are givin as a global variable,
# so it will be used in subsequent geom layers

#6
ggplot(data = mpg, mapping = aes(x= displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x= displ, y = hwy)) +
  geom_point() +
  geom_smooth(aes(group = drv), se = FALSE)

ggplot(data = mpg, mapping = aes(x= displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(aes(group = drv), se = FALSE)

ggplot(data = mpg, mapping = aes(x= displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x= displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(mapping = aes(group = drv, linetype = drv), se = FALSE)

ggplot(data = mpg, mapping = aes(x= displ, y = hwy, color = drv)) +
  geom_point(shape = 1, stroke = 2)


# 3.7 ---------------------------------------------------------------------
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


# 3.7.1 -------------------------------------------------------------------
# 1
# The default geom is geom_pointrange
ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

# 2
# geom_bar() makes the height of the bar proportional to the number of cases in
# each group. If you want the heights of the bars to represent the values, use
# geom_col instead.

# 3
# They have mostly the same names. The geoms and stats that are used in concert
# have eachother as default stat or geom.

# 4
# y = predicted value;
# ymin = lower pointwise confidence interval;
# ymax = upper pointwise confidence interval;
# se = standard error;
# method, formula, and se.

# 5
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop)))

# compared to...
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = TRUE))
# It tells geom_bar that the porportions should be for the whole population, 
# not within the group itself. 


# 3.8 ---------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity")
  
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")


# 3.8.1 -------------------------------------------------------------------
# 1
# There are a lot of overlapping data points. I could be improved by adding some
# jitter.

# 2
# Width and height

# 3
ggplot(data = mpg, mapping = aes(x = cyl, y = hwy)) +
         geom_jitter()

ggplot(data = mpg, mapping = aes(x = cyl, y = hwy)) +
         geom_count()

# 4
ggplot(data = mpg, mapping = aes(x = cyl, y = hwy, colour = class)) +
  geom_boxplot()


# 3.9 ---------------------------------------------------------------------
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

bar <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


# 3.9.1 -------------------------------------------------------------------
# 1
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), show.legend = FALSE) +
  coord_polar()

# 2
# This generates the labels on the x and y-axis.

# 3
# They both project maps, _quickmap does a quick approximations that does pre-
# serve straight lines, where _map doesn't.

# 4
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() + # adds reference line, goes through 10,10; 20,20; 30,30; etc.
  coord_fixed() # makes the unites on the x and y axis same size aesthetically. 