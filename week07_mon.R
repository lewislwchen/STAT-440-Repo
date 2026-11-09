library(tidyverse)

# Extract the three datasets Urbana Rentals' Properties provided by City of Urbana, 
# Urbana Rentals' Inspections provided by City of Urbana, Urbana Rentals' 
# Landlords provided by City of Urbana as separate data frames or tibbles in R.

url_landlords <- 'https://uofi.box.com/shared/static/hsypgzu7rdhh6wsjl3x2px5y0fz695cx'
url_inspections <- 'https://uofi.box.com/shared/static/dh0cu4jj691bpcc1dgj1sou1wbxi2ent'
url_properties <- 'https://uofi.box.com/shared/static/xmnb777mdt0owqf9f2ilxnocbw7w1m91'

properties  <- read_csv(url_properties, show_col_types = FALSE)
inspections <- read_csv(url_inspections, show_col_types = FALSE)
landlords   <- read_csv(url_landlords, show_col_types = FALSE)

# Join all three datasets together using each of the three joins mentioned above:
# inner join, left join, and full join. Store each resulting joined set as a different 
# object name.

join_key <- "parcel_number"

inner <- properties %>%
  inner_join(inspections, by = join_key, relationship = "many-to-many") %>%
  inner_join(landlords, by = join_key, relationship = "many-to-many")

joined_left <- properties %>%
  left_join(inspections, by = join_key, relationship = "many-to-many") %>%
  left_join(landlords, by = join_key, relationship = "many-to-many")

joined_full <- properties %>%
  full_join(inspections, by = join_key, relationship = "many-to-many") %>%
  full_join(landlords, by = join_key, relationship = "many-to-many")
# Ensure your work is reproducible and submit your solutions as a week07_mon.R 
# script file in Canvas for the Week 7 In-class Assignment.

head(joined_full)
