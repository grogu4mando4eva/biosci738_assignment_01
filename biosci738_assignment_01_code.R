#load dataset into R
require(tidyverse)
require(dplyr)
require(scales)
library(readr)
install.packages("plotrix")
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

# wrangle the spread into percentage format
calluna_long <- calluna_long %>% 
  select(Treatment, Year, Spread)%>%
  mutate(     
    Spread = Spread * 100)

# find the mean and sd/se for the treatment type and year 
calluna_mean <- calluna_long %>% 
  group_by(Treatment, Year) %>% 
  summarise(., mean_year_treatment = mean(Spread), sd = sd(Spread), n = n(), se = sd / sqrt(n))
calluna_mean$mean_year_treatment = as.numeric(calluna_mean$mean_year_treatment)

## ggplot line graph 
ggplot2::ggplot(data = calluna_mean, aes(x = Year, y = mean_year_treatment, group = Treatment)) + 
  geom_errorbar(aes(ymin=mean_year_treatment-se, ymax=mean_year_treatment+se ), width=.1) +
  geom_line(aes(linetype = Treatment)) + 
  geom_point(aes(shape = Treatment)) + xlab("Year") + ylab("Percentage Cover") +
  scale_x_discrete(limit = c("2008", "2009", "2010", "2011", "2012")) +
  scale_y_continuous(
    n.breaks = 7, 
    limits = NULL,
    )
  
