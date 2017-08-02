
#Clear all variables
rm(list=ls())


# CHECKPOINT 1: Data Cleaning 1

# Load the companies and rounds data
companies <- read.delim("companies.txt",stringsAsFactors = F)
rounds2 <- read.csv("rounds2.csv",stringsAsFactors = F)



# Loading libraries stringr, tidyr and dplyr
library(stringr)
library(dplyr)
library(tidyr)



# How many unique companies are present in rounds2?
# converting permalink to lower case for uniformity
rounds2$company_permalink <- str_to_lower(rounds2$company_permalink,locale = "en")
count_companies_in_rounds2 <- n_distinct(as.data.frame(rounds2$company_permalink))



# How many unique companies are present in the companies file?
# converting permalink to lower case for uniformity
