library(tidyverse)

gold <- read.csv('data/Gold_Historical.csv', skip = 9, header = TRUE)
silver <- read.csv('data/Silver_Historical.csv', skip = 9, header = TRUE)

full <- left_join(gold, silver, by = 'date', suffix = c('_gd','_sv'), keep = FALSE)

par(mfrow=c(2,2))  






