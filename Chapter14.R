# Chapter14.R - all the exercises and examples from chapter 14 of R4DS.

# Packages ----------------------------------------------------------------
library(tidyverse)


# 14.2 --------------------------------------------------------------------
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single qoute'

double_quote <- "\""
single_quote <- '\''

x <- c("\"", "\\")
writeLines(x)

x <- "\u00b5"
writeLines(x)

c("one", "two", "three")


# 14.2.1 ------------------------------------------------------------------
str_length(c("a", "R for Date Science"))


# 14.2.2 ------------------------------------------------------------------
str_c("x", "y")
str_c("x", "y", "z")

str_c("x", "y", sep = ", ")

x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x),"-|")

str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ",
  time_of_day,
  "",
  if(birthday) " and HAPPY BIRTHDAY",
  "."
  )

str_c(c("x", "y", "z"), collapse = ",")


# 14.2.3 ------------------------------------------------------------------
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 2)
str_sub(x, -3, -1)

str_sub("a", 1, 5)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))


# 14.2.4 ------------------------------------------------------------------
str_to_upper(c("i","ı"))
str_to_upper(c("i", "ı"), locale = "tr")

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")
str_sort(x, locale = "haw")


# 14.2.5 ------------------------------------------------------------------
# 1
# paste() and paste0() both concatenate text, however paste0 doesn't have a
# "sep" argument. The str_c function is the tidyverse equivalent. Missing values
# are converted to the string "NA". str_c keeps them at NA.

# 2
# sep = the element which separates every term.
# collapse = the element which separates every term.

# 3
name <- "Barack"
middleLetter <- round(median(1:str_length(name)))
str_sub(name, middleLetter, middleLetter)
# I have chosen to round the number to nearest integer.

# 4
# It wraps strings into nicely formatted paragraphs. This is especially helpful
# when you are doing a summary of values.

# 5
# Removes whitespace from start and end of string. The oppostie is str_pad().

# 6
exerciseSix <- function(x) {
  n <- length(x)
  if (n == 0) {
    ""
  } else if (n == 1) {
    x
  } else if (n == 2) {
    str_c(x[[1]], " and ", x[[2]])
  } else {
    str_c(x[[1]], ", ", x[[2]], " and ", x[[3]]) 
  }
}


# 14.3.1 ------------------------------------------------------------------
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

dot <- "\\."
writeLines(dot)
str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")


# 14.3.1.1 ----------------------------------------------------------------
# 1
# You need one extra '\' to escape. The first is too short, the second correct,
# and the third is too long.

# 2
expressionTwo <- "\"\'\\"
writeLines(expressionTwo)

# 3
expressionThree <- "\\..\\..\\.."
writeLines(expressionThree)


# 14.3.2 ------------------------------------------------------------------
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")


# 14.3.2.1 ----------------------------------------------------------------
# 1
expressionOne <- "\"$^$\""
writeLines(expressionOne)

# 2
str_view(words, "^y", match = TRUE)
str_view(words, "x$", match = TRUE)
str_view(words, "^...$", match = TRUE)
str_view(words, ".......", match = TRUE)


# 14.3.3 ------------------------------------------------------------------
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")
str_view(c("grey", "gray"), "gr(e|a)y")


# 14.3.3.1 ----------------------------------------------------------------
# 1
# 1
str_subset(words, "^[aeiou]")

# 2
str_subset(words, "^[^aeiou]+$")

# 3
str_subset(words, "[^e]ed$")

# 4
str_subset(words, "i(ng|se)$")


# 14.3.4.1 ----------------------------------------------------------------
# 1
#? - {0, 1} - match at most 1
#+ - {1,} - match 1 or more
#* - {0,} - match 0 or more

# 2
# 1
# This will match anything.
# 2
# Between curly brackets, and at least one character.
# 3
# This will match 2 digits, followed by an hyphen, 4 digits, hyphen, 2 digits.
# 4
# 2 backslashes, curly bracket, 4, curly bracket.

# 3
# 1
str_view(words, "^[^aeiou]{3}", match = TRUE)
# 2
str_view(words, "[aeiou]{3,}", match = TRUE)
# 3
str_view(words, "([aeiou][^aeiou]){2,}", match = TRUE)
  

# 14.3.5 ------------------------------------------------------------------
str_view(fruit, "(..)\\1", match = TRUE)


# 14.3.5.1 ----------------------------------------------------------------
# 1
# a: This matches the same character three times in a row.
# b: A pair of characters followed by the same in reverse order.
# c: Any two characters repeated.
# d: Original character, followed by any, original, any, original.
# e: Three characters followed by zero or more characters of any kind followed
# by the same three characters but in reverse order.
  
# 2
# a 
str_subset(words, "^(.)(.*\\1$)")

# b
str_subset(words, "(..).*\\1")

# c
str_subset(words, "(.).*\\1.*\\1")


# 14.4.1 -------------------------------------------------------------------
x <- c("apple", "banana", "pear")
str_detect(x, "e")

sum(str_detect(words, "^t"))
mean(str_detect(words, "[aeiou]$"))

no_vowels_1 <- !str_detect(words, "[aeiou]")
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

words[str_detect(words, "x$")]
str_subset(words, "x$")

df <- tibble(
  word = words,
  i = seq_along(word)
) 

df %>% 
  filter(str_detect(word, "x$"))

x <- c("apple", "banana", "pear")
str_count(x, "a")

mean(str_count(words, "[aeiou]"))

df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

str_count("abababa", "aba")
str_view_all("abababa", "aba")


# 14.4.1.1 ----------------------------------------------------------------
# 1
  # 1
words[str_detect(words, "^x|x$")]
start_with_x <- str_detect(words, "^x")
end_with_x <- str_detect(words, "x$")
words[start_with_x | end_with_x]

  # 2
str_subset(words, "^[aeiou].*[^aeiou]$")
start_with_vowel <- str_detect(words, "^[aeiou]")
end_with_consonant <- str_detect(words, "[^aeiou]$")
words[start_with_vowel & end_with_consonant]

# 2
vowels <- str_count(words, "[aeiou]")
words[which(vowels == max(vowels))]


# 14.4.2 ------------------------------------------------------------------
length(sentences)
head(sentences)

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)

more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)

str_extract(more, colour_match)

str_extract_all(more, colour_match)
str_extract_all(more, colour_match, simplify = TRUE)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)


# 14.4.2.1 ----------------------------------------------------------------
# 1
colour_match_boundaries <- str_c("\\b(", str_c(colours, collapse = "|"), ")\\b")

# 2
  # 1
str_extract(sentences, "[A-Za-z]+")

  # 2
words_with_ing <- str_extract(sentences, "\\b[A-Za-z]+ing\\b")
words_with_ing <- words_with_ing[!is.na(words_with_ing)]

  # 3
plurals <- str_extract(sentences, "\\b[A-Za-z]{3,}s\\b")
plurals <- plurals[!is.na(plurals)]


# 14.4.3.1 ----------------------------------------------------------------
# 1
numbers <- "\\b(one|two|three|four|five|six|seven|eight|nine|ten) +(\\w+)"
has_numbers <- sentences %>% 
  str_subset(numbers) %>% 
  str_extract(numbers)

# 2
contractions <- "([A-Za-z]+)'([A-Za-z]+)"
has_contraction <- sentences %>% 
  str_subset(contractions) %>% 
  str_extract(contractions) %>% 
  str_split("'")

#TODO: 14.5
