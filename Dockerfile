FROM rocker/verse 
RUN apt update && apt-get install -y emacs\
	openssh-server\
  ne\
  sqlite3\
	texlive-base\
	texlive-binaries\
  texlive-latex-base\
	texlive-latex-recommended\
	texlive-pictures\
  texlive-latex-extra\
	python3-pip
RUN adduser rstudio sudo
RUN pip3 install --pre --user hy
RUN pip3 install tensorflow sklearn pandas numpy pandasql 
RUN R -e "install.packages(c('ggpmisc','NbClust','wordcloud','RColorBrewer','factoextra','reticulate','stringr',tidyverse','ggplot2','tm','SnowballC','shiny','leaflet','leaflet.extras','shinyWidgets','ggpubr','tinytex'))"


