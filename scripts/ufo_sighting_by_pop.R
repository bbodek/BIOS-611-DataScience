library(tidyverse)
library(ggplot2)
source("scripts/utils.R")

df<-read.csv("./derived_data/nuforc_ufo_clean_data.csv")
state_df<-read.csv("./source_data/census_est_pop.csv")

# create tidy dataframe of state and population data from census population estimates
tidy_state <- state_df%>%
  pivot_longer(
    cols = starts_with("X"), 
    names_to = "year", 
    values_to = "population", 
    names_prefix = "year_")%>%
  mutate(year=substring(year, 2))%>%
  mutate(year=as.integer(year))%>%
  mutate(state=substring(region,2))%>%
  mutate(state=state.abb[match(state,state.name)])%>%
  mutate(population=strip_strings(population))%>%
  mutate(population=as.integer(population))

# create dataframe of the number of ufo sightings by state and year
sighting_df<-df%>%
  group_by(state,year)%>%
  tally()%>%
  filter(is.na(state) == FALSE)%>%
  filter(state!="")%>%
  rename(sightings=n)%>%
  mutate(year=as.integer(year))

sighting_pop_df<-inner_join(sighting_df,tidy_state,by = c("state" = "state", "year"="year"))%>%
  mutate(sightings_per_100k = 100000*sightings/population)%>%arrange(sightings_per_100k,asc=FALSE)

write_csv(sighting_pop_df,"./derived_data/sighting_by_population.csv")                        