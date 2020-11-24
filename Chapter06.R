# Chapter06.R - all the exercises and examples from chapter 6 of R4DS.

# Packages ----------------------------------------------------------------
library(dplyr)
library(nycflights13)


# 6.1 ---------------------------------------------------------------------
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled <- flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))