library(tm)
library(dplyr)
library(cluster)
library(NbClust)
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
dist.matrix = proxy::dist(tfidf.matrix, method = "cosine")

# see which method has the highest agglomerative coefficient (ac)
m<- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute coefficient
ac <- function(x) {
  agnes(dist.matrix, method = x)$ac
}
# create table of clustering methods and their AC score
cluster_ac<-map_dbl(m, ac)
best_method<-m[which.max(cluster_ac)]

#nb<-NbClust(diss=dist.matrix,method="ward.D",,distance=NULL, min.nc=3,max.nc=20,index="dunn")

clustering.hierarchical <- hclust(dist.matrix, method = best_method)
h.clusters <- cutree(clustering.hierarchical, k = 5)


text_df$clusters<-unname(h.clusters)
text_df%>% group_by(clusters)%>%tally()
plot(clustering.hierarchical, cex = 0.6, hang = -1)
rect.hclust(clustering.hierarchical, k = 5, border = 2:8)

fviz_cluster(list(data = dist.matrix, cluster = h.clusters))
write_csv(text_df,"derived_data/clustered_ufo_descriptions.csv")
