library(tm)
library(dplyr)
library(cluster)
library(factoextra)

source("scripts/utils.R")

ufo_df<-read.csv("derived_data/nuforc_ufo_clean_data.csv", header=TRUE, stringsAsFactors=FALSE)
ufo_df<- ufo_df%>%filter(year==2019)%>%filter(state %in% state.abb)
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(text = strip_strings(text)) %>% 
  ungroup()

# create dataframe grouped by state with concatenated text for each state
text_df<-ufo_df%>%select(state,text)%>%
  group_by(state)%>%
  summarise(text=paste(text,collapse=" "))
  
text_df<-text_df[order(text_df$state),]
states<-text_df%>%pull(state)

tfidf.matrix<-tfidf(text_df$text)
rownames(tfidf.matrix)<-states
df<-as.data.frame(tfidf.matrix)
df <- tibble::rownames_to_column(df, "State")
df <- select(-VALUE)

write_csv(df,"derived_data/ufo_description_tfidf.csv")
