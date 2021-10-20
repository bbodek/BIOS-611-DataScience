FROM rocker/verse 
RUN apt update && apt-get install -y emacs openssh-server python3-pip
RUN pip3 install --pre --user hy
RUN pip3 install tensorflow sklearn pandas numpy pandasql 
RUN R -e "install.packages(\"reticulate\")"
RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"ggplot2\")"
RUN R -e "install.packages(\"shiny\")"
RUN R -e "install.packages(\"leaflet\")"