#load dataset into R
require(tidyverse)
require(dplyr)
library(readr)
url <- "https://raw.githubusercontent.com/STATS-UOA/databunker/master/data/dicots_proportions.csv"
data <- read_csv(url)

#extract the calluna data from the dataset
callunavulgaris_data <- data %>% select(starts_with("Calluna"), `Treat!`)

#save dataframe in project folder
save(callunavulgaris_data, file = "callunavulgaris_data.RData")

## rename columns to match the dataset 
names(callunavulgaris_data)[1] <- '2008'
names(callunavulgaris_data)[2] <- '2009'
names(callunavulgaris_data)[3] <- '2010'
names(callunavulgaris_data)[4] <- '2012'
names(callunavulgaris_data)[5] <- 'Treatment'

#extrapolating the data sets based on treatment type
callunavulgaris_treatment_B <- subset(callunavulgaris_data, Treatment=="B")
callunavulgaris_treatment_C <- subset(callunavulgaris_data, Treatment=="C")
callunavulgaris_treatment_HB <- subset(callunavulgaris_data, Treatment=="HB")
callunavulgaris_treatment_H <- subset(callunavulgaris_data, Treatment=="H")
