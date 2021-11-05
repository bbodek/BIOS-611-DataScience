library(tidyverse)
library(ggplot2)
source("scripts/utils.R")

df<-read.csv("./derived_data/nuforc_ufo_clean_data.csv")
state_df<-read.csv("./source_data/census_est_pop.csv")

tidy_state <- state_df%>%
  pivot_longer(
    cols = starts_with("X"), 
    names_to = "year", 
    values_to = "population", 
    names_prefix = "year_")%>%
  mutate(year=substring(year, 2))

