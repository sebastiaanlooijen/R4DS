# Chapter12.R - all the exercises and examples from chapter 12 of R4DS.

# Packages ----------------------------------------------------------------
library(tidyverse)

# 12.2.1 ------------------------------------------------------------------
# 1
# Table1
# This table has tidy data. Columns are variables, rows are observations, and
# each cell is a data point.

# Table2
# The column type contains variable names, so this data isn't tidy.

# Table3
# The column rate contains two values, ideally those should be split of you want
# To do some calculations on it.

# Table4ab
# The variables 1999 and 2000 are observations, those should be in variable 
# named year, and merged in to one table.

# 2
table2tidy <- table2 %>% 
  pivot_wider(names_from = type, values_from = count) %>% 
  mutate(rate = (cases / population) * 10000)

table4atidy <- table4a %>%
  pivot_longer(c(`1999` , `2000`), names_to = "year", values_to = "cases")
  
table4btidy <- table4b %>%
  pivot_longer(c(`1999` , `2000`), names_to = "year", values_to = "population")
 
table4tidy <- table4atidy %>% 
  right_join(table4btidy) %>% 
  mutate(rate = (cases / population) * 10000)

# 3
table2tidy <- table2 %>% 
  pivot_wider(names_from = type, values_from = count) %>% 
  mutate(rate = (cases / population) * 10000) %>% 
  ggplot(aes(year, cases)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country))
# ggplot2 doesn't work good if you don't have a tidy data.


# 12.3 --------------------------------------------------------------------
table4a %>%
  pivot_longer(c(`1999` , `2000`), names_to = "year", values_to = "cases")

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

tidy4a <- table4a %>%
  pivot_longer(c(`1999` , `2000`), names_to = "year", values_to = "cases")

tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

left_join(tidy4a, tidy4b)


# 12.3.2 ------------------------------------------------------------------
table2 %>%
  pivot_wider(names_from = type, values_from = count)


# 12.3.3 ------------------------------------------------------------------
# 1
# This because some of variables are combine or split apart in seperate
# variables. So placing them back isn't always possible.

# 2
# The names of the number variables should be encased in ``.

# 3
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

peopleTidy <- people %>% 
  pivot_wider(names_from = "names", values_from = "values")
# Since Philip has two age entries, double values are turned in to lists.
# You could merge two variables to make a variable unique.

# 4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

pregTidy <- preg %>% 
  pivot_longer(
    c("male", "female"), 
    names_to = "gender", 
    values_to = "count"
  ) %>%
  select(gender, pregnant, count)


# 12.4 --------------------------------------------------------------------
table3 %>% 
  separate(rate, into = c("cases", "population"))

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = 2)

# 12.4.2 ------------------------------------------------------------------
table5 %>% 
  unite(new, century, year)

table5 %>% 
 unite(new, century, year, sep = "") 

# 12.4.3 ------------------------------------------------------------------
# 1
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")
# It add the values it can place to another cell.

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")
# It fills the empty cells with a NA.

# 2
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")

# 3
# If this is set to FALSE, a new variable will be created.

# 4
# With extract() and seperate() you can select one column, and use different 
# methods to seperate the values. With unite() you can select multiple columns 
# and unite them.


# 12.5 --------------------------------------------------------------------
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`),
    names_to = "year",
    values_to = "return",
    values_drop_na = TRUE
  )

stocks %>%
  complete(year, qtr)

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>% 
  fill(person)


# 12.5.1 ------------------------------------------------------------------
# 1
#?fill
#?pivot_wider
#?complete

# 2
# This is the direction from which the values are copied and pasted. The value
# above it, beneath it, under it, etc.


# 12.6 --------------------------------------------------------------------
who1 <- who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65,
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  )

who1 %>% 
  count(key)

who2 <- who1 %>% 
  mutate(names_from = stringr::str_replace(key, "newrel", "new_rel"))

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")

who3 %>% 
  count(new)

who4 <- who3 %>% 
  select(-new, -iso2, -iso3)

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)

who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)


# 12.6.1 ------------------------------------------------------------------
# 1
# If it's reasonable depends on how NA are represented in de dataset.
# There are 0's in the dataset, so using the technique to filter NA's sees
# reasonable to me.

# 2
# If we leave that out the variables do not match in name, and we can't check
# if all the observations have "new" in them, which we can't subsequently drop
# the variable since it's redundant.

# 3
whoTidy <- who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(country, iso2, iso3) %>%
  distinct() %>%
  group_by(country) %>%
  filter(n() > 1)
# The are indeed redundant.

# 4
who5 %>%
  group_by(country, year, sex) %>%
  filter(year > 1995) %>%
  summarise(cases = sum(cases)) %>%
  unite(country_sex, country, sex, remove = FALSE) %>%
  ggplot(aes(x = year, y = cases, group = country_sex, colour = sex)) +
  geom_line()