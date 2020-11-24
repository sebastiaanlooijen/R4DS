# Chapter11.R - all the exercises and examples from chapter 11 of R4DS.

# Packages ----------------------------------------------------------------
library(tidyverse)
library(hms)
library(feather)

# 11.2 --------------------------------------------------------------------
read_csv("a,b,c 
          1, 2, 3 
          4, 5, 6")

read_csv("The first line of metadata
          The second line of metadata
          x, y, z
          1, 2, 3", skip = 2)

read_csv("# A comment I want to skip
          x, y, z
          1, 2, 3", comment = "#")

read_csv("1, 2, 3\n4, 5, 6", col_names = FALSE)

read_csv("1, 2, 3\n4, 5, 6", col_names = c("x", "y", "z"))

read_csv("a, b, c\n1, 2, .", na = ".")


# 11.2.2 ------------------------------------------------------------------
# 1
# That is used for a Delimiter Seperated Values or DSV. Nobody really uses that.

# 2
# quote = "\"", 

# 3
# The length of every field.

# 4
quote = ""

# 5
read_csv("a,b\n1,2,3\n4,5,6") # only two columns with one row of data.
read_csv("a,b,c\n1,2\n1,2,3,4") # only two colums with one row of data.
read_csv("a,b\n\"1") # produces a NA because there aren't enough data points.
read_csv("a,b\n1,2\na,b") # This works.
read_csv("a;b\n1;3") # This produces one column with a;b in it. Incorrect sep.


# 11.3 --------------------------------------------------------------------
str(parse_logical(c("TRUE", "FALSE", NA)))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))
      
parse_integer(c("1", "231", ".", "456"),  na = ".")
x <- parse_integer(c("123", "355", "abc", "123.45"))
problems(x)


# 11.3.1 ------------------------------------------------------------------
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

parse_number("$123,456,789")
parse_number("123.456.789", locale = locale(grouping_mark = "."))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))


# 11.3.2 ------------------------------------------------------------------
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))
    
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))


# 11.3.3 ------------------------------------------------------------------
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananan"), levels = fruit)


# 11.3.4 ------------------------------------------------------------------
parse_datetime("2010-10-01T2010")
parse_datetime("20101019")
parse_date("2010-10-01")

parse_time("01:10 am")
parse_time("20:10:01")

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")


# 11.3.5 ------------------------------------------------------------------
# 1
# As far as I am concerned, the decimal_mark and grouping_mark.

# 2
parse_number(
  "123,456,789", 
  locale = locale(
    grouping_mark = ",",
    decimal_mark = ","
    )
  )
# There is an error that these should be different. 

parse_number(
  "123,456,789", 
  locale = locale(
    decimal_mark = ","
    )
  )
# The grouping_mark gets turned to ".".

parse_number(
  "123,456,789", 
  locale = locale(
    grouping_mark = ","
    )
  )
# The decimal_mark gets turned to ".".

# 3
# They change the default time and date formats.
parse_date("1 januari 2010", "%d %B %Y", locale = locale("nl"))

# 4
nl_locale <- locale(date_format = "%d/%m/%Y")

# 5
# read_csv2 reads csv files that are seperated by ";".

# 6
# UTF-8 is mostly used in the EU.

# 7
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")
parse_time(t1, "%H%M")
parse_time(t2, "%H:%M:%OS %p") 


# 11.4.1 ------------------------------------------------------------------
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))
str(parse_guess("2010-10-10"))


# 11.4.2 ------------------------------------------------------------------
challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
tail(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_logical()
  )
)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
tail(challenge)


# 11.4.3 ------------------------------------------------------------------
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)

challenge2 <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(.default = col_character())
  )

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df
type_convert(df)


# 11.5 --------------------------------------------------------------------
write_csv(challenge, "challenge.csv")

write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")