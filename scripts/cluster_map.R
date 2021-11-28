library(tidyverse)
library(ggplot2)
library(maps)

df<-read_csv("./derived_data/clusters.csv")
MainStates <- map_data("state")
states<-data.frame("state_name"=tolower(state.name),"state_abb" = state.abb)

df<-df%>%inner_join(states, by=c("state"="state_abb"))%>%inner_join(MainStates, by=c("state_name"="region"))

png(file="./figures/cluster_map.png",width=7,height=4,units="in",res=350)
ggplot() + 
  geom_polygon( data=df, aes(x=long, y=lat, group=group,fill=as.character(cluster)),
                color="black") + labs(fill = "Cluster",x="",y="") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        rect = element_blank())

dev.off()