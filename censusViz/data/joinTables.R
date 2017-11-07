library(shiny)
library(ggplot2)
library(dplyr)

race = readRDS("data/counties.rds")

counties_map = map_data("county")
View(counties_map)
View(race)

## In order to join both tables, we need to make sure that we are combining them by 
## both state and county as a unique identifier.. so, we can combine region and
## subregion in the counties_map into a new variables called "name"

counties_map = counties_map %>%
  mutate(name = paste(region, subregion, sep = ","))

# Left join and right join

counties <- left_join(counties_map, race, by = "name")
# if the name is different: by = c("first variable","second variable")

ggplot(counties, aes(x = long, y = lat,
                     group = group,
                     fill = white)) +
  geom_polygon(color = "black") + 
  scale_fill_gradient(low = "white", high = "red")
  

