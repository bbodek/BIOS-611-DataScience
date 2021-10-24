library(tidyverse)
source("scripts/utils.R")

ensure_directory("derived_data")

ufo_df <- read.csv("./source_data/nuforc_ufo_data.csv", header=TRUE, stringsAsFactors=FALSE,skipNul = TRUE)

#extract year from ufo report date time field
ufo_df$year<-substr(ufo_df$date_time,1,4)

################################
#### clean "duration" field ####
################################

# convert spelled out numbers (such as five) to numeric 
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(format_duration = strip_strings(duration)) %>% 
  mutate(format_duration = simplify_strings(duration)) %>%
  mutate(format_duration=word2num(format_duration)) %>% ungroup()

# extract hours, seconds, and minutes from duration 
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(duration_sec = as.integer(strsplit(str_match(format_duration,"([0-9]*)\\s?(?:sec|s)")[2]," ")[[1]][1])) %>% ungroup()
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(duration_hr = as.integer(strsplit(str_match(format_duration,"([0-9]*)\\s?(?:hour|hr)")[2]," ")[[1]][1])) %>% ungroup()
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(duration_min = as.integer(strsplit(str_match(format_duration,"([0-9]*)\\+?\\s?min")[2]," ")[[1]][1])) %>% ungroup()

# create fields for duration in minutes, hours, and seconds
ufo_df <- ufo_df %>% replace_na(list(duration_sec=0,duration_hr=0,duration_min=0))
ufo_df<- ufo_df %>% 
  mutate(duration_minutes = round(duration_sec/60 + duration_min + duration_hr*60)) %>% 
  mutate(duration_hours = round(duration_sec/3600 + duration_min/60 + duration_hr,1)) %>% 
  mutate(duration_seconds = round(duration_sec + duration_min*60 + duration_hr*3600,1)) %>% 
  mutate(duration_minutes = ifelse(duration_minutes==0 & duration_hours==0 & duration_seconds == 0, NA, duration_minutes))%>%
  mutate(duration_seconds = ifelse(duration_minutes==0 & duration_hours==0 & duration_seconds == 0, NA, duration_seconds))%>%
  mutate(duration_hours = ifelse(duration_minutes==0 & duration_hours==0 & duration_seconds == 0, NA, duration_hours))%>%
  select(-duration_sec,-duration_min,-duration_hr,-format_duration)

################################
##### clean "shape" field ######
################################

ufo_df <- ufo_df %>% mutate(shape = simplify_strings(shape)) %>% mutate(shape = ifelse(is.na(shape)==1|shape=='','unknown',shape))

write_csv(ufo_df,"derived_data/nuforc_ufo_clean_data.csv")