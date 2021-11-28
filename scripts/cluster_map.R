library(tidyverse)
library(ggplot2)
library(maps)

df<-read_csv("./derived_data/clusters.csv")
MainStates <- map_data("state")
states<-data.frame("state_name"=tolower(state.name),"state_abb" = state.abb)

df<-df%>%inner_join(states, by=c("state"="state_abb"))%>%inner_join(MainStates, by=c("state_name"="region"))

ggplot() + 
  geom_polygon( data=df, aes(x=long, y=lat, group=group,fill=as.character(cluster)),
                color="black") + labs(fill = "Cluster") 

