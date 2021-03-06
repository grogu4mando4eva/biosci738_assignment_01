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
  scale_x_discrete(limit = c("2008", "2009", "2010", "2011", "2012"), expand = c(0,0)) +
  scale_y_continuous(
    n.breaks = 7, 
    limits = c(0, 70),
    )
 
## ggplot line graph IMPROVED GRAPH
ggplot2::ggplot(data = calluna_mean, aes(x = Year, y = mean_year_treatment, group = Treatment)) + 
  geom_errorbar(aes(ymin=mean_year_treatment-se, ymax=mean_year_treatment+se, colour = Treatment ), width=.1) +
  geom_line(aes(linetype = Treatment, colour = Treatment)) + 
  theme_minimal() + 
  ggtitle("Percentage Ground Cover of Heather \n by Treatment Type")+
  labs(caption = "Percentage of ground cover of heather based on treatment \n types introduced to Tongariro National Park from 2008-2012. \n B = biocontrol, C = control, H = herbicide, HB = herbicide + biocontrol")+
  geom_point(aes(shape = Treatment, colour = Treatment)) + xlab("Year") + ylab("% Ground Cover") +
  scale_x_discrete(limit = c("2008", "2009", "2010", "2011", "2012"), expand = c(0,0)) +
  scale_y_continuous(
    n.breaks = 7, 
    limits = c(0, 70),
  )
 

## wrangle the data to have only 2008 and 2012 

calluna_8_12 <- calluna_long[!(calluna_long$Year == '2009' |calluna_long$Year == '2010'),]


## subset into B and C dataframes 

calluna_B <- subset(calluna_8_12, Treatment == 'B')
calluna_C <- subset(calluna_8_12, Treatment == 'C')

## randomisation test for Control subset 49 

diff_in_means_C <- (calluna_C %>% group_by(Year)%>% 
  summarise(mean_C = mean(Spread)) %>% 
  summarise(diff = diff(mean_C)))$diff

diff_in_means_C
------------------------------------------------------------------------------------------------------------------------
nreps_49_C <- 49 # number of times I want to randomise

#empty array
randomarray_49_C <- numeric(nreps_49_C)
for (i in 1:nreps_49_C) {
  randomised_49C <- data.frame(value = calluna_C$Spread) ##the obersvations
  
  
  randomised_49C$random_labels <- sample(calluna_C$Year, replace = FALSE) ## randomise labels
  
  randomarray_49_C[i] <- as.list(randomised_49C %>% 
                                   group_by(random_labels)%>% summarise(mean = mean(value)) %>% ## randomised diff in mean
                                   summarise(diff = diff(mean)) )
}

## results
results_49_C <- data.frame(results = c(randomarray_49_C, diff_in_means_C))
results_49_C <- pivot_longer(results_49_C, cols = everything())

## calculate the p value 
n_exceed_49C <- sum(abs(results_49_C$value) >= abs(diff_in_means_C))
n_exceed_49C/nreps_49_C ## this is my p value for 49 reps of randomisation of B

---------------------------------------------------------------------------------------------------------------------------
## randomisation test for Control subset 499 times 

nreps_499_C <- 499 # number of times I want to randomise

#empty array
randomarray_499_C <- numeric(nreps_499_C)
for (i in 1:nreps_499_C) {
  randomised_499C <- data.frame(value = calluna_C$Spread) ##the obersvations
  
  
  randomised_499C$random_labels <- sample(calluna_C$Year, replace = FALSE) ## randomise labels
  
  randomarray_499_C[i] <- as.list(randomised_499C %>% 
                                    group_by(random_labels)%>% summarise(mean = mean(value)) %>% ## randomised diff in mean
                                    summarise(diff = diff(mean)) )
}

## results
results_499_C <- data.frame(results = c(randomarray_49_C, diff_in_means_C))
results_499_C <- pivot_longer(results_499_C, cols = everything())
print(results_499_C$value)

## calculate the p value 
n_exceed_499C <- sum(abs(results_49_C$value) >= abs(diff_in_means_C))
n_exceed_499C/nreps_499_C ## this is my p value for 49 reps of randomisation of B
----------------------------------------------------------------------------------------------------------
## randomisation test for BIOCONTROL subset 49 

diff_in_means_B <- (calluna_B %>% group_by(Year)%>% 
                      summarise(mean_B = mean(Spread)) %>% 
                      summarise(diff = diff(mean_B)))$diff

diff_in_means_B
-------------------------------------------------------------------------------------------------------
nreps_49_B <- 49 # number of times I want to randomise

#empty array
randomarray_49_B <- numeric(nreps_49_B)
for (i in 1:nreps_49_B) {
  randomised_49B <- data.frame(value = calluna_B$Spread) ##the obersvations
  
  
  randomised_49B$random_labels <- sample(calluna_B$Year, replace = FALSE) ## randomise labels
  
  randomarray_49_B[i] <- as.list(randomised_49B %>% 
                                   group_by(random_labels)%>% summarise(mean = mean(value)) %>% ## randomised diff in mean
                                   summarise(diff = diff(mean)) )
}

## results
results_49_B <- data.frame(results = c(randomarray_49_B, diff_in_means_B))
results_49_B <- pivot_longer(results_49_B, cols = everything())

## calculate the p value 
n_exceed_49B <- sum(abs(results_49_B$value) >= abs(diff_in_means_B))
n_exceed_49B/nreps_49_B ## this is my p value for 49 reps of randomisation of B

----------------------------------------------------------------------------------------------------------
## randomisation test for BIOCONTROL subset 499 

nreps_499_B <- 499 # number of times I want to randomise

#empty array
randomarray_499_B <- numeric(nreps_49_B)
for (i in 1:nreps_499_B) {
  randomised_499B <- data.frame(value = calluna_B$Spread) ##the obersvations
  
  
  randomised_499B$random_labels <- sample(calluna_B$Year, replace = FALSE) ## randomise labels
  
  randomarray_499_B[i] <- as.list(randomised_499B %>% 
                                    group_by(random_labels)%>% summarise(mean = mean(value)) %>% ## randomised diff in mean
                                    summarise(diff = diff(mean)) )
}

## results
results_499_B <- data.frame(results = c(randomarray_499_B, diff_in_means_B))
results_499_B <- pivot_longer(results_499_B, cols = everything())

## calculate the p value 
n_exceed_499B <- sum(abs(results_49_B$value) >= abs(diff_in_means_B))
n_exceed_499B/nreps_499_B ## this is my p value for 49 reps of randomisation of B


## PERMUTATION TESTS

#control 
combinations_C <- combn(12,6)
permtest_combn_C <- apply(combinations_C, 2, function(x)
  mean(calluna_C$Spread[x]) - mean(calluna_C$Spread[-x]))
p_val_C <- length(permtest_combn_C[abs(permtest_combn_C) >= diff_in_means_C]) / choose(12,6)
p_val_C

#biocontrol
combinations_B <- combn(12,6)
permtest_combn_B <- apply(combinations_B, 2, function(x)
  mean(calluna_B$Spread[x]) - mean(calluna_B$Spread[-x]))
p_val_B <- length(permtest_combn_B[abs(permtest_combn_B) >= abs(diff_in_means_B)]) / choose(12,6)
p_val_B

## HISTOGRAM

hist(permtest_combn_C,
  xlab='Differences Between Randomised Group Means',
  main='Permutation Test (Control)')
abline(v = diff_in_means_C, col = "red")


hist(permtest_combn_B,
     xlab='Differences Between Randomised Group Means',
     main='Permutation Test (Biocontrol)')
abline(v = diff_in_means_B, col = "red")
