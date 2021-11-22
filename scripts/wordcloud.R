library(tm)
library(dplyr)
library(wordcloud)
library(RColorBrewer)

source("scripts/utils.R")

df<-read.csv("derived_data/clustered_ufo_descriptions.csv", header=TRUE, stringsAsFactors=FALSE)
df<-df%>%summarise(text=paste(text,collapse=" "))

#df<-df%>%group_by(clusters)%>%summarise(text=paste(text,collapse=" "))
#text_df<-text_df[order(text_df$state),]
tfidf.matrix<-tfidf(cluster1$text)
#states<-text_df%>%pull(state)
#rownames(tfidf.matrix)<-states
text<-cluster1$text
corpus <- tm::Corpus(tm::VectorSource(text))
# convert to UTF-8
corpus <- corpus %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) 

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeWords, stopwords("english"))
#corpus <- tm_map(corpus, stemDocument, language = "english")
# build feature matrices
tdm <- tm::TermDocumentMatrix(corpus) 
# convert tdm.tfidf to a matrix
tfidf.matrix <- as.matrix(tdm)
  
words <- sort(rowSums(tfidf.matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)
set.seed(42)
wordcloud(words = df$word,freq = df$freq, 
          min.freq = 1,max.words=200, random.order=FALSE, 
          rot.per=0.35,colors=brewer.pal(8, "Dark2"))

