library(tidyverse)
library(readxl)
library(janitor)
library(broom)

library(rjson)
library(bbplot)
library(ggthemes)
library(maps)
library(leaflet)
library(mapdata)
library(plotly)
library(bbplot)

library(tidyverse)

library(ggthemes)
library(scico)

library(mapproj)

library(tweenr)

library(shiny)
library(shinydashboard)

library(ggplot2)


global_mortality <- read_xlsx("global_mortality (1).xlsx")

life_dat <- read_csv("week14_global_life_expectancy.csv") %>% 
  filter(year == 2015) %>% 
  mutate(country = case_when(
    country == "United States" ~ "United States of America",
    country == "Democratic Republic of Congo" ~ "Democratic Republic of the Congo",
    country == "Congo" ~ "Republic of the Congo",
    country == "Cote d'Ivoire" ~ "Ivory Coast",
    country == "Serbia (including Kosovo)" ~ "Republic of Serbia",
    country == "Tanzania" ~ "United Republic of Tanzania",
    TRUE ~ country
  ))

tidy_mortality <- global_mortality %>% 
  clean_names %>% 
  gather("cause", "percent_mortality", -country, -country_code, -year) %>% 
  mutate(cause = cause %>% str_replace("_percent", ""))

tidy_mortality <- tidy_mortality %>% 
  mutate_if(is.character, as.factor)

big_dat <- left_join(life_dat, tidy_mortality, by=c("code"="country_code", "year"="year"))

mortality_final <- tidy_mortality %>% 
  filter(str_detect(country, "SDI")) %>% 
  select(1,3,4,5)

mortality_final$year <- as.factor(mortality_final$year)



