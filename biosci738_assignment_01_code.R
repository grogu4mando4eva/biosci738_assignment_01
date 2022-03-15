#load dataset into R
require(tidyverse)
library(readr)
url <- "https://raw.githubusercontent.com/STATS-UOA/databunker/master/data/dicots_proportions.csv"
data <- read_csv(url)
