library(tidyverse)

nasa_neo_data <- read_delim('https://uofi.box.com/shared/static/lpzls0yrw49e6dyexx7gkfofjazo82l3', delim = '|')

str(nasa_neo_data)

nasa_neo_data2 <- nasa_neo_data |>
  mutate(`Close-Approach (CA) Date Time` = ymd_hm(`Close-Approach (CA) Date Time`), 
         `Close-Approach (CA) Date` = ymd(`Close-Approach (CA) Date`))

str(nasa_neo_data2)

table(format(nasa_neo_data2$`Close-Approach (CA) Date`, '%Y'))

nasa_neo_data |>
  filter(Rarity > 0, str_detect(`Close-Approach (CA) Date`, "2011|2012|2013"))

nasa_neo_data |>
  slice_max(`V relative(km/s)`, n = 10) |>
  mutate(`CA DistanceNominal (mi)` = `CA DistanceNominal (au)`*150000000*0.62137) |>
  arrange(`CA DistanceNominal (au)`) |>
  select(Object, `V relative(km/s)`, `CA DistanceNominal (mi)`, `CA DistanceNominal (au)`)


sampled_food_inspections_data <- jsonlite::fromJSON('https://uofi.box.com/shared/static/1skod19nwsy3tn9n8izdc5pk35j0skku.csv')

sampled_food_inspections_data_smaller <- sampled_food_inspections_data |>
  mutate(`Inspection Date` = mdy(`Inspection Date`)) |>
  select(-c(`AKA Name`, City, State, Zip, Location))
#'AKA Name', 'City', 'State', 'Zip', 'Location'

sampled_food_inspections_data_chains <- sampled_food_inspections_data_smaller |>
  distinct(`License #`, .keep_all = TRUE) |>
  filter(str_detect(tolower(`Facility Type`), "restaurant")) |>
  group_by(`DBA Name`) |>
  mutate(n = n()) |>
  filter(n > 1) |>
  mutate(`Chain Name` = paste('Chain', `DBA Name`)) |>
  print(width = Inf)

sampled_food_inspections_data_total_violations <- sampled_food_inspections_data_chains |>
  group_by(`Chain Name`) |>
  summarize(`Total Violations` = sum(as.numeric(str_count(Violations, '\\|'))+1, na.rm = TRUE)) |>
  ungroup() |>
  arrange(desc(`Total Violations`))

#sampled_food_inspections_data_chains$Violations
#str_count(sampled_food_inspections_data_chains$Violations, '\\|')+1
print(sampled_food_inspections_data_total_violations, width = Inf)
