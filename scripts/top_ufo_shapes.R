library(tidyverse)
library(ggplot2)
library(stringr)
source("scripts/utils.R")

ensure_directory("figures")

ufo_df<-read.csv("derived_data/nuforc_ufo_clean_data.csv", header=TRUE, stringsAsFactors=FALSE)

shapes_in_order<-ufo_df %>% group_by(shape) %>% tally() %>% arrange(desc(n),shape) %>% pull(shape)
n_total <- nrow(ufo_df)
  
p<-ggplot(ufo_df,aes(x=factor(shape,shapes_in_order))) +
  geom_bar(color="black",fill="#00B8E5") +
  theme(axis.text.x = element_text(angle = 90,size=10, vjust = 0.5, hjust=1),
        panel.background = element_rect(fill = "white"),
        #panel.grid.major = element_line(colour="black",size=0.1))+
        panel.grid.major = element_blank())+
  labs(x="UFO Shape", y="Count of Reports")+
  geom_text(aes(label=paste0(round(..count../n_total,2)*100,"%")),stat="count", vjust=-0.25,size=3)

ggsave("figures/top_ufo_shapes.png",plot=p,width=5,height=4)
p
