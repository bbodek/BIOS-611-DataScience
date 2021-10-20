library(tidyverse)
source("scripts/utils.R")

ensure_directory("source_data")
df <- read.csv("https://query.data.world/s/2ylyphak7xhl553wrxb54jmlwcbixq", header=TRUE, stringsAsFactors=FALSE)
write_csv(df,"source_data/nuforc_ufo_data.csv")
