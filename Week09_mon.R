library(tidyverse)
library(RMariaDB)

#
url <- 'https://uofi.box.com/shared/static/yuebypinh5vue62kh674yo7xy4qvkb5u'
jail_data <- read_delim(url, delim = '&')
View(jail)

library(DBI)

#q1
#rename to lower case
jail_data <- jail_data %>% rename_with(~tolower(.x))
#over write booking date and released date into date mode
jail_data <- jail_data %>% mutate(
  booking_date = mdy(booking_date),
  released_date = mdy(released_date)
)
#overwrite jacket_number and booking_number into character
jail_data <- jail_data %>% mutate(
  jacket_number = as.character(jacket_number),
  booking_number = as.character(booking_number)
)
con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = "root", 
  password = 'N3jF14nabak8nf02jk', 
  host = "localhost", 
  dbname = "sakila")

dbWriteTable(con, "ccso_jail", jail_data, overwrite = TRUE)

# #q3 remove na or null value in the released_date

# # Using ccso_jail and SQL via R, remove any NA or NULL values of released_date.
# Now, create a query that mutates the data with two new columns named
# "booking_date_time" and "released_date_time". Booking_date_time is the
# concatenation of the booking_date and booking_time columns.
# Released_date_time is the concatenation of the released_date and released_time columns.
# These new columns must be proper DATETIME types.
dbGetQuery(con, 'SELECT *, CAST(CONCAT(booking_date," ", booking_time) AS DATETIME) AS booking_date_time,
           CAST(CONCAT(released_date, " ", released_time) AS DATETIME) AS released_date_time
           FROM ccso_jail
           WHERE released_date IS NOT NULL
           
           
           ')
#q4 summarize the result so that there's one row for each column
# crime column collapsing in one row for each jacket number
# second column is the n_crime which is the distinct crime per jacket number

dbGetQuery(con, 'SELECT jacket_number, GROUP_CONCAT(DISTINCT crime) AS crime_list, COUNT(DISTINCT crime) AS n_crime
           FROM ccso_jail
           GROUP BY jacket_number
           LIMIT 10
           
           
           ')

#q5 what is wrong with the code given
dbGetQuery(con, '
SELECT arrest_agency, COUNT(arrest_agency) OVER() AS n_of_each_arrest_agency, COUNT(arrest_agency)/SUM(COUNT(arrest_agency)) OVER() AS percent
FROM (SELECT *, CONCAT(first_name, " " , last_name) AS full_name 
      FROM ccso_jail  
      WHERE arrest_agency IS NOT NULL) 
GROUP BY arrest_agency
ORDERBYpercent
;')

# ORDER BY needs to be separated
# percent alias need to *100
# the subquery in the FROM function needs an alias

# correct it
dbGetQuery(con, '
SELECT arrest_agency, COUNT(arrest_agency) AS n_of_each_arrest_agency, 100*COUNT(arrest_agency)/SUM(COUNT(arrest_agency)) OVER() AS percent
FROM (SELECT *, CONCAT(first_name, " " , last_name) AS full_name 
      FROM ccso_jail  
      WHERE arrest_agency IS NOT NULL) AS d1
GROUP BY arrest_agency
ORDER BY percent
;')
