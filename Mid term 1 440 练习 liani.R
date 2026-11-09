
#1. Find a JSON data file online and load it into R, either via local download or URL. (5 min)
library(jsonlite)
library(tidyverse)

users_raw <- fromJSON('https://jsonplaceholder.typicode.com/users', flatten = TRUE)
users <- as_tibble(users_raw)
#2. Print the column names of the data frame. (2 min)
colnames(users)

#3. Print the first 10 rows, with all columns visible. (2 min)
head(users, 10)
#4. Prusers4. Print the mode() of each column. (1 min)
sapply(users, mode)

# 5. Print the typeof() or class() of each column. (1 min)
sapply(users, class)
sapply(users, typeof)
# 6. Pick one character-valued column and truncate the strings to keep only the first 2 characters. (3 min)
colnames(users)
users1 <- users %>% mutate(`new col` = str_extract(users$name, '\\w\\w'))
view(users1)

users <- users %>%
  mutate(name_short = str_sub(name, 1, 2))

#7. Create a new numeric column representing the character length of one character-valued column. (3 min)
users7 <- users %>% mutate(`new str length` = str_length(users$name))
view(users7)

#Week 4 Mon

# Extract the data from https://jsonplaceholder.typicode.com/users into a tibble named users. Nested columns must be flattened.
# Print the structure of users, then answer the following as # comments:
# (a) Are there any logical mode columns?
str(users) #No
 # (b) Which columns look numeric but are actually character? Why does that matter for later analysis?
# phone number, latitude and longtitude  

# (c) Separate address.zipcode into two new columns, zip5 and zip4. Write working code and explain why the fill argument is needed.
colnames(users)
view(users)

userswww <- users %>%separate(address.zipcode, into = c('Zip4','Zip5'), sep = '-', fill = 'right')
view(userswww)
users_str <- users %>%
  mutate(
    zip5 = str_extract(address.zipcode, "^\\d+"),
    zip4 = str_extract(address.zipcode, "(?<=-)\\d+")
  )     
view(users_str)
#(d) What might we do to parse the company.catchPhrase column consistently?

# Slice the data frame to show only the first 3 rows. Give two different ways to do it.
usersslice <- users %>% slice(1:3) #or slice_head(n = 3)
usersslice <- users %>% slice_head(n=3)
head(usersslice)
# Filter the data frame to show only the rows where the company name contains "romaguera".
#The match should not depend on case. Then answer in a comment: how many rows would tolower(company.name) == "romaguera" return, and why?
usersw4b <- users %>% filter(str_detect(tolower(`company.name`), 'romaguera'))
view(usersw4b)
colnames(users)

 ### Run this setup line first: 
users_dup <- bind_rows(users, slice(users, 3)). 
### Run this setup line first: 
users_na <- users |> mutate(website = if_else(id %% 3 == 0, NA, website)). Drop missing values from the website column. Then convert address.geo.lat to numeric, sort the result in decreasing order of latitude, and print the structure of the resulting data frame.
# Organize the columns so that numeric mode columns come first, then character mode columns, then logical mode columns.
# Slice and print a random set of 5 rows. Sample without replacement, and let R make the selection, not you.
usersw4c <- users %>% slice_sample(n = 5)
view(usersw4c)
#Is your work reproducible? If not, edit your solutions so that they are.
#In a comment, say which line set.seed() should go on and why.
# Reorder columns: numeric first, then character, then logical
users_reordered <- users %>%
  select(where(is.numeric), where(is.character), where(is.logical))

#week4 wed
#Extract the data from https://jsonplaceholder.typicode.com/users into a tibble named users. Nested columns must be flattened.
#Print the structure of users, then answer as # comments:
#(a) Are there any compound columns? 
#Name at least three, and say which singular columns each one would be best separated into.
str(users)
#Yes there are compound columns. For example:
  - name
- address street
- address suite
- the company.bs
#(b) How do you feel about the way the data is currently organized?
 # Is it wide or long, and does the column naming help or hurt?
great
#Filter out any row where name is not a plain "First Last" value (exactly two words, letters only).
user_clean <- users %>% filter(str_detect(address.street, '^[A-Za-z]+ [A-Za-z]+$'))
view(user_clean)
str(user_clean)

#Store the result as users_clean and print the structure. 
#In a comment, say how many rows were removed and which ones.

#Beginning with users_clean, keep only id, name, address.geo.lat, and address.geo.lng. 
#Then reshape the data so the result has more rows than columns: 
# pivot the two coordinate columns into a single column named coord and their values
#into a single column named value. The coord column should contain just lat or lng, 
#not the address.geo. prefix. Format value as a proper numeric column. 
#Store the result as users_geo and print the structure.
view(user_clean)
users_geo <- user_clean %>% select(id, name, address.geo.lat, address.geo.lng) %>%
  pivot_longer(
    cols = c(address.geo.lat, address.geo.lng),
    names_to = 'coord',
    values_to = 'value',
    names_prefix = "address.geo."
    )
view(users_geo)

#(a) If there are any duplicate rows in users_geo, print them. 
users_geo_duplicates <- users_geo %>%
  filter(duplicated(.)|duplicated(., fromLast = TRUE))
view(users_geo_duplicates)
#(b) Are there any duplicated values in the id column of users_geo? In a comment, explain why the answers to (a) and (b) differ.
#Beginning with users_geo, keep only the rows where coord is lat. 
#Remove the coord and name columns, then add a column retrieved containing today's date.
#Store the result as users_lat and print the structure.

users_lat <- users_geo %>%
#Beginning with users_lat, add a new row with these values: id = nrow(users_lat) + 1, value = the latitude of Urbana, IL (40.1106), retrieved = Sys.Date(). Store the result as users_lat_urbana and print the last 3 rows.
#Is your work reproducible? If not, edit your solutions so that they are. In a comment, name two separate things in this assignment that could make the output differ if someone runs it next month.
#Write a new function in R named rev_words that reverses the order of the words in a character string (assume the input has length 1). For example, rev_words('Leanne Graham') should return 'Graham Leanne'. Use base R functions only, such as strsplit(), rev(), and paste(). Then answer in a comment: what happens if you call rev_words(users$name), and why? Bonus: apply it correctly to every row of users.

# week4 fri
 #Extract the data from https://jsonplaceholder.typicode.com/users into a tibble named users, with nested columns flattened. Then write a short data dictionary as # comments for these five columns: id, name, address.zipcode, address.geo.lat, company.name. For each column, give its R type and a one-line description of what it means. Run this setup code before continuing:
r
users_ts <- users |>
  mutate(signup = c('2011-Mar-05 14:30', '2013-Dec-31 23:59', '2010-Jan-15 08:00',
                    '2012-Jul-04 12:00', '2014-Feb-28 09:15', '2011-Feb-30 18:45',
                    '2013-Jan-01 00:05', '2009-Nov-20 07:30', '2012-Feb-29 16:20',
                    '2015-Jun-30 11:11'),
         signup_date = str_sub(signup, 1, 11))

#Beginning with users_ts, format signup as a date-time column and signup_date as a date column. 
#Store the result as users2 and print the structure. 
# In a comment, answer: did any value fail to parse? Which one, and why? 
#What does R put in its place?
users2 <- users_ts %>% 
  mutate(signup = ymd_hm(signup), signup_date = ymd(signup_date)
    )


#   #Beginning with users2, keep only the users in the southern hemisphere (latitude below 0) whose signup_date year is 2011, 2012, or 2013. Sort from newest to oldest signup_date, store the result as users3, and print it. Do this two ways:
#   (a) using the parsed date column, and
# (b) using string matching on the original character column from users_ts.
users3_b <- users_ts %>%
  mutate(lat_num = as.numeric(address.geo.lat)) %>%
  filter(
    lat_num > 0,
    str_detect(signup_date, '^2011|2012|2013'))%>%
      arrange(desc(signup_date))

# # In a comment, say whether (a) and (b) return the same number of rows, and explain why or why not.
# # Among the 5 users closest to the prime meridian 
# (the smallest absolute longitude), how far from the equator is the one farthest from it?
#   Add two columns: km_from_equator (1 degree of latitude ≈ 111 km) and mi_from_equator 
# (1 km = 0.62137 mi). Keep only id, name, the two coordinates, and the two distance columns.
# The result should contain only the row(s) that answer the question. 
# Store the result as users4 and print it.