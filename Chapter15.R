# Chapter15.R - all the exercises and examples from chapter 15 of R4DS.

# Load packages -----------------------------------------------------------
library(tidyverse)

# 15.2 --------------------------------------------------------------------
x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

y1 <- factor(x1, levels = month_levels)
sort(y1)
y2 <- factor(x2, levels = month_levels)
sort(y2)

factor(x1)

f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>% factor() %>% fct_inorder()
f2

levels(f2)

# 15.3 --------------------------------------------------------------------
gss_cat %>% 
  count(race)

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

# 15.3.1 ------------------------------------------------------------------
# 1
ggplot(gss_cat, aes(rincome)) +
  geom_bar()
# the categories have a substantial size difference in population. The bigger
# categories make the smaller ones illegible. It can be improved by dropping NA,
# and deleting the categories who say as much.

# 2
gss_cat %>% 
  count(relig, sort = TRUE)
# Protestant

gss_cat %>% 
  count(partyid, sort = TRUE)
# Indepedent

# 3
gss_cat %>%
  count(relig, denom, sort = TRUE)

ggplot(gss_cat, aes(x = relig, fill = denom)) +
  geom_bar(position = "dodge")
# Protestant

# 15.4 --------------------------------------------------------------------
relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()

ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

# 15.4.1 ------------------------------------------------------------------
# 1
# No, the means is very senstive to high numbers.

# 2
# year, age, rincome, tvhours: principled.
# marital, race, partyid, relig, denom: arbitrary.

# 3
# It will be the first category plotted.

# 15.5 --------------------------------------------------------------------
gss_cat %>% count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(
    partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(
    partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_collapse(
    partyid,
    other = c("No answer", "Don't know", "Other party"),
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Independent", "Ind,near dem"),
    dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)

# 15.5.1 ------------------------------------------------------------------
# 1
gss_summary <- gss_cat %>%
  mutate(
    partyid = fct_collapse(
      partyid,
      other = c("No answer", "Don't know", "Other party"),
      rep = c("Strong republican", "Not str republican"),
      ind = c("Ind,near rep", "Independent", "Ind,near dem"),
      dem = c("Not str democrat", "Strong democrat")
    )
  ) %>%
  count(year, partyid) %>% 
  group_by(year) %>% 
  summarise(prop = n / sum(n))

# 2
gss_rincome <- gss_cat %>% 
  mutate(rincome = fct_collapse(
    rincome,
    `Unknown` = c("No answer", "Don't know", "Refused", "Not applicable")
  ))