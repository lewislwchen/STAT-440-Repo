#q1 find a json data file online, either download or import into R
#link https://data.illinois.gov/Business-and-Workforce/2026-Clean-Energy-Jobs-Report-County-Census-Gender/7rd7-bp48/about_data
library(jsonlite)

api_url <- ("https://data.illinois.gov/api/v3/views/7rd7-bp48/query.json")

df <- fromJSON(api_url)
#q2 print the column names of the data file
names(df)
colnames(df)

#q3 print all columns at the first 10 rows of the dataset

head(df,10)
#or
df[1:10,]

#q4 print the mode of each column in the dataframe

sapply(df, mode)
lapply(df,mode)
help('lapply')
mode(df$project_county)
#q5 print the class of each column
  
sapply(df, class)
#q6 truncate the characters of the column, so that ONLY the first 2 characters are shown
help(substring)
df$worker_percent <- substring(df$worker_percent, 1, 2)
head(df$worker_percent)

#q7 create a new column for the dataframe, representing
#the # of character for the previous character column
help(nchar)
df$new_column <- nchar(df$worker_percent)

head(df$new_column)
head(df[, c("worker_percent","new_column")])


df$col2 <- data.frame(worker_percent = rep('10', nrow(df))
df$col2
                      
                      
lapply(df[,c("workers","id")]function)

#week6 oral exam mock a
library(tidyverse)
#1 extract the data with url (the file has comma delimiter)
url_mock_a <- 'https://uofi.box.com/shared/static/y4waonf9unsw5oaxjputsbthma26i7ld.dsv'
Prob <- read_delim(url_mock_a)
View(Prob)
str(Prob)
colnames(Prob)
#2 format the date in r, overwrite them into dates
Prob02 <- Prob %>% mutate(y(`1910`))
# 3
# Pro03 Remove the license column
Prob03 <- Prob %>% select(-IL)
view(Prob03)
# 4
# Pro04 filter the rows to keep the properties with inspection date of 2018 and 2019
Prob04 <- Prob %>% filter(str_detect(`1910`, '2018|2019'))
view(Prob04)
# 5
# Create a new column grade proportion
# The proportion will be the summarize of grade column. 
# Hint: Divide by the  total number of the cols
Prob05 <- Prob %>% 
  group_by(`grade`) %>%
  summarize(count = n(), .groups = 'drop') %>%
  mutate(proportion = count/sum(count))
# 6 conceptual
# suppose someone believe they should use str_detect in slice() function 
This is not a good idea. Since the str_detect return a logical reponse and the slice
is a row indexing method based on the location of the row in a data frame

# 创建与题目考点完全对应的模拟数据
mock3_raw <- tibble(
  restaurant_id = 101:110,
  inspection_date = c(
    "2017-03-15", "2018-06-20", "2019-11-05", "2017-08-22", "2016-01-10",
    "2019-04-18", "2018-12-01", "2017-05-30", "2020-02-14", "2019-09-09"
  ),
  expiration_date = c(
    "2018-03-15", "2019-06-20", "2020-11-05", "2018-08-22", "2017-01-10",
    "2020-04-18", "2019-12-01", "2018-05-30", "2021-02-14", "2020-09-09"
  ),
  license_status = c("Active", "Expired", "Active", "Suspended", "Active", 
                     "Active", "Expired", "Active", "Active", "Expired"),
  grade = c("A", "B", "A", "C", "B", "A", "A", "B", "A", "B")
)

# 写入为逗号分隔的 csv 文件供题目读取
write_csv(mock3_raw, "mock3_data.csv")

# 440 mock 3
# 1 name prob01 extract data, comma separated
Bob <- read_delim('mock3_data.csv')
View(Bob)
colnames(Bob)
# 2 name prob02, overwrite the inspection date and expiration date to be properly formatted 
Bob02 <- Bob %>% mutate(
  inspection_date = ymd(inspection_date),
  expiration_date = ymd(expiration_date)
)
View(Bob02
     )
# 3 name prob03 ,remove the license status column
Bob03 <- Bob %>% select(
  -license_status
)
View(Bob03)
# 4 name prob04 filter rows to keep the date of the year 2017 and 2019
Bob04 <- Bob %>% filter(
  str_detect(`expiration_date`, '2017|2019')
)

Bob04 <- Bob %>% filter(
  year(inspection_date) %in% c(2017, 2019)
)
View(Bob04)
# 5 being with prob02
# Summarize the grade column, find the proportion and save as percentage 
Bob05 <- Bob02 %>% 
  group_by(`grade`) %>%
  summarize(
    count = n(),
    .groups = 'drop'
  ) %>%
  mutate(proportion = count/sum(count),
         percentage = proportion*100
         )
# 6 conceptual
# Suppose someone believe str_detect is appropriate to use in filter(), 
# what recommendations would you give to them
# This is a reasonable use of string manipulation and the filter function. The reason
# being the str_detect() return a logical vector and the filter function can receive
# such a value and filter successfully.

# Mock wed 1
library(tibble)

# 構造符合題目要求的模擬數據集
set.seed(42)

simulated_bookings <- tibble(
  booking_number = paste0("BK-", 1001:1010),
  jacket_number = paste0("JK-", 2001:2010),
  # 按照 Q2 要求使用 "月/日/年" (mdy) 的字符格式
  booking_date = c(
    "01/10/2026", "02/14/2026", "03/01/2026", "03/05/2026", "03/12/2026",
    "04/01/2026", "04/10/2026", "04/15/2026", "05/01/2026", "05/20/2026"
  ),
  # 釋放日期（部分相差小於 7 天，部分大於 7 天，以供 Q5 篩選）
  released_date = c(
    "01/13/2026", # 3 天 (<= 7)
    "02/25/2026", # 11 天 (> 7)
    "03/03/2026", # 2 天 (<= 7)
    "03/20/2026", # 15 天 (> 7)
    "03/15/2026", # 3 天 (<= 7)
    "04/05/2026", # 4 天 (<= 7)
    "04/28/2026", # 18 天 (> 7)
    "04/18/2026", # 3 天 (<= 7)
    "05/04/2026", # 3 天 (<= 7)
    "06/10/2026"  # 21 天 (> 7)
  ),
  sex = c("Male", "Female", "Male", "Male", "Female", "Male", "Female", "Male", "Male", "Female"),
  race = c("Black", "White", "Hispanic", "White", "Black", "Asian", "Black", "White", "Hispanic", "White"),
  crime = c(
    "Traffic Violation", "Trespassing", "Theft", "DUI", "Assault",
    "Vandalism", "Drug Possession", "Burglary", "Fraud", "DUI"
  ),
  # 額外添加兩個無關字段，以供 Q3 練習 select 篩選
  bail_amount = c(500, 1500, 2000, 1000, 5000, 800, 1200, 3000, 4500, 1000),
  arresting_officer_id = paste0("OFF-", 901:910)
)

# 導出為 CSV 以完全模擬 Q1 的 read_csv 場景
write.csv(simulated_bookings, "simulated_bookings.csv", row.names = FALSE)

library(tidyverse)
# Q1: Extract, comma delimited structured data (prob01)
url <- 'simulated_bookings.csv'
prob <- read_delim(url, delim = ',')
# Q2: Overwrite the booking date and the release date to be date modes (prob02)
prob02 <- prob %>% mutate(booking_date = mdy(booking_date), released_date = mdy(released_date))
View(prob02)
str(prob02)
# Q3: Select Booking Number, Jacket Number, Booking Date, Release Date, Sex, Race, crime (prob03)
prob03 <- prob02 %>% select(`booking_number`, 
                            `jacket_number`, `booking_date`, `released_date`, `sex`,
                            `race`,`crime`)
# Q4: What is the proportion of bookings for each sex (prob04)
prob04 <- prob %>% group_by(sex) %>%
  summarise(
    booking_count = n()
  ) %>%
  mutate(proportion = booking_count/sum(booking_count))
# Q5: Creating prob05 from prob03 filtering the row so that the difference in time 
#before booking and released date is less than 7 days
 prob05 <- prob03 %>%
   filter(as.numeric(booking_date - released_date) < 7)
 
# Q6 (Conceptual): Suppose someone wants to change the column name to be upper case, 
 #what functions would they use?
 toupper()
 
#  440 mock4 wed
#  1） extract data, delimiter is comma
 url <- 'simulated_bookings.csv'
 prob <- read_delim(url, delim = ',')
colnames(prob02)
#  2)name prob02. Overwrite the release date to book date to date modes
 prob02 <- prob %>% mutate(
   released_date = mdy(released_date),
   booking_date = mdy(booking_date)
 )
# 3） name prob03. Keeping columns, booking number, jacket number, booking date, release date, sex, race, crime
prob03 <- prob02 %>% select(
  booking_number, jacket_number, booking_date, released_date, crime, sex, race
)
# 4)prob04 what is proportion of bookings of each race
prob04 <- prob03 %>% group_by(race) %>%
  summarize(booking_count = n()) %>% ungroup() %>%
  mutate(proportion = booking_count/sum(booking_count))
str(prob03)
# 5)begin with prob03, filter the row such that the difference of booking date and release date = 0
prob05 <- prob03 %>% filter(
  as.numeric(booking_date - released_date) == 0
)
# 6)suppose someone want to change the case within the volumes of the sex and race to lowercase
tolower()