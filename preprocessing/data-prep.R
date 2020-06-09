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

two_level_factored <- two_level %>%
  mutate(grouped_ra = case_when(
    grouped_ra == "Major City postcodes" ~ 1,
    TRUE                                 ~ 0)) %>%
  mutate(grouped_ra = as.factor(grouped_ra)) %>%
  dplyr::select(c(usual_resident_population, prop_dwellings_internet_accessed, grouped_ra)) %>%
  mutate(usual_resident_population = log10(usual_resident_population))

#-------------
# Export data
#-------------

# Create a data folder if none exists:

if(!dir.exists('data')) dir.create('data')

write_xlsx(three_level, "data/three_level.xlsx")
write_xlsx(two_level, "data/two_level.xlsx")
write_xlsx(two_level_factored, "data/two_level_factored.xlsx")
