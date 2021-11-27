library(ggpmisc)
library(tidyverse)
library(ggplot2)

df<-read_csv("./derived_data/sighting_by_pop_density.csv")

df<-df%>%group_by(year,Region)%>%summarize(sightings=sum(sightings),sightings_per_100k=sum(sightings)*100000/sum(population))
# Line plot with multiple groups
p1<-ggplot(data=df, aes(x=year, y=sightings, group=Region)) +
  geom_line(aes(color=Region))+
  geom_point()+
  scale_x_continuous(breaks=(2010:2019))+
  ylab("Sightings")

# Line plot with multiple groups
p2<-ggplot(data=df, aes(x=year, y=sightings_per_100k, group=Region)) +
  geom_line(aes(color=Region))+
  geom_point()+
  scale_x_continuous(breaks=(2010:2019))+
  ylab("Sightings Per 100k population")

multi.page <- ggarrange(p1, p2,
                        nrow = 2, ncol = 1)
png(file="./figures/sightings_by_time.png",width=5,height=5,units="in",res=350)
multi.page
dev.off()
