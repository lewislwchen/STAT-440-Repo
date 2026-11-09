library(tidyverse)

url <- 'https://uofi.box.com/shared/static/mz7cefd4z0agdnhamvayq48ehlb0c3r6.dsv'
jail_data <- read_delim(url, delim = '&')
View(jail_data)

# Mock 1
#q1
jail_data <- jail_data %>% mutate(
  booking_date = ymd(booking_date),
  released_date = ymd(released_date)
) %>%
  mutate(
    jacket_number = as.character(jacket_number),
    booking_number = as.character(booking_number)
  ) %>%
  rename_with(~tolower(.x))
str(jail_data)

#q2
library(DBI)

con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = "root", 
  password = 'N3jF14nabak8nf02jk', 
  host = "localhost", 
  dbname = "sakila")

dbWriteTable(con, "ccso_jail", jail_data, overwrite = TRUE)

#q3
# remove null values of released_date; mutate data with twon new columns
# booking_data_time and released_date_time

dbGetQuery(con, 'SELECT CAST(CONCAT(booking_date, " ",booking_time) AS DATETIME) AS booking_date_time, CAST(CONCAT(released_date, " ",released_time) AS DATETIME) AS released_date_time
           FROM ccso_jail
           WHERE released_date IS NOT NULL
           ')

# q4
dbGetQuery(con, 'SELECT jacket_number, GROUP_CONCAT(DISTINCT crime) AS crimes_list, COUNT(DISTINCT crime) AS n_crimes
           FROM ccso_jail
           GROUP BY jacket_number
           
           
           
           ')

#Q5

dbGetQuery(con, '
SELECT arrest_agency, COUNT(arrest_agency) AS n_of_each_arrest_agency, (COUNT(arrest_agency)/SUM(COUNT(arrest_agency)) OVER())*100 AS percent
FROM (SELECT *, CONCAT(first_name, " " , last_name) AS full_name 
      FROM ccso_jail  
      WHERE arrest_agency IS NOT NULL) AS subquery_name
GROUP BY arrest_agency
ORDER BY percent
;')

# the errors are 1) ORDERBYpercent needs to be separated to ORDER BY percent; the percent needs to be x100
# 2) OVER() is unnecessary
# 3) the subquery needs a name

# Mock 2

#q1
library(tidyverse)
url2 <- 'https://uofi.box.com/shared/static/ht0m74fktmplay8j3lpu18zcpfpmsra8.csv'
food_inspections_data <- read_delim(url2, delim = ',')
View(food_inspections_data)

food_inspections_data <- food_inspections_data %>% rename_with(~tolower(.x))
food_inspections_data <- food_inspections_data %>% rename_with(~str_replace_all(.x,'\\s|\\.','_'))
food_inspections_data <- food_inspections_data %>% mutate(
  `Inspection Date` = mdy(`Inspection Date`)
)
str(food_inspections_data)
# q2
library(DBI)

con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = "root", 
  password = Sys.getenv("MYSQL_PASSWORD"), 
  host = "localhost", 
  dbname = "sakila")

dbWriteTable(con, "food_inspections", food_inspections_data, overwrite = TRUE)
# q3
dbGetQuery(con, 'SELECT dba_name, results
           FROM food_inspections
           WHERE UPPER(results) LIKE "FAIL" AND facility_type LIKE "%school%"
           
           
           ')
#q4
dbGetQuery(con, 'SELECT dba_name, AVG(total_violations) AS average_total_violations_each_dba_name
           FROM food_inspections
           WHERE dba_name IN (SELECT dba_name
FROM food_inspections
GROUP BY dba_name
HAVING COUNT(DISTINCT address) > 1)
           GROUP BY dba_name
           
           
           
           ')

# q5 Explain any error(s) in the following code (using food_inspections and SQL via R) and write corrected code below. Your explanation should be written as an R comment such as # the error...

dbGetQuery(con, 'SELECT address, COUNT(DISTINCT dba_name) AS n_businesses, 
  CASE WHEN COUNT(DISTINCT dba_name) > 1 THEN 1
  ELSE 0 END AS business_plaza
FROM food_inspections
GROUP BY address 
;')

# the errors are 1) HAVING in CASE WHEN is not needed. 2) DISTINCT should be put before the dba_name
# 3) address is mispelled

# Mock 3
url3 <- 'https://uofi.box.com/shared/static/a1u1xw2nsivngvdy1r9rve7dztm9ktmu.csv'
illinois_baby_names_data <- read_delim(url3, delim = ',')
illinois_baby_names_data <- illinois_baby_names_data %>% mutate(
  name = toupper(name))
)

View(illinois_baby_names_data)
#q2
library(DBI)
con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = "root", 
  password = Sys.getenv("MYSQL_PASSWORD"), 
  host = "localhost", 
  dbname = "sakila")
dbWriteTable(con, "illinois_baby_names", illinois_baby_names_data, overwrite = TRUE)

#q3
dbGetQuery(con, 'SELECT name
           FROM illinois_baby_names
           WHERE name LIKE "B_B" OR name LIKE "A_A" OR name LIKE "E_E" AND LENGTH(name) = 3
           
           
           ')
#q4
dbGetQuery(con, 'SELECT name
           FROM illinois_baby_names
           GROUP BY name
           HAVING COUNT(name) > 1
           ORDER BY name
           ')

dbGetQuery(con, '
SELECT *
FROM illinois_baby_names 
WHERE name IN (SELECT name
FROM illinois_baby_names
GROUP BY name
HAVING COUNT(name) >1
ORDER BY name)
ORDER BY name, sex
;')

#Execute the following code.

# Now, write R code using tidyverse functionality to achieve the same result set.

dbGetQuery(con, '
SELECT name, SUM(frequency) AS total_frequency, RANK() OVER(ORDER BY SUM(frequency) DESC) AS ranking
FROM illinois_baby_names
WHERE name IN (SELECT DISTINCT name FROM illinois_baby_names) 
GROUP BY name
LIMIT 20')
?rank
illinois_baby_names_data <- food_inspections_data %>%
  group_by(name) %>%
  summarize(total_frequency = sum(frequency)) %>%
  arrange(desc(total_frequency)) %>%
  ungroup() %>%
  mutate(ranking = rank(desc(total_frequency)) %>%
  slice(1:20)

# claude mock 1
# 
library(tidyverse)
url4 <- 'https://uofi.box.com/shared/static/mz7cefd4z0agdnhamvayq48ehlb0c3r6.dsv'
jail_data <- read_delim(url4, delim = '&')  
View(jail_data)

jail_data <- jail_data %>% mutate(
  booking_date = mdy(booking_date),
  released_date = mdy(released_date),
  jacket_number = as.character(jacket_number),
  booking_number = as.character(booking_number),
  days_in_jail = as.numeric(released_date - booking_date))
  )

str(jail_data)

library(DBI)

con <- dbConnect(
  drv = RMariaDB::MariaDB(),
  user = "root", 
  password = Sys.getenv("MYSQL_PASSWORD"), 
  host = "localhost", 
  dbname = "sakila")

dbWriteTable(con, "ccso_jail", jail_data, overwrite = TRUE)

# q3 crime contained battery in summer 2019
# Return jacket_number, booking_number,
# booking_date, and crime, sorted from oldest to newest booking_date
dbGetQuery(con, 'SELECT jacket_number, booking_number, booking_date, crime
           FROM ccso_jail
           WHERE UPPER(crime) LIKE "%BATTERY%" AND booking_date BETWEEN "2019-06-21" AND "2019-09-22"
           ORDER BY booking_date DESC
           
           ')
# q4
dbGetQuery(con, 'SELECT jacket_number, booking_number, COUNT(DISTINCT crime) AS n_crimes, 
SUM(COUNT(DISTINCT crime)) OVER(PARTITION BY jacket_number) AS person_total_crimes
           FROM ccso_jail
           GROUP BY jacket_number, booking_number
           HAVING booking_number > 1
           ORDER BY person_total_crimes DESC, jacket_number 
           
           
           ')
#Q 5

dbGetQuery(con, '
SELECT race, COUNT(jacket_number DISTINCT) AS n_people,
  COUNT(DISTINCT jacket_number)/SUM(COUNT(DISTINCT jacket_number)) AS prop_people
FROM ccso_jail
WHERE race <> NULL AND booking_date BETWEEN "01/01/2019" AND "06/30/2019"
GROUP BY race
ORDER BY prop_people DESC
;')
# the errors are 1) DISTINCT should be placed before jacket_number. 2) COUNT(DISTINCT jacket_number)/SUM(COUNT(DISTINCT jacket_number)) needs OVER() to complete the window for sum()
# 3) <> can be replaced by 'IS NOT'. 4) date needs to be defined with -
dbGetQuery(con, '
SELECT race, COUNT(DISTINCT jacket_number) AS n_people,
  COUNT(DISTINCT jacket_number)/SUM(COUNT(DISTINCT jacket_number)) OVER() AS prop_people
FROM ccso_jail
WHERE race IS NOT NULL AND booking_date BETWEEN "01-01-2019" AND "06-30-2019"
GROUP BY race
ORDER BY prop_people DESC
;')

# claude part 2
# A1
View(illinois_baby_names_data)
dbGetQuery(con, 'SELECT dba_name
           FROM food_inspections
           WHERE dba_name LIKE "MC%S"
           ')
dbGetQuery(con, "SELECT DISTINCT name
FROM illinois_baby_names
WHERE name REGEXP '^[aeiou][a-z]{3}[aeiou]$';
           ")
dbGetQuery(con, 'SELECT name
           FROM illinois_baby_names
           WHERE LENGTH(name) = 5 AND
           SUBTSTRING(name,1,1) IN ('a','e','i','o','u')
           SUBTSTRING(name,5,1) IN ('a','e','i','o','u')
           ')
# A3
view(food_inspections_data)
dbGetQuery(con, 'SELECT facility_type, COUNT(results) AS n_fail
           FROM food_inspections
           WHERE UPPER(facility_type) LIKE "%SCHOOL%" AND
           UPPER(results) LIKE "FAIL"
           GROUP BY facility_type
           ')

#A4
View(jail_data)
dbGetQuery(con, "SELECT DISTINCT jacket_number, first_name, last_name
           FROM ccso_jail
           WHERE last_name REGEXP '\\-' OR LENGTH(first_name) < 3")
#B 1
dbGetQuery(con, "SELECT booking_number, jacket_number, booking_date
           FROM ccso_jail
           WHERE booking_date BETWEEN '2019-12-1' AND '2019-12-31'
           
           ")
dbGetQuery(con, "SELECT booking_number, jacket_number, booking_date
           FROM ccso_jail
           WHERE EXTRACT(YEAR FROM booking_date) = 2019 
           AND EXTRACT(MONTH FROM booking_date) = 12
           
           ")
# B2
dbGetQuery(con, "SELECT booking_number, booking_date, released_date,
DATEDIFF(released_date,booking_date) AS days_held, CASE WHEN DATEDIFF(released_date,booking_date) = 0 THEN 'Same_day'
WHEN DATEDIFF(released_date,booking_date) >= 30 THEN '30+days' ELSE 'other' END AS stay_type
           FROM ccso_jail
           WHERE released_date IS NOT NULL
           ")
# B3
dbGetQuery(con, "
  SELECT 
    booking_number,
    CAST(CONCAT(booking_date, ' ', booking_time) AS DATETIME) AS booking_date_time
  FROM ccso_jail
  WHERE CAST(CONCAT(booking_date, ' ', booking_time) AS DATETIME) >= '2019-12-31 18:00:00'
    AND CAST(CONCAT(booking_date, ' ', booking_time) AS DATETIME) <= '2019-12-31 23:59:59'
")
# B4
dbGetQuery(con, "SELECT month, 
           FROM food_inspections
           WHERE n_fail IN (SELECT MAX(COUNT(results)) AS n_fail
           FROM food_inspection
           GROUP BY dba_name
           HAVING UPPER(results) = 'FAIL'
           )
           ")
# C
# C1
dbGetQuery(con, "SELECT name, sex, frequency, 
SUM(frequency) OVER(PARTITION BY name) AS name_total,
100*(frequency/name) AS pct_of_name
           FROM illinois_baby_names
           
           ")
#C2
# C2
dbGetQuery(con, "
  WITH ranked_names AS (
    SELECT 
      sex, 
      name, 
      frequency, 
      DENSE_RANK() OVER (PARTITION BY sex ORDER BY frequency DESC) AS rnk
    FROM illinois_baby_names
  )
  SELECT 
    sex, 
    name, 
    frequency, 
    rnk
  FROM ranked_names
  WHERE rnk <= 3
  ORDER BY sex, rnk, frequency DESC, name
")
# C3
dbGetQuery(con, "SELECT DISTINCT booking_number AS n_bookings,
SUM(booking_number) OVER(PARTITION BY EXTRACT(YEAR FROM booking_date) ORDER BY booking_date) AS cumulative_bookings,
AVG(booking_number) OVER() AS avg_daily_bookings
           FROM ccso_jail
           ")
# C4
dbGetQuery(con, "SELECT jacket_number, booking_number, booking_date,
LAG(booking_date) OVER(PARTITION BY booking_date) AS previous_booking_date
           FROM
           WHERE DISTINCT booking_number
           ")
# D
# D1
dbGetQuery(con, "SELECT AVG(n_crime) AS avg_crime
           FROM (SELECT booking_number, COUNT(DISTINCT crime) AS n_crime
           FROM ccso_jail
           GROUP BY booking_number) AS d1
           ")

#D2
dbGetQuery(con, "SELECT dba_name
           FROM food_inspections
           WHERE dba_name In (SELECT dba_name
           FROM food_inspections
           GROUP BY dba_name
           HAVING COUNT dba_name > AVG(dba_name) OVER()")

#D3
dbGetQuery(con, "SELECT
           FROM illinois_baby_names
           WHERE n_name IN (SELECT name, COUNT(name) AS n_names
           FROM illinois_baby_name
           GROUP BY name)
           
           ")
dbGetQuery(con, "SELECT CAST(CONCAT(booking_date,' ',booking_time) AS DATETIME) AS booking_date_time, 
CAST(CONCAT(released_date,' ', released_time) AS DATETIME) AS released_date_time
           FROM ccso_jail
           WHERE released_date IS NOT NULL")
dbGetQuery(con, "SELECT jacket_number,GROUP_CONCAT(DISTINCT crime) AS crimes_list, COUNT(DISTINCT crime) AS n_crimes
           FROM ccso_jail
           GROUP BY jacket_number")
food_inspections_data <- food_inspections_data %>%
  rename_with(~tolower(.x)) %>%
  rename_with(
    ~str_replace_all(.x, '\\s|\\.','_')
  ) %>%
  mutate(
    inspection_date = mdy(inspection_date)
  )

dbWriteTable(con, "food_inspections", food_inspections_data, overwrite = TRUE)
dbGetQuery(con,"SELECT dba_name, facility_type, results
           FROM food_inspections
           WHERE UPPER(facility_type) LIKE '%SCHOOL%' AND UPPER(results) LIKE 'FAIL'
           ")
dbGetQuery(con, "SELECT dba_name, AVG(total_violations) AS average_total_violations_each_dba_name
           FROM food_inspections
           WHERE dba_name IN (SELECT dba_name
           FROM food_inspections
           GROUP BY dba_name
           HAVING COUNT(DISTINCT address) > 1)
           GROUP BY dba_name
           ")
illinois_baby_names_data <- illinois_baby_names_data %>%
  mutate(
    name = toupper(name)
  )
dbWriteTable(con, "illinois_baby_names", illinois_baby_names_data, overwrite = TRUE)
dbGetQuery(con, "SELECT name
           FROM illinois_baby_names
           WHERE UPPER(name) REGEXP '^([A-Za-z]).\\\\1$'
           ")
dbGetQuery(con, "SELECT name
           FROM illinois_baby_names
           WHERE name IN (SELECT name
           FROM illinois_baby_names
           GROUP BY name
           HAVING COUNT(*) > 1)
           ORDER BY name
           ")
data <- illinois_baby_names_data %>%
  group_by(name) %>%
  summarize(
    total_frequency = sum(frequency),
  ) %>%
  ungroup() %>%
  arrange(desc(frequency) %>% mutate(ranking = rank(frequency)) %>%
  slice(1:20)

  