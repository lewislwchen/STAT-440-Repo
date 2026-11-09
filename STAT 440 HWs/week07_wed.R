# Wednesday In-class Assignment
# 
# Extract the Champaign County Sheriff Office Jail Data provided by Champaign County 
#Sheriff Office Jail Data and State of Illinois as a data frame or tibble in R. 
#Using tidyverse methods, overwrite the booking_date and released_date columns to
#be proper date modes in R and store the resulting set as jail_data. 
#A brief data description is below and may be helpful for understanding the data.

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

dbGetQuery(con, 'SELECT First_name, Last_name, jacket_number, booking_number, crime
            FROM ccso_jail01
            LIMIT 20')

dbGetQuery(con, ' SELECT jacket_number, COUNT(crime) AS crime_total
           FROM ccso_jail01
           GROUP BY jacket_number
           HAVING crime_total > 1
           ORDER BY crime_total DESC')

dbGetQuery(con, 'SELECT jacket_number, booking_number, crime
           FROM ccso_jail01
           WHERE jacket_number = 44860')

#q2
# Beginning with jail_data and using SQL via R, write a query that contains data 
# that answers the question: 'Which people were booked into jail at two or more time points?'
dbGetQuery(con, 'SELECT jacket_number, booking_number, crime, COUNT(jacket_number) AS total_visits 
FROM ccso_jail01
GROUP BY jacket_number, booking_number
HAVING total_visits > 1')

# Using SQL via R, run the following line of code to load the data into the sakila database.
#The object con is the connection you made to the sakila database in problem 2 (above).
# 
dbDisconnect(con)
# 
# Ensure your work is reproducible and submit your solutions as a 
#week05_wed.R script file in Canvas for the Week 5 In-class Assignment.