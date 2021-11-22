library(tm)
library(dplyr)
library(cluster)
library(factoextra)

source("scripts/utils.R")

df<-read.csv("derived_data/ufo_description_tfidf.csv", header=TRUE, stringsAsFactors=FALSE)
tfidf.matrix<-as.matrix(df[,-1])
rownames(tfidf.matrix)<-df[,1]
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
# choose the 'best' method, and use for final clustering
best_method<-m[which.max(cluster_ac)]
clustering.hierarchical <- hclust(dist.matrix, method = best_method)

#select number of clusters
h.clusters <- cutree(clustering.hierarchical, k = 5)

# plot dendrogram
png(file="./figures/state_dendogram.png",
    width=1000, height=500)
  plot(clustering.hierarchical, cex = 0.7, hang = -1)
  rect.hclust(clustering.hierarchical, k = 5, border = 2:8)
dev.off()

# plot clusters (with pca)
png(file="./figures/state_clusters.png",
    width=750, height=500)
  fviz_cluster(list(data = dist.matrix, cluster = h.clusters))
  dev.off()