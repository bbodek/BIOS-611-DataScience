library(dplyr)
library("ggpubr")
source("scripts/utils.R")

#df<-read.csv("derived_data/nuforc_ufo_clean_data.csv", header=TRUE, stringsAsFactors=FALSE)
cluster_df<-read.csv("derived_data/clusters.csv", header=TRUE, stringsAsFactors = FALSE)
state_df<-read.csv("derived_data/sighting_by_pop_density.csv", header=TRUE)%>%
  filter(year==2019)
# df<- df%>%filter(year==2019)%>%inner_join(cluster_df,by=c("state"="state"))%>%
#   select(state,cluster,text)%>%
#   sample_n(3000)
df<- cluster_df%>%inner_join(state_df,by=c("state"="state"))

# summary<-df%>%group_by(cluster)%>%
#   summarise(
#     count = n(),
#     mean = mean(pop_density, na.rm = TRUE),
#     sd = sd(pop_density, na.rm = TRUE),
#     median = median(pop_density, na.rm = TRUE),
#     IQR = IQR(pop_density, na.rm = TRUE)
#   )
# summary
# 


x <- which(names(df) == "cluster") # name of grouping variable
y <- which(
  names(df) == "pop_density" # names of variables to test
)
method1 <- "kruskal.test"
method2 <- "wilcox.test" 
my_comparisons <- list(c("1", "2"), c("1", "3"), c("1", "4"), 
                       c("2", "5"), c("4", "5"))
png(file="./figures/pop_density_by_cluster.png",
    width=750, height=500)
for (i in y) {
  for (j in x) {
    p <- ggboxplot(df,
                   x = colnames(df[j]), y = colnames(df[i]),
                   color = colnames(df[j]),
                   legend = "none",
                   palette = "npg",
                   add = "jitter",
                   ylab=("Population Density")
    )
    print(
      p + stat_compare_means(aes(label = paste0(..method.., ", p-value = ", ..p.format..)),
                             method = method1, label.y = 1700
      )
      + stat_compare_means(comparisons = my_comparisons, method = method2, label = "p.adj") 
    )
  }
}
dev.off()

# 
# df<-df %>% dplyr::rowwise() %>% 
#   mutate(text = strip_strings(text)) %>% 
#   ungroup()
# 
# # create dataframe grouped by state with concatenated text for each state
# text_df<-df%>%select(cluster,text)%>%
#   group_by(cluster)%>%
#   summarise(text=paste(text,collapse=" "))
# 
# text_df<-text_df[order(text_df$cluster),]
# cluster<-text_df%>%pull(cluster)
# 
# tfidf.matrix<-t(tfidf(text_df$text))
# colnames(tfidf.matrix)<-cluster
# df<-as.data.frame(tfidf.matrix)
# #df <- tibble::rownames_to_column(df, "cluster")
# 
# 
