library(tidyverse);

ensure_directory <- function(directory){
    if(!dir.exist(directory)){
        dir.create(directory);
    }
}

