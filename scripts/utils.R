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

word2num <- function(word){
  wsplit <- strsplit(tolower(word)," ")[[1]]
  one_digits <- list(zero=0, one=1, two=2, three=3, four=4, five=5,
                     six=6, seven=7, eight=8, nine=9)
  teens <- list(eleven=11, twelve=12, thirteen=13, fourteen=14, fifteen=15,
                sixteen=16, seventeen=17, eighteen=18, nineteen=19)
  ten_digits <- list(ten=10, twenty=20, thirty=30, forty=40, fifty=50,
                     sixty=60, seventy=70, eighty=80, ninety=90)
  string=c()
  i<-1
  while(i<= length(wsplit)){
    if(wsplit[i] %in% names(one_digits)){
      temp <- as.numeric(one_digits[wsplit[i]])
    }
    else if (wsplit[i] %in% names(teens)){
      temp <- as.numeric(teens[wsplit[i]])
    }
    else if(wsplit[i] %in% names(ten_digits)){
      if (wsplit[i+1] %in% names(one_digits)){
        temp <- (as.numeric(ten_digits[wsplit[i]]))+(as.numeric(one_digits[wsplit[i+1]]))
        i<-i+1
      }
      else {temp <- (as.numeric(ten_digits[wsplit[i]]))
      }
    }
    else {temp<-wsplit[i]
    }
    string<-c(string,temp)
    i<-1+i
  }
  paste(string, collapse = ' ')
}