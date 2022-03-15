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

