
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
companies$permalink <- str_to_lower(companies$permalink,locale = "en")
count_companies_in_companies <- n_distinct(as.data.frame(companies$permalink))





# Any companies in the rounds2 file which are not present in companies
# anti_join will find those rows in distinct rounds2$company_permalink which are not present in distinct companies$permalink
# if there are any such companies, they will be saved in the variable missing_from_companies
missing_from_companies <- anti_join(distinct(rounds2,company_permalink) , distinct(companies,permalink), by = c("company_permalink" = "permalink") )




# Merge the two data frames so that all variables (columns) in the companies frame are added to the rounds2 data frame. Name the merged frame master_frame.
master_frame <- left_join(rounds2,companies,by = c("company_permalink" = "permalink"))




#============ GOAL 1 : Investment type analysis ===================


# Checkpoint 2: Funding Type Analysis

# Calculate the average investment amount for each of the four funding types (venture, angel, seed, and private equity)

funding_rounds <- filter(master_frame,funding_round_type %in% c("seed","venture","angel","private_equity"))
funding_rounds_spread <- spread(funding_rounds,funding_round_type,raised_amount_usd)
summarise(funding_rounds_spread,avg_seed = mean(seed,na.rm = T),avg_venture = mean(venture,na.rm = T),avg_angel = mean(angel,na.rm = T),avg_private_equity = mean(private_equity,na.rm = T))



# Alternate solutions
# Average Seed Fund
mean(master_frame$raised_amount_usd[which(master_frame$funding_round_type == "seed")],na.rm = T)
# Average Venture Fund
mean(master_frame$raised_amount_usd[which(master_frame$funding_round_type == "venture")],na.rm = T)
# Average Angel Fund
mean(master_frame$raised_amount_usd[which(master_frame$funding_round_type == "angel")],na.rm = T)
# Average Private Equity Fund
mean(master_frame$raised_amount_usd[which(master_frame$funding_round_type == "private_equity")],na.rm = T)





#============ GOAL 2 : Country analysis ===========================


# Checkpoint 3: Country Analysis



# Filter by chosen investment type
filter_by_inv_type <- filter(master_frame,funding_round_type == "venture")

# Group by country code
group_by_country <- group_by(filter_by_inv_type,country_code)

# Find sum of investment based on country code
total_investment_by_country <- summarise(group_by_country,Total_Investment = sum(raised_amount_usd,na.rm = T))


# For the chosen investment type, make a data frame named top9 with the top nine countries (based on the total investment amount each country has received)
# Also cleanup Blank Country Code
top_9 <- arrange(total_investment_by_country[which(total_investment_by_country$country_code != ""),],desc(Total_Investment))[1:9,]

