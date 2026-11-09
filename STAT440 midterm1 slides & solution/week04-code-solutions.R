library(tidyverse)

ds_jobs_data <- read_delim("https://uofi.box.com/shared/static/5nqg2dk8uym5u87s9rv1gq10mtxnybij.txt", delim = '\t')

str(ds_jobs_data)

# No logical mode columns.

# Separate the city and state information into new columns.

# We would want to be careful in processing text using string manipulation and other techniques.

ds_jobs_data |>
  slice_head(n = 3)

ds_jobs_data |>
  filter(str_detect(tolower(`Job Title`), 'data scientist'))

anyDuplicated(ds_jobs_data)
anyDuplicated(ds_jobs_data, fromLast = TRUE)

ds_jobs_data |>
  count(across(everything())) |>
  filter(n > 1)

ds_jobs_data |>
  drop_na(`Salary Estimate`) |>
  arrange(desc(Rating)) |>
  str()

ds_jobs_data |>
  select(where(is.numeric), where(is.character), where(is.logical)) |>
  slice_sample(n = 5)
















zd <- read_csv('https://uofi.box.com/shared/static/kjulhvqj976fzfxfjx57ljcelguu9fag.csv')

zd |>
  slice(-1)

zd |>
  filter_out(is.na(StateName))

zd |>
  drop_na(StateName)

zd |>
  filter(str_detect(RegionName, ','))


zillow_data <- zd |>
  pivot_longer(cols = starts_with('20'), names_to = 'Date', values_to = 'Rent') |>
  mutate(Date = ymd(Date))

str(zillow_data)

zillow_data_illinois <- zillow_data |>
  filter(StateName == 'IL') |>
  select(-StateName, -RegionID)

str(zillow_data_illinois)

zillow_data_urbana_illinois <- zillow_data_illinois |>
  add_row('SizeRank' = nrow(zillow_data_illinois)+1, 'RegionName' = 'Urbana, IL', 'Date' = Sys.Date(), 'Rent' = 1000)

zillow_data_urbana_illinois |>
  slice_tail(n = 10)
