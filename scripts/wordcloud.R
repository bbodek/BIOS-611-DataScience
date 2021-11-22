library(tm)
library(dplyr)
library(wordcloud)
library(RColorBrewer)

source("scripts/utils.R")

df<-read.csv("derived_data/nuforc_ufo_clean_data.csv", header=TRUE, stringsAsFactors=FALSE)
df<-df%>%filter(year==2019)%>%
  sample_n(1000)%>%
  select(text)%>%
  summarise(text=paste(text,collapse=" "))

text<-df$text
corpus <- Corpus(VectorSource(text))
# convert to UTF-8
corpus <- corpus %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) 
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeWords, stopwords("english"))
#corpus <- tm_map(corpus, stemDocument, language = "english")
# build feature matrices
tdm <- TermDocumentMatrix(corpus) 
# convert tdm.tfidf to a matrix
tfidf.matrix <- as.matrix(tdm)
  
words <- sort(rowSums(tfidf.matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)
set.seed(42)
wordcloud(words = df$word,freq = df$freq, 
          min.freq = 20,max.words=200, random.order=FALSE, 
          rot.per=0.35,colors=brewer.pal(8, "Dark2"),scale=c(3.5,0.25))

