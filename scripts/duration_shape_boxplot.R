library(tidyverse)
library(ggplot2)
library(ggpubr)
source("scripts/utils.R")

ensure_directory("figures")

ufo_df<-read.csv("derived_data/nuforc_ufo_clean_data.csv", header=TRUE, stringsAsFactors=FALSE)
# select top 5 most common shapes
shapes_in_order<-ufo_df %>% group_by(shape) %>% tally() %>% arrange(desc(n),shape) %>% head(5) %>% pull(shape)

pct_99<-quantile(ufo_df%>%filter(!is.na(duration_seconds))%>%pull(duration_seconds),probs=.99)

df<-ufo_df%>%
  filter(shape %in% shapes_in_order)%>%
  filter(!is.na(duration_seconds))%>%
  filter(duration_seconds<=pct_99)


p<-ggplot(df,aes(y=shape,x=duration_seconds,fill=shape)) +
  geom_boxplot(outlier.shape=NA)+
  coord_cartesian(xlim = c(0, 1500)) +
  labs(y="UFO Shape", x="Duration of Sighting (seconds)")

ggsave("figures/shape_duration_boxplot.png",plot=p)
p
