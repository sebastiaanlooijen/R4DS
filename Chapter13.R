# Chapter13.R - all the exercises and examples from chapter 13 of R4DS.

# Packages ----------------------------------------------------------------
library(tidyverse)
library(nycflights13)
library(Lahman)
library(babynames)
library(nasaweather)
library(fueleconomy)
library(maps)


# 13.2 --------------------------------------------------------------------
airlines
airports
planes
weather


# 13.2.1 ------------------------------------------------------------------
# 1
# origin and dest from 'flights', tailnum and carrier from flights, year and
# month from weather.

# 2
# Both have origin, so that can be linked.

# 3
# Year, month, day, hour, and dest.

# 4
special_days <- tribble(
  ~month, ~day, ~holiday,
  01, 01, "New Years Day",
  12, 25, "Christmas"
)


# 13.3 --------------------------------------------------------------------
planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)
m
flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)


# 13.3.1 ------------------------------------------------------------------
# 1
flights_surrogate <- flights %>% 
  mutate(
    surrogate_key = paste(
      flight,
      tailnum, 
      origin, 
      dest, 
      time_hour, 
      sep = "-"
    )
  )

flights_surrogate %>% 
  count(surrogate_key) %>% 
  filter(n > 1)

# 2
Batting %>% 
  count(playerID, yearID, stint) %>% 
  filter(n > 1)

babynames %>% 
  count(year, sex, name) %>% 
  filter(n > 1)

atmos %>% 
  count(lat, long, year, month) %>% 
  filter(n > 1)

vehicles %>% 
  count(id) %>% 
  filter(n > 1)

# diamonds doesn't have a primary key.

# 3
diagram1 <- Batting %>% 
  left_join(Master, by = "playerID") %>%
  left_join(Salaries, by = c("playerID", "yearID", "teamID", "lgID"))

diagram2 <- Managers %>% 
  left_join(AwardsManagers, by = c("playerID", "yearID", "lgID")) %>% 
  left_join(Master, by = "playerID")


# 13.4 --------------------------------------------------------------------
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")


# 13.4.1 ------------------------------------------------------------------
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)


# 13.4.2 ------------------------------------------------------------------
x %>%
  inner_join(y, by = "key")


# 13.4.4 ------------------------------------------------------------------
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")


# 13.4.5 ------------------------------------------------------------------
flights2 %>% 
  left_join(weather)

flights2 %>% 
  left_join(planes, by = "tailnum")

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))


# 13.4.6 ------------------------------------------------------------------
# 1
average_delay <- flights %>% 
  group_by(dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  inner_join(airports, by = c(dest = "faa")) 
  
ggplot(average_delay, aes(x = lon, y = lat, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 2
airports_location <- airports %>% 
  select(faa, lat, lon)

flights %>% 
  left_join(airports_location, by = c("origin" = "faa")) %>% 
  left_join(
    airports_location, 
    by = c("dest" = "faa"),
    suffix = c("_origin", "_dest")
  )

# 3
planes_age <- flights %>% 
  select(year, dep_delay, tailnum) %>% 
  inner_join(
    select(planes, tailnum, plane_year = year)
  ) %>%
  mutate(age = year - plane_year) %>% 
  group_by(age) %>% 
  summarise(average_delay = mean(dep_delay, na.rm = TRUE))

ggplot(planes_age, aes(x = age, y = average_delay)) +
  geom_line()

# 4
flights_weather <- flights %>%
  inner_join(
    weather, by = c(
    "origin" = "origin",
    "year" = "year",
    "month" = "month",
    "day" = "day",
    "hour" = "hour"
    )
  ) %>% 
  group_by(precip) %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE))

ggplot(flights_weather, aes(x = precip, y = delay)) +
  geom_line()

# 5
flights_spatial <- flights %>% 
  filter(year == 2013, month == 6, day == 13) %>% 
  group_by(dest) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  inner_join(airports, by = c("dest" = "faa"))

ggplot(flights_spatial, aes(y = lat, x = lon, size = delay, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
# A storm!


# 13.5 --------------------------------------------------------------------
top_dest <- flights %>% 
  count(dest, sort = TRUE) %>% 
  head(10)

flights %>%
  filter(dest %in% top_dest$dest)

flights %>% 
  semi_join(top_dest)

flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = TRUE)


# 13.5.1 ------------------------------------------------------------------
# 1
# It means that they didn't depart: the flight was cancelled. 

# 2
flights %>%
  filter(!is.na(tailnum)) %>% 
  count(tailnum) %>% 
  filter(n > 100)

# 3
common %>% 
  arrange(desc(n)) %>% 
  head(10) %>% 
  inner_join(vehicles, by = c("make", "model"))

# 4
worst_hours <- flights %>%
  mutate(hour = sched_dep_time %% 100) %>% 
  group_by(origin, year, month, day, hour) %>% 
  summarise(average_delay = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(average_delay)) %>% 
  head(48)

# 5
# The first expression returns the flights that went to airports that are not in
# FAA list.

# The second expression returns the flights that were not the destination in the
# flight data.

# 6
planes_carriers <- flights %>%
  filter(!is.na(tailnum)) %>%
  distinct(tailnum, carrier)

carrier_transfer_tbl <- planes_carriers %>%
  group_by(tailnum) %>%
  filter(n() > 1) %>%
  left_join(airlines, by = "carrier") %>%
  arrange(tailnum, carrier)


# 13.6 --------------------------------------------------------------------
airports %>% count(lon, lat) %>% filter(n > 1)


# 13.7 --------------------------------------------------------------------
df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)

df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)