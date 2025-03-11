FROM rocker/r-ver:4.3.1

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev

RUN install2.r --error \
    tidyverse \
    here \
    rio

WORKDIR /home/rstudio/project

COPY . /home/rstudio/project

CMD ["R"]
