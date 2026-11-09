library(tidyverse)
library(RMariaDB)

url <- 'https://uofi.box.com/shared/static/itpy8hgv5n9bbf13ux48uw83z9nld1up'

jail <- read_delim(url, delim = '&')

jail <- jail %>% 
  mutate(
    booking_date = dmy(booking_date),
    released_date = dmy(released_date)
  )

con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = 'root',
  password = 'N3jF14nabak8nf02jk',
  host = 'localhost',
  dbname = 'sakila'
)
dbWriteTable(con, "ccso_jail", jail, overwrite = TRUE)

# Q1
# Beginning with ccso_jail and using SQL via R, write a query that summarizes the data 
# by computing the number of days spent in jail per jacket_number and the ranking 
# of number of days spent in jail per jacket_number, such that the highest number of 
# days spent in jail receives rank 1, second highest receives rank 2, and so on. 
# When computing the number of days spent in jail per jacket_number, multiple crimes 
# should not influence this calculation.

View(jail)
dbGetQuery(con, 'DESCRIBE ccso_jail')

dbGetQuery(con, 'SELECT jacket_number, `days jail`, DATEDIFF(released_date, booking_date) AS diff,
           booking_date, released_date
           FROM ccso_jail
           LIMIT 20
           ')

#USE subquery
dbGetQuery(con, 'SELECT DISTINCT jacket_number, booking_number
           FROM ccso_jail')

dbGetQuery(con, 'SELECT jacket_number, booking_number, SUM(SUM(`days jail`)) OVER(ORDER BY `jacket_number`)
           FROM ccso_jail
           WHERE jacket_number = 17377
           GROUP BY jacket_number, booking_number
           LIMIT 10')

# Q2
# Beginning with ccso_jail and using SQL via R, write a query that summarizes 
# the data by computing the following cumulative sums: daily total bookings 
# per jacket_number, daily releases per jacket_number, and daily inmates. 
# The result should contain 365 days and the booking date and released_date 
# columns in addition to the 3 accumulation columns.
dbGetQuery(con, 'SELECT booking_date, COUNT(DISTINCT jacket_number) AS unique, SUM(COUNT(DISTINCT jacket_number)) OVER(ORDER BY booking_date)
           FROM ccso_jail
           GROUP BY booking_date
           ')
# Q3
# Beginning with ccso_jail and using SQL via R, write a query that summarizes 
# the data by computing the average number of crimes across all values of jacket_number. 
# Thus, number of unique rows is the same as number of unique jacket_number values. 
# Validate (i.e. verify) the resulting set makes sense based on the jacket_number equals to 17377.
dbGetQuery(con, 'SELECT DISTINCT jacket_number, COUNT(crime) * 1.0 /COUNT(DISTINCT booking_number) AS avg_crime
           FROM ccso_jail
           GROUP BY jacket_number
           LIMIT 20
           ')
dbGetQuery(con, 'SELECT DISTINCT jacket_number, COUNT(crime) * 1.0 /COUNT(DISTINCT booking_number) AS avg_crime
           FROM ccso_jail
           WHERE jacket_number = 17377
           GROUP BY jacket_number
           ')

# Q4
# Beginning with ccso_jail and using SQL via R, write a query that summarizes 
# the data by computing the total number of distinct crimes per jacket_number and
# the ranking of total number of distinct crimes per jacket_number, 
# such that the largest number of crimes receives rank 1, second largest receives rank 2, 
# and so on.

# I use DENSE_RANK instead of RANK since it makes more sense to have multiple person with
# the same rank
dbGetQuery(con, 'SELECT jacket_number, COUNT(DISTINCT crime) AS total_crime,
           DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT crime) DESC) AS rank_crime
           FROM ccso_jail
           GROUP BY jacket_number
           ORDER BY rank_crime
           
           
           ')

# Ensure your work is reproducible and submit your solutions as a week08_fri.R script file 
# in Canvas for the Week 8 In-class Assignment.

