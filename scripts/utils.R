library(tidyverse);

ensure_directory <- function(directory){
    if(!dir.exists(directory)){
        dir.create(directory);
    }
}

simplify_strings <- function(s){
  s <- str_to_lower(s);
  s <- str_trim(s);
  s
}