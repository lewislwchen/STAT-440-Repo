library(tidyverse)
library(httr)
library(jsonlite)
library(stringr)
library(alr4)
week4 <- read_delim('/Users/lewischen/Desktop/UIUC 课程 Current Folder /STAT 440/Uncleaned_DS_jobs.txt'，stringsAsFactors = FALSE)
week4

# Are there any logical mode columns?
str(week4) # No. It seems to me that the document is mostly characters and numbers
# How might we separate the information within the Location and Headquarters columns?
tidyr::separate(week4, col = Location, into = c("City", "State"), 
                sep = ",\\s*", extra = "merge", fill = "right") # so we use the separate() function to get rid of ,
# What might we do to parse the Job Description column consistently?
# to parse consistently, we might want to have key word extraction which we can use for later to categorize each job description

#3 Slice the data frame to show only the first 3 rows.
week4 %>% slice(1:3)

#4 Filter the data frame to show only the rows where the Job Title equals "data scientist". You may want to ensure the case is the consistent with the toupper() or tolower() function.
ds_jobs <- week4 %>% filter(tolower(`Job Title`) == "data scientist")

#5 If there are any duplicates in the data, print them.
Duplicated_rows <- week4 %>% filter(duplicated(.))

#6 Drop missing values from the Salary Estimate column, sort the resulting set in decreasing order of the Rating column, and print the structure of the resulting data frame.
# we want to clean the na data and mistyped e.g. -1 data as well
cleaned_sorted_jobs <- week4 %>%
  filter(!is.na(`Salary Estimate`) & `Salary Estimate` != "-1" & `Salary Estimate` != "") %>%
  arrange(desc(Rating))

#7 Organize the columns such that the numeric mode columns appear first, followed by the character mode columns, and finally the logical mode columns. Slice and print a random set of 5 rows of the resulting data frame. The random selection should be without replacement and determined by R not the user.
# we use slice_sample to RANDOMLY choose (by R essentially)
set.seed(2)

reordered <- week4 %>%
  select(
    where(is.numeric),
    where(is.character),
    where(is.logical)
  )

random_5_rows <- reordered %>%
  slice_sample(n = 5, replace = FALSE)
print(random_5_rows)

#8 Is your work reproducible? If not, edit your solutions such that they are reproducible.
# Yes. I added set.seed(2) so that the output of slice_sample ought to be the same every round