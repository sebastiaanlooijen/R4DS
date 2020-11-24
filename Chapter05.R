# Chapter05.R - all the exercises and examples from chapter 5 of R4DS.

# Packages ----------------------------------------------------------------
library(tidyverse)
library(nycflights13)


# 5.2 ---------------------------------------------------------------------
filter(flights, month == 1, day == 1)

jan1 <- filter(flights, month == 1, day == 1)

(dec25 <- filter(flights, month == 12, day == 25))


# 5.2.1 -------------------------------------------------------------------
filter(flights, month = 1) # doesn't work

sqrt(2) ^ 2 == 2

1 / 49 * 49 == 1

near(sqrt(2) ^ 2, 2)
  
near(1 / 49 * 49, 1)


# 5.2.2 -------------------------------------------------------------------
filter(flights, month == 11 | month == 12)

nov_dec <- filter(flights, month %in% c(11, 12))

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)


# 5.2.3 -------------------------------------------------------------------
NA > 5

10 == NA
    
NA + 10

NA / 2

NA == NA

x <- NA

y <- NA

x == y

is.na(y)

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)

filter(df, is.na(x) | x > 1)


# 5.2.4 -------------------------------------------------------------------
# 1
filter(flights, arr_delay >= 120)
filter(flights, dest %in% c("IAH", "HOU"))
filter(flights, carrier %in% c("UA", "DL", "AA"))
filter(flights, month %in% 7:9)
filter(flights, arr_delay >= 120 & dep_delay == 0)
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)       
filter(flights, dep_time >= 0 & dep_time <= 600)

# 2
# It can filter for values in a certain range.
filter(flights, between(arr_delay, 10, 60))

# 3
filter(flights, is.na(dep_time)) %>% 
  count(dep_time)
# Probably that the flight was delayed to another day.

# 4
x ^ 0 == 1
NA OR TRUE == TRUE
NA & FALSE == always FALSE


# 5.3 ---------------------------------------------------------------------
arrange(flights, desc(dep_delay))

df <- tibble(x = c(5, 2, NA))
arrange(df, x)

arrange(df, desc(x))


# 5.3.1 -------------------------------------------------------------------
# 1
arrange(flights, desc(is.na(dep_delay)))

# 2 
arrange(flights, desc(dep_delay))
arrange(flights, desc(dep_time))

# 3
flightsfastest <- flights %>% 
  mutate(mph = (distance/air_time)*60)

arrange(flightsfastest, desc(mph))

# 4
arrange(flights, desc(distance))
tail(arrange(flights, desc(distance)))


# 5.4 ---------------------------------------------------------------------
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

rename(flights, tail_num = tailnum)

select(flights, time_hour, air_time, everything())

# 5.4.1 -------------------------------------------------------------------
# 1
# One of those is...
select(flights, dep_time, dep_delay, arr_time, arr_delay)

# 2
# It will only get selected once.
select(flights, dep_time, dep_delay, dep_time)

# 3
# It will select the available variables in de the vector. Where select() gives
# an error if one of those aren't present.

# 4
select(flights, contains("TIME"))
# It ignores capitalisation. On the contrary:
select(flights, contains("TIME", ignore.case = FALSE))
# This yields no result.


# 5.5 ---------------------------------------------------------------------
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)

mutate(
  flights_sml, 
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60
)

mutate(
  flights_sml, 
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

transmute(
  flights,
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

transmute(
  flights,
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100
)

(x <- 1:10)
lag(x)
lead(x)
cumsum(x)
cummean(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# 5.5.2 -------------------------------------------------------------------
# 1
transmute(flights, dep_time_num = dep_time %/% 100 * 60 + dep_time %% 100)

# 2
# You would expect them to be the same. In other words, air_time = arr_time -
# dep_time. So lets check:
flights_compare <- flights %>% 
  transmute(
    dep_time_num = dep_time %/% 100 * 60 + dep_time %% 100,
    arr_time_num = arr_time %/% 100 * 60 + arr_time %% 100,
    air_time_diff = air_time - arr_time_num + dep_time_num,
    check = air_time == air_time_diff
    )
# It seems that time zones are messing up the data.

# 3
# We would expect these to be the same. So let's check again:
flights_dep <- flights %>% 
  mutate(
     dep_time_num = dep_time %/% 100 * 60 + dep_time %% 100,
     sched_num = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100,
     diff = sched_num + dep_delay - dep_time_num 
     ) %>% 
  select(dep_time_num, sched_num, dep_delay, diff)
# The difference is 1440 on the ones that aren't the same. 1440 minutes divided
# by 60 is 24. So 24 hour dirrence... has to day with arriving at or past mid-
# night.

# 4
flights_ranked <- flights %>% 
  transmute(dep_delay_rank = min_rank(desc(dep_delay)))

# 5
# The first set 1:3 gets recycled over the 1:10

# 6
# If I use ?Trig, I get the following:
cos(x)
sin(x)
tan(x)


# 5.6 ---------------------------------------------------------------------
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day) 
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))


# 5.6.1 -------------------------------------------------------------------
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
                   )

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE),
  ) %>% 
  filter(count > 20, dest != "HNL")


# 5.6.2 -------------------------------------------------------------------
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))
# Everthing gets coerced into NA.

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))
# Much better!

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))


# 5.6.3 -------------------------------------------------------------------
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay))

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE), n = n())

ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

batters %>% 
  arrange(desc(ba))


# 5.6.4 -------------------------------------------------------------------
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )
  
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(first_dep = first(dep_time), last_dep = last(dep_time))
  
not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled %>% 
  count(dest)

not_cancelled %>% 
  count(tailnum, wt = distance)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))


# 5.6.5 -------------------------------------------------------------------
daily <- group_by(flights, year, month, day)
(per_day <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year <- summarise(per_month, flights = sum(flights)))


# 5.6.6 -------------------------------------------------------------------
daily %>% 
  ungroup() %>% 
  summarise(flights = n())


# 5.6.7 -------------------------------------------------------------------
# 1
# Arrival delay is more important in the sense that is has more negavative
# consequences. A departure delay can be negated by arriving earlier, whereas a
# arrival can't.

# 2
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(n = length(dest))

not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(n = sum(distance))

# 3
# There is a dependency: if a flight doesn't depart, it doesn't arrive. So there
# is perhaps a double count going on. Also if flight crashes, with will become a
# cancelled flight

# 4
cancelledPerDay <- flights %>% 
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>% 
  group_by(year, month, day) %>% 
  summarise(cancelledNum = sum(cancelled), flightNum = n())

ggplot(data = cancelledPerDay) +
  geom_point(mapping = aes(x = flightNum, y = cancelledNum))
# It seems that cancelled flights increase when the numbers of flights go up.

cancelledProportion <- flights %>% 
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    cancelled_prop = mean(cancelled)
  ) %>% 
  ungroup()

ggplot(cancelledProportion) +
  geom_point(aes(x = avg_dep_delay, y = cancelled_prop))

ggplot(cancelledProportion) +
  geom_point(aes(x = avg_arr_delay, y = cancelled_prop))
#There is a increase in delay if ther are more flights!

# 5
worstCarrier <- flights %>% 
  group_by(carrier) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% 
  arrange(desc(delay))

# 6
# It sorts on highest count.


# 5.7 ---------------------------------------------------------------------
flights_sml <-flights %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dest <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dest

popular_dests <- flights %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

# 5.7.1 -------------------------------------------------------------------
# 1
# mean() The mean is calculated by group
# sd() The sd is calculated by group
# min() This gives the smallest value within the group
# max() This gives the hightest value within the group

# 2
worstTailnum <- flights %>% 
  filter(!is.na(tailnum), arr_delay <= 0) %>% 
  group_by(tailnum) %>% 
  summarise(time = mean(arr_delay)) %>% 
  arrange(desc(min_rank(time)))

# 3
bestTime <- flights %>% 
  group_by(hour) %>% 
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>% 
  arrange(arr_delay)
# The best time to fly is in the morning betwee 5 and 9.

# 4
totalDelay <- flights %>%
  filter(arr_delay > 0) %>% 
  group_by(dest) %>% 
  mutate(
    arr_delay_tot = sum(arr_delay),
    arr_delay_prop = arr_delay / arr_delay_tot
    ) %>% 
  select(dest, flight, arr_delay, arr_delay_prop) %>% 
  arrange(desc(arr_delay_prop))

# 5
lagged <- flights %>% 
  arrange(origin, month, day, dep_time) %>% 
  group_by(origin) %>% 
  mutate(dep_delay_lag = lag(dep_delay)) %>% 
  filter(!is.na(dep_delay), !is.na(dep_delay_lag))

# 6
fastestFlights <- flights %>% 
  filter(!is.na(air_time)) %>% 
  mutate(speed = distance / air_time * 60) %>% 
  select(flight, speed) %>% 
  arrange(desc(speed))
  
# 7
destByTwo <- flights %>% 
  group_by(dest) %>% 
  mutate(unique_carriers = n_distinct(carrier)) %>% 
  filter(unique_carriers > 1) %>% 
  group_by(carrier) %>% 
  summarize(n_dest = n_distinct(dest)) %>% 
  arrange(desc(n_dest))

# 8
oneHourDelay <- flights %>% 
  select(tailnum, year, month, day, dep_delay) %>% 
  filter(!is.na(dep_delay)) %>% 
  arrange(tailnum, year, month, day) %>% 
  group_by(tailnum) %>% 
  mutate(cumHours = cumsum(dep_delay > 60)) %>% 
  summarise(totalFlights = sum(cumHours < 1)) %>% 
  arrange(totalFlights)

