library(tidyverse)
neo <- 'https://uofi.box.com/shared/static/lv2lqlgjxf87y8o36lw1cyxjarrrfx5j.csv'
nasa_neo_data <- read_delim(neo)

view(nasa_neo_data)

#q2
nasa_neo_data_2 <- nasa_neo_data %>% mutate(
  `Close-Approach (CA) Date Time` = as.POSIXct(`Close-Approach (CA) Date Time`,
    format = '%Y-%b-%d %H:%M',
    tz = "UTC"),
  `Close-Approach (CA) Date` = as.Date(`Close-Approach (CA) Date`)
)

view(nasa_neo_data_2)

#q3
nasa_neo_data_3 <- nasa_neo_data %>%
  filter(Rarity > 0,
         year (`Close-Approach (CA) Date`) %in% 2011:2013) %>%
  arrange(desc(`Close-Approach (CA) Date`))

#q3 can be done with the string manipulation as well!!!
nasa_neo_data_3 <- nasa_neo_data %>% filter(Rarity > 0, str_detect(`Close-Approach (CA) Date`, '2011|2012|2013') %>%
  arrange(desc(`Close-Approach (CA) Date`))
nasa_neo_data_3
#q4
#two approches
nasa_neo_data_4 <- nasa_neo_data %>% slice_max(order_by = `V relative(km/s)`, n = 10) %>% arrange(`CA DistanceNominal (au)`)
view(nasa_neo_data_4)

nasa_neo_data_4 <- nasa_neo_data %>%
  arrange(desc(`V relative(km/s)`)) %>% slice(1:10) %>%
  arrange(`CA DistanceNominal (au)`)
view(nasa_neo_data_4)


