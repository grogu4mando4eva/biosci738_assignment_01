#load dataset into R
require(tidyverse)
require(dplyr)
require(scales)
library(readr)
url <- "https://raw.githubusercontent.com/STATS-UOA/databunker/master/data/dicots_proportions.csv"
data <- read_csv(url)

#extract the calluna data from the dataset
callunavulgaris_data <- data %>% select(starts_with("Calluna"), `Treat!`)

#save dataframe in project folder
save(callunavulgaris_data, file = "callunavulgaris_data.RData")

# pivot long rather than wide 
calluna_long <- pivot_longer(callunavulgaris_data, 
                            cols = starts_with("Calluna"), 
                                     names_to = "Year", values_to = "Spread")

## rename columns to match the dataset 
names(calluna_long)[1] <- 'Treatment'

#find the index (place in the column) where the "Year" column ends with "08"
index_08 <- which(endsWith(calluna_long$Year,"08"))
print(index_08)

#for every index in the "Year" column. Change it to "2008"
for (index in index_08){
  calluna_long$Year[index] <- "2008"
}

#find the index (place in the column) where the "Year" column ends with "09"
index_09 <- which(endsWith(calluna_long$Year,"09"))
print(index_09)

#for every index in the "Year" column. Change it to "2009"
for (index in index_09){
  calluna_long$Year[index] <- "2009"
}


#find the index (place in the column) where the "Year" column ends with "10"
index_10 <- which(endsWith(calluna_long$Year,"10"))
print(index_10)

#for every index in the "Year" column. Change it to "2010"
for (index in index_10){
  calluna_long$Year[index] <- "2010"
}


#find the index (place in the column) where the "Year" column ends with "12"
index_12 <- which(endsWith(calluna_long$Year,"12"))
print(index_12)

#for every index in the "Year" column. Change it to "2012"
for (index in index_12){
  calluna_long$Year[index] <- "2012"
}


# # for every numeric value in the "Spread" column, multiply by 100
# x100 <- function(x){x * 100}
# mutate_each(calluna_long$Spread, function(x100), names(which(calluna_long$Spread)))

