#STAT 440 笔记

### Sep 2, 2026

### revest() package

# How to web-scrape
# Be cautious about the rules set by the website

library(rvest)
library(stringr)
housing <- read_html('https://champaignil.devnetwedge.com/parcel/view/922116304005/2025') |>
  html_table()
housing  

#this is the three steps of web-scraping
read_html('https://champaignil.devnetwedge.com/parcel/view/922116304005/2025') |>
  html_elements('.inner-value') |>
  html_text2()|>
  str_squish() #str_squish literally squish the white spaces (and equivalents)

library(rvest)
housing <- read_html('https://champaignil.devnetwedge.com/parcel/view/922116304005/2025') |>
  html_table()

read_html()

### httr() package
# for API calls - Application Programming Interface (API)
library(httr)
library(jsonlite)
library(stringr)

# Lat and long; 40.7128 and -74.0060

nyc <- GET('https://api.weather.gov/points/40.7128,-74.0060')|>
  content(as = 'text', encoding = "UTF-8") |>
  fromJSON(flatten = TRUE)

#if receiving a 400 related code feedback - some error occured
#hourly of weather report of nyc
str(nyc)
View(nyc)
nyc
# I control f and found the forecastHourly under properties
hourly_weather_report_nyc <- nyc$properties$forecastHourly
hourly_weather_report_nyc
#webscrape again
GET('https://api.weather.gov/gridpoints/OKX/33,42/forecast/hourly')|>
  content(as = 'text', encoding = 'UTF-8') |>
  fromJSON(flatten = TRUE)
#done

### Sep 4, 2026
#Wisconcin Dells
library(httr)
library(jsonlite)
wisconsin_dells <- GET('https://api.weather.gov/points/43.6374,-89.7788') |>
  content(as = 'text', encoding = 'UTF-8')|>
  fromJSON(flatten = TRUE)

str(wisconsin_dells)

wisconsin_dells$properties$forecast

# we obtain link: https://api.weather.gov/gridpoints/MKX/24,90/forecast
wisconsin_dells_forecasthourly <- GET(wisconsin_dells$properties$forecastHourly)|>
  content(as = 'text', encoding = 'UTF-8')|>
  fromJSON(flatten = TRUE)
str(wisconsin_dells_forecasthourly)

wisconsin_dells_forecasthourly$properties$periods
tail(wisconsin_dells_forecasthourly$properties$periods, 10)

#Shakespeare
shakespeare <- readLines('https://uofi.box.com/s/zjsqtb4eax44qzmkq94akp8aryb6ta84')
shakespeare

#If you we want to read a sound file!!!
library(tuneR)
audio1 <- readWave("/Users/lewischen/Desktop/UIUC 课程 Current Folder /STAT 440/KV_TABLA_120_PATT_04_G.WAV")
str(audio1)

plot(audio1@left, type = 'l')

# sql chapter
usethis::edit_r_environ()
password = Sys.getenv(‘MYSQL_PASSWORD’)

# question 10 slide3
library(DBI)
library(RMariaDB)
db_connection <- dbConnect(RMariaDB::MariaDB(), user = "root", password = Sys.getenv('MYSQL_PASSWORD'), host = 'localhost', port = 3306)

new_dbname <- "urbana_champaign_db"
dbExecute(db_connection, paste0("CREATE DATABASE ", new_dbname))

dbDisconnect(db_connection)

# 排序R功能
#Base R
sort()
order()
rev()
### Tidyverse Arrange
library(tidyverse)
arrange(desc(column1), column2)
# Tidyvese 
select()
# all remaining columns
everything()
# column names having character string prefix or suffix
first_
last_col()
#想要移动 一堆 columns in tidyverse (relocate)
relocate()
# e.g.
data_name |> relocate(column_name01, .after = column_name04, .before = last_col())
# Filter - 实施一些condition 来 filter
filter()
filter_out()
#slice 用来 limit row output based on row index or position
# random selection of rows
slice_sampel(n = )

slice_min(order_by = , n =)
slice_max
# 消除missingness
drop_na() #尽量不要去
# 找duplication
data_name |> count(across(everything())) |> filter(n > 1) # count 计算， across 找全部
#在base R，这个function可以展示出多少是重复的
anyDuplicated()
anyDuplicated() #从底下网上找
# distinct() 在tidyvers，unique()在base r。都一样

#select() 作用于“列” (Columns / Variables)：这是一个降维 (Dimensionality Reduction) 或特征选择的过程。
#你用它来决定数据集中哪些变量 (变量 Variable) 应该被保留、重新排序或丢弃。它操作的是数据的“属性”。

#filter() 作用于“行” (Rows / Observations)，基于“条件”：
#这是一个基于逻辑条件 (逻辑条件 Logical Condition) 提取数据的过程。只有当观测值 (观测值 Observation) 
#满足你设定的数学或布尔逻辑（如大于、等于、包含）时，才会被保留。

#slice() 作用于“行” (Rows / Observations)，基于“位置”：这是一个基于物理行号 (索引 Index) 强制截取数据的过程。
#它完全不在乎这行数据具体是什么内容，只在乎它在数据表中的绝对排名位置。

# 时间在tidyerse
library(tidyverse)
string <- "12/15/2012"
mdy(string)
str(mdy(string))
#时间在base r
str(as.Date(string, format = '%m/%d/%Y'))

format(as.Date(string, format = '%m/%d/%Y'), '%Y')
as.numeric(format(as.Date(string, format = '%m/%d/%Y'), '%Y'))

# Base R Mutating!!!
mutate() #append new columns to the right of existing columns in data frame
transmutate() #!!!replace the whole column!!! the rest of the column will be removed
#tidyverse里面是add_row()
data_name |> add_row(col = new value. col2 = new value 2, .before = , .after = )

# reshape, in tidyverse.
pivot_longer() #加更多rows
pivot_wider() #加更多columns
#pivot wider

#q9 Create an new function in R that reverses the values of a character string input 
#(assuming the input is length 1). Name your function rev_char. For example,
#if the input is 'apples', then the output is 'selppa'. Devise your rev_char() 
#function on base R functions alone, such as strsplit(), rev(), and paste().

rev_char <- function(x) {
  split_char <- strsplit(x, split = "")[[1]]
  reverse <- rev(split_char)
  result <- paste(reverse, collapse = '')
  return(result)
}

#Notes：
rev_char('apples')

filter(str_detect(tolower(`Job title`), 'data scientist'))

ds_jobs %/% drop_na() %/% arrange(desc())

ds <- select(where(is.numeric), where(is.character), where(is.logical)) %>%
  slice_sample (n = 5)

#String Manipulation
string <- "You like syntactical words."
str_count(string, '\\s') # count how many white space
str_remove(string, '\\s')

#create function
rev_char <- function(input) {
  strsplit(input,'')[[1]] %>%
    rev() %>%
    paste(collapse = '')
}
rev_char('apples')

library(tidyverse)
head(diamonds)
cut1 <- diamonds %>% group_by(cut) %>% summarize(
  n_diamonds = n(),
  avg_price = mean(price, na.rm = TRUE),
  median_price = median(price, na.rm = TRUE)
) %>% arrange(desc(avg_price))

view(cut1)
