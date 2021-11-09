library(ggpmisc)
library(tidyverse)
library(ggplot)

df<-read_csv("./derived_data/sighting_by_population.csv")
df<-df%>%
  filter(year>=2015)%>%
  group_by(state)%>%
  summarize(sighting_per_100k_peopleyears=100000*sum(sightings)/sum(population),avg_pop=round(mean(population)))

ggplot(df, aes(x=avg_pop, y=sighting_per_100k_peopleyears)) +
         geom_point()+
         geom_text(aes(label=state),nudge_x=0.5, nudge_y=0.1,check_overlap=TRUE,size=2.5) +
         geom_smooth(method="lm", se=TRUE,formula="y~log(x)",color='black') +
         stat_fit_glance(method = 'lm', method.args=list(formula=y~log(x)),geom = 'text', 
                         mapping = aes(label = sprintf('R^2~"="~%.3f~~italic(P)~"="~%.2g',
                                                       stat(r.squared), stat(p.value))),
                                       parse=TRUE,label.x=30000000,label.y = 4,
                                       color="red")+
         scale_x_continuous(labels = scales::comma)+
         xlab("Average State Population (per year, 2010-2019)")+
         ylab("UFO Sightings per 100k People Years")
