library(tidyverse)
library(httr)
library(jsonlite)
library(stringr)
library(alr4)
box <- 'https://uofi.box.com/shared/static/e7ohkd15fmb8mw3948u79d5i16s0hric.csv'
Metro <- read_csv(box)
head(Metro)
str(Metro)
ncol(Metro)
#q2
#Are there any compound columns? What kind of singular columns would be best to separate the compound columns into?
#Yes. I see the regionname column has values that are compound. It will be a great practice to have them separated
#into singular columns.

#How do you feel about the way the data is currently organized?
#Not the best formatting. The initial 4 columns are well-formatted, whereas the index numbers and date should be structured in a long format

#q3 Filter out any row for which the 'RegionName' column is not a city and state value.
Filtered <- Metro %>% filter(!is.na(StateName))
str(Filtered)
#q4 Reshape the data such that the resulting set contains more rows than columns. 
#The column names containing a date should be pivoted into a single column named 'Date', 
#and the values of those columns should be pivoted into a single column named 'Rent'. 
#Store the resulting set as the object name zillow_data. 
#Be sure to format the 'Date' column as a proper date column in R. Print the structure.

zillow_data <- Filtered %>% pivot_longer(
  cols = -c(RegionID, SizeRank, RegionName, RegionType, StateName),
  names_to = 'Date',
  values_to = 'Rent'
) %>% mutate(Date = ymd(Date))
str(zillow_data)


#q5 If there are any duplicates in the zillow_data, print them.
dup <- Metro %>% filter(duplicated(.))
head(dup)

#q6 Beginning with zillow_data, filter to keep rows for which the 'StateName' refers to the state of Illinois 
#(abbreviated as IL). Now with that resulting set, remove the 'StateName' column and 'RegionType' column 
#and store the current resulting set as the object name zillow_data_illinois. Print the structure.

zillow_data_illinois <- zillow_data %>% filter(StateName == 'IL') %>% select(-StateName, -RegionType)
str(zillow_data_illinois)
  
#q7 Beginning with zillow_data_illinois, mutate a new row to have the values: 
#'RegionID' = 440, 'SizeRank' = nrow(zillow_data_illinois)+1, 'RegionName' = 'Urbana, IL', 'Date' = Sys.Date()
#', and 'Rent' = YOURRENT, where YOURRENT is the average monthly rent for everyone at your table in class.
#' Store the resulting set as the object name zillow_data_urbana_illinois. Print the structure.

zillow_data_urbana_illinois <- zillow_data_illinois %>% add_row(
  RegionID =440,
  SizeRank = nrow(zillow_data_illinois)+1,
  RegionName = 'Urbana, IL',
  Date = Sys.Date()
)
str(zillow_data_urbana_illinois)
#mutate()is changing columns; add_row is adding new rows

#q8 Is your work reproducible? If not, edit your solutions such that they are reproducible.
# I changed the date to as.Date('2026-09-16'); this will ensure all the code to be repruducible
zillow_data_urbana_illinois <- zillow_data_illinois %>% add_row(
  RegionID =440,
  SizeRank = nrow(zillow_data_illinois)+1,
  RegionName = 'Urbana, IL',
  Date = as.Date('2026-09-16')
)
view(zillow_data_urbana_illinois)
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
rev_char('apples')

