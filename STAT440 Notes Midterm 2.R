library(tidyverse)
library(DBI)

jail_data <- read_delim('https://uofi.box.com/shared/static/ao2osc2my46133rcvmb5re55fvge5275', delim = '&')

str(jail_data)
# "The Champaign County Sheriff Office Jail Data contains 11082 observations 
# and 40 columns for individuals who were booked into jail in Champaign County Jail 
#in year 2019. The rows are considered bookings. Each person is uniquely identifiable 
#by their jacket number. Each booking is uniquely identifiable by its booking number. 
#Some rows in the data appear more than once because of multiple crimes being assigned 
#to one booking. There is also the possibility that some people are recidivists meaning 
#they are booked into jail at more than one date-time. The demographics of the people, 
#reasons for being booked, and crime code are also given in the data. The original 
#source is the Champaign County Sheriff Office & Jail (CCSO)."

jail_data01 <- jail_data %>%
  mutate(
    booking_date = mdy(booking_date),
    released_date = mdy(released_date)
  )
nrow(jail_data01)
#q1
# Beginning with jail_data and using SQL via R, write a query that returns the people 
# who were booked for more than one crime.


con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = 'root',
  password = 'N3jF14nabak8nf02jk',
  host = 'localhost',
  dbname = 'sakila'
)
dbWriteTable(con, "ccso_jail01", jail_data01, overwrite = TRUE) # load the data into the database

# find all the length of the first name
dbGetQuery(con, 'SELECT LENGTH(First_name) AS nchar FROM ccso_jail01')
# LIKE function
dbGetQuery(con, 'SELECT First_name 
           FROM ccso_jail01 
           WHERE First_name LIKE "B%" 
           LIMIT 10')
# or return 0&1 by putting LIKE function int the beginning
dbGetQuery(con, 'SELECT First_name LIKE "B%"
           FROM ccso_jail01
           LIMIT 10')

# use regext to find all first name not start with vowels
dbGetQuery(con, 'SELECT First_name 
           FROM ccso_jail01 
           WHERE First_name 
           REGEXP "^[^AEIOU]" 
           LIMIT 10')
# use REGEXP_SUBTR
dbGetQuery(con, 'SELECT First_name
           REGEXP_SUBSTR(Last_name, "[A-Z]+//-[A-Z]+" AS nchar 
           FROM ccso_jail01')

# replace
dbGetQuery(con, 'SELECT REPLACE (First_name, First_name, LAST_name) FROM ccso_jail01')

#CASE WHEN
dbGetQuery(con, 'SELECT Last_name CASE WHEN Last_name LIKE "WILL%" THEN "WILL-FM" 
WHEN Last_name LIKE "JACK%" THEN "JACK-FM" FROM ccso+jail01')

#CAST() function, change the date_value AS date fpr,at
# STR_TO_DATE("string01, "%date %format %code")
dbGetQuery(con, 'SELECT 
           CAST(CONCET(str_to_date(booking_date, "m%/d%/y%"), " ", booking_time) AS DATETIME)) 
           FROM ccso_jail01')
