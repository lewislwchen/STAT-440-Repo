library(tidyverse)
library(jsonlite)
foods <- 'https://uofi.box.com/shared/static/9xcyk6qax92qlsme62mvjd0ea9ecyqh9.csv'
sampled_food_inspections_data <- fromJSON(foods) %>% as_tibble()
view(sampled_food_inspections_data)

#q2
sampled_food_inspections_data_smaller <- sampled_food_inspections_data %>% 
  mutate(`Inspection Date` = as.Date(`Inspection Date`, format = '%m/%d/%Y') %>%
  select(-`AKA Name`, -City, -State, -Zip, -Location)


view(sampled_food_inspections_data_smaller)

#q3
sampled_food_inspections_data_chains <- sampled_food_inspections_data_smaller %>%
  filter(`Facility Type` == 'Restaurant') %>%
  group_by(`DBA Name`) %>%
  filter(n_distinct(`License #`) >= 2) %>% #check distinct restaurants
  ungroup() %>%
  mutate(`Chain Name` = paste('Chain',`DBA Name`)) %>%
  arrange(`DBA Name`)

view(sampled_food_inspections_data_chains)

#q4
sampled_food_inspections_data_total_violations <- sampled_food_inspections_data_chains %>%
  drop_na(Violations) %>%
  separate_longer_delim(Violations, delim = '|') %>%
  group_by(`Chain Name`) %>%
  summarize(`Total Violations` = n()) %>%
  arrange(desc(`Total Violations`))

view(sampled_food_inspections_data_total_violations)