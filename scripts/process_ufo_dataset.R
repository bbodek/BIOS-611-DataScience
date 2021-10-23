library(tidyverse)
source("scripts/utils.R")

ensure_directory("derived_data")

df <- read.csv("./source_data/nuforc_ufo_data.csv", header=TRUE, stringsAsFactors=FALSE)

#extract year from ufo report date time field
ufo_df$year<-format(ufo_df$date_time, format="%Y")

#### clean "duration" field
# convert spelled out numbers (such as five) to numeric 
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(format_duration = strip_strings(duration)) %>% mutate(format_duration=word2num(format_duration)) %>% ungroup()

# extract hours, seconds, and minutes from duration 
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(duration_sec = strsplit(str_match(duration,"([0-9]*)\\s?sec")[2]," ")[[1]][1]) %>% ungroup()
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(duration_hr = strsplit(str_match(duration,"([0-9]*)\\s?(hour|hr)")[2]," ")[[1]][1]) %>% ungroup()
ufo_df<-ufo_df %>% dplyr::rowwise() %>% 
  mutate(duration_min = strsplit(str_match(duration,"([0-9]*)\\s?min")[2]," ")[[1]][1]) %>% ungroup()

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

write_csv(df,"derived_data/nuforc_ufo_clean_data.csv")