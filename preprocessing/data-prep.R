#-------------------------------------
# This script sets out to clean the
# data ready for analysis
#
# NOTE: This script requires setup.R
# to have been run first
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 9 June 2020
#-------------------------------------

# Read in and prep data

d <- read_excel("raw-data/population_data.xlsx")

three_level <- d %>%
  mutate(grouped_ra = case_when(
    ra_name_2016 == "Major Cities of Australia" ~ "Major City postcodes",
    grepl("Regional", ra_name_2016)             ~ "Regional postcodes",
    grepl("Remote", ra_name_2016)               ~ "Remote postcodes")) %>%
  mutate(prop_dwellings_internet_accessed = prop_dwellings_internet_accessed * 100)

two_level <- d %>%
  mutate(grouped_ra = case_when(
    ra_name_2016 == "Major Cities of Australia" ~ "Major City postcodes",
    TRUE                                        ~ "Not Major City")) %>%
  mutate(prop_dwellings_internet_accessed = prop_dwellings_internet_accessed * 100)

#-------------
# Export data
#-------------

# Create a data folder if none exists:

if(!dir.exists('data')) dir.create('data')

write_xlsx(three_level, "data/three_level.xlsx")
write_xlsx(two_level, "data/two_level.xlsx")
