library(tidyverse)
url <- 'https://uofi.box.com/shared/static/d26umwu6i60odump4gcmbix9e51z7tj0'
bicycle <- read_csv(url)
view(bicycle)

bicycle |>
  summarise(across(everything(), ~ mean(is.na(.)))) |>
  pivot_longer(everything(), names_to = "col", values_to = "na_rate") |>
  arrange(desc(na_rate)) |>
  print(n = Inf)

bicycle |>
  summarise(across(where(is.character), n_distinct)) |>
  pivot_longer(everything(), names_to = "col", values_to = "n_levels") |>
  arrange(n_levels) |>
  print(n = Inf)
count(bicycle, unit_type, sort = TRUE)
count(bicycle, vehicle_travel_direction, sort = TRUE) 

# we use bar chart to show the accident rate per direction
dir_df <- bicycle |>
  filter(vehicle_travel_direction != "UNKNOWN") |>
  # filter(unit_type == "BICYCLE") |>  
  mutate(axis = case_when(
    vehicle_travel_direction %in% c("N", "S")   ~ "North–South",
    vehicle_travel_direction %in% c("E", "W")   ~ "East–West",
    vehicle_travel_direction %in% c("NW", "SE") ~ "NW–SE (diagonal)",
    vehicle_travel_direction %in% c("NE", "SW") ~ "NE–SW (diagonal)"
  ))

dir_df |> filter(vehicle_travel_direction %in% c("N","E","S","W")) |>
  count(vehicle_travel_direction) |>
  ggplot(aes(fct_reorder(vehicle_travel_direction, n), n)) + geom_col()

dir_df |>
  mutate(d = factor(vehicle_travel_direction,
                    levels = c("N","NE","E","SE","S","SW","W","NW"))) |>
  count(d) |>
  ggplot(aes(d, n, fill = d %in% c("NE","SE","SW","NW"))) +
  geom_col() +
  scale_fill_manual(values = c("grey", "turquoise"),
                    labels = c("Cardinal", "Diagonal"), name = NULL)

dir_df |> count(axis) |>
  ggplot(aes(fct_reorder(axis, n), n, fill = axis == "NW–SE (diagonal)")) +
  geom_col() + coord_flip() +
  scale_fill_manual(values = c("skyblue", "orange"), guide = "none")
