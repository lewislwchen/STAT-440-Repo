library(tidyverse)
library(RMariaDB)
# Extract the Champaign County Sheriff Office Jail Data provided by Champaign County 
# Sheriff Office Jail Data and State of Illinois as a data frame or tibble in R. 
# Using tidyverse methods or base R methods:
url <- 'https://uofi.box.com/shared/static/itpy8hgv5n9bbf13ux48uw83z9nld1up'

jail <- read_delim(url, delim = '&')

View(jail)
#   overwrite the booking_date and released_date columns to be proper date modes in R
jail <- jail %>% 
  mutate(
    booking_date = dmy(booking_date),
    released_date = dmy(released_date)
  )
str(jail)

# overwrite the jacket_number and booking_number columns to be character modes in R

jail <- jail %>% 
  mutate(
    jacket_number = as.character(jacket_number),
    booking_number = as.character(booking_number)
  )
str(jail)

# rename all columns to be lower case
jail <- jail %>%
  rename_with(lowercase)

# store the resulting set as jail_data
jail_data <- jail
# A brief data description is below and may be helpful for understanding the data.

# "The Champaign County Sheriff Office Jail Data contains 11082 observations 
# and 40 columns for individuals who were booked into jail in Champaign County Jail 
# in year 2019. The rows are considered bookings. Each person is uniquely
# identifiable by their jacket number. 
#v Each booking is uniquely identifiable by its booking number. 
#Some rows in the data appear more than once because of multiple crimes being 
#assigned to one booking. There is also the possibility that some people are 
#recidivists meaning they are booked into jail at more than one date-time. 
# The demographics of the people, reasons for being booked, and crime code are 
# also given in the data. The original source is the Champaign County Sheriff
# Office & Jail (CCSO)."

# Q2
# Using SQL via R, run the following line of code to load the data into the sakila database. 
# The object con is the connection you made to the sakila database in problem 2 (above).
# 

con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = 'root',
  password = 'N3jF14nabak8nf02jk',
  host = 'localhost',
  dbname = 'sakila'
)
dbWriteTable(con, "ccso_jail", jail, overwrite = TRUE)

# Q3
#Beginning with ccso_jail and using SQL via R, write a query that answers the question:
# Which people (if any) may have a potentially mistaken identity? 
# Meaning, which people have the same name but different jacket_number values.

# COUNT() in sql take duplicates, therefore the DISTINCT command is necessary
dbGetQuery(con, 'SELECT DISTINCT CONCAT(First_name," ", Last_name) AS full_name, COUNT(DISTINCT jacket_number)
           FROM ccso_jail
           GROUP BY full_name
           HAVING COUNT(DISTINCT jacket_number) > 1
           ')

# Q4
#Beginning with ccso_jail and using SQL via R, write a query transforms the 
# crime column values to be collapsed for each combination of jacket_number and booking_number. 
# Thus, number of unique rows is the same as number of unique booking_number values. 
# Validate (i.e. verify) the resulting set makes sense based on the jacket_number 
# equals to 17377.

dbGetQuery(con, 'SELECT jacket_number, booking_number, GROUP_CONCAT(crime) AS collapsed_crime, COUNT(crime) AS crime_count
           FROM ccso_jail
           GROUP BY jacket_number, booking_number
           ORDER BY crime_count DESC
           LIMIT 10
           ')

# Q5
# Beginning with ccso_jail and using SQL via R, write a query that summarizes the data by
# computing the average number of crimes across all values of jacket_number.
# Thus, number of unique rows is the same as number of unique jacket_number values.
# Validate (i.e. verify) the resulting set makes sense based on the jacket_number equals to 17377.

# use COUNT(*) for all crime listed in the GROUP BY jacket_number and divide it by
# DISTINCT booking number which tells the number of entry to the jail
dbGetQuery(con, 'SELECT jacket_number, ( COUNT(*) / COUNT(DISTINCT booking_number)) AS average_num_crime
           FROM ccso_jail
           GROUP BY jacket_number
           ')

# Q6
# Beginning with ccso_jail and using SQL via R, write a query that summarizes the data by
# computing total days spent in jail per booking per jacket_number.
# Thus, number of unique rows is the same as number of unique booking_number values.
# Validate (i.e. verify) the resulting set makes sense based on the jacket_number equals to 17377.

dbGetQuery(con, 'SELECT jacket_number, SUM(`days jail`) AS total_days
           FROM ccso_jail
           WHERE jacket_number = 17377
           GROUP BY jacket_number
           ')

# Q7
# Ensure your work is reproducible and submit your solutions as a week08_wed.R script 
# file in Canvas for the Week 8 In-class Assignment.

